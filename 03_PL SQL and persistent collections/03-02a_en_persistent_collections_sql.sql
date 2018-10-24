-- 1.  Tipuri-colecție: telefoane, faxuri, emailuri
--
DROP TABLE applicants ;
DROP TABLE master_progs ;

CREATE TABLE master_progs (
  prog_abbreviation VARCHAR2(5) PRIMARY KEY,
  prog_name VARCHAR2(50) NOT NULL,
  n_of_positionsBuget NUMBER(3),
  n_of_positionsBuget_Ocupate NUMBER(3),
  n_of_positionsTaxa NUMBER(3),
  n_of_positionsTaxa_Ocupate NUMBER(3),
  Blocata CHAR(1) DEFAULT 'N' NOT NULL
      CHECK (Blocata IN ('D', 'N'))
  ) ;

-- tipuri colectie necesar stocarii numerelor de telefon și adreselor de e-mail 

DROP TYPE tip_colectie_tel FORCE 
/
CREATE OR REPLACE TYPE tip_colectie_tel IS TABLE OF CHAR(10) 
/

DROP TYPE tip_colectie_email FORCE 
/
CREATE OR REPLACE TYPE tip_colectie_email IS TABLE OF VARCHAR2(100)
/

-- tip înoegistrare pentru stocarea opțiunilor 
DROP TYPE tip_optiune FORCE 
/

CREATE OR REPLACE TYPE tip_optiune AS OBJECT (
    prog_abbreviation VARCHAR2(5),
    taxa CHAR (1) 
    ) 
/	

DROP TYPE tip_colectie_optiuni FORCE 
/
CREATE OR REPLACE TYPE tip_colectie_optiuni IS VARRAY (12) OF  tip_optiune
/

-------------------------------------------------------------------------
-- pachet utilitar
CREATE OR REPLACE PACKAGE pac_utilitare
AS
    FUNCTION f_ref_master_progs (prog_abbreviation_ master_progs.prog_abbreviation%TYPE) RETURN BOOLEAN ;
END ;
/

------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_utilitare
AS
    FUNCTION f_ref_master_progs (prog_abbreviation_ master_progs.prog_abbreviation%TYPE) RETURN BOOLEAN 
    IS
        v_unu NUMBER(1) ;
    BEGIN
        SELECT 1 INTO v_unu FROM master_progs WHERE prog_abbreviation = prog_abbreviation_ ;
        RETURN TRUE ;
    EXCEPTION
--        WHEN NO_DATA_FOUND THEN
        WHEN OTHERS THEN
            RETURN FALSE ;
    END f_ref_master_progs ;
END ;
/


-----------------------------------------------------------------------------------------------------
-- folosirea colectiilor in tabela applicants 
  
CREATE TABLE applicants (
  applicant_id NUMBER(6) NOT NULL PRIMARY KEY, 
  applicant_name VARCHAR2(50) NOT NULL,
  telefoane tip_colectie_tel,
  adrese_email tip_colectie_email,
  grades_avg NUMBER(4,2) NOT NULL 
    CONSTRAINT ck_grades_avg CHECK (grades_avg BETWEEN 5 AND 10),
  dissertation_avg NUMBER(4,2) NOT NULL 
    CONSTRAINT ck_dissertation_avg CHECK (dissertation_avg BETWEEN 6 AND 10),
  optiuni tip_colectie_optiuni,
  prog_abbreviation_admis VARCHAR2(5) REFERENCES master_progs(prog_abbreviation), 
  taxa_admis CHAR(1) 
      CHECK (taxa_admis IN ('B', 'T'))
  ) 
  NESTED TABLE telefoane STORE AS telefoane_nt
  NESTED TABLE adrese_email STORE AS adrese_email_nt ;
  

