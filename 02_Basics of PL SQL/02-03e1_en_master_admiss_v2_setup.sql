/* Case study (simplified - no positions for tuition fee studies):
    Admission at FEAA master programs - 2nd version
    
    New:
    	Students aspiring to the same programme, having the same admission grade
    		average as the last accepted to the program, MUST be also accepted  
    
    In this script we will create and populate two tables, "master_progs" and "applicants"
    
*/
DROP TABLE applicants ;
DROP TABLE master_progs ;

/* table "master_progs" stores every program abbreviation, name, number of positions, 
    and number of filled positions (which initially is zero and will be updated
     by the admission procedures); notice `last_admitted_avg` */
CREATE TABLE master_progs (
	prog_abbreviation VARCHAR2(9) PRIMARY KEY,
	prog_name VARCHAR2(70) NOT NULL,
	n_of_positions NUMBER(3),
	n_of_filled_positions NUMBER(3), 
	last_admitted_avg NUMBER (5, 3) 
	) ;

/*
    table "applicants" keeps information about applicants
    - "prog1_abbreviation", "prog2_abbreviation" describes applicant preferences
        (she/he wants to be accepted at prog1, but if her/his results are not good enough
           for this program, she/he would prefer prog2, ....)
    -  "grades_avg" refers to applicant's grades average (one of the acceptance 
        criteria for all master programmes)      
    -  "dissertation_avg" refers to applicant's dissertation average (the other 
            acceptance criteria for all master programmes)    
    -  "prog_abbreviation_accepted" refers to the programme the applicant will be
            accepted  (initially its values are NULL and they will be updated
            by the admission procedures) 
            
    - students ranking depends on applicants' admission average points
        which are computed as 
            admiss_avg_points := grades_avg * 0.6 + dissertation_avg * 0.4  
*/

CREATE TABLE applicants (	
    applicant_id NUMBER(6) NOT NULL PRIMARY KEY, 
    applicant_name VARCHAR2(50) NOT NULL,
    grades_avg NUMBER(4,2) NOT NULL 
		CONSTRAINT ck_grades_avg_apps CHECK (grades_avg BETWEEN 5 AND 10),
	dissertation_avg NUMBER(4,2) NOT NULL 
		CONSTRAINT ck_dissertation_avg CHECK (dissertation_avg BETWEEN 6 AND 10),
	prog1_abbreviation VARCHAR2(4) NOT NULL REFERENCES master_progs(prog_abbreviation),
	prog2_abbreviation VARCHAR2(4) REFERENCES master_progs(prog_abbreviation),
	prog3_abbreviation VARCHAR2(4) REFERENCES master_progs(prog_abbreviation),
	prog4_abbreviation VARCHAR2(4) REFERENCES master_progs(prog_abbreviation),
	prog5_abbreviation VARCHAR2(4) REFERENCES master_progs(prog_abbreviation),
	prog6_abbreviation VARCHAR2(4) REFERENCES master_progs(prog_abbreviation),
	prog_abbreviation_accepted VARCHAR2(4) REFERENCES master_progs(prog_abbreviation),
	CONSTRAINT ck_filled_applic_progs 
	    CHECK (
COALESCE(prog2_abbreviation, ' ') = COALESCE(prog2_abbreviation, prog3_abbreviation, ' ') 
			AND
 COALESCE(prog3_abbreviation, ' ') = COALESCE(prog3_abbreviation, prog4_abbreviation, ' ') 
			AND
COALESCE(prog4_abbreviation, ' ') = COALESCE(prog4_abbreviation, prog5_abbreviation, ' ') 
			AND
COALESCE(prog5_abbreviation, ' ') = COALESCE(prog5_abbreviation, prog6_abbreviation, ' '))
) ;


			

-- populate the tables

DELETE FROM applicants ;

DELETE FROM master_progs ;
			
INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positions) 
    VALUES ('SIA', 
	'Sisteme informationale pentru afaceri', 4, 0) ;

INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positions) 
    VALUES ('FAB', 'Finante-Asigurari-Banci', 6, 0) ;

INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positions) 
    VALUES ('CEA', 
	'Contabilitate, expertiza si audit', 6, 0) ;

INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positions) 
    VALUES ('MARK', 'Marketing', 5, 0) ;

INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positions) 
    VALUES ('EAI', 
	'Economie si afaceri internationale', 5, 0) ;

INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positions) 
    VALUES ('MRU', 
	'Managementul resurselor umane', 4, 0) ;



DELETE FROM applicants ;

INSERT INTO applicants VALUES 
    ( 1, 'Popescu I. Irina', 7.5, 9.50, 'FAB', 'MARK', 'EAI', 'MRU',  NULL, NULL, NULL);
