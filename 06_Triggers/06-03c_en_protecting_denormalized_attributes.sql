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


See also the presentation:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-03_en_Triggers%20-%20part%203.pptx


*/

--====================================================================================
-- 		            Triggers for protecting denormalized attributes   
--====================================================================================

/* 
    Keeping denormalized tables/attributes synchronized with the "base" 
        tables/attributes does not limit to cascading updates 
    Equally important is to prevent direct updates of denormalizaed attributes
    
    For example, at this moment, the next update will be executed and would ruin
        synchronization "invoices"-"invoice_details" (also the values of other
        attributes in which the update will propagate - tables "customers", 
        "months", etc.)
*/

SELECT * 
FROM (SELECT * FROM invoices ORDER BY invoice_id DESC)
WHERE rownum = 1 ;

SELECT * FROM invoices WHERE invoice_id = 62 ;

UPDATE invoices SET invoice_amount = 1234567890 WHERE invoice_id = 62 ;

SELECT * FROM invoices WHERE invoice_id = 62 ;

-- revert the update 
ROLLBACK ;


/*  Next we'll create a series of triggers targeted to protect all the 
        denormalized attributes/tables from unauthorized updates (i.e. updates
            that put in jeopardy database integrity
*/            
 
 
/*
====================================================================================
  Proposed solution: 
  Use public variables as flags for signaling which updates
    are results of the triggers.
  Triggers of the denormalizaed tables/attributes will check the flag status and
    block any update that is resutl to a direct INSERT/UPDATE/DELETEE statement
     ("direct" means launched/executed otherwise than from the "authorized" triggers	   
====================================================================================

*/

