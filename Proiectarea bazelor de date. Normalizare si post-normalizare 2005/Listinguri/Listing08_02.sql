DROP SEQUENCE seq_idcompetente ;
CREATE SEQUENCE seq_idcompetente START WITH 100000 MINVALUE 100000 MAXVALUE 999999999999999
 NOCACHE NOCYCLE ORDER ;

DELETE FROM  competente_personal ;
ALTER TABLE compartimente DISABLE CONSTRAINT fk_compart_pers ;
DELETE FROM personal9 ;
DELETE FROM compartimente ;
ALTER TABLE compartimente ENABLE CONSTRAINT fk_compart_pers ;
DELETE FROM competente_posturi ;
DELETE FROM posturi ;
DELETE FROM competente_elementare ;
DELETE FROM competente ;

INSERT INTO competente VALUES (100000, 'Competenta RADACINA', NULL, NULL, NULL);

-- competente tehnico-profesionale
INSERT INTO competente VALUES (100001, 'tehnico-profesionale', NULL, NULL, 100000);
INSERT INTO competente VALUES (100002, 'marketing', 'puncte', 'superior', 100001);
INSERT INTO competente VALUES (100003, 'contabile', 'puncte', 'test scris', 100001);
INSERT INTO competente VALUES (100004, 'contab. financiara', 'puncte', 'test scris', 100003);
INSERT INTO competente VALUES (100005, 'contab. manageriala', 'puncte', 'test scris', 100003);

-- competente IT
INSERT INTO competente VALUES (100006, 'IT', NULL, NULL, 100000);
INSERT INTO competente VALUES (100007, 'ECDL', 'nr.module', 'test national', 100006);
INSERT INTO competente VALUES (100008, 'software', NULL, NULL, 100006);
INSERT INTO competente VALUES (100009, 'programare', NULL, NULL, 100008); 
INSERT INTO competente VALUES (100010, 'BASIC', 'puncte', NULL, 100009);  
INSERT INTO competente VALUES (100011, 'Visual BASIC 6', 'puncte', 'test scris', 100010);   
INSERT INTO competente VALUES (100012, 'VB.NET', 'puncte', 'test scris', 100010);    
INSERT INTO competente VALUES (100013, 'C', 'puncte', NULL, 100009);   
INSERT INTO competente VALUES (100014, 'C++', 'puncte', 'test scris', 100013);    
INSERT INTO competente VALUES (100015, 'C#', 'puncte', 'test scris', 100013);     
INSERT INTO competente VALUES (100016, 'Java', 'puncte', 'test scris', 100009);    
INSERT INTO competente VALUES (100017, 'baze de date', NULL, NULL, 100008); 
INSERT INTO competente VALUES (100018, 'SQL', 'puncte', 'test scris', 100017); 
INSERT INTO competente VALUES (100019, 'Oracle', 'puncte', 'test scris', 100017); 
INSERT INTO competente VALUES (100020, 'PL/SQL', 'puncte', 'test scris', 100019); 
INSERT INTO competente VALUES (100021, 'administrare', 'puncte', 'test Oracle', 100019); 
INSERT INTO competente VALUES (100022, 'developer', 'puncte', 'test scris', 100019);  
INSERT INTO competente VALUES (100023, 'SGBD open source', 'puncte', 'test scris', 100017); 
INSERT INTO competente VALUES (100024, 'analiza-proiectare', 'puncte', 'test scris', 100006);
INSERT INTO competente VALUES (100025, 'hardware', 'puncte', 'test scris', 100006);
 
-- competente comportamentale
INSERT INTO competente VALUES (100026, 'comportamentale', NULL, NULL, 100000);
INSERT INTO competente VALUES (100027, 'rabdare', 'puncte', 'superior', 100026); 
INSERT INTO competente VALUES (100028, 'tenacitate', 'puncte', 'superior', 100026);  
INSERT INTO competente VALUES (100029, 'lucru in echipa', 'puncte', 'superior', 100026);   
INSERT INTO competente VALUES (100030, 'comunicare', 'puncte', 'superior', 100026);   
 
-- competente manageriale
INSERT INTO competente VALUES (100031, 'manageriale', NULL, NULL, 100000);
INSERT INTO competente VALUES (100032, 'antrenare-motivare', 'puncte', 'superior', 100031);
INSERT INTO competente VALUES (100033, 'aplanarea conflictelor', 'puncte', 'superior', 100031);
INSERT INTO competente VALUES (100034, 'organizarea echipei', 'puncte', 'superior', 100031);
INSERT INTO competente VALUES (100035, 'managementul proiectelor', 'puncte', 'test scris', 100031);

/*

INSERT INTO competente_elementare VALUES (100002);
INSERT INTO competente_elementare VALUES (100004);
INSERT INTO competente_elementare VALUES (100034);
INSERT INTO competente_elementare VALUES (100006);
INSERT INTO competente_elementare VALUES (100010);   
INSERT INTO competente_elementare VALUES (100011);    
INSERT INTO competente_elementare VALUES (100013);    
INSERT INTO competente_elementare VALUES (100014);     
INSERT INTO competente_elementare VALUES (100015);    
INSERT INTO competente_elementare VALUES (100017); 
INSERT INTO competente_elementare VALUES (100018); 
INSERT INTO competente_elementare VALUES (100019); 
INSERT INTO competente_elementare VALUES (100020);  
INSERT INTO competente_elementare VALUES (100021); 
INSERT INTO competente_elementare VALUES (100022);
INSERT INTO competente_elementare VALUES (100025); 
INSERT INTO competente_elementare VALUES (100026);  
INSERT INTO competente_elementare VALUES (100027);   
INSERT INTO competente_elementare VALUES (100028);   
INSERT INTO competente_elementare VALUES (100030);
INSERT INTO competente_elementare VALUES (100031);
INSERT INTO competente_elementare VALUES (100032);
INSERT INTO competente_elementare VALUES (100033);

*/
--
INSERT INTO posturi VALUES (1001, 'Contabil 1', 7800000);
INSERT INTO posturi VALUES (1002, 'Contabil 2', 7900000);
INSERT INTO posturi VALUES (1021, 'Dezvoltator aplicatii - 1', 10900000);
INSERT INTO posturi VALUES (1022, 'Dezvoltator aplicatii - 2', 12900000);
INSERT INTO posturi VALUES (1023, 'Administrator aplicatii', 14900000);


