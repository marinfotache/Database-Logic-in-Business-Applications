CREATE OR REPLACE PACKAGE pachet_salarizare AS
  v_declansator_PONTAJE BOOLEAN := FALSE ;
  v_declansator_SPORURI BOOLEAN := FALSE ;
  v_declansator_ALTESP BOOLEAN := FALSE ;
FUNCTION f_salorar (marca_ personal.marca%TYPE) RETURN personal.salorar%TYPE ;
FUNCTION f_salorarco (marca_ personal.marca%TYPE) RETURN personal.salorarco%TYPE ;
FUNCTION f_datasv (marca_ personal.marca%TYPE) RETURN personal.datasv%TYPE ;


   v_compart_vechi personal.compart%TYPE ;
   v_compart_nou personal.compart%TYPE ;

   -- regulile (CASCADE sau RESTRICT) de urmat la modificarea unei marci sau stergerea
   -- 	unei linii în PERSONAL
    v_regula_upd_personal CHAR(1) := 'C' ; -- implicit UPDATE CASCADE
    v_regula_del_personal CHAR(1) := 'R' ; -- implicit DELETE RESTRICT

  	-- adaugam si patru functii pentru cautarea unei marci în tabelele copil
   FUNCTION f_marca_in_pontaje (marca_ personal.marca%TYPE) RETURN BOOLEAN ;
   FUNCTION f_marca_in_sporuri (marca_ personal.marca%TYPE) RETURN BOOLEAN ;   
   FUNCTION f_marca_in_retineri (marca_ personal.marca%TYPE) RETURN BOOLEAN ;
   FUNCTION f_marca_in_salarii (marca_ personal.marca%TYPE) RETURN BOOLEAN ;

    -- un vector pentru stocarea marcilor alocate
    TYPE t_v_marci IS TABLE OF personal.marca%TYPE INDEX BY PLS_INTEGER ;
    v_marci t_v_marci ;

    PROCEDURE p_initializare_v_marci  ;
      
    FUNCTION f_prima_gaura_marca RETURN personal.marca%TYPE ; 

  -- in continuare -- EXACT LISTING 9.30
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
 
  /* functiile de cautare sunt acum in pachetul PACHET_EXISTA */

  FUNCTION f_ani_vechime (datasv_ personal.datasv%TYPE,
    an_ IN  salarii.an%TYPE, luna_ salarii.luna%TYPE 
    ) RETURN transe_sv.ani_limita_inf%TYPE ;

  FUNCTION f_procent_spor_vechime (ani_ transe_sv.ani_limita_inf%TYPE)
    RETURN transe_sv.procent_sv%TYPE ;

 CURSOR c_ore (an_ v_an%TYPE, luna_ v_luna%TYPE) IS
   SELECT marca, SUM(orelucrate) AS ore_l, SUM(oreco) AS ore_co, 
      SUM(orenoapte) AS ore_n FROM pontaje  
   WHERE TO_NUMBER(TO_CHAR(data,'YYYY')) = an_ AND 
      TO_NUMBER(TO_CHAR(data,'MM')) = luna_  GROUP BY marca ;

 prea_multe_ore EXCEPTION ;
    
END pachet_salarizare ;
/

-- corpul pachetului, plus cod de initializare
CREATE OR REPLACE PACKAGE BODY pachet_salarizare AS

-------------------------------------------------------------------------------
FUNCTION f_salorar (marca_ personal.marca%TYPE) RETURN personal.salorar%TYPE 
IS
 v_salorar personal.salorar%TYPE ;
BEGIN
 SELECT salorar INTO v_salorar FROM personal WHERE marca = marca_ ;
 RETURN v_salorar ;
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
  RETURN 0 ;
END f_salorar ;

---------------------------------------------------------------------------------
FUNCTION f_salorarco (marca_ personal.marca%TYPE) RETURN personal.salorarco%TYPE 
IS
 v_salorarco personal.salorarco%TYPE ;
BEGIN
 SELECT salorarco INTO v_salorarco FROM personal WHERE marca = marca_ ;
 RETURN v_salorarco ;
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
  RETURN 0 ;
END f_salorarco ;

-----------------------------------------------------------------------------
FUNCTION f_datasv (marca_ personal.marca%TYPE) RETURN personal.datasv%TYPE 
IS
 v_datasv personal.datasv%TYPE ;
BEGIN
 SELECT datasv INTO v_datasv FROM personal WHERE marca = marca_ ;
 RETURN v_datasv ;
EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
  RETURN SYSDATE ;
END f_datasv ;


--------------------------------------------------------------------------
FUNCTION f_marca_in_pontaje (
 marca_ personal.marca%TYPE) RETURN BOOLEAN
