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
https://github.com/marinfotache/Database-Logic-in-Business-Applications/blob/master/07_Business%20Rules%20with%20PL%20SQL/07-03_en_Business%20Rules%20and%20Scheduler.pptx
*/



--====================================================================================
-- 	            Business Rules Implemented with Oracle Scheduler
--         Example 1:   Automatic close of invoices
--  At 23:00 all open invoices will be automaticall closed by setting the value
--    of attribute "is_closed" on value "Y"
--====================================================================================


CREATE OR REPLACE PROCEDURE p_automatic_invoice_close
AS
BEGIN 
	UPDATE invoices SET is_closed = 'Y' WHERE COALESCE(is_closed,'N') <> 'Y' ;
	COMMIT ;
END ;
/

-- "JOB" definition
--   need privileges
BEGIN
	DBMS_SCHEDULER.CREATE_JOB (
		job_name => 'automatic_close',
		job_type => 'STORED_PROCEDURE',
		job_action => 'SDBIS.p_automatic_invoice_close',
		start_date => TIMESTAMP'2018-01-10 23:00:00',
		repeat_interval => 'FREQ=DAILY;INTERVAL=1', /* daily execution */
		end_date => TIMESTAMP'2018-01-31 23:59:00',
		auto_drop => FALSE,
		comments => 'Oracle Scheduler first example');
END;
/

-- "JOB" activation
BEGIN 
	DBMS_SCHEDULER.ENABLE('automatic_close');
END ;
/

/*
-- for cancelling this job, run:
BEGIN
	DBMS_SCHEDULER.DROP_JOB ('automatic_close');
END;
/
*/


--====================================================================================
-- 	            Business Rules Implemented with Oracle Scheduler
--         Example 2: Compute penalties for unpaid invoices (after payment deadline)
--====================================================================================

-- Table with penalty percents (diferent by ranges of number of days of delay)

DROP TABLE penalty_percents ;

CREATE TABLE penalty_percents (
	n_of_days__from NUMBER(5) NOT NULL,
	n_of_days__until NUMBER(6) NOT NULL,
	penalty_percent NUMBER(5,2) NOT NULL,
	PRIMARY KEY (n_of_days__from, n_of_days__until),
	CONSTRAINT ck_pen_intervals CHECK (n_of_days__from <= n_of_days__until)
	) ;

--DELETE FROM penalty_percents ;
INSERT INTO penalty_percents VALUES ( 0, 10, 0.01) ;
INSERT INTO penalty_percents VALUES (11, 25, 0.02) ;
INSERT INTO penalty_percents VALUES (26, 40, 0.04) ;
INSERT INTO penalty_percents VALUES (41, 100,0.12) ;
INSERT INTO penalty_percents VALUES (101, 999999, 0.2) ;
COMMIT ;


-- table with total amount of penalties on each invoice
DROP TABLE invoice_penalties ;

CREATE TABLE invoice_penalties (
    invoice_id  INTEGER PRIMARY KEY
        CONSTRAINT fk_inv_pen_invoices REFERENCES invoices(invoice_id),
    current_penalties NUMBER(12,2),
    last_update_ts TIMESTAMP,
    comments VARCHAR2(200)
	) ;
	

-- tabela cu detalierea penalităților (zilnice) pentru fiecare factură
DROP TABLE invoice_daily_penalties ;

CREATE TABLE invoice_daily_penalties (
    idp_id INTEGER PRIMARY KEY,
    invoice_id INTEGER NOT NULL 
        CONSTRAINT fk_idp_invoices REFERENCES invoices(invoice_id),
    update_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    penalty_initial_day DATE NOT NULL,	
    penalty_percent NUMBER (5,2),
    amount_penalty NUMBER(12,2) DEFAULT 0 NOT NULL,
    comments VARCHAR2(200)
	) ;


-- sequences needed for attribute "invoice_daily_penalties.idp_id"
CREATE SEQUENCE seq_idp_id START WITH 1 MINVALUE 1 MAXVALUE 9999999999999 NOCACHE ORDER NOCYCLE ;

-- table "invoice_daily_penalties" triggers
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_idp_ins_br
	BEFORE INSERT ON invoice_daily_penalties FOR EACH ROW
BEGIN 
	:NEW.idp_id := seq_idp_id.NextVal ;
END ;
/
---------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_idp_ups_br
	BEFORE UPDATE ON invoice_daily_penalties FOR EACH ROW
BEGIN 
	RAISE_APPLICATION_ERROR (-20323, 'Table <<invoice_daily_penalties>> record cannot be modified' ) ;
