/*

This script works with `sales` database that was created by launching (in Oracle SQL Developer) seven previous scripts:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-2_fixed_DDL_script_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-3_add_constraints_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01a_en_sequences.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01b_en_data_cleaning__surrogate_keys.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01c_en_cascade_updates.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-02a_en_triggers__invoices.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-02b_en_triggers__invoice_details.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-02c_en_triggers__receipts__receipt_details.sql


See also the `sales` database schema and denormalized attributes in presentation:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-02_en_Triggers%20-%20part%202.pptx

*/


--==========================================================================================
--     Starting with the month succeeding the month with the last receipt, 
--    generate, for each customer, monthly receipts 
--    (in the last day of the month) which pay all the remaining unpaid invoices 
--          from previous months and the current month  
-- at the moment, there is no invoice cancellation or refusal           
--==========================================================================================


--==========================================================================================

CREATE OR REPLACE PROCEDURE p_automatic_receipts
IS
    v_last_receipt_date receipts.receipt_date%TYPE ;
    v_first_month months.month%TYPE ;
    v_last_day receipts.receipt_date%TYPE ;
    v_receipt_id receipts.receipt_id%TYPE ;
BEGIN 
    SELECT MAX(receipt_date) INTO v_last_receipt_date FROM receipts ;
    
    FOR i_year IN EXTRACT (YEAR FROM v_last_receipt_date)..EXTRACT (YEAR FROM current_date)  LOOP
        IF i_year = EXTRACT (YEAR FROM v_last_receipt_date) THEN
            v_first_month := EXTRACT (MONTH FROM v_last_receipt_date) ;
        ELSE
            v_first_month := 1 ;
        END IF ;        
    
        FOR i_month IN v_first_month..12  LOOP
        
            v_last_day := LAST_DAY(TO_DATE(i_year || '-' || i_month || '-01', 'yyyy-mm-dd')) ;
            
            -- scan the customers
            FOR rec_cust IN (SELECT * FROM customers) LOOP
                
                v_receipt_id := NULL ;
            
                -- scan all the customer invoices
                FOR rec_invoice IN (SELECT * FROM invoices 
                		WHERE cust_id = rec_cust.cust_id
                    AND invoice_date <= v_last_day AND 
                    	invoice_amount > amount_received) LOOP
                    
                    -- if "v_receipt_id" IS NULL one must insert a record in "receipts"
                    IF v_receipt_id IS NULL THEN
                        INSERT INTO receipts (receipt_date, receipt_docum_type, 
                                receipt_docum_number,receipt_docum_date) 
                            VALUES (v_last_day, 'OP', '111', 
                            		v_last_day - dbms_random.value(0,10) )
                            RETURNING receipt_id INTO v_receipt_id ;
                        
                        -- change the document number according to "receipt_id"
                        UPDATE receipts 
                        SET receipt_docum_number = v_receipt_id || ''
                        WHERE receipt_id = v_receipt_id ;
                    END IF ;
                    
                    -- now insert a record in "receipt_details" for the current unpaid invoice
                    INSERT INTO  receipt_details (receipt_id, invoice_id, amount)
                            VALUES (v_receipt_id, rec_invoice.invoice_id, 
                               rec_invoice.invoice_amount - rec_invoice.amount_received  ) ;          
        
                END LOOP ;   
            END LOOP ;
        END LOOP ; 
    END LOOP;             
END ;
/


--==========================================================================================
--                          test the procedure
--==========================================================================================


---------------------------------------------------------------
--   data synchronization before the procedure...
----------------------------------------------------------------

-- check synchronization "invoices"-"invoice_details"-"receipt_details"
WITH check_invoices AS
    (SELECT i.invoice_id, i.invoice_number, i.invoice_date, i.invoice_amount, 
        (SELECT COALESCE(SUM(quantity * unit_price + row_vat), 0) 
            FROM invoice_details WHERE invoice_id = i.invoice_id) AS checked_amount ,
        i.amount_received, 
        (SELECT COALESCE(SUM(amount), 0) 
            FROM receipt_details WHERE invoice_id = i.invoice_id) AS checked_received
    FROM invoices i    )
SELECT c_i.*, 
  CASE WHEN invoice_amount <> checked_amount OR amount_received <> checked_received 
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_invoices c_i   
ORDER BY 1 ;
         
