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

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-02a_BusinessRules4__closed_months.sql

See also the presentation:
https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-02_en_Business%20Rules%20with%20PL%20SQL%20(2).pptx

*/



--====================================================================================
-- 	        Business Rules Implemented with Oracle PL/SQL triggers - part V: 
--                Controlling user access to records to be edited 
--====================================================================================
--
-- There are also other options for controlling user access in Oracle:
--      * Views
--      * Virtual Private Databases


/*
	Problem description: 
	    Internal users can have assigned group of entities (customers, students, employees...).
	    They have the rights to edit the records only to allocated entities.

    In SALES database, we'll give explicit rights for an user to update the invoices (refusals, 
        payments) only of some specific customers.
 
    Table "user_rights" assigns users to customers.
    Tables "customers", "invoices", "invoice_detais", ... check if the user doing current
       updates has privileges (rights) for current customer's data 
*/
		
--====================================================================================
DROP TABLE user_rights ;

CREATE TABLE user_rights (
	user_name VARCHAR2(30),
	cust_id INTEGER
        	CONSTRAINT fk_ur_customers REFERENCES customers(cust_id),
	has_rights_to_insert CHAR(1) DEFAULT 'N' NOT NULL
		CONSTRAINT ck_drept_ins CHECK (has_rights_to_insert IN ('Y','N')),
	has_rights_to_update CHAR(1) DEFAULT 'N' NOT NULL
		CONSTRAINT ck_drept_upd CHECK (has_rights_to_update IN ('Y','N')),
	has_rights_to_delete CHAR(1) DEFAULT 'N' NOT NULL
		CONSTRAINT ck_drept_del CHECK (has_rights_to_delete IN ('Y','N')),
	comments VARCHAR2(200), 	
	PRIMARY KEY (user_name, cust_id)
	) ;

--
--====================================================================================
--                  a new package - pac_user_rights
-----------------------------------------------
CREATE OR REPLACE PACKAGE pac_user_rights IS
-----------------------------------------------
	FUNCTION f_find_customer (invoice_id_ invoices.invoice_id%TYPE) RETURN customers.cust_id%TYPE ;

	FUNCTION f_user_has_rights (user_ VARCHAR2, cust_id_ customers.cust_id%TYPE, 
		edit_type CHAR) RETURN BOOLEAN ;

END pac_user_rights ;
/

-----------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_user_rights IS
-----------------------------------------------
--
FUNCTION f_find_customer (invoice_id_ invoices.invoice_id%TYPE) 
	RETURN customers.cust_id%TYPE 
IS
	v_cust_id customers.cust_id%TYPE ;
BEGIN 
	SELECT cust_id INTO v_cust_id FROM invoices WHERE invoice_id=invoice_id_ ;
	RETURN v_cust_id ;
END ;

--
FUNCTION f_user_has_rights (user_ VARCHAR2, cust_id_ customers.cust_id%TYPE,
		edit_type CHAR ) 
	RETURN BOOLEAN 
IS
	v_string CHAR(1) ; 
BEGIN
	CASE 
	  WHEN edit_type = 'I' THEN 	
		SELECT has_rights_to_insert INTO v_string FROM user_rights
		WHERE user_name = user_ AND cust_id=cust_id_ ;
	  WHEN edit_type = 'U' THEN 	
		SELECT has_rights_to_update INTO v_string FROM user_rights
		WHERE user_name = user_ AND cust_id=cust_id_ ;
	  WHEN edit_type = 'D' THEN 	
		SELECT has_rights_to_delete INTO v_string FROM user_rights
		WHERE user_name = user_ AND cust_id=cust_id_ ;
	END CASE ;
	RETURN CASE v_string WHEN 'Y' THEN TRUE ELSE FALSE END ;
EXCEPTION
	WHEN NO_DATA_FOUND THEN 
	RETURN FALSE ;
END ;

END pac_user_rights ;
/

--====================================================================================
--
--                  Triggers controlling the current user rights
--
--====================================================================================

-------------------------------------------------------------------------------------
-- for table "customers" we accept new customers added by every user, but no updates or deletes
CREATE OR REPLACE TRIGGER trg_customers_rights
	BEFORE UPDATE OR DELETE ON customers FOR EACH ROW 
BEGIN
    -- we have a super user (fully authorized for all the customers' data
    IF USER <> 'SDBIS' THEN
	    IF DELETING THEN 
		    IF pac_user_rights.f_user_has_rights (USER, :OLD.cust_id, 'D') = FALSE THEN
			    RAISE_APPLICATION_ERROR(-20401, 'You do not have permission to delete the current customer!') ;
		    END IF ;
	    ELSE	
		    IF pac_user_rights.f_user_has_rights (USER, :NEW.cust_id, 'U') = FALSE 	OR 
				    pac_user_rights.f_user_has_rights (USER, :OLD.cust_id, 'U') = FALSE THEN
			    RAISE_APPLICATION_ERROR(-20402, 'You do not have permission to edit data for current customer!') ;
		    END IF ;		
	    END IF ;
	END IF ;	
END ;
/

-------------------------------------------------------------------------------------
-- trigger for table "invoices" 
CREATE OR REPLACE TRIGGER trg_invoices_rights
	BEFORE INSERT OR UPDATE OR DELETE ON invoices FOR EACH ROW 

BEGIN
    -- we have a super user (fully authorized for all the customers' data
    IF USER <> 'SDBIS' THEN
	    IF INSERTING THEN 
		    IF pac_user_rights.f_user_has_rights (USER, :new.cust_id, 'I') = FALSE THEN
			    RAISE_APPLICATION_ERROR(-20403, 
			    	'You do not have permission to insert invoices for the current customer!') ;
		    END IF ;
        END IF ;
	    IF UPDATING THEN 
		    IF pac_user_rights.f_user_has_rights (USER, :NEW.cust_id, 'U') = FALSE 	OR 
				    pac_user_rights.f_user_has_rights (USER, :OLD.cust_id, 'U') = FALSE THEN
			    RAISE_APPLICATION_ERROR(-20404, 
			    	'You do not have permission to edit invoices for current customer!') ;
		    END IF ;		
	    END IF ;

	    IF DELETING THEN 
		    IF pac_user_rights.f_user_has_rights (USER, :OLD.cust_id, 'D') = FALSE THEN
			    RAISE_APPLICATION_ERROR(-20405, 
			    	'You do not have permission to delete invoices for the current customer!') ;
		    END IF ;
	    END IF ;
	END IF ;	
END ;
/



--
-- to be testes and continued with triggers for tables: "invoice_details", "receipt_details", "cancelled_invoices"
--