--------------------------------------------------------------------------------------------------
-- întrucât în colecții nu putem defini restricții (nici dintre cele referențiale, 
--        vom face verificările în declanșator
CREATE OR REPLACE TRIGGER trg_applicants_ins_ar
    AFTER INSERT ON applicants FOR EACH ROW
DECLARE
BEGIN 
    IF :NEW.optiuni(1).prog_abbreviation IS NULL THEN
        RAISE_APPLICATION_ERROR (-20456, 'Prima optiune nu poate fi NULL' );
    END IF ;

    FOR i IN 1..:NEW.optiuni.COUNT LOOP 
        IF pac_utilitare.f_ref_master_progs (:NEW.optiuni (i).prog_abbreviation) = FALSE THEN
            RAISE_APPLICATION_ERROR (-20457, 'prog_abbreviationializarea de la optiunea ' || i  || ' inexistentă !' );
        END IF ;
        IF :NEW.optiuni (i).taxa IS NULL OR :NEW.optiuni (i).taxa NOT IN ('B', 'T') THEN
            RAISE_APPLICATION_ERROR (-20458, 'La optiunea ' || i  || ' finatarea B/T (buget/taxa) este eronată !' );
        END IF ;
    END LOOP ;
	
	-- sa nu se repete vreo optiune !!!
	FOR rec_duplicate IN (SELECT t.prog_abbreviation, t.taxa, COUNT(*) 
                        FROM TABLE(:NEW.optiuni) t 
                        GROUP BY t.prog_abbreviation, t.taxa
						HAVING COUNT(*) > 1) LOOP 
		RAISE_APPLICATION_ERROR (-20550, 'Se repeta optiunea ' || rec_duplicate.prog_abbreviation || '-' || rec_duplicate.taxa)  ;
  END LOOP ;
	
END ;
/

DELETE FROM master_progs ;

INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positionsBuget, n_of_positionsTaxa) 
    VALUES ('SIA', 'Sisteme informationale pentru afaceri', 3, 2) ;
INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positionsBuget, n_of_positionsTaxa)  
    VALUES ('FAB', 'Finante-Asigurari-Banci', 4, 2) ;
INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positionsBuget, n_of_positionsTaxa)  
    VALUES ('CEA', 'Contabilitate, expertiza si audit', 6, 0) ;
INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positionsBuget, n_of_positionsTaxa)  
    VALUES ('MARK', 'Marketing', 5, 0) ;
INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positionsBuget, n_of_positionsTaxa)  
    VALUES ('EAI', 'Economie si afaceri internationale', 4, 1) ;
INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positionsBuget, n_of_positionsTaxa)  
    VALUES ('MRU', 'Managementul resurselor umane', 5, 2) ;
INSERT INTO master_progs (prog_abbreviation, prog_name, n_of_positionsBuget, n_of_positionsTaxa)  
    VALUES ('MCE', 'Metode cantitative in economie', 5, 5) ;

COMMIT ;	


DELETE FROM applicants ;

-- inserturi cu preluarea datelor in atribute NESTED TABLES și VARRAY

-- aici avem o eroare (prima optiune nu poate fi null)
INSERT INTO applicants VALUES ( 1, 'Popescu I. Irina', 
    tip_colectie_tel('2323111222', '0745123456'),
    tip_colectie_email ('irina.p@gmail.com', 'irina.popescu2011@feaa.uaic.ro'),
    7.5, 9.50, 
    tip_colectie_optiuni(  tip_optiune( NULL, NULL), 
        tip_optiune('FAB', 'B'), tip_optiune('FAB', 'T'), tip_optiune('MARK', 'B'), 
        tip_optiune('EAI', 'B'), tip_optiune('MRU', 'B') 
        ), 
        NULL, NULL  );

-- acum generăm o altă eroare (la a treia optiune, finantarea este greșită)
INSERT INTO applicants VALUES ( 1, 'Popescu I. Irina', 
    tip_colectie_tel('2323111222', '0745123456'),
    tip_colectie_email ('irina.p@gmail.com', 'irina.popescu2011@feaa.uaic.ro'),
    7.5, 9.50, 
    tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('FAB', 'T'), tip_optiune('MARK', 'X'), 
        tip_optiune('EAI', 'B'), tip_optiune('MRU', 'B') 
        ), 
        NULL, NULL  );

-- acum repetam optiuni		
INSERT INTO applicants VALUES ( 1, 'Popescu I. Irina', 
    tip_colectie_tel('0232311122', '0745123456'),
    tip_colectie_email ('irina.p@gmail.com', 'irina.popescu2011@feaa.uaic.ro'),
    7.5, 9.50, 
    tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('FAB', 'B'), tip_optiune('MARK', 'B'), 
        tip_optiune('EAI', 'B'), tip_optiune('MRU', 'B') 
        ), 
        NULL, NULL  );

		
-- de acum este bine 

DELETE FROM applicants ;

INSERT INTO applicants VALUES ( 1, 'Popescu I. Irina', 
    tip_colectie_tel('0232311122', '0745123456'),
    tip_colectie_email ('irina.p@gmail.com', 'irina.popescu2011@feaa.uaic.ro'),
    7.5, 9.50, 
    tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('FAB', 'T'), tip_optiune('MARK', 'B'), 
        tip_optiune('EAI', 'B'), tip_optiune('MRU', 'B') 
        ), 
        NULL, NULL  );

