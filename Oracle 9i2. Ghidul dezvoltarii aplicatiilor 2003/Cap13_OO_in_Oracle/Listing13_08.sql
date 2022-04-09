ALTER TYPE Lucrate  ADD 
	CONSTRUCTOR FUNCTION Lucrate(pNrOre INTEGER, pMarca INTEGER) 
		RETURN SELF AS RESULT
		CASCADE INCLUDING TABLE DATA;


CREATE OR REPLACE TYPE BODY Lucrate AS
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER 
	IS
		obj_angajat ANGAJAT ;
	BEGIN
		UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
		RETURN obj_angajat.getSalOrar()*SELF.nrore;
	EXCEPTION 
		WHEN OTHERS THEN RETURN -1;
	END getSuma;

CONSTRUCTOR FUNCTION Lucrate(pNrOre INTEGER, pMarca INTEGER) 
	RETURN SELF AS RESULT
IS
	V_ref REF ANGAJAT;
BEGIN
	-- extragem referinta necesara pentru atributul ref_angajat
	SELECT REF(A) INTO v_ref FROM Angajati_ObjTbl A WHERE A.marca = pMarca;
	SELF.eticheta:= 'Ore lucrate';
	SELF.nrOre := pNrOre;
	SELF.ref_Angajat := v_ref;
	RETURN;
END Lucrate;
END;
/
