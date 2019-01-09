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

See also the presentation:
https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-01_en_Business%20Rules%20with%20PL%20SQL%20(1).pptx

*/

--====================================================================================
-- 	        Business Rules Implemented with Oracle PL/SQL triggers - part III: 
--                          invoice row (re)numbering
--====================================================================================
--      When deleting one or more rows in an invoice, remaining rows of the invoice
--   must be re-numbered
--   we'll use a public collection for cathing the "invoice_id"s where row renumbering
--    might be necessary
--====================================================================================

--====================================================================================
--  first, create the package
--====================================================================================
CREATE OR REPLACE PACKAGE pac_collections
AS
    -- declare the collection type (associative array) for "receipt_id"s
    TYPE t_aa_receipt_id_s IS TABLE OF receipts.receipt_id%TYPE INDEX BY
        PLS_INTEGER ;
    -- declare the collection variable 
    v_aa_receipt_id_s  t_aa_receipt_id_s ;

    -- function for searching an receipt_id in the collection
    FUNCTION f_search_v_aa_receipt_id_s (receipt_id_ receipts.receipt_id%TYPE) 
        RETURN BOOLEAN ; 


    -- declare the collection type (associative array) for "invoice_id"s
    TYPE t_aa_invoice_id_s IS TABLE OF invoices.invoice_id%TYPE INDEX BY
        PLS_INTEGER ;
    -- declare the collection variable 
    v_aa_t_invoice_id_s  t_aa_invoice_id_s ;
    

   -- function for searching an invoice_id in the collection
    FUNCTION f_search_v_aa_t_invoice_id_s (invoice_id_ invoices.invoice_id%TYPE) 
        RETURN BOOLEAN ; 
        
    -- public variable for bypassing the nested execution of triggers
    v_bypass BOOLEAN := FALSE ;
          
END ;
/

---------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_collections
AS
----------------------------------------------------------
-- function for searching an receipt_id in the collection
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

----------------------------------------------------------
-- function for searching an invoice_id in the collection
FUNCTION f_search_v_aa_t_invoice_id_s (invoice_id_ invoices.invoice_id%TYPE) 
        RETURN BOOLEAN 
IS
BEGIN
    -- test if collection is empty
    IF v_aa_t_invoice_id_s.COUNT = 0 THEN
        RETURN FALSE ;
    ELSE
        FOR i IN 1..v_aa_t_invoice_id_s.COUNT LOOP
            IF v_aa_t_invoice_id_s(i) = invoice_id_ THEN
                RETURN TRUE ;
            END IF ;
        END LOOP ;
        RETURN FALSE ;
    END IF ;    
END f_search_v_aa_t_invoice_id_s;

END ;
/

--====================================================================================
--      Next wel'll create a group of three triggers for "invoice_details"
--  Each trigger will be associated to one of three actions:
--      - delete a row 
--      - change value of "row_number"
--      - change value of "invoice_id"
--  Triggers purpose are:
--      - BEFORE STATEMENT: clear (empty) collection
--      - BEFORE ROW (following current created triggers): catch the "id"s of invoices
--          to have rows re-numbered
--      - AFTER STATEMENT - doing the re-numbering 
--====================================================================================

---------------------------------------------------------------------------------------
-- clear the public collection
CREATE OR REPLACE TRIGGER trg_inv_details_row_nums_1
    BEFORE UPDATE OF invoice_id, row_number OR DELETE ON invoice_details 
BEGIN
    IF pac_collections.v_bypass = FALSE THEN
        -- clear the colllection
        pac_collections.v_aa_t_invoice_id_s.DELETE ;
    END IF ;    
END ;
/

---------------------------------------------------------------------------------------
-- update trigger "trg_inv_details_upd1" which forbids "row_number" change
CREATE OR REPLACE TRIGGER trg_inv_details_upd1
	BEFORE UPDATE ON invoice_details FOR EACH ROW
DECLARE	
    v_row_number invoice_details.row_number%TYPE ;
BEGIN 
    /*
    -- "invoice_details.row_number" must be changed only accompanied by 
    --       a change of "invoice_details.invoice_id")
    IF :NEW.row_number <> :OLD.row_number AND :NEW.invoice_id = :OLD.invoice_id THEN
        -- user defined errors must be in the range between -20000 and -20999.
        RAISE_APPLICATION_ERROR (-20010, 
    		'Value of attribute "row_number" cannot be changed within an invoice!');
    END IF ;
    */
    -- compute "row_VAT"
    :NEW.row_VAT := :NEW.quantity * :NEW.unit_price * 
        pac_sales_3.f_vat_prod (:NEW.product_id, pac_sales_3.f_invoice_date(:NEW.invoice_id)) ;
END ;
/

