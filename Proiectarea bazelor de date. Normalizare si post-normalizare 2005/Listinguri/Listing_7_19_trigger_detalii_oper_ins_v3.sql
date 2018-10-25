CREATE OR REPLACE TRIGGER trg_do_ins
AFTER INSERT ON detalii_operatiuni FOR EACH ROW
DECLARE
	v_nr NUMBER(3) := 0 ;
BEGIN
	-- se numara câte conturi încep cu simbolurile contului
	-- debitor, pentru a vedea daca acesta se descompune
	SELECT COUNT(*) INTO v_nr FROM plan_conturi
	WHERE SUBSTR(SimbolCont,1,LENGTH(:NEW.ContDebitor))
  = :NEW.ContDebitor ;
	IF v_nr > 1 THEN
   RAISE_APPLICATION_ERROR(-20194, 'EROARE ! ContDebitor nu este FRUNZA !!!') ;
 END IF ;

	-- se numara câte conturi încep cu simbolurile contului
	-- creditor, pentru a vedea daca acesta se descompune
 SELECT COUNT(*) INTO v_nr FROM plan_conturi
	WHERE SUBSTR(SimbolCont,1,LENGTH(:NEW.ContCreditor))
  = :NEW.ContCreditor ;
	IF v_nr > 1 THEN
   RAISE_APPLICATION_ERROR(-20195, 'EROARE ! ContCreditor nu este FRUNZA !!!') ;
 END IF ;

 UPDATE operatiuni
 SET  nrconturidebitoare =  NVL(nrconturidebitoare, 1) +
   CASE WHEN :NEW.contdebitor <> NVL(uncontdebitor,:NEW.contdebitor) 
      THEN 1	ELSE 0 END, 
      nrconturicreditoare =  NVL(nrconturicreditoare, 1) + CASE 
        WHEN :NEW.contcreditor <> NVL(uncontcreditor,:NEW.contcreditor) 
       THEN 1 ELSE 0 END,  
     uncontdebitor = :NEW.contdebitor, 
     uncontcreditor = :NEW.contcreditor
  WHERE idoperatiune = :NEW.idoperatiune ;
END ;

