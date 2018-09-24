/* tablouri PL/SQL - vol. II
Tema: Reorganizarea tabloului PL/SQL, astfel incit prima componenta
sa aiba indexul 1 (sa ne existe indecsi negativi) 
iar componentele sa fie continue (fara spatii intre ele) */

DECLARE
 TYPE t_vector IS TABLE OF NUMBER(14,2) INDEX BY BINARY_INTEGER ;
 vector_sursa t_vector ; -- tabloul initial
 vector_destinatie t_vector ; -- tabloul dupa prelucrare
 
 /* cite un index pentru fiecare tablou */
 i_sursa BINARY_INTEGER ;
 i_destinatie BINARY_INTEGER := 1 ;

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

 -- se initializeaza indexul vectorului sursa
 i_sursa := vector_sursa.FIRST ;

 WHILE i_sursa <= vector_sursa.LAST LOOP
  vector_destinatie(i_destinatie) := vector_sursa(i_sursa) ;
  i_destinatie := i_destinatie + 1 ;

  -- deplasarea, in vectorul sursa, pe urmatoarea componenta initalizata
  i_sursa := vector_sursa.NEXT(i_sursa) ;   
 END LOOP ;

 DBMS_OUTPUT.PUT_LINE(' ') ;
 DBMS_OUTPUT.PUT_LINE('DUPA PRELUCRARE ') ;
 DBMS_OUTPUT.PUT_LINE('Tabloul are '||vector_destinatie.COUNT||' componente ') ;
 DBMS_OUTPUT.PUT_LINE('Indexul primeia este '||vector_destinatie.FIRST) ;
 DBMS_OUTPUT.PUT_LINE('Indexul ultimeia este '||vector_destinatie.LAST) ;

 -- in fine, se sterge tabloul sursa
 vector_sursa.DELETE ;
     
 END ;
 
 
 
