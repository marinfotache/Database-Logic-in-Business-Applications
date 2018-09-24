CREATE OR REPLACE PACKAGE pachet_salarizare AS

 /* primele doua variabile globale, AN_ si LUNA_ preiau valorile
  initiale din data sistemului */
 v_an salarii.an%TYPE := TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) ;
 v_luna salarii.luna%TYPE := TO_NUMBER(TO_CHAR(SYSDATE, 'MM')) ;

 -- variabila pentru pastrarea liniilor din TRANSE_SV
  TYPE t_transe_sv IS TABLE OF transe_sv%ROWTYPE INDEX BY PLS_INTEGER ;
  v_transe_sv t_transe_sv ;
 
  -- procedura de initializare a vectorului asociativ V_TRANSE_SV 
  PROCEDURE p_init_v_transe_sv ;

 /* se declara un vector asociativ pentu stocarea salariilor orare,
  salariilor orare pentru calculul indemnizatiei de concediu si sporului
  de vechime; indexul este chiar marca */
  TYPE r_personal IS RECORD (
   salorar personal.salorar%TYPE, salorarCO personal.salorarCO%TYPE,
   datasv personal.datasv%TYPE) ;

  TYPE  t_personal IS TABLE OF r_personal INDEX BY PLS_INTEGER ;
  v_personal t_personal ; 

 PROCEDURE p_init_vectori_personal ;
 
  /* mutam in pachet o serie de functii create anterior */
 FUNCTION f_este_in_pontaje (marca_ personal.marca%TYPE, 
   data_ pontaje.data%TYPE )  RETURN BOOLEAN ;

 FUNCTION f_este_in_sporuri (marca_ personal.marca%TYPE, 
   an_ v_an%TYPE, luna_ v_luna%TYPE ) RETURN BOOLEAN ;

 FUNCTION f_este_in_retineri (marca_ personal.marca%TYPE, 
   an_ v_an%TYPE, luna_ v_luna%TYPE ) RETURN BOOLEAN ;

 FUNCTION f_este_in_salarii (marca_ personal.marca%TYPE, 
   an_ v_an%TYPE, luna_ v_luna%TYPE ) RETURN BOOLEAN ;

  FUNCTION f_ani_vechime (datasv_ personal.datasv%TYPE,
    an_ IN  salarii.an%TYPE, luna_ salarii.luna%TYPE 
    ) RETURN transe_sv.ani_limita_inf%TYPE ;

  FUNCTION f_procent_spor_vechime (ani_ transe_sv.ani_limita_inf%TYPE)
    RETURN transe_sv.procent_sv%TYPE ;

 CURSOR c_ore (an_ v_an%TYPE, luna_ v_luna%TYPE) IS
   SELECT marca, SUM(orelucrate) AS ore_l, SUM(oreco) AS ore_co, 
      SUM(orenoapte) AS ore_n
   FROM pontaje  
   WHERE TO_NUMBER(TO_CHAR(data,'YYYY')) = an_ AND 
      TO_NUMBER(TO_CHAR(data,'MM')) = luna_ 
   GROUP BY marca ;

 prea_multe_ore EXCEPTION ;
    
END pachet_salarizare ;
