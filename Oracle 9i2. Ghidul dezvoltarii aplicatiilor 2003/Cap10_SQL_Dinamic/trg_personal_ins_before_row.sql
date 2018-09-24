-- Start of DDL Script for Trigger FOTACHEM.TRG_PERSONAL_INS_BEFORE_ROW
-- Generated 10.04.2003 12:07:51 from FOTACHEM@ORA9I2

CREATE OR REPLACE TRIGGER trg_personal_ins_before_row
BEFORE INSERT 
ON personal
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
    :NEW.marca := pac_salarizare.f_prima_gaura_marca() ; 
    pac_salarizare.v_marci (:NEW.marca) := :NEW.marca ;
END ;
/

-- End of DDL Script for Trigger FOTACHEM.TRG_PERSONAL_INS_BEFORE_ROW


