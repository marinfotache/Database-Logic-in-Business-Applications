-- populare cu inregistrari pentru o luna (dintr-un an) a tabelei PONTAJE
-- cu un bloc inclus si folosirea exceptiilor
DECLARE
	an salarii.an%TYPE := 2003;
 luna salarii.luna%TYPE := 3 ;

 zi DATE ; -- variabila folosita la ciclare

 TYPE t_marca IS TABLE OF personal.marca%TYPE INDEX BY PLS_INTEGER ;
 v_marca t_marca ;

-- TYPE t_r_pont IS RECORD (marca pontaje.marca%TYPE, data pontaje.data%TYPE) ;
-- TYPE t_pont IS TABLE OF t_r_pont INDEX BY PLS_INTEGER ;
-- v_pont t_pont ;
  k PLS_INTEGER := 1 ; 

 TYPE t_pont_marca IS TABLE OF pontaje.marca%TYPE INDEX BY PLS_INTEGER ;
 v_pont_marca t_pont_marca ;
 
 TYPE t_pont_data IS TABLE OF pontaje.data%TYPE INDEX BY PLS_INTEGER ;
 v_pont_data t_pont_data ;

BEGIN 
 DBMS_OUTPUT.PUT_LINE ('initializam vectorul v_marca');
 -- initializam vectorul v_marca cu toate marcile din PERSONAL 
 SELECT marca BULK COLLECT INTO v_marca FROM PERSONAL ;

 DBMS_OUTPUT.PUT_LINE ('initializam tabloul V_PONT');
 /* includem in tablourile V_PONT_MARCA si V_PONT_DATA toate zilele 
  lucratoare si angajatii (corespondent unei linii de inserat in PONTAJE */
 FOR i IN 1..TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('01/' || luna || '/' || an, 'DD/MM/YYYY')),'DD')) LOOP
  zi := TO_DATE( TO_CHAR(i,'99') || '/' || luna || '/' || an, 'DD/MM/YYYY') ;
  IF TO_CHAR(zi, 'DAY') IN ('SAT', 'SUN') THEN
   -- e zi nelucratoare (simbata sau duminica)
   NULL ;
  ELSE
   FOR j IN 1..v_marca.COUNT LOOP 
    v_pont_marca(k) := v_marca(j) ;
    v_pont_data(k) := zi ;
    k := k + 1 ;
   END LOOP ;
  END IF ;
 END LOOP ;

 DBMS_OUTPUT.PUT_LINE ('Incercam sa inseram dintr-o singura miscare ');

 -- incercam sa inseram dintr-o singura miscare
 FORALL i IN 1..v_pont_marca.COUNT
  INSERT INTO pontaje (marca, data) VALUES (v_pont_marca(i), v_pont_data(i) ) ;

/* EXCEPTION   -- se preia eventuala violare a cheii primare
    WHEN DUP_VAL_ON_INDEX THEN
     -- se sterg mai intai inregistrarile pentru ziua curenta
      DELETE FROM pontaje WHERE data = zi ;     
      -- apoi se reinsereaza inregistrarile
     INSERT INTO pontaje (marca, data) 
       SELECT marca, zi FROM personal ;
   END ;   -- aici se termina blocul inclus    
  END IF ;
*/
 COMMIT ;
END ;
/ 