INSERT INTO applicants VALUES 
    ( 2, 'Babias D. Ecaterina', 8.75, 9.00, 'SIA', 'EAI', NULL,NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES 
    ( 3, 'Strat P. Iulian', 7.35, 9.50, 'CEA', 'EAI', 'MRU', 'SIA', 'FAB', 'MARK', NULL);
INSERT INTO applicants VALUES 
    ( 4, 'Georgescu M. Floricela', 8.5, 9.00, 'MRU', 'MARK', 'EAI', 'FAB', 'CEA', 'SIA', NULL);
INSERT INTO applicants VALUES 
    ( 5, 'Munteanu A. Optimista', 9.5, 9.50, 'SIA', 'CEA', 'FAB', NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES ( 6, 'Dumitriu F. Floricel', 9.5, 10, 'EAI', NULL, NULL,NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES ( 7, 'Mesnita G. Oana', 10, 10,'EAI', 'MARK', 'MRU',NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES ( 8, 'Greavu V. Doru', 9.25, 8.50,'SIA', 'CEA', 'FAB',NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES ( 9, 'Baboi P. Iustina', 8.5, 8.50,'SIA', NULL, NULL,NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (10, 'Postelnicu I. Irina', 9.5, 8.25,'MARK', NULL, NULL,	NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES (11, 'Fotache H. Fanel', 9.75, 9.50,'MRU', NULL, NULL,	NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES (12, 'Moscovici J. Cristina', 9.80, 9.30,'CEA', 'SIA', 'FAB',	NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES (13, 'Rusu I. Vanda', 7.80, 9.10,'FAB', 'CEA', 'MARK','MRU', 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (14, 'Spinu M. Algebra', 7.25, 9.00,'SIA', 'CEA', 'FAB',NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (15, 'Sandovici I. Irina', 7.05, 7.50,'MARK', 'MRU', 'EAI','CEA',	 NULL, NULL, NULL);
INSERT INTO applicants VALUES (16, 'Plai V. Picior', 7.5, 7.90,'EAI', 'SIA', 'CEA', 'FAB', 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (17, 'Ambuscada B. Cristina', 8.25, 9.50,'SIA', 'CEA', 	'FAB', 'EAI',NULL, NULL, NULL);
INSERT INTO applicants VALUES (18, 'Pinda A. Axinia', 8.75, 9.00,'SIA', 'FAB', 'CEA',NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (19, 'Planton V. Grigore', 9.25, 9.50,'FAB', NULL, NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (20, 'Sergentu I. Zece',7.5, 9.50,'FAB', 'CEA', NULL,NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (21, 'Ababei T. Marian-Vasile', 7.5, 9.50,'CEA', 'MRU', NULL, NULL,	NULL, NULL, NULL);
INSERT INTO applicants VALUES (22, 'Popistasu J. Maria', 8.25, 9.85,'FAB', 'EAI', 'CEA', 'MRU', 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (23, 'Plop R. Robert', 7.75, 9.75, 'FAB', 'MARK', 'MRU', NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (24, 'Aflorei H. Crina',6.75, 9.75,'EAI', 'SIA', NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (25, 'Afaunei P. Gina', 8.45, 9.25,'SIA', NULL, NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (26, 'Vatamanu I. Alexandrina', 8.5, 8.25, 'MRU', 'MARK', 'EAI',	 NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES (27, 'Lovin P. Marian', 9.10, 8.50,'MARK', 'MRU', NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (28, 'Antiteza W. Florin', 10, 9.50, 'EAI', 'MARK', 'MRU', 	NULL, NULL, NULL, NULL);

INSERT INTO applicants VALUES (29, 'Prepelita V. Ion', 10, 10, 
	'EAI', NULL, NULL, NULL, 	NULL, NULL, NULL);

INSERT INTO applicants VALUES (30, 'Cioara X. Sanda', 9.75, 7.10, 'CEA', 'FAB', 'EAI', NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (31, 'Metafora Y. Vasile',8.85, 8.95,'SIA', 'CEA', NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (32, 'Streasina R. Elvis', 6.5, 6.50, 'CEA', NULL, NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (33, 'Durere V. Vasile', 8.75, 7.25, 'FAB', 'CEA', 'EAI', 'MARK', 	'MRU', NULL, NULL);
INSERT INTO applicants VALUES (34, 'Sedentaru L. Marius-Daniel',7.35, 9.15,'MARK', 'MRU', 	'EAI', NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES (35, 'Zgircitu I. Agamita',6.5, 7.50,'MRU', NULL, NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (36, 'Graur X. Sanda', 8.5, 9.90, 'CEA', 'FAB', 'EAI', NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (37, 'Epitet V. Vasilica',7.75, 8.50,'SIA', 'CEA', NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (38, 'Burlan W. Elvis', 8.5, 9.40, 'CEA', NULL, NULL, NULL, 	NULL, NULL, NULL);
INSERT INTO applicants VALUES (39, 'Alifie I. Grigore', 7.9, 9.60, 'FAB', 'CEA', 'EAI', 'MARK', 	'MRU', NULL, NULL);
INSERT INTO applicants VALUES (40, 'Viteza L. Marius-Daniel',7.5, 9.50,'MARK', 'MRU', 	'EAI', NULL, NULL, NULL, NULL);
INSERT INTO applicants VALUES (41, 'Depresivu Q. Daniel',7.8, 9.50,'MRU', NULL, NULL, NULL, 	NULL, NULL, NULL);

COMMIT ;
