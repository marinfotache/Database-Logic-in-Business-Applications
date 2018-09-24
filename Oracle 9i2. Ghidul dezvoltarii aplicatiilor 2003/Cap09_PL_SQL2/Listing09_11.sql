-- Procedura pentru popularea tabelei PONTAJE pe un an intreg
CREATE OR REPLACE PROCEDURE p_populare_pontaje_an 
( anul salarii.an%TYPE DEFAULT 2003)
IS
BEGIN 
FOR i IN 1..12 LOOP 
DBMS_OUTPUT.PUT_LINE ('Urmeaza luna '|| i) ;
p_populare_pontaje_luna (anul, i) ;
END LOOP ;
END p_populare_pontaje_an ;

