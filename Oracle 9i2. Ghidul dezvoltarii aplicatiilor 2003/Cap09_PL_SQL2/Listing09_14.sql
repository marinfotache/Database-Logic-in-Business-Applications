/* Prima functie - Ecuatia de gradul II se intoarce */
CREATE OR REPLACE FUNCTION f_ec2 (
 a IN INTEGER, b IN INTEGER, c IN INTEGER ) RETURN VARCHAR2
AS
	delta NUMBER(16,2) ;
	x1 NUMBER(16,6) ;
	x2 NUMBER(16,6) ;
 sir VARCHAR2(100) := '' ;
BEGIN
	-- ecuatia este de grad II ?
	IF a = 0 THEN 
		IF b = 0 THEN 
			IF c=0 THEN 
				sir := 'Nedeterminare !' ;		
			ELSE
				sir := 'Imposibil !!!' ;		
			END IF ;
		ELSE
			sir := 'Ecuatia este de gradul I' ;					
			x1 := -c / b ;
			sir := sir || ', x='||x1 ;					
		END IF ;
	ELSE
		delta := b**2 - 4*a*c ;
		IF delta > 0 THEN 
			x1 := (-b - SQRT(delta)) / (2 * a) ;
			x2 := (-b + SQRT(delta)) / (2 * a) ;
			sir := 'x1='|| x1 ||', x2='||x2 ;					
		ELSE
			IF delta = 0 THEN 
				x1 := -b / (2 * a) ;		
				sir := 'x1 = x2 = '||x1 ;					
			ELSE
				sir := 'Radacinile sunt complexe !!!' ;									
			END IF ;
		END IF;
	END IF ;
 RETURN sir ;
END;
/
