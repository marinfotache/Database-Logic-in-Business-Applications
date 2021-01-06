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


See also the presentation:
https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-01_en_Business%20Rules%20with%20PL%20SQL%20(1).pptx

*/

--====================================================================================
-- 		       Business Rules Implemented with Oracle PL/SQL triggers - part I
--====================================================================================
--  1. Simple Business Rules
--
--      1.a. Date/timestamp attribute synchronization for attributes in the same table
--      Notice: If attributes to be sync are NOT NULLable, we don't need triggers,
--        but a simple CHECK CONSTRAINT, e.g.
--          ALTER TABLE receipts ADD CONSTRAINT ck_receipts_dt_order
--	            CHECK (receipt_docum_date <= receipt_date )  ;
--
--          * "former_contacts.from_" must precede "former_contacts.to_"
--          * "former_vat_percents.date_start" must precede "former_vat_percents.date_until"
--          * "receipts.receipt_docum_date" must precede "receipts.receipt_date"
--
--      1.b. Date/timestamp attribute synchronization for attributes in different tables
--         * "cancelled_invoices.cancellation_dt" cannot preceed "invoices.invoice_date"
--              (both "cancelled_invoices" and "invoices" tables synchronization)
--         * "receipt_details.receipt_date" cannot preceed "invoices.invoice_date"
--              for current paid invoice
--         * "refusals.refusal_dt" cannot preceed "invoices.invoice_date"
--              (both "refusals" and "invoices" tables synchronization
--
--      1.c. Other simple business rules
--          * invoices paid with the same receipt cannot refer to two or more customers
--              (each payment/receipt is made by a single customer for its invoice(s)
--          * a product cannot channge VAT percent more than once in the same day
--
--====================================================================================


--====================================================================================
--      1.a Date/timestamp attribute synchronization for attributes in the same table
--====================================================================================
--         "former_contacts.from_" must precede "former_contacts.to_"
-- (this errors is not supposed to happen, as we manager "former_contacts" records
--  through the "current_contact" triggers)
--====================================================================================

-- unfortunately, next ALTER TABLE does not work in Oracle...
ALTER TABLE former_contacts ADD CONSTRAINT ck_contacts_dt_order
	CHECK (from_ <= COALESCE(to_, CURRENT_TIMESTAMP))  ;

-- so we need another trigger (this case) or we have to change existing triggers (see below)
------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_former_contacts_dts
	AFTER INSERT OR UPDATE OF from_, to_ ON former_contacts FOR EACH ROW
BEGIN
    IF :NEW.from_ > COALESCE(:NEW.to_, CURRENT_TIMESTAMP) THEN
        RAISE_APPLICATION_ERROR (-20040, '`from_` cannot succede to `to_`');
    END IF ;

END ;
/


--====================================================================================
--   "former_vat_percents.date_start" must precede "former_vat_percents.date_until"
-- (this error is not supposed to happen, as we manage "former_vat_percents" records
--  through the table "products" triggers)
--====================================================================================
------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_former_vat_dts
	AFTER INSERT OR UPDATE OF date_start, date_until ON former_vat_percents FOR EACH ROW
BEGIN
    IF :NEW.date_start > COALESCE(:NEW.date_until, CURRENT_TIMESTAMP) THEN
        RAISE_APPLICATION_ERROR (-20041, '`date_start` cannot succede to `date_until`');
    END IF ;
END ;
/


--====================================================================================
--          "receipts.receipt_docum_date" must precede "receipts.receipt_date"
--====================================================================================
------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_receipts_dates
	AFTER INSERT OR UPDATE OF receipt_date, receipt_docum_date ON receipts FOR EACH ROW
BEGIN
    IF COALESCE(:NEW.receipt_docum_date, CURRENT_TIMESTAMP)
            > COALESCE(:NEW.receipt_date, CURRENT_TIMESTAMP) THEN
        RAISE_APPLICATION_ERROR (-20042, '`receipt_docum_date` cannot succede to `receipt_date`');
    END IF ;
END ;
/

--------------------
-- test the trigger

-- extract the last receipt
SELECT * FROM receipts WHERE receipt_id = (SELECT MAX(receipt_id) FROM receipts) ;

-- try to change the document date so that it succeeds the receipt date (in my case, receipt_id = 24)
UPDATE receipts SET receipt_docum_date = DATE'2015-01-01' WHERE receipt_id = 24 ;
-- it works (error is triggered) !




--====================================================================================
--   1.b. Date/timestamp attribute synchronization for attributes in different tables
--
-- In next trigger we'll use the following functions already created in packages:
--      * pac_sales_3.f_invoice_date
--      * pac_sales_4.f_receipt_date
--====================================================================================
--      "cancelled_invoices.cancellation_dt" cannot preceed "invoices.invoice_date"
--          (both "cancelled_invoices" and "invoices" tables synchronization
-- so we'll create/update two triggers, one for "cancelled_invoices" and another
--   for "invoices"

--====================================================================================

-- The needed trigger for "cancelled_invoices"
CREATE OR REPLACE TRIGGER trg_cancel_inv_date
	AFTER INSERT OR UPDATE OF cancellation_dt ON cancelled_invoices FOR EACH ROW
--declare
--		v_date invoices.invoice_date%TYPE ;
BEGIN
/*
 		SELECT invoice_date INTO v_date FROM invoices WHERE invoice_id = :NEW.invoice_id ;
		IF 	:NEW.cancellation_dt > v_date THEN
        RAISE_APPLICATION_ERROR (-20045, 'Cancellation date cannot precede the invoice date');
    END IF ;
*/
    IF :NEW.cancellation_dt < pac_sales_3.f_invoice_date(:NEW.invoice_id) THEN
        RAISE_APPLICATION_ERROR (-20045, 'Cancellation date cannot precede the invoice date');
    END IF ;
END ;
/

-- The needed trigger for "invoices" (instead of changing UPDATE triggers, we prefer to create
--   a new one (not always the recommended solution)
CREATE OR REPLACE TRIGGER trg_invoices_upd3
	AFTER UPDATE OF invoice_date ON invoices FOR EACH ROW
BEGIN
    -- check if the invoice is cancelled - a function would be recommended
    --   but instead we'll use a cursor
    FOR rec_cancel IN (SELECT * FROM cancelled_invoices
            WHERE invoice_id = :NEW.invoice_id) LOOP
        IF rec_cancel.cancellation_dt < :NEW.invoice_date THEN
            RAISE_APPLICATION_ERROR (-20046, 'Cancellation date cannot precede the invoice date');
        END IF ;
    END LOOP ;
END ;
/

-- Alternate solution: a function returning cancellation timestamp of an invoice
--  or NULL if the invoice has not been cancelled
CREATE OR REPLACE FUNCTION f_cancel_date (invoice_id_ invoices.invoice_id%type)
	RETURN timestamp
AS
	v_ts TIMESTAMP ;
BEGIN
	SELECT cancellation_dt INTO v_ts
	FROM cancelled_invoices WHERE invoice_id = invoice_id_ ;
	RETURN v_ts ;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN NULL ;
END ;
/
-- the second version of the trigger
CREATE OR REPLACE TRIGGER trg_invoices_upd3
	AFTER UPDATE OF invoice_date ON invoices FOR EACH ROW
BEGIN
     IF COALESCE(f_cancel_date(:NEW.invoice_id), :NEW.invoice_date)  < :NEW.invoice_date THEN
            RAISE_APPLICATION_ERROR (-20046, 'Cancellation date cannot precede the invoice date');
        END IF ;
END ;
/




----------------------------
-- test one of the triggers

-- no records in "cancelled invoices"
SELECT * FROM cancelled_invoices ;

-- extract the last invoice
SELECT * FROM invoices WHERE invoice_id = (SELECT MAX(invoice_id) FROM invoices) ;
-- in my db, the last invoice has id 61 and date '01-11-2014 '

-- try to insert the invoice cancellation prior to invoice date
INSERT INTO cancelled_invoices
    VALUES (TIMESTAMP'2014-01-01 00:00:00', 'no comments', 61) ;
-- it works (error is triggered) !


--          the other trigger is to be tested during lectures at at home



--====================================================================================
--         * "receipt_details.receipt_date" cannot preceed "invoices.invoice_date"
--              for current paid invoice
--====================================================================================
-- "receipt_details" trigger
CREATE OR REPLACE TRIGGER trg_receipt_dets_date
	AFTER INSERT OR UPDATE OF receipt_date ON receipt_details FOR EACH ROW
BEGIN
    IF :NEW.receipt_date < pac_sales_3.f_invoice_date(:NEW.invoice_id) THEN
        RAISE_APPLICATION_ERROR (-20050, 'Payment date cannot precede the invoice date');
    END IF ;
END ;
/

-- change the above version of "trg_invoices_upd3"
CREATE OR REPLACE TRIGGER trg_invoices_upd3
	AFTER UPDATE OF invoice_date ON invoices FOR EACH ROW
BEGIN
    -- this is taken from previous version
    -- check if the invoice is cancelled - a package function would be recommended
    --   but instead we'll use a cursor
    FOR rec_cancel IN (SELECT * FROM cancelled_invoices
            WHERE invoice_id = :NEW.invoice_id) LOOP
        IF rec_cancel.cancellation_dt < :NEW.invoice_date THEN
            RAISE_APPLICATION_ERROR (-20050, 'Payment date cannot precede the invoice date');
        END IF ;
    END LOOP ;

    -- this is new
    -- check if the invoice is paid - a package function would be recommended
    --   but instead we'll use a cursor
    FOR rec_pay IN (SELECT * FROM receipt_details
            WHERE invoice_id = :NEW.invoice_id) LOOP
        IF rec_pay.receipt_date < :NEW.invoice_date THEN
            RAISE_APPLICATION_ERROR (-20051, 'Payment date cannot precede the invoice date');
        END IF ;
    END LOOP ;

END ;
/


--          triggers are to be tested during lectures at at home



--====================================================================================
--         * "refusals.refusal_dt" cannot preceed "invoices.invoice_date"
--              (both "refusals" and "invoices" tables synchronization
--====================================================================================
--
--          to be done during lectures or at home




--====================================================================================
--      1.c. Other simple business rules
--====================================================================================


--====================================================================================
--    invoices paid with the same receipt cannot be belong to two or more customers
--          (each payment/receipt is made by a single customer for its invoice(s)
--====================================================================================

------------------------------------------------------------------------------------------
--                          Mutating tables - part 2
------------------------------------------------------------------------------------------
-- Initial solution's idea (this will generate the mutation problem)
--      In table "receipt_details" when:
--              * a record is inserted or
--              * attributes "receipt_id" or "invoice_id" are changed
--          then check if all the other invoices paid with current receipt
--          are referring to the same customer
--  Mutation is generated by the fact that the UPDATE trigger (see below) we'll
--      query the same table it was created for

CREATE OR REPLACE TRIGGER trg_receipt_dets_custs
	AFTER INSERT OR UPDATE OF receipt_id, invoice_id ON receipt_details FOR EACH ROW
DECLARE
    v_cust_id invoices.cust_id%TYPE ;
BEGIN
    -- load in a cursor all the invoices paid with current receipt
    FOR rec_invoices IN (SELECT * FROM receipt_details
            WHERE receipt_id = :NEW.receipt_id) LOOP
        IF v_cust_id IS NULL THEN
            -- store the customer of the first invoice for current receipt
            v_cust_id := pac_sales_4.f_cust_id(rec_invoices.invoice_id) ;
        ELSE
            IF v_cust_id <>  pac_sales_4.f_cust_id(rec_invoices.invoice_id) THEN
                RAISE_APPLICATION_ERROR (-20055,
                    'Receipt ' || rec_invoices.invoice_id ||
                    ' is trying to pay invoices of different customers') ;
            END IF ;
        END IF ;
    END LOOP ;
END ;
/

------------------------------------------------------------------------------------------
--                  test the trigger (add some new data)

-- all the invoices are fully paid...
/*
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
*/

-- ... so, wel'll add some data
SELECT * FROM invoices WHERE invoice_id = (SELECT MAX(invoice_id) FROM invoices) ;
-- in my db, now the last invoice has id 62, number 13219 and date '01-12-2014 '

-- two new invoices
INSERT INTO invoices (invoice_number, invoice_date, cust_id)
    VALUES (13220, DATE'2014-12-02', pac_sales.f_cust_id('Client A SRL'));
INSERT INTO invoices (invoice_number, invoice_date, cust_id)
    VALUES (13221, DATE'2014-12-02', pac_sales.f_cust_id('Client C SRL'));
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price)
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 13220), 1, 1, 57, 1000) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price)
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 13220), 2, 2, 79, 1050) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price)
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 13220), 3, 5, 510, 7060) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price)
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 13221), 1, 2, 85, 1030) ;
INSERT INTO invoice_details (invoice_id, row_number, product_id, quantity, unit_price)
    VALUES ((SELECT invoice_id FROM invoices WHERE invoice_number = 13221), 2, 3, 65, 750) ;