END ;
/
--------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_idp_del_br
	BEFORE DELETE ON invoice_daily_penalties FOR EACH ROW
BEGIN 
	RAISE_APPLICATION_ERROR (-20323, 'Table <<invoice_daily_penalties>> record cannot be deleted' ) ;
END ;
/	


-- procedure for computing delay penalties will be included in a package
--------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE pac_penalties IS
	FUNCTION f_penalty_percent (n_of_days_ penalty_percents.n_of_days__until%TYPE)
		RETURN penalty_percents.penalty_percent%TYPE ;
	
	PROCEDURE p_compute_daily_penalties ;
END ;
/

CREATE OR REPLACE PACKAGE BODY pac_penalties IS
-------------------------------------------------------------------------------------
FUNCTION f_penalty_percent (n_of_days_ penalty_percents.n_of_days__until%TYPE)
	RETURN penalty_percents.penalty_percent%TYPE 
IS
	v_percent penalty_percents.penalty_percent%TYPE ;
BEGIN
	SELECT penalty_percent 
	INTO v_percent 
	FROM penalty_percents WHERE n_of_days_ BETWEEN n_of_days__from AND n_of_days__until ;
	RETURN v_percent ;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		RETURN 0 ;
END ;

---------------------------------------------------------------------------------------
PROCEDURE p_compute_daily_penalties IS
	v_n_of_days NUMBER(5) ;
	v_date DATE ;
	v_penalty invoice_penalties.current_penalties%TYPE ;
BEGIN
	FOR rec_invoice IN (SELECT i.*, COALESCE(i_p.last_update_ts, 
			to_timestamp(i.invoice_date)) AS last_update_ts 
			 FROM invoices i LEFT OUTER JOIN invoice_penalties i_p 
			 ON i.invoice_id = i_p.invoice_id
				WHERE invoice_amount - amount_received - amount_refused > 0 ) LOOP 
		v_n_of_days := 0 ;
		v_penalty := 0 ;
		v_date := TRUNC(rec_invoice.last_update_ts) + INTERVAL '1' DAY ;
    		
		WHILE v_date < CURRENT_DATE LOOP
			IF RTRIM(TO_CHAR(v_date, 'day')) NOT IN ('sâmbătă', 'duminică', 'saturday', 'sunday') THEN
				v_n_of_days := v_n_of_days + 1 ;
				v_penalty := v_penalty + (rec_invoice.invoice_amount - rec_invoice.amount_received -
				    rec_invoice.amount_refused ) * 
				     f_penalty_percent (v_n_of_days ) / 100   ;	
			END IF ;
      		
			v_date := v_date + INTERVAL '1' DAY ;
		END LOOP ;  

		-- penalties computed; now write into tables
		INSERT INTO invoice_daily_penalties (invoice_id, penalty_initial_day, penalty_percent, amount_penalty )
			VALUES (rec_invoice.invoice_id, rec_invoice.last_update_ts, f_penalty_percent (v_n_of_days ), v_penalty  ) ;

		UPDATE invoice_penalties 
			SET current_penalties = current_penalties + v_penalty,
			    last_update_ts = CURRENT_TIMESTAMP
			WHERE invoice_id = rec_invoice.invoice_id ;

		IF SQL%ROWCOUNT = 0 THEN
			-- record does not exits in table "invoice_penalties" for current invoice:
			INSERT INTO invoice_penalties VALUES (rec_invoice.invoice_id, v_penalty, CURRENT_TIMESTAMP, NULL) ;

		END IF ;
			
	END LOOP ;

END ;

END ;
/


---------------------------------------------------------------------------------------
-- "JOB" definition
BEGIN
	DBMS_SCHEDULER.CREATE_JOB (
		job_name => 'compute_penalties',
		job_type => 'STORED_PROCEDURE',
		job_action => 'sdbis.pac_penalties.p_compute_daily_penalties',
		start_date => TIMESTAMP'2018-01-01 23:59:59',
		repeat_interval => 'FREQ=DAILY;INTERVAL=1', /* zilnic */
		end_date => TIMESTAMP'2018-02-01 10:00:00',
		auto_drop => FALSE,
		comments => 'Oracle Scheduler second example');
END;
/
----
-- JOB activation
BEGIN 
	DBMS_SCHEDULER.ENABLE('compute_penalties');
END ;
/


/*
-- delete the job
BEGIN
	DBMS_SCHEDULER.DROP_JOB ('compute_penalties');
END;
/
*/


DELETE FROM invoice_penalties ;

DELETE FROM invoice_daily_penalties ;









