DROP TABLE increases ;
DROP TABLE employees ;


CREATE TABLE employees (
	empId NUMERIC(5) NOT NULL CONSTRAINT pk_employees PRIMARY KEY,
	empName VARCHAR(40) NOT NULL,
	dateOfBirth DATE,
	department VARCHAR(20),
	managerId NUMERIC(5)  CONSTRAINT fk_employees2 REFERENCES employees (empId),
	baseSalary NUMERIC(12,2)   
	) ;

CREATE TABLE increases ( 
	year NUMERIC(4) NOT NULL,
	month NUMERIC(2) NOT NULL,
	empId NUMERIC(5) NOT NULL
		CONSTRAINT fk_increases_employees REFERENCES employees (empId),
	fidelityIncrease NUMERIC(12,2),  -- increase for year of experience within company (fidelity)
	nightIncrease NUMERIC(12,2),  -- increase for working overnight
	heavyActivIncrease NUMERIC(12,2),  -- increase for activities in heavy environments (storms, freeze)
	miscIncrease NUMERIC(12,2),   -- miscellaneous increase (others that above)
	CONSTRAINT pk_increases PRIMARY KEY (year,month,empId)  ) ;

INSERT INTO employees VALUES (1, 'employee 1', DATE'1962-07-01',  
	'CEO', NULL, 1600) ;  -- this is the chief executive officer
INSERT INTO employees VALUES (2, 'employee 2', DATE'1977-10-11',  'finance', 1, 1450) ;
INSERT INTO employees VALUES (3, 'employee 3', DATE'1962-08-02', 'sales', 1, 1450) ;
INSERT INTO employees VALUES (4, 'employee 4', NULL, 'finance', 2, 1380) ;
INSERT INTO employees VALUES (5, 'employee 5', DATE'1965-04-30', 'finance', 2, 1420) ;
INSERT INTO employees VALUES (6, 'employee 6', DATE'1965-11-09',  'finance', 5, 1350) ;
INSERT INTO employees VALUES (7, 'employee 7', NULL, 'finance', 5, 1280) ;
INSERT INTO employees VALUES (8, 'employee 8', DATE'1960-12-31', 'sales', 3, 1290) ;
INSERT INTO employees VALUES (9, 'employee 9', DATE'1976-02-28', 'sales', 3, 1410) ;
INSERT INTO employees VALUES (10, 'employee 10', DATE'1972-01-29', 
	'HRM',  1, 1370) ;  -- Human Resouce Management responsible

INSERT INTO increases VALUES (2014, 4, 1, 160, 0, 0, 132) ;
INSERT INTO increases VALUES (2014, 4, 2, 130, 45, 0, 70) ;
INSERT INTO increases VALUES (2014, 4, 3, 145, 156, 420, 157) ;
INSERT INTO increases VALUES (2014, 5, 1, 160, 0, 0, 0) ;

INSERT INTO increases VALUES (2014, 5, 2, 80, 45, 0, 70) ;
INSERT INTO increases VALUES (2014, 5, 3, 145, 0, 0, 0) ;
INSERT INTO increases VALUES (2014, 5, 10, 137, 0, 0, 430) ;
INSERT INTO increases VALUES (2014, 6, 1, 160, 0, 0, 0) ;
INSERT INTO increases VALUES (2014, 6, 2,  80, 0, 0, 150) ;
INSERT INTO increases VALUES (2014, 6, 4, 50, 15, 88, 120) ;
INSERT INTO increases VALUES (2014, 6, 5, 130, 15, 0, 20) ;
INSERT INTO increases VALUES (2014, 6, 10, 200, 12, 0, 6) ;
INSERT INTO increases VALUES (2014, 7, 1, 160, 0, NULL, NULL) ;
INSERT INTO increases VALUES (2014, 7, 2, 80, 0, 0, 158) ;
INSERT INTO increases VALUES (2014, 7, 3, 145, 0, 0, 0) ;
INSERT INTO increases VALUES (2014, 7, 4, 50, 15, NULL, 15) ;
INSERT INTO increases VALUES (2014, 7, 5, 130, 0, 0, 120) ;
INSERT INTO increases VALUES (2014, 7, 6, 110, 147, 0, 0) ;
INSERT INTO increases VALUES (2014, 7, 7, 60, 210, 0, 0) ;
INSERT INTO increases VALUES (2014, 7, 8, 130, 0, 15, 0) ;
INSERT INTO increases VALUES (2014, 7, 9, 140, 100, 77, 0) ;
INSERT INTO increases VALUES (2014, 7, 10, 200, 0, 0, 120) ;

