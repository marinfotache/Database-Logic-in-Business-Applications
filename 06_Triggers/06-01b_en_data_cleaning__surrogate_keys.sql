/*
This script works with `sales` database that was created by launching (in Oracle SQL
Developer) three previous scripts:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-2_fixed_DDL_script_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-3_add_constraints_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01a_en_sequences.sql

*/

DELETE FROM invoices ;
DELETE FROM customers ;
DELETE FROM postal_codes ;
DELETE FROM counties ;
COMMIT ;


--================================================================================
/* 
	Just for displaying the triggers order, we'll create a couple of triggers
	  that do almost nothing
*/      
--================================================================================
-----------------------------------------------------------
-- this is INSERT - BEFORE  - STATEMENT trigger
CREATE OR REPLACE TRIGGER trg_counties_ins_1
	BEFORE INSERT ON counties
BEGIN 
	DBMS_OUTPUT.PUT_LINE('I am executing the trigger INSERT - BEFORE - STATEMENT') ;
END ;
/
-----------------------------------------------------------
-- this is INSERT - BEFORE  - ROW trigger
CREATE OR REPLACE TRIGGER trg_counties_ins_2
	BEFORE INSERT ON counties FOR EACH ROW
BEGIN 
	DBMS_OUTPUT.PUT_LINE('I am executing the trigger INSERT - BEFORE - ROW') ;
	DBMS_OUTPUT.PUT_LINE(' The values to be inserted are: |' || :NEW.county_code || '|'
		|| :NEW.county_name || '|' || :NEW.county_region) ;	
END ;
/
-----------------------------------------------------------
-- this is INSERT - AFTER - ROW trigger
CREATE OR REPLACE TRIGGER trg_counties_ins_3
	AFTER INSERT ON counties FOR EACH ROW
BEGIN 
	DBMS_OUTPUT.PUT_LINE('I am executing the triggere INSERT - AFTER - ROW') ;
	DBMS_OUTPUT.PUT_LINE(' The inserted values were: |' || :NEW.county_code || '|'
		|| :NEW.county_name || '|' || :NEW.county_region) ;

END ;
/
-----------------------------------------------------------
-- this is INSERT - AFTER - STATEMENT trigger
CREATE OR REPLACE TRIGGER trg_counties_ins_4
	AFTER INSERT ON counties
BEGIN 
	DBMS_OUTPUT.PUT_LINE('I am executing the triggere INSERT - AFTER - STATEMENT') ;
END ;
/

-- test
DELETE FROM counties ;
INSERT INTO counties VALUES ('IS', 'Iasi', 'Moldova') ;

-- check this
INSERT INTO counties VALUES ('VN', 'Vrancea', 'Mdova') ;
-- notice which triggers are launched

DELETE FROM counties ;
INSERT INTO counties VALUES ('IS', 'Iasi', 'Moldova') ;
INSERT INTO counties VALUES ('VN', 'Vrancea', 'Moldova') ;
INSERT INTO counties VALUES ('NT', 'Neamt', 'Moldova') ;
INSERT INTO counties VALUES ('SV', 'Suceava', 'Moldova') ;
INSERT INTO counties VALUES ('VS', 'Vaslui', 'Moldova') ;
INSERT INTO counties VALUES ('TM', 'Timis', 'Banat') ;
SELECT * FROM counties ;

-- do not save (make permanents) the inserts 
ROLLBACK ;
SELECT * FROM counties ;

-- now insert all initial record in table "counties" in 
-- a single statement
INSERT INTO counties 
	SELECT 'IS', 'Iasi', 'Moldova' FROM dual UNION
	SELECT 'VN', 'Vrancea', 'Moldova' FROM dual UNION
	SELECT 'NT', 'Neamt', 'Moldova' FROM dual UNION
	SELECT 'SV', 'Suceava', 'Moldova' FROM dual UNION
	SELECT 'VS', 'Vaslui', 'Moldova' FROM dual UNION
	SELECT 'TM', 'Timis', 'Banat' FROM dual ;

/*	
SELECT * FROM counties ;
*/
-- again, do not save (make permanents) the inserts 
ROLLBACK ;

/*
SELECT * FROM counties ;
*/


--================================================================================
/* In table "counties" we defined some CHECK constraints for data to be uniformly
    gathered and properly displayed when sorting.
    
    We can prevent some constraint violation by cleaning data on-the-fly, using
    triggers of type BEFORE-ROW

    Take care! Only BEFORE-ROW triggers allow this type of operation.   
*/      
--================================================================================

