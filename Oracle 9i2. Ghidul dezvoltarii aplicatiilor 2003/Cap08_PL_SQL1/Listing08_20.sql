/* tablouri asociative - vol. 1 */
DECLARE
-- declararea tipului de tablouri asociative ce pot contine numere reale
TYPE t_vector IS TABLE OF NUMBER(14,2) INDEX BY BINARY_INTEGER ;

-- iata si tabloul propriu-zis
un_vector t_vector ;

BEGIN 
-- initializarea a câteva dintre componente
un_vector(-3) := -10 ;
un_vector(1) := 5 ;
un_vector(2) := 19 ;
un_vector(3) := 3 ;
un_vector(7) := 87 ;
  
DBMS_OUTPUT.PUT_LINE('Tabloul are '||un_vector.COUNT||' componente ') ;
DBMS_OUTPUT.PUT_LINE('Indexul primeia este '||un_vector.FIRST) ;
DBMS_OUTPUT.PUT_LINE('Indexul ultimeia este '||un_vector.LAST) ;
DBMS_OUTPUT.PUT_LINE('----------------------------------------') ;   

/* acesta e un mod eronat de a parcurge vectorul, deoarece pot
  exista si indecsi negativi, iar valorile nu sunt consecutive */
BEGIN 
FOR i IN 1..un_vector.COUNT LOOP  
/* la prima componenta (dupa 1) neintializata, se declanseaza exceptia
NO_DATA_FOUND */
DBMS_OUTPUT.PUT_LINE('Componenta '||i||' este '|| un_vector(i)) ;
END LOOP ; 
   	EXCEPTION 
-- preluam eroarea (acesta e motivul pentru care am folosit un bloc inclus)
WHEN NO_DATA_FOUND THEN 
DBMS_OUTPUT.PUT_LINE('Componenta neinitializata ') ; 
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('Alta eroare') ;   
END ;
 
DBMS_OUTPUT.PUT_LINE('----------------------------------------') ;   
/* acesta este modul indicat de parcurgere a tabloului, bazat pe proprietatile FIRST si LAST */ 
FOR i IN un_vector.FIRST..un_vector.LAST LOOP 
-- folosind clauza EXISTS evitam declansarea exceptiei
IF un_vector.EXISTS(i) THEN 
DBMS_OUTPUT.PUT_LINE('Componenta '||i||' este '|| un_vector(i)) ;
ELSE
DBMS_OUTPUT.PUT_LINE('Componenta '||i||' nu este  initializata') ;
END IF ;    
END LOOP ;
 END ;

 
 
 
