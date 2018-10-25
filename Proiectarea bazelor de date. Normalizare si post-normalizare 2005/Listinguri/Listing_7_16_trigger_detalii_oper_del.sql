CREATE OR REPLACE TRIGGER trg_do_del
 BEFORE DELETE ON detalii_operatiuni FOR EACH ROW
BEGIN
 UPDATE operatiuni
 SET  nrconturidebitoare = nrconturidebitoare -
   CASE WHEN nrconturidebitoare > 1 OR nrconturidebitoare+nrconturicreditoare=2 THEN 1	ELSE 0 END, 
      nrconturicreditoare =  nrconturicreditoare - 
   CASE WHEN nrconturicreditoare > 1 OR nrconturidebitoare+nrconturicreditoare=2 THEN 1 ELSE 0 END,
      uncontdebitor = CASE WHEN nrconturidebitoare+nrconturicreditoare=2 THEN NULL ELSE uncontdebitor END, 
      uncontcreditor = CASE WHEN nrconturidebitoare+nrconturicreditoare=2 THEN NULL ELSE uncontcreditor END
  WHERE idoperatiune = :OLD.idoperatiune ;
END ;



