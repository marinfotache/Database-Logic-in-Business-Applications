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

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-02d_en_proc_auto_ins__receipts.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-03a_en_logs_and_triggers.sql


See also the presentation:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-03_en_Triggers%20-%20part%203.pptx


*/



--====================================================================================
-- 		    general log (keeping track of all important tables changes)
--====================================================================================
--              1st version: - a single big log table OPERATIONS
--====================================================================================
DROP TABLE operations  ;

CREATE TABLE operations (
	op_id NUMBER(18) PRIMARY KEY,
	op_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	op_user VARCHAR2(30) DEFAULT USER NOT NULL,
	table_ VARCHAR2(30),
	primary_key_value VARCHAR2(500),
	op_type CHAR(1) DEFAULT 'I' 
		NOT NULL CONSTRAINT ck_operations_categ1 CHECK (op_type IN ('I', 'U', 'D')),
	old_record VARCHAR2(4000), 
	new_record VARCHAR2(4000)
	) ;

DROP SEQUENCE seq__op_id	;
CREATE SEQUENCE seq__op_id START WITH 1 MINVALUE 1 MAXVALUE 999999999999999999
	INCREMENT BY 1 ORDER NOCACHE ;


--======================================================================================
--          triggers of table "operations" - UPDATEs and DELETEs will be forbidden !!!
--======================================================================================
-- insert
CREATE OR REPLACE TRIGGER trg_operations_ins
	BEFORE INSERT ON operations FOR EACH ROW
BEGIN
	:NEW.op_id := seq__op_id.NextVal ;
	:NEW.op_ts := CURRENT_TIMESTAMP ;
	:NEW.op_user := USER ;
END;
/

-- update and delete
CREATE OR REPLACE TRIGGER trg_operations_upd_del
	BEFORE UPDATE OR DELETE ON operations FOR EACH ROW
BEGIN 
	RAISE_APPLICATION_ERROR(-20657, 'In table `operations` only inserts are allowed!')  ;
END ;
/

--==============================================================================
-- 			Example 1:    create a single log trigger for table "invoices" 
--===============================================================================
CREATE OR REPLACE TRIGGER trg_invoices_log 
    AFTER INSERT OR UPDATE OR DELETE ON invoices FOR EACH ROW
BEGIN
    IF INSERTING THEN
 	    INSERT INTO operations (table_, primary_key_value, op_type, old_record, new_record) 
		    VALUES ('invoices', CAST (:NEW.invoice_id AS VARCHAR2(10)), 'I', 
		        NULL, 
		        'invoice_id:'|| :NEW.invoice_id || ', invoice_number:'|| :NEW.invoice_number ||
		        ', invoice_date:'|| TO_CHAR(:NEW.invoice_date, 'YYYY-MM-DD') || ', cust_id:'|| :NEW.cust_id ||
		        ', comments:'|| :NEW.comments || ', invoice_VAT:'|| :NEW.invoice_VAT ||
		        ', invoice_amount:'|| :NEW.invoice_amount || ', amount_received:'|| :NEW.amount_received ||
		        ', amount_refused:'|| :NEW.amount_refused || ', n_of_rows:'|| :NEW.n_of_rows ||
		        ', is_closed:'|| :NEW.is_closed || ', invoice_status:'|| :NEW.invoice_status ) ;
    END IF ;
    IF DELETING THEN
 	    INSERT INTO operations (table_, primary_key_value, op_type, old_record, new_record) 
		    VALUES ('invoices', CAST (:OLD.invoice_id AS VARCHAR2(10)), 'D', 
		        'invoice_id:'|| :OLD.invoice_id || ', invoice_number:'|| :OLD.invoice_number ||
		        ', invoice_date:'|| TO_CHAR(:OLD.invoice_date, 'YYYY-MM-DD') || ', cust_id:'|| :OLD.cust_id ||
		        ', comments:'|| :OLD.comments || ', invoice_VAT:'|| :OLD.invoice_VAT ||
		        ', invoice_amount:'|| :OLD.invoice_amount || ', amount_received:'|| :OLD.amount_received ||
		        ', amount_refused:'|| :OLD.amount_refused || ', n_of_rows:'|| :OLD.n_of_rows ||
		        ', is_closed:'|| :OLD.is_closed || ', invoice_status:'|| :OLD.invoice_status,
		        NULL ) ;
    END IF ;
     IF UPDATING THEN
 	    INSERT INTO operations (table_, primary_key_value, op_type, old_record, new_record) 
		    VALUES ('invoices', CAST (:NEW.invoice_id AS VARCHAR2(10)), 'U', 
		    'invoice_id:'|| :OLD.invoice_id || ', invoice_number:'|| :OLD.invoice_number ||
		        ', invoice_date:'|| TO_CHAR(:OLD.invoice_date, 'YYYY-MM-DD') || ', cust_id:'|| :OLD.cust_id ||
		        ', comments:'|| :OLD.comments || ', invoice_VAT:'|| :OLD.invoice_VAT ||
		        ', invoice_amount:'|| :OLD.invoice_amount || ', amount_received:'|| :OLD.amount_received ||
		        ', amount_refused:'|| :OLD.amount_refused || ', n_of_rows:'|| :OLD.n_of_rows ||
		        ', is_closed:'|| :OLD.is_closed || ', invoice_status:'|| :OLD.invoice_status,   
		    'invoice_id:'|| :NEW.invoice_id || ', invoice_number:'|| :NEW.invoice_number ||
		        ', invoice_date:'|| TO_CHAR(:NEW.invoice_date, 'YYYY-MM-DD') || ', cust_id:'|| :NEW.cust_id ||
		        ', comments:'|| :NEW.comments || ', invoice_VAT:'|| :NEW.invoice_VAT ||
		        ', invoice_amount:'|| :NEW.invoice_amount || ', amount_received:'|| :NEW.amount_received ||
		        ', amount_refused:'|| :NEW.amount_refused || ', n_of_rows:'|| :NEW.n_of_rows ||
		        ', is_closed:'|| :NEW.is_closed || ', invoice_status:'|| :NEW.invoice_status ) ;
    END IF ;

    
