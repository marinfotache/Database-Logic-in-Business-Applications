CREATE OR REPLACE PACKAGE pac_trg IS
 v_idoper operatiuni.idoperatiune%TYPE ;
END ;
/ 

CREATE OR REPLACE TRIGGER trg_do_upd1
 BEFORE UPDATE OF IdOperatiune, ContDebitor, ContCreditor 
   ON detalii_operatiuni FOR EACH ROW
BEGIN
 pac_trg.v_idoper := :NEW.idoperatiune ;
END ;
/

CREATE OR REPLACE TRIGGER trg_do_upd2
 AFTER UPDATE OF IdOperatiune, ContDebitor, ContCreditor 
   ON detalii_operatiuni 
DECLARE 
  v_nrcontdebit NUMBER(4) := 0 ;
  v_nrcontcredit NUMBER(4) := 0 ;
BEGIN
 SELECT COUNT(DISTINCT ContDebitor), COUNT (DISTINCT ContCreditor)
 INTO v_nrcontdebit, v_nrcontcredit
 FROM detalii_operatiuni
 WHERE idoperatiune = pac_trg.v_idoper ;
 
  IF v_nrcontdebit > 1 AND v_nrcontcredit > 1 THEN 
  		RAISE_APPLICATION_ERROR (-20852, 
     'Nu pot fi simultan mai multe conturi si pe debit si pe credit') ;
  END IF ;
END ;
/
