-- populare cu inregistrari pentru o luna (dintr-un an) a tabelei PONTAJE
DECLARE
	an salarii.an%TYPE := 2003;
 luna salarii.luna%TYPE := 1 ;
 prima_zi DATE ; -- variabila care stocheaza data de 1 a lunii
 ultima_zi DATE ;
 zi DATE ; -- variabila folosita la ciclare
 numar_ultima_zi PLS_INTEGER ;
 
BEGIN 
 prima_zi := TO_DATE('01/'||luna||'/'||an, 'DD/MM/YYYY') ; 
 ultima_zi := LAST_DAY(prima_zi) ;
 numar_ultima_zi = TO_NUMBER(TO_CHAR(ultima_zi, 'DD'))
 /* acum bucla se repeta pentu i de la 1 la 31 (30, 28 sau 29) */
 FOR i IN 1..numar_ultima_zi LOOP
  zi := prima_zi + i - 1 ;
  IF RTRIM(TO_CHAR(zi,'DAY')) IN ('SATURDAY', 'SUNDAY') THEN
   -- e zi nelucratoare (simbata sau duminica)
   NULL ;
  ELSE  
   INSERT INTO pontaje (marca, data) 
    SELECT marca, zi
    FROM personal ;
  END IF ;
  -- se trece (automat) la ziua urmatoare
 END LOOP ;

 COMMIT ;
END ;
/ 
