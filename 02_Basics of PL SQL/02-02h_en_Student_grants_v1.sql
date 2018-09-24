-- Allocation of students grants - a simple (and rather unrealistic) version

-- Given the table:
DROP TABLE students ;
CREATE TABLE students (
    student_code CHAR(18) PRIMARY KEY,
    student_name NVARCHAR2(80) NOT NULL,
    e_mail_address VARCHAR(100),
    mobile_phone CHAR(10),
    study_level CHAR(1) NOT NULL -- can be "B" (Bachelor), "M" (Master) or "D" (Doctorate)
        CONSTRAINT ck_study_level CHECK (study_level IN ('B', 'M', 'D')),
    year_of_study NUMERIC(1) NOT NULL
        CONSTRAINT ck_year_of_study CHECK (year_of_study IN (1, 2, 3)),
    attendance_type CHAR(1) DEFAULT 'R'  -- 'R' = Regular, 'D' - Distance, 'O' - Other
        CONSTRAINT ck_attendance CHECK (attendance_type IN ('R', 'D', 'O')),         
    programme_name NVARCHAR2(100),
    course_batch_number NUMERIC(1) DEFAULT 1
        CONSTRAINT ck_course_batch CHECK (course_batch_number BETWEEN 1 AND 5),
    grades_avg_last_sem NUMERIC(4, 2) 
        CONSTRAINT ck_grades_avg CHECK (grades_avg_last_sem <= 10),
    grant_type CHAR(1) 
        CONSTRAINT ck_grant_type CHECK (grant_type IN ('1', '2'))
    ) ;


-- and some records:

DELETE FROM students ;    

INSERT INTO students VALUES ('M24101','HALUCA V. ANA cas. RUSU', 'ana.haluca@feaa.uaic.ro', '0711111111',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 7.50, NULL);
INSERT INTO students VALUES ('M24102','HALUCA V. PAULINA ANDRUŢA', 'paulina.haluca@feaa.uaic.ro', '0711111112',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 9.50, NULL);
INSERT INTO students VALUES ('M24103','BALĂUCĂ G .TUDOR-PETRU', 'petru.balaluca@feaa.uaic.ro', '0711111113',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 6.20, NULL);
INSERT INTO students VALUES ('M24104','GRIGORICI E. RALUCA ELENA cas. CHIRIAC', 'raluca.grig@feaa.uaic.ro', '0741111111',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 8.50, NULL);
INSERT INTO students VALUES ('M24105','NEDELCU N. ALINA SIMONA', 'alinasimona.nedelcu@feaa.uaic.ro', '0742111111',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 8.50, NULL);
INSERT INTO students VALUES ('M24106','URSA M. VALENTIN MARIAN', 'i_hate._databases_198876@gmail.com', '0744111111',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 9.25, NULL);
INSERT INTO students VALUES ('M24107','ANASIE C. DANIEL-SEBASTIAN', 'daniel.anasiei@yahoo.com', '0751111111',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 7.75, NULL);
INSERT INTO students VALUES ('M24108','SOCEA-DUPAC M. NICOLETA-LOREDANA', 'nicoleta.socea@feaa.uaic.ro', '0761111111',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 7.50, NULL);
INSERT INTO students VALUES ('M24109','ZAPODEANU D. VASILICA-ANCA', 'vasilica.zappo@gmail.com', '0771111111',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 8.50, NULL);
INSERT INTO students VALUES ('M24110','TERCU I. CARMEN IULIANA', 'carmen.tercu@feaa.uaic.ro', '0781111111',
    'B', 1, 'R', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 9.50, NULL);