-----------------------------------------------------------
-- Example:  
DELETE FROM counties ;
INSERT INTO counties VALUES ('Is', 'Iasi', 'MolDOva') ;

-----------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_counties_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON counties FOR EACH ROW
BEGIN 
	-- attribute values conversion 
	:NEW.county_code := UPPER(:NEW.county_code) ;
	:NEW.county_name := UPPER(SUBSTR(:NEW.county_name,1,1)) || 
	    SUBSTR(:NEW.county_name,2,LENGTH(:NEW.county_name)-1) ;
	:NEW.county_region := INITCAP(:NEW.county_region) ;

END ;
/

-----------------------------------------------------------
-- Now, all the inserts below should work:
DELETE FROM counties ;
INSERT INTO counties VALUES ('Is', 'Iasi', 'Moldova') ;
INSERT INTO counties VALUES ('vn', 'vrancea', 'Moldova') ;
INSERT INTO counties VALUES ('NT', 'neamt', 'moldova') ;
INSERT INTO counties VALUES ('SV', 'Suceava', 'Moldova') ;
INSERT INTO counties VALUES ('VS', 'Vaslui', 'Moldova') ;
INSERT INTO counties VALUES ('TM', 'Timis', 'Banat') ;
COMMIT ;

--================================================================
-- In order to suppress further display of messages when inserting
-- rows in table "counties", we drop the un-useful triggers ;
DROP TRIGGER trg_counties_ins_1 ;
DROP TRIGGER trg_counties_ins_2 ;
DROP TRIGGER trg_counties_ins_3 ;
DROP TRIGGER trg_counties_ins_4 ;



--================================================================
-- We continue with table "postal_codes"  
-----------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_postal_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON postal_codes FOR EACH ROW
BEGIN 
	-- attribute values conversion 
	:NEW.county_code := UPPER(:NEW.county_code) ;
	:NEW.town := UPPER(SUBSTR(:NEW.town,1,1)) || 
    	SUBSTR(:NEW.town,2,LENGTH(:NEW.town)-1) ;
END ;
/
-----------------------------------------------------------
DELETE FROM postal_codes ;
INSERT INTO postal_codes VALUES ('700505', 'iasi', 'is')  ;
INSERT INTO postal_codes VALUES ('701150', 'Pascani', 'IS') ;
INSERT INTO postal_codes VALUES ('706500', 'Vaslui', 'VS') ;
INSERT INTO postal_codes VALUES ('705300', 'Focsani', 'VN')  ;
INSERT INTO postal_codes VALUES ('706400', 'Birlad', 'VS')  ;
INSERT INTO postal_codes VALUES ('705800', 'Suceava', 'SV')  ;
INSERT INTO postal_codes VALUES ('705550', 'Roman', 'NT')  ;
INSERT INTO postal_codes VALUES ('701900', 'Timisoara', 'TM') ;
COMMIT ;
--===============================================================


--================================================================================
/*
                            Surrogate keys
    The basic Oracle solution for dealing the surrogate keys is based on:
    1. sequences that "emit" the unique values
    2. insert triggers that take the surrogate key values from the sequences
    
    We create all needed the sequences in the previous script 
*/
--================================================================================

-- Example of using sequence "seq__cust_id"


-- row level - before - insert trigger for table "customers" takes "cust_id"
--    values from the above created sequence
-----------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_customers_ins_1_bef_row
	BEFORE INSERT ON customers FOR EACH ROW
BEGIN 
	-- assign the next value of the sequence to "cust_id" attribute in newly inserted record;
	--  this is possible only in BEFORE-ROW triggers
	:NEW.cust_id := seq__cust_id.NextVal  ;

    -- a newly inserted customer has zero as current_balance
    :NEW.current_balance := 0  ;
  
	-- additionally for avoiding some constraint violation, we convert here the 
	--   values for some of the attributes
	:NEW.cust_name := UPPER(SUBSTR(:NEW.cust_name,1,1)) || 
	    SUBSTR(:NEW.cust_name,2,LENGTH(:NEW.cust_name)-1) ;
	:NEW.fiscal_code := UPPER(SUBSTR(:NEW.fiscal_code,1,1)) || 
	    SUBSTR(:NEW.fiscal_code,2,LENGTH(:NEW.fiscal_code)-1) ;
	:NEW.cust_address:= UPPER(SUBSTR(:NEW.cust_address,1,1)) || 
        SUBSTR(:NEW.cust_address,2,LENGTH(:NEW.cust_address)-1) ;
              
