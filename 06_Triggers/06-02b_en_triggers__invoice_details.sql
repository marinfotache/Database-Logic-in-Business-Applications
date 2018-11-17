/*

This script works with `sales` database that was created by launching (in Oracle SQL Developer) six previous scripts:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-2_fixed_DDL_script_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-3_add_constraints_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01a_en_sequences.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01b_en_data_cleaning__surrogate_keys.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01c_en_cascade_updates.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-02a_en_triggers__invoices.sql



See also the `sales` database schema and denormalized attributes in presentation:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-02_en_Triggers%20-%20part%202.pptx



--==========================================================================================
--    Triggers for table INVOICE_DETAILS for dealing with denormalized attributes/tables
--==========================================================================================
--									I. INSERT triggers
--==========================================================================================

I.a Tasks for the INSERT - BEFORE - ROW trigger

	When inserting a new record in table INVOICE_DETAILS:

	- attribute "invoice_details.row_number" must be determined based on 
		attribute "invoices.n_of_rows" for current invoice 
	- attribute "invoice_details.row_vat" must be determined based on 
		attributes "invoice_details.quantity", "invoice_details.unit_price"
			and "products.current_vat_percent"  


I.b Tasks for the INSERT - AFTER - ROW trigger

	-- update "invoice_VAT", "invoice_amount", "n_of_rows" in table INVOICES

	-- update denormalized table PRODUCT_MONTHLY_STATS (if no record exists 
		in table PRODUCT_MONTHLY_STATS for current (inserted)
		invoice's month and customer invoice row's product, 
		then INSERT a record into PRODUCT_MONTHLY_STATS!
		
*/


----------------------------------------------------------------------------------------
-- first, we create a package called "pac_sales_3" with some functions  
--  ...
----------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pac_sales_3
AS
	-- function that returns the date of a given invoice
    FUNCTION f_invoice_date (invoice_id_ invoices.invoice_id%TYPE)
        RETURN invoices.invoice_date%TYPE ; 
        
	-- function that returns the number of rows of a given invoice
    FUNCTION f_invoice_n_of_rows (invoice_id_ invoices.invoice_id%TYPE)
        RETURN invoices.n_of_rows%TYPE ; 
	    
	-- function that provides the current vat percent of a given product        
    FUNCTION f_current_vat_prod (product_id_ products.product_id%TYPE)
        RETURN products.current_vat_percent%TYPE ;  
        
    -- function that determined the vat percent of a given product at 
    --    a given date    
    FUNCTION f_vat_prod (product_id_ products.product_id%TYPE, 
            invoice_date_ invoices.invoice_date%TYPE)
        RETURN products.current_vat_percent%TYPE ;          
END ;
/

--------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_sales_3 
AS

-----------------------------------------------------------------------
-- function that returns the date of a given invoice
FUNCTION f_invoice_date (invoice_id_ invoices.invoice_id%TYPE)
        RETURN invoices.invoice_date%TYPE 
IS
    v_invoice_date invoices.invoice_date%TYPE ;
BEGIN
    SELECT invoice_date INTO v_invoice_date
        FROM invoices WHERE invoice_id = invoice_id_ ;
    RETURN v_invoice_date ;    
END f_invoice_date;         


-----------------------------------------------------------------------
-- function that returns the number of rows of a given invoice
FUNCTION f_invoice_n_of_rows (invoice_id_ invoices.invoice_id%TYPE)
        RETURN invoices.n_of_rows%TYPE 
IS
    v_n_of_rows invoices.n_of_rows%TYPE ;
BEGIN
    SELECT COALESCE(n_of_rows,0) INTO v_n_of_rows
        FROM invoices WHERE invoice_id = invoice_id_ ;
    RETURN v_n_of_rows ;    
END f_invoice_n_of_rows;         


-----------------------------------------------------------------------
-- function that provides the current vat percent of a given product        
FUNCTION f_current_vat_prod (product_id_ products.product_id%TYPE)
        RETURN products.current_vat_percent%TYPE 
IS
    v_current_vat_percent products.current_vat_percent%TYPE ;
BEGIN
    SELECT current_vat_percent INTO v_current_vat_percent
        FROM products WHERE product_id = product_id_ ;
    RETURN v_current_vat_percent ;    
    
END f_current_vat_prod ;


-----------------------------------------------------------------------
-- function that determined the vat percent of a given product at 
--    a given date    
FUNCTION f_vat_prod (product_id_ products.product_id%TYPE, 
            invoice_date_ invoices.invoice_date%TYPE)
    RETURN products.current_vat_percent%TYPE          
IS
    v_VAT_percent products.current_vat_percent%TYPE ;
BEGIN
    -- first try to extract the vat percent from table "former_vat_percents"
    SELECT VAT_percent 
    INTO v_VAT_percent
    FROM former_vat_percents 
    WHERE product_id = product_id_ AND invoice_date_ BETWEEN
        date_start AND COALESCE(date_until, CURRENT_DATE) ;
    
    RETURN v_VAT_percent ;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
    -- if there no record in table "former_vat_percents", we'll get
    --   the current percent from table products
    SELECT current_vat_percent INTO v_VAT_percent
        FROM products WHERE product_id = product_id_ ;
    RETURN v_VAT_percent ;    
    
END f_vat_prod ;          

END ;
/



/* 
------------------------------------------------------------------------------------------
-- 				I.a insert trigger for INVOICE_DETAILS: BEFORE-ROW
------------------------------------------------------------------------------------------
	- attribute "invoice_details.row_number" must be determined based on 
		attribute "invoices.n_of_rows" for current invoice 
	- attribute "invoice_details.row_vat" must be determined based on 
		attributes "invoice_details.quantity", "invoice_details.unit_price"
			and "products.current_vat_percent"  
*/
CREATE OR REPLACE TRIGGER trg_inv_details_ins1
	BEFORE INSERT ON invoice_details FOR EACH ROW
BEGIN 
    -- "row_number" is automatically assigned 
    :NEW.row_number := pac_sales_3.f_invoice_n_of_rows(:NEW.invoice_id) + 1 ;
 
    -- compute "row_VAT" according to the VAT percent at the moment of "invoice_date"
    :NEW.row_VAT := :NEW.quantity * :NEW.unit_price * 
        pac_sales_3.f_vat_prod (:NEW.product_id, 
        pac_sales_3.f_invoice_date(:NEW.invoice_id)) ;

END ;
/


