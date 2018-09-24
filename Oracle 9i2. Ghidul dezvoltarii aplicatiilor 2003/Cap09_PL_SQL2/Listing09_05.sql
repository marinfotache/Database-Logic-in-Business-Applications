-- procedura de ordonare a 5 numere - versiunea 2
CREATE OR REPLACE PROCEDURE ordonare_5v2 (
 nivel IN OUT PLS_INTEGER,
 n1 IN OUT NUMBER, n2 IN OUT NUMBER, n3 IN OUT NUMBER,
 n4 IN OUT NUMBER, n5 IN OUT NUMBER ) 
IS
 -- cele cinci numere se preiau intr-un tablou
 TYPE t_v IS TABLE OF NUMBER INDEX BY BINARY_INTEGER ;
 v t_v ;
  temp NUMBER (14,2) ; -- variabila de lucru
 o_schimbare BOOLEAN := FALSE ; 
BEGIN
 v(1) := n1 ; -- initializarea componentelor vectorului 
 v(2) := n2 ;
 v(3) := n3 ;
 v(4) := n4 ;
 v(5) := n5 ;
 
 /* se compara fiecare din primele 4 componente ale vectorului cu 
  urmatoarea */
 FOR i IN 1..4 LOOP 
  IF v(i) > v(i+1) THEN /* ordinea nu e cea corecta, asa ca se schimba
    intre ele cele doua componente alaturate */
   temp := v(i) ;
   v(i) := v(i+1) ;
   v(i+1) := temp ;
   o_schimbare := TRUE ;
   DBMS_OUTPUT.PUT_LINE ('Nivel '||nivel ||' - rezultat :' || v(1) ||' - '||
    v(2) ||' - '|| v(3) ||' - '|| v(4) ||' - '||v(5)) ;
   nivel := nivel + 1 ;
    -- apelul recursiv
   ordonare_5v2 (nivel, v(1), v(2), v(3), v(4), v(5)) ;
   nivel := nivel - 1 ; 
   -- se modifica valorilor parametrilor IN OUT propriu-zisi
   n1 := v(1) ;
   n2 := v(2) ;
   n3 := v(3) ;
   n4 := v(4) ;
   n5 := v(5) ;  
   EXIT ;
  END IF ;
 END LOOP ;
 
 IF o_schimbare AND nivel < 1 THEN
  DBMS_OUTPUT.PUT_LINE ('Ordinea finala :' || v(1) ||' - '|| v(2) ||' - '|| v(3) 
    ||' - '|| v(4) ||' - '||v(5)) ;
 END IF ;
END ;

