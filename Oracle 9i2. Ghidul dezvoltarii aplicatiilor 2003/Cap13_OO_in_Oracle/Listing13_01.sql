CREATE TYPE Angajat as OBJECT(
	Marca INTEGER,
	Nume VARCHAR2(30),
	Prenume VARCHAR2(30),
	OreLucrate INTEGER,
	OreCO INTEGER,
	OreCM INTEGER,
	SalOrar NUMBER(16,2),
MEMBER FUNCTION CalculSalariu RETURN NUMBER,
MEMBER PROCEDURE SetOre(p_OreLucr INTEGER, p_OreCO INTEGER, p_OreCm INTEGER)
) ;
/


CREATE OR REPLACE TYPE BODY Angajat AS
	MEMBER FUNCTION CalculSalariu RETURN NUMBER IS
	BEGIN
	RETURN (SELF.OreLucrate+SELF.OreCo + SELF.OreCM*0.85)*SELF.SalOrar;
	END CalculSalariu;
	MEMBER PROCEDURE SetOre(p_OreLucr INTEGER, 
			p_OreCO INTEGER, p_OreCm INTEGER)
	IS
BEGIN
    SELF.OreLucrate:=p_Orelucr;
    SELF.OreCO:=p_OreCO;
    SELF.OreCM:=p_OreCM;
 END SetOre;
 END;
/
