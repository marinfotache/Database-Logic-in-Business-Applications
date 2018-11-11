/*
This script works with `sales` database that was created by launching (in Oracle SQL
Developer) two previous scripts:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-2_fixed_DDL_script_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-3_add_constraints_sales_2015.sql

*/


DELETE FROM invoices ;
DELETE FROM customers ;
DELETE FROM postal_codes ;
DELETE FROM counties ;
COMMIT ;



--================================================================================
/* 
	In this script, we'll be playing with sequences required for the
	management of surrogate keys (see script `06-01b...`)
*/      
--================================================================================


--================================================================================
-- 				Sequence creation; methods `.NextVal` and `.CurrVal`           ---
--================================================================================
-- create the sequence needed for the surrogate key  "products.product_id"
DROP SEQUENCE seq__product_id 
/
CREATE SEQUENCE seq__product_id START WITH 1 INCREMENT BY 1 MINVALUE 1
	MAXVALUE 789789789 NOCACHE ORDER NOCYCLE 
/	

-- ... `consume` a sequence value
SELECT seq__product_id.NextVal FROM dual ;


-- once a sequence is initialised in the the current session
--  (using `.NextVal` for a sequence will initialise the sequence),
-- one can find out the last generated value by the sequence with...
SELECT seq__product_id.CurrVal FROM dual ;

 
-- if we are not sure the sequence is initialized, given that we created the 
--   sequence with option NOCACHE, one can query the database dictionary (USER_SEQUENCES)
--   as follows:
-- (in Oracle DB data dictionary all object names are UPPERCASE)
SELECT LAST_NUMBER - 1
FROM USER_SEQUENCES
WHERE LOWER(SEQUENCE_NAME) = 'seq__product_id' ;



--================================================================================
--                          Using the sequence in INSERTs                      ---
--================================================================================

-- clean up table PRODUCTS
DELETE FROM products ;
COMMIT ;

----------------------------------------------------------------------------------
--   insert one row in the table "products" invoking the sequence ...
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 1','buc', 'Bauturi racoritoare', .19)  ;

-- ... `consume` a sequence value
SELECT seq__product_id.NextVal FROM dual ;

-- and insert another row in the table PRODUCTS invoking the sequence
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 2','kg', 'Bere', 0.09)  ;


--------------------------------------------------------------------------
-- check the inserts (notice the inserted values for "products.product_id"
SELECT * FROM products ;


------------------------------------------------------------------------
-- if we rollback the transaction, even the table records will be
--    removes, the sequence generated values are `lost`

-- this cancels out all the DML operation from the transaction start, 
-- so that table "producs" won't contain any record
ROLLBACK ;


----------------------------------------------------------------------------------
-- now, repeat the insertion ...

--   insert one row in the table PRODUCTS invoking the sequence ...
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 1','buc', 'Bauturi racoritoare', .19)  ;

-- ... `consume` a sequence value
SELECT seq__product_id.NextVal FROM dual ;

-- and insert another row in the table PRODUCTS invoking the sequence
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 2','kg', 'Bere', 0.09)  ;


--------------------------------------------------------------------------------------------
-- check the new record in PRODUCTS (notice the inserted values for "products.product_id"
SELECT * FROM products ;

--------------------------------------------------------------------------------------------
-- visualize the last generated value by the sequence...
SELECT LAST_NUMBER - 1
FROM USER_SEQUENCES
WHERE LOWER(SEQUENCE_NAME) = 'seq__product_id' ;




--------------------------------------------------------------------------------------------
-- if we want to be sure that all initial records in table PRODUCTS we'll
-- have for "product_id" consecutive values taken the sequence we have to
-- drop and re-create the sequence, as follows:

DROP SEQUENCE seq__product_id ;
CREATE SEQUENCE seq__product_id START WITH 1 INCREMENT BY 1 MINVALUE 1
	MAXVALUE 789789789 NOCACHE ORDER NOCYCLE ;

DELETE FROM products ;
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 1','buc', 'Tigari', .24)  ;
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 2','kg', 'Bere', 0.12)  ;
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 3','kg', 'Bere', 0.24)  ;
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 4','l', 'Dulciuri', 0.12)  ;
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 5','buc', 'Tigari', .24)  ;
INSERT INTO products VALUES (seq__product_id.NextVal, 'Produs 6','p250g', 'Cafea', .24)  ;
COMMIT ;



--================================================================================
-- 								 Create other sequences            		       ---
--================================================================================

-- create the sequence needed for the surrogate key  "customers.cust_id"
DROP SEQUENCE seq__cust_id 
/
CREATE SEQUENCE seq__cust_id START WITH 1001 INCREMENT BY 1 MINVALUE 1001
	MAXVALUE 789789789 NOCACHE ORDER NOCYCLE 
/	

-- create the sequence needed for the surrogate key  "people.pers_id"
DROP SEQUENCE seq__pers_id 
/
CREATE SEQUENCE seq__pers_id START WITH 1 INCREMENT BY 1 MINVALUE 1
	MAXVALUE 888888 NOCACHE ORDER NOCYCLE 
/	

-- create the sequence needed for the surrogate key  "invoices.invoice_id"
DROP SEQUENCE seq__invoice_id 
/
CREATE SEQUENCE seq__invoice_id START WITH 1 INCREMENT BY 1 MINVALUE 1
	MAXVALUE 888888999999 NOCACHE ORDER NOCYCLE 
/	

-- RE-create the sequence needed for the surrogate key  "products.product_id"
DROP SEQUENCE seq__product_id 
/
CREATE SEQUENCE seq__product_id START WITH 1 INCREMENT BY 1 MINVALUE 1
	MAXVALUE 888888999 NOCACHE ORDER NOCYCLE 
/	

-- create the sequence needed for the surrogate key  "receipts.receipt_id"
DROP SEQUENCE seq__receipt_id 
/
CREATE SEQUENCE seq__receipt_id START WITH 1 INCREMENT BY 1 MINVALUE 1
	MAXVALUE 888888999999 NOCACHE ORDER NOCYCLE 
/	

-- create the sequence needed for the surrogate key  "refusals.refusal_id"
DROP SEQUENCE seq__refusal_id 
/
CREATE SEQUENCE seq__refusal_id START WITH 1 INCREMENT BY 1 MINVALUE 1
	MAXVALUE 8888899 NOCACHE ORDER NOCYCLE 
/	