COMMIT ;

-- check the insert
SELECT * FROM invoices WHERE invoice_id > 62 ;
SELECT * FROM invoice_details WHERE invoice_id > 62 ;


-- now insert a receipt
SELECT MAX(receipt_id) FROM receipts ;
-- 24 is the last receipt_id

INSERT INTO receipts (receipt_date, receipt_docum_type, receipt_docum_number,receipt_docum_date)
    VALUES (DATE'2014-12-05', 'OP', '20141205', DATE'2014-12-05') ;
COMMIT ;
SELECT * FROM receipts WHERE receipt_id  > 24 ;



-- first invoice paid with this receipt (25) is 63
INSERT INTO receipt_details (receipt_id, invoice_id, amount)
    VALUES ((SELECT receipt_id FROM receipts WHERE receipt_docum_number='20141205' ),
        (SELECT invoice_id FROM invoices WHERE invoice_number = 13220), 1000000) ;

-- Here comes ther mutation error:
/*
Error starting at line : 1 in command -
INSERT INTO receipt_details (receipt_id, invoice_id, amount)
    VALUES ((SELECT receipt_id FROM receipts WHERE receipt_docum_number='20141205' ),
        (SELECT invoice_id FROM invoices WHERE invoice_number = 13220), 1000000)
Error report -
SQL Error: ORA-04091: tabela SDBIS.RECEIPT_DETAILS este schimbatoare, triggerul/functia nu o poate vedea
ORA-06512: la "SDBIS.TRG_RECEIPT_DETS_CUSTS", linia 5
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_RECEIPT_DETS_CUSTS'
04091. 00000 -  "table %s.%s is mutating, trigger/function may not see it"
*Cause:    A trigger (or a user defined plsql function that is referenced in
           this statement) attempted to look at (or modify) a table that was
           in the middle of being modified by the statement which fired it.
*Action:   Rewrite the trigger (or function) so it does not read that table.
*/