---------------------------------------------------------------------------------------
-- catch the "id"s of updated invoices with rows to be re-numbered
CREATE OR REPLACE TRIGGER trg_inv_details_row_nums_2a
    BEFORE UPDATE OF invoice_id, row_number ON invoice_details 
        FOR EACH ROW 
BEGIN
    IF pac_collections.v_bypass = FALSE THEN
        -- catch the "id"s of invoices to have rows re-numbered
        IF pac_collections.f_search_v_aa_t_invoice_id_s(:OLD.invoice_id) = FALSE THEN
            pac_collections.v_aa_t_invoice_id_s(pac_collections.v_aa_t_invoice_id_s.COUNT+1)
                := :OLD.invoice_id ;
        END IF ; 
        -- in order to avoid primary key violations, increase, line number with 500
        --  (affected rows will be moved towards the end of the invoice)
        :NEW.row_number := :NEW.row_number + 500;   
        IF pac_collections.f_search_v_aa_t_invoice_id_s(:NEW.invoice_id) = FALSE THEN
            pac_collections.v_aa_t_invoice_id_s(pac_collections.v_aa_t_invoice_id_s.COUNT+1)
                := :NEW.invoice_id ;
        END IF ;
    END IF ;        
END ;
/
---------------------------------------------------------------------------------------
-- catch the "id"s of invoices with rows deleted (their rows must be re-numbered)
CREATE OR REPLACE TRIGGER trg_inv_details_row_nums_2b
    BEFORE DELETE ON invoice_details 
        FOR EACH ROW 
BEGIN
    IF pac_collections.v_bypass = FALSE THEN
        -- catch the "id"s of invoices to have rows re-numbered
        IF pac_collections.f_search_v_aa_t_invoice_id_s(:OLD.invoice_id) = FALSE THEN
            pac_collections.v_aa_t_invoice_id_s(pac_collections.v_aa_t_invoice_id_s.COUNT+1)
                := :OLD.invoice_id ;
        END IF ;
    END IF ;        
END ;
/

---------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_inv_details_row_nums_4
    AFTER UPDATE OF invoice_id, row_number OR DELETE ON invoice_details 
DECLARE
    j PLS_INTEGER ;    
    CURSOR c_rows (invoice_id_ invoices.invoice_id%TYPE) IS
        SELECT * FROM invoice_details WHERE invoice_id = invoice_id_ FOR UPDATE ;
    
BEGIN
    IF pac_collections.v_bypass = FALSE THEN
        pac_collections.v_bypass := TRUE ;
        -- scan the collection and do the re-numerotation
        FOR i IN 1..pac_collections.v_aa_t_invoice_id_s.COUNT LOOP
            -- renumber all rows for current invoice
            j := 1 ;
            FOR rec_rows IN c_rows (pac_collections.v_aa_t_invoice_id_s (i)) LOOP
            
                -- for avoiding primary key violation, we'll start numbering with 1001
                UPDATE invoice_details SET row_number = 1000 + j WHERE CURRENT OF c_rows ;
                j := j + 1 ;     
            END LOOP ;
            
            -- decrement the row_number
            UPDATE invoice_details SET row_number = row_number - 1000 
            WHERE invoice_id = pac_collections.v_aa_t_invoice_id_s (i) ;   
      
        END LOOP ;   

        pac_collections.v_bypass := FALSE ;
    END IF ;
END ;
/



--====================================================================================
--                      test the triggers



-- unlock invoice 61 (you might need to replace 61 with any other value)
UPDATE invoices SET is_closed = 'N' WHERE invoice_id = 61 ;
COMMIT ;

SELECT * FROM invoice_details WHERE invoice_id >= 60
ORDER BY invoice_id, row_number ;

-- move second row of invoice 60 into invoice 61
UPDATE invoice_details SET invoice_id = 61 WHERE invoice_id = 60 AND row_number = 2 ;


SELECT * FROM invoice_details WHERE invoice_id >= 60
ORDER BY invoice_id, row_number ;



--====================================================================================
--                      utilies

-- anonymous bloc to test the value of "pac_collections.v_bypass"
BEGIN
  IF pac_collections.v_bypass THEN
    DBMS_OUTPUT.PUT_LINE('true');
  ELSE
    DBMS_OUTPUT.PUT_LINE('false');  
  END IF ;
END ;
/

-- anonymous bloc for setting the value of "pac_collections.v_bypass" on FALSE
BEGIN
  pac_collections.v_bypass := false ;
END ;
/


-- anonymous bloc for displaying the collection
BEGIN
    FOR i IN 1..pac_collections.v_aa_t_invoice_id_s.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('i='||i || ',invoice_id=' || pac_collections.v_aa_t_invoice_id_s(i) );  
    END LOOP ;
END ;
/

