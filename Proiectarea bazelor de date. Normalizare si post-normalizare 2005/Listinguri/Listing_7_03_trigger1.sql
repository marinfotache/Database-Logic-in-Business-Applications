CREATE OR REPLACE TRIGGER trg_note_contabile_ins
 BEFORE INSERT ON note_contabile FOR EACH ROW
BEGIN 
 SELECT seq_idnota.NextVal INTO :NEW.IdNotaContabila FROM dual ;
END ; 

