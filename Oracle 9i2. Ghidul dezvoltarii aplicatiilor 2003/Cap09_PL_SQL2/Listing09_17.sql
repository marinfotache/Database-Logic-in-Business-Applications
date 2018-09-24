CREATE OR REPLACE PROCEDURE p_populare_pontaje_luna (
  an_ IN  salarii.an%TYPE, luna_ salarii.luna%TYPE )
IS 
  prima_zi DATE ; -- variabila care stocheaza data de 1 a lunii
  zi DATE ; -- variabila folosita la ciclare
BEGIN 
  prima_zi := TO_DATE('01/'||luna_||'/'||an_, 'DD/MM/YYYY') ; 
  zi := prima_zi ;

/* bucla se repeta pentru fiecare zi a lunii */
WHILE zi <= LAST_DAY(prima_zi) LOOP 
  IF TO_CHAR(zi,'DAY') IN ('SAT', 'SUN') THEN
    -- e zi nelucratoare (sâmbata sau duminica)
    NULL ;
  ELSE  
    FOR rec_marci IN (SELECT marca FROM personal) LOOP 
     IF f_este_in_pontaje (rec_marci.marca, zi) THEN
      NULL ; -- pastram inregistrarea existenta
     ELSE 
      INSERT INTO pontaje (marca, data) VALUES (rec_marci.marca, zi) ; 
     END IF ; 
  END LOOP ;  
  END IF ;
  -- se trece la ziua urmatoare
  zi := zi + 1 ;  
END LOOP ;
COMMIT ;
END ;
/


