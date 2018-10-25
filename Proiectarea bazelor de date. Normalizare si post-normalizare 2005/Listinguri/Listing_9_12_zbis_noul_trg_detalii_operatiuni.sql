CREATE OR REPLACE TRIGGER trg_do_ins
 AFTER INSERT ON detalii_operatiuni FOR EACH ROW
DECLARE 
	v_nr NUMBER(3) := 0 ;
BEGIN
	IF f_este_frunza (:NEW.ContDebitor)=FALSE OR f_este_frunza (:NEW.ContCreditor)=FALSE THEN
		-- EROARE! Cel putin unul dintre conturile de pe debit sau credit nu este FRUNZA !!!
		RAISE_APPLICATION_ERROR(-20194, 
		'EROARE ! Cel putin unul dintre conturile de pe debit sau credit nu este FRUNZA !!!') ; 
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


	UPDATE conturi_elementare SET RulajDB = NVL(RulajDB, 0) + :NEW.Suma
	WHERE ContElementar = :NEW.ContDebitor ;

	UPDATE conturi_elementare SET RulajCR = NVL(RulajCR, 0) + :NEW.Suma
	WHERE ContElementar = :NEW.ContCreditor ;

END ;


