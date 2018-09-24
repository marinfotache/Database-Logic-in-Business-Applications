-- create tables of Sales sub-schema in Oracle

DROP TABLE receipt_details  ;
DROP TABLE receipts  ;
DROP TABLE invoice_details ;
DROP TABLE invoices  ;
DROP TABLE products  ;
DROP TABLE contacts  ;
DROP TABLE people  ;
DROP TABLE customers  ;
DROP TABLE postcodes  ;
DROP TABLE post_codes  ;
DROP TABLE counties  ;

CREATE TABLE counties (
    county_code CHAR(2)
        CONSTRAINT pk_counties PRIMARY KEY
        CONSTRAINT ck_county_code CHECK (county_code=LTRIM(UPPER(county_code))),
    county_name VARCHAR2(25)
        CONSTRAINT un_county_name UNIQUE
        CONSTRAINT nn_county_name NOT NULL
        CONSTRAINT ck_county_name CHECK (county_name=LTRIM(INITCAP(county_name))),
    region VARCHAR2(15)
        DEFAULT 'Moldova' CONSTRAINT nn_region NOT NULL
        CONSTRAINT ck_region CHECK (region IN ('Banat', 
	'Transilvania', 'Dobrogea','Oltenia', 'Muntenia', 'Moldova'))
    ) ;

CREATE TABLE post_codes (
    post_code CHAR(6)
        CONSTRAINT pk_coduri_post PRIMARY KEY
        CONSTRAINT ck_post_code CHECK (post_code=LTRIM(post_code)),
    place VARCHAR2(25)
        CONSTRAINT nn_place NOT NULL
        CONSTRAINT ck_place CHECK (place=LTRIM(INITCAP(place))),
    county_code CHAR(2)
        DEFAULT 'IS' NOT NULL
        CONSTRAINT fk_post_codes_counties REFERENCES counties(county_code)
    ) ;


CREATE TABLE customers (
    customer_id NUMBER(6)
        CONSTRAINT pk_customers PRIMARY KEY
        CONSTRAINT ck_customer_id CHECK (customer_id > 1000),
    customer_name VARCHAR2(30)
        CONSTRAINT ck_customer_name CHECK (SUBSTR(customer_name,1,1) = UPPER(SUBSTR(customer_name,1,1))),
    fiscal_code CHAR(9)
        CONSTRAINT ck_fiscal_code CHECK (SUBSTR(fiscal_code,1,1) = UPPER(SUBSTR(fiscal_code,1,1))),
    address VARCHAR2(40)
        CONSTRAINT ck_address_customers CHECK (SUBSTR(address,1,1) = UPPER(SUBSTR(address,1,1))),
    post_code CHAR(6) NOT NULL
        CONSTRAINT fk_customers_post_codes REFERENCES post_codes(post_code),
    phone VARCHAR2(10)
    ) ;


CREATE TABLE people (
    personal_code CHAR(14)
        CONSTRAINT pk_people PRIMARY KEY,
 --       CONSTRAINT ck_personal_code CHECK (personal_code=LTRIM(UPPER(personal_code))),
    last_name VARCHAR2(20)
        CONSTRAINT ck_last_name CHECK (last_name=LTRIM(INITCAP(last_name))),
    first_name VARCHAR2(20)
        CONSTRAINT ck_first_name CHECK (first_name=LTRIM(INITCAP(first_name))),
    address VARCHAR2(40)
        CONSTRAINT ck_address_people 
            CHECK (SUBSTR(address,1,1) = UPPER(SUBSTR(address,1,1))),
    genre CHAR(1) DEFAULT 'B'
        CONSTRAINT ck_genre CHECK (genre IN ('F','B')),
    post_code CHAR(6) NOT NULL
        CONSTRAINT fk_people_post_codes REFERENCES post_codes(post_code),
    home_phone VARCHAR2(10),
    office_phone VARCHAR2(10),
    mobile_phone VARCHAR2(10),
    email VARCHAR2(50)
    ) ;