COMMIT ;




--====================================================================================
--                          New solution's idea:
--   We'll catch (in a AFTER INSERT OR UPDATE trigger) the "receipt_id"s for all
--     inserted or update records in "receipt_details" and store them ( "receipt_id"s)
--     in a public collection. In the AFTER STATEMENT trigger we'll check if all
--      invoices paid by a receipt (element of the collection) refer to a single
--      customer
--
--====================================================================================

-- don't forget to drop the  trigger
DROP TRIGGER trg_receipt_dets_custs ;

--====================================================================================
--  first, create the package
--====================================================================================
CREATE OR REPLACE PACKAGE pac_coll_receipts
AS
    -- declare the collection type (associative array)
    TYPE t_aa_receipt_id_s IS TABLE OF receipts.receipt_id%TYPE INDEX BY
        PLS_INTEGER ;
    -- declare the collection variable
    v_aa_receipt_id_s  t_aa_receipt_id_s ;

    -- function for searching an receipt_id in the collection
    FUNCTION f_search_v_aa_receipt_id_s (receipt_id_ receipts.receipt_id%TYPE)
        RETURN BOOLEAN ;

END ;
/

---------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_coll_receipts
AS
-- function for searching an invoice_id in the collection
FUNCTION f_search_v_aa_receipt_id_s (receipt_id_ receipts.receipt_id%TYPE)
        RETURN BOOLEAN