/*
------------------------------------------------------------------------------------------
-- 				I.b insert trigger for INVOICE_DETAILS: AFTER - ROW
------------------------------------------------------------------------------------------

	-- update "invoice_VAT", "invoice_amount", "n_of_rows" in table INVOICES

	-- update denormalized table PRODUCT_MONTHLY_STATS (if no record exists 
		in table PRODUCT_MONTHLY_STATS for current (inserted)
		invoice's month and customer invoice row's product, 
		then INSERT a record into PRODUCT_MONTHLY_STATS!

*/
CREATE OR REPLACE TRIGGER trg_inv_details_ins2
	AFTER INSERT ON invoice_details FOR EACH ROW
DECLARE	
    v_row_number invoice_details.row_number%TYPE ;
BEGIN 
    -- increase "invoice_VAT", "invoice_amount", "n_of_rows" in table "invoices"
    UPDATE invoices
    SET 
        invoice_VAT = invoice_VAT + :NEW.row_VAT,
        invoice_amount = invoice_amount + :NEW.quantity * :NEW.unit_price + :NEW.row_VAT,
        n_of_rows = n_of_rows + 1
    WHERE invoice_id = :NEW.invoice_id  ;
     
    -- update denormalized table "product_monthly_stats"
    --  if there is no record for current year, month and product, then insert
    IF pac_sales_2.f_product_monthly_stats (:NEW.product_id, 
            EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)), 
            EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id))) = FALSE THEN
	    INSERT INTO product_monthly_stats (YEAR, MONTH, product_id, sales, refusals,
	            cancellations) 
	        VALUES (  EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)), 
	            EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)),
	            :NEW.product_id, :NEW.quantity * :NEW.unit_price + :NEW.row_VAT,
	            0, 0) ;
	ELSE
	    -- if the record exists, then update
	    UPDATE product_monthly_stats
	    SET  sales = sales + :NEW.quantity * :NEW.unit_price + :NEW.row_VAT
	    WHERE year = EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) AND
	        month = EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) AND
	        product_id = :NEW.product_id ;             
	END IF ;	
      
END ;
/

----------------------------------------------------------------------------------------
--  When inserting records in table "invoice_details", all the insert triggers of
--   table "invoice_details" and the update triggers for table "invoices" will be tested
----------------------------------------------------------------------------------------
SELECT * FROM invoice_details ;
SELECT * FROM months ;
SELECT * FROM product_monthly_stats ;


INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1111), 1, 1, 50, 1000) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1111), 22, 2, 75, 1050) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1111), 3, 5, 500, 7060) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1112), 1, 2, 80, 1030) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1112), 2, 3, 40, 750) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1113), 1, 2, 100, 975) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1114), 1, 2, 70, 1070) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1114), 2, 4, 30, 1705) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1114), 3, 5, 700, 7064) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1115), 1, 2, 150, 925) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1116), 1, 2, 125, 930) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1117), 1, 2, 100, 1000) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1117), 2, 1, 100, 950) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1118), 1, 2, 30, 1100) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1118), 2, 1, 150, 930) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1119), 1, 2, 35, 1090) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1119), 2, 3, 40, 700) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1119), 3, 4, 50, 1410) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1119), 4, 5, 750, 6300) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1120), 1, 2, 80, 1120) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1121), 1, 5, 550, 7064) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1121), 2, 2, 100, 1050) ;

INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2111), 1, 1, 57, 1000) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2111), 2, 2, 79, 1050) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2111), 3, 5, 510, 7060) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2112), 1, 2, 85, 1030) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2112), 2, 3, 65, 750) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2113), 1, 2, 120, 975) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2115), 1, 2, 110, 925) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2116), 1, 2, 135, 930) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2117), 1, 2, 150, 1000) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2117), 2, 1, 110, 950) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2118), 1, 2, 39, 1100) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2118), 2, 1, 120, 930) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2119), 1, 2, 35, 1090) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2119), 2, 3, 40, 700) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2119), 3, 4, 55, 1410) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2119), 4, 5, 755, 6300) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2121), 1, 5, 550, 7064) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 2121), 2, 2, 103, 1050) ;


INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3111), 1, 1, 57, 1000) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3111), 2, 2, 79, 1050) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3111), 3, 5, 510, 7060) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3112), 1, 2, 85, 1030) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3112), 2, 3, 65, 750) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3113), 1, 2, 120, 975) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3115), 1, 2, 110, 925) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3116), 1, 2, 135, 930) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3117), 1, 2, 150, 1000) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3117), 2, 1, 110, 950) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3118), 1, 2, 39, 1100) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3118), 2, 1, 120, 930) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3119), 1, 2, 35, 1090) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3119), 2, 3, 40, 700) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3119), 3, 4, 55, 1410) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 3119), 4, 5, 755, 6300) ;
COMMIT ;

-- insert records for 2014 by simply copying the invoice_details from 2013 
INSERT INTO invoice_details (invoice_id, product_id, quantity, unit_price) 
    SELECT invoice_id + (SELECT MIN(invoice_id) FROM invoices
				WHERE EXTRACT (YEAR FROM invoice_date) = 2014) -
			(SELECT MIN(invoice_id) FROM invoices
				WHERE EXTRACT (YEAR FROM invoice_date) = 2013), 
		product_id, quantity, unit_price
    FROM invoice_details 
    WHERE invoice_id IN 
        (SELECT invoice_id
         FROM invoices
         WHERE EXTRACT (YEAR FROM invoice_date) = 2013) ;

		 
COMMIT ;


----------------------------------------------------------------------------------------
--  check the triggers examining the records
----------------------------------------------------------------------------------------
/*
SELECT * FROM invoice_details ;
SELECT * FROM invoices ;
SELECT * FROM customers ;
SELECT * FROM months ;
SELECT * FROM customer_monthly_stats ;
SELECT * FROM product_monthly_stats ;
*/


----------------------------------------------------------------------------------------
--              check the triggers with a couple of queries
----------------------------------------------------------------------------------------

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
FROM check_invoices c_i ;  

         
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
FROM check_cust c_c ;  


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
FROM check_months c_m ;  
     

