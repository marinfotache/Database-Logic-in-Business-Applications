-- declansatorul pentru generarea automata a marcii - ver. 2.0
CREATE OR REPLACE TRIGGER trg_personal_ins_befo_row
    BEFORE INSERT ON personal
    FOR EACH ROW
BEGIN
	SELECT seq_marca.NEXTVAL INTO :NEW.marca FROM dual ;
END ;