END ;
/


--==============================================================================
-- 		Example 2:    create a single log trigger for table "invoice_details" 
--===============================================================================

CREATE OR REPLACE TRIGGER trg_invoice_details_log 
    AFTER INSERT OR UPDATE OR DELETE ON invoice_details FOR EACH ROW
BEGIN
    IF INSERTING THEN
 	    INSERT INTO operations (table_, primary_key_value, op_type, old_record, new_record) 
		    VALUES ('invoice_details', 
		        CAST (:NEW.invoice_id AS CHAR(10)) || CAST (:NEW.row_number AS CHAR(2)), 
		        'I', 
		        NULL, 
		        'invoice_id:'|| :NEW.invoice_id || ', row_number:'|| :NEW.row_number ||
		            ', quantity:'|| :NEW.quantity || ', unit_price:'|| :NEW.unit_price ||
		            ', product_id:'|| :NEW.product_id || ', row_VAT:'|| :NEW.row_VAT ) ;
    END IF ;
    IF DELETING THEN
 	    INSERT INTO operations (table_, primary_key_value, op_type, old_record, new_record) 
		    VALUES ('invoice_details', 
		        CAST (:OLD.invoice_id AS CHAR(10)) || CAST (:OLD.row_number AS CHAR(2)), 
		        'D',  
		        'invoice_id:'|| :OLD.invoice_id || ', row_number:'|| :OLD.row_number ||
		            ', quantity:'|| :OLD.quantity || ', unit_price:'|| :OLD.unit_price ||
		            ', product_id:'|| :OLD.product_id || ', row_VAT:'|| :OLD.row_VAT,
		        NULL ) ;
    END IF ;
    
    IF UPDATING THEN
 	    INSERT INTO operations (table_, primary_key_value, op_type, old_record, new_record) 
		    VALUES ('invoice_details', 
		        CAST (:NEW.invoice_id AS CHAR(10)) || CAST (:NEW.row_number AS CHAR(2)), 
		        'U', 
		        'invoice_id:'|| :OLD.invoice_id || ', row_number:'|| :OLD.row_number ||
		            ', quantity:'|| :OLD.quantity || ', unit_price:'|| :OLD.unit_price ||
		            ', product_id:'|| :OLD.product_id || ', row_VAT:'|| :OLD.row_VAT,
		        'invoice_id:'|| :NEW.invoice_id || ', row_number:'|| :NEW.row_number ||
		            ', quantity:'|| :NEW.quantity || ', unit_price:'|| :NEW.unit_price ||
		            ', product_id:'|| :NEW.product_id || ', row_VAT:'|| :NEW.row_VAT 
		        ) ;
    END IF ;   
END ;
/

---------------------------------------------------------------------------------------------------
--                  test the trigger
SELECT * 
FROM (SELECT * FROM invoices ORDER BY invoice_id DESC)
WHERE rownum = 1 ;


INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (13219, DATE'2014-12-01', pac_sales.f_cust_id('Client A SRL'));

SELECT * 
FROM (SELECT * FROM invoices ORDER BY invoice_id DESC)
WHERE rownum = 1 ;

SELECT * FROM operations ORDER BY 1 ;

INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 13219), 1, 1, 50, 1000) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 13219), 2, 2, 75, 1050) ;


SELECT * FROM invoices WHERE invoice_number = 13219 ;

SELECT * FROM operations ORDER BY 1 ;


DELETE FROM invoice_details WHERE invoice_id = 63 AND row_number = 2 ;

SELECT * FROM invoices WHERE invoice_number = 13219 ;

SELECT * FROM operations ORDER BY 1 ;


COMMIT ;

---------------------------------------------------------------------------------------------------
--                   Too many triggers may slow the database
--
--  we will disable the log triggers

ALTER TRIGGER trg_invoices_log DISABLE ;
ALTER TRIGGER trg_invoice_details_log DISABLE ;


