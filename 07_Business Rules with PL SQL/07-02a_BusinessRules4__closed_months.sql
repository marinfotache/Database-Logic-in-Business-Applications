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

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-01b_BusinessRules2__invoice_locking.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-01c_BusinessRules3__inv_rows_numbers.sql

See also the presentation:
https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-02_en_Business%20Rules%20with%20PL%20SQL%20(2).pptx

*/



--====================================================================================
-- 	        Business Rules Implemented with Oracle PL/SQL triggers - part IV: 
--                          blocking/closing months (in Finance/Accounting)
--====================================================================================
-- After general ledger, VAT and other financial statements were finalized (that can
--    happen each monthly, quartely, twice a year or yearly), the operations incoporated
--    in finished statements cannot be modifies - financial-accounting closing

-- Next we'll see how to implement this business rule with triggers




--==================================================================================== 
--              table "closed_months" keeps record of blocked months
DROP TABLE closed_months ;

CREATE TABLE closed_months (
	year NUMBER(4),
	month NUMBER(2),
	closing_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	user_ VARCHAR2(30) DEFAULT user,
	comments VARCHAR2(200),
	PRIMARY KEY (year, month)
	) ;


--==================================================================================== 
--	Package pac_closed_months contains:
--		- a public variable showing the last blocked day
--		- a procedure for public variables initialization 
--
CREATE OR REPLACE PACKAGE pac_closed_months IS
	v_last_blocked_day DATE := NULL ;
	PROCEDURE p_init_closing ;
	--      * pac_sales_3.f_invoice_date
    --      * pac_sales_4.f_receipt_date
END pac_closed_months ;
/

-----------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_closed_months IS
-----------------------------------------------
PROCEDURE p_init_closing
IS
BEGIN 
	SELECT LAST_DAY(TO_DATE('01/'||month||'/'||year, 'dd/mm/yyyy'))
	INTO  v_last_blocked_day
	FROM closed_months
	WHERE TO_DATE('01/'||month||'/'||year, 'dd/mm/yyyy') = 
		(SELECT MAX(TO_DATE('01/'||month||'/'||year, 'dd/mm/yyyy'))
		 FROM closed_months ) ;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	    -- first closed month will be considered the month before the first invoice
	    SELECT ADD_MONTHS(LAST_DAY(MIN(invoice_date)), -1) INTO v_last_blocked_day 
	    FROM invoices ;
END p_init_closing ;

--------------------------------------------------------------------------
END pac_closed_months ;
/

--==================================================================================== 
--
--  					Triggers for table "closed_months"
--

-- INSERT trigger
CREATE OR REPLACE TRIGGER trg_closed_months_ins_br
	BEFORE INSERT ON closed_months FOR EACH ROW
BEGIN 
	:NEW.user_ := user ;
	:NEW.closing_ts := CURRENT_TIMESTAMP ;

	IF pac_closed_months.v_last_blocked_day IS NULL THEN
		pac_closed_months.p_init_closing  ;
	END IF ;

	IF ADD_MONTHS (pac_closed_months.v_last_blocked_day, 1) <> 
		LAST_DAY(TO_DATE('01/'||:NEW.month||'/'||:NEW.year, 'dd/mm/yyyy')) THEN
	    	RAISE_APPLICATION_ERROR(-20556, 'Months must be closed one after another (no gaps, please) !') ;
	END IF ;
	pac_closed_months.v_last_blocked_day := LAST_DAY(TO_DATE('01/'||:NEW.month||'/'||:NEW.year, 'dd/mm/yyyy')) ;		
END ;
/

-----------------------------------------------
-- UPDATE trigger that will block the updates of table "closed_months"
CREATE OR REPLACE TRIGGER trg_closed_months_upd_br
	BEFORE UPDATE ON closed_months FOR EACH ROW
BEGIN 
	RAISE_APPLICATION_ERROR(-20557, 'In table <<closed_months>> records can be only appended and deleted !')  ;
END ;
/
-----------------------------------------------
-- the DELETE trigger - when a new month is blocked, public variable "v_last_blocked_day" must be updated
-- also only the last closed month can be deleted
CREATE OR REPLACE TRIGGER trg_closed_months_del_br
	BEFORE DELETE ON closed_months FOR EACH ROW
