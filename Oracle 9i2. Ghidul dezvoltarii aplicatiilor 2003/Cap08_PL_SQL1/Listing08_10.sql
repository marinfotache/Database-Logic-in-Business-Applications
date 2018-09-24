/* Primul exemplu de cursor implicit */
DECLARE
 ani_etalon PLS_INTEGER := 50 ;
 numar PLS_INTEGER ;
BEGIN 
  /* se mareste cu 1000 de lei salariul orar al angajatilor care au 
 mai mult de un numar de ani vechime specificati prin variabila ANI_ETALON */
  UPDATE personal 
   SET salorar = salorar + 1000
   WHERE MONTHS_BETWEEN (SYSDATE,datasv) / 12 >= ani_etalon ;
  IF SQL%FOUND THEN 
     DBMS_OUTPUT.PUT_LINE('Exista cel putin un angajat cu vechime de peste '||
       ani_etalon || ' ani ')   ;
     numar := SQL%ROWCOUNT ;
     DBMS_OUTPUT.PUT_LINE('Dee fapt, numarul lor este '||numar)   ;
  ELSE
     DBMS_OUTPUT.PUT_LINE('Nu exista nici un angajat asa de matur ! ')   ;
 END IF  ;
 
 
END;
/