-- check the values in table "customer_monthly_stats"
WITH check_c_m_s AS (
    SELECT c_m_s.year, c_m_s.month, sales, 
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
FROM check_c_m_s c_c_m_s ;  
     

-- check the values in table "product_monthly_stats"
WITH check_p_m_s AS (
    SELECT p_m_s.year, p_m_s.month, sales, 
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
FROM check_p_m_s c_p_m_s ;  



/*

--==========================================================================================
--					II. UPDATE triggers for table INVOICE_DETAILS
--==========================================================================================

------------------------------------------------------------------------------------------
II.a Tasks for the UPDATE - BEFORE - ROW trigger

	When updating a record in table INVOICE_DETAILS:

		- check if at least one value of the following attributes
			was changed: product_vat, `quantity`, `unit_price`; if so, 
				UPDATE `row_vat` !

		- check if "invoice_details.row_number"'s values has been changed;
			for the moment, the rule to be enforced is: "the `row_number`
			cannot be updated, except for the case when also `invoice_id`
			was changed!"


II.b Tasks for the UPDATE - AFTER - ROW trigger

	II.b.1  Check id the `invoice_id` has been changed...
	
		II.b.1.a ...if the "invoice_id" was changed, then...
		
			- decrease "invoices.invoice_VAT", "invoices.invoice_amount" and
	        	 "invoices.n_of_rows" for the OLD invoice
	   		- increase "invoices.invoice_VAT", "invoices.invoice_amount" and
	        	 "invoices.n_of_rows" for the NEW invoice
				
			-	test if the new invoice date falls in another month
			
				II.b.1.a.1 ... if new line appear in a new invoice placed into another month...
					- decrease "product_monthly_stats.sales" for the OLD product and the old invoice's month
					- increase "product_monthly_stats.sales" for the NEW product and the new invoice's month; 
							(do not forget to check if the new product has a corresponding record 
								in "product_monthly_stats" for  the current invoice's month (if not, add 
								the record in "product_monthly_stats")

				II.b.1.a.2 ... if new line appear in a new invoice placed in the same month...
					- do nothing


	II.b.1.b if the "invoice_id" was not changed, then...
		- just update "invoices.invoice_VAT" and 
		     "invoices.invoice_amount"


	II.b.2 Check if the `product_id` has been changed...

	II.b.2.a ...if the `product_id` was changed, then...
		- decrease "product_monthly_stats.sales" for the OLD product (and the current invoice's month)
		- increase "product_monthly_stats.sales" for the NEW product (and the current invoice's month), 
			but do not forget to check if the new product has a corresponding record in "product_monthly_stats"
			for  the current invoice's month (if not, add the record in "product_monthly_stats")

	II.b.2.b if the `product_id` was not changed, then just update "product_monthly_stats.sales"					
*/


------------------------------------------------------------------------------------------
--							II.a UPDATE - BEFORE - ROW trigger

CREATE OR REPLACE TRIGGER trg_inv_details_upd1
	BEFORE UPDATE ON invoice_details FOR EACH ROW
BEGIN 

    -- "invoice_details.row_number" must be changed only accompanied by 
    --       a change of "invoice_details.invoice_id")
    IF :NEW.row_number <> :OLD.row_number AND :NEW.invoice_id = :OLD.invoice_id THEN
        -- user defined errors must be in the range between -20000 and -20999.
        RAISE_APPLICATION_ERROR (-20010, 
    		'In this version, value of attribute "row_number" cannot be changed within an invoice!');
    END IF ;

	-- check if at least one value of the following attributes
	--		was changed: product_vat, `quantity`, `unit_price`; if so, 
	--			UPDATE `row_vat` !
	IF COALESCE(:NEW.quantity,0) <> COALESCE(:OLD.quantity,0) OR
		COALESCE(:NEW.unit_price,0) <> COALESCE(:OLD.unit_price,0) OR
		COALESCE( pac_sales_3.f_vat_prod (:NEW.product_id, 
        	pac_sales_3.f_invoice_date(:NEW.invoice_id)) ,0) <> 
        			COALESCE( pac_sales_3.f_vat_prod (:OLD.product_id, 
        				pac_sales_3.f_invoice_date(:OLD.invoice_id)) ,0) THEN
	    :NEW.row_VAT := :NEW.quantity * :NEW.unit_price * 
    	    pac_sales_3.f_vat_prod (:NEW.product_id, 
        		pac_sales_3.f_invoice_date(:NEW.invoice_id)) ;
	END IF ;
END ;
/

	

------------------------------------------------------------------------------------------
--							II.b UPDATE - AFTER - ROW trigger
------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_inv_details_upd2
	AFTER UPDATE ON invoice_details FOR EACH ROW
DECLARE	

BEGIN 

	-- II.b.1  Check id the `invoice_id` has been changed...

    IF :NEW.invoice_id <> :OLD.invoice_id THEN
    	/* 
    	II.b.1.a ...if the "invoice_id" was changed, then...
		- decrease "invoices.invoice_VAT", "invoices.invoice_amount" and
	         "invoices.n_of_rows" for the OLD invoice
	    - increase "invoices.invoice_VAT", "invoices.invoice_amount" and
	         "invoices.n_of_rows" for the NEW invoice
		*/
    
        -- decrease "invoice_VAT", "invoice_amount", "n_of_rows" for the old invoice
        UPDATE invoices
        SET invoice_VAT = invoice_VAT - :OLD.row_VAT,
            invoice_amount = invoice_amount - 
            	(:OLD.quantity * :OLD.unit_price + :OLD.row_VAT),
            n_of_rows = n_of_rows - 1
        WHERE invoice_id = :OLD.invoice_id  ;
    
        -- increase "invoice_VAT", "invoice_amount", "n_of_rows" for the new invoice
        UPDATE invoices
        SET invoice_VAT = invoice_VAT + :NEW.row_VAT,
            invoice_amount = invoice_amount + :NEW.quantity * :NEW.unit_price + :NEW.row_VAT,
            n_of_rows = n_of_rows + 1
        WHERE invoice_id = :NEW.invoice_id  ;
        
        /*
        	test if the new invoice date falls in another month
		*/
		
		IF EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) <>
					EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:OLD.invoice_id)) OR
				EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) <>
					EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:OLD.invoice_id)) THEN							
		/*	
				II.b.1.a.1 ... if new line appear in a new invoice placed into another month...
					- decrease "product_monthly_stats.sales" for the OLD product and the old invoice's month
					- increase "product_monthly_stats.sales" for the NEW product and the new invoice's month; 
							(do not forget to check if the new product has a corresponding record 
								in "product_monthly_stats" for  the current invoice's month (if not, add 
								the record in "product_monthly_stats")
		*/
			UPDATE product_monthly_stats
			SET  sales = sales - (:OLD.quantity * :OLD.unit_price + :OLD.row_VAT)
			WHERE year = EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:OLD.invoice_id)) AND
	    		month = EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:OLD.invoice_id)) AND
	    		product_id = :OLD.product_id ;             

		    --  for the new month and the new product, check if the record exists in 
		    --   	"product_monthly_stats"
    		IF pac_sales_2.f_product_monthly_stats (:NEW.product_id, 
            		EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)), 
            		EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id))) = FALSE THEN
            	-- it does not exist, so INSERT
	    		INSERT INTO product_monthly_stats (YEAR, MONTH, product_id, sales, refusals,
	            		cancellations) 
	        		VALUES (  EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)), 
	            		EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)),
	            		:NEW.product_id, :NEW.quantity * :NEW.unit_price + :NEW.row_VAT,
	            		0, 0) ;
			ELSE
				-- record exists, so add the new value of row sales
		    	UPDATE product_monthly_stats
		    	SET  sales = sales + :NEW.quantity * :NEW.unit_price + :NEW.row_VAT
	    		WHERE year = EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) AND
	        		month = EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) AND
	        		product_id = :NEW.product_id ;             
			END IF ;
		
		ELSE
		/*
				II.b.1.a.2 ... if new line appear in a new invoice placed in the same month...
					- do nothing

        */
        	NULL ;
        END IF ;
        
        
        
        
    ELSE
		/*    
    	II.b.1.b if the "invoice_id" was not changed, then...
		- just update "invoices.invoice_VAT" and 
		     "invoices.invoice_amount"
		*/
        UPDATE invoices
        SET invoice_VAT = invoice_VAT - :OLD.row_VAT + :NEW.row_VAT,
            invoice_amount = invoice_amount 
                - (:OLD.quantity * :OLD.unit_price + :OLD.row_VAT)
                + (:NEW.quantity * :NEW.unit_price + :NEW.row_VAT)
        WHERE invoice_id = :NEW.invoice_id  ;   
    END IF ;
    
    

	-- II.b.2 Check if the `product_id` has been changed...
	IF :NEW.product_id <> :OLD.product_id THEN 
		/*
		II.b.2.a ...if the `product_id` was changed, then...
			- decrease "product_monthly_stats.sales" for the OLD product (and the current invoice's month)
			- increase "product_monthly_stats.sales" for the NEW product (and the current invoice's month), 
				but do not forget to check if the new product has a corresponding record in "product_monthly_stats"
				for  the current invoice's month (if not, add the record in "product_monthly_stats")
		*/
		UPDATE product_monthly_stats
		SET  sales = sales - (:OLD.quantity * :OLD.unit_price + :OLD.row_VAT)
		WHERE year = EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:OLD.invoice_id)) AND
	    	month = EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:OLD.invoice_id)) AND
	    	product_id = :OLD.product_id ;             

	    --  for the new month and the new product, check if the record exists in 
	    --   	"product_monthly_stats"
    	IF pac_sales_2.f_product_monthly_stats (:NEW.product_id, 
            	EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)), 
            	EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id))) = FALSE THEN
            -- it does not exist, so INSERT
	    	INSERT INTO product_monthly_stats (YEAR, MONTH, product_id, sales, refusals,
	            	cancellations) 
	        	VALUES (  EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)), 
	            	EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)),
	            	:NEW.product_id, :NEW.quantity * :NEW.unit_price + :NEW.row_VAT,
	            	0, 0) ;
		ELSE
			-- record exists, so add the new value of row sales
		    UPDATE product_monthly_stats
		    SET  sales = sales + :NEW.quantity * :NEW.unit_price + :NEW.row_VAT
	    	WHERE year = EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) AND
	        	month = EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) AND
	        	product_id = :NEW.product_id ;             
		END IF ;

	ELSE


		/*
		II.b.2.b if the `product_id` was not changed, then just update "product_monthly_stats.sales"					
    	*/
    
		-- check if at least one value of the following attributes
		--		was changed: product_vat, `quantity`, `unit_price`
		IF COALESCE(:NEW.quantity,0) <> COALESCE(:OLD.quantity,0) OR
			COALESCE(:NEW.unit_price,0) <> COALESCE(:OLD.unit_price,0) OR
			COALESCE( pac_sales_3.f_vat_prod (:NEW.product_id, 
        		pac_sales_3.f_invoice_date(:NEW.invoice_id)) ,0) <> 
        			COALESCE( pac_sales_3.f_vat_prod (:OLD.product_id, 
        				pac_sales_3.f_invoice_date(:OLD.invoice_id)) ,0) THEN
    
 		    -- * update denormalized table "product_monthly_stats"...
			UPDATE product_monthly_stats
			SET  sales = sales - (:OLD.quantity * :OLD.unit_price + :OLD.row_VAT) +
				(:NEW.quantity * :NEW.unit_price + :NEW.row_VAT)
			WHERE year = EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) AND
	    		month = EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:NEW.invoice_id)) AND
	    		product_id = :NEW.product_id ;             
		END IF ;
	END IF ;    
    
