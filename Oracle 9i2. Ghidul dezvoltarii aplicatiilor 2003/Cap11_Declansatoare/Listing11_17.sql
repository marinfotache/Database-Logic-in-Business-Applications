CREATE OR REPLACE TRIGGER trg_pontaje_after_row
  AFTER INSERT OR UPDATE OR DELETE ON pontaje
  REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
DECLARE
  v_spvech sporuri.spvech%TYPE ;
  v_spnoapte sporuri.spnoapte%TYPE ;
  v_venitbaza salarii.venitbaza%TYPE ;
  v_procent transe_sv.procent_sv%TYPE ;
BEGIN
  pachet_salarizare.v_declansator_PONTAJE := TRUE ;

  -- la trigerele de inserare si actualizare, valorile atributelor trebuie incrementate
  IF INSERTING OR UPDATING THEN 
     v_venitbaza := (:NEW.orelucrate * pachet_salarizare.f_salorar(:NEW.marca) +
                :NEW.oreco * pachet_salarizare.f_salorarco(:NEW.marca) ) ;
     v_spnoapte := :NEW.orenoapte * pachet_salarizare.f_salorar(:NEW.marca) * .15 ;
     v_procent := pachet_salarizare.f_procent_spor_vechime ( pachet_salarizare.f_ani_vechime (
             pachet_salarizare.f_datasv(:NEW.marca), EXTRACT (YEAR FROM :NEW.data),  
             EXTRACT (MONTH FROM :NEW.data) ) );   
     v_spvech := v_venitbaza * v_procent / 100 ;                  
  
    -- ne ocupam, mai intii, de tabela SPORURI 
    IF pachet_exista.f_exista (:NEW.marca, EXTRACT (YEAR FROM :NEW.data),
        EXTRACT (MONTH FROM :NEW.data), 'SPORURI') THEN 
      -- exista o inregistrare in SPORURI, ce trebuie actualizata
      UPDATE sporuri SET spvech = spvech + v_spvech,
        orenoapte = orenoapte + :NEW.orenoapte,  spnoapte = spnoapte + v_spnoapte
      WHERE marca = :NEW.marca AND an = EXTRACT (YEAR FROM :NEW.data) AND luna = EXTRACT (MONTH FROM :NEW.data) ;
    ELSE
      -- nu exista inregistrare in SPORURI, deci trebuie inserata
      INSERT INTO sporuri VALUES ( :NEW.marca, EXTRACT (YEAR FROM :NEW.data),  
       EXTRACT (MONTH FROM :NEW.data), v_spvech, :NEW.orenoapte, v_spnoapte, 0 ) ;  
    END IF ;

    -- apoi de tabela SALARII
    IF pachet_exista.f_exista (:NEW.marca, EXTRACT (YEAR FROM :NEW.data),
        EXTRACT (MONTH FROM :NEW.data), 'SALARII') THEN 
      -- exista o inregistrare in SALARII, ce trebuie actualizata
      UPDATE salarii SET orelucrate = orelucrate + :NEW.orelucrate, oreco = oreco + :NEW.oreco, 
        venitbaza = venitbaza + v_venitbaza, sporuri = sporuri + v_spvech + v_spnoapte
      WHERE marca = :NEW.marca AND an = EXTRACT (YEAR FROM :NEW.data) AND 
       luna = EXTRACT (MONTH FROM :NEW.data) ;
    ELSE
      -- nu exista inregistrare in SALARII, deci trebuie inserata
      INSERT INTO salarii VALUES (:NEW.marca, EXTRACT (YEAR FROM :NEW.data),  
       EXTRACT (MONTH FROM :NEW.data), :NEW.orelucrate, :NEW.oreco, 
       v_venitbaza, v_spvech + v_spnoapte, 0, 0 ) ;  
    END IF ;
   END IF ;


  -- la trigerele de stergere si actualizare, valorile atributelor trebuie DECREMENTATE
  IF DELETING OR UPDATING THEN 
     v_venitbaza := (:OLD.orelucrate * pachet_salarizare.f_salorar(:OLD.marca) +
                :OLD.oreco * pachet_salarizare.f_salorarco(:OLD.marca) ) ;
     v_spnoapte := :OLD.orenoapte * pachet_salarizare.f_salorar(:OLD.marca) * .15 ;
     v_procent := pachet_salarizare.f_procent_spor_vechime ( pachet_salarizare.f_ani_vechime (
             pachet_salarizare.f_datasv(:OLD.marca), EXTRACT (YEAR FROM :OLD.data),  
             EXTRACT (MONTH FROM :OLD.data) ) );   
     v_spvech := v_venitbaza * v_procent / 100 ;                  
  
    -- tabela SPORURI 
    UPDATE sporuri SET spvech = spvech - v_spvech, orenoapte = orenoapte - :OLD.orenoapte,  
        spnoapte = spnoapte - v_spnoapte
      WHERE marca = :OLD.marca AND an = EXTRACT (YEAR FROM :OLD.data) AND luna = EXTRACT (MONTH FROM :OLD.data) ;

    -- tabela SALARII
      UPDATE salarii SET orelucrate = orelucrate - :OLD.orelucrate, 
        oreco = oreco - :OLD.oreco, venitbaza = venitbaza - v_venitbaza, sporuri = sporuri - v_spvech - v_spnoapte
      WHERE marca = :OLD.marca AND an = EXTRACT (YEAR FROM :OLD.data) AND luna = EXTRACT (MONTH FROM :OLD.data) ;
   END IF ;

   pachet_salarizare.v_declansator_PONTAJE := FALSE ;
END ;
/


