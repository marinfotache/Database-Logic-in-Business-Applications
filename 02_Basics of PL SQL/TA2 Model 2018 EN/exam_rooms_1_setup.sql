DROP TABLE STUD_ROOMS;
DROP TABLE SCHEDULED_EXAMS;
DROP TABLE STUDENTS ;
DROP TABLE PROGRAMMES;
DROP TABLE COURSES;
DROP TABLE ROOMS;

CREATE TABLE PROGRAMMES (
    Prog_Abbreviation VARCHAR(15)
        CONSTRAINT PK_PROGRAMMES PRIMARY KEY,
    Prog_Name VARCHAR2(75)
        CONSTRAINT nn_Prog_Name NOT NULL,
    Study_Level CHAR(1)
	) ;
	
CREATE TABLE COURSES (
    Course_Code VARCHAR(10)
        CONSTRAINT PK_COURSES PRIMARY KEY,
    Course_Name VARCHAR2(75)
        CONSTRAINT nn_Course_Name NOT NULL,
    N_of_Credits NUMBER(2) DEFAULT 6
	) ;	
	
	
CREATE TABLE STUDENTS  (
    Stud_Id Number(10)
        CONSTRAINT PK_STUDENTS  PRIMARY KEY,
    Stud_Name VARCHAR2(100)
        CONSTRAINT nn_Stud_Name NOT NULL,
    Prog_Abbreviation  VARCHAR(15)
		CONSTRAINT FK_STUDS_PROGS REFERENCES PROGRAMMES(Prog_Abbreviation),
	Year_of_Study INTEGER NOT NULL
	) ;	
	
	
CREATE TABLE ROOMS (
    Room_Name VARCHAR2(20)
        CONSTRAINT PK_ROOMS PRIMARY KEY,
    N_of_Seats INTEGER
	) ;		
	
CREATE TABLE SCHEDULED_EXAMS (
    Exam_Id Number(10)
        CONSTRAINT PK_SCHEDULED_EXAMS PRIMARY KEY,
    Exam_Timestamp TIMESTAMP NOT NULL,
    Prog_Abbreviation VARCHAR(15)
		CONSTRAINT FK_EXAM_AB_SPEC REFERENCES PROGRAMMES(Prog_Abbreviation),
	Year_of_Study INTEGER NOT NULL,		
	Course_Code VARCHAR(10) 
		CONSTRAINT FK_EXAM_COD_DISC REFERENCES COURSES(Course_Code)
	) ;	
	
CREATE TABLE STUD_ROOMS (
	Exam_Id NUMBER(10) 
		CONSTRAINT FK_STUD_ROOMS_ID_EX REFERENCES SCHEDULED_EXAMS(Exam_Id),
  Stud_Id Number(10)
		CONSTRAINT FK_STUD_ROOMS_ID_STUD REFERENCES STUDENTS (Stud_Id),
	Room_Name VARCHAR2(20)
		CONSTRAINT FK_STUD_ROOMS_SALA REFERENCES ROOMS(Room_Name),	
  CONSTRAINT PK_STUD_ROOMS PRIMARY KEY (Exam_Id, Stud_Id)
	) ;	
	
INSERT INTO programmes VALUES ('IE', 'Business Informatics', 'U') ;
INSERT INTO programmes VALUES ('SPE', 'Statistics', 'U') ;
INSERT INTO programmes VALUES ('CIG', 'Accounting', 'U') ;
INSERT INTO programmes VALUES ('SDBIS', 'Software Development and Business Information Systems', 'M') ;

INSERT INTO courses VALUES ('BD', 'Databases', 6) ;
INSERT INTO courses VALUES ('MICROEC', 'Microeconomics', 6) ;
INSERT INTO courses VALUES ('FINMAG', 'Financial Management', 6) ;



-- insert 170 students for `Business Informatics` Programe (2nd Year of Study)
BEGIN 
	FOR i IN 1..170 LOOP
		INSERT INTO students VALUES (1000 + i, 'Stud ' || i || ' - Info Ec 2', 'IE', 2) ;
	END LOOP ;
END ;
/	
		
-- insert 85 students for `Statistics` Programe (2nd Year of Study)
BEGIN 
	FOR i IN 1..85 LOOP
		INSERT INTO students VALUES (2000 + i, 'Stud ' || i || ' - Statisitcs 2', 'SPE', 2) ;
	END LOOP ;
END ;
/	
		
	
INSERT INTO rooms VALUES('B5', 150) ;
INSERT INTO rooms VALUES('B1', 140) ;
INSERT INTO rooms VALUES('B6', 160) ;
INSERT INTO rooms VALUES('B8', 130) ;
INSERT INTO rooms VALUES('B3', 144) ;
INSERT INTO rooms VALUES('B4', 125) ;
INSERT INTO rooms VALUES('B604', 100) ;
INSERT INTO rooms VALUES('B601', 90) ;
INSERT INTO rooms VALUES('B325', 20) ;
INSERT INTO rooms VALUES('B324A', 30) ;
INSERT INTO rooms VALUES('B310', 60) ;
INSERT INTO rooms VALUES('B328', 25) ;
INSERT INTO rooms VALUES('B329', 25) ;


-- Two schduled exams for 8:00-10:00 time slot on the 16th of January 2018
INSERT INTO SCHEDULED_EXAMS VALUES (1, TIMESTAMP'2018-01-16 08:00:00', 'IE', 2, 'BD') ;
INSERT INTO SCHEDULED_EXAMS VALUES (2, TIMESTAMP'2018-01-16 08:00:00', 'SPE', 2, 'BD') ;

COMMIT ;



	
		