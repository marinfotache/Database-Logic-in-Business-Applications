CREATE OR REPLACE TRIGGER trg_rc_ins
 BEFORE INSERT ON rezultate_curse FOR EACH ROW
DECLARE
	v_puncte NUMBER(2) := 0 ;
BEGIN
	SELECT PunctePozitie INTO v_puncte FROM locuri_puncte 
	WHERE PozitieSosire = :NEW.PozitieSosire ;

	:NEW.NrPuncteCursa := v_puncte ;
END ;



