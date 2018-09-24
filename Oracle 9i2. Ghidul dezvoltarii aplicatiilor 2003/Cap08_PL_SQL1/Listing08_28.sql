/* Refacerea blocului din listing 8.25, prin recursul la BULK COLLECT si FORALL*/
DECLARE
  v_an salarii.an%TYPE := 2003 ;
  v_luna salarii.luna%TYPE := 1  ;

  /* in locul cursorului c_ore folosim un VARRAY - v_ore - care va contine toate valorile
  necesare actualizarii tabelelor SPORURI si SALARII */

   TYPE t_marca IS TABLE OF personal.marca%TYPE INDEX BY PLS_INTEGER ;
   v_marca t_marca ;
   v2_marca t_marca ;

   TYPE t_marca IS TABLE OF personal.marca%TYPE INDEX BY PLS_INTEGER ;
   v_marca t_marca ;
   v2_marca t_marca ;

   TYPE t_marca IS TABLE OF personal.marca%TYPE INDEX BY PLS_INTEGER ;
   v_marca t_marca ;
   v2_marca t_marca ;

   TYPE t_marca IS TABLE OF personal.marca%TYPE INDEX BY PLS_INTEGER ;
   v_marca t_marca ;
   v2_marca t_marca ;


   TYPE t_marca IS TABLE OF personal.marca%TYPE INDEX BY PLS_INTEGER ;
   v_marca t_marca ;
   v2_marca t_marca ;
   
   TYPE t_spvech IS TABLE OF sporuri.spvech%TYPE INDEX BY PLS_INTEGER ;
   v_spvech t_spvech ;
   v2_spvech t_spvech ;
   
   TYPE t_orenoapte IS TABLE OF sporuri.orenoapte%TYPE INDEX BY PLS_INTEGER ;
   v_orenoapte t_orenoapte ;
   v21_orenoapte t_orenoapte ;

   TYPE t_spnoapte IS TABLE OF sporuri.spnoapte%TYPE INDEX BY PLS_INTEGER ;
   v_spnoapte t_spnoapte ;
   v2_spnoapte t_spnoapte ;
   
   TYPE t_orelucrate IS TABLE OF salarii.orelucrate%TYPE INDEX BY PLS_INTEGER ;
   v_orelucrate t_orelucrate ;
   v2_orelucrate t_orelucrate ;
   
   TYPE t_oreco IS TABLE OF salarii.oreco%TYPE INDEX BY PLS_INTEGER ;
   v_oreco t_oreco ;
   v2_oreco t_oreco ;
   
   TYPE t_venitbaza IS TABLE OF salarii.venitbaza%TYPE INDEX BY PLS_INTEGER ;
   v_venitbaza t_venitbaza ;
   v2_venitbaza t_venitbaza ;

   TYPE t_sporuri IS TABLE OF salarii.sporuri%TYPE INDEX BY PLS_INTEGER ;
   v_sporuri t_sporuri ;
   v2_sporuri t_sporuri ;

  /* se declara un tip articol pentru incarcarea din PERSONAL a marcilor, anilor
   de vechime si salariilor orare pentru toti angajatii */
  TYPE t_rec_pers IS RECORD (
    marca personal.marca%TYPE, ani_vechime NUMBER (4,2),
    salorar personal.salorar%TYPE, salorarco personal.salorarco%TYPE ) ;
  
  TYPE t_personal_manevra IS VARRAY (500000) OF t_rec_pers ;
  
  TYPE t_personal IS TABLE OF t_rec_pers INDEX BY PLS_INTEGER ;

  v_pers_manevra t_personal_manevra ;

  v_personal t_personal ; 	

  -- tipul si variabila vector cu marime variabila
  TYPE t_sporv IS VARRAY(6) OF transe_sv%ROWTYPE ; --sunt 6 transe de vechime (în TRANSE_SV)
  v_sporv t_sporv := t_sporv() ;

  -- o variabila contoar
  k PLS_INTEGER := 1 ;
 