END ;
/

-----------------------------------------------------------
-- now for the inserts
DELETE FROM  customer_monthly_stats ;
DELETE FROM invoices ;
DELETE FROM customers ;
INSERT INTO customers (cust_id, cust_name, fiscal_code, cust_address, post_code, cust_phone)
	VALUES (1, 'Client A SRL', 'R100A', 'Tranzitiei, 13 bis', '700505', '0723456789') ;
INSERT INTO customers (cust_id, cust_name, fiscal_code, post_code, cust_phone)
	VALUES (2,'Client B SA', 'R100B', '700505', '0232212121') ;
INSERT INTO customers (cust_id, cust_name, fiscal_code, cust_address, post_code, cust_phone)
	VALUES (4, 'Client C SRL', 'R100C', 'Prosperitatii, 22','706500','0235222222') ;
INSERT INTO customers (cust_id, cust_name, fiscal_code, cust_address, post_code, cust_phone)
    VALUES (10, 'Client D', 'R100D', 'Sapientei, 56', '701150', '0744400111');
INSERT INTO customers (cust_id, cust_name, fiscal_code, cust_address, post_code, cust_phone)
	VALUES (15, 'Client E SRL', 'R100E', NULL, '701900', '0256111111');
INSERT INTO customers (cust_id, cust_name, fiscal_code, cust_address, post_code, cust_phone)
	VALUES (16, 'Client F SA', 'R100F', 'Pacientei, 33', '705550', '0721111222') ;
INSERT INTO customers 
	VALUES (17, 'Client G SRL', 'R100G', 'Victoria Capitalismului, 15','701900', 
	    '0744121212', 'client.g@yahoo.ro', 123456789) ;
COMMIT ;

-----------------------------------------------------------
-- check the inserts
--SELECT * FROM customers ;



--================================================================================
/*
                           First problem with surrogate keys
    
    The solution sequence-trigger for dealing with surrogate keys has, 
    as main weakness, the possibility of uniqueness violation as a result of an update.
    
    Example: next value generated by sequence "seq__cust_id" is 1008.
    If we run next UPDATE:
*/
    
UPDATE customers SET cust_id = 1008 WHERE cust_id = 1001 ;

/* ... and then    */ 
    INSERT INTO customers 
	    VALUES (17, 'Client NEW SRL', 'R10XX', 'Depresiei, 13','701900', 
	    '0744121212', 'cient.new@yahoo.ro', 123456780) ;
/*
    
    The primary key is violated  !
         
--================================================================================
--  Four solutions will be presented:
    A. Forbid any modification of "customers.cust_id"
    B. Allow modification of "customers.cust_id" but only if the new value
        is smaller than the older one
    C. Allow modification of "customers.cust_id" but only if the new value
        is smaller than the current value of the sequence
    D. Allow any modification of "customers.cust_id" but change the trigger for
         insert that uses the sequence
        
*/

--================================================================================
--    A. Forbid any modification of "customers.cust_id"
DROP TRIGGER trg_customers_ins_1_bef_row ;


CREATE OR REPLACE TRIGGER trg_customers_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON customers FOR EACH ROW
BEGIN 
    -- only the insert trigger will get the value of "customers.cust_id" from 
    --    the sequence
    IF INSERTING THEN
    	-- assign the next value of the sequence to "cust_id" attribute in newly inserted record;
	    --  this is possible only in BEFORE-ROW triggers
	    :NEW.cust_id := seq__cust_id.NextVal  ;

	    -- a newly inserted customer has zero as current_balance
        :NEW.current_balance := 0  ;

    ELSE
        -- the update trigger will forbid the value of "customers.cust_id"
	    IF :NEW.cust_id <> :OLD.cust_id THEN
	        -- user defined errors must be in the range between -20000 and -20999.
    		RAISE_APPLICATION_ERROR (-20810, 'Attribute cust_id cannot be modified!');
	    END IF ;
    END IF ;
  
	-- convert values for some of the attributes
	:NEW.cust_name := UPPER(SUBSTR(:NEW.cust_name,1,1)) || 
	    SUBSTR(:NEW.cust_name,2,LENGTH(:NEW.cust_name)-1) ;
	:NEW.fiscal_code := UPPER(SUBSTR(:NEW.fiscal_code,1,1)) || 
	    SUBSTR(:NEW.fiscal_code,2,LENGTH(:NEW.fiscal_code)-1) ;
	:NEW.cust_address:= UPPER(SUBSTR(:NEW.cust_address,1,1)) || 
        SUBSTR(:NEW.cust_address,2,LENGTH(:NEW.cust_address)-1) ;      
