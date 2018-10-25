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

-- posturi
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
INSERT INTO personal9 VALUES (20011, 'Butuca George', DATE'2003-05-14', 'IT', 1022); 
INSERT INTO personal9 VALUES (20012, 'Slavici Minodora', DATE'2002-12-01', 'IT', 1022); 
INSERT INTO personal9 VALUES (20013, 'Dediu Cristina', DATE'1990-03-01', 'IT', 1022); 
INSERT INTO personal9 VALUES (20014, 'Slabu Florin', DATE'1989-01-15', 'IT', 1022); 
INSERT INTO personal9 VALUES (20015, 'Fodor Iuliana', DATE'1994-01-20', 'IT', 1023); 
UPDATE compartimente SET marcasef=20008 WHERE compartiment='IT' ;


-- COMPETENTE_PERSONAL

-- 20001, 'Vasilescu Georgeta' - directoarea generala
INSERT INTO competente_personal VALUES (20001, 100002, 8) ;
INSERT INTO competente_personal VALUES (20001, 100007, 6) ;
INSERT INTO competente_personal VALUES (20001, 100024, 7) ;
INSERT INTO competente_personal VALUES (20001, 100027, 8) ;
INSERT INTO competente_personal VALUES (20001, 100028, 9) ;
INSERT INTO competente_personal VALUES (20001, 100029, 7) ;

-- 20007, 'Strat Costel', - sef Marketing
INSERT INTO competente_personal VALUES (20007, 100002, 9) ;
INSERT INTO competente_personal VALUES (20007, 100007, 8) ;
INSERT INTO competente_personal VALUES (20007, 100027, 8) ;
INSERT INTO competente_personal VALUES (20007, 100028, 9) ;
INSERT INTO competente_personal VALUES (20007, 100029, 7) ;

-- 20002, 'Mihuleac Iulian', sef  Contabilitate
INSERT INTO competente_personal VALUES (20002, 100002, 5) ;
INSERT INTO competente_personal VALUES (20002, 100004, 9) ;
INSERT INTO competente_personal VALUES (20002, 100005, 8) ;
INSERT INTO competente_personal VALUES (20002, 100007, 9) ;
INSERT INTO competente_personal VALUES (20002, 100024, 9) ;
INSERT INTO competente_personal VALUES (20002, 100027, 6) ;
INSERT INTO competente_personal VALUES (20002, 100028, 9) ;
INSERT INTO competente_personal VALUES (20002, 100029, 9) ;
INSERT INTO competente_personal VALUES (20002, 100030, 6) ;
INSERT INTO competente_personal VALUES (20002, 100032, 7) ;
INSERT INTO competente_personal VALUES (20002, 100033, 5) ;
INSERT INTO competente_personal VALUES (20002, 100034, 6) ;
INSERT INTO competente_personal VALUES (20002, 100035, 7) ;

-- 20003, 'Irimia Magdalena', 'contabilitate'
INSERT INTO competente_personal VALUES (20003, 100002, 9) ;
INSERT INTO competente_personal VALUES (20003, 100004, 8) ;
INSERT INTO competente_personal VALUES (20003, 100005, 7) ;
INSERT INTO competente_personal VALUES (20003, 100007, 6) ;
INSERT INTO competente_personal VALUES (20003, 100024, 5) ;
INSERT INTO competente_personal VALUES (20003, 100027, 4) ;
INSERT INTO competente_personal VALUES (20003, 100028, 7) ;
INSERT INTO competente_personal VALUES (20003, 100029, 9) ;
INSERT INTO competente_personal VALUES (20003, 100030, 8) ;
INSERT INTO competente_personal VALUES (20003, 100032, 6) ;
INSERT INTO competente_personal VALUES (20003, 100034, 8) ;
INSERT INTO competente_personal VALUES (20003, 100035, 5) ;