BEGIN 
 -- incepem cu ceea ce este mai important, adica cu stersul
 DELETE FROM sporuri WHERE  an = v_an AND luna = v_luna ;
 DELETE FROM salarii WHERE  an = v_an AND luna = v_luna ;
 COMMIT ;

  -- mai intii, se preiau cele cinci informatii in V_PERS_MANEVRA, bun prilej de un BULK COLLECT 
  SELECT marca, MONTHS_BETWEEN( TO_DATE('01/'||v_luna||'/'||v_an, 'DD/MM/YYYY'),datasv)/12,
    salorar, salorarco 
   INTO v_pers_manevra
   FROM personal 
   ORDER BY marca ; 

  /* din VARRAY, datele se preiau intr-un tablou asociativ; trucul consta in accesul
   la datele unui angajat pe baza marcii sale; or, asta e posibil doar cu un tablou asociativ */
 FOR i IN 1..v_pers_manevra.COUNT LOOP
  v_personal (v_pers_manevra(i).marca).ani_vechime := v_pers_manevra(i).ani_vechime ;
  v_personal (v_pers_manevra(i).marca).salorar := v_pers_manevra(i).salorar ;
  v_personal (v_pers_manevra(i).marca).salorarco := v_pers_manevra(i).salorarco ;
 END LOOP ;

  /* tot la început initializam vectorul cu marime variabila V_SPORV care contine tabela TRANSE_SV
  de data aceasta, se apeleza la BULK COLLECT */
--  SELECT * BULK COLLECT INTO v_sporv FROM transe_sv ORDER BY ani_limita_inf ;

 DBMS_OUTPUT.PUT_LINE(v_sporv.COUNT) ;

/*
  SELECT marca, 0, SUM(orenoapte), 0, SUM(orelucrate), SUM(oreco), 0,0 
  BULK COLLECT INTO v_ore 
  FROM pontaje 
  WHERE TO_NUMBER(TO_CHAR(data,'YYYY')) = v_an AND TO_NUMBER(TO_CHAR(data,'MM')) = v_luna
  GROUP BY marca ;

-- secventa iterativa principala
 FOR k IN 1..v_ore.COUNT LOOP

  -- în loc de consultarea tabelei TRANSE_SV, procentul se va afla din VARRAY
  FOR i IN 1..v_sporv.COUNT LOOP
    IF v_personal(v_ore.marca).ani_vechime >= v_sporv(i).ani_limita_inf AND 
     v_personal(v_ore.marca).ani_vechime < v_sporv(i).ani_limita_sup  THEN 
      -- componenta curenta a VARRAY-ului este care contine procentul corect
      i_vechime := i ;
      EXIT ; 
    END IF ;
  END LOOP      ;

 /* se calculeaza venitul de baza, sporul de vechime si sporul de noapte; indexul vectorului
 asociativ este chiar marca curenta din C_ORE /
 v_ore(k).venitbaza := ROUND(v_ore(k).orelucrate * v_personal(v_ore(k).marca).salorar + 
       v_ore(k).oreco * v_personal(v_ore(k).marca).salorarco,-2) ;

 DBMS_OUTPUT.PUT_LINE('-----') ;
 DBMS_OUTPUT.PUT_LINE('-----') ;
 DBMS_OUTPUT.PUT_LINE(i_vechime) ;
 DBMS_OUTPUT.PUT_LINE(v_sporv(i_vechime).procent_sv) ;

-- v_ore(k).spvech := ROUND( v_ore(k).venitbaza * v_sporv(i_vechime).procent_sv / 100, -3) ; 
 
-- v_ore(k).spnoapte := ROUND(v_ore(k).orenoapte * v_personal(v_ore(k).marca).salorar * .15, -3) ;

 END LOOP ;
 
 -- se actualizeaza 
 FORALL i IN 1..v_ore.COUNT
  INSERT INTO sporuri VALUES (v_ore(i).marca, v_an, v_luna, v_ore.spvech (i), v_ore(i).orenoapte, 
   v_ore(i).spnoapte, 0)  ;

-- se procedeaza analog pentru tabela SALARII
 FORALL i IN 1..v_ore.COUNT
  INSERT INTO salarii VALUES (v_ore(i).marca, v_an, v_luna, v_ore(i).orelucrate, v_ore(i).oreco, 
   v_ore(i).venitbaza, v_ore(i).spvech + v_ore(i).spvech + 0, 0)  ;

 COMMIT ; */
END ;

