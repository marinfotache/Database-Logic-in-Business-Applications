CREATE TABLE angajati_objtbl OF ANGAJAT;

CREATE TABLE drepturi_tbl (
 Luna INTEGER,
 An INTEGER,
 dreptAcordat DREPTURI
 );

INSERT INTO angajati_objtbl VALUES (
			NEW Angajat(111,'Angajat',' 1',140,100000,120000,0));
INSERT INTO angajati_objtbl VALUES (
			NEW Angajat(112,'Angajat',' 2',18,80000,100000,0.15));

INSERT INTO angajati_objtbl VALUES (
			 NEW AngajatAcord(113,'Angajat_Acord',' 3',18,100000,120000,0,1.2));

INSERT INTO angajati_objtbl VALUES (
			 NEW AngajatAcord(114,'Angajat_Acord',' 4',18,80000,100000,0.1,0.8));
 
-- drepturi pentru angajatul 111
INSERT INTO drepturi_tbl (SELECT 03,2003,NEW Lucrate(REF(A),'ore lucrate',100)
                         			        FROM angajati_objtbl A WHERE A.marca=111);
INSERT INTO drepturi_tbl (SELECT 03,2003,NEW SporVechime(REF(A),'sp vech',160)
                     				        FROM angajati_objtbl A WHERE A.marca=111);

-- drepturi pentru angajatul 112
INSERT INTO drepturi_tbl (SELECT 03,2003,NEW CM(REF(A),'c. med',3,7,10,0.85)
                         			        FROM angajati_objtbl A WHERE A.marca=112);

-- drepturi pentru angajatul 113
INSERT INTO drepturi_tbl (SELECT 03,2003,NEW Lucrate(REF(A),'ore lucrate',100)
                      				       FROM angajati_objtbl A WHERE A.marca=113);
INSERT INTO drepturi_tbl (SELECT 03,2003,NEW SporNoapte(REF(A),'sp noapte',0.1,80)
                     				       FROM angajati_objtbl A WHERE A.marca=113);
INSERT INTO drepturi_tbl (SELECT 03,2003,NEW CO(REF(A),'zile CO',8)
                            			 FROM angajati_objtbl A WHERE A.marca=113);
