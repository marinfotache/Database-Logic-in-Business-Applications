/* procedura de actualizare SPORURI/SALARII - alta versiune  */
CREATE OR REPLACE PROCEDURE p_act_sp_sa2
 (an_ salarii.an%TYPE, luna_ salarii.luna%TYPE)
AS 
  -- C_ORE este deja declarat in pachet si, astfel, a devenit public 
  v_spvech sporuri.spvech%TYPE ;
  v_venitbaza salarii.venitbaza%TYPE ;
  v_spnoapte sporuri.spnoapte%TYPE ;
  v_sporuri salarii.sporuri%TYPE ;
 
BEGIN 
  -- nu trebuie sa se mai verifice daca V_PERSONAL este initializat
    
  FOR rec_ore IN pachet_salarizare.c_ore (an_, luna_) LOOP

 		-- se verifica daca numarul orelor lucrate este exagerat  
    IF rec_ore.ore_l > 190 THEN
      RAISE pachet_salarizare.prea_multe_ore ;
    END IF ;  
 
    v_venitbaza := ROUND( rec_ore.ore_l * NVL(pachet_salarizare.v_personal(rec_ore.marca).salorar,0) + 
        rec_ore.ore_co * NVL(pachet_salarizare.v_personal(rec_ore.marca).salorarco,0),-2) ;

    v_spvech := ROUND(v_venitbaza * pachet_salarizare.f_procent_spor_vechime( pachet_salarizare.f_ani_vechime 
       (pachet_salarizare.v_personal(rec_ore.marca).datasv , an_, luna_)) / 100, -3) ; 

    v_spnoapte := ROUND(rec_ore.ore_n * pachet_salarizare.v_personal(rec_ore.marca).salorar * .15, -3) ;

    IF pachet_exista.f_exista (rec_ore.marca, an_, luna_, 'SPORURI') THEN 
      -- se actualizeaza tabela SPORURI pentru angajatul curent
      UPDATE sporuri 
      SET spvech = v_spvech, orenoapte = rec_ore.ore_n, spnoapte = v_spnoapte
      WHERE marca=rec_ore.marca AND an=an_ AND luna=luna_ ;
    ELSE
      INSERT INTO sporuri VALUES (rec_ore.marca, an_, luna_, 
        v_spvech, rec_ore.ore_n, v_spnoapte, 0) ;
    END IF ;

    -- se procedeaza analog pentru tabela SALARII
    IF pachet_exista.f_exista (rec_ore.marca, an_, luna_, 'SALARII') THEN 
       UPDATE salarii 
       SET orelucrate = rec_ore.ore_l, oreco = rec_ore.ore_co,  
         venitbaza = v_venitbaza, sporuri = (SELECT spvech + spnoapte + altesp 
       FROM sporuri WHERE an=an_ AND luna=luna_ AND marca = rec_ore.marca)
       WHERE marca=rec_ore.marca AND an=an_ AND luna=luna_ ;
    ELSE
       INSERT INTO salarii VALUES (rec_ore.marca, an_, luna_, rec_ore.ore_l, 
         rec_ore.ore_co, v_venitbaza, (SELECT spvech + spnoapte + altesp FROM sporuri 
        WHERE an=an_ AND luna=luna_ AND marca = rec_ore.marca),  0, 0) ;
    END IF ;
  END LOOP ;
COMMIT ;

EXCEPTION
 WHEN pachet_salarizare.prea_multe_ore THEN
  RAISE_APPLICATION_ERROR (-20005, 'E ceva in neregula cu pontajele') ;
END p_act_sp_sa2  ;
/