IS
BEGIN
    -- test if collection is empty
    IF v_aa_receipt_id_s.COUNT = 0 THEN
        RETURN FALSE ;
    ELSE
        FOR i IN 1..v_aa_receipt_id_s.COUNT LOOP
            IF v_aa_receipt_id_s(i) = receipt_id_ THEN
                RETURN TRUE ;
            END IF ;
        END LOOP ;
        RETURN FALSE ;
    END IF ;
END f_search_v_aa_receipt_id_s;

END ;
/

--====================================================================================
--      Next wel'll create a group of three triggers for "receipt_details"
--  Each trigger will be associated to one of three actions:
--      - insert a row
--      - change value of "receipt_id"
--      - change value of "invoice_id"
--  Triggers purpose are:
--      - BEFORE STATEMENT: clear (empty) collection
--      - BEFORE ROW (following current created triggers): catch the "id"s of receipt
--          in affected rows
--      - AFTER STATEMENT - doing the check (of single customer for each receipt)
--====================================================================================

---------------------------------------------------------------------------------------
-- BEFORE - STATEMENT trigger will clear the public collection
CREATE OR REPLACE TRIGGER trg_receipt_dets_custs_1
    BEFORE INSERT OR UPDATE OF receipt_id, invoice_id ON receipt_details
