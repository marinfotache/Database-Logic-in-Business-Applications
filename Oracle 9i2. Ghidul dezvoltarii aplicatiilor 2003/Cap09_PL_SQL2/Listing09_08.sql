 DECLARE
  v_parametru_actual VARCHAR2(50) := 'Valoare initiala' ;
 BEGIN 
  -- varianta 1 - FARA declansarea exceptiei 
  Eroare_Controlata (FALSE, v_parametru_actual) ;
  DBMS_OUTPUT.PUT_LINE ('v_parametru_actual = '|| v_parametru_actual) ;
  
  -- varianta 2 - CU declansarea exceptiei 
  v_parametru_actual := 'Valoare - VARIANTA 2' ;
  Eroare_Controlata (TRUE, v_parametru_actual) ;
  DBMS_OUTPUT.PUT_LINE ('v_parametru_actual = '|| v_parametru_actual) ;
 
 EXCEPTION
  WHEN OTHERS THEN
  -- se preia eroarea din procedura EROARE_CONTROLATA
   DBMS_OUTPUT.PUT_LINE ('v_parametru_actual in sectiunea EXCEPTION= '
    || v_parametru_actual) ; 
 END   ;  