INSERT INTO applicants VALUES ( 2, 'Babias D. Ecaterina', 
    tip_colectie_tel('0232311222', '0746123456', '074111999'),
    tip_colectie_email ('Ecaterina23@gmail.com', 'Ecaterina.Babias@feaa.uaic.ro'),
    8.5, 9.20, 
   tip_colectie_optiuni(   
        tip_optiune('SIA', 'B'), tip_optiune('SIA', 'T'), tip_optiune('EAI', 'B'), 
        tip_optiune('EAI', 'T') 
        ), 
        NULL, NULL  );
        
INSERT INTO applicants VALUES ( 3, 'Strat P. Iulian', 
    tip_colectie_tel('0232111111', '0747123456'),
    tip_colectie_email ('iulian.strat@gmail.com', 'iulianpp2011@feaa.uaic.ro'),
    7.35, 9.50, 
    tip_colectie_optiuni(   
        tip_optiune('CEA', 'B'), tip_optiune('CEA', 'T'), tip_optiune('EAI', 'B'), 
        tip_optiune('MRU', 'B'), tip_optiune('MRU', 'T'), tip_optiune('SIA', 'T'), tip_optiune('FAB', 'T'), tip_optiune('MARK', 'B') 
        ), 
        NULL, NULL  );

INSERT INTO applicants VALUES ( 4, 'Georgescu M. Honda', 
    tip_colectie_tel('0232222222', '0748123456'),
    tip_colectie_email ('mgeorgescu1966@gmail.com', 'mircea.geo1966@feaa.uaic.ro'),
    8.5, 9.00, 
    tip_colectie_optiuni(   
        tip_optiune('MRU', 'B'), tip_optiune('MRU', 'T'), tip_optiune('MARK', 'B'), 
        tip_optiune('EAI', 'B'), tip_optiune('FAB', 'B'), tip_optiune('CEA', 'B'), tip_optiune('SIA', 'B') 
        ), 
        NULL, NULL  );

INSERT INTO applicants VALUES ( 5, 'Munteanu A. Optimista', 
    tip_colectie_tel('0232333333', '0749123456'),
    tip_colectie_email ('munteanu.o@gmail.com', 'opti_m@yahoo.com', 'opti.munteanu@feaa.uaic.ro'),
    9.5, 9.50, 
   tip_colectie_optiuni(   
        tip_optiune('SIA', 'B'), tip_optiune('CEA', 'T'), tip_optiune('FAB', 'B'), 
        tip_optiune('FAB', 'T'), tip_optiune('SIA', 'T') 
        ), 
        NULL, NULL  );    

INSERT INTO applicants VALUES ( 6, 'Dumitriu F. Dura', 
    tip_colectie_tel('0232444444', '0746623456'),
    tip_colectie_email ('ddumi@gmail.com', 'dura_dumi@feaa.uaic.ro', 'dumitriu_d2010@yahoo.com'),
    9.5, 10, 
   tip_colectie_optiuni(   
        tip_optiune('EAI', 'B'), tip_optiune('EAI', 'T') 
        ), 
        NULL, NULL  );    

INSERT INTO applicants VALUES ( 7, 'Mesnita G. Plinutul', 
    tip_colectie_tel('0237111222', '0747723456'),
    tip_colectie_email ('mesnita.plin@gmail.com', 'mesnita.pl2011@feaa.uaic.ro'),
    10, 10,  
    tip_colectie_optiuni(   
        tip_optiune('EAI', 'B'), tip_optiune('EAI', 'T'), tip_optiune('MARK', 'B'), 
        tip_optiune('MARK', 'T'), tip_optiune('MRU', 'B') 
        ), 
        NULL, NULL  );   

INSERT INTO applicants VALUES ( 8, 'Greavu V. Doru', 
    tip_colectie_tel('0235111222', '0725123456'),
    tip_colectie_email ('doru.greavu2011@feaa.uaic.ro'),
    9.25, 8.50, 
    tip_colectie_optiuni(   
        tip_optiune('SIA', 'B'), tip_optiune('SIA', 'T'), tip_optiune('CEA', 'B'), 
        tip_optiune('FAB', 'B')
        ), 
        NULL, NULL  );    