BEGIN
    --DBMS_OUTPUT.PUT_LINE('trg_receipt_dets_custs_1') ;
    -- clear the colllection
    pac_coll_receipts.v_aa_receipt_id_s.DELETE ;
END ;
/

---------------------------------------------------------------------------------------
-- BEFORE ROW (following current created triggers): catch the "id"s of receipt
--          in affected rows
CREATE OR REPLACE TRIGGER trg_receipt_dets_custs_2
    BEFORE INSERT OR UPDATE OF receipt_id, invoice_id ON receipt_details FOR EACH ROW
BEGIN
    --DBMS_OUTPUT.PUT_LINE('trg_receipt_dets_custs_2 - ' || :NEW.receipt_id) ;
    -- catch the "id" of current receipt
    IF pac_coll_receipts.f_search_v_aa_receipt_id_s(:NEW.receipt_id) = FALSE THEN
        --DBMS_OUTPUT.PUT_LINE('trg_receipt_dets_custs_2 - add in collection: ' || :NEW.receipt_id) ;

        pac_coll_receipts.v_aa_receipt_id_s(pac_coll_receipts.v_aa_receipt_id_s.COUNT+1)
            := :NEW.receipt_id ;
    END IF ;
END ;
/

---------------------------------------------------------------------------------------
--      - AFTER STATEMENT - doing the check (of single customer for each receipt)
CREATE OR REPLACE TRIGGER trg_receipt_dets_custs_4
    AFTER INSERT OR UPDATE OF receipt_id, invoice_id ON receipt_details
DECLARE
    v_cust_id invoices.cust_id%TYPE ;
    CURSOR c_invoices (receipt_id_ receipt_details.receipt_id%TYPE) IS
        SELECT * FROM receipt_details
         WHERE receipt_id = receipt_id_  ;
BEGIN
    --DBMS_OUTPUT.PUT_LINE('trg_receipt_dets_custs_4 - ') ;

    -- scan the collection and do the customer check
    FOR i IN 1..pac_coll_receipts.v_aa_receipt_id_s.COUNT LOOP
        -- load all the invoices paid by current receipt
        v_cust_id := NULL ;
        FOR rec_invoices IN c_invoices (pac_coll_receipts.v_aa_receipt_id_s (i)) LOOP
            IF v_cust_id IS NULL THEN
                -- store the customer of the first invoice for current receipt
                v_cust_id := pac_sales_4.f_cust_id(rec_invoices.invoice_id) ;
            ELSE
                IF v_cust_id <>  pac_sales_4.f_cust_id(rec_invoices.invoice_id) THEN
                    RAISE_APPLICATION_ERROR (-20055,
                     'Receipt ' || rec_invoices.invoice_id ||
                     ' is trying to pay invoices of different customers') ;
                END IF ;
           END IF ;
        END LOOP ;
    END LOOP ;
