CREATE OR REPLACE TRIGGER trg_personal_upd_after_row
 AFTER UPDATE OF MARCA ON PERSONAL
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
BEGIN 
    dbms_output.put_line('trg_personal_upd_after_row') ;
    UPDATE pontaje SET marca = :NEW.marca WHERE marca = :OLD.marca ;
    UPDATE sporuri SET marca = :NEW.marca WHERE marca = :OLD.marca ;
    UPDATE retineri SET marca = :NEW.marca WHERE marca = :OLD.marca ;
    UPDATE salarii SET marca = :NEW.marca WHERE marca = :OLD.marca ;
    UPDATE concedii SET marca = :NEW.marca WHERE marca = :OLD.marca ;
END ;
/