IS
   v_unu NUMBER(1) := 0;
BEGIN
   SELECT 1 INTO v_unu FROM dual WHERE EXISTS
       (SELECT 1 FROM pontaje WHERE marca = marca_) ;
   RETURN TRUE ;
EXCEPTION
 WHEN NO_DATA_FOUND THEN
  RETURN FALSE ;
END f_marca_in_pontaje ;

--------------------------------------------------------------------------   
FUNCTION f_marca_in_sporuri (
 marca_ personal.marca%TYPE) RETURN BOOLEAN 
IS
   v_unu NUMBER(1) := 0;
BEGIN
   SELECT 1 INTO v_unu FROM dual WHERE EXISTS
       (SELECT 1 FROM sporuri WHERE marca = marca_) ;
   RETURN TRUE ;
EXCEPTION
 WHEN NO_DATA_FOUND THEN
  RETURN FALSE ;
END f_marca_in_sporuri;   


--------------------------------------------------------------------------
FUNCTION f_marca_in_retineri (
 marca_ personal.marca%TYPE) RETURN BOOLEAN 
IS
   v_unu NUMBER(1) := 0;
BEGIN
   SELECT 1 INTO v_unu FROM dual WHERE EXISTS
       (SELECT 1 FROM retineri WHERE marca = marca_) ;
   RETURN TRUE ;
EXCEPTION
 WHEN NO_DATA_FOUND THEN
  RETURN FALSE ;
END f_marca_in_retineri;


--------------------------------------------------------------------------
FUNCTION f_marca_in_salarii (
 marca_ personal.marca%TYPE) RETURN BOOLEAN 
IS
   v_unu NUMBER(1) := 0;
BEGIN
   SELECT 1 INTO v_unu FROM dual WHERE EXISTS
       (SELECT 1 FROM salarii WHERE marca = marca_) ;
   RETURN TRUE ;
EXCEPTION
 WHEN NO_DATA_FOUND THEN
  RETURN FALSE ;
END f_marca_in_salarii ;


-- identic listing 11.3.

-----------------------------------------------------------------------
PROCEDURE p_initializare_v_marci IS
    -- un vector de manevra
    v2_marca t_v_marci ;    
  BEGIN 
    pachet_salarizare.v_marci.DELETE ;
    -- se stocheaza toate marcile in vectorul de manevra
    SELECT marca BULK COLLECT INTO v2_marca FROM personal ORDER BY marca ;
     
    -- marcile se trec din vectorul de manevra in vectorul public V_MARCI in care 
    -- indexul este chiar marca respectiva (pentru acces rapid)
    FOR i IN 1..v2_marca.COUNT LOOP 
          pachet_salarizare.v_marci (v2_marca(i)) := v2_marca (i) ; 
    END LOOP ;
  END p_initializare_v_marci  ;

------------------------------------------------------------------    
  FUNCTION f_prima_gaura_marca RETURN personal.marca%TYPE IS 
    v_i personal.marca%TYPE ; -- prima valoare
    v_f personal.marca%TYPE ;
  BEGIN 
    -- daca vectorul public V_MARCI nu este initializat, se lanseaza procedura de profil
    IF v_marci.COUNT = 0 THEN 
        p_initializare_v_marci ;
    END IF ;

    -- se determina valorile de start si actuala din secventa SEQ_MARCA 
    SELECT min_value, last_number INTO v_i, v_f FROM USER_SEQUENCES 
     WHERE sequence_name = 'SEQ_MARCA' ;

    -- se verifica, pe rind, daca toate valorilor din secventa au fost alocate 
    FOR i IN v_i..v_f - 1 LOOP 
        IF v_marci.EXISTS(i) THEN
            NULL ;
        ELSE
            -- s-a gasit o valoare nealocata ! se verifica daca, intre timp, o alta sesiune
            -- a beneficiat de aceasta marca
            IF pachet_exista.f_exista(i) THEN 
              -- valoarea a fost deja preluata de alt utilizator
              pachet_salarizare.v_marci(i) := i ;
            ELSE
              -- valoarea poate (aparent) fi alocata 
              RETURN i ;
            END IF ;
        END IF ;        
    END LOOP ; 
    
    -- in acest punct se ajunge daca vectorul a fost parcurs si nu a fost gasita
    --     nici o valoare nealocata, caz in care se apeleaza la secventa
    SELECT seq_marca.NextVal INTO v_f FROM DUAL ;
    RETURN v_f ;
  
  END f_prima_gaura_marca ;

-- in continuare -- LISTING 9.31

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
/
