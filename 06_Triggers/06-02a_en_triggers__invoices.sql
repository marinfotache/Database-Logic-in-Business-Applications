/*

This script works with `sales` database that was created by launching (in Oracle SQL Developer) five previous scripts:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-2_fixed_DDL_script_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-3_add_constraints_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01a_en_sequences.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01b_en_data_cleaning__surrogate_keys.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01c_en_cascade_updates.sql




See also the `sales` database schema and denormalized attributes in presentation:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-02_en_Triggers%20-%20part%202.pptx

 

--=====================================================================================
--      Triggers of table INVOICES will manage the denormalized attributes/tables
--=====================================================================================

a. Tasks for the INSERT - BEFORE - ROW trigger

	When inserting a new record in table INVOICES, the following of its 
		attributes must be set on 0 (since the invoice has no lines yes):
	- INVOICES.invoice_VAT
	- INVOICES.invoice_amount
	- INVOICES.amount_received
	- INVOICES.amount_refused
	- INVOICES.n_of_rows


b. Tasks for the INSERT - AFTER - ROW trigger

	After inserting a new record in table INVOICES, one must check
		if this is the first invoice for its month (year + month)
	
	b.1 If no record exists in table MONTHS for current (inserted)
		invoice's month, then INSERT a record into MONTHS!
		
	b.2 If no record exists in table CUSTOMER_MONTHLY_STATS for current (inserted)
		invoice's month and customer, then INSERT a record into CUSTOMER_MONTHLY_STATS!
		
*/



----------------------------------------------------------------------------------------
-- but first, we create a package called "pac_sales_2" with some functions for testing
--   the existence of records in the three denormalized tables, MONTHS,
--   CUSTOMER_MONTHLY_STATS and PRODUCT_MONTHLY_STATS (we won't work with 
--    PRODUCT_MONTHLY_STATS for now, but we'll still create the function for further 
--     triggers (see `06-02b...`))
----------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pac_sales_2  AS
	-- this function checks if, for a given year and month, a record exists in table MONTHS
    FUNCTION f_months (
        year_ months.year%TYPE, 
        month_ months.month%TYPE) RETURN BOOLEAN ; 

	-- this function checks if, for a given year, month and customer,
	--	 a record exists in table CUSTOMER_MONTHLY_STATS
    FUNCTION f_customer_monthly_stats (
        cust_id_ customer_monthly_stats.cust_id%TYPE, 
        year_ customer_monthly_stats.year%TYPE, 
        month_ customer_monthly_stats.month%TYPE) RETURN BOOLEAN ; 

	-- this function checks if, for a given year, month and product,
	--	 a record exists in table PRODUCT_MONTHLY_STATS
    FUNCTION f_product_monthly_stats (
        product_id_ product_monthly_stats.product_id%TYPE, 
        year_ product_monthly_stats.year%TYPE, 
        month_ product_monthly_stats.month%TYPE) RETURN BOOLEAN ; 
        
END ;
/


-----------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_sales_2  AS
-----------------------------------------------------------------

-- this function checks if, for a given year and month, 
-- 		a record exists in table MONTHS
FUNCTION f_months (
        year_ months.year%TYPE, 
        month_ months.month%TYPE) RETURN BOOLEAN 
IS
    v_dummy INTEGER ;
BEGIN
    SELECT 1 INTO v_dummy FROM months
    WHERE year = year_ AND month = month_ ;
    RETURN TRUE ;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE ;
END f_months;         

-----------------------------------------------------------------
-- this function checks if, for a given year, month and customer,
--	 a record exists in table CUSTOMER_MONTHLY_STATS
FUNCTION f_customer_monthly_stats (
        cust_id_ customer_monthly_stats.cust_id%TYPE, 
        year_ customer_monthly_stats.year%TYPE, 
        month_ customer_monthly_stats.month%TYPE) RETURN BOOLEAN 
IS
    v_dummy INTEGER ;