CREATE TABLE contacts (
    personal_code CHAR(14)
        CONSTRAINT fk_contacts_people REFERENCES people(personal_code),
    customer_id NUMBER(6) NOT NULL
        CONSTRAINT fk_contacts_customers REFERENCES customers(customer_id),
    position VARCHAR2(25)
        CONSTRAINT ck_position CHECK (SUBSTR(position,1,1) = 
              UPPER(SUBSTR(position,1,1))),
    CONSTRAINT pk_contacts PRIMARY KEY (personal_code, customer_id, position)
    ) ;


CREATE TABLE products (
    product_id NUMBER(6)
        CONSTRAINT pk_products PRIMARY KEY
        CONSTRAINT ck_product_id CHECK (product_id > 0),
    product_name VARCHAR2(30) CONSTRAINT ck_product_name
        CHECK (SUBSTR(product_name,1,1) = UPPER(SUBSTR(product_name,1,1))),
    unit_of_measurement VARCHAR2(10),
    category VARCHAR2(15) CONSTRAINT ck_products_category
        CHECK (SUBSTR(category,1,1) = UPPER(SUBSTR(category,1,1))),
    VAT_percent NUMBER(2,2) DEFAULT .25
    )  ;


CREATE TABLE invoices (
    invoice_no NUMBER(8)
        CONSTRAINT pk_invoices PRIMARY KEY,
    invoice_date DATE DEFAULT CURRENT_DATE,
        CONSTRAINT ck_invoice_date CHECK 
          (invoice_date >= TO_DATE('01/01/2011','DD/MM/YYYY')
            AND invoice_date <= TO_DATE('31/12/2019','DD/MM/YYYY')),
    customer_id NUMBER(6) NOT NULL
        CONSTRAINT fk_invoices_customers REFERENCES customers(customer_id) ,
    comments VARCHAR2(50) 
	)  ;
--    invoiceVAT NUMBER(12,2),	
--    invoiceAmount NUMBER(12,2),
--    invoiceReceipt NUMBER(12,2),
--    ) 


CREATE TABLE invoice_details (
    invoice_no NUMBER(8) NOT NULL
        CONSTRAINT fk_invoice_details_invoices REFERENCES invoices(invoice_no),
    invoice_row_number NUMBER(2) NOT NULL
        CONSTRAINT ck_invoice_row_number CHECK (invoice_row_number > 0),
    product_id NUMBER(6) NOT NULL 
		CONSTRAINT fk_invoice_details_products REFERENCES products(product_id),
    quantity NUMBER(8),
    unit_price NUMBER (9,2),
--  invoiceRowVAT NUMBER(10,2),
    CONSTRAINT pk_invoice_details PRIMARY KEY (invoice_no,invoice_row_number)
    ) ;
    
    
CREATE TABLE receipts (
    receipt_id NUMBER(8)
        CONSTRAINT pk_receipts PRIMARY KEY,
    receipt_date DATE DEFAULT SYSDATE
        CONSTRAINT ck_receipt_date CHECK (receipt_date >= TO_DATE('01/07/2011','DD/MM/YYYY')
            AND receipt_date <= TO_DATE('31/12/2019','DD/MM/YYYY')),
--  receiptType CHAR(1) CONSTRAINT ck_tipinc CHECK (tipinc IN ('P', 'C', 'A')),
    docum_code CHAR(4)
        CONSTRAINT ck_docum_code CHECK(docum_code=UPPER(LTRIM(docum_code))),
    docum_no VARCHAR2(16),
    docum_date DATE DEFAULT SYSDATE - 7
        CONSTRAINT ck_docum_date CHECK (docum_date >= TO_DATE('01/01/2011','DD/MM/YYYY')
            AND docum_date <= TO_DATE('31/12/2019','DD/MM/YYYY'))
    ) ;


CREATE TABLE receipt_details (
    receipt_id NUMBER(8) NOT NULL 
	CONSTRAINT fk_receipt_details_receipts REFERENCES receipts(receipt_id) ,
    invoice_no NUMBER(8) NOT NULL 
	CONSTRAINT fk_receipt_details_invoices REFERENCES invoices(invoice_no),
    amount NUMBER(16,2) NOT NULL,
    CONSTRAINT pk_receipt_details PRIMARY KEY (receipt_id, invoice_no)
     ) ;

