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

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-03b_en_general_log.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-03c_en_protecting_denormalized_attributes.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-01a_BusinessRules1__basic_BR.sql

See also the presentation:
See also the presentation:
https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-01_en_Business%20Rules%20with%20PL%20SQL%20(1).pptx

*/

--====================================================================================
-- 	Business Rules Implemented with Oracle PL/SQL triggers - part II: invoice locking
--====================================================================================
--      In table "invoices" there is attribute called "is_closed".
--  It acts like a flag. When "is_closed" is set on "Y" (Yes), an invoice can be
--  edited no more, but only paid, cancelled or refused
--
--  UPDATE triggers for tables "invoices" and "invoice_details" must check now
--    the value of "invoices.is_closed" and reject detail changes of closed invoices; 
--  Additionally, "invoices.is_closed" must be changed only by an authorized user 
--    of the database
--====================================================================================

-- we'll update previously created trigger "trg_invoices_upd1"
CREATE OR REPLACE TRIGGER trg_invoices_upd1
	BEFORE UPDATE ON invoices FOR EACH ROW
BEGIN 

    -- check in the invoice is closed    
    IF :OLD.is_closed = 'Y' THEN
        -- if so, reject changes of invoice detailed information
        IF :NEW.invoice_id <> :OLD.invoice_id OR :NEW.invoice_number <> :OLD.invoice_number
                OR :NEW.invoice_date <> :OLD.invoice_date OR :NEW.cust_id <> :OLD.cust_id
                OR :NEW.invoice_VAT <> :OLD.invoice_VAT OR :NEW.invoice_amount <> :OLD.invoice_amount
                OR :NEW.amount_received <> :OLD.amount_received OR 
                :NEW.amount_refused <> :OLD.amount_refused  THEN
    
            RAISE_APPLICATION_ERROR (-20070, 
                'Current invoice is locked (closed), so many of its properties cannot be changed');
        END IF ;
        
    END IF ;
    
    IF  :NEW.is_closed <> :OLD.is_closed THEN   
        -- only autorized users may change the value of "is_changed"
        --  please change the list according to your database status
        IF user NOT IN ('FOTACHEM', 'STRIMBEIC', 'SDBIS', 'SIA', 'DM') THEN
            RAISE_APPLICATION_ERROR (-20071, 
                'Sorry, but you are not authorized the change the attribute <<is_closed>> value');
        END IF ;
    
    END IF ;
        
	-- convert is_closed
	:NEW.is_closed := UPPER(:NEW.is_closed) ;
END ;
/

--====================================================================================
-- next we'll create a before each row trigger for "invoices"
CREATE OR REPLACE TRIGGER trg_invoices_del_closed
	BEFORE DELETE ON invoices FOR EACH ROW
BEGIN 
    -- check in the invoice is closed    
    IF :OLD.is_closed = 'Y' THEN
        RAISE_APPLICATION_ERROR (-20075, 
                'Current invoice is locked (closed), so you cannot delete it');
    END IF ;
END ;
/

--====================================================================================
--                      test the triggers

-- extract the last  invoice
SELECT * FROM invoices WHERE invoice_id = (SELECT MAX(invoice_id) FROM invoices) ; 
-- in my db, the last invoice has id 61 and date '01-11-2014 ' 

-- change "is_closed" to Y 
UPDATE invoices SET is_closed = 'Y' WHERE invoice_id = 61 ;
COMMIT ;

-- next UPDATE must be rejected by the newly created trigger
UPDATE invoices SET invoice_date = DATE'2014-11-02' WHERE invoice_id = 61 ;

-- also next DELETE must be rejected
DELETE FROM invoices WHERE invoice_id = 61 ;
--  frankly speaking, one must admit that this DELETE would be rejected by the
--    foreign keys



--====================================================================================
--    create a single trigger for table "invoice_details" for authorizing
--      the changes only for invoices that are not closed 
--====================================================================================
CREATE OR REPLACE TRIGGER trg_inv_details_closed
    BEFORE INSERT OR UPDATE OR DELETE ON invoice_details FOR EACH ROW
DECLARE 
    v_is_closed invoices.is_closed%TYPE ;
BEGIN
    IF INSERTING OR (UPDATING AND :NEW.invoice_id <> :OLD.invoice_id) THEN
        SELECT is_closed INTO v_is_closed FROM invoices
        WHERE invoice_id = :NEW.invoice_id ;
        
        IF v_is_closed = 'T' THEN  
            RAISE_APPLICATION_ERROR (-20080, 
                'Current invoice is locked (closed), so you cannot edit it');
        END IF ;
    END IF ;
    
    IF DELETING OR (UPDATING AND :NEW.invoice_id <> :OLD.invoice_id) THEN
        SELECT is_closed INTO v_is_closed FROM invoices
        WHERE invoice_id = :OLD.invoice_id ;
        
        IF v_is_closed = 'T' THEN  
            RAISE_APPLICATION_ERROR (-20081, 
                'Current invoice is locked (closed), so you cannot edit it');
        END IF ;
    END IF ;
        
END ;
/



--====================================================================================
--                      test the triggers

-- extract the last  invoice
SELECT * FROM invoices WHERE invoice_id = (SELECT MAX(invoice_id) FROM invoices) ; 
-- in my db, the last invoice has id 61 and date '01-11-2014 ' 

SELECT * FROM invoice_details WHERE invoice_id = 61 ;

-- next DELETE must be blocked!
DELETE FROM invoice_details WHERE invoice_id = 61 AND row_number = 3 ;

-- next DELETE is accepted, but we will ROLLBACK it
SELECT * FROM invoice_details WHERE invoice_id = 60 ;
DELETE FROM invoice_details WHERE invoice_id = 60 AND row_number = 2 ;
ROLLBACK ;