BEGIN
    SELECT 1 INTO v_dummy FROM customer_monthly_stats
    WHERE cust_id = cust_id_ AND year = year_ AND month = month_ ;
    RETURN TRUE ;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE ;
END f_customer_monthly_stats;         

-----------------------------------------------------------------
-- this function checks if, for a given year, month and product,
--	 a record exists in table PRODUCT_MONTHLY_STATS
FUNCTION f_product_monthly_stats (
    product_id_ product_monthly_stats.product_id%TYPE, 
    year_ product_monthly_stats.year%TYPE, 
    month_ product_monthly_stats.month%TYPE) RETURN BOOLEAN 
IS
    v_dummy INTEGER ;
BEGIN
    SELECT 1 INTO v_dummy FROM product_monthly_stats
    WHERE product_id = product_id_ AND year = year_ AND month = month_ ;
    RETURN TRUE ;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE ;
END f_product_monthly_stats;             

END ;
/


----------------------------------------------------------------------------------------
--  the insert trigger - "trg_invoices_ins_upd_bef_row" - 
--      was created in script 06-01b_en_...

-- we delete it and create separated triggers for insert, update and delete
--   

DROP TRIGGER trg_invoices_ins_upd_bef_row 
/

------------------------------------------------------------------------------------------
-- Tasks for the INSERT trigger:
-- * manage the surrogate key (invoice_id) - BEFORE ROW
-- * update denormalized tables MONTHS and CUSTOMER_MONTHLY_STATS
------------------------------------------------------------------------------------------
-- 1. insert trigger for INVOICES: BEFORE-ROW
--  we place here all the commands for changing current inserted row values
CREATE OR REPLACE TRIGGER trg_invoices_ins1
	BEFORE INSERT ON invoices FOR EACH ROW
DECLARE	
    v_invoice_id invoices.invoice_id%TYPE ;
    v_dummy INTEGER ;
BEGIN 
    -- we'll use a block inside the trigger that will catch any primary key violation
    BEGIN
        LOOP -- keep looping until the value generated by the sequence was not already
             -- assigned to the surrogate key      
            v_invoice_id := seq__invoice_id.NextVal  ;
            SELECT 1 INTO v_dummy FROM invoices WHERE invoice_id = v_invoice_id ;  
        END LOOP ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            :NEW.invoice_id := seq__invoice_id.CurrVal  ;
    END ;
    -- here the nested anonymous block finishes
        
    -- a newly inserted invoice has...
    :NEW.invoice_VAT := 0 ;
    :NEW.invoice_amount := 0 ;
    :NEW.amount_received := 0 ;
    :NEW.amount_refused := 0 ;
    :NEW.n_of_rows := 0 ;
                
	-- convert values for some of the attributes
	:NEW.is_closed := UPPER(:NEW.is_closed) ;

END ;
/

-- 2. insert trigger for INVOICES: AFTER-ROW
--   here we update the denormalized attributes/tables
CREATE OR REPLACE TRIGGER trg_invoices_ins2
	AFTER INSERT ON invoices FOR EACH ROW
BEGIN 	
	-- we test if for invoice's customer there is a record in the current month
	--   in table CUSTOMER_MONTHLY_STATS; if not, we'll insert one record
	--   ..., but, before that, we'll check if table MONTHS has a record for 
	-- the current month
	IF pac_sales_2.f_months (EXTRACT (YEAR FROM :NEW.invoice_date), 
	        EXTRACT (MONTH FROM :NEW.invoice_date)) = FALSE THEN
	    INSERT INTO months VALUES (EXTRACT (YEAR FROM :NEW.invoice_date), 
	        EXTRACT (MONTH FROM :NEW.invoice_date), 0, 0, 0, 0) ;
 	END IF ;	

	-- CUSTOMER_MONTHLY_STATS
	IF pac_sales_2.f_customer_monthly_stats (:NEW.cust_id, 
	        EXTRACT (YEAR FROM :NEW.invoice_date), 
	        EXTRACT (MONTH FROM :NEW.invoice_date)) = FALSE THEN
	    INSERT INTO customer_monthly_stats VALUES (:NEW.cust_id, 
	        EXTRACT (YEAR FROM :NEW.invoice_date), 
	        EXTRACT (MONTH FROM :NEW.invoice_date),
	        0, 0, 0, 0) ;
 	END IF ;	