BEGIN 
	IF pac_closed_months.v_last_blocked_day IS NULL THEN
		pac_closed_months.p_init_closing  ;
	END IF ;
	IF pac_closed_months.v_last_blocked_day <> 
		LAST_DAY(TO_DATE('01/'||:OLD.month||'/'||:OLD.year, 'dd/mm/yyyy')) THEN
    		RAISE_APPLICATION_ERROR(-20558, 'Sorry, only the last blocked month can be deleted !') ;
	ELSE 
		pac_closed_months.p_init_closing  ;		
	END IF;
END ;
/

--==================================================================================== 

INSERT INTO closed_months (year, month) VALUES (2013,8) ;
COMMIT ;


-- we'll try to jump over August 2013 and to close October 2013
INSERT INTO closed_months (year, month) VALUES (2013,10) ;

/*
Error starting at line : 5 in command -
INSERT INTO closed_months (year, month) VALUES (2013,10) 
Error report -
SQL Error: ORA-20556: Months must be closed one after another (no gaps, please) !
ORA-06512: la "SDBIS.TRG_CLOSED_MONTHS_INS_BR", linia 11
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_CLOSED_MONTHS_INS_BR'
*/

INSERT INTO closed_months (year, month) VALUES (2013,9) ;
INSERT INTO closed_months (year, month) VALUES (2013,10) ;
COMMIT ;

-- utilities
-- display the public variable
begin 
dbms_output.put_line(pac_closed_months.v_last_blocked_day);
end ;
/

-- set the public variable on NULL
begin 
  pac_closed_months.v_last_blocked_day := null;
end ;
/


--==================================================================================== 
--
--                                  Breaking News :-)			
--  At the end of a package body an anonymous block can be inserted; it will
--      be executed once per session (at first call of a package variable, procedure
--      or function) 			
--
--  So, we' ll update the package body
-----------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_closed_months IS
-----------------------------------------------
PROCEDURE p_init_closing
IS
BEGIN 
	SELECT LAST_DAY(TO_DATE('01/'||month||'/'||year, 'dd/mm/yyyy'))
	INTO  v_last_blocked_day
	FROM closed_months
	WHERE TO_DATE('01/'||month||'/'||year, 'dd/mm/yyyy') = 
		(SELECT MAX(TO_DATE('01/'||month||'/'||year, 'dd/mm/yyyy'))
		 FROM closed_months ) ;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
	    -- first closed month will be considered the month before the first invoice
	    SELECT ADD_MONTHS(LAST_DAY(MIN(invoice_date)), -1) INTO v_last_blocked_day 
	    FROM invoices ;
END p_init_closing ;
-----------------------------------------------

-- this is the initialization anonymous block we talked about
BEGIN
	pac_closed_months.p_init_closing ;
END pac_closed_months ;
/

--==================================================================================== 
--                      Mutating tables (part II)

SELECT * FROM closed_months ;

DELETE FROM closed_months WHERE year=2013 AND month = 10 ;
/*
Error starting at line : 1 in command -
DELETE FROM closed_months WHERE year=2013 AND month = 10 
Error report -
SQL Error: ORA-04091: tabela SDBIS.CLOSED_MONTHS este schimbatoare, triggerul/functia nu o poate vedea
ORA-06512: la "SDBIS.PAC_CLOSED_MONTHS", linia 6
ORA-06512: la "SDBIS.TRG_CLOSED_MONTHS_DEL_BR", linia 9
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_CLOSED_MONTHS_DEL_BR'
04091. 00000 -  "table %s.%s is mutating, trigger/function may not see it"
*Cause:    A trigger (or a user defined plsql function that is referenced in
           this statement) attempted to look at (or modify) a table that was
           in the middle of being modified by the statement which fired it.
*Action:   Rewrite the trigger (or function) so it does not read that table.
*/

-----------------------------------------------
-- for DELETE two triggers will be created, on of type BEFORE ROW ...
CREATE OR REPLACE TRIGGER trg_closed_months_del_br
	BEFORE DELETE ON closed_months FOR EACH ROW
BEGIN 
	IF pac_closed_months.v_last_blocked_day <> 
		LAST_DAY(TO_DATE('01/'||:OLD.month||'/'||:OLD.year, 'dd/mm/yyyy')) THEN
    		RAISE_APPLICATION_ERROR(-20558, 'Sorry, only the last blocked month can be deleted !') ;
	END IF;
