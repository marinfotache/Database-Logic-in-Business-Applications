/* Functie care intoarce salariul orar al unui angajat
 pe baza marcii */
CREATE OR REPLACE FUNCTION f_afla_salorar (
 marca_ personal.marca%TYPE ) RETURN personal.salorar%TYPE
AS
	v_salorar personal.salorar%TYPE ;
BEGIN
 -- folosim un bloc inclus pentru a returna 0 cind marca este eronata
	BEGIN
		SELECT salorar INTO v_salorar FROM personal WHERE marca = marca_ ;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN -- marca indicata nu exista in PERSONAL
		v_salorar := 0 ;
	END ;
	RETURN v_salorar ;
END;
/