--------------------------------------------------------------
-- we'll create a package for public variables;
--   a public variable will be created for every source table 
-- (source tables stored primary data, being the base for updating
--    denemolized tables/attributes
--------------------------------------------------------------
CREATE OR REPLACE PACKAGE public_variables AS
    --  variabilele publice (la nivel de sesiune)
    v_trg_invoices BOOLEAN := FALSE ;
    v_trg_invoice_details BOOLEAN := FALSE ;
    v_trg_products BOOLEAN := FALSE ;
    v_trg_receipt_details BOOLEAN := FALSE ;

    v_trg_cancelled_invoices BOOLEAN := FALSE ;
    v_trg_refusals BOOLEAN := FALSE ;
    v_trg_refused_products BOOLEAN := FALSE ;

/*  
    v_invoice_id invoices.v_invoice_id%TYPE ;
    TYPE t_v_invoice_id IS TABLE OF invoices.v_invoice_id%TYPE INDEX BY PLS_INTEGER ;
    va_v_invoice_id t_v_invoice_id ;
*/    
    
END ; -- end of "public_variables" package specifications
/

-- "public_variables" has no body, at least for the moment


--====================================================================================
--                              Case 1 (simpler)
-- 	  Forbidding any record insert, update, or delete in table "former_vat_percents"
--        that is NOT a result of one of the table "products "triggers      
--====================================================================================

---------------------------------------------------------------------------------------
--  First, create two simple triggers for insert/update/delete of table "products", one
--   of type BEFORE-STATEMENT and one of type AFTER-STATEMENT

CREATE OR REPLACE TRIGGER trg_products_pub1
    BEFORE INSERT OR UPDATE OR DELETE ON products 
BEGIN
    public_variables.v_trg_products := TRUE ;
END ;
/
CREATE OR REPLACE TRIGGER trg_products_pub2
    AFTER INSERT OR UPDATE OR DELETE ON products 
BEGIN
    public_variables.v_trg_products := FALSE ;
END ;
/

---------------------------------------------------------------------------------------
--  Second, in all of the triggers of tables "former_vat_percents", test if the public
-- variable "v_trg_products" is set on TRUE; if so, the update in "former_vat_percents"
-- is a consequence of one of the triggers of table "products", anf that's ok; 
--   otherwise, the current operation on "former_vat_percents" would be aborted

CREATE OR REPLACE TRIGGER trg_former_vat
    BEFORE INSERT OR UPDATE OR DELETE ON former_vat_percents 
BEGIN
    IF public_variables.v_trg_products = FALSE THEN
        RAISE_APPLICATION_ERROR (-20014, 
    		'Table `former_vat_percents` cannot be edited interactively');
    END IF ;
END ;
/

---------------------------------------------------------------------------------------
--      test
SELECT * FROM products ;
SELECT * FROM former_vat_percents ;

-- next UPDATE must be blocked:
UPDATE former_vat_percents 
SET vat_percent = 0.24 WHERE product_id = 6 AND date_until IS NULL ;
/*
UPDATE former_vat_percents 
SET vat_percent = 0.24 WHERE product_id = 6 AND date_until IS NULL 
Error report -
SQL Error: ORA-20014: Table former_vat_percents cannot be edited interactively
ORA-06512: la "SDBIS.TRG_FORMER_VAT", linia 3
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_FORMER_VAT'
*/

-- next update is accepted:
UPDATE products SET current_vat_percent = 0.24 WHERE product_id = 6 ;
SELECT * FROM products ;
SELECT * FROM former_vat_percents ;
-- we'll rollback the update, for not having two VAT changes in the same day
ROLLBACK ;




--====================================================================================
-- Case 2:
-- 	In table "invoices", attributes "invoice_VAT", "invoice_amount" and "n_of_rows"
--    must be updated only through triggers of table "invoice_details"       
--====================================================================================
---------------------------------------------------------------------------------------
--  First, create two simple triggers for insert/update/delete of table "invoice_details",
--     one of type BEFORE-STATEMENT and one of type AFTER-STATEMENT
CREATE OR REPLACE TRIGGER trg_invoice_details_pub1
    BEFORE INSERT OR UPDATE OR DELETE ON invoice_details 
BEGIN
    public_variables.v_trg_invoice_details := TRUE ;
END ;
/
CREATE OR REPLACE TRIGGER trg_invoice_details_pub2
    AFTER INSERT OR UPDATE OR DELETE ON invoice_details 
BEGIN
    public_variables.v_trg_invoice_details := FALSE ;
END ;
/
---------------------------------------------------------------------------------------
--  Second, create a new UPDATE trigger for checking if those three attributes 
--    are changes trought the triggers of "invoice_details" 
CREATE OR REPLACE TRIGGER trg_invoices_inv_details
    BEFORE UPDATE OF invoice_VAT, invoice_amount, n_of_rows  ON invoices
BEGIN
    IF public_variables.v_trg_invoice_details = FALSE THEN
        RAISE_APPLICATION_ERROR (-20015, 
    		'Attributes `invoice_VAT`, `invoice_amount`, and `n_of_rows` cannot be edited interactively');
    END IF ;
END ;
/

---------------------------------------------------------------------------------------
--      test
SELECT * 
FROM (SELECT * FROM invoices ORDER BY invoice_id DESC)
WHERE rownum = 1 ;

SELECT * FROM invoices WHERE invoice_id = 62 ;
SELECT * FROM invoice_details WHERE invoice_id = 62 ;

-- next insert (and consequenting triggers) must run without any problem:
INSERT INTO invoice_details VALUES (62, 3, 100, 1000, 3, NULL);

SELECT * FROM invoices WHERE invoice_id = 62 ;
SELECT * FROM invoice_details WHERE invoice_id = 62 ;

COMMIT ;

-- now the unauhorisez update of "invoice_amout" will be blocked
UPDATE invoices SET invoice_amount = 1234567890 WHERE invoice_id = 62 ;
/*
UPDATE invoices SET invoice_amount = 1234567890 WHERE invoice_id = 62 
Error report -
SQL Error: ORA-20015: Attributes invoice_VAT, invoice_amount, or n_of_rows cannot be edited interactively
ORA-06512: la "SDBIS.TRG_INVOICES_INV_DETAILS", linia 3
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_INVOICES_INV_DETAILS'
*/


/*
====================================================================================
                          Rest of the cases:
 	1. For all the the tables whose triggers update denormalized attributes 
    in other tables we'll create a pair of triggers, 
     one of type BEFORE-STATEMENT and one of type AFTER-STATEMENT
     
    2. For the tables with computed attributes we'll define a trigger for
            every attribute (or group of attributes) updates in which the public variable
            flag will be testes and, consequently, the denormalized attribute update 
            will be authorized or denied
--====================================================================================
*/


---------------------------------------------------------------------------------------
-- 	For all the the tables whose triggers update denormalized attributes 
--    in other tables we'll create a pair of triggers, 
--     one of type BEFORE-STATEMENT and one of type AFTER-STATEMENT
---------------------------------------------------------------------------------------


-- Notice: Creation of the next triggers can be done more elegantly with dynamic SQL
--    (see the first lecture in January)

/* The "source" (of the updates of the tables are:
    cancelled_invoices
    invoice_details
    invoices
    products
    receipt_details
    refusals
    refused_products
*/

-- cancelled_invoices
CREATE OR REPLACE TRIGGER trg_cancel_inv_pub1
    BEFORE INSERT OR UPDATE OR DELETE ON cancelled_invoices 
BEGIN
    public_variables.v_trg_cancelled_invoices := TRUE ;
END ;
/
CREATE OR REPLACE TRIGGER trg_cancel_inv_pub2
    AFTER INSERT OR UPDATE OR DELETE ON cancelled_invoices 
BEGIN
    public_variables.v_trg_cancelled_invoices := FALSE ;
END ;
/

-- invoice_details
-- triggers already created

-- invoices
CREATE OR REPLACE TRIGGER trg_invoices_pub1
    BEFORE INSERT OR UPDATE OR DELETE ON invoices 
BEGIN
    public_variables.v_trg_invoices := TRUE ;
END ;
/
CREATE OR REPLACE TRIGGER trg_invoices_pub2
    AFTER INSERT OR UPDATE OR DELETE ON invoices 
BEGIN
    public_variables.v_trg_invoices := FALSE ;
END ;
/

-- products
-- triggers already created

-- receipt_details
CREATE OR REPLACE TRIGGER trg_receipt_details_pub1
    BEFORE INSERT OR UPDATE OR DELETE ON receipt_details 
BEGIN
    public_variables.v_trg_receipt_details := TRUE ;
END ;
/
CREATE OR REPLACE TRIGGER trg_receipt_details_pub2
    AFTER INSERT OR UPDATE OR DELETE ON receipt_details 
BEGIN
    public_variables.v_trg_receipt_details := FALSE ;
END ;
/

-- refusals
CREATE OR REPLACE TRIGGER trg_refusals_pub1
    BEFORE INSERT OR UPDATE OR DELETE ON refusals 
BEGIN
    public_variables.v_trg_refusals := TRUE ;
END ;
/
CREATE OR REPLACE TRIGGER trg_refusals_pub2
    AFTER INSERT OR UPDATE OR DELETE ON refusals 
BEGIN
    public_variables.v_trg_refusals := FALSE ;
END ;
/

-- refused_products
CREATE OR REPLACE TRIGGER trg_refused_products_pub1
    BEFORE INSERT OR UPDATE OR DELETE ON refused_products 
BEGIN
    public_variables.v_trg_refused_products := TRUE ;
END ;
/
CREATE OR REPLACE TRIGGER trg_refused_products_pub2
    AFTER INSERT OR UPDATE OR DELETE ON refused_products 
BEGIN
    public_variables.v_trg_refused_products := FALSE ;
END ;
/



/*
---------------------------------------------------------------------------------------
    For the tables with computed attributes we'll define a trigger for
            every attribute (or group of attributes) updates in which the public variable
            flag will be testes and, consequently, the denormalized attribute update 
            will be authorized or denied
---------------------------------------------------------------------------------------
*/

---------------------------------------------------------------------------------------
--          customer_monthly_stats
---------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_cust_mon_stat__sales
    BEFORE UPDATE OF sales ON customer_monthly_stats
BEGIN
    -- update of "sales" must be a result of table "invoices" triggers
    IF public_variables.v_trg_invoices = FALSE THEN
        RAISE_APPLICATION_ERROR (-20016, 
    		'Attribute `sales` cannot be edited interactively');
    END IF ;
END ;
/
CREATE OR REPLACE TRIGGER trg_cust_mon_stat__refusals
    BEFORE UPDATE OF refusals ON customer_monthly_stats
BEGIN
    -- update of "refusals" must be a result of table "refusals" triggers
    IF public_variables.v_trg_refusals = FALSE THEN
        RAISE_APPLICATION_ERROR (-20017, 
    		'Attribute `refusals` cannot be edited interactively');
    END IF ;
END ;
/
CREATE OR REPLACE TRIGGER trg_cust_mon_stat__cancel
    BEFORE UPDATE OF cancellations ON customer_monthly_stats
BEGIN
    -- update of "cancellations" must be a result of table "cancelled_invoices" triggers
    IF public_variables.v_trg_cancelled_invoices = FALSE THEN
        RAISE_APPLICATION_ERROR (-20018, 
    		'Attribute `cancellations` cannot be edited interactively');
    END IF ;
END ;
/
CREATE OR REPLACE TRIGGER trg_cust_mon_stat__received
    BEFORE UPDATE OF received ON customer_monthly_stats
BEGIN
    -- update of "received" must be a result of table "receipt_details" triggers
    IF public_variables.v_trg_receipt_details = FALSE THEN
        RAISE_APPLICATION_ERROR (-20019, 
    		'Attribute `received` cannot be edited interactively');
    END IF ;
END ;
/

---------------------------------------------------------------------------------------
--          customers
---------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_customers__crt_bal
    BEFORE UPDATE OF current_balance ON customers
BEGIN
    -- update of "current_balance" must be a result of table "invoices" triggers
    --   or table "cancelled_invoices" triggers or table "refusals" triggers
    
    IF public_variables.v_trg_invoices = FALSE AND 
            public_variables.v_trg_cancelled_invoices = FALSE AND
            public_variables.v_trg_refusals = FALSE THEN
        RAISE_APPLICATION_ERROR (-20021, 
    		'Attribute `current_balance` cannot be edited interactively');
    END IF ;
END ;
/

---------------------------------------------------------------------------------------
--          former_contacts
---------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_former_contacts
    BEFORE INSERT OR UPDATE OR DELETE ON former_contacts 
BEGIN
    IF public_variables.v_trg_products = FALSE THEN
        RAISE_APPLICATION_ERROR (-20022, 
    		'Table `former_contacts` cannot be edited interactively');
    END IF ;
END ;
/

---------------------------------------------------------------------------------------
--         former_vat_percents - trigger created previously
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
--         invoices
---------------------------------------------------------------------------------------
--         trg_invoices_inv_details - trigger created previously
---------------------------------------------------------------------------------------

-- ... we continue with refusals 
CREATE OR REPLACE TRIGGER trg_invoices_refusals
    BEFORE UPDATE OF amount_refused ON invoices
BEGIN
    -- update of "amount_refused" must be a result of table "refusals" triggers
    IF public_variables.v_trg_refusals = FALSE THEN
        RAISE_APPLICATION_ERROR (-20023, 
    		'Attribute `amount_refused` cannot be edited interactively');
    END IF ;
END ;
/

-- ... and amount_received 
CREATE OR REPLACE TRIGGER trg_invoices_received
    BEFORE UPDATE OF amount_received ON invoices
BEGIN
    -- update of "amount_received" must be a result of table "receipt_details" triggers
    IF public_variables.v_trg_receipt_details = FALSE THEN
        RAISE_APPLICATION_ERROR (-20024, 
    		'Attribute `amount_received` cannot be edited interactively');
    END IF ;
END ;
/

---------------------------------------------------------------------------------------
--          months
---------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_months__sales
    BEFORE UPDATE OF sales_total ON months
BEGIN
    -- update of "sales_total" must be a result of table "invoices" triggers
    IF public_variables.v_trg_invoices = FALSE THEN
        RAISE_APPLICATION_ERROR (-20025, 
    		'Attribute `sales_total` cannot be edited interactively');
    END IF ;
END ;
/
CREATE OR REPLACE TRIGGER trg_months__refusals
    BEFORE UPDATE OF refusals_total ON months
BEGIN
    -- update of "refusals_total" must be a result of table "refusals" triggers
    IF public_variables.v_trg_refusals = FALSE THEN
        RAISE_APPLICATION_ERROR (-20026, 
    		'Attribute `refusals_total` cannot be edited interactively');
    END IF ;
END ;
/
CREATE OR REPLACE TRIGGER trg_months__cancel
    BEFORE UPDATE OF cancellations_total ON months
BEGIN
    -- update of "cancellations_total" must be a result of table "cancelled_invoices" triggers
    IF public_variables.v_trg_cancelled_invoices = FALSE THEN
        RAISE_APPLICATION_ERROR (-20027, 
    		'Attribute `cancellations_total` cannot be edited interactively');
    END IF ;
END ;
/
CREATE OR REPLACE TRIGGER trg_months__received
    BEFORE UPDATE OF received_total ON months
BEGIN
    -- update of "received_total" must be a result of table "receipt_details" triggers
    IF public_variables.v_trg_receipt_details = FALSE THEN
        RAISE_APPLICATION_ERROR (-20028, 
    		'Attribute `received_total` cannot be edited interactively');
    END IF ;
END ;
/


---------------------------------------------------------------------------------------
--          product_monthly_stats
---------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_prod_mon_stat__sales
    BEFORE UPDATE OF sales ON product_monthly_stats
BEGIN
    -- update of "sales" must be a result of table "invoices" triggers
    IF public_variables.v_trg_invoices = FALSE AND
            public_variables.v_trg_invoice_details = FALSE THEN
        RAISE_APPLICATION_ERROR (-20030, 
    		'Attribute `sales` cannot be edited interactively');
    END IF ;
END ;
/
CREATE OR REPLACE TRIGGER trg_prod_mon_stat__refusals
    BEFORE UPDATE OF refusals ON product_monthly_stats
BEGIN
    -- update of "refusals" must be a result of table "refused_products" triggers
    IF public_variables.v_trg_refused_products = FALSE THEN
        RAISE_APPLICATION_ERROR (-20031, 
    		'Attribute `refusals` cannot be edited interactively');
    END IF ;
END ;
/
CREATE OR REPLACE TRIGGER trg_prod_mon_stat__cancel
    BEFORE UPDATE OF cancellations ON product_monthly_stats
BEGIN
    -- update of "cancellations" must be a result of table "cancelled_invoices" triggers
    IF public_variables.v_trg_cancelled_invoices = FALSE THEN
        RAISE_APPLICATION_ERROR (-20032, 
    		'Attribute `cancellations` cannot be edited interactively');
    END IF ;
END ;
/

---------------------------------------------------------------------------------------
--         receipts
---------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_receipts__rec_details
    BEFORE UPDATE OF amount_paid ON receipts
BEGIN
    -- update of "amount_paid" must be a result of table "receipt_details" triggers
    IF public_variables.v_trg_receipt_details = FALSE THEN
        RAISE_APPLICATION_ERROR (-20035, 
    		'Attribute `amount_paid` cannot be edited interactively');
    END IF ;
END ;
/




---------------------------------------------------------------------------------------
--         to be tested during lectures
---------------------------------------------------------------------------------------