-- competente_posturi 

-- contabil 1
INSERT INTO competente_posturi VALUES (1001, 100004, 8);
INSERT INTO competente_posturi VALUES (1001, 100005, 5);
INSERT INTO competente_posturi VALUES (1001, 100027, 8);
INSERT INTO competente_posturi VALUES (1001, 100028, 9);

-- contabil 2
INSERT INTO competente_posturi VALUES (1002, 100004, 6);
INSERT INTO competente_posturi VALUES (1002, 100005, 9);
INSERT INTO competente_posturi VALUES (1002, 100027, 9);
INSERT INTO competente_posturi VALUES (1002, 100028, 9);

-- dezvoltator aplicatii - 1
INSERT INTO competente_posturi VALUES (1021, 100012, 9);
INSERT INTO competente_posturi VALUES (1021, 100018, 8);
INSERT INTO competente_posturi VALUES (1021, 100020, 8);
INSERT INTO competente_posturi VALUES (1021, 100029, 7);

-- dezvoltator aplicatii - 2
INSERT INTO competente_posturi VALUES (1022, 100018, 7);
INSERT INTO competente_posturi VALUES (1022, 100020, 9);
INSERT INTO competente_posturi VALUES (1022, 100016, 9);
INSERT INTO competente_posturi VALUES (1022, 100029, 8);

-- administrator aplicatii
INSERT INTO competente_posturi VALUES (1023, 100018, 9);
INSERT INTO competente_posturi VALUES (1023, 100021, 8);
INSERT INTO competente_posturi VALUES (1023, 100024, 9);
INSERT INTO competente_posturi VALUES (1023, 100029, 8);
INSERT INTO competente_posturi VALUES (1023, 100030, 9);
INSERT INTO competente_posturi VALUES (1023, 100035, 7);


-- compartimente 
INSERT INTO compartimente VALUES ('financiar', null);
INSERT INTO compartimente VALUES ('contabilitate', null);
INSERT INTO compartimente VALUES ('productie', null); 
INSERT INTO compartimente VALUES ('marketing', null);
INSERT INTO compartimente VALUES ('IT', null);
INSERT INTO compartimente VALUES ('personal-salarizare', null); 
 

-- personal

-- directorul general 
INSERT INTO personal9 VALUES (20001, 'Vasilescu Georgeta', DATE'1989-11-11', NULL, NULL); 

-- la marketing
INSERT INTO personal9 VALUES (20007, 'Strat Costel', DATE'1992-07-01', 'marketing', NULL); 
UPDATE compartimente SET marcasef=20007 WHERE compartiment='marketing' ;

-- la contabilitate
INSERT INTO personal9 VALUES (20002, 'Mihuleac Iulian', DATE'1996-10-21', 'contabilitate', 1001); 
INSERT INTO personal9 VALUES (20003, 'Irimia Magdalena', DATE'1999-02-21', 'contabilitate', 1002); 
INSERT INTO personal9 VALUES (20004, 'Baboi Cosmina', DATE'2001-12-01', 'contabilitate', 1002); 
INSERT INTO personal9 VALUES (20005, 'Ailenei Jenica', DATE'1987-04-01', 'contabilitate', 1001); 
INSERT INTO personal9 VALUES (20006, 'Cosmovici Ionel', DATE'1988-11-01', 'contabilitate', 1001); 
UPDATE compartimente SET marcasef=20002 WHERE compartiment='contabilitate' ;

-- la IT
INSERT INTO personal9 VALUES (20008, 'Stroe Ionut', DATE'1998-12-01', 'IT', 1021); 
INSERT INTO personal9 VALUES (20009, 'Babias Vasile', DATE'1986-10-01', 'IT', 1021); 
INSERT INTO personal9 VALUES (20010, 'Lemnaru Mihai', DATE'1983-11-25', 'IT', 1021); 
INSERT INTO personal9 VALUES (20011, 'Butuca Geirge', DATE'2003-05-14', 'IT', 1022); 
INSERT INTO personal9 VALUES (20012, 'Slavici Minodora', DATE'2002-12-01', 'IT', 1022); 
INSERT INTO personal9 VALUES (20013, 'Dediu Cristina', DATE'1990-03-01', 'IT', 1022); 
INSERT INTO personal9 VALUES (20014, 'Slabu Florin', DATE'1989-01-15', 'IT', 1022); 
INSERT INTO personal9 VALUES (20015, 'Fodor Iuliana', DATE'1994-01-20', 'IT', 1023); 
UPDATE compartimente SET marcasef=20008 WHERE compartiment='IT' ;


/*
------------------------------------------------------
CREATE TABLE competente_personal (
 marca NUMBER (6) CONSTRAINT fk_comppers_pers REFERENCES personal9(marca),
 idcompfrunza NUMBER (10) CONSTRAINT fk_comppers_compelem 
   REFERENCES competente_elementare(idcompfrunza),
 nivel NUMBER(5) CONSTRAINT nn_nivel NOT NULL,   
 CONSTRAINT pk_comp_pers PRIMARY KEY (marca, idcompfrunza)
 ) ;
*/

COMMIT ; 