-- 20004, 'Baboi Cosmina', 'contabilitate'
INSERT INTO competente_personal VALUES (20004, 100004, 9) ;
INSERT INTO competente_personal VALUES (20004, 100005, 10) ;
INSERT INTO competente_personal VALUES (20004, 100007, 9) ;
INSERT INTO competente_personal VALUES (20004, 100024, 8) ;
INSERT INTO competente_personal VALUES (20004, 100027, 9) ;
INSERT INTO competente_personal VALUES (20004, 100028, 9) ;
INSERT INTO competente_personal VALUES (20004, 100029, 10) ;
INSERT INTO competente_personal VALUES (20004, 100030, 7) ;
INSERT INTO competente_personal VALUES (20004, 100032, 9) ;
INSERT INTO competente_personal VALUES (20004, 100033, 7) ;
INSERT INTO competente_personal VALUES (20004, 100034, 8) ;

-- 20005, 'Ailenei Jenica', 'contabilitate'
INSERT INTO competente_personal VALUES (20005, 100004, 5) ;
INSERT INTO competente_personal VALUES (20005, 100005, 4) ;
INSERT INTO competente_personal VALUES (20005, 100007, 6) ;
INSERT INTO competente_personal VALUES (20005, 100024, 5) ;
INSERT INTO competente_personal VALUES (20005, 100027, 5) ;
INSERT INTO competente_personal VALUES (20005, 100029, 3) ;
INSERT INTO competente_personal VALUES (20005, 100030, 9) ;
INSERT INTO competente_personal VALUES (20005, 100033, 8) ;
INSERT INTO competente_personal VALUES (20005, 100034, 5) ;
INSERT INTO competente_personal VALUES (20005, 100035, 4) ;

-- 20006, 'Cosmovici Ionel', 'contabilitate'
INSERT INTO competente_personal VALUES (20006, 100002, 3) ;
INSERT INTO competente_personal VALUES (20006, 100004, 4) ;
INSERT INTO competente_personal VALUES (20006, 100005, 9) ;
INSERT INTO competente_personal VALUES (20006, 100007, 8) ;
INSERT INTO competente_personal VALUES (20006, 100024, 3) ;
INSERT INTO competente_personal VALUES (20006, 100027, 10) ;
INSERT INTO competente_personal VALUES (20006, 100028, 9) ;
INSERT INTO competente_personal VALUES (20006, 100029, 2) ;
INSERT INTO competente_personal VALUES (20006, 100030, 7) ;
INSERT INTO competente_personal VALUES (20006, 100032, 4) ;
INSERT INTO competente_personal VALUES (20006, 100034, 10) ;
INSERT INTO competente_personal VALUES (20006, 100035, 3) ;

-- 20008, 'Stroe Ionut', Sef IT'
INSERT INTO competente_personal VALUES (20008, 100011, 4) ;
INSERT INTO competente_personal VALUES (20008, 100012, 8) ;
INSERT INTO competente_personal VALUES (20008, 100016, 9) ;
INSERT INTO competente_personal VALUES (20008, 100018, 7) ;
INSERT INTO competente_personal VALUES (20008, 100020, 7) ;
INSERT INTO competente_personal VALUES (20008, 100021, 5) ;
INSERT INTO competente_personal VALUES (20008, 100024, 8) ;
INSERT INTO competente_personal VALUES (20008, 100025, 4) ;
INSERT INTO competente_personal VALUES (20008, 100027, 9) ;
INSERT INTO competente_personal VALUES (20008, 100028, 6) ;
INSERT INTO competente_personal VALUES (20008, 100029, 10) ;
INSERT INTO competente_personal VALUES (20008, 100030, 9) ;
INSERT INTO competente_personal VALUES (20008, 100032, 5) ;
INSERT INTO competente_personal VALUES (20008, 100033, 10) ;
INSERT INTO competente_personal VALUES (20008, 100034, 8) ;
INSERT INTO competente_personal VALUES (20008, 100035, 10) ;