-- check if the current balance account for each customer is correct
WITH check_cust AS (
    SELECT c.cust_id, cust_name, current_balance, 
        (SELECT COALESCE(SUM(invoice_amount),0) AS sales FROM invoices WHERE cust_id = c.cust_id) AS sales,
        (SELECT COALESCE(SUM(amount),0) FROM receipt_details rd INNER JOIN
                        invoices i ON rd.invoice_id = i.invoice_id   
                WHERE cust_id = c.cust_id) AS paid,
    (SELECT COALESCE(SUM(invoice_amount),0) AS sales FROM invoices WHERE cust_id = c.cust_id) -
        (SELECT COALESCE(SUM(amount),0) FROM receipt_details rd INNER JOIN
                        invoices i ON rd.invoice_id = i.invoice_id   
                WHERE cust_id = c.cust_id) AS diff
    FROM customers c) 
SELECT c_c.*, 
  CASE WHEN current_balance <> diff
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_cust c_c   
ORDER BY 1 ;


-- check the values in table "months"
WITH check_months AS (
    SELECT m.year, m.month, sales_total, 
        (SELECT COALESCE(SUM(invoice_amount),0) 
        FROM invoices 
        WHERE EXTRACT (YEAR FROM invoice_date) = m.year AND
            EXTRACT (MONTH FROM invoice_date) = m.month) AS sales_checked,
        received_total,
        (SELECT COALESCE(SUM(amount),0) FROM receipt_details 
        WHERE EXTRACT (YEAR FROM receipt_date) = m.year AND
            EXTRACT (MONTH FROM receipt_date) = m.month) AS received_checked
    FROM months m)
SELECT c_m.*, 
  CASE WHEN sales_total <> sales_checked OR received_total <> received_checked 
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_months c_m 
ORDER BY 1, 2, 3;  
     

-- check the values in table "customer_monthly_stats"
WITH check_c_m_s AS (
    SELECT c_m_s.year, c_m_s.month, cust_id, sales, 
        (SELECT COALESCE(SUM(invoice_amount),0) 
        FROM invoices 
        WHERE EXTRACT (YEAR FROM invoice_date) = c_m_s.year AND
            EXTRACT (MONTH FROM invoice_date) = c_m_s.month AND
            cust_id = c_m_s.cust_id) AS sales_checked,
        received,
        (SELECT COALESCE(SUM(amount),0) FROM receipt_details r_d
            INNER JOIN invoices i ON r_d.invoice_id = i.invoice_id
        WHERE EXTRACT (YEAR FROM receipt_date) = c_m_s.year AND
            EXTRACT (MONTH FROM receipt_date) = c_m_s.month AND
            cust_id = c_m_s.cust_id) AS received_checked
    FROM customer_monthly_stats c_m_s)
SELECT c_c_m_s.*, 
  CASE WHEN sales <> sales_checked OR received <> received_checked 
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_c_m_s c_c_m_s  
ORDER BY 1, 2, 3 ;
     

-- check the values in table "product_monthly_stats"
WITH check_p_m_s AS (
    SELECT p_m_s.year, p_m_s.month, product_id, sales, 
        (SELECT COALESCE(SUM(quantity * unit_price + row_vat), 0) 
            FROM invoices i INNER JOIN invoice_details i_d ON i.invoice_id = i_d.invoice_id 
            WHERE 
                EXTRACT (YEAR FROM invoice_date) = p_m_s.year AND
                EXTRACT (MONTH FROM invoice_date) = p_m_s.month AND
                product_id = p_m_s.product_id) AS sales_checked
    FROM product_monthly_stats p_m_s)
SELECT c_p_m_s.*, 
  CASE WHEN sales <> sales_checked 
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_p_m_s c_p_m_s   
ORDER BY 1, 2, 3;  



----------------------------------------------------------------------------------------
                        -- call the procedure
----------------------------------------------------------------------------------------
BEGIN
    p_automatic_receipts ;
END ;
/    

---------------------------------------------------------------
--   data synchronization after the procedure call
----------------------------------------------------------------

-- check synchronization "invoices"-"invoice_details"-"receipt_details"
WITH check_invoices AS
    (SELECT i.invoice_id, i.invoice_number, i.invoice_date, i.invoice_amount, 
        (SELECT COALESCE(SUM(quantity * unit_price + row_vat), 0) 
            FROM invoice_details WHERE invoice_id = i.invoice_id) AS checked_amount ,
        i.amount_received, 
        (SELECT COALESCE(SUM(amount), 0) 
            FROM receipt_details WHERE invoice_id = i.invoice_id) AS checked_received
    FROM invoices i    )
