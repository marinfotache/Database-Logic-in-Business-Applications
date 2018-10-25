CREATE OR REPLACE FUNCTION f_apare (
 simbol_cont plan_conturi.SimbolCont%TYPE)
	RETURN BOOLEAN
AS
	v_unu NUMBER(1)  ;
BEGIN
	SELECT 1 INTO v_unu FROM dual WHERE EXISTS (
   SELECT 1 FROM detalii_operatiuni
	  WHERE ContDebitor=simbol_cont OR ContCreditor=simbol_cont);
	RETURN TRUE ;
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
		RETURN FALSE ;
END ;

