-- Start of DDL Script for Trigger FOTACHEM.TRG_PERSONAL_UPD_AFTER_ROW
-- Generated 10.04.2003 12:08:55 from FOTACHEM@ORA9I2

CREATE OR REPLACE TRIGGER trg_personal_upd_after_row
AFTER UPDATE OF 
  marca
ON personal
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    UPDATE pontaje SET marca=:NEW.marca WHERE marca=:OLD.marca ;
    UPDATE sporuri SET marca=:NEW.marca WHERE marca=:OLD.marca ;
    UPDATE retineri SET marca=:NEW.marca WHERE marca=:OLD.marca ;
    UPDATE salarii SET marca=:NEW.marca WHERE marca=:OLD.marca ;
END ;
/

-- End of DDL Script for Trigger FOTACHEM.TRG_PERSONAL_UPD_AFTER_ROW


