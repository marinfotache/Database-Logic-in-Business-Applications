-- declansator de stergere (tot) cu dubla actiune, CASCADE sau RESTRICT
CREATE OR REPLACE TRIGGER trg_personal_del_before_row
 BEFORE DELETE ON personal
 REFERENCING OLD AS OLD NEW AS NEW
 FOR EACH ROW 
BEGIN 
 dbms_output.put_line('trg_personal_del_before_row') ;
    IF pachet_salarizare.v_regula_del_personal = 'C' THEN 
       -- DELETE CASCADE !
       DELETE FROM salarii WHERE marca = :OLD.marca ;
       DBMS_OUTPUT.PUT_LINE ('Din SALARII s-au sters ' || SQL%ROWCOUNT || ' inregistrari ');
       DELETE FROM retineri WHERE marca = :OLD.marca ;
       DBMS_OUTPUT.PUT_LINE ('Din RETINERI s-au sters ' || SQL%ROWCOUNT || ' inregistrari ');
       DELETE FROM sporuri WHERE marca = :OLD.marca ;
       DBMS_OUTPUT.PUT_LINE ('Din SPORURI s-au sters ' || SQL%ROWCOUNT || ' inregistrari ');
       DELETE FROM pontaje WHERE marca = :OLD.marca ;
       DBMS_OUTPUT.PUT_LINE ('Din PONTAJE s-au sters ' || SQL%ROWCOUNT || ' inregistrari ');
    ELSE
       -- UPDATE RESTRICT !
       IF pachet_salarizare.f_marca_in_pontaje (:OLD.marca) THEN 
         RAISE_APPLICATION_ERROR (-20510, 'Marca stearsa are copii in PONTAJE');
       END IF ;
       IF pachet_salarizare.f_marca_in_sporuri (:OLD.marca) THEN 
         RAISE_APPLICATION_ERROR (-20511, 'Marca stearsa are copii in SPORURI');
       END IF ;
       IF pachet_salarizare.f_marca_in_retineri (:OLD.marca) THEN 
         RAISE_APPLICATION_ERROR (-20512, 'Marca stearsa are copii in RETINERI');
       END IF ;
       IF pachet_salarizare.f_marca_in_salarii (:OLD.marca) THEN 
         RAISE_APPLICATION_ERROR (-20513, 'Marca stearsa are copii in SALARII');
       END IF ;
    END IF ;       
END ;
/