SELECT c_i.*, 
  CASE WHEN invoice_amount <> checked_amount OR amount_received <> checked_received 
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_invoices c_i   
ORDER BY 1 ;
         
-- check if the current balance account for each customer is correct
WITH check_cust AS (
    SELECT c.cust_id, cust_name, current_balance, 
        (SELECT COALESCE(SUM(invoice_amount),0) AS sales FROM invoices WHERE cust_id = c.cust_id) AS sales,
        (SELECT COALESCE(SUM(amount),0) FROM receipt_details rd INNER JOIN
                        invoices i ON rd.invoice_id = i.invoice_id   
                WHERE cust_id = c.cust_id) AS paid,
    (SELECT COALESCE(SUM(invoice_amount),0) AS sales FROM invoices WHERE cust_id = c.cust_id) -
        (SELECT COALESCE(SUM(amount),0) FROM receipt_details rd INNER JOIN
                        invoices i ON rd.invoice_id = i.invoice_id   
                WHERE cust_id = c.cust_id) AS diff
    FROM customers c) 
SELECT c_c.*, 
  CASE WHEN current_balance <> diff
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_cust c_c   
ORDER BY 1 ;


-- check the values in table "months"
WITH check_months AS (
    SELECT m.year, m.month, sales_total, 
        (SELECT COALESCE(SUM(invoice_amount),0) 
        FROM invoices 
        WHERE EXTRACT (YEAR FROM invoice_date) = m.year AND
            EXTRACT (MONTH FROM invoice_date) = m.month) AS sales_checked,
        received_total,
        (SELECT COALESCE(SUM(amount),0) FROM receipt_details 
        WHERE EXTRACT (YEAR FROM receipt_date) = m.year AND
            EXTRACT (MONTH FROM receipt_date) = m.month) AS received_checked
    FROM months m)
SELECT c_m.*, 
  CASE WHEN sales_total <> sales_checked OR received_total <> received_checked 
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_months c_m 
ORDER BY 1, 2, 3;  
     

-- check the values in table "customer_monthly_stats"
WITH check_c_m_s AS (
    SELECT c_m_s.year, c_m_s.month, cust_id, sales, 
        (SELECT COALESCE(SUM(invoice_amount),0) 
        FROM invoices 
        WHERE EXTRACT (YEAR FROM invoice_date) = c_m_s.year AND
            EXTRACT (MONTH FROM invoice_date) = c_m_s.month AND
            cust_id = c_m_s.cust_id) AS sales_checked,
        received,
        (SELECT COALESCE(SUM(amount),0) FROM receipt_details r_d
            INNER JOIN invoices i ON r_d.invoice_id = i.invoice_id
        WHERE EXTRACT (YEAR FROM receipt_date) = c_m_s.year AND
            EXTRACT (MONTH FROM receipt_date) = c_m_s.month AND
            cust_id = c_m_s.cust_id) AS received_checked
    FROM customer_monthly_stats c_m_s)
SELECT c_c_m_s.*, 
  CASE WHEN sales <> sales_checked OR received <> received_checked 
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_c_m_s c_c_m_s  
ORDER BY 1, 2, 3 ;
     

-- check the values in table "product_monthly_stats"
WITH check_p_m_s AS (
    SELECT p_m_s.year, p_m_s.month, product_id, sales, 
        (SELECT COALESCE(SUM(quantity * unit_price + row_vat), 0) 
            FROM invoices i INNER JOIN invoice_details i_d ON i.invoice_id = i_d.invoice_id 
            WHERE 
                EXTRACT (YEAR FROM invoice_date) = p_m_s.year AND
                EXTRACT (MONTH FROM invoice_date) = p_m_s.month AND
                product_id = p_m_s.product_id) AS sales_checked
    FROM product_monthly_stats p_m_s)
SELECT c_p_m_s.*, 
  CASE WHEN sales <> sales_checked 
    THEN 'Problem!' ELSE ' ' END AS Problems
FROM check_p_m_s c_p_m_s   
ORDER BY 1, 2, 3;  



-- now, we can commit the changes
COMMIT ;