END ;
/

-- next update won't succeed:
UPDATE customers SET cust_id = 1001 WHERE cust_id = 1008 ;

-- now, let's test for an insert
SELECT seq__cust_id.NextVal FROM dual ;
SELECT seq__cust_id.CurrVal FROM dual ;
INSERT INTO customers 
	VALUES (99, 'Client H SRL', 'R101H', 'Victoria Capitalismului, 13bis','701900', 
	    '0744121010', 'client.1010@yahoo.ro', 123451000) ;
/*
SELECT * FROM customers ;
*/


--================================================================================
--    B. Allow modification of "customers.cust_id" but only if the new value
--        is smaller than the older one

-- overwrite the `trg_customers_ins_upd_bef_row` trigger created above
CREATE OR REPLACE TRIGGER trg_customers_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON customers FOR EACH ROW
BEGIN 
    -- only the insert trigger will get the value of "customers.cust_id" from 
    --    the sequence
    IF INSERTING THEN
    	-- assign the next value of the sequence to "cust_id" attribute in newly inserted record;
	    --  this is possible only in BEFORE-ROW triggers
	    :NEW.cust_id := seq__cust_id.NextVal  ;

	    -- a newly inserted customer has zero as current_balance
        :NEW.current_balance := 0  ;

    ELSE
        -- The new value of attribute "cust_id" cannot be greater than the older one
	    IF :NEW.cust_id > :OLD.cust_id THEN
    		RAISE_APPLICATION_ERROR (-20810, 
    		'The new value of attribute cust_id cannot be greater than the older one!');
	    END IF ;
    END IF ;
  
	-- convert values for some of the attributes
	:NEW.cust_name := UPPER(SUBSTR(:NEW.cust_name,1,1)) || 
	    SUBSTR(:NEW.cust_name,2,LENGTH(:NEW.cust_name)-1) ;
	:NEW.fiscal_code := UPPER(SUBSTR(:NEW.fiscal_code,1,1)) || 
	    SUBSTR(:NEW.fiscal_code,2,LENGTH(:NEW.fiscal_code)-1) ;
	:NEW.cust_address:= UPPER(SUBSTR(:NEW.cust_address,1,1)) || 
        SUBSTR(:NEW.cust_address,2,LENGTH(:NEW.cust_address)-1) ;      
END ;
/


-- test  
--SELECT * FROM customers ;

-- next update will work:
UPDATE customers SET cust_id = 1001 WHERE cust_id = 1008 ;
--SELECT * FROM customers ;

-- but the next one won't:
UPDATE customers SET cust_id = 1020 WHERE cust_id = 1010 ;



--================================================================================
--    C. Allow modification of "customers.cust_id" but only if the new value
--        is smaller than the current value of the sequence

-- overwrite the `trg_customers_ins_upd_bef_row` trigger created above
CREATE OR REPLACE TRIGGER trg_customers_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON customers FOR EACH ROW
DECLARE	
    crt_seq_value INTEGER ;
