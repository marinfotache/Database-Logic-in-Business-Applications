/* SPORURI - declansator pt. INSERARE/STERGERE si modificarea tuturor atributelor, 
   cu exceptia SPORURI.altesp */
CREATE OR REPLACE TRIGGER trg_sporuri_after_row
  AFTER INSERT OR UPDATE OF marca, an, luna, spvech, orenoapte, spnoapte
   OR DELETE ON sporuri
  REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
DECLARE
   v_unu NUMBER(1) := 0 ;  
BEGIN
  -- se modifica variabila publica 
  pachet_salarizare.v_declansator_SPORURI := TRUE ;

  -- daca modificarea nu provine de la declansatorul tabelei PONTAJE, 
  -- inserarea si modificarea sunt interzise !
  IF pachet_salarizare.v_declansator_PONTAJE = FALSE THEN 
    IF INSERTING THEN 
      RAISE_APPLICATION_ERROR (-20332, 'In SPORURI nu se pot insera intregistrari interactiv !!!') ;
    END IF ;   
    IF UPDATING THEN 
      RAISE_APPLICATION_ERROR (-20333, 'Nu puteti opera aceste modificari in mod interactiv !!!') ;
    END IF ;
  END IF ;   

  -- cu stergerea e alta poveste; daca nu exista nici un pontaj, atunci linia se poate sterge
  IF DELETING THEN 
    BEGIN 
     SELECT 1 INTO v_unu FROM DUAL WHERE EXISTS 
       (SELECT 1 FROM pontaje WHERE marca=:OLD.marca AND EXTRACT (YEAR FROM data) = :OLD.an AND
         EXTRACT (MONTH FROM data) = :OLD.luna AND orelucrate + oreco > 0 ) ;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
       v_unu := 0 ;
    END ;   
    IF v_unu = 1 THEN 
      RAISE_APPLICATION_ERROR (-20334, 'Nu aveti permisiunea de a sterge aceasta linie din SPORURI !!!') ;
    END IF ;  
  END IF ;
  pachet_salarizare.v_declansator_SPORURI := FALSE ;
END trg_sporuri_after_row ;
/

-- declansator special pentru atributul SPORURI.altesp
CREATE OR REPLACE TRIGGER trg_sporuri_altesp
  AFTER UPDATE OF altesp ON sporuri
  REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
BEGIN
   pachet_salarizare.v_declansator_ALTESP := TRUE ;
   UPDATE salarii SET sporuri = sporuri + :NEW.altesp - :OLD.altesp ;
   pachet_salarizare.v_declansator_ALTESP := FALSE ;
END trg_sporuri_altesp ;
/



