CREATE OR REPLACE TRIGGER trg_sporuri_after_row
  AFTER INSERT OR UPDATE OR DELETE ON sporuri
  REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
BEGIN
  -- la trigerul de actualizare, valoarea SALARII.sporuri trebuie incrementata
  IF UPDATING AND :NEW.altesp <> :OLD.altesp THEN 
      UPDATE salarii SET sporuri = sporuri + :NEW.altesp - :OLD.altesp
      WHERE marca = :NEW.marca AND an = :NEW.an AND luna = :NEW.luna ;
  ELSE
     -- deocamdata nimic !
     NULL ;
  END IF ;   
END ;
/




