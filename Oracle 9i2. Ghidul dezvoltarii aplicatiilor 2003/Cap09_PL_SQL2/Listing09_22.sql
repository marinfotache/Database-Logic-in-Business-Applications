/* procedura de actualizare, a tabelelor SPORURI si SALARII 
 pe baza datelor dn PONTAJE */
CREATE OR REPLACE PROCEDURE p_act_sp_sa 
 (an_ salarii.an%TYPE, luna_ salarii.luna%TYPE)
AS 
-- C_ORE calculeaza totalul orelor lucrate, de concediu si de noapte petru luna data
CURSOR c_ore IS
 SELECT marca, SUM(orelucrate) AS ore_l, SUM(oreco) AS ore_co, SUM(orenoapte) AS ore_n
 FROM pontaje  WHERE TO_NUMBER(TO_CHAR(data,'YYYY')) = an_ 
   AND TO_NUMBER(TO_CHAR(data,'MM')) = luna_ 
 GROUP BY marca ;

v_spvech sporuri.spvech%TYPE ;
v_venitbaza salarii.venitbaza%TYPE ;
v_spnoapte sporuri.spnoapte%TYPE ;
v_sporuri salarii.sporuri%TYPE ;
 
BEGIN 
FOR rec_ore IN c_ore LOOP
 
  /* se calculeaza venitul de baza, sporul de vechime si sporul de noapte;
  functia ROUND asigura rotunjirea la ordinul sutelor */
  v_venitbaza := ROUND( rec_ore.ore_l * NVL(TO_NUMBER(f_personal(rec_ore.marca, 'SALORAR')),0) + 
    rec_ore.ore_co * NVL(TO_NUMBER(f_personal(rec_ore.marca, 'SALORARCO')),0),-2) ;

 v_spvech := ROUND(v_venitbaza * f_procent_spor_vechime( f_ani_vechime( 
  TO_DATE(f_personal(rec_ore.marca, 'DATASV') , 'DD/MM/YYYY'), an_, luna_)) / 100, -3) ; 

 v_spnoapte := ROUND(rec_ore.ore_n * TO_NUMBER(f_personal(rec_ore.marca, 'SALORAR')) * .15, -3) ;

 IF f_exista_sp_re_sa (rec_ore.marca, an_, luna_, 'SPORURI') THEN 
   -- se actualizeaza tabela SPORURI pentru angajatul curent
    UPDATE sporuri 
    SET spvech = v_spvech, orenoapte = rec_ore.ore_n, spnoapte = v_spnoapte
    WHERE marca=rec_ore.marca AND an=an_ AND luna=luna_ ;
 ELSE
   INSERT INTO sporuri VALUES (rec_ore.marca, an_, luna_, 
    v_spvech, rec_ore.ore_n, v_spnoapte, 0) ;
 END IF ;

-- se procedeaza analog pentru tabela SALARII
 IF f_exista_sp_re_sa (rec_ore.marca, an_, luna_, 'SALARII') THEN 
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
END p_act_sp_sa  ;
/