END ;
/

-- ... and another of type AFTER STATEMENT (to avoid "mutation")
CREATE OR REPLACE TRIGGER trg_closed_months_del_as
	AFTER DELETE ON closed_months 
BEGIN 
	pac_closed_months.p_init_closing  ;		
END ;
/


-- Now it works !

DELETE FROM closed_months WHERE year=2013 AND month = 10 ;
COMMIT ;


--==================================================================================== 
--
--  	Change the triggers for table "invoices" for dealing with closed months			
--
--====================================================================================  
CREATE OR REPLACE TRIGGER trg_invoices_mon_closed
    BEFORE INSERT OR UPDATE OR DELETE ON invoices FOR EACH ROW
BEGIN
    IF INSERTING OR (UPDATING AND :NEW.invoice_id <> :OLD.invoice_id OR 
            :NEW.invoice_number <> :OLD.invoice_number OR :NEW.invoice_date <> :OLD.invoice_date OR
            :NEW.cust_id <> :OLD.cust_id OR :NEW.invoice_VAT <> :OLD.invoice_VAT OR
            :NEW.invoice_amount <> :OLD.invoice_amount OR :NEW.n_of_rows <> :OLD.n_of_rows OR
            :NEW.is_closed <> :OLD.is_closed) THEN
    
        IF :NEW.invoice_date <= pac_closed_months.v_last_blocked_day THEN
           RAISE_APPLICATION_ERROR (-20091, 
                'Month of the current invoice is closed!');
        END IF ;
    END IF ;
    
    IF DELETING OR (UPDATING AND :NEW.invoice_id <> :OLD.invoice_id OR 
            :NEW.invoice_number <> :OLD.invoice_number OR :NEW.invoice_date <> :OLD.invoice_date OR
            :NEW.cust_id <> :OLD.cust_id OR :NEW.invoice_VAT <> :OLD.invoice_VAT OR
            :NEW.invoice_amount <> :OLD.invoice_amount OR :NEW.n_of_rows <> :OLD.n_of_rows OR
            :NEW.is_closed <> :OLD.is_closed) THEN
    
        IF :OLD.invoice_date <= pac_closed_months.v_last_blocked_day THEN
           RAISE_APPLICATION_ERROR (-20092, 
                'Month of the OLD invoice is closed!');
        END IF ;
    END IF ;
END ;
/


--==================================================================================== 
--      test 

-- insert an invoice in a month already closed 
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1123, DATE'2013-08-08', pac_sales.f_cust_id('Client A SRL'));
  /*
Error starting at line : 1 in command -
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (1123, DATE'2013-08-08', pac_sales.f_cust_id('Client A SRL'))
Error report -
SQL Error: ORA-20091: Month of the current invoice is closed!
ORA-06512: la "SDBIS.TRG_INVOICES_MON_CLOSED", linia 11
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_INVOICES_MON_CLOSED'    
*/
    


-- insert an invoice in a month not closed 
INSERT INTO invoices (invoice_number, invoice_date, cust_id)  
    VALUES (13222, DATE'2014-12-02', pac_sales.f_cust_id('Client C SRL'));
-- it works
COMMIT ;


-- next UPDATE should be blocked as the invoice date is on a closed month
UPDATE invoices SET cust_id = 1002 WHERE invoice_number = '1111' ;
/*
Error starting at line : 1 in command -
UPDATE invoices SET cust_id = 1002 WHERE invoice_number = '1111' 
Error report -
SQL Error: ORA-20091: Month of the current invoice is closed!
ORA-06512: la "SDBIS.TRG_INVOICES_MON_CLOSED", linia 11
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_INVOICES_MON_CLOSED'
*/


