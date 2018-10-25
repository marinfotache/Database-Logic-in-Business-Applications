DROP TABLE inchideri ;
CREATE TABLE inchideri (
	an NUMBER(4) DEFAULT EXTRACT (YEAR FROM CURRENT_DATE) 
		NOT NULL CHECK (an >= 2004),
	luna NUMBER(2) DEFAULT EXTRACT (MONTH FROM CURRENT_DATE) 
		NOT NULL CHECK (luna BETWEEN 1 AND 12),
	datainchiderii DATE DEFAULT CURRENT_DATE NOT NULL,
	operator VARCHAR2(30) DEFAULT USER,
	PRIMARY KEY (an, luna)
	) ;

INSERT INTO inchideri (an, luna) VALUES (2005,2);

-------------------------------------------------------------
-- pachetul PAC_INCHIDERI 
CREATE OR REPLACE PACKAGE pac_inchideri AS
	v_ultima_zi_inchisa DATE := NULL ;
	PROCEDURE init_v_ultima_zi_inchisa ;
END ;
/

CREATE OR REPLACE PACKAGE BODY pac_inchideri AS
----------------------------------
PROCEDURE init_v_ultima_zi_inchisa 
IS
	v_data DATE ;
BEGIN 
	IF v_ultima_zi_inchisa  IS NULL THEN 
		SELECT MAX(TO_DATE('01/'|| luna || '/' || an, 'DD/MM/YYYY')) 
		INTO v_data FROM inchideri ;
		v_ultima_zi_inchisa := LAST_DAY(v_data) ;
	END IF ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
		v_ultima_zi_inchisa := DATE'1999-12-31' ;
END ;

END ; -- pachet
/

--------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_inchideri_ins
	AFTER INSERT ON inchideri 
BEGIN
	pac_inchideri.v_ultima_zi_inchisa := NULL ;
	pac_inchideri.init_v_ultima_zi_inchisa ;

END ;
/

--------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_fact_del
	BEFORE DELETE ON fact FOR EACH ROW
BEGIN
	IF :OLD.definitivata='D' THEN
		RAISE_APPLICATION_ERROR(-20349, 'Nu puteti sterge o factura definitivata !');
	END IF ;

	pac_inchideri.init_v_ultima_zi_inchisa ;

	IF pac_inchideri.v_ultima_zi_inchisa >= :OLD.DataFact THEN
		RAISE_APPLICATION_ERROR(-20899, 
			'Factura apartine unei luni <<inchise>> !') ;
	END IF ;
END ;
/



