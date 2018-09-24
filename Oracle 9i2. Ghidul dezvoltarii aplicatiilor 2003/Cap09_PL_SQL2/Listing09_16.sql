/* Functie care întoarce TRUE daca exista pontaje
  pentru marca si ziua curente */
CREATE OR REPLACE FUNCTION f_este_in_pontaje (
 marca_ personal.marca%TYPE, data_ pontaje.data%TYPE ) 
  RETURN BOOLEAN
AS
	v_este BOOLEAN ;
 v_unu INTEGER ;
BEGIN
-- folosim un bloc inclus 
	BEGIN
   SELECT 1 INTO v_unu FROM pontaje WHERE marca=marca_ AND data=data_ ;
   v_este := TRUE ;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN -- nu exista inregistrarea in PONTAJE 
		v_este := FALSE ;
	END ;
	RETURN v_este ;
END;
/

