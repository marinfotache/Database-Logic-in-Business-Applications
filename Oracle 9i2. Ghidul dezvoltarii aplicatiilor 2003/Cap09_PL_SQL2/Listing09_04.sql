-- procedura de ordonare a 5 numere
CREATE OR REPLACE PROCEDURE ordonare_5 (
 n1 NUMBER, n2 NUMBER, n3 NUMBER, n4 NUMBER, n5 NUMBER ) 
IS
 -- cele cinci numere se preiau intr-un tablou
 TYPE t_v IS TABLE OF NUMBER INDEX BY BINARY_INTEGER ;
 v t_v ;
 temp NUMBER (14,2) ; -- variabila folosita la schimbare
 o_schimbare BOOLEAN := TRUE ; 
BEGIN
 v(1) := n1 ; -- initializarea componentelor vectorului 
 v(2) := n2 ;
 v(3) := n3 ;
 v(4) := n4 ;
 v(5) := n5 ;
 
 WHILE o_schimbare LOOP 
  o_schimbare := FALSE ; -- presupunem ca nu va exista nici o inversiune
  FOR i IN 1..4 LOOP 
   IF v(i) > v(i+1) THEN /* ordinea nu e cea corecta, asa ca se schimba
      intre ele cele doua componente alaturate */
     temp := v(i) ;
     v(i) := v(i+1) ;
     v(i+1) := temp ;
     o_schimbare := TRUE ;
   END IF ;
  END LOOP ; 
 END LOOP ; 

  DBMS_OUTPUT.PUT_LINE ('Ordinea finala :' || v(1) ||' - '|| v(2) ||' - '|| v(3) 
    ||' - '|| v(4) ||' - '||v(5)) ;
END ;

