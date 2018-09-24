/* Bloc anonm pentru rezolvarea ecuatiei de gradul II
Pentru cei cu anumita distanta fata de perioada copilariei, 
 reamintim ca formatul general este
   ax**2 + b*x + c = 0
Sa se determine x1 si x2. */
DECLARE
	a INTEGER := 0 ;
	b INTEGER := 5667 ;
	c INTEGER := 12 ;
	delta NUMBER(16,2) ;
	X1 NUMBER(16,6) ;
	X2 NUMBER(16,6) ;
BEGIN
	-- ecuatia este de grad II ?
	IF a = 0 THEN 

		IF b = 0 THEN 
			IF c=0 THEN 
				DBMS_OUTPUT.PUT_LINE('Nedeterminare !') ;		
			ELSE
				DBMS_OUTPUT.PUT_LINE('Imposibil !!!') ;		
			END IF ;
		ELSE
			DBMS_OUTPUT.PUT_LINE('Ecuatia este de gradul I') ;					
			x1 := -c / b ;
			DBMS_OUTPUT.PUT_LINE('x='||x1) ;					
		END IF ;
	ELSE
		delta := b**2 - 4*a*c ;
		IF delta > 0 THEN 
			x1 := (-b - SQRT(delta)) / (2 * a) ;
			x2 := (-b + SQRT(delta)) / (2 * a) ;
			DBMS_OUTPUT.PUT_LINE('x1='||x1||',   x2='||x2) ;					
		ELSE
			IF delta = 0 THEN 
				x1 := -b / (2 * a) ;		
				DBMS_OUTPUT.PUT_LINE('x1=x2='||x1) ;					
			ELSE
				DBMS_OUTPUT.PUT_LINE('radacinile sunt complexe !!!') ;									
			END IF ;
		END IF;
	END IF ;
END;
/