-- 20009, 'Babias Vasile', 'IT'
INSERT INTO competente_personal VALUES (20009, 100015, 8) ;
INSERT INTO competente_personal VALUES (20009, 100012, 10) ;
INSERT INTO competente_personal VALUES (20009, 100016, 6) ;
INSERT INTO competente_personal VALUES (20009, 100018, 5) ;
INSERT INTO competente_personal VALUES (20009, 100020, 9) ;
INSERT INTO competente_personal VALUES (20009, 100021, 9) ;
INSERT INTO competente_personal VALUES (20009, 100024, 6) ;
INSERT INTO competente_personal VALUES (20009, 100025, 7) ;
INSERT INTO competente_personal VALUES (20009, 100027, 7) ;
INSERT INTO competente_personal VALUES (20009, 100028, 8) ;
INSERT INTO competente_personal VALUES (20009, 100029, 5) ;
INSERT INTO competente_personal VALUES (20009, 100030, 3) ;
INSERT INTO competente_personal VALUES (20009, 100032, 4) ;
INSERT INTO competente_personal VALUES (20009, 100033, 3) ;
INSERT INTO competente_personal VALUES (20009, 100034, 2) ;
INSERT INTO competente_personal VALUES (20009, 100035, 6) ;

-- 20010, 'Lemnaru Mihai', 'IT'
INSERT INTO competente_personal VALUES (20010, 100014, 8) ;
INSERT INTO competente_personal VALUES (20010, 100015, 10) ;
INSERT INTO competente_personal VALUES (20010, 100016, 6) ;
INSERT INTO competente_personal VALUES (20010, 100018, 10) ;
INSERT INTO competente_personal VALUES (20010, 100020, 9) ;
INSERT INTO competente_personal VALUES (20010, 100021, 9) ;
INSERT INTO competente_personal VALUES (20010, 100024, 8) ;
INSERT INTO competente_personal VALUES (20010, 100025, 7) ;
INSERT INTO competente_personal VALUES (20010, 100027, 6) ;
INSERT INTO competente_personal VALUES (20010, 100028, 5) ;
INSERT INTO competente_personal VALUES (20010, 100029, 3) ;
INSERT INTO competente_personal VALUES (20010, 100030, 3) ;

-- 20011, 'Butuca George', 'IT'
INSERT INTO competente_personal VALUES (20011, 100011, 7) ;
INSERT INTO competente_personal VALUES (20011, 100012, 9) ;
INSERT INTO competente_personal VALUES (20011, 100016, 5) ;
INSERT INTO competente_personal VALUES (20011, 100018, 6) ;
INSERT INTO competente_personal VALUES (20011, 100020, 5) ;
INSERT INTO competente_personal VALUES (20011, 100021, 8) ;
INSERT INTO competente_personal VALUES (20011, 100024, 10) ;
INSERT INTO competente_personal VALUES (20011, 100025, 9) ;
INSERT INTO competente_personal VALUES (20011, 100027, 10) ;
INSERT INTO competente_personal VALUES (20011, 100028, 9) ;
INSERT INTO competente_personal VALUES (20011, 100029, 10) ;
INSERT INTO competente_personal VALUES (20011, 100030, 9) ;
INSERT INTO competente_personal VALUES (20011, 100032, 10) ;
INSERT INTO competente_personal VALUES (20011, 100033, 10) ;
INSERT INTO competente_personal VALUES (20011, 100034, 9) ;
INSERT INTO competente_personal VALUES (20011, 100035, 10) ;