BEGIN 
    -- only the insert trigger will get the value of "customers.cust_id" from 
    --    the sequence
    IF INSERTING THEN
    	-- assign the next value of the sequence to "cust_id" attribute in newly inserted record;
	    --  this is possible only in BEFORE-ROW triggers
	    :NEW.cust_id := seq__cust_id.NextVal  ;

	    -- a newly inserted customer has zero as current_balance
        :NEW.current_balance := 0  ;

    ELSE
        -- Test if "cust_id" was modified...
        IF :NEW.cust_id <> :OLD.cust_id THEN
            
            -- if so, we'll compare "cust_id" new value with the current value of the sequence
            --- caution: this solution works because when creating the sequence we used NOCACHE option
            SELECT last_number INTO crt_seq_value
            FROM user_sequences
            WHERE sequence_name = 'SEQ__CUST_ID';    
            
            -- The new value of attribute "cust_id" cannot be greater than the current value of the sequence
	        IF :NEW.cust_id > crt_seq_value THEN
    		    RAISE_APPLICATION_ERROR (-20810, 
    		        'The new value cust_id cannot be greater than the current value of the sequence!');
	        END IF ;
        END IF ;
    END IF ;    
  
	-- convert values for some of the attributes
	:NEW.cust_name := UPPER(SUBSTR(:NEW.cust_name,1,1)) || 
	    SUBSTR(:NEW.cust_name,2,LENGTH(:NEW.cust_name)-1) ;
	:NEW.fiscal_code := UPPER(SUBSTR(:NEW.fiscal_code,1,1)) || 
	    SUBSTR(:NEW.fiscal_code,2,LENGTH(:NEW.fiscal_code)-1) ;
	:NEW.cust_address:= UPPER(SUBSTR(:NEW.cust_address,1,1)) || 
        SUBSTR(:NEW.cust_address,2,LENGTH(:NEW.cust_address)-1) ;      
END ;
/

-- test 
/*
SELECT * FROM customers ;
*/
-- next update will not work:
UPDATE customers SET cust_id = 1020 WHERE cust_id = 1010 ;



--================================================================================
--    D. Allow any modification of "customers.cust_id" but change the trigger for
--         insert that uses the sequence

-- overwrite the `trg_customers_ins_upd_bef_row` trigger created above
CREATE OR REPLACE TRIGGER trg_customers_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON customers FOR EACH ROW
DECLARE	
    v_cust_id customers.cust_id%TYPE ;
    v_dummy INTEGER ;
BEGIN 

    IF INSERTING THEN
    
        -- we'll use a block inside the trigger that will catch any primary key violation
        BEGIN
            LOOP -- keep looping until the value generated by the sequence was not already
                 -- assigned to the surrogate key   
            
                v_cust_id := seq__cust_id.NextVal  ;
                SELECT 1 INTO v_dummy FROM customers WHERE cust_id = v_cust_id ;  
            END LOOP ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                :NEW.cust_id := seq__cust_id.CurrVal  ;
        END ;
        -- here the nested anonymous block finishes

	    -- a newly inserted customer has zero as current_balance
        :NEW.current_balance := 0  ;

    -- there is no need for a special treatment of UPDATING
    END IF ;    
  
	-- convert values for some of the attributes
	:NEW.cust_name := UPPER(SUBSTR(:NEW.cust_name,1,1)) || 
	    SUBSTR(:NEW.cust_name,2,LENGTH(:NEW.cust_name)-1) ;
	:NEW.fiscal_code := UPPER(:NEW.fiscal_code) ;
	:NEW.cust_address:= UPPER(SUBSTR(:NEW.cust_address,1,1)) || 
        SUBSTR(:NEW.cust_address,2,LENGTH(:NEW.cust_address)-1) ;      
END ;
/

-- now, for the test 
--SELECT * FROM customers ;
SELECT last_number FROM user_sequences WHERE sequence_name = 'SEQ__CUST_ID' ;

-- insert a customer
INSERT INTO customers 
	VALUES (99, 'A New Client SRL', 'R_new', 'The address of A New Client SRL','701900', 
	    '0744121011', 'a.new.client@yahoo.ro', 123451001) ;
--SELECT * FROM customers ;

-- change the last cust_id for forcing the primary key violation at the next insett
UPDATE customers SET cust_id = 1012 WHERE cust_id = 1011 ;

-- previously, the next insert would violate the primary key; the trigger new version
-- will avoid it (the new customer must have not `1012` but `1013` as cust_id)
INSERT INTO customers 
	VALUES (99, 'A Even Newer Client SRL', 'R_newer', 'The address of A Even Newer Client SRL','701900', 
	    '0744121012', 'a.newer.client@yahoo.ro', 123451002) ;
COMMIT ;

/*
SELECT * FROM customers ;
*/

-- It worked!!!




--================================================================================
/*
                           The second problem with the surrogate keys
    
    When a surrogate key gets values from a sequence, we must take care
        of situations when that surrogate key appears as a foreign key 
        (in a child table)
    
    Example: 
    When entering an invoice, we might not know in advance its customer "cust_id", but only
       "cust_name", that because some sequence values were `lost` because of
       some `rolledback` transactions


--================================================================================
--  There are two basic solutions:
    A. Every insert in a child table of "customers" table will have a sub-query
       for getting customer's id based on the customer name
    B. Create a function that gets a customer name and returns the customer id;
        this function will be used in each insert into a child table
*/

