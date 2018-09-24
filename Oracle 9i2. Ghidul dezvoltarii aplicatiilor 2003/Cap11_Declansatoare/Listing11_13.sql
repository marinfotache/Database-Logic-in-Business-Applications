CREATE OR REPLACE TRIGGER TRG_PERSONAL_UPD_AFTER_ROW
 AFTER UPDATE OF MARCA ON PERSONAL
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
DECLARE
  v_marca_curenta personal.marca%TYPE ; 
  v_marca personal.marca%TYPE ; 
BEGIN 
    IF pachet_salarizare.v_regula_upd_personal = 'C' THEN -- UPDATE CASCADE
       UPDATE pontaje SET marca = :NEW.marca WHERE marca = :OLD.marca ;
       UPDATE sporuri SET marca = :NEW.marca WHERE marca = :OLD.marca ;
       UPDATE retineri SET marca = :NEW.marca WHERE marca = :OLD.marca ;
       UPDATE salarii SET marca = :NEW.marca WHERE marca = :OLD.marca ;
       UPDATE concedii SET marca = :NEW.marca WHERE marca = :OLD.marca ;
    ELSE
       -- UPDATE RESTRICT 
       IF pachet_salarizare.f_marca_in_pontaje (:OLD.marca) THEN 
         RAISE_APPLICATION_ERROR (-20500, 'Marca modificata are copii in PONTAJE');
       END IF ;
       IF pachet_salarizare.f_marca_in_sporuri (:OLD.marca) THEN 
         RAISE_APPLICATION_ERROR (-20501, 'Marca modificata are copii in SPORURI');
       END IF ;
       IF pachet_salarizare.f_marca_in_retineri (:OLD.marca) THEN 
         RAISE_APPLICATION_ERROR (-20502, 'Marca modificata are copii in RETINERI');
       END IF ;
       IF pachet_salarizare.f_marca_in_salarii (:OLD.marca) THEN 
         RAISE_APPLICATION_ERROR (-20503, 'Marca modificata are copii in SALARII');
       END IF ;
    END IF ;       

  IF :NEW.marca > :OLD.marca THEN 
    -- riscul apare doar atunci cind noua marca e mai mare decit vechea
  
      -- se determina valoarea actuala din secventa SEQ_MARCA 
      SELECT last_number INTO v_marca_curenta FROM USER_SEQUENCES 
      WHERE sequence_name = 'SEQ_MARCA' ;

      IF :NEW.marca <= v_marca_curenta + 3 THEN 
         -- consumam secventa pentru a evita violarea cheii primare
         FOR i IN v_marca_curenta .. :NEW.marca LOOP
           SELECT seq_marca.NEXTVAL INTO v_marca FROM dual ;
         END LOOP ;  
     ELSE     
         RAISE_APPLICATION_ERROR (-20529, 'Marca depaseste cu mai mult de 3 valoarea curenta a secventei ');
     END IF ; 
  END IF ;    
END ;
/