END;
/



--==========================================================================================
--                      test the triggers
--==========================================================================================


----------------------------------------------------------------------------------------
--              1. change the quantity for a product in an invoice


SELECT * FROM invoices WHERE invoice_id = 1 ;

/* 
  "invoice_date" is '2013-08-01', "cust_id" is 1001, 
  "invoice_vat is 868650, invoice_amount is 4527400, 
  "n_of_rows" is 3 and amount_received and refused is 0
*/

SELECT * FROM customers WHERE cust_id = 
  (SELECT cust_id FROM invoices WHERE invoice_id = 1) ;
-- the customer current balance is 32093544


SELECT * FROM months WHERE year = 2013 AND month = 8 ;
-- sales total for this month is 39472766


SELECT * FROM customer_monthly_stats WHERE year = 2013 AND month = 8 
  AND cust_id = 1001 ;
-- sales total for this customer and this month is 10689432



SELECT * FROM invoice_details WHERE invoice_id = 1 ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
         1          1         50       1000          1      12000
         1          2         75       1050          2       9450
         1          3        500       7060          5     847200
*/


SELECT * FROM product_monthly_stats WHERE year = 2013 AND month = 8 
  AND product_id = 1 ;
-- sales total for this products and this month is 691424



---------------------------------------------------------------------------
/* for this invoice, in row number 1 (product_id is 1), change the value of
  "quantity" from 50 to 500
*/
UPDATE invoice_details SET quantity = 500 WHERE invoice_id = 1 AND row_number = 1;


