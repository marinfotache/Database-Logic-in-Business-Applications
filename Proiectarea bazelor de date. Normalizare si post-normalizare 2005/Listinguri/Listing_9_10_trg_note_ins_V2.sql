--ALTER TABLE note_finale ADD (DataUltimuluiExamen DATE) 
--/

CREATE OR REPLACE TRIGGER trg_note_ins
AFTER INSERT ON note FOR EACH ROW
BEGIN
	UPDATE note_finale	
 SET notafinala = :NEW.nota, dataultimuluiexamen = :NEW.dataex
	WHERE matricol=:NEW.matricol AND coddisc=:NEW.coddisc
    AND dataultimuluiexamen < :NEW.dataex ;
	
	IF SQL%ROWCOUNT = 0 THEN
 		-- inserarea se face numai daca nu e nici  o inregistrare pentru 
   -- examinarea (matricol, coddisc) curenta în NOTE_FINALE
		INSERT INTO note_finale
			SELECT matricol, :NEW.coddisc,  :NEW.nota, :NEW.dataex
			FROM studenti WHERE matricol=:NEW.matricol AND
    NOT EXISTS
				(SELECT 1 FROM note_finale WHERE matricol=:NEW.matricol AND
  					coddisc=:NEW.coddisc) ;
	END IF;
END ;
/

  