INSERT INTO students VALUES ('M24111','MIRONAŞ V. MARIETA IULIANA', 'marieta.mironas@feaa.uaic.ro', '0791111111',
    'B', 1, 'D', '1',   -- at bachelor, in the first year, there are just modules of study (the programme hasn't been chosen yet)
    1, 9.75, NULL);


-- 3rd year of study, bachelor, InfoEc
INSERT INTO students VALUES ('M24112','TODERAŞC D. MUGUREL-LUCIAN', 'mugurel_lucian_toderasc@feaa.uaic.ro', '0742211111',
    'B', 3, 'R', 'InfoEc', 1, 6.75, NULL) ;
INSERT INTO students VALUES ('M24113','TODERAŞC D. IOANA TATIANA', 'ioana.toderasc@feaa.uaic.ro', '0742211112',
    'B', 3, 'R', 'InfoEc', 1, 9.75, NULL) ;
INSERT INTO students VALUES ('M24114','FURDUI A. RADU-OCTAVIAN', 'octav_furdui@feaa.uaic.ro', '0742211113',
    'B', 3, 'R', 'InfoEc', 1, 9.55, NULL) ;
INSERT INTO students VALUES ('M24115','FURDUI M. ROXANA - ADRIANA', 'roxana.furdui@feaa.uaic.ro', '0742211114',
    'B', 3, 'R', 'InfoEc', 1, 7.75, NULL) ;
INSERT INTO students VALUES ('M24116','FURDUI P. FELICIA-GENOVEVA', 'felicia_i_hate_databases_too@feaa.uaic.ro', '0742211115',
    'B', 3, 'R', 'InfoEc', 1, 7.25, NULL) ;
INSERT INTO students VALUES ('M24117','CIREAŞE C. ANIŞOARA cas. ACAMPORA', 'acampora_di_la_infoec@yahoo.com', '0742211116',
    'B', 3, 'R', 'InfoEc', 1, 7.75, NULL) ;
INSERT INTO students VALUES ('M24118','CIREAŞE M. PETRU-IULIAN', 'petru_iulian_cirease@feaa.uaic.ro', '0742211117',
    'B', 3, 'R', 'InfoEc', 1, 7.75, NULL) ;
INSERT INTO students VALUES ('M24119','CIREAŞE P. CARMEN cas. SCHIN', 'carmen_schin1992@gmai.com', '0742211118',
    'B', 3, 'R', 'InfoEc', 1, 7.75, NULL) ;
INSERT INTO students VALUES ('M24120','BRUMARU V. ANDREEA-CAMELIA', 'camelia.brumaru2015@feaa.uaic.ro', '0742211119',
    'B', 3, 'R', 'InfoEc', 1, 7.75, NULL) ;
INSERT INTO students VALUES ('M24121','HALUCA V. ELENA-ANDREEA', 'elena.haluca2015@feaa.uaic.ro', '0742211120',
    'B', 3, 'R', 'InfoEc', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M24122','NICOLAE G. ANDA-MARIA', 'anda.nicolae2014@feaa.uaic.ro', '0742211122',
    'B', 3, 'R', 'InfoEc', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M24123','MUT N. DORU-IONUŢ', 'doru.ionut.mut@feaa.uaic.ro', '0742211124',
    'B', 3, 'R', 'InfoEc', 1, 8.75, NULL) ;


-- try something strange - all the students have the same grade average (master, 1st year, SIA
INSERT INTO students VALUES ('M24124','SCROBANITA A. NICOLETA GABRIELA', 'nicoleta.scrobanita@feaa.uaic.ro', '0742211131',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M24125','HAULICA V. FLORENTINA-ROXANA', 'roxy.haulica@outlook.com', '0742211132',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M24126','AVRAMII E. LILIANA cas. NEAGU', 'lili.avramii2014@outlook.com', '0742211133',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22305','RADAN A.V. MARIANA cas AGAFITEI', 'mariana.agafitei@feaa.uaic.ro', '0742211134',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22306','ASĂNDULESEI D. MAURA', 'maura_asandulesei@outlook.com', '0742211135',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22307','IBRIAN E. MARIA cas. ATOMEI', 'maia.atomei2015@gmail.com', '0742211136',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22308','SĂLĂGEANU D. VALENTIN IONEL', 'vali.salageanu@feaa.uaic.ro', '0742211137',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22309','TULUC C. ELENA cas. DASCĂLU', 'elena.dascalu2013@yahoo.com', '0742211138',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22312','BEDREAG D. ROXANA-MADALINA', 'roxy.bedreag@outlook', '0742211139',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22310','BÎZÎIAC I. COZMINA', 'cozmina.biziiac@feaa.uaic.ro', '0742211140',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22311','CODAU G. LĂCRĂMIOARA-IULIANA', 'lacra.codau2010@yahoo.com', '0742211141',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;
INSERT INTO students VALUES ('M22313','CARAIMAN ROTARIU C. MADALINA-IONELA', 'madalina.caraiman.rotariu@feaa.uaic.ro', '0742211142',
    'M', 1, 'R', 'SIA', 1, 8.75, NULL) ;


COMMIT ;

-- instead of printing next procedure's results, we'll write them into a log-table

-- as Oracle does not support SERIAL data type, we'll use a sequence and a trigger instead
DROP SEQUENCE seq_log_id  ;
CREATE SEQUENCE seq_log_id INCREMENT BY 1 START WITH 1 ORDER ;

DROP TABLE stud_grants1_log;
CREATE TABLE stud_grants1_log (
    id NUMERIC(10),
    text NCLOB ) ;
    
    
CREATE OR REPLACE TRIGGER trg_ins_stud_grants1_log
    BEFORE INSERT ON stud_grants1_log FOR EACH ROW
BEGIN
    :NEW.id := seq_log_id.NextVal ;
END ;
/    

----------------------------------------------------------------------------------------
--                          and now for procedure
/* The next procedure must assign to each student a grant_type 
Requirements:
    - only students enrolled in regular attendance (R) programmes may receive allowances
    - only students with average grades (on the most recent semester) greater than 7.00  
        may receive allowances
    - there are only two types of grants, '1' (highest amount) and '2'    
    - grants/allowances are provided based only on grades average for the most recent semester
    - students are ranked within their study cyle (level), year of study, attendance type, 
        and programme
    - top 25% of the students (within their study cyle (level), year of study, attendance type, 
        and programme) receive grants of type '1'
    - next 25% of the students (within their study cyle (level), year of study, attendance type, 
        and programme) receive grants of type '2'
    - students with the same grades average (within their study cyle (level), year of study, 
        attendance type, and programme) most receive the same type of grant (or no grant)           
*/ 

----------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE p_student_grants_v1 
IS
    -- first cursor is for extracting the groups of students for the ranking and
    --   grants
    CURSOR c_grant_groups IS 
        SELECT DISTINCT study_level, year_of_study, programme_name 
        FROM students 
		WHERE attendance_type = 'R' AND grades_avg_last_sem >= 7 
		ORDER BY 1, 2, 3;
			
	-- second cursor ranks the students within a programme (level, year of study, ...)		
    CURSOR c_ranked_studs  (
        study_level_ students.study_level%TYPE,
		year_of_study_ students.year_of_study%TYPE,
        programme_name_ students.programme_name%TYPE      ) IS
            SELECT student_code, student_name, grades_avg_last_sem 
            FROM students 
            WHERE study_level = study_level_ AND year_of_study = year_of_study_ AND 
                programme_name = programme_name_ AND 
                attendance_type = 'R' AND grades_avg_last_sem >= 7 
            ORDER BY grades_avg_last_sem DESC;                             
    
	v_nof_studs INTEGER := 0;
    v_nof_grants INTEGER := 0;
    v_nof_grants_1 INTEGER := 0;
    v_nof_grants_2 INTEGER := 0;

    v_last_grades_avg_1 students.grades_avg_last_sem%TYPE;
    v_last_grades_avg_2 students.grades_avg_last_sem%TYPE;
BEGIN

    -- clean up the log table
    DELETE FROM stud_grants1_log ;
    
    -- re-start the log table
    INSERT INTO stud_grants1_log (text)
        VALUES ('Start at ' || CURRENT_TIMESTAMP )  ;
    
    -- 
    INSERT INTO stud_grants1_log (text)
        VALUES ('Set on NULL the attribute students.grant_type for all studs ' )  ;
    UPDATE students SET grant_type = NULL ;
  
  
    -- main loop (for each programme and year-of-study)
	FOR rec_grant_group IN c_grant_groups LOOP
	
	   INSERT INTO stud_grants1_log (text)
        VALUES ('   Processing of programme: ' || rec_grant_group.programme_name || ', year of study: ' ||
            rec_grant_group.year_of_study || ', level: ' || rec_grant_group.study_level ||         
        '  starts at ' || CURRENT_TIMESTAMP )  ;
 
	
		-- count students within the current granting group
        SELECT COUNT(*) INTO v_nof_studs FROM students 
        WHERE study_level = rec_grant_group.study_level AND year_of_study = rec_grant_group.year_of_study AND 
                programme_name = rec_grant_group.programme_name AND attendance_type = 'R' ;
                
	   INSERT INTO stud_grants1_log (text)
        VALUES ('   There are: ' || v_nof_studs || ' of students in this group, so initially, there are ' ||
             v_nof_studs / 4 || ' estimated number of grants of type 1 and of type 2')  ;
                
		-- reset counters for current granting group 
		v_nof_grants := 0 ;
		v_nof_grants_1 := 0;
        v_nof_grants_2 := 0;

        v_last_grades_avg_1 := 10 ;        
        v_last_grades_avg_2 := 10 ;     

        -- loop through all the students in the current granting group (with grades average >= 7 )
		FOR rec_stud IN c_ranked_studs(rec_grant_group.study_level, rec_grant_group.year_of_study, 
		            rec_grant_group.programme_name) LOOP
		    INSERT INTO stud_grants1_log (text)
                VALUES ('       Current student: ' || rec_stud.student_name || ', code: ' ||
                    RTRIM(rec_stud.student_code) || ', grades average: ' || rec_stud.grades_avg_last_sem )  ;
        
		    -- if total number of grants exceeds 50% of the number of students in current
		    --    granting group, and the current student has a grade average less that
		    --    the last grant, exit from loop        
			IF v_nof_grants >= v_nof_studs / 2 AND rec_stud.grades_avg_last_sem < v_last_grades_avg_2 THEN 
                EXIT;
            ELSE
                -- there are more grants  
                
				-- test if grants of type '1' are still available (for top 25% of the students in current group)
				IF c_ranked_studs%ROWCOUNT <= v_nof_studs / 4 OR rec_stud.grades_avg_last_sem >= v_last_grades_avg_1 THEN
					-- there are still grants of type '1' available
                    UPDATE students SET grant_type='1' WHERE student_code = rec_stud.student_code ;
                    v_last_grades_avg_1 := rec_stud.grades_avg_last_sem ;
                    v_last_grades_avg_2 := v_last_grades_avg_1 ;
                    
                    INSERT INTO stud_grants1_log (text)
                        VALUES ('         this student receives grant of type 1' )  ;               
                ELSE
					-- no more grants of type  '1', but still grants of type '2'
                    UPDATE students SET grant_type='2' WHERE student_code = rec_stud.student_code;
                    v_last_grades_avg_2 := rec_stud.grades_avg_last_sem; 
                    
                    INSERT INTO stud_grants1_log (text)
                        VALUES ('         this student receives grant of type 2' )  ;               
     
                END IF;
                
                v_nof_grants := v_nof_grants + 1;  
                
                COMMIT ;
                
                -- statistics after the curent student
                SELECT COUNT(*) INTO v_nof_grants_1 FROM students 
                WHERE study_level = rec_grant_group.study_level AND year_of_study = rec_grant_group.year_of_study AND 
                        programme_name = rec_grant_group.programme_name AND grant_type='1' ;
                        
                SELECT COUNT(*) INTO v_nof_grants_2 FROM students 
                WHERE study_level = rec_grant_group.study_level AND year_of_study = rec_grant_group.year_of_study AND 
                        programme_name = rec_grant_group.programme_name AND grant_type='2' ;
                        
                INSERT INTO stud_grants1_log (text)
                    VALUES ('             currently, at this group, there were assigned ' || v_nof_grants_1 ||
                        ' grants of type1 and ' || v_nof_grants_2 || ' of type2.' )  ;               
                        
            END IF;
        END LOOP;
    END LOOP;
    
    -- write stop timestamp
    INSERT INTO stud_grants1_log (text)
        VALUES ('Stop at ' || CURRENT_TIMESTAMP )  ;
    
    COMMIT ;
   
END;
/

-- test 
EXECUTE p_student_grants_v1

-- see the results
SELECT * FROM students ;

SELECT * FROM students ORDER BY study_level, year_of_study, programme_name, grades_avg_last_sem DESC;

SELECT * FROM stud_grants1_log ORDER BY 1 ;



