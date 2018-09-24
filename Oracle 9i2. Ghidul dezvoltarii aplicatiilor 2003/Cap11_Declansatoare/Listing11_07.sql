-- declansator cu dubla actiune, CASCADE sau RESTRICT
CREATE OR REPLACE TRIGGER trg_personal_upd_after_row
 AFTER UPDATE OF MARCA ON PERSONAL 
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
BEGIN 
 dbms_output.put_line('trg_personal_upd_after_row') ;
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
END ;
/
