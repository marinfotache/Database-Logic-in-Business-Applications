/*
        Computing penalties for delays in invoice payment
*/

-- Table "delays_penalties" stores the penalties percents to be applied
--   depending on the number of days of the delay 
DROP TABLE delays_penalties ;

CREATE TABLE delays_penalties (
	n_of_days__from NUMBER(5) NOT NULL,
	n_of_days__to NUMBER(6) NOT NULL,
	penalty_percent NUMBER(5,2) NOT NULL,
	PRIMARY KEY (n_of_days__from, n_of_days__to),
	CONSTRAINT ck_days_from_to CHECK (n_of_days__from <= n_of_days__to)
	) ;

DELETE FROM delays_penalties ;

-- between 1 and 10 days of delay the penalty percent is 0.1% 
INSERT INTO delays_penalties VALUES ( 1, 10, 0.1) ;
-- ...
INSERT INTO delays_penalties VALUES (11, 25, 0.5) ;
INSERT INTO delays_penalties VALUES (26, 40, 0.1) ;
INSERT INTO delays_penalties VALUES (41, 100, 1) ;
INSERT INTO delays_penalties VALUES (101, 999999, 1.5) ;

COMMIT ;


-- table "invoices_penalties" keeps track of penalties on each invoice
DROP TABLE invoices_penalties ;

CREATE TABLE invoices_penalties (
    invoice_no NUMBER(8) NOT NULL PRIMARY KEY
        CONSTRAINT fk_inv_pen__invoices REFERENCES invoices(invoice_no),
    current_penalties NUMBER(12,2),
    date_last_penalty TIMESTAMP,
    comments VARCHAR2(200)
	) ;
	

-- tabela cu detalierea penalităților (zilnice) pentru fiecare factură
DROP TABLE detailed_penalties ;

CREATE TABLE detailed_penalties (
    id NUMBER (15) NOT NULL PRIMARY KEY,
    invoice_no NUMBER(8) NOT NULL 
        CONSTRAINT fk_detail_invoices REFERENCES invoices(invoice_no),
    timest_of_calc TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    initial_day_of_penalty DATE NOT NULL,	
    penalty_percent NUMBER (5,2),
    ammount_penalty NUMBER(12,2) DEFAULT 0 NOT NULL,
    obs VARCHAR2(200)
	) ;


-- avem nevoie de o secvență penttru cheia surogat 	detailed_penalties.id
CREATE SEQUENCE seq_id START WITH 1 MINVALUE 1 MAXVALUE 9999999999999 NOCACHE ORDER NOCYCLE ;

-- triggers - no problem if you don't understand them now, we'll cover then whithin a few weeks
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_detailes_penalties_ins_br
	BEFORE INSERT ON detailed_penalties FOR EACH ROW
BEGIN 
	:NEW.id := seq_id.NextVal ;
END ;
/
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_detailes_penalties_upd_br
	BEFORE UPDATE ON detailed_penalties FOR EACH ROW
BEGIN 
	RAISE_APPLICATION_ERROR (-20123, 'You cannot edit table <<detailed_penalties>>' ) ;
END ;
/
--------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_detailes_penalties_del_br
	BEFORE DELETE ON detailed_penalties FOR EACH ROW
BEGIN 
	RAISE_APPLICATION_ERROR (-20124, 'You cannot delete records of table <<detailed_penalties>>' ) ;
END ;
/	


-- the main procedure belons to a package (along with a function)
--------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pac_penalties IS
	FUNCTION f_penalty_percent (n_of_days_ delays_penalties.n_of_days__to%TYPE)
		RETURN delays_penalties.penalty_percent%TYPE ;
	
	PROCEDURE p_compute_daily_penalties ;
END ;
/



CREATE OR REPLACE PACKAGE BODY pac_penalties IS
-------------------------------------------------------------------------------------
FUNCTION f_penalty_percent (n_of_days_ delays_penalties.n_of_days__to%TYPE)
	RETURN delays_penalties.penalty_percent%TYPE 
IS
	v_percent delays_penalties.penalty_percent%TYPE ;
BEGIN
	SELECT penalty_percent 
	INTO v_percent 
	FROM delays_penalties WHERE n_of_days_ BETWEEN n_of_days__from AND n_of_days__to ;
	RETURN v_percent ;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 0 ;
END ;

---------------------------------------------------------------------------------------
PROCEDURE p_compute_daily_penalties IS
	v_n_of_days NUMBER(5) ;
	v_day DATE ;
	v_penalty invoices_penalties.current_penalties%TYPE ;
BEGIN
	FOR rec_invoice IN (
	        SELECT inv.*, 
	            COALESCE(ip.date_last_penalty, inv.invoice_date) AS date_last_penalty 
		    FROM 
		        (SELECT invoice_no, invoice_date,
		            (SELECT COALESCE(SUM(quantity * unit_price * (1 + VAT_percent)), 0) 
		             FROM invoice_details INNER JOIN products 
		                ON  invoice_details.product_id = products.product_id
		             WHERE invoice_details.invoice_no = invoices.invoice_no) AS Sold,
		            (SELECT COALESCE(SUM(amount), 0) 
		             FROM receipt_details 
		             WHERE invoice_no = invoices.invoice_no) AS Received
		        FROM invoices    ) inv
		        LEFT OUTER JOIN invoices_penalties ip ON inv.invoice_no=ip.invoice_no
		    WHERE Received < Sold
		            ) LOOP 
		v_n_of_days := 0 ;
		v_penalty := 0 ;
		v_day := TRUNC(rec_invoice.date_last_penalty) + INTERVAL '1' DAY ;
    		
		WHILE v_day < CURRENT_DATE LOOP
			IF RTRIM(TO_CHAR(v_day, 'day')) NOT IN ('sâmbătă', 'duminică') THEN
				v_n_of_days := v_n_of_days + 1 ;
				v_penalty := v_penalty + (rec_invoice.Sold - rec_invoice.Received) *  
				    f_penalty_percent (v_n_of_days ) / 100   ;	
			END IF ;
      		
			v_day := v_day + INTERVAL '1' DAY ;
		END LOOP ;  

	    -- penalties were computed until current_date - 1 (yesterday), so 
	    --   tables are updated

		INSERT INTO detailed_penalties (invoice_no, initial_day_of_penalty, penalty_percent, ammount_penalty )
			VALUES (rec_invoice.invoice_no, rec_invoice.date_last_penalty, 
			    f_penalty_percent (v_n_of_days ), v_penalty  ) ;

		UPDATE invoices_penalties 
			SET current_penalties = current_penalties + v_penalty,
			    date_last_penalty = CURRENT_TIMESTAMP
			WHERE invoice_no = rec_invoice.invoice_no ;

		IF SQL%ROWCOUNT = 0 THEN
			-- there is no record for this invoice in table 'invoices_penalties', so that an insert is needed
			INSERT INTO invoices_penalties VALUES (rec_invoice.invoice_no, v_penalty, CURRENT_TIMESTAMP, NULL) ;
		END IF ;
			
	END LOOP ;

END ;

END ;
/

-- test function "f_penalty_percent"
SELECT pac_penalties.f_penalty_percent(0) FROM dual ;
SELECT pac_penalties.f_penalty_percent(1) FROM dual ;
SELECT pac_penalties.f_penalty_percent(10) FROM dual ;
SELECT pac_penalties.f_penalty_percent(50) FROM dual ;
SELECT pac_penalties.f_penalty_percent(500) FROM dual ;

-- procedure
EXECUTE pac_penalties.p_compute_daily_penalties

COMMIT ;

SELECT * FROM detailed_penalties ;

SELECT * FROM invoices_penalties ;



