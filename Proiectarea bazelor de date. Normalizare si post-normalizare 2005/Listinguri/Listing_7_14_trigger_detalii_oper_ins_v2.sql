CREATE OR REPLACE TRIGGER trg_do_ins
 AFTER INSERT ON detalii_operatiuni FOR EACH ROW
BEGIN
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
