CREATE OR REPLACE FUNCTION f_este_frunza (simbol_cont VARCHAR2)
	RETURN BOOLEAN
AS
	v_frunza CHAR(1)  ;
BEGIN
	SELECT EsteFrunza INTO v_frunza FROM plan_conturi
	 WHERE SimbolCont = simbol_cont ;
 IF v_frunza = 'D' THEN
   RETURN TRUE ;
 ELSE
   RETURN FALSE ;
 END IF ;    
END ;

