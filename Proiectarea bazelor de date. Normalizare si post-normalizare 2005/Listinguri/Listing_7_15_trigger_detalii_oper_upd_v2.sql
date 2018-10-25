DROP TRIGGER trg_do_upd1 ;
DROP TRIGGER trg_do_upd2 ;
DROP PACKAGE pac_trg ;
/

CREATE OR REPLACE TRIGGER trg_do_upd
 AFTER UPDATE OF IdOperatiune, ContDebitor, ContCreditor 
  ON detalii_operatiuni FOR EACH ROW
BEGIN
 -- mai intii, se fac modificarile pentru vechile valori
 UPDATE operatiuni
 SET  nrconturidebitoare = nrconturidebitoare -
   CASE WHEN nrconturidebitoare > 1 THEN 1	ELSE 0 END, 
      nrconturicreditoare =  nrconturicreditoare - 
   CASE WHEN nrconturicreditoare > 1 THEN 1 ELSE 0 END
  WHERE idoperatiune = :OLD.idoperatiune ;

 -- apoi, se fac modificarile pentru noile valori
 UPDATE operatiuni
 SET  nrconturidebitoare =  nrconturidebitoare +
         CASE WHEN :NEW.contdebitor <> uncontdebitor THEN 1	ELSE 0 END, 
      nrconturicreditoare =  nrconturicreditoare + 
         CASE WHEN :NEW.contcreditor <> uncontcreditor THEN 1 ELSE 0 END,  
     uncontdebitor = :NEW.contdebitor, 
     uncontcreditor = :NEW.contcreditor
  WHERE idoperatiune = :NEW.idoperatiune ;

END ;

