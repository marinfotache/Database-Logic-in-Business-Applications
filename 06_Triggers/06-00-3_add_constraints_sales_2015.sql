/*
 Prior to running this statements in Oracle SQL Developer (you are already
    connected to `sales` database, please download and run (also in SQL Developer)
 the following script:

https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/06_Triggers/06-00-2_fixed_DDL_script_sales_2015.sql

*/


-- 				Add some new constraints in the database sales (2015)

-- counties
ALTER TABLE counties ADD CONSTRAINT ck_county_code CHECK 
	( county_code=LTRIM(UPPER(county_code))) ;
ALTER TABLE counties ADD CONSTRAINT ck_county_name CHECK ( 
	SUBSTR(county_name,1,1) = UPPER(SUBSTR(county_name,1,1))) ;
ALTER TABLE counties ADD CONSTRAINT ck_region1 CHECK ( 
	SUBSTR(county_region,1,1) = UPPER(SUBSTR(county_region,1,1))) ;
ALTER TABLE counties ADD CONSTRAINT ck_region2 CHECK ( county_region IN ('Banat',
	'Transilvania', 'Dobrogea','Oltenia', 'Muntenia', 'Moldova', 'Other'))  ;


-- postal_codes
ALTER TABLE postal_codes ADD CONSTRAINT ck_town CHECK ( 
	SUBSTR(town,1,1) = UPPER(SUBSTR(town,1,1))) ;


-- people
-- Declare the default value for person_genre	
ALTER TABLE people MODIFY ( pers_genre DEFAULT 'F')  ;
-- now, for the constraints
ALTER TABLE people ADD CONSTRAINT ck_fam_name CHECK ( 
	SUBSTR(pers_family_name,1,1) = UPPER(SUBSTR(pers_family_name,1,1))) ;
ALTER TABLE people ADD CONSTRAINT ck_1st_name CHECK ( 
	SUBSTR(pers_first_name,1,1) = UPPER(SUBSTR(pers_first_name,1,1))) ;
ALTER TABLE people ADD CONSTRAINT ck_pers_addr CHECK ( 
	SUBSTR(pers_address,1,1) = UPPER(SUBSTR(pers_address,1,1))) ;
ALTER TABLE people ADD CONSTRAINT ck_genre CHECK ( pers_genre IN ('F', 'M') ) ;
ALTER TABLE people ADD CONSTRAINT ck_pers_email_p CHECK ( 
	pers_email LIKE '%@%' ) ;
ALTER TABLE people ADD CONSTRAINT ck_pers_email_o CHECK ( 
	office_email LIKE '%@%' ) ;


-- customers
ALTER TABLE customers ADD CONSTRAINT ck_cust_name CHECK ( 
	SUBSTR(cust_name,1,1) = UPPER(SUBSTR(cust_name,1,1))) ;
ALTER TABLE customers ADD CONSTRAINT ck_fisc_code CHECK ( 
	fiscal_code=LTRIM(UPPER(fiscal_code))) ;
ALTER TABLE customers ADD CONSTRAINT ck_cust_addr CHECK ( 
	SUBSTR(cust_address,1,1) = UPPER(SUBSTR(cust_address,1,1))) ;
ALTER TABLE customers ADD CONSTRAINT ck_cust_email CHECK ( 
	cust_email LIKE '%@%' ) ;


-- months
ALTER TABLE months ADD CONSTRAINT ck_months_year CHECK ( 
	year BETWEEN  1990 AND 2020) ;
ALTER TABLE months ADD CONSTRAINT ck_months_month CHECK ( 
	month BETWEEN  1 AND 12) ;


-- current_contacts
ALTER TABLE current_contacts ADD CONSTRAINT ck_cc_pos CHECK ( 
	SUBSTR(position,1,1) = UPPER(SUBSTR(position,1,1))) ;


-- former_contacts
ALTER TABLE former_contacts ADD CONSTRAINT ck_fc_pos CHECK ( 
	SUBSTR(position,1,1) = UPPER(SUBSTR(position,1,1))) ;


-- products
-- Declare the default value for VAT percent	
ALTER TABLE products MODIFY ( current_vat_percent DEFAULT .24 )  ;
-- now for the constraints
ALTER TABLE products ADD CONSTRAINT ck_prod_name CHECK ( 
	SUBSTR(product_name,1,1) = UPPER(SUBSTR(product_name,1,1))) ;
ALTER TABLE products ADD CONSTRAINT ck_prod_group CHECK ( 
	SUBSTR(group_,1,1) = UPPER(SUBSTR(group_,1,1))) ;



-- invoices
-- Declare the default value for attribute "is_closed"	
ALTER TABLE invoices MODIFY ( is_closed DEFAULT 'N')  ;
-- now, for the constraints
ALTER TABLE invoices ADD CONSTRAINT ck_invoice_date CHECK ( 
	invoice_date BETWEEN TO_DATE('01/08/2000','DD/MM/YYYY') AND 
	TO_DATE( '31/12/2025','DD/MM/YYYY')) ;
ALTER TABLE invoices ADD CONSTRAINT ck_n_of_rows CHECK ( 
	n_of_rows >= 0 ) ;
ALTER TABLE invoices ADD CONSTRAINT ck_inv_am_ref CHECK ( 
	invoice_amount >= amount_refused ) ;
ALTER TABLE invoices ADD CONSTRAINT ck_is_closed CHECK ( is_closed IN ('N', 'Y') ) ;
ALTER TABLE invoices ADD CONSTRAINT ck_invoice_status CHECK ( 
	invoice_status IN ('pending', 'closed', 'partially collected', 'fully collected', 
		'cancelled', 'refused', 'other'))  ;


-- invoice_details
ALTER TABLE invoice_details ADD CONSTRAINT ck_row_number CHECK ( 
	row_number >= 1 ) ;


-- receipts
ALTER TABLE receipts ADD CONSTRAINT ck_receipt_date CHECK ( 
	receipt_date BETWEEN DATE'2000-08-01' AND DATE'2025-12-31') ;
ALTER TABLE receipts ADD CONSTRAINT ck_doc_date CHECK ( 
	receipt_docum_date BETWEEN DATE'2000-08-01' AND DATE'2025-12-31') ;
 




