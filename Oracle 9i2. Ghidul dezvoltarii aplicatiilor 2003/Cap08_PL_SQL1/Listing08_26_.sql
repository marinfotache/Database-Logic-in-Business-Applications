/* … acelasi enunt ca în Listing 8.16 si 8.17...; renuntam la exceptie. Schimbam logica programului: se foloseste un vector cu marime variabila pentru a stoca marcile angajatilor pentru care se opereaza modificarea salariului*/
DECLARE
-- declararea tipului VARRAY si a vectorului propriu-zis
  TYPE t_marca IS VARRAY(100000000) OF personal.marca%TYPE ;
  v_marca t_marca := t_marca() ; 

  CURSOR c_salariati (v_compart personal.compart%TYPE) IS 
   SELECT marca, salorar, TRUNC(MONTHS_BETWEEN(SYSDATE, datasv)/12, 0)
    AS ani_vechime
   FROM personal WHERE compart = v_compart ORDER BY 3 DESC  ;

  v_ani INTEGER ;  /* anii de vechime ai celui mai recent angajat cu marire de salariu */ 
BEGIN
  FOR rec_compart IN (SELECT DISTINCT compart FROM personal ) LOOP 
    v_ani := 99 ;
    FOR rec_salariati IN c_salariati (rec_compart.compart) LOOP  
    IF c_salariati%ROWCOUNT > 3 AND rec_salariati.ani_vechime < v_ani THEN 
     NULL ;
   ELSE
    /* prezentul angajat benefieciaza de sporul de salariu, asa ca marca sa va fi stocata în urmatoarea componenta a vectorului */
    v_marca.EXTEND ;
    v_marca(v_marca.COUNT) := rec_salariati.marca ;
    v_ani := rec_salariati.ani_vechime ;
  END IF ;  
END LOOP; 
END LOOP ;

/* Acesta este modul "clasic" de parcurgere a vectorului si actualizare a tabelei PERSONAL
FOR i IN 1..v_marca.COUNT LOOP
UPDATE personal  SET salorar = salorar + salorar * .1 WHERE marca = v_marca (i) ;
END LOOP ; */

-- noi vom folosi o delicatesa - "BULK BIND"
FORALL i IN 1..v_marca.COUNT
UPDATE personal  SET salorar = salorar + salorar * .1 WHERE marca = v_marca (i) ;
  	COMMIT ;
END ;     

