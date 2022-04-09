DECLARE
	obj_ang1 Angajat;
	obj_ang2 Angajat;
BEGIN
	obj_ang1 := new Angajat(111,'Asaftei','M.',160,0,0,100000);
	obj_ang2 := new Angajat(111,'Gologan','P.',0,0,0,150000);
	INSERT INTO TEMP VALUES ('Pasul 1: doua obiecte diferite: doua 		variabile'); 
	INSERT INTO TEMP VALUES (obj_ang1.Nume||' '|| obj_ang1.Prenume || 
	     	' are sal:'||obj_ang1.calculSalariu());
	INSERT INTO TEMP VALUES (obj_ang2.Nume||' '|| obj_ang2.Prenume ||
		 ' are sal:'||obj_ang2.calculSalariu());

	-- transfer de OBIECT : se creaza automat unul NOU identic !!!!!! :
	obj_ang1 := obj_ang2 ;
	INSERT INTO TEMP VALUES ('Pasul 2 dupa atribuire: doua obiecte 		identice : doua variabile'); 
	INSERT INTO TEMP VALUES (obj_ang1.Nume||' '|| obj_ang1.Prenume || 
		' are sal:'||obj_ang1.calculSalariu());
	INSERT INTO TEMP VALUES (obj_ang2.Nume||' '|| obj_ang2.Prenume || ' 
		are sal:'||obj_ang2.calculSalariu());

	-- se modifica doar obiectul 2 :
	obj_ang2.OreLucrate :=200;
	INSERT INTO TEMP VALUES ('Pasul 3: modificam unul din obiecte 		(orelucrate =200) : 
		celelalt ramane neschimbat'); 
	INSERT INTO TEMP VALUES (obj_ang1.Nume||' '|| obj_ang1.Prenume || 
		' are sal:'||obj_ang1.calculSalariu());
	INSERT INTO TEMP VALUES (obj_ang2.Nume||' '|| obj_ang2.Prenume || 
		' are sal:'||obj_ang2.calculSalariu());
END;
/
