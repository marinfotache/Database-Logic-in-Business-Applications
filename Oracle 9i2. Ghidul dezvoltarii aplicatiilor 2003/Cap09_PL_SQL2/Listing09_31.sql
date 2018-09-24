-- corpul pachetului, plus cod de initializare
CREATE OR REPLACE PACKAGE BODY pachet_salarizare AS
------------------------------------------------------------------------ 
-- procedura de initializare a vectorului asociativ V_TRANSE_SV 
PROCEDURE p_init_v_transe_sv IS 
    i PLS_INTEGER ;
BEGIN
 v_transe_sv.DELETE ;
 FOR rec_transe IN (SELECT * FROM transe_sv ORDER BY ani_limita_inf) LOOP
   i := v_transe_sv.COUNT + 1 ;
   v_transe_sv (i).ani_limita_inf := rec_transe.ani_limita_inf ;     
   v_transe_sv (i).ani_limita_sup := rec_transe.ani_limita_sup ;     
   v_transe_sv (i).procent_sv := rec_transe.procent_sv ;           
 END LOOP ; 
END p_init_v_transe_sv ;

-------------------------------------------------------------------------- 
PROCEDURE p_init_vectori_personal 
IS
   CURSOR c_pers IS 
    SELECT marca, salorar, salorarco, datasv 
    FROM personal ORDER BY marca ;
BEGIN
  v_personal.DELETE ;
  FOR rec_pers IN c_pers LOOP 
    v_personal (rec_pers.marca).salorar := rec_pers.salorar ;
    v_personal (rec_pers.marca).salorarco := rec_pers.salorarco ;
    v_personal (rec_pers.marca).datasv := rec_pers.datasv ;        
  END LOOP ; 
END p_init_vectori_personal ;

--------------------------------------------------------------------
FUNCTION f_ani_vechime (datasv_ personal.datasv%TYPE,
    an_ IN  salarii.an%TYPE, luna_ salarii.luna%TYPE 
    ) RETURN transe_sv.ani_limita_inf%TYPE 
AS 
  prima_zi DATE := TO_DATE('01/'||luna_||'/'||an_, 'DD/MM/YYYY') ;
BEGIN 
  RETURN TRUNC(MONTHS_BETWEEN(prima_zi, datasv_) / 12,0) ;
END f_ani_vechime ;

--------------------------------------------------------------------
FUNCTION f_procent_spor_vechime (ani_ transe_sv.ani_limita_inf%TYPE)
    RETURN transe_sv.procent_sv%TYPE 
AS
  v_procent transe_sv.procent_sv%TYPE := 0 ;
BEGIN 
  -- ...v_transe_sv e cu siguranta initializat ..

  -- determinarea procentului
  FOR i IN 1..v_transe_sv.COUNT LOOP 
    IF ani_ >= v_transe_sv(i).ani_limita_inf AND 
      ani_ < v_transe_sv(i).ani_limita_sup THEN
      v_procent := v_transe_sv(i).procent_sv ;
      EXIT ;
    END IF ;
  END LOOP ;    
  RETURN v_procent ;
END f_procent_spor_vechime ;

-- aici incepe codul de initializare !!!
BEGIN
 p_init_v_transe_sv  ;
 p_init_vectori_personal ;

END pachet_salarizare ;
