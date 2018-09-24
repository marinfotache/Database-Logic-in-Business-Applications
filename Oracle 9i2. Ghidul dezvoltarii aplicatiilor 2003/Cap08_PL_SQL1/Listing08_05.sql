-- populare cu inregistrari pentru o luna (dintr-un an) a tabelei PONTAJE
DECLARE
	an salarii.an%TYPE := 2003;
 luna salarii.luna%TYPE := 1 ;
 prima_zi DATE ; -- variabila care stocheaza data de 1 a lunii
 zi DATE ; -- variabila folosita la ciclare
BEGIN 
 prima_zi := TO_DATE('01/'||luna||'/'||an, 'DD/MM/YYYY') ; 
-- DELETE FROM pontaje WHERE data BETWEEN prima_zi AND LAST_DAY(prima_zi) ;
 zi := prima_zi ;

 /* bucla se repeta pentru fiecare zi a lunii */
 WHILE zi <= LAST_DAY(prima_zi) LOOP 
  IF RTRIM(TO_CHAR(zi,'DAY')) IN ('SATURDAY', 'SUNDAY') THEN
   -- e zi nelucratoare (simbata sau duminica)
   NULL ;
  ELSE  
   INSERT INTO pontaje (marca, data) 
    SELECT marca, zi
    FROM personal ;
  END IF ;
  -- se trece la ziua urmatoare
  zi := zi + 1 ;  
 END LOOP ;

 COMMIT ;
END ;
/ 
