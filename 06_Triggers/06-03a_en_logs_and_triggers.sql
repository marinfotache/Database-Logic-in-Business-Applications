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


See also the presentation:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-03_en_Triggers%20-%20part%203.pptx


*/



--=====================================================================================
--           Keeping track of (some important) database operations with triggers
--=====================================================================================


/*
=====================================================================================
    All the values of "current_vat_percent" attribute in table "products", 
        are logged using table "former_vat_percents"
    So:
    1. When a product is inserted (in "products"), a new record is added to table
        "former_vat_percents"
    2. When a "current_vat_percent" is changed (in "products"),
        2.1. in "former_vat_percents" the record corresponding to the old percent
                is updated ("date_until" takes the value of current_date - 1)
        2.2. in "former_vat_percents" a new record is added corresponding to the new percent
    3. When a product is deleted, the foreign key "invoice_details <- products" 
        will block the deletion if the products was already sold. 
        If this product does not appear in any invoice,
        we'll first delete it from  "former_vat_percents" in order to "unlock" the
        referential integrity "former_vat_percents -> products" that otherwise will block
        any delete attempt in "products"
    --  Notice: foreign key violation could also be avoided by declaring it as DEFERRABLE
           (see discussion during lecture)

*/

--------------------------------------------------------------------------------------
-- Since we already have populated tables "products", "invoice_details", ...
--  before creating the triggers we'll synchonize "former_vat_percents" with "products"
--  by inserting in "former_vat_percents" a record for each product; 
--    "former_vat_percents.date_start" will be the date of the first invoice minus 1 (day)
INSERT INTO former_vat_percents (product_id, date_start, date_until, VAT_percent)
    SELECT product_id, 
        (SELECT MIN(invoice_date) - 1 FROM invoices), 
        NULL, 
        current_vat_percent
    FROM products 
    WHERE product_id NOT IN (SELECT product_id FROM former_vat_percents) ; 

COMMIT ;

--------------------------------------------------------------------------------------
--          Trigger for INSERTs in table "products" - of type AFTER-ROW
-- (remember that we created in script 06a the INSERT-BEFORE-ROW trigger for this table
--------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_products_ins_vat
	AFTER INSERT ON products FOR EACH ROW
BEGIN 	
    -- When a product is inserted (in "products") a new record is added to table
    --    "former_vat_percents"...
    INSERT INTO former_vat_percents (product_id, date_start, date_until, VAT_percent)
        VALUES (:NEW.product_id, current_date, NULL, :NEW.current_vat_percent) ;
END ;
/

--------------------------------------
-- test 
SELECT * FROM products ;
SELECT * FROM former_vat_percents ;

--delete from former_vat_percents where product_id = 7 ;
--delete from products where product_id = 7 ;

INSERT INTO products VALUES (7, 'Produs 7','p100g', 'Cafea', .24)  ;

SELECT * FROM products ;
SELECT * FROM former_vat_percents ;
COMMIT ;



--------------------------------------------------------------------------------------
-- Trigger for UPDATING "current_vat_percent" in table "products" - of type AFTER-ROW
--   (remember that we created in script 06b the "UPDATE-CASCADE" trigger 
--      for "products.product_id")
--------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_products_upd
	AFTER UPDATE OF current_vat_percent ON products FOR EACH ROW
BEGIN 	
    -- When a "current_vat_percent" is changed (in "products")...
    
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


--------------------------------------
-- test 
SELECT * FROM products ;
SELECT * FROM former_vat_percents ;

UPDATE products SET current_vat_percent = 0.12 WHERE product_name = 'Produs 6' ;

SELECT * FROM products ;
SELECT * FROM former_vat_percents ;

COMMIT ;


--------------------------------------------------------------------------------------
--          Trigger for DELETE in table "products" - of type BEFORE-ROW
--------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_products_del
	BEFORE DELETE ON products FOR EACH ROW
BEGIN 
	

    -- the trigger of type BEFORE-ROW in order to avoid foreign key constraint violation
    --  Notice: foreign key violation could also be avoided by declaring it as DEFERRABLE
    --    (see discussion during lecture)

    -- for the deleted product we remove its records from "former_vat_percents"
    DELETE FROM former_vat_percents WHERE product_id = :OLD.product_id ;
    
END ;
/


--------------------------------------
-- test 
SELECT * FROM products ;
SELECT * FROM former_vat_percents ;

-- next delete will produce an error
DELETE products  WHERE product_name = 'Produs 1' ;

-- next delete will work
DELETE products  WHERE product_name = 'Produs 7' ;

SELECT * FROM products ;
SELECT * FROM former_vat_percents ;

COMMIT ;

 
--------------------------------------------------------------------------------------
--          Task to be done during lectures (or at home)
--------------------------------------------------------------------------------------

-- Synchronize using triggers the tables "current_contacts" and "former_contacts"

/*
TABLE current_contacts (
    cust_id INTEGER NOT NULL ,
    position NVARCHAR2 (50) NOT NULL ,
    start_date DATE NOT NULL ,
    pers_id    INTEGER NOT NULL ) ;
ALTER TABLE current_contacts ADD CONSTRAINT current_contacts_PK PRIMARY KEY (
cust_id, position, pers_id ) NOT DEFERRABLE ENABLE VALIDATE ;

TABLE former_contacts (
    from_ DATE NOT NULL ,
    to_   DATE NOT NULL ,
    position NVARCHAR2 (50) NOT NULL ,
    comments NVARCHAR2 (100) NULL ,
    pers_id INTEGER NOT NULL ,
    cust_id INTEGER NOT NULL );
ALTER TABLE former_contacts ADD CONSTRAINT former_contacts_PK PRIMARY KEY (
pers_id, cust_id, from_ ) NOT DEFERRABLE ENABLE VALIDATE ;
*/