INSERT INTO applicants VALUES ( 9, 'Baboi P. Iustina', 
    tip_colectie_tel('0237123456', '0735123456'),
    tip_colectie_email ('iustina.baboi@gmail.com', 'iustina.baboi2011@feaa.uaic.ro', 'iustina.baboi2011@personal.ro'),
    8.5, 8.50,  
    tip_colectie_optiuni(   
        tip_optiune('SIA', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (10, 'Postelnicu I. Irina', 
    tip_colectie_tel('0235112233', '0755123456'),
    tip_colectie_email ('irina.post@gmail.com', 'irina.post2011@feaa.uaic.ro'),
    9.5, 8.25, 
    tip_colectie_optiuni(   
        tip_optiune('MARK', 'B')
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (11, 'Fotache H. Fanel', 
    tip_colectie_tel('0232311222', '0785563456'),
    tip_colectie_email ('fanel.fotache@gmail.com', 'fanel.fotache2011@feaa.uaic.ro', 'ff2011@yahoo.com'),
    9.75, 9.50,  
    tip_colectie_optiuni(   
        tip_optiune('MRU', 'B')
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (12, 'Moscovici J. Cristina', 
    tip_colectie_tel('0237112233', '0795123456'),
    tip_colectie_email ('Moscovici.J@gmail.com', 'cristina.moscovici2011@feaa.uaic.ro'),
    9.80, 9.30,  
    tip_colectie_optiuni(   
        tip_optiune('CEA', 'B'), tip_optiune('CEA', 'T'), tip_optiune('SIA', 'B'), 
        tip_optiune('SIA', 'T'), tip_optiune('FAB', 'B') 
        ), 
        NULL, NULL  );    

INSERT INTO applicants VALUES (13, 'Rusu I. Vanda', 
    tip_colectie_tel('0238011222', '0745553456'),
    tip_colectie_email ('vanda.rusu@gmail.com', 'vanda.rusu2011@feaa.uaic.ro'),
    7.80, 9.10,  
    tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('FAB', 'T'), tip_optiune('CEA', 'B'), 
        tip_optiune('MARK', 'B'), tip_optiune('MRU', 'B'), tip_optiune('MRU', 'T')
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (14, 'Spinu M. Algebra', 
    tip_colectie_tel('0323111222', '072321321'),
    tip_colectie_email ('spinu.harap-alb@gmail.com', 'algebra.spinu2011@feaa.uaic.ro'),
    7.25, 9.00,  
    tip_colectie_optiuni(   
        tip_optiune('SIA', 'B'), tip_optiune('CEA', 'B'), tip_optiune('FAB', 'B'), 
        tip_optiune('SIA', 'T'), tip_optiune('CEA', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (15, 'Sandovici I. Irina', 
    tip_colectie_tel('0324111222', '0788823456'),
    tip_colectie_email ('irina.sand@gmail.com', 'irina.sandovici2011@feaa.uaic.ro'),
    7.05, 7.50,  
    tip_colectie_optiuni(   
        tip_optiune('MARK', 'B'), tip_optiune('MARK', 'T'), tip_optiune('MRU', 'B'), 
        tip_optiune('EAI', 'B'), tip_optiune('CEA', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (16, 'Plai V. Picior', 
    tip_colectie_tel('023797654', '0789923456'),
    tip_colectie_email ('picior-de-plai@gmail.com', 'picior.play2011@feaa.uaic.ro'),
    7.5, 7.90,  
    tip_colectie_optiuni(   
        tip_optiune('EAI', 'B'), tip_optiune('EAI', 'T'), tip_optiune('SIA', 'B'), 
        tip_optiune('CEA', 'B'), tip_optiune('FAB', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (17, 'Ambuscada B. Cristina', 
    tip_colectie_tel('0245311222', '0745432456'),
    tip_colectie_email ('cristina.ambuscada@gmail.com', 'cristina.ambuscada2011@feaa.uaic.ro'),
    8.25, 9.50,  
    tip_colectie_optiuni(   
        tip_optiune('SIA', 'B'), tip_optiune('SIA', 'T'), tip_optiune('CEA', 'B'), 
        tip_optiune('FAB', 'B'), tip_optiune('EAI', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (18, 'Pinda A. Axinia', 
    tip_colectie_tel('0232918273', '0746993456'),
    tip_colectie_email ('axinia.p@gmail.com', 'pinda.axinia2011@feaa.uaic.ro'),
    8.75, 9.00,  
    tip_colectie_optiuni(   
        tip_optiune('SIA', 'B'), tip_optiune('FAB', 'B'), tip_optiune('CEA', 'B'), 
        tip_optiune('SIA', 'T'), tip_optiune('FAB', 'T') 
        ), 
        NULL, NULL  );    

INSERT INTO applicants VALUES (19, 'Planton V. Grigore', 
    tip_colectie_tel('0232991122', '0746225556'),
    tip_colectie_email ('grigore.planton@gmail.com', 'grigore.planton2011@feaa.uaic.ro'),
    9.25, 9.50,  
    tip_colectie_optiuni(   
        tip_optiune('FAB', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (20, 'Sergentu I. Zece',
    tip_colectie_tel('0235223344', '0715123486'),
    tip_colectie_email ('zece.sergentu.p@gmail.com', 'sergentu.zece2011@feaa.uaic.ro'),
    7.5, 9.50,  
    tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('FAB', 'T'), tip_optiune('CEA', 'B'), 
        tip_optiune('CEA', 'T') 
        ), 
       NULL, NULL  );    


INSERT INTO applicants VALUES (21, 'Ababei T. Marian-Vasile', 
    tip_colectie_tel('0238366778', '0725132546'),
    tip_colectie_email ('ababei.tmv@gmail.com', 'vasile.ababei2011@feaa.uaic.ro'),
    7.5, 9.50, 
    tip_colectie_optiuni(   
        tip_optiune('CEA', 'B'), tip_optiune('CEA', 'T'), tip_optiune('MRU', 'B'), 
        tip_optiune('MRU', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (22, 'Popistasu J. Maria',
    tip_colectie_tel('0232441122', '0777123456'),
    tip_colectie_email ('maria.posistasu_adjud@gmail.com', 'maria.popistasu2011@feaa.uaic.ro'),
    8.25, 9.85,  
    tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('EAI', 'B'), tip_optiune('CEA', 'B'), 
        tip_optiune('MRU', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (23, 'Plop R. Robert', 
    tip_colectie_tel('0237315268', '0777653456'),
    tip_colectie_email ('robert.plop@gmail.com', 'robert.plop2011@feaa.uaic.ro'),
    7.75, 9.75, 
    tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('FAB', 'T'), tip_optiune('MARK', 'B'), 
        tip_optiune('MRU', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (24, 'Aflorei H. Crina',
    tip_colectie_tel( '0788823456'),
    tip_colectie_email ('crina.aflorei@gmail.com', 'crina.aflorei2011@feaa.uaic.ro'),
    6.75, 9.75,  
    tip_colectie_optiuni(   
        tip_optiune('EAI', 'B'), tip_optiune('EAI', 'T'), tip_optiune('SIA', 'B'), 
        tip_optiune('SIA', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (25, 'Afaunei P. Gina', 
    tip_colectie_tel( '0885123456'),
    tip_colectie_email ('ginaa@gmail.com', 'gina.afaunei2011@feaa.uaic.ro'),
    8.45, 9.25,  
    tip_colectie_optiuni(   
        tip_optiune('SIA', 'B'), tip_optiune('SIA', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (26, 'Vatamanu I. Alexandrina', 
    tip_colectie_tel('0238889977', '0845123459'),
    tip_colectie_email ('alexandrina.vat@gmail.com', 'alexandrina.vatamanu2011@feaa.uaic.ro'),
    8.5, 8.25, 
    tip_colectie_optiuni(   
        tip_optiune('MRU', 'B'), tip_optiune('MRU', 'T'), tip_optiune('MARK', 'B'), 
        tip_optiune('MARK', 'T'), tip_optiune('EAI', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (27, 'Lovin P. Marian', 
    tip_colectie_tel('0235312223', '0945987456'),
    tip_colectie_email ('marian.lov@gmail.com', 'mariaa.lovin2011@feaa.uaic.ro'),
    9.10, 8.50,  
    tip_colectie_optiuni(   
        tip_optiune('MARK', 'B'), tip_optiune('MARK', 'T'), tip_optiune('MRU', 'B'), 
        tip_optiune('MRU', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (28, 'Antiteza W. Florin', 
    tip_colectie_tel( '0876153456'),
    tip_colectie_email ('antiteza.sinteza@gmail.com', 'florin.anti2011@feaa.uaic.ro'),
    10, 9.50, 
	tip_colectie_optiuni(   
        tip_optiune('EAI', 'B'), tip_optiune('MARK', 'B'), tip_optiune('MRU', 'B'), 
        tip_optiune('EAI', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (29, 'Prepelita V. Ion', 
    tip_colectie_tel('0232776655'),
    tip_colectie_email ('ion.prepelita@gmail.com', 'ion.prepelita2011@feaa.uaic.ro', 'ion_zburatoru@hotmail.com'),
    10, 10, 
	tip_colectie_optiuni(   
        tip_optiune('EAI', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (30, 'Cioara X. Sanda', 
    tip_colectie_tel('0783423456'),
    tip_colectie_email ('sanda.pasare@hotmail.com', 'sanda.pasare2011@feaa.uaic.ro'),
    9.75, 7.10, 
	tip_colectie_optiuni(   
        tip_optiune('CEA', 'B'), tip_optiune('CEA', 'T'), tip_optiune('FAB', 'B'), 
        tip_optiune('EAI', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (31, 'Metafora Y. Vasile',
    tip_colectie_tel('0232444559'),
    tip_colectie_email ('vasile.hiperbola@personal.ro', 'vasile.metafora2011@feaa.uaic.ro'),
    8.85, 8.95,  
	tip_colectie_optiuni(   
        tip_optiune('CEA', 'B'), tip_optiune('CEA', 'T'), tip_optiune('MRU', 'B'), 
        tip_optiune('MRU', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (32, 'Strasina R. Elvis', 
    tip_colectie_tel('0232123987', '0745929496'),
    tip_colectie_email ('elvis_curgatoru@gmail.com', 'elvis.strasina2011@feaa.uaic.ro'),
    6.5, 6.50, 
	tip_colectie_optiuni(   
        tip_optiune('CEA', 'B'), tip_optiune('CEA', 'T')
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (33, 'Durere V. Vasile', 
    tip_colectie_tel('0232119922', '0745828486'),
    tip_colectie_email ('vasile.pilula@gmail.com', 'vasile.durere2011@feaa.uaic.ro'),
    8.75, 7.25, 
	tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('CEA', 'B'), tip_optiune('EAI', 'B'), 
        tip_optiune('MARK', 'B'), tip_optiune('MRU', 'B'), tip_optiune('FAB', 'T'), 
        tip_optiune('CEA', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (34, 'Sedentaru L. Marius-Daniel',
    tip_colectie_tel('0745727476'),
    tip_colectie_email ('maris.danile-sed@gmail.com', 'marius.sedentaru2011@feaa.uaic.ro'),
    7.35, 9.15,  
	tip_colectie_optiuni(   
        tip_optiune('MARK', 'B'), tip_optiune('MRU', 'B'), tip_optiune('EAI', 'B'), 
        tip_optiune('MARK', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (35, 'Zgircitu I. Daniel',
    tip_colectie_tel('2323111222', '0745626466'),
    tip_colectie_email ('generosu.daniel@gmail.com', 'daniel.zgircitu2011@feaa.uaic.ro'),
    6.5, 7.50,  
	tip_colectie_optiuni(   
        tip_optiune('MRU', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (36, 'Graur X. Sanda', 
    tip_colectie_tel( '0745525456'),
    tip_colectie_email ('sanda.graur@gmail.com', 'sanda.graur2011@feaa.uaic.ro'),
    8.5, 9.90, 
    tip_colectie_optiuni(   
        tip_optiune('CEA', 'B'), tip_optiune('CEA', 'T'), tip_optiune('FAB', 'B'), 
        tip_optiune('EAI', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (37, 'Epitet V. Vasilica',
    tip_colectie_tel('0238665577', '0745424446'),
    tip_colectie_email ('vas.eipitet@gmail.com', 'vasilica.epitet@feaa.uaic.ro'),
    7.75, 8.50,  
	tip_colectie_optiuni(   
        tip_optiune('SIA', 'B'), tip_optiune('SIA', 'T'), tip_optiune('CEA', 'B'), 
        tip_optiune('CEA', 'T') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (38, 'Burlan W. Elvis', 
    tip_colectie_tel('0237665544', '0745323436'),
    tip_colectie_email ('elvis.burlan@gmail.com', 'elvia.burlan@feaa.uaic.ro'),
    8.5, 9.40, 
	tip_colectie_optiuni(   
        tip_optiune('CEA', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (39, 'Alifie I. Grigore', 
    tip_colectie_tel( '0745222426'),
    tip_colectie_email ('alifie.grig@hotmail.com', 'grigore.alifie2011@feaa.uaic.ro'),
    7.9, 9.60, 
	tip_colectie_optiuni(   
        tip_optiune('FAB', 'B'), tip_optiune('FAB', 'T'), tip_optiune('CEA', 'B'), 
        tip_optiune('CEA', 'T'), tip_optiune('EAI', 'B'), tip_optiune('MARK', 'B'), 
		tip_optiune('MARK', 'T'), tip_optiune('MRU', 'B'), tip_optiune('MRU', 'T')	
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (40, 'Viteza L. Marius-Daniel',
    tip_colectie_tel( '0745121416'),
    tip_colectie_email ('viteza.md@gmail.com'),
    7.5, 9.50,  
    tip_colectie_optiuni(   
        tip_optiune('MARK', 'B'), tip_optiune('MARK', 'T'), tip_optiune('MRU', 'B'), 
        tip_optiune('EAI', 'B') 
        ), 
       NULL, NULL  );    

INSERT INTO applicants VALUES (41, 'Generosu I. Daniel',
    tip_colectie_tel('0232443322', '0740120450'),
    tip_colectie_email ('generosu.d@gmail.com'),
  7.8, 9.50,  
     tip_colectie_optiuni(   
        tip_optiune('MRU', 'B') 
        ), 
       NULL, NULL  );    

COMMIT ;
  


--=========================================================================
-- Interogari ale tabelei applicants
--=========================================================================

SELECT c.*
FROM applicants c


-- sa se afiseze sub forma de tabela numerele de telefon ale 
-- tuturor applicantslor
SELECT c.*, e.*
FROM applicants c, TABLE (c.telefoane) e

-- interogarea urmatoare nu functioneaza
SELECT c.*, e.* AS tel
FROM applicants c, TABLE (c.telefoane) e

-- insa aceasta DA !
SELECT c.*, e.column_value AS tel
FROM applicants c, TABLE (c.telefoane) e


-- sa se afiseze toti applicantsi si numerele de tel., inclusiv cei care nu au telefon

-- aceasta interogarea nu functioneaza !
SELECT c.*, e.column_value AS tel
FROM applicants c, TABLE (c.telefoane) e
UNION
SELECT c.*, NULL
FROM applicants c
WHERE c.applicant_id NOT IN 
  (SELECT c.applicant_id
   FROM applicants c, TABLE (c.telefoane) e)


-- nici aceasta  !
SELECT x.*
FROM 
  (SELECT c.*, e.COLUMN_VALUE AS tel
   FROM applicants c, TABLE (c.telefoane) e ) x  
UNION
SELECT c.*, NULL
FROM applicants c
WHERE c.applicant_id NOT IN 
  (SELECT c.applicant_id
   FROM applicants c, TABLE (c.telefoane) e)

   
-- nici macar aceasta  !
SELECT c.*, e.COLUMN_VALUE AS tel
FROM applicants c, TABLE (c.telefoane) e
UNION
SELECT c.*, y.COLUMN_VALUE
FROM applicants c, TABLE (CAST (MULTISET (SELECT NULL FROM dual) AS tip_colectie_tel)) y
WHERE applicant_id NOT IN 
  (SELECT applicant_id
   FROM applicants c, TABLE (c.telefoane) e)



-- ci doar aceasta  !
SELECT x.applicant_id, applicant_name, tel
FROM 
  (SELECT c.*, e.COLUMN_VALUE AS tel
   FROM applicants c, TABLE (c.telefoane) e ) x  
UNION
SELECT c.applicant_id, applicant_name, NULL
FROM applicants c
WHERE c.applicant_id NOT IN 
  (SELECT c.applicant_id
   FROM applicants c, TABLE (c.telefoane) e)



   
-- sa se afiseze sub forma de tabela adresele de e-mail ale candidatului 'Dumitriu F. Dura',
SELECT e.*
FROM applicants c, TABLE (c.adrese_email) e
WHERE applicant_name = 'Dumitriu F. Dura'

-- sau 
SELECT *
FROM TABLE (
		SELECT c.adrese_email
		FROM applicants c 
		WHERE applicant_name = 'Dumitriu F. Dura'
		)


-- toate combinatiile e-mail/telefon pentru 'Dumitriu F. Dura'
SELECT c.applicant_name, e.column_value AS "e-mail", t.column_value AS tel
FROM applicants c,
 TABLE (
  SELECT c.adrese_email
  FROM applicants c
  WHERE applicant_name = 'Dumitriu F. Dura'
  ) e,
TABLE (
  SELECT c.telefoane
  FROM applicants c
  WHERE applicant_name = 'Dumitriu F. Dura'
  ) t
WHERE applicant_name = 'Dumitriu F. Dura'


-- Cite numere de telefon are Popescu Ioneliu ?
-- solutie valabila numai incepind cu Oracle 10g 
SELECT CARDINALITY(c.telefoane)
FROM applicants c
WHERE applicant_name = 'Dumitriu F. Dura'

-- si o solutie valabila si in 9i
SELECT COUNT(*)
FROM TABLE (
		SELECT c.telefoane
		FROM applicants c
		WHERE applicant_name = 'Dumitriu F. Dura'
		)


-- Cine foloseste telefonul cu numarul 0232222222 ?
SELECT *
FROM applicants WHERE applicant_id IN (
		SELECT applicant_id 
		FROM applicants c, TABLE (c.telefoane) t
		WHERE t.column_value = '0232222222'
		)


-- Care sunt applicantsi care au adresa de e-mail pe serverul feaa.uaic.ro  ?
SELECT c.* 
FROM applicants c, TABLE (c.adrese_email) e
WHERE UPPER(e.column_value)  LIKE '%@FEAA.UAIC.RO'
				
		
-- Care sunt applicantsi care NU au adresa de e-mail pe serverul feaa.uaic.ro  ?
SELECT c.* 
FROM applicants c
WHERE applicant_id NOT IN  (
    SELECT c.applicant_id 
    FROM applicants c, TABLE (c.adrese_email) e
    WHERE UPPER(e.column_value)  LIKE '%@FEAA.UAIC.RO'
    )

		
-- Care sunt serverele de e-mail folosite de applicants ?

-- mai întâi, o interogare ajutătoare
SELECT c.applicant_id, e.COLUMN_VALUE, INSTR( e.COLUMN_VALUE, '@'),
   SUBSTR(e.COLUMN_VALUE, INSTR( e.COLUMN_VALUE, '@'), LENGTH (e.COLUMN_VALUE) - INSTR( e.COLUMN_VALUE, '@') + 1)
FROM applicants c, TABLE (c.adrese_email) e

-- iar acum răspunsul
SELECT DISTINCT server_email
FROM (
    SELECT SUBSTR(e.COLUMN_VALUE, 
        INSTR( e.COLUMN_VALUE, '@') + 1, 
        LENGTH (e.COLUMN_VALUE) - INSTR( e.COLUMN_VALUE, '@') + 1
            ) as server_email
    FROM applicants c, TABLE (c.adrese_email) e
    )
ORDER BY 1    


-- Care este cel mai folosit server de e-mail ?

-- începem tot cu o interogare ajutătoare
SELECT server_email, COUNT(*) AS noConturi
FROM (
    SELECT SUBSTR(e.COLUMN_VALUE, 
        INSTR( e.COLUMN_VALUE, '@') + 1, 
        LENGTH (e.COLUMN_VALUE) - INSTR( e.COLUMN_VALUE, '@') + 1
            ) as server_email
    FROM applicants c, TABLE (c.adrese_email) e
    )
GROUP BY   server_email  
ORDER BY 1 
/

-- acum folosim o funcție analitică - RANK
SELECT server_email, noConturi, RANK() OVER (ORDER BY noConturi DESC ) AS Pozitie
FROM (
    SELECT server_email, COUNT(*) AS noConturi
    FROM (
        SELECT SUBSTR(e.COLUMN_VALUE, 
            INSTR( e.COLUMN_VALUE, '@') + 1, 
            LENGTH (e.COLUMN_VALUE) - INSTR( e.COLUMN_VALUE, '@') + 1
                ) as server_email
        FROM applicants c, TABLE (c.adrese_email) e
        )
    GROUP BY   server_email  
    )
/


--=================================================================
-- 			actualizarea colectiilor 
--=================================================================


-- adaugam un numar de ZAPP pentru 'Popescu I. Irina'
INSERT INTO TABLE (
	SELECT c.telefoane 
	FROM applicants c 
	WHERE applicant_name = 'Popescu I. Irina'
			)
	VALUES ('0788111111');


-- ii stergem lui Babias D. Ecaterina al doilea numar Orange
DELETE FROM TABLE (
	SELECT c.telefoane
	FROM applicants c
	WHERE applicant_name ='Babias D. Ecaterina'
		)
WHERE column_value = '074111999' ;

	
-- modificam prima adresa e-mail a Irinei Popescu
-- 	din 'irina.p@gmail.com' in 'irina_pop@gmail.com'
UPDATE TABLE (
		SELECT c.adrese_email FROM applicants c 
			WHERE applicant_name ='Popescu I. Irina'
		) e
SET VALUE(e) = 'irina_pop@gmail.com'
WHERE column_value = 'irina.p@gmail.com'




