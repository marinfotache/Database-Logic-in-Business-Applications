/* Bloc anonm pentru rezolvarea ecuatiei de gradul II - varianta CASE*/
DECLARE
	a INTEGER := 34 ;
	b INTEGER := 345553 ;
	c INTEGER := 231 ;
	X1 NUMBER(16,6) ;
	X2 NUMBER(16,6) ;
BEGIN
 CASE
  WHEN a = 0 AND b = 0 AND c = 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Nedeterminare !') ;		
  WHEN a = 0 AND b = 0 AND c <> 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Imposibil !!!') ;		
  WHEN a = 0 AND b <> 0 THEN 
    DBMS_OUTPUT.PUT_LINE('Ecuatia este de gradul I') ;					
    x1 := -c / b ;
    DBMS_OUTPUT.PUT_LINE('x='||x1) ;					
 WHEN a <> 0 AND b**2 - 4*a*c > 0 THEN 
 			x1 := (-b - SQRT(b**2 - 4*a*c)) / (2 * a) ;
 			x2 := (-b + SQRT(b**2 - 4*a*c)) / (2 * a) ;
 			DBMS_OUTPUT.PUT_LINE('x1='||x1||',   x2='||x2) ;					
 WHEN a <> 0 AND b**2 - 4*a*c = 0 THEN 
 			x1 := -b / (2 * a) ;		
  		DBMS_OUTPUT.PUT_LINE('x1=x2='||x1) ;					
 ELSE
				DBMS_OUTPUT.PUT_LINE('radacinile sunt complexe !!!') ;									
 END CASE;
END ;
/
