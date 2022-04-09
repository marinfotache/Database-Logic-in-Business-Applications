DROP TABLE angajati_objtbl CASCADE CONSTRAINTS
/
DROP TABLE angajati_reltbl CASCADE CONSTRAINTS
/
DROP TABLE Sporuri_RefTbl CASCADE CONSTRAINTS
/
DROP TYPE Drepturi FORCE 
/
DROP TYPE Angajat FORCE 
/
CREATE OR REPLACE TYPE Angajat AS OBJECT (
	marca INTEGER,
	nume VARCHAR2(50),
	prenume VARCHAR2(50),
	nrLuniVechime INTEGER,
	salorar NUMBER(16,2),
	salorarCO NUMBER(16,2),    
	procentPenalizare NUMBER(5,2),
	MEMBER FUNCTION getSalOrar RETURN NUMBER,
	MEMBER FUNCTION getSalOrarCO RETURN NUMBER
) NOT FINAL
/

-- suprascriem doar metoda getSalOrar() pentru ca CO nu e in functie de realizare
CREATE OR REPLACE  TYPE AngajatAcord UNDER ANGAJAT (
	procentRealizat NUMBER(5,2),
	OVERRIDING MEMBER FUNCTION getSalOrar RETURN NUMBER
	
)
/

CREATE OR REPLACE  TYPE BODY Angajat AS
	MEMBER FUNCTION getSalOrar RETURN NUMBER IS
		BEGIN
		RETURN SELF.salOrar*(1-SELF.procentPenalizare);
	END getSalOrar;

	MEMBER FUNCTION getSalOrarCO RETURN NUMBER IS
		BEGIN
		RETURN SELF.salOrarCO*(1-SELF.procentPenalizare);
	END getSalOrarCO;
END;
/

CREATE OR REPLACE  TYPE BODY AngajatAcord AS
	OVERRIDING MEMBER FUNCTION getSalOrar RETURN NUMBER IS
		BEGIN
		RETURN SELF.salOrar*(1-SELF.procentPenalizare)*SELF.procentRealizat;
	END getSalOrar;
	
END;
/

CREATE OR REPLACE TYPE DREPTURI AS OBJECT (
	ref_Angajat REF ANGAJAT,
	eticheta VARCHAR2(20),
	NOT INSTANTIABLE MEMBER FUNCTION getSuma RETURN NUMBER
) NOT INSTANTIABLE NOT FINAL 
/

CREATE OR REPLACE TYPE SporVechime UNDER DREPTURI (
	nrore NUMBER(5,2),
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER
	)
/

CREATE OR REPLACE TYPE SporNoapte UNDER DREPTURI (
	procent NUMBER(5,2),
	nrore NUMBER(5,2),
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER
	)
/

CREATE OR REPLACE TYPE Lucrate UNDER DREPTURI (
	nrore NUMBER(5,2),
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER
	)
/

CREATE OR REPLACE TYPE CO UNDER DREPTURI (
	nrZile NUMBER(5,2),
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER
	)
/

CREATE OR REPLACE TYPE CM UNDER DREPTURI (
	nrZileNeplatite INTEGER,
	nrZilePlatiteCAS INTEGER,
	nrZilePlatiteFirma INTEGER,
	procentSal NUMBER(5,2),
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER,
	MEMBER FUNCTION getSumaCAS RETURN NUMBER,
	MEMBER FUNCTION getSumaFirma RETURN NUMBER
	)
/

CREATE OR REPLACE TYPE PrimaPaste UNDER DREPTURI(
	suma NUMBER(16,2),
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER
)
/

 CREATE OR REPLACE TYPE BODY SporVechime AS
 	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER IS
   		obj_angajat ANGAJAT;
   		procent_ Transe_sv.Procent_sv%TYPE;
 BEGIN
  	 UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
  	 SELECT procent_sv INTO procent_ FROM transe_sv
   		 WHERE (obj_angajat.nrLuniVechime/12) BETWEEN ani_limita_inf AND ani_limita_sup;
   	RETURN obj_angajat.getSalOrar() * SELF.nrore*procent_;
 EXCEPTION
  	 WHEN NO_DATA_FOUND THEN RETURN 0;
  	 WHEN OTHERS THEN RETURN -1;
 END getSuma;
 END;
/

CREATE OR REPLACE TYPE BODY SporNoapte AS
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER IS
		obj_angajat ANGAJAT;
	BEGIN
		UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
		RETURN obj_angajat.getSalOrar()*SELF.nrore*SELF.procent;
	EXCEPTION 
		WHEN OTHERS THEN RETURN -1;
	END getSuma;
END;
/

CREATE OR REPLACE TYPE BODY Lucrate AS
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER IS
		obj_angajat ANGAJAT;
	BEGIN
		UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
		RETURN obj_angajat.getSalOrar()*SELF.nrore;
	EXCEPTION 
		WHEN OTHERS THEN RETURN -1;
	END getSuma;
END;
/

CREATE OR REPLACE TYPE BODY co AS
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER IS
		obj_angajat ANGAJAT;
	BEGIN
		UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
-- consideram ziua de CO de 8 ore
		RETURN obj_angajat.getSalOrarCO()*8*SELF.nrZile;
	EXCEPTION 
		WHEN OTHERS THEN RETURN -1;
	END getSuma;
END;
/

CREATE OR REPLACE TYPE BODY co AS
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER IS
		obj_angajat ANGAJAT;
	BEGIN
		UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
		RETURN obj_angajat.getSalOrarCO()*SELF.nrZile;
	EXCEPTION 
		WHEN OTHERS THEN RETURN -1;
	END getSuma;
END;
/

CREATE OR REPLACE TYPE BODY PrimaPaste AS
	OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER IS
	BEGIN
		RETURN SELF.suma;
	END getSuma;
END;
/

CREATE OR REPLACE TYPE BODY CM AS
MEMBER FUNCTION getSumaCAS RETURN NUMBER IS
		obj_angajat ANGAJAT;
	BEGIN
		UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
	-- consideram ziua de CM de  8 ore
		RETURN obj_angajat.getSalOrar()*8*SELF.procentSal*SELF.nrZilePlatiteCAS;
	EXCEPTION 
		WHEN OTHERS THEN RETURN -1;
	END getSumaCAS;
MEMBER FUNCTION getSumaFirma RETURN NUMBER IS
		obj_angajat ANGAJAT;
	BEGIN
		UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
		RETURN obj_angajat.getSalOrar()*8*SELF.procentSal*SELF.nrZilePlatiteFirma;
	EXCEPTION 
		WHEN OTHERS THEN RETURN -1;
	END getSumaFirma;				

		
OVERRIDING MEMBER FUNCTION getSuma RETURN NUMBER IS
		obj_angajat ANGAJAT;
	BEGIN
		UTL_REF.SELECT_OBJECT(SELF.ref_angajat,obj_angajat);
		RETURN SELF.getSumaCAS()+SELF.getSumaFirma();
	EXCEPTION 
		WHEN OTHERS THEN RETURN -1;
	END getSuma;
END;
/
