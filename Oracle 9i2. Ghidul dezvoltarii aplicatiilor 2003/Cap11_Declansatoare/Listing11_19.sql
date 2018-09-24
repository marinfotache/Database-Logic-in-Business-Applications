/* SALARII - declansator pentru INSERARE/STERGERE si MODIFICAREA atributelor
  marca, an, luna, orelucrate, oreco, venitbaza */
CREATE OR REPLACE TRIGGER trg_salarii_after_row
  AFTER INSERT OR UPDATE OF marca, an, luna, orelucrate, oreco, venitbaza
   OR DELETE ON salarii
  REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
DECLARE
   v_unu NUMBER(1) := 0 ;  
BEGIN
  -- se interzice inserarea/modificarea care NU provine de la declansatorul tabelei PONTAJE
  IF pachet_salarizare.v_declansator_PONTAJE = FALSE THEN 
    IF INSERTING THEN 
      RAISE_APPLICATION_ERROR (-20335, 'In SALARII nu se pot insera intregistrari interactiv !!!') ;
    END IF ;   
    IF UPDATING THEN 
      RAISE_APPLICATION_ERROR (-20336, 'Nu puteti opera aceste modificari in mod interactiv !!!') ;
    END IF ;
  END IF ;   

  /* in caz ca nu exista inregistrari corespondente in PONTAJE sau SPORURI, 
   atunci linia se poate sterge */
  IF DELETING THEN 
    BEGIN 
     SELECT 1 INTO v_unu FROM DUAL WHERE EXISTS 
       (SELECT 1 FROM pontaje WHERE marca=:OLD.marca AND EXTRACT (YEAR FROM data) = :OLD.an AND
         EXTRACT (MONTH FROM data) = :OLD.luna AND orelucrate + oreco > 0 )
        OR EXISTS (SELECT 1 FROM sporuri WHERE marca=:OLD.marca AND an = :OLD.an AND
         luna = :OLD.luna AND spvech + spnoapte + altesp > 0)   ;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
       v_unu := 0 ;
    END ;
  
    IF v_unu = 1 THEN 
      RAISE_APPLICATION_ERROR (-20337, 'Nu aveti permisiunea de a sterge aceasta linie din SALARII !!!') ;
    END IF ;  
  END IF ;  
END trg_salarii_after_row ;
/

/* declansator special pentru atributul Sporuri, ce poate fi modificat atit prin declansatorul
  tabelei PONTAJE, cit si prin declansatorul tabelei SPORURI (AlteSp) */
CREATE OR REPLACE TRIGGER trg_salarii_altesp
  AFTER UPDATE OF sporuri ON salarii
  REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
BEGIN
  IF pachet_salarizare.v_declansator_PONTAJE OR pachet_salarizare.v_declansator_ALTESP THEN 
    -- e-n regula
    NULL ;
  ELSE
      RAISE_APPLICATION_ERROR (-20338, 'In SALARII, atributul Sporuri nu se poate edita interactiv !') ;
  END IF ;   
END trg_salarii_altesp ;
/


