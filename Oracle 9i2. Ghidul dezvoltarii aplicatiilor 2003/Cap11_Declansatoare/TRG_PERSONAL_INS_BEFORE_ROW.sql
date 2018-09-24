CREATE OR REPLACE TRIGGER TRG_PERSONAL_INS_BEFORE_ROW
 BEFORE 
 INSERT
 ON PERSONAL
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
DECLARE
    marca_noua personal.marca%TYPE ; 
BEGIN
    SELECT seq_marca.NEXTVAL INTO marca_noua FROM dual ;
    :NEW.marca := marca_noua ;
END ;
/