END ;
/

------------------------------------------------------------------------------------------
--                  test the triggers
-- don't forget to drop the  trigger
DROP TRIGGER trg_receipt_dets_custs ;

DELETE FROM receipt_details WHERE receipt_id  > 24 ;

-- first invoice paid with this receipt (25) is 63
INSERT INTO receipt_details (receipt_id, invoice_id, amount)
    VALUES ((SELECT receipt_id FROM receipts WHERE receipt_docum_number='20141205' ),
        (SELECT invoice_id FROM invoices WHERE invoice_number = 13220), 1000000) ;
COMMIT ;

SELECT * FROM receipts WHERE receipt_id  > 24 ;
SELECT * FROM receipt_details WHERE receipt_id  > 24 ;

-------------------------------------------------------
--                      utilies
-- anonymous bloc for displaying the collection
BEGIN
    FOR i IN 1..pac_coll_receipts.v_aa_receipt_id_s.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('i='||i || ',invoice_id=' || pac_coll_receipts.v_aa_receipt_id_s(i) );
    END LOOP ;
END ;
/

-- second invoice paid with this receipt (25) is 64 which must be an error (this
--    invoice is targeted to other customer
INSERT INTO receipt_details (receipt_id, invoice_id, amount)
    VALUES ((SELECT receipt_id FROM receipts WHERE receipt_docum_number='20141205' ),
        (SELECT invoice_id FROM invoices WHERE invoice_number = 13221), 10000) ;

-- It works !
/*
Error starting at line : 1 in command -
INSERT INTO receipt_details (receipt_id, invoice_id, amount)
    VALUES ((SELECT receipt_id FROM receipts WHERE receipt_docum_number='20141205' ),
        (SELECT invoice_id FROM invoices WHERE invoice_number = 13221), 10000)
Error report -
SQL Error: ORA-20055: Receipt 64 is trying to pay invoices of different customers
ORA-06512: la "SDBIS.TRG_RECEIPT_DETS_CUSTS_4", linia 19
ORA-04088: eroare în timpul executiei triggerului 'SDBIS.TRG_RECEIPT_DETS_CUSTS_4'
*/




--====================================================================================
--   For a product the VAT percent cannot be changed  more than once in the same day
--   (this is necessary since invoice date does not deal with timestamps but with
--     dates; if we allow multiple VAT percents for the same day, we won't be
--     able to know in which invoices different VAT percentent were applied)
--====================================================================================

-- we'll change previously created "trg_products_upd"

CREATE OR REPLACE TRIGGER trg_products_upd
	AFTER UPDATE OF current_vat_percent ON products FOR EACH ROW
BEGIN

    -- When a "current_vat_percent" is changed (in "products")...

    -- ...first we check if there is also a VAT change for this product the current date
    FOR rec_changes IN (SELECT * FROM former_vat_percents
            WHERE product_id = :NEW.product_id AND date_start = current_date) LOOP
        RAISE_APPLICATION_ERROR (-20060,
            'For product ' || :NEW.product_id ||
            ' there is already a VAT change for today');
    END LOOP ;


    -- ... and then continue "as usual" (next lines are taken from previous version)

    --    1. ... in "former_vat_percents" the record corresponding to the old percent
    --            is updated ("date_until" takes the value of current_date - 1)
    UPDATE former_vat_percents
    SET date_until = current_date - 1
    WHERE product_id = :OLD.product_id AND date_until IS NULL ;

    --    2. ...then in "former_vat_percents" a new record is added,
    --         corresponding to the new percent
    INSERT INTO former_vat_percents (product_id, date_start, date_until, VAT_percent)
        VALUES (:NEW.product_id, current_date, NULL, :NEW.current_vat_percent) ;
END ;
/

-- test

-- first change for today (must work)
UPDATE products SET current_vat_percent = .12 WHERE product_id = 6 ;

-- second change for today (must NOT work)
UPDATE products SET current_vat_percent = .24 WHERE product_id = 6 ;
-- SUPRISE!
-- operation is blocked first the trigger TRG_FORMER_VAT_DTS
--   which is correct. Why?