END ;
/

DELETE FROM invoice_details ;
DELETE FROM product_monthly_stats ;
DELETE FROM customer_monthly_stats ;
DELETE FROM invoices ;

INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1111, DATE'2013-08-01', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id, comments)
    VALUES (1112, DATE'2013-08-01', pac_sales.f_cust_id('Client D'), 'Probleme cu transportul');
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1113, DATE'2013-08-01', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1114, DATE'2013-08-01', pac_sales.f_cust_id('Client F SA'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1115, DATE'2013-08-02', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id, comments)
    VALUES (1116, DATE'2013-08-02', pac_sales.f_cust_id('Client G SRL'), 'Pretul propus initial a fost modificat');
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1117, DATE'2013-08-03', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1118, DATE'2013-08-04', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1119, DATE'2013-08-07', pac_sales.f_cust_id('Client C SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1120, DATE'2013-08-07', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1121, DATE'2013-08-07', pac_sales.f_cust_id('Client D'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1122, DATE'2013-08-07', pac_sales.f_cust_id('Client D'));

INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (2111, DATE'2013-08-14', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id, comments)
    VALUES (2112, DATE'2013-08-14', pac_sales.f_cust_id('Client D'),
        'Probleme cu transportul');
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (2113, DATE'2013-08-14', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (2115, DATE'2013-08-15', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id, comments) 
    VALUES (2116, DATE'2013-08-15', pac_sales.f_cust_id('Client G SRL'),
        'Pretul propus initial a fost modificat');
INSERT INTO invoices (invoice_number, invoice_date, cust_id)   
    VALUES (2117, DATE'2013-08-16', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (2118, DATE'2013-08-16', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (2119, DATE'2013-08-21', pac_sales.f_cust_id('Client C SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (2121, DATE'2013-08-21', pac_sales.f_cust_id('Client D'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (2122, DATE'2013-08-22', pac_sales.f_cust_id('Client E SRL'));

INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (3111, DATE'2013-09-01', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id, comments)
    VALUES (3112, DATE'2013-09-01', pac_sales.f_cust_id('Client D'),
        'Probleme cu transportul');
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (3113, DATE'2013-09-02', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (3115, DATE'2013-09-02', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id, comments)
    VALUES (3116, DATE'2013-09-10', pac_sales.f_cust_id('Client G SRL'),
        'Pretul propus initial a fost modificat');
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (3117, DATE'2013-09-10', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (3118, DATE'2013-09-17', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (3119, DATE'2013-10-07', pac_sales.f_cust_id('Client C SRL'));
COMMIT ;

-- check some of the triggers
/*
SELECT * FROM invoices ;
SELECT * FROM customers ;
SELECT * FROM months ;
SELECT * FROM customer_monthly_stats ;
*/

------------------------------------------------------------------------------------------
--                          Mutating tables - part 1
------------------------------------------------------------------------------------------

-- we want to insert records for 2014 by simply copying the invoices 
--  from 2013 ("invoice_number" will be incremented  by 10000 and 
--    "invoice_date" will be incremented by 365 days)
   
INSERT INTO invoices (invoice_number, invoice_date, cust_id) 
    SELECT invoice_number + 10000, invoice_date + 365, cust_id 
    FROM invoices ;

/* the displayed error message is:

Error starting at line : 2 in command -
INSERT INTO invoices (invoice_number, invoice_date, cust_id) 
    SELECT invoice_number + 10000, invoice_date + 365, cust_id 
    FROM invoices
Error report -
ORA-04091: table SALES.INVOICES is mutating, trigger/function may not see it
ORA-06512: at "SALES.TRG_INVOICES_INS1", line 10
ORA-04088: error during execution of trigger 'SALES.TRG_INVOICES_INS1'
*/


------------------------------------------------------------------------------------------
-- Tasks for the INSERT trigger:
-- * manage the surrogate key (invoice_id) - BEFORE ROW
-- * update denormalized tables MONTHS and CUSTOMER_MONTHLY_STATS
------------------------------------------------------------------------------------------
-- 1. insert trigger for INVOICES: BEFORE-ROW
--  we place here all the commands for changing current inserted row values
CREATE OR REPLACE TRIGGER trg_invoices_ins1
	BEFORE INSERT ON invoices FOR EACH ROW
DECLARE	
    PRAGMA AUTONOMOUS_TRANSACTION;  -- this is new
    v_invoice_id invoices.invoice_id%TYPE ;
    v_dummy INTEGER ;
BEGIN 
    -- we'll use a block inside the trigger that will catch any primary key violation
    BEGIN
        LOOP -- keep looping until the value generated by the sequence was not already
             -- assigned to the surrogate key      
            v_invoice_id := seq__invoice_id.NextVal  ;
            SELECT 1 INTO v_dummy FROM invoices WHERE invoice_id = v_invoice_id ;  
        END LOOP ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            :NEW.invoice_id := seq__invoice_id.CurrVal  ;
            COMMIT ;
    END ;
    -- here the nested anonymous block finishes
        
    -- a newly inserted invoice has...
    :NEW.invoice_VAT := 0 ;
    :NEW.invoice_amount := 0 ;
    :NEW.amount_received := 0 ;
    :NEW.amount_refused := 0 ;
    :NEW.n_of_rows := 0 ;
                
	-- convert values for some of the attributes
	:NEW.is_closed := UPPER(:NEW.is_closed) ;

END ;
/

-- Another try:
-- we want to insert records for 2014 by simply copying the invoices 
--  from 2013 ("invoice_number" will be incremented  by 10000 and 
--    "invoice_date" will be incremented by 365 days)
   
INSERT INTO invoices (invoice_number, invoice_date, cust_id) 
    SELECT invoice_number + 10000, invoice_date + 365, cust_id 
    FROM invoices ;

COMMIT ;

-- check the triggers
/*
SELECT * FROM invoices ;
SELECT * FROM customers ;
SELECT * FROM months ;
SELECT * FROM customer_monthly_stats ;
*/  



/*  
------------------------------------------------------------------------------------------
Tasks for the UPDATE triggers of table INVOICES:
	 * update "customers.current_balance"
 	 * update denormalized tables MONTHS, CUSTOMER_MONTHLY_STATS, and PRODUCT_MONTHLY_STATS

When "invoice_date" is changed, check if the new month is different from the 
older one; if so: 
- in table MONTHS:
			* decrease "sales_total" with the older "invoice_amount" for the older month 
			* increase "sales_total" with the newer "invoice_amount" for the newer month; 
				(do not forget to check there is a record in MONTHS for the new month)  


When the year+month of "invoice_date" remains unchanged, just:
	* update "sales_total" in table MONTHS
	* update "sales_total" in table CUSTOMER_MONTHLY_STATS


*/
------------------------------------------------------------------------------------------
-- first UPDATE trigger for INVOICES: BEFORE-ROW
CREATE OR REPLACE TRIGGER trg_invoices_upd1
	BEFORE UPDATE ON invoices FOR EACH ROW
BEGIN 
	-- convert values for some of the attributes
	:NEW.is_closed := UPPER(:NEW.is_closed) ;
END ;
/


------------------------------------------------------------------------------------------
-- second UPDATE trigger for INVOICES: AFTER-ROW

-- this command is necessary for dealing with a compiler error
ALTER SESSION SET PLSCOPE_SETTINGS = 'IDENTIFIERS:NONE';


-- now, the trigger
CREATE OR REPLACE TRIGGER trg_invoices_upd2
	AFTER UPDATE ON invoices FOR EACH ROW
DECLARE
    v_dummy INTEGER := 0;	
BEGIN 

    -- A.1 if the invoice month was changed...
    IF EXTRACT(YEAR FROM :NEW.invoice_date) <> EXTRACT(YEAR FROM :OLD.invoice_date) OR
			EXTRACT(MONTH FROM :NEW.invoice_date) <> EXTRACT(MONTH FROM :OLD.invoice_date) THEN
			
		-- the invoice's amount and VAT must be transferred from the older month to 
		--	the new month for all three denormalized tables:		
		--		* MONTHS
		--      * CUSTOMER_MONTHLY_STATS (also considering the customer has changed)
		--		* PRODUCT_MONTHLY_STATS 	
			
			
        -- first, in table MONTHS decrease "sales_total" with the corresponding 
        -- 		INVOICES attribute OLD value
        UPDATE months
        SET sales_total = sales_total - :OLD.invoice_amount
        WHERE year = EXTRACT(YEAR FROM :OLD.invoice_date) 
            AND month =  EXTRACT(MONTH FROM :OLD.invoice_date) ;

        -- ... then, also in table MONTHS, increase "sales_total" with invoice new "invoice_amount"
        -- 
        --  Note: we do not update "refusals_total", and "received_total" with the 
        --          corresponding INVOICES attributes NEW values since refusals and receipts can
        --          occur in other months than the invoice issue month !
        
    	--  before insert, we'll check if table MONTHS has a record for the (new) current month
	    IF pac_sales_2.f_months (EXTRACT (YEAR FROM :NEW.invoice_date), 
	            EXTRACT (MONTH FROM :NEW.invoice_date)) = FALSE THEN
	        INSERT INTO months VALUES (EXTRACT (YEAR FROM :NEW.invoice_date), 
	            EXTRACT (MONTH FROM :NEW.invoice_date), 0, 0, 0, 0) ;
 	    END IF ;	

        -- now, the update
        UPDATE months
        SET sales_total = sales_total + :NEW.invoice_amount
        WHERE year = EXTRACT(YEAR FROM :NEW.invoice_date) 
            AND month =  EXTRACT(MONTH FROM :NEW.invoice_date) ;


        -- second, in table CUSTOMER_MONTHLY_STATS decrease "sales"
        --  with the corresponding INVOICES attribute OLD value
        UPDATE customer_monthly_stats
        SET sales = sales - :OLD.invoice_amount
        WHERE year = EXTRACT(YEAR FROM :OLD.invoice_date) 
            AND month =  EXTRACT(MONTH FROM :OLD.invoice_date) AND 
            	cust_id = :OLD.cust_id ;

        -- increase "customer_monthly_stats.sales" with invoice new "invoice_amount"
        
    	--  before insert, we'll check if table MONTHS has a record for the (new) current month
	    IF pac_sales_2.f_customer_monthly_stats (:NEW.cust_id,
	    		EXTRACT (YEAR FROM :NEW.invoice_date), 
	            EXTRACT (MONTH FROM :NEW.invoice_date)) = FALSE THEN
	        INSERT INTO customer_monthly_stats VALUES (:NEW.cust_id, EXTRACT (YEAR FROM :NEW.invoice_date), 
	            EXTRACT (MONTH FROM :NEW.invoice_date), 0, 0, 0, 0) ;
 	    END IF ;	

        -- now, the update
        UPDATE customer_monthly_stats
        SET sales = sales + :NEW.invoice_amount
        WHERE year = EXTRACT(YEAR FROM :NEW.invoice_date) 
            AND month =  EXTRACT(MONTH FROM :NEW.invoice_date) AND 
            	cust_id = :NEW.cust_id ;
            
            
        -- now, the most interesting part (in this trigger):
        --   update PRODUCT_MONTHLY_STATS, decreasing the product sales for the former month
        --		and former products,
        --     and increasing the product sales for the new month and the new products
        --  (we'll consider the case that not only the month, but also the products might change)
        
        -- we'll use (twice) a cursor for the products sold in the current invoice
        
        -- ... one for the former month (and former quantities, unit prices and products)
        FOR rec_row IN (SELECT * FROM invoice_details 
                WHERE invoice_id = :OLD.invoice_id) LOOP
            UPDATE product_monthly_stats
            SET sales = sales - (rec_row.quantity * rec_row.unit_price + rec_row.row_vat) 
            WHERE year = EXTRACT(YEAR FROM :OLD.invoice_date) 
                AND month =  EXTRACT(MONTH FROM :OLD.invoice_date)
                AND product_id = rec_row.product_id ;
        END LOOP ;        

        -- ... and another one for the new month (and new quantities, unit prices and products)        
        FOR rec_row IN (SELECT * FROM invoice_details 
                WHERE invoice_id = :NEW.invoice_id) LOOP
                
            IF pac_sales_2.f_product_monthly_stats (rec_row.product_id, 
                    EXTRACT (YEAR FROM :NEW.invoice_date), 
                    EXTRACT (MONTH FROM :NEW.invoice_date) ) = FALSE THEN
	            INSERT INTO product_monthly_stats (YEAR, MONTH, product_id, sales, refusals,
	                    cancellations) 
	            VALUES (  EXTRACT (YEAR FROM :NEW.invoice_date), 
	                    EXTRACT (MONTH FROM :NEW.invoice_date),
	                    rec_row.product_id, rec_row.quantity * rec_row.unit_price + rec_row.row_vat,
	                0, 0) ;
            ELSE 
                UPDATE product_monthly_stats 
                SET sales = sales + (rec_row.quantity * rec_row.unit_price + rec_row.row_vat) 
                WHERE year = EXTRACT(YEAR FROM :NEW.invoice_date) 
                    AND month =  EXTRACT(MONTH FROM :NEW.invoice_date)
                        AND product_id = rec_row.product_id ;
            END IF ;            
        END LOOP ;        
                            
    ELSE
    	
    	-- A.2 here (this point will be reached if) the invoice month has not been changed 
    	
    	-- we'll test if the invoice's customer was changed
    
 		IF :NEW.cust_id <> :OLD.cust_id THEN
    	
    		-- A.2.1 here the invoice month is unchanged, but the invoice customer was changed!
    		
	        -- ... decrease the balance for the former customer
    	    UPDATE customers 
			SET current_balance = current_balance - (:OLD.invoice_amount - :OLD.amount_refused
            	- :OLD.amount_received) WHERE  cust_id = :OLD.cust_id ;
        	-- ... increase the balance for the NEW customer     
        	UPDATE customers 
			SET current_balance = current_balance + (:NEW.invoice_amount - :NEW.amount_refused
            	- :NEW.amount_received) WHERE cust_id = :NEW.cust_id ;
    		
    		
    		-- ... transfer the invoice amount from the old to the new customer in table 
    		--   CUSTOMER_MONTHLY_STATS

		    -- decrease the old values for the old customer and the old month
    		UPDATE customer_monthly_stats
    		SET sales = sales - :OLD.invoice_amount
 		    WHERE year = EXTRACT(YEAR FROM :OLD.invoice_date) AND 
        		month =  EXTRACT(MONTH FROM :OLD.invoice_date) AND cust_id = :OLD.cust_id ;

		    -- increase the new values for the new customer and the new month
			IF pac_sales_2.f_customer_monthly_stats (:NEW.cust_id, 
	        		EXTRACT (YEAR FROM :NEW.invoice_date), EXTRACT (MONTH FROM :NEW.invoice_date)) = FALSE THEN
	    		INSERT INTO customer_monthly_stats VALUES (:NEW.cust_id, 
	        		EXTRACT (YEAR FROM :NEW.invoice_date), EXTRACT (MONTH FROM :NEW.invoice_date),
	        		0, 0, 0, 0) ;
 			END IF ;	    
		    UPDATE customer_monthly_stats
    		SET sales = sales + :NEW.invoice_amount
		    WHERE year = EXTRACT(YEAR FROM :NEW.invoice_date) AND 
        		month =  EXTRACT(MONTH FROM :NEW.invoice_date) AND cust_id = :NEW.cust_id ;
    		
    		 		
    		
			-- we are not done yet!    		
    		-- we can experience a `nightmarish` situation related to receipts:
 	        --  an invoice was issued in September 2013 (influencing values in tables
 	        --		MONTHS and CUSTOMER_MONTHLY_STATS for September 2013), 
 	        --  then partially paid in October 2013 (also influencing values in tables
 	        --		MONTHS and CUSTOMER_MONTHLY_STATS for October 2013 );
        	--   in November, surprise! we discover that the invoice customer was wrongly specified!!!
        
        
        	-- Solution:
        	-- as the invoice's customer was changed (not a very realistic situation, to be fair),
        	--   we will loop through:
        	-- 		* all the invoice payments, and, depending on `RECEIPTS.receipt_date`,
        	--   			we'll update  CUSTOMER_MONTHLY_STATS. 
        	-- 		* all the invoice refusals, and, depending on `REFUSAL.refusal_dt`,
        	--   			we'll update  CUSTOMER_MONTHLY_STATS.
        	-- 		* all the invoice cancellations (at most one cancellation per invoice), and, 
        	-- 				depending on `cancelled_invoices.cancellation_dt`,
        	--   			we'll update  CUSTOMER_MONTHLY_STATS.

        	
        	-- we load in a cursor all the payments for the current invoice
        	FOR rec_payments IN (SELECT * FROM receipt_details NATURAL JOIN receipts
        		WHERE invoice_id = :NEW.invoice_id ORDER BY receipt_date) LOOP
        		
        		-- discharge the payment from the former customer
        		UPDATE customer_monthly_stats
        		SET received = received - rec_payments.amount
        		WHERE cust_id = :OLD.cust_id AND year = EXTRACT (YEAR FROM rec_payments.receipt_date) AND 
        			month = EXTRACT (MONTH FROM rec_payments.receipt_date) ;
        			 
        		-- charge the payment to the new customer
        		UPDATE customer_monthly_stats
        		SET received = received + rec_payments.amount
        		WHERE cust_id = :NEW.cust_id AND year = EXTRACT (YEAR FROM rec_payments.receipt_date) AND 
        			month = EXTRACT (MONTH FROM rec_payments.receipt_date) ;
        	END LOOP ;


        	-- we load in a cursor all the refusals for the current invoice
        	FOR rec_refusals IN (SELECT * FROM refusals
        		WHERE invoice_id = :NEW.invoice_id ORDER BY refusal_dt) LOOP
        		
        		-- discharge the refusal from the former customer
        		UPDATE customer_monthly_stats
        		SET refusals = refusals - rec_refusals.refusal_amount
        		WHERE cust_id = :OLD.cust_id AND year = EXTRACT (YEAR FROM rec_refusals.refusal_dt) AND 
        			month = EXTRACT (MONTH FROM rec_refusals.refusal_dt) ;
        			 
        		-- charge the payment to the new customer
        		UPDATE customer_monthly_stats
        		SET refusals = refusals + rec_refusals.refusal_amount
        		WHERE cust_id = :NEW.cust_id AND year = EXTRACT (YEAR FROM rec_refusals.refusal_dt) AND 
        			month = EXTRACT (MONTH FROM rec_refusals.refusal_dt) ;
        	END LOOP ;


        	-- we load in a cursor all the cancellation (actually there is no more 
        	--    than one cancellation per invoice) for the current invoice
        	FOR rec_cancel IN (SELECT * FROM cancelled_invoices NATURAL JOIN invoices
        		WHERE invoice_id = :NEW.invoice_id) LOOP
        		
        		-- discharge all the invoice amount (that means invoice cancellation) from the former customer
        		UPDATE customer_monthly_stats
        		SET cancellations = cancellations - rec_cancel.invoice_amount
        		WHERE cust_id = :OLD.cust_id AND year = EXTRACT (YEAR FROM rec_cancel.cancellation_dt) AND 
        			month = EXTRACT (MONTH FROM rec_cancel.cancellation_dt) ;
        			 
        		-- charge all the invoice amount to the new customer
        		UPDATE customer_monthly_stats
        		SET cancellations = cancellations + rec_cancel.invoice_amount
        		WHERE cust_id = :NEW.cust_id AND year = EXTRACT (YEAR FROM rec_cancel.cancellation_dt) AND 
        			month = EXTRACT (MONTH FROM rec_cancel.cancellation_dt) ;
        	END LOOP ;
        
        ELSE
        
            -- A.2.2 here neither the invoice month nor the customer were changed

			-- so, we check of the invoice amount was changed

	        IF COALESCE(:NEW.invoice_amount,0) <> COALESCE(:OLD.invoice_amount,0) THEN
      	          
	            -- A.2.2.1 here neither the invoice month nor the customer were changed,
	            --   but the invoice amount
	            
	            -- to do:
	            -- * update "customers.current_balance"
	            -- * update "months.sales_total"
	            -- * update "customer_monthly_stats.sales"

				
				-- * update "customers.current_balance"
				UPDATE customers 
        		SET current_balance = current_balance - :OLD.invoice_amount + :NEW.invoice_amount
		        WHERE cust_id = :NEW.cust_id ;      	          


	            -- * update "months.sales_total"      	          
            	UPDATE months
            	SET sales_total = sales_total - :OLD.invoice_amount + :NEW.invoice_amount
	            WHERE year = EXTRACT(YEAR FROM :NEW.invoice_date) 
    	            AND month =  EXTRACT(MONTH FROM :NEW.invoice_date) ; 

	            -- * update "customer_monthly_stats.sales"    	            
			    UPDATE customer_monthly_stats
    			SET sales = sales - :OLD.invoice_amount + :NEW.invoice_amount
				WHERE year = EXTRACT(YEAR FROM :OLD.invoice_date) AND 
        			month =  EXTRACT(MONTH FROM :OLD.invoice_date) AND cust_id = :OLD.cust_id ;      
    	             
			END IF ;			
            
        END IF ;
    END IF ;        
END ;
/



/*
------------------------------------------------------------------------------------------
--      Tasks for the DELETE trigger:
-- * update "customers.current_balance"
-- * update "months.sales_total" 
-- * update "customer_monthly_stats.sales"
------------------------------------------------------------------------------------------
		
*/

-- 1. delete trigger for INVOICES: BEFORE-ROW
--  we do not need such a trigger (at least, for the moment)

-- 2. delete trigger for INVOICES: AFTER-ROW
--   here we update the denormalized attributes/tables
CREATE OR REPLACE TRIGGER trg_invoices_del2
	AFTER DELETE ON invoices FOR EACH ROW
BEGIN 

    -- update the balance for the deleted invoice customer
    UPDATE customers 
	SET current_balance = current_balance - :OLD.invoice_amount 
    WHERE  cust_id = :OLD.cust_id ;
        
    -- update MONTHS   
    UPDATE months
    SET sales_total = sales_total - :OLD.invoice_amount
    WHERE year = EXTRACT(YEAR FROM :OLD.invoice_date) 
        AND month =  EXTRACT(MONTH FROM :OLD.invoice_date) ;
        
    -- update CUSTOMER_MONTHLY_STATS
    UPDATE customer_monthly_stats
    SET sales = sales - :OLD.invoice_amount
    WHERE year = EXTRACT(YEAR FROM :OLD.invoice_date) AND 
        month =  EXTRACT(MONTH FROM :OLD.invoice_date) AND cust_id = :OLD.cust_id ;

	
END ;
/

------------------------------------------------------------------------------------------
-- we'll check triggers functionality in the next script, along with the INVOICE_DETAILS's
--      triggers
------------------------------------------------------------------------------------------

