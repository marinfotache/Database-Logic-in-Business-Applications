DECLARE
	obj_ang1 Angajat;
BEGIN
	obj_ang1:= NEW Angajat(111,'Asaftei','M.',160,0,0,100000);
--	DBMS_OUTPUT.PUT_LINE(obj_ang1.Nume||' ' || obj_ang1.Prenume || 
--					   ' are sal:'  		-- ||obj_ang1.calculSalariu());
	INSERT INTO temp VALUES (obj_ang1.Nume||' ' || obj_ang1.Prenume || 
		' are sal:' ||obj_ang1.calculSalariu()) ;

	-- modificam starea obiectului:
	obj_ang1.setOre(100,0,60);
--	DBMS_OUTPUT.PUT_LINE(obj_ang1.Nume || ' ' || obj_ang1.Prenume || 
-- 		' are salariul dupa modificare oreCM=60:' || 
-- obj_ang1.calculSalariu());
INSERT INTO temp VALUES (obj_ang1.Nume || ' ' || obj_ang1.Prenume || 
	' are salariul dupa modificare oreCM=60:' || 
		obj_ang1.calculSalariu()) ;	
END;
/