--  let's see how the triggers did their job

SELECT * FROM invoice_details WHERE invoice_id = 1 ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
         1          1        500       1000          1     120000
         1          2         75       1050          2       9450
         1          3        500       7060          5     847200
*/
-- in row 1, QUANTITY was changed from `50` to `500` and the ROW_VAT from `12000` to `120000`


SELECT * FROM invoices WHERE invoice_id = 1 ;

/* 
  "invoice_vat is 976650 (old values was 868650), 
  invoice_amount is now 5085400 (it was 4527400 before the insert), 
  "n_of_rows" is 3 and amount_received is 0
*/

SELECT * FROM customers WHERE cust_id = 
  (SELECT cust_id FROM invoices WHERE invoice_id = 1) ;

-- the customer current balance is 32651544 (it was 32093544)


SELECT * FROM months WHERE year = 2013 AND month = 8 ;
-- sales total for this month is 40030766 (old value was 39472766)


SELECT * FROM customer_monthly_stats WHERE year = 2013 AND month = 8 
  AND cust_id = 1001 ;
-- sales total for this customer and this month is 11247432 (it was 10689432)

SELECT * FROM product_monthly_stats WHERE year = 2013 AND month = 8 
  AND product_id = 1 ;
-- sales total for this products and this month is 1249424 (old value was 691424)

COMMIT ;



----------------------------------------------------------------------------------------
--   2. change the invoice date (change the month) and the customer for invoice


SELECT * FROM invoices WHERE invoice_id = 61 ;

/* 
  "invoice_date" is '07-10-2014', "cust_id" is 1003, 
  "invoice_vat is 1162164, invoice_amount is 6062364, 
  "n_of_rows" is 4 and amount_received is 0
*/

SELECT cust_id, cust_name, current_balance FROM customers WHERE cust_id IN (1003, 1004)  ;
/*
  CUST_ID CUST_NAME                                          CURRENT_BALANC
---------- -------------------------------------------------- --------------
      1003 Client C SRL                                             36280272
      1004 Client D                                                 20641048
*/

SELECT * FROM months WHERE year = 2014 AND month IN (10, 11) ;
/*
YEAR      MONTH      SALES_TOTAL   REFUSALS_TOTAL CANCELLATIONS_TO      RECEIVED_TOTAL
---------- ---------- ---------------- ---------------- --------------- --------------
      2014         10          6062364                0                0 0
*/



SELECT * FROM customer_monthly_stats WHERE year = 2014 AND month = 10
  AND cust_id IN (1003, 1004) ;
/*  
   CUST_ID       YEAR      MONTH      SALES   REFUSALS    CANCELLATIONS        RECEIVED
---------- ---------- ---------- ---------- ---------- ----------------  --------------
      1003       2014         10    6062364          0                0               0
*/


SELECT * FROM invoice_details WHERE invoice_id = 61 ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        61          1         35       1090          2       4578
        61          2         40        700          3       6720
        61          3         55       1410          4       9306
        61          4        755       6300          5    1141560
*/

SELECT * FROM product_monthly_stats WHERE (year = 2014 AND month = 10
  OR year = 2014 AND month = 11)
  AND product_id IN (SELECT product_id FROM invoice_details WHERE invoice_id = 61) ;
/*  
    SALES   REFUSALS  CANCELLATIONS   PRODUCT_ID       YEAR      MONTH
---------- ---------- --------------  ---------- ---------- ----------
     42728          0              0           2       2014         10
     34720          0              0           3       2014         10
     86856          0              0           4       2014         10
   5898060          0              0           5       2014         10
*/


-- in invoice 61, change the date from '07-10-2014' to '01-11-2014' cust_id from 1003 to 1004
UPDATE invoices
SET invoice_date = DATE'2014-11-01', cust_id = 1004 
WHERE invoice_id = 61 ;


-- not let's see what the triggers have done

SELECT * FROM invoices WHERE invoice_id = 61 ;

/* 
  "invoice_date" is '01-11-2014', "cust_id" is 1004, 
  "invoice_vat is 1162164, invoice_amount is 6062364, 
  "n_of_rows" is 4 and amount_received is 0
*/

SELECT cust_id, cust_name, current_balance FROM customers WHERE cust_id IN (1003, 1004)  ;
/*
   CUST_ID CUST_NAME                                          CURRENT_BALANC
---------- -------------------------------------------------- --------------
      1003 Client C SRL                                             30217908
      1004 Client D                                                 26703412
*/

SELECT * FROM months WHERE year = 2014 AND month IN (10, 11) ;
/*
YEAR      MONTH            SALES_TOTAL  REFUSALS_TOTAL CANCELLATIONS_TO     RECEIVED_TOTAL
---------- ---------- ---------------- ----------------   ---------------  --------------
      2014         10                0               0                0                 0
      2014         11          6062364               0                0                 0
*/


SELECT * FROM customer_monthly_stats WHERE year = 2014 AND month IN (10, 11)
  AND cust_id IN (1003, 1004) ;
/*  
   CUST_ID       YEAR      MONTH      SALES   REFUSALS    CANCELLATIONS        RECEIVED
---------- ---------- ---------- ---------- ---------- ----------------  --------------
      1003       2014         10          0          0                0               0
      1004       2014         11          0    6062364                0               0
*/


SELECT * FROM invoice_details WHERE invoice_id = 61 ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        61          1         35       1090          2       4578
        61          2         40        700          3       6720
        61          3         55       1410          4       9306
        61          4        755       6300          5    1141560
*/

SELECT * FROM product_monthly_stats WHERE (year = 2014 AND month = 10
  OR year = 2014 AND month = 11) AND product_id IN 
  (SELECT product_id FROM invoice_details WHERE invoice_id = 61) ;
/*  
     SALES   REFUSALS  CANCELLATIONS  PRODUCT_ID       YEAR      MONTH
---------- ---------- --------------  ---------- ---------- ----------
     42728          0              0           2       2014         11
         0          0              0           2       2014         10
     34720          0              0           3       2014         11
         0          0              0           3       2014         10
     86856          0              0           4       2014         11
         0          0              0           4       2014         10
   5898060          0              0           5       2014         11
         0          0              0           5       2014         10
*/

-- now the update can be commited
COMMIT ;



----------------------------------------------------------------------------------------
--   3. change the row number in an invoice ("invoice_id" remains unchanged)
-- this operation must be blocked (according to the current business requirements)


SELECT MAX(invoice_id) FROM invoices ;
-- 61

