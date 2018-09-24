DECLARE
 v_parametru_actual VARCHAR2(60) := 'Valoare initiala in blocul anonim' ;
BEGIN 
 -- varianta 1 - FARA declansarea exceptiei 
 p_No_Copy (FALSE, v_parametru_actual) ;
 DBMS_OUTPUT.PUT_LINE ('Varianta 1 - dupa apel: '||v_parametru_actual) ;
  
 -- varianta 2 - CU declansarea exceptiei 
 v_parametru_actual := 'VARIANTA 2' ;
 p_No_Copy (TRUE, v_parametru_actual) ;
 DBMS_OUTPUT.PUT_LINE ('Varianta 2 - dupa apelul procedurii: '||v_parametru_actual) ; 
 EXCEPTION
 WHEN OTHERS THEN
--  se preia eroarea din procedura p_NO_COPY
 DBMS_OUTPUT.PUT_LINE ('Sectiunea EXCEPTION= ' || v_parametru_actual) ; 
END   ;  

