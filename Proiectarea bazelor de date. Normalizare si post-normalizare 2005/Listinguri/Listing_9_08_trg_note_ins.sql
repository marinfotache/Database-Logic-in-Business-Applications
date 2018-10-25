CREATE OR REPLACE TRIGGER trg_note_ins
 AFTER INSERT ON note FOR EACH ROW
BEGIN
	UPDATE note_finale SET notafinala = :NEW.nota
	 WHERE matricol=:NEW.matricol AND coddisc=:NEW.coddisc ;
	
	IF SQL%ROWCOUNT = 0 THEN -- nr.liniilor modificate este 0
		INSERT INTO note_finale VALUES (:NEW.matricol, :NEW.coddisc, :NEW.nota) ;
	END IF;
END ;

