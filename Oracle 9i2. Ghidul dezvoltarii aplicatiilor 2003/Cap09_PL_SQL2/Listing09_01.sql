/* Prima procedura - Rezolvarea ecuatiei de gradul II */
CREATE OR REPLACE PROCEDURE p_ec2 (
 a IN INTEGER, b IN INTEGER, c IN INTEGER ) 
AS
	delta NUMBER(16,2) ;
	x1 NUMBER(16,6) ;
	x2 NUMBER(16,6) ;
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