--================================================================================
--    A. Every insert in a child table of "customers" table will have a sub-query
--       for getting customers id based on customer name

INSERT INTO invoices VALUES (1, 1111, DATE'2013-08-01', 
        (SELECT cust_id FROM customers WHERE cust_name='Client A SRL'),
    NULL, 0, 0, 0, 0, 0, 'N', NULL  ) ;  

-- check
--SELECT * FROM invoices ;


--================================================================================
--    B. Create a function that gets a customer name and returns the customer id;
--        this function will be used in each insert into a child table

---------------------------------------------------------------
CREATE OR REPLACE PACKAGE pac_sales 
AS
    FUNCTION f_cust_id (cust_name_ customers.cust_name%TYPE)
        RETURN customers.cust_id%TYPE ;
END ;
/
---------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_sales  AS
---------------------------------------------
FUNCTION f_cust_id (cust_name_ customers.cust_name%TYPE)
        RETURN customers.cust_id%TYPE 
IS
    v_cust_id customers.cust_id%TYPE ;
BEGIN
    SELECT cust_id INTO v_cust_id FROM customers
    WHERE cust_name = cust_name_ ;
    
    RETURN v_cust_id ;        
END ;

END ;
/

-- this function will be used in every row insert in "invoices"
INSERT INTO invoices VALUES (2, 1112, DATE'2013-08-01', pac_sales.f_cust_id('Client E SRL'),
    NULL, 0, 0, 0, 0, 0, 'N', NULL  ) ;  
-- check
--SELECT * FROM invoices ;
--
COMMIT ;


/*
--================================================================================
--    Create similar triggers for all the surrogate keys in the database
--    Each time we'll define a sequence and then a trigger, as in the case of 
--      table "customers"
*/

--================================================================================
--    As with "customers.cust_id", we'll allow any modification of "people.pers_id" 
CREATE OR REPLACE TRIGGER trg_people_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON people FOR EACH ROW
DECLARE	
    v_pers_id people.pers_id%TYPE ;
    v_dummy INTEGER ;
BEGIN 
    IF INSERTING THEN    
        -- we'll use a block inside the trigger that will catch any primary key violation
        BEGIN
            LOOP -- keep looping until the value generated by the sequence was not already
                 -- assigned to the surrogate key      
                v_pers_id := seq__pers_id.NextVal  ;
                SELECT 1 INTO v_dummy FROM people WHERE pers_id = v_pers_id ;  
            END LOOP ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                :NEW.pers_id := seq__pers_id.CurrVal  ;
        END ;
        -- here the nested anonymous block finishes
    END IF ;    
  
	-- convert values for some of the attributes
	:NEW.pers_family_name := UPPER(SUBSTR(:NEW.pers_family_name,1,1)) || 
	    SUBSTR(:NEW.pers_family_name,2,LENGTH(:NEW.pers_family_name)-1) ;
	:NEW.pers_first_name := UPPER(SUBSTR(:NEW.pers_first_name,1,1)) || 
	    SUBSTR(:NEW.pers_first_name,2,LENGTH(:NEW.pers_first_name)-1) ;
	:NEW.pers_address := UPPER(SUBSTR(:NEW.pers_address,1,1)) || 
	    SUBSTR(:NEW.pers_address,2,LENGTH(:NEW.pers_address)-1) ;    
	:NEW.pers_genre := UPPER(:NEW.pers_genre) ;
END ;
/


--================================================================================
--    We'll allow any modification of "invoices.invoice_id" 
CREATE OR REPLACE TRIGGER trg_invoices_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON invoices FOR EACH ROW
DECLARE	
    v_invoice_id invoices.invoice_id%TYPE ;
    v_dummy INTEGER ;
BEGIN 

    IF INSERTING THEN
    
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
                
    END IF ;    
  
	-- convert values for some of the attributes
	:NEW.is_closed := UPPER(:NEW.is_closed) ;
END ;
/

  
--================================================================================
--              We'll allow any modification of "products.product_id" 
CREATE OR REPLACE TRIGGER trg_products_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON products FOR EACH ROW
DECLARE	
    v_product_id products.product_id%TYPE ;
    v_dummy INTEGER ;
