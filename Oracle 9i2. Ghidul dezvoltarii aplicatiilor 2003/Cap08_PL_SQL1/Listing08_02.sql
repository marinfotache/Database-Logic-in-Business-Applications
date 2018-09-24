-- blocul principal
DECLARE
 a INTEGER := 12 ;
 b VARCHAR2 (20) ;
 c DATE ;
BEGIN
 b := 'Ana are mere' ;
 c := TO_DATE('15/05/2003', 'DD/MM/YYYY') ; 

 DBMS_OUTPUT.PUT_LINE (' ') ;
 DBMS_OUTPUT.PUT_LINE ('La inceputul blocului principal') ;
 DBMS_OUTPUT.PUT_LINE ('a = '||a) ;
 DBMS_OUTPUT.PUT_LINE ('b = '||b) ;
 DBMS_OUTPUT.PUT_LINE ('c = '||c) ; 
 
 -- aici incepe blocul secundar
  DECLARE

--   b NUMBER(12,2) ;
   b VARCHAR2(20) ;
   c VARCHAR2(25) ;
   d DATE ;  
  BEGIN
   a:= 20 ;
--   b := 455 ;
   d := TO_DATE('11/06/2003', 'DD/MM/YYYY') ; 
   DBMS_OUTPUT.PUT_LINE ('  ') ;
   DBMS_OUTPUT.PUT_LINE ('  La inceputul blocului secundar') ;
   DBMS_OUTPUT.PUT_LINE ('  a = '||a) ;
   DBMS_OUTPUT.PUT_LINE ('  b = '||b) ;
   DBMS_OUTPUT.PUT_LINE ('  c = '||NVL(c, ' c este NULL')) ; 
   DBMS_OUTPUT.PUT_LINE ('  d = '||d) ; 
 END ; 

 -- revenirea in blocul principal
 DBMS_OUTPUT.PUT_LINE ('  ') ;
 DBMS_OUTPUT.PUT_LINE ('La revenirea in blocul principal') ;
 DBMS_OUTPUT.PUT_LINE ('a = '||a) ;
 DBMS_OUTPUT.PUT_LINE ('b = '||b) ;
 DBMS_OUTPUT.PUT_LINE ('c = '||c) ; 

-- daca linia urmatoare nu ar fi comentata, s-ar declansa eroarea din figura 8.6
-- DBMS_OUTPUT.PUT_LINE ('d = '||d) ; 

END ; 

