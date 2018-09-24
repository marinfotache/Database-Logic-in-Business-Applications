-- populare cu înregistrari pentru o luna (dintr-un an) a tabelei PONTAJE
-- cu un bloc inclus si folosirea exceptiilor
DECLARE
	an salarii.an%TYPE := 2003;
 	luna salarii.luna%TYPE :=4 ;
prima_zi DATE ; -- variabila care stocheaza data de 1 a lunii
zi DATE ; -- variabila folosita la ciclare
BEGIN 
prima_zi := TO_DATE('01/'||luna||'/'||an, 'DD/MM/YYYY') ; 
zi := prima_zi ;

/* bucla se repeta pentru fiecare zi a lunii */
WHILE zi <= LAST_DAY(prima_zi) LOOP 
IF RTRIM(TO_CHAR(zi,'DAY')) IN ('SATURDAY', 'SUNDAY') THEN
-- e zi nelucratoare (sâmbata sau duminica)
NULL ;
ELSE  
BEGIN    -- de aici începe blocul inclus
INSERT INTO pontaje (marca, data) 
SELECT marca, zi FROM personal ;
EXCEPTION   -- se preia eventuala violare a cheii primare
WHEN DUP_VAL_ON_INDEX THEN
-- se sterg mai întâi înregistrarile pentru ziua curenta
DELETE FROM pontaje WHERE data = zi ;     
-- apoi se reinsereaza înregistrarile
INSERT INTO pontaje (marca, data) 
       SELECT marca, zi FROM personal ;
END ;   -- aici se termina blocul inclus    
END IF ;
-- se trece la ziua urmatoare
zi := zi + 1 ;  
END LOOP ;
COMMIT ;
END ;

