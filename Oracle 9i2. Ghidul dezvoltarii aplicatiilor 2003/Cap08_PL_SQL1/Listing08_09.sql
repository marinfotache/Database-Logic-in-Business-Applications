/* Bloc anonim pentru rezolvarea ecuatiei de gradul II - varianta ce foloseste EXCEPTII */
DECLARE
	a INTEGER := 5 ;
	b INTEGER :=  3456 ;
	c INTEGER := 23 ;
	delta NUMBER(16,2) ;
	x1 NUMBER(16,6) ;
	x2 NUMBER(16,6) ;
BEGIN
 		delta := b**2 - 4*a*c ;
		 IF delta > 0 THEN 
			   x1 := (-b - SQRT(delta)) / (2 * a) ;
		   	x2 := (-b + SQRT(delta)) / (2 * a) ;
  			 DBMS_OUTPUT.PUT_LINE('x1='||x1||',   x2='||x2) ;					
		ELSE
   			IF delta = 0 THEN 
			     	x1 := -b / (2 * a) ;		
         /* acesta este locul in care, daca a=0, se
            declanseaza exceptia ZERO_DIVIDE */
     				DBMS_OUTPUT.PUT_LINE('x1 = x2 = '||x1) ;					-- se executa numai daca a<>0
   			ELSE
			     	DBMS_OUTPUT.PUT_LINE('Radacinile sunt complexe !!!') ;									
   			END IF ;
		END IF;
EXCEPTION  -- sectiunea de exceptii a blocului principal; se stie ca a=0
 WHEN ZERO_DIVIDE THEN
  BEGIN -- aici incepe blocul secundar
			x1 := -c / b ;   -- daca si b=0, se declaseaza (din nou) exceptia ZERO_DIVIDE
			DBMS_OUTPUT.PUT_LINE('Ecuatia este de gradul I') ;		-- se executa numai daca		b <> 0
			DBMS_OUTPUT.PUT_LINE('x='||x1) ;					
  EXCEPTION -- sectiunea de exceptii a blocului secundar; se stie ca a=0 si b=0
   WHEN ZERO_DIVIDE THEN
			IF c=0 THEN 
				DBMS_OUTPUT.PUT_LINE('Nedeterminare !') ;		
			ELSE
				DBMS_OUTPUT.PUT_LINE('Imposibil !!!') ;		
			END IF ;
 END;
END ;
/
