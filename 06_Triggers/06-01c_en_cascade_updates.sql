/*
This script works with `sales` database that was created by launching (in Oracle SQL
Developer) four previous scripts:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-2_fixed_DDL_script_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-3_add_constraints_sales_2015.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01a_en_sequences.sql

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-01b_en_data_cleaning__surrogate_keys.sql

*/


--================================================================================
--     Parent surrogate keys update propagation (in all their children tables)
----------------------------------------------------------------------------------
--   That's necessary because Oracle SQL does not allow CREATE TABLE... ON UPDATE CASCADE
--
-- All triggers below are of type: UPDATE - AFTER - ROW


------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_county_code 
    AFTER UPDATE OF county_code ON counties
    FOR EACH ROW
BEGIN
    UPDATE postal_codes SET county_code = :NEW.county_code 
        WHERE county_code=:OLD.county_code ;
END ;
/
------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_post_code 
    AFTER UPDATE OF post_code ON postal_codes
    FOR EACH ROW
BEGIN
    UPDATE customers SET post_code = :NEW.post_code 
        WHERE post_code=:OLD.post_code ;
    UPDATE people SET post_code = :NEW.post_code 
        WHERE post_code=:OLD.post_code ;
END ;
/
------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_cust_id 
    AFTER UPDATE OF cust_id ON customers
    FOR EACH ROW
BEGIN
    UPDATE invoices SET cust_id = :NEW.cust_id 
        WHERE cust_id = :OLD.cust_id ;
    UPDATE current_contacts SET cust_id = :NEW.cust_id 
        WHERE cust_id = :OLD.cust_id ;
    UPDATE customer_monthly_stats SET cust_id = :NEW.cust_id 
        WHERE cust_id = :OLD.cust_id ;
    UPDATE former_contacts SET cust_id = :NEW.cust_id 
        WHERE cust_id = :OLD.cust_id ;
END ;
/
------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_year_month 
    AFTER UPDATE OF year, month ON months
    FOR EACH ROW
BEGIN
    UPDATE customer_monthly_stats SET year = :NEW.year, 
        month = :NEW.month WHERE year = :OLD.year AND month = :OLD.month ;
    UPDATE product_monthly_stats SET year = :NEW.year, 
        month = :NEW.month WHERE year = :OLD.year AND month = :OLD.month ;

END ;
/
------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_pers_id
    AFTER UPDATE OF pers_id ON people
    FOR EACH ROW
BEGIN
    UPDATE current_contacts SET pers_id = :NEW.pers_id 
        WHERE pers_id = :OLD.pers_id ;
    UPDATE former_contacts SET pers_id = :NEW.pers_id 
        WHERE pers_id = :OLD.pers_id ;
END ;
/
------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_product_id
    AFTER UPDATE OF product_id ON products
    FOR EACH ROW
BEGIN
    UPDATE invoice_details SET product_id = :NEW.product_id 
        WHERE product_id = :OLD.product_id ;
    UPDATE former_vat_percents SET product_id = :NEW.product_id 
        WHERE product_id = :OLD.product_id ;
    UPDATE product_monthly_stats SET product_id = :NEW.product_id 
        WHERE product_id = :OLD.product_id ;
    UPDATE refused_products SET product_id = :NEW.product_id 
        WHERE product_id = :OLD.product_id ;
END ;
/
------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_invoice_id
    AFTER UPDATE OF invoice_id ON invoices
    FOR EACH ROW
BEGIN
    UPDATE invoice_details SET invoice_id = :NEW.invoice_id 
        WHERE invoice_id = :OLD.invoice_id ;
    UPDATE cancelled_invoices SET invoice_id = :NEW.invoice_id 
        WHERE invoice_id = :OLD.invoice_id ;
    UPDATE receipt_details SET invoice_id = :NEW.invoice_id 
        WHERE invoice_id = :OLD.invoice_id ;
    UPDATE refusals SET invoice_id = :NEW.invoice_id 
        WHERE invoice_id = :OLD.invoice_id ;
END ;
/
------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_receipt_id
    AFTER UPDATE OF receipt_id ON receipts
    FOR EACH ROW
BEGIN
    UPDATE receipt_details SET receipt_id = :NEW.receipt_id 
        WHERE receipt_id = :OLD.receipt_id ;
END ;
/
------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_refusal_id
    AFTER UPDATE OF refusal_id ON refusals
    FOR EACH ROW
BEGIN
    UPDATE refused_products SET refusal_id = :NEW.refusal_id 
        WHERE refusal_id = :OLD.refusal_id ;
END ;
/


-- To be tested during the lecture class
