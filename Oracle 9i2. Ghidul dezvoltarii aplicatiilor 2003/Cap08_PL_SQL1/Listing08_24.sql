/* Vectori cu marime variabila  */
DECLARE
-- folosim si un tip  VARRAY de obiecte scolaritate
 TYPE t_v_scolaritate IS VARRAY(8) OF scolaritate ;
 v_scolaritate t_v_scolaritate := t_v_scolaritate() ;	 

BEGIN 
 -- rezervam "cinci" componente
 v_scolaritate.EXTEND(5) ;
 -- initializam trei 
 v_scolaritate(1) := scolaritate (1990, 1994, 'X1', 'Y1') ;
 v_scolaritate(2) := scolaritate (1995,  null, 'X2', 'Y2') ;
 v_scolaritate(4) := scolaritate (NULL, NULL, NULL, NULL) ; 

 -- un prim bloc inclus pentru o prima eroare
 BEGIN 
  /* prima eroare - initializam o componenta pentru care nu s-a facut rezervarea */
  DBMS_OUTPUT.PUT_LINE('Incercam initializarea componentei 7');
  v_scolaritate(7) := scolaritate (2005, NULL, 'TEST', NULL) ; 
 EXCEPTION 
   WHEN OTHERS THEN
   DBMS_OUTPUT.PUT_LINE('Ecce eroarea:');
    DBMS_OUTPUT.PUT_LINE('Codul sau este '||SQLCODE||', iar mesajul '||SQLERRM);
  END  ;

 DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');

 -- al doilea bloc inclus pentru un alt tip de eroare
 BEGIN 
  /*incercam sa extindem vrectorul cu inca 8 componente, desi l-am declarat cu max. 10 */
  DBMS_OUTPUT.PUT_LINE('Incercam sa marim vectorul cu 8 componente');
  v_scolaritate.EXTEND(8); 
 EXCEPTION 
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Iata si a doua eroare:');
  DBMS_OUTPUT.PUT_LINE('Codul sau este '||SQLCODE||', iar mesajul '||SQLERRM);
 END  ;
END ;

 
 
 
