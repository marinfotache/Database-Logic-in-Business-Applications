DECLARE
  /* folosim si variabila NIVEL pentru a pune in evidenta 
   apelul recursiv al procedurii */
  nivel PLS_INTEGER := 0 ;
  
  -- cele cinci valori de ordonat
  nr1 NUMBER(14,2) := 12 ;
  nr2 NUMBER(14,2) := 123 ;
  nr3 NUMBER(14,2) := 120 ;
  nr4 NUMBER(14,2) := 78 ;
  nr5 NUMBER(14,2) := 2 ;
BEGIN
 DBMS_OUTPUT.PUT_LINE ('Ordinea initiala :' || nr1 ||' - '|| nr2 ||
   ' - '|| nr3 ||' - '|| nr4 ||' - '|| nr5) ;
 ordonare_5v2 (nivel, nr1,nr2,nr3,nr4,nr5) ;
END ;
   