SELECT * FROM invoice_details WHERE invoice_id = 61 ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        61          1         35       1090          2       4578
        61          2         40        700          3       6720
        61          3         55       1410          4       9306
        61          4        755       6300          5    1141560
*/

UPDATE invoice_details SET row_number = 5 WHERE invoice_id = 61 AND row_number = 4 ;
/*
Error starting at line : 14 in command -
UPDATE invoice_details SET row_number = 5 WHERE invoice_id = 61 AND row_number = 4 
Error report -
SQL Error: ORA-20010: Value of attribute "row_number" cannot be changed within an invoice!
ORA-06512: la "SIA.TRG_INV_DETAILS_UPD1", linia 8
ORA-04088: eroare în timpul executiei triggerului 'SIA.TRG_INV_DETAILS_UPD1'
*/



----------------------------------------------------------------------------------------
-- 4. move a row from an invoice to another without changing the row number in the new invoice
--   this time, we take care of row numbers in both in invoices

/*
SELECT *
FROM invoices 
WHERE n_of_rows IN (1,2) ;
*/

SELECT invoice_id, invoice_date, cust_id, invoice_vat, invoice_amount,
  n_of_rows
FROM invoices WHERE invoice_id IN (58, 59) ;
/*
INVOICE_ID INVOICE_DATE    CUST_ID    INVOICE_VAT INVOICE_AMOUNT  N_OF_ROWS
---------- ------------ ---------- -------------- -------------- ----------
        58 10-09-2014         1007          15066         140616          1
        59 10-09-2014         1001          43080         297580          2
*/ 


SELECT cust_id, cust_name, current_balance FROM customers WHERE cust_id IN (1007, 1001)  ;
/*
   CUST_ID CUST_NAME                                          CURRENT_BALANC
---------- -------------------------------------------------- --------------
      1001 Client A SRL                                             32651544
      1007 Client G SRL                                               822864
*/

SELECT * FROM months WHERE year = 2014 AND month = 9  ;
/*
YEAR      MONTH            SALES_TOTAL   REFUSALS_TOTAL CANCELLATIONS_TO      RECEIVED_TOTAL
---------- ---------- ---------------- ---------------- ----------------- ----------------
      2014          9          5656462                0                 0                0
*/


SELECT * FROM customer_monthly_stats WHERE year = 2014 AND month = 9
  AND cust_id IN (1007, 1001) ;
/*  
   CUST_ID       YEAR      MONTH      SALES   REFUSALS    CANCELLATIONS        RECEIVED
---------- ---------- ---------- ---------- ---------- ----------------  --------------
      1001       2014          9    5357340          0                0               0
      1007       2014          9     140616          0                0               0
*/


SELECT * FROM invoice_details WHERE invoice_id IN (58, 59) ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        58          1        135        930          2      15066
        59          1        150       1000          2      18000
        59          2        110        950          1      25080
*/

SELECT * FROM product_monthly_stats WHERE (year = 2014 AND month = 9)
  AND product_id IN (SELECT product_id FROM invoice_details WHERE invoice_id IN (58, 59)) ;
/*  
     SALES   REFUSALS  CANCELLATIONS PRODUCT_ID       YEAR      MONTH
---------- ---------- -------------- ---------- ---------- ----------
    338644          0              0          1       2014          9
    792624          0              0          2       2014          9
*/


-- we'll move the second row of invoice 59 into the invoice 58 (there will be no
--   problem with row numbering in both invoices after this update

UPDATE invoice_details SET invoice_id = 58 WHERE invoice_id = 59 and row_number = 2 ;


-- check the triggers actions

SELECT invoice_id, invoice_date, cust_id, invoice_vat, invoice_amount,
  n_of_rows
FROM invoices WHERE invoice_id IN (58, 59) ;
/*
INVOICE_ID INVOICE_DATE    CUST_ID    INVOICE_VAT INVOICE_AMOUNT  N_OF_ROWS
---------- ------------ ---------- -------------- -------------- ----------
        58 10-09-2014         1007          40146         270196          2
        59 10-09-2014         1001          18000         168000          1
*/ 


SELECT cust_id, cust_name, current_balance FROM customers WHERE cust_id IN (1007, 1001)  ;
/*
  CUST_ID CUST_NAME                                          CURRENT_BALANC
---------- -------------------------------------------------- --------------
      1001 Client A SRL                                             32521964
      1007 Client G SRL                                               952444
*/

SELECT * FROM months WHERE year = 2014 AND month = 9  ;
/*
YEAR      MONTH            SALES_TOTAL   REFUSALS_TOTAL CANCELLATIONS_TO      RECEIVED_TOTAL
---------- ---------- ---------------- ---------------- ----------------- ----------------
      2014          9          5656462                0                 0                0
*/



SELECT * FROM customer_monthly_stats WHERE year = 2014 AND month = 9
  AND cust_id IN (1007, 1001) ;
/*  
   CUST_ID       YEAR      MONTH      SALES   REFUSALS    CANCELLATIONS        RECEIVED
---------- ---------- ---------- ---------- ---------- ----------------  --------------
      1001       2014          9    5227760          0                0               0
      1007       2014          9     270196          0                0               0
*/


SELECT * FROM invoice_details WHERE invoice_id IN (58, 59) ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        58          1        135        930          2      15066
        58          2        110        950          1      25080
        59          1        150       1000          2      18000
*/

SELECT * FROM product_monthly_stats WHERE (year = 2014 AND month = 9)
  AND product_id IN (SELECT product_id FROM invoice_details WHERE invoice_id IN (58, 59)) ;
/*  
     SALES   REFUSALS  CANCELLATIONS PRODUCT_ID       YEAR      MONTH
---------- ---------- -------------- ---------- ---------- ----------
    338644          0              0          1       2014          9
    792624          0              0          2       2014          9
*/

COMMIT ;





----------------------------------------------------------------------------------------
-- 5. move a row from an invoice to another, changing the row number in the new invoice;
--   this time, we take care of row numbers in both invoices, too

SELECT *
FROM invoices 
WHERE n_of_rows IN (1,3) ;

SELECT *
FROM invoice_details
WHERE invoice_id IN (SELECT invoice_id FROM invoices WHERE n_of_rows IN (1,3))
ORDER BY invoice_id, product_id;


SELECT invoice_id, invoice_date, cust_id, invoice_vat, invoice_amount,
  n_of_rows