BEGIN 

    IF INSERTING THEN
    
        -- we'll use a block inside the trigger that will catch any primary key violation
        BEGIN
            LOOP -- keep looping until the value generated by the sequence was not already
                 -- assigned to the surrogate key      
                v_product_id := seq__product_id.NextVal  ;
                SELECT 1 INTO v_dummy FROM products WHERE product_id = v_product_id ;  
            END LOOP ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                :NEW.product_id := seq__product_id.CurrVal  ;
        END ;
        -- here the nested anonymous block finishes
    END IF ;    
  
	-- convert values for some of the attributes
	:NEW.product_name := UPPER(SUBSTR(:NEW.product_name,1,1)) || 
	    SUBSTR(:NEW.product_name,2,LENGTH(:NEW.product_name)-1) ;
	:NEW.group_ := UPPER(SUBSTR(:NEW.group_,1,1)) || 
	    SUBSTR(:NEW.group_,2,LENGTH(:NEW.group_)-1) ;

END ;
/


--================================================================================
--    We'll allow any modification of "receipts.receipt_id" 
CREATE OR REPLACE TRIGGER trg_receipts_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON receipts FOR EACH ROW
DECLARE	
    v_receipt_id receipts.receipt_id%TYPE ;
    v_dummy INTEGER ;
BEGIN 
    IF INSERTING THEN
        -- we'll use a block inside the trigger that will catch any primary key violation
        BEGIN
            LOOP -- keep looping until the value generated by the sequence was not already
                 -- assigned to the surrogate key      
                v_receipt_id := seq__receipt_id.NextVal  ;
                SELECT 1 INTO v_dummy FROM receipts WHERE receipt_id = v_receipt_id ;  
            END LOOP ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                :NEW.receipt_id := seq__receipt_id.CurrVal  ;
        END ;
        -- here the nested anonymous block finishes
        
        -- a newly inserted receipt has...
        :NEW.amount_paid := 0 ;
                
    END IF ;    
  
	-- apparently we have no attribute values to be converted
	-- ... so, actually, this is a trigger useful only for inserts
END ;
/


--================================================================================
--    We'll allow any modification of "refusals.refusal_id" 
CREATE OR REPLACE TRIGGER trg_refusals_ins_upd_bef_row
	BEFORE INSERT OR UPDATE ON refusals FOR EACH ROW
DECLARE	
    v_refusal_id refusals.refusal_id%TYPE ;
    v_dummy INTEGER ;
BEGIN 
    IF INSERTING THEN
        -- we'll use a block inside the trigger that will catch any primary key violation
        BEGIN
            LOOP -- keep looping until the value generated by the sequence was not already
                 -- assigned to the surrogate key      
                v_refusal_id := seq__refusal_id.NextVal  ;
                SELECT 1 INTO v_dummy FROM refusals WHERE refusal_id = v_refusal_id ;  
            END LOOP ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                :NEW.refusal_id := seq__refusal_id.CurrVal  ;
        END ;
        -- here the nested anonymous block finishes
        
        -- a newly inserted refusal has...
        :NEW.refusal_amount := 0 ;
                
    END IF ;    
  
	-- apparently we have no attribute values to be converted
	-- ... so, actually, this is a trigger useful only for inserts
END ;
/


--================================================================================
--    Finally, we'll update `pac_sales`, by creating functions to be used 
--			in all inserts into the child tables 
---------------------------------------------------------------
CREATE OR REPLACE PACKAGE pac_sales 
AS
    -- this function is copied from the previous version of the package
    FUNCTION f_cust_id (cust_name_ customers.cust_name%TYPE)
        RETURN customers.cust_id%TYPE ;

    -- for getting the person id, we create a function which can identify 
    --    a person based or her/his family name and first name, or by its
    --    mobile_phone or by its personal e_mail       
    FUNCTION f_pers_id (value_to_be_searched_ NVARCHAR2, what_is_that_value_ VARCHAR2)
        RETURN people.pers_id%TYPE ;

    -- for getting the invoice_id, we create a function which can identify 
    --    an invoice using the combination (invoice_number, invoice_date)    
    FUNCTION f_invoice_id (invoice_number_ invoices.invoice_number%TYPE, 
                invoice_date_ invoices.invoice_date%TYPE)
        RETURN invoices.invoice_id%TYPE ;
                
    -- next function gets a product name and returns the product code
    FUNCTION f_product_id (product_name_ products.product_name%TYPE)
        RETURN products.product_id%TYPE ;

    -- for getting the receipt_id, we create a function which can identify 
    --    a receipt using the combination (receipt_docum_type, receipt_docum_number, receipt_docum_date)    
    FUNCTION f_receipt_id (receipt_docum_type_ receipts.receipt_docum_type%TYPE, 
                receipt_docum_number_ receipts.receipt_docum_number%TYPE,
                receipt_docum_date_ receipts.receipt_docum_date%TYPE)
        RETURN receipts.receipt_id%TYPE ;

    -- for getting the refusal_id, we create a function which can identify 
    --    a refusal using "refusal_dt")    
    FUNCTION f_refusal_id (refusal_dt_ refusals.refusal_dt%TYPE)
        RETURN refusals.refusal_id%TYPE ;        