--20012,  Slavici Minodora, 'IT',
INSERT INTO competente_personal VALUES (20012, 100011, 7) ;
INSERT INTO competente_personal VALUES (20012, 100012, 9) ;
INSERT INTO competente_personal VALUES (20012, 100016, 5) ;
INSERT INTO competente_personal VALUES (20012, 100018, 4) ;
INSERT INTO competente_personal VALUES (20012, 100024, 8) ;
INSERT INTO competente_personal VALUES (20012, 100025, 9) ;
INSERT INTO competente_personal VALUES (20012, 100027, 4) ;
INSERT INTO competente_personal VALUES (20012, 100028, 9) ;
INSERT INTO competente_personal VALUES (20012, 100030, 9) ;
INSERT INTO competente_personal VALUES (20012, 100032, 10) ;
INSERT INTO competente_personal VALUES (20012, 100034, 6) ;
INSERT INTO competente_personal VALUES (20012, 100035, 10) ;

-- 20013, 'Dediu Cristina', 'IT'
INSERT INTO competente_personal VALUES (20013, 100011, 7) ;
INSERT INTO competente_personal VALUES (20013, 100012, 9) ;
INSERT INTO competente_personal VALUES (20013, 100018, 10) ;
INSERT INTO competente_personal VALUES (20013, 100024, 8) ;
INSERT INTO competente_personal VALUES (20013, 100025, 9) ;
INSERT INTO competente_personal VALUES (20013, 100028, 7) ;
INSERT INTO competente_personal VALUES (20013, 100030, 9) ;
INSERT INTO competente_personal VALUES (20013, 100032, 5) ;
INSERT INTO competente_personal VALUES (20013, 100034, 8) ;
INSERT INTO competente_personal VALUES (20013, 100035, 10) ;

--  20014, 'Slabu Florin', 'IT'
INSERT INTO competente_personal VALUES (20014, 100011, 8) ;
INSERT INTO competente_personal VALUES (20014, 100012, 10) ;
INSERT INTO competente_personal VALUES (20014, 100016, 7) ;
INSERT INTO competente_personal VALUES (20014, 100018, 4) ;
INSERT INTO competente_personal VALUES (20014, 100020, 9) ;
INSERT INTO competente_personal VALUES (20014, 100021, 4) ;
INSERT INTO competente_personal VALUES (20014, 100024, 5) ;
INSERT INTO competente_personal VALUES (20014, 100025, 8) ;
INSERT INTO competente_personal VALUES (20014, 100027, 7) ;
INSERT INTO competente_personal VALUES (20014, 100028, 9) ;
INSERT INTO competente_personal VALUES (20014, 100029, 3) ;
INSERT INTO competente_personal VALUES (20014, 100030, 4) ;
INSERT INTO competente_personal VALUES (20014, 100032, 9) ;
INSERT INTO competente_personal VALUES (20014, 100033, 4) ;
INSERT INTO competente_personal VALUES (20014, 100034, 8) ;
INSERT INTO competente_personal VALUES (20014, 100035, 5) ;

-- 20015, 'Fodor Iuliana', 'IT' 
INSERT INTO competente_personal VALUES (20015, 100011, 8) ;
INSERT INTO competente_personal VALUES (20015, 100012, 7) ;
INSERT INTO competente_personal VALUES (20015, 100016, 6) ;
INSERT INTO competente_personal VALUES (20015, 100018, 6) ;
INSERT INTO competente_personal VALUES (20015, 100020, 7) ;
INSERT INTO competente_personal VALUES (20015, 100021, 9) ;
INSERT INTO competente_personal VALUES (20015, 100024, 6) ;
INSERT INTO competente_personal VALUES (20015, 100025, 7) ;
INSERT INTO competente_personal VALUES (20015, 100027, 8) ;
INSERT INTO competente_personal VALUES (20015, 100028, 8) ;
INSERT INTO competente_personal VALUES (20015, 100029, 5) ;
INSERT INTO competente_personal VALUES (20015, 100030, 8) ;
INSERT INTO competente_personal VALUES (20015, 100032, 7) ;
INSERT INTO competente_personal VALUES (20015, 100033, 9) ;
INSERT INTO competente_personal VALUES (20015, 100034, 10) ;
INSERT INTO competente_personal VALUES (20015, 100035, 10) ;


COMMIT ; 