FROM invoices WHERE invoice_id IN (30, 48) ;
/*
INVOICE_ID INVOICE_DATE    CUST_ID    INVOICE_VAT INVOICE_AMOUNT  N_OF_ROWS
---------- ------------ ---------- -------------- -------------- ----------
        30 07-10-2013         1003        1162164        6062364          4
        48 15-08-2014         1007          15066         140616          1
*/ 


SELECT cust_id, cust_name, current_balance FROM customers WHERE cust_id IN (1003, 1007)  ;
/*
   CUST_ID CUST_NAME                                          CURRENT_BALANCE
---------- -------------------------------------------------- ---------------
      1003 Client C SRL                                              30217908
      1007 Client G SRL                                                952444
*/

SELECT * FROM months WHERE (year = 2013 AND month = 10) OR
  (year = 2014 AND month = 8) ;

/*
YEAR      MONTH            SALES_TOTAL   REFUSALS_TOTAL CANCELLATIONS_TO      RECEIVED_TOTAL
---------- ---------- ---------------- ---------------- ----------------- ----------------
      2013         10          6062364                0                 0                0
      2014          8         39472766                0                 0                0
*/


SELECT * FROM customer_monthly_stats WHERE (year = 2013 AND month = 10) OR
  (year = 2014 AND month = 8) AND cust_id IN (1003, 1007) 
ORDER BY cust_id, year, month;
  
/*  
   CUST_ID       YEAR      MONTH      SALES   REFUSALS    CANCELLATIONS        RECEIVED
---------- ---------- ---------- ---------- ---------- ----------------  --------------
      1003       2013         10    6062364          0                0               0
      1003       2014          8   12077772          0                0               0
      1007       2014          8     270816          0                0               0
*/


SELECT * FROM invoice_details WHERE invoice_id IN (30, 48) ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        30          1         35       1090          2       4578
        30          2         40        700          3       6720
        30          3         55       1410          4       9306
        30          4        755       6300          5    1141560
        48          1        135        930          2      15066
*/

SELECT * FROM product_monthly_stats WHERE (year = 2013 AND month = 10) OR
  (year = 2014 AND month = 8) AND product_id IN (SELECT product_id FROM invoice_details 
    WHERE invoice_id IN (30, 48)) 
ORDER BY product_id, year, month;
/*  
     SALES   REFUSALS  CANCELLATIONS PRODUCT_ID       YEAR      MONTH
---------- ---------- -------------- ---------- ---------- ----------
     42728          0              0          2       2013         10
   2025296          0              0          2       2014          8
     34720          0              0          3       2013         10
    167090          0              0          3       2014          8
     86856          0              0          4       2013         10
    223104          0              0          4       2014          8
   5898060          0              0          5       2013         10
  36365852          0              0          5       2014          8
*/


-- we'll move the forth row of invoice 30 into the invoice 48; in order to 
--   preserve row numbering (in both invoices) the moved row is the last in invoice 30
--   and it will become the second in invoice 48

UPDATE invoice_details 
SET invoice_id = 48, row_number = 2
WHERE invoice_id = 30 and row_number = 4 ;




-- check the triggers actions


SELECT invoice_id, invoice_date, cust_id, invoice_vat, invoice_amount,
  n_of_rows
FROM invoices WHERE invoice_id IN (30, 48) ;
/*
INVOICE_ID INVOICE_DATE    CUST_ID    INVOICE_VAT INVOICE_AMOUNT  N_OF_ROWS
---------- ------------ ---------- -------------- -------------- ----------
        30 07-10-2013         1003          20604         164304          3
        48 15-08-2014         1007        1156626        6038676          2
*/ 


SELECT cust_id, cust_name, current_balance FROM customers WHERE cust_id IN (1003, 1007)  ;
/*
   CUST_ID CUST_NAME                                          CURRENT_BALANCE
---------- -------------------------------------------------- ---------------
      1003 Client C SRL                                              24319848
      1007 Client G SRL                                               6850504
*/

SELECT * FROM months WHERE (year = 2013 AND month = 10) OR
  (year = 2014 AND month = 8) ;

/*
YEAR      MONTH            SALES_TOTAL   REFUSALS_TOTAL CANCELLATIONS_TO      RECEIVED_TOTAL
---------- ---------- ---------------- ---------------- ----------------- ----------------
      2013         10           164304                0                 0                0
      2014          8         45370826                0                 0                0
*/


SELECT * FROM customer_monthly_stats WHERE (year = 2013 AND month = 10) OR
  (year = 2014 AND month = 8) AND cust_id IN (1003, 1007) 
ORDER BY cust_id, year, month;
  
/*  
   CUST_ID       YEAR      MONTH      SALES   REFUSALS    CANCELLATIONS        RECEIVED
---------- ---------- ---------- ---------- ---------- ----------------  --------------
      1003       2013         10     164304          0                0               0
      1003       2014          8   12077772          0                0               0
      1007       2014          8    6168876          0                0               0
*/


SELECT * FROM invoice_details WHERE invoice_id IN (30, 48) ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        30          1         35       1090          2       4578
        30          2         40        700          3       6720
        30          3         55       1410          4       9306
        48          1        135        930          2      15066
        48          2        755       6300          5    1141560
*/

SELECT * FROM product_monthly_stats WHERE (year = 2013 AND month = 10) OR
  (year = 2014 AND month = 8) AND product_id IN (SELECT product_id FROM invoice_details 
    WHERE invoice_id IN (30, 48)) 
ORDER BY product_id, year, month;
/*  
     SALES   REFUSALS  CANCELLATIONS PRODUCT_ID       YEAR      MONTH
---------- ---------- -------------- ---------- ---------- ----------
     42728          0              0          2       2013         10
   2025296          0              0          2       2014          8
     34720          0              0          3       2013         10
    167090          0              0          3       2014          8
     86856          0              0          4       2013         10
    223104          0              0          4       2014          8
         0          0              0          5       2013         10
  42263912          0              0          5       2014          8
*/

COMMIT ;




----------------------------------------------------------------------------------------
--              check the triggers with a couple of queries
----------------------------------------------------------------------------------------

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
FROM check_invoices c_i ;  

         
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
FROM check_cust c_c ;  


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
FROM check_months c_m ;  
     

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
FROM check_c_m_s c_c_m_s ;  
     

