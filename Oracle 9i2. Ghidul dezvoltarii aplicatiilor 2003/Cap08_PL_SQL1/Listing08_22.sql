/* tablouri PL/SQL - vol. III
Reorganizarea tabloului PL/SQL - varianta 2  */

DECLARE
 TYPE t_vector IS TABLE OF NUMBER(14,2) INDEX BY BINARY_INTEGER ;
 vector_sursa t_vector ; -- tabloul initial
 
 /* cite un index pentru fiecare tablou */
 i_sursa BINARY_INTEGER ;

 v_reia BOOLEAN := TRUE ;

BEGIN 
 -- initializare "manuala"
 vector_sursa(-3) := -10 ;
 vector_sursa(1) := 5 ;
 vector_sursa(2) := 19 ;
 vector_sursa(3) := 3 ;
 vector_sursa(7) := 87 ;

 DBMS_OUTPUT.PUT_LINE('INITIAL ') ;
 DBMS_OUTPUT.PUT_LINE('Tabloul are '||vector_sursa.COUNT||' componente ') ;
 DBMS_OUTPUT.PUT_LINE('Indexul primeia este '||vector_sursa.FIRST) ;
 DBMS_OUTPUT.PUT_LINE('Indexul ultimeia este '||vector_sursa.LAST) ;

 WHILE v_reia LOOP
  v_reia := FALSE ;
  FOR i IN vector_sursa.FIRST..vector_sursa.LAST LOOP 
   IF vector_sursa.EXISTS(i) THEN
    -- se testeaza daca cheia elementului curent este negativa
    IF i <= 0 THEN
      v_reia := FALSE ;
       vector_sursa (vector_sursa.COUNT + 1) := vector_sursa (i) ;
      vector_sursa.DELETE(i) ;
    ELSE
     -- inseamna ca elementul i exista, iar cheia sa este pozitiva
     NULL ;
   END IF ;
  ELSE 
    -- elementul i nu este initializat, asa ca preia valoarea ultimului din tablou
     vector_sursa (i) := vector_sursa.LAST ;
     -- se sterge ultimul element
     vector_sursa.DELETE(vector_sursa.LAST) ; 
  END IF;
 END LOOP ;
 END LOOP ;

 DBMS_OUTPUT.PUT_LINE(' ') ;
 DBMS_OUTPUT.PUT_LINE('DUPA PRELUCRARE ') ;
 DBMS_OUTPUT.PUT_LINE('Tabloul are '||vector_sursa.COUNT||' componente ') ;
 DBMS_OUTPUT.PUT_LINE('Indexul primeia este '||vector_sursa.FIRST) ;
 DBMS_OUTPUT.PUT_LINE('Indexul ultimeia este '||vector_sursa.LAST) ;

    
 END ;
 
 
 
