CREATE TRIGGER FOTACHEM.TRG_PERSONAL_UPD_AFTER_ROW
 AFTER 
 UPDATE
 ON PERSONAL
 FOR EACH ROW 


BEGIN
    IF :NEW.marca <> :OLD.marca THEN 
        UPDATE pontaje SET marca = :NEW.marca WHERE marca = :OLD.marca ;
    END IF ;
END ;
/