-- check the values in table "product_monthly_stats"
WITH check_p_m_s AS (
    SELECT p_m_s.year, p_m_s.month, sales, 
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
FROM check_p_m_s c_p_m_s ;  



------------------------------------------------------------------------------------------
-- Tasks for the DELETE trigger of table "invoice_details":

-- * decrease "invoice_VAT", "invoice_amount", "n_of_rows" for the invoice 
--       containing the deleted line/row
-- * update denormalized table "product_monthly_stats"
--       for the month and the product contained in the deleted line

CREATE OR REPLACE TRIGGER trg_inv_details_del
	AFTER DELETE ON invoice_details FOR EACH ROW
DECLARE	

BEGIN 
    -- decrease "invoice_VAT", "invoice_amount", "n_of_rows" for the invoice 
    --   containing the deleted line/row
    UPDATE invoices
    SET invoice_VAT = invoice_VAT - :OLD.row_VAT,
        invoice_amount = invoice_amount - 
        	(:OLD.quantity * :OLD.unit_price + :OLD.row_VAT),
        n_of_rows = n_of_rows - 1
    WHERE invoice_id = :OLD.invoice_id  ;
    
    
    -- update denormalized table "product_monthly_stats"
    --      for the month and the product contained in the deleted line
	UPDATE product_monthly_stats
	SET  sales = sales - (:OLD.quantity * :OLD.unit_price + :OLD.row_VAT)
	WHERE year = EXTRACT (YEAR FROM pac_sales_3.f_invoice_date(:OLD.invoice_id)) AND
	    month = EXTRACT (MONTH FROM pac_sales_3.f_invoice_date(:OLD.invoice_id)) AND
	    product_id = :OLD.product_id ;             
    
END;
/

------------------------------------------------------------------------------------------
-- test the trigger for DELETE


SELECT invoice_id, invoice_date, cust_id, invoice_vat, 
  invoice_amount,n_of_rows
FROM invoices WHERE invoice_id = 61 ;
/*
INVOICE_ID INVOICE_DA    CUST_ID INVOICE_VAT INVOICE_AMOUNT  N_OF_ROWS
---------- ---------- ---------- ----------- -------------- ----------
        61 01-11-2014       1004     1162164        6062364          4*/ 


SELECT cust_id, cust_name, current_balance FROM customers WHERE cust_id = 1004  ;
/*
  CUST_ID CUST_NAME                                          CURRENT_BALANCE
---------- -------------------------------------------------- ---------------
      1004 Client D                                                  26703412
*/

SELECT * FROM months WHERE year = 2014 AND month = 11 ;
/*
      YEAR      MONTH SALES_TOTAL REFUSALS_TOTAL CANCELLATIONS_TOTAL RECEIVED_TOTAL
---------- ---------- ----------- -------------- ------------------- --------------
      2014         11     6062364              0                   0              0
*/

SELECT * FROM customer_monthly_stats WHERE year = 2014 AND month = 11 AND cust_id = 1004 
ORDER BY cust_id, year, month;
  
/*  
  CUST_ID       YEAR      MONTH      SALES   REFUSALS CANCELLATIONS   RECEIVED
---------- ---------- ---------- ---------- ---------- ------------- ----------
      1004       2014         11    6062364          0             0          0
*/


SELECT * FROM invoice_details WHERE invoice_id = 61 ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        61          1         35       1090          2       4578
        61          2         40        700          3       6720
        61          3         55       1410          4       9306
        61          4        755       6300          5    1141560
*/

SELECT * FROM product_monthly_stats WHERE year = 2014 AND month = 11 AND 
  product_id IN (SELECT product_id FROM invoice_details 
      WHERE invoice_id = 61) 
ORDER BY product_id, year, month;
/*  
     SALES   REFUSALS CANCELLATIONS PRODUCT_ID       YEAR      MONTH
---------- ---------- ------------- ---------- ---------- ----------
     42728          0             0          2       2014         11
     34720          0             0          3       2014         11
     86856          0             0          4       2014         11
   5898060          0             0          5       2014         11
*/


-- we'll remove the forth row of invoice 61 (row numbering will be preserved)
DELETE FROM invoice_details WHERE invoice_id = 61 AND row_number = 4 ;


-- check the new values (after the trigger oparations)

SELECT invoice_id, invoice_date, cust_id, invoice_vat, 
  invoice_amount,n_of_rows
FROM invoices WHERE invoice_id = 61 ;
/*
INVOICE_ID INVOICE_DA    CUST_ID INVOICE_VAT INVOICE_AMOUNT  N_OF_ROWS
---------- ---------- ---------- ----------- -------------- ----------
        61 01-11-2014       1004       20604         164304          3
*/ 


SELECT cust_id, cust_name, current_balance FROM customers WHERE cust_id = 1004  ;
/*
   CUST_ID CUST_NAME                                          CURRENT_BALANCE
---------- -------------------------------------------------- ---------------
      1004 Client D                                                  20805352
*/

SELECT * FROM months WHERE year = 2014 AND month = 11 ;
/*
     YEAR      MONTH SALES_TOTAL REFUSALS_TOTAL CANCELLATIONS_TOTAL RECEIVED_TOTAL
---------- ---------- ----------- -------------- ------------------- --------------
      2014         11      164304              0                   0              0
*/


SELECT * FROM customer_monthly_stats WHERE year = 2014 AND month = 11 AND cust_id = 1004 ;
  
/*  
   CUST_ID       YEAR      MONTH      SALES   REFUSALS CANCELLATIONS   RECEIVED
---------- ---------- ---------- ---------- ---------- ------------- ----------
      1004       2014         11     164304          0             0          0
*/


SELECT * FROM invoice_details WHERE invoice_id = 61 ;
/*
INVOICE_ID ROW_NUMBER   QUANTITY UNIT_PRICE PRODUCT_ID    ROW_VAT
---------- ---------- ---------- ---------- ---------- ----------
        61          1         35       1090          2       4578
        61          2         40        700          3       6720
        61          3         55       1410          4       9306
*/

SELECT * FROM product_monthly_stats WHERE year = 2014 AND month = 11 AND 
  product_id IN (SELECT product_id FROM invoice_details 
      WHERE invoice_id = 61) 
ORDER BY product_id, year, month;
/*  
     SALES   REFUSALS CANCELLATIONS PRODUCT_ID       YEAR      MONTH
---------- ---------- ------------- ---------- ---------- ----------
     42728          0             0          2       2014         11
     34720          0             0          3       2014         11
     86856          0             0          4       2014         11
*/

COMMIT ;

----------------------------------------------------------------------------------------
--              check the triggers with a couple of queries
----------------------------------------------------------------------------------------

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


