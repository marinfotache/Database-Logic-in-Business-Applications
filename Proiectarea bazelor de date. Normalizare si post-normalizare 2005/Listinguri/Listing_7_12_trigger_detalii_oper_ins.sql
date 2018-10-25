CREATE OR REPLACE TRIGGER trg_do_ins
 AFTER INSERT ON detalii_operatiuni FOR EACH ROW
DECLARE 
  v_nrcontdebit NUMBER(4) := 0 ;
  v_nrcontcredit NUMBER(4) := 0 ;
BEGIN
 SELECT COUNT(DISTINCT ContDebitor), COUNT (DISTINCT ContCreditor)
 INTO v_nrcontdebit, v_nrcontcredit
 FROM 
	  (SELECT ContDebitor, ContCreditor
    FROM detalii_operatiuni
    WHERE idoperatiune = :NEW.idoperatiune 
    UNION 
    SELECT :NEW.ContDebitor, :NEW.ContCreditor
    FROM dual 
    ) T ;

  IF v_nrcontdebit > 1 AND v_nrcontcredit > 1 THEN 
  		RAISE_APPLICATION_ERROR (-20852, 
     'Nu pot fi simultan mai multe conturi si pe debit si pe credit') ;
  END IF ;

END ;
