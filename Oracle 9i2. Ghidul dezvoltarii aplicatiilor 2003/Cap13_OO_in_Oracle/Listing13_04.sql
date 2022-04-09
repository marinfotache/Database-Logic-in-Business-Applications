CREATE TABLE Angajati_ObjTbl OF ANGAJAT;
		-- sau 
CREATE TABLE Angajati_RelTbl (id Integer, pers ANGAJAT);

-- adaugam date in tabela obiectuala ca in orice alta tabela relationala:
INSERT INTO Angajati_ObjTbl VALUES (111,'Asaftei','V.', 0,0,0,200000);

--sau prin crearea in mod explicit a unui obiect nou:
INSERT INTO Angajati_ObjTbl VALUES (NEW Angajat (112,'Mandache','M.',0,0,0,150000));

-- inserare date in tabela relational-obiectula:
INSERT INTO  Angajati_RelTbl VALUES (1,new Angajat(111,'Asaftei','V.', 	0,0,0,200000)) ;
INSERT INTO  Angajati_RelTbl VALUES (2, new Angajat (112,'Mandache','M.',0,0,0,150000));