END ;
/


---------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_sales  AS
---------------------------------------------------------------
FUNCTION f_cust_id (cust_name_ customers.cust_name%TYPE)
        RETURN customers.cust_id%TYPE 
IS
    v_cust_id customers.cust_id%TYPE ;
BEGIN
    SELECT cust_id INTO v_cust_id FROM customers
    WHERE cust_name = cust_name_ ;
    
    RETURN v_cust_id ;        
END f_cust_id ;

---------------------------------------------------------------
FUNCTION f_pers_id (value_to_be_searched_ NVARCHAR2, 
    what_is_that_value_ VARCHAR2)
        RETURN people.pers_id%TYPE 
IS
    v_pers_id people.pers_id%TYPE ;
BEGIN
    CASE what_is_that_value_
        WHEN 'name' THEN
            SELECT pers_id INTO v_pers_id FROM people
            WHERE pers_family_name || ' ' || pers_first_name = value_to_be_searched_ ;
        WHEN 'mobile_phone' THEN
            SELECT pers_id INTO v_pers_id FROM people
            WHERE RTRIM(mobile_phone) = RTRIM(value_to_be_searched_) ;
        WHEN 'pers_email' THEN
            SELECT pers_id INTO v_pers_id FROM people
            WHERE pers_email = value_to_be_searched_ ;
    END CASE ;         
    RETURN v_pers_id ;
END f_pers_id;

---------------------------------------------------------------
FUNCTION f_invoice_id (invoice_number_ invoices.invoice_number%TYPE, 
                invoice_date_ invoices.invoice_date%TYPE)
    RETURN invoices.invoice_id%TYPE 
IS
    v_invoice_id invoices.invoice_id%TYPE ;
BEGIN
    SELECT invoice_id INTO v_invoice_id FROM invoices
    WHERE invoice_number = invoice_number_ AND invoice_date = invoice_date_  ;

    RETURN v_invoice_id ;
END f_invoice_id ;    

---------------------------------------------------------------
FUNCTION f_product_id (product_name_ products.product_name%TYPE)
        RETURN products.product_id%TYPE 
IS
    v_product_id products.product_id%TYPE ;
BEGIN
    SELECT product_id INTO v_product_id FROM products
    WHERE product_name = product_name_   ;

    RETURN v_product_id ;
END f_product_id ;    

---------------------------------------------------------------
FUNCTION f_receipt_id (receipt_docum_type_ receipts.receipt_docum_type%TYPE, 
                receipt_docum_number_ receipts.receipt_docum_number%TYPE,
                receipt_docum_date_ receipts.receipt_docum_date%TYPE)
        RETURN receipts.receipt_id%TYPE 
IS
    v_receipt_id receipts.receipt_id%TYPE ;
BEGIN
    SELECT receipt_id INTO v_receipt_id FROM receipts
    WHERE receipt_docum_type = receipt_docum_type_ AND 
        receipt_docum_number = receipt_docum_number_ AND
        receipt_docum_date = receipt_docum_date_  ;

    RETURN v_receipt_id ;
END f_receipt_id ; 

---------------------------------------------------------------
FUNCTION f_refusal_id (refusal_dt_ refusals.refusal_dt%TYPE)
        RETURN refusals.refusal_id%TYPE        
IS
    v_refusal_id refusals.refusal_id%TYPE ;
BEGIN
    SELECT refusal_id INTO v_refusal_id FROM refusals
    WHERE refusal_dt = refusal_dt_  ;

    RETURN v_refusal_id ;              
END f_refusal_id ;

END ;
/

--================================================================================
