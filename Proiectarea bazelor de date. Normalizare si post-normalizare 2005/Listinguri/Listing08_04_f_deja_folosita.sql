CREATE OR REPLACE FUNCTION f_deja_folosita (
 id_competenta NUMBER) RETURN BOOLEAN
AS
v_unu NUMBER(1)  ;
BEGIN
SELECT 1 INTO v_unu FROM dual WHERE EXISTS
	(SELECT 1 FROM competente_posturi	 WHERE IdCompFrunza = id_competenta
  UNION 
  SELECT 1 FROM competente_personal WHERE IdCompFrunza = id_competenta
   );
RETURN TRUE ;
EXCEPTION 
WHEN NO_DATA_FOUND THEN
	RETURN FALSE ;
END ;