-- next UPDATE should work even the invoice date is on a closed month
--   (that's because comments are not affected by the month closing
UPDATE invoices SET comments = 'test 2016' WHERE invoice_number = '1111' ;
-- it works, but we don't keep the update
ROLLBACK ;




--==================================================================================== 
--
--  	Change the triggers for table "invoice_details" for dealing with closed months			
--
--====================================================================================  
CREATE OR REPLACE TRIGGER trg_inv_details_mon_closed
    BEFORE INSERT OR UPDATE OR DELETE ON invoice_details FOR EACH ROW
BEGIN
    IF INSERTING OR UPDATING THEN
        IF pac_sales_3.f_invoice_date(:NEW.invoice_id) <= pac_closed_months.v_last_blocked_day THEN
           RAISE_APPLICATION_ERROR (-20093, 
                'Month of the current invoice is closed!');
        END IF ;
    END IF ;
    
    IF DELETING OR UPDATING THEN
        IF pac_sales_3.f_invoice_date(:OLD.invoice_id) <= pac_closed_months.v_last_blocked_day THEN
           RAISE_APPLICATION_ERROR (-20094, 
                'Month of the OLD invoice is closed!');
        END IF ;
    END IF ;
END ;
/


--==================================================================================== 
--      test 
SELECT * FROM invoices WHERE invoice_number = 13222 ;
SELECT * FROM invoice_details WHERE invoice_id IN 
  (SELECT invoice_id FROM invoices WHERE invoice_number = 13222 ) ;

-- this works
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 13222), 1, 1, 50, 1010) ;


-- this does not work
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1115), 2, 1, 51, 1001) ;
/*
Error starting at line : 1 in command -
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price) 
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 1115), 2, 1, 51, 1001) 
Error report -
SQL Error: ORA-20093: Month of the current invoice is closed!
ORA-06512: la "SDBIS.TRG_INV_DETAILS_MON_CLOSED", linia 4
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_INV_DETAILS_MON_CLOSED'
*/
   

--==================================================================================== 
--
--  	Change the triggers for table "receipts" for dealing with closed months			
--


--====================================================================================  
CREATE OR REPLACE TRIGGER trg_receipts_mon_closed
    BEFORE INSERT OR UPDATE OR DELETE ON receipts FOR EACH ROW
BEGIN
    IF INSERTING OR (UPDATING AND :NEW.receipt_id <> :OLD.receipt_id OR 
            :NEW.receipt_date <> :OLD.receipt_date OR :NEW.receipt_docum_type <> :OLD.receipt_docum_type OR
            :NEW.receipt_docum_number <> :OLD.receipt_docum_number OR 
            :NEW.receipt_docum_date <> :OLD.receipt_docum_date OR
            :NEW.amount_paid <> :OLD.amount_paid ) THEN
    
        IF :NEW.receipt_date <= pac_closed_months.v_last_blocked_day THEN
           RAISE_APPLICATION_ERROR (-20096, 
                'Month of the current receipt is closed!');
        END IF ;
    END IF ;
    
    IF DELETING OR (UPDATING AND :NEW.receipt_id <> :OLD.receipt_id OR 
            :NEW.receipt_date <> :OLD.receipt_date OR :NEW.receipt_docum_type <> :OLD.receipt_docum_type OR
            :NEW.receipt_docum_number <> :OLD.receipt_docum_number OR 
            :NEW.receipt_docum_date <> :OLD.receipt_docum_date OR
            :NEW.amount_paid <> :OLD.amount_paid) THEN
    
        IF :OLD.receipt_date <= pac_closed_months.v_last_blocked_day THEN
           RAISE_APPLICATION_ERROR (-20097, 
                'Month of the OLD receipt is closed!');
        END IF ;
    END IF ;
END ;
/


--==================================================================================== 
--
--  	Change the triggers for table "receipt_details" for dealing with closed months			
--
--====================================================================================  
CREATE OR REPLACE TRIGGER trg_rec_details_mon_closed
    BEFORE INSERT OR UPDATE OR DELETE ON receipt_details FOR EACH ROW
BEGIN
    IF INSERTING OR UPDATING THEN
        IF pac_sales_4.f_receipt_date(:NEW.receipt_id) <= pac_closed_months.v_last_blocked_day THEN
           RAISE_APPLICATION_ERROR (-20098, 
                'Month of the current receipt is closed!');
        END IF ;
    END IF ;
    
    IF DELETING OR UPDATING THEN
        IF pac_sales_4.f_receipt_date(:OLD.receipt_id) <= pac_closed_months.v_last_blocked_day THEN
           RAISE_APPLICATION_ERROR (-20099, 
                'Month of the OLD receipt is closed!');
        END IF ;
    END IF ;
END ;
/
