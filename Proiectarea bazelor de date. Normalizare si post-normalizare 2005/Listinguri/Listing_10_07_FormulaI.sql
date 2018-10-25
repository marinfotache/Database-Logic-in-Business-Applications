DROP TABLE rezultate_curse ;
DROP TABLE curse ;
DROP TABLE locuri_puncte ;
DROP TABLE piloti_echipe ;
DROP TABLE piloti ;
DROP TABLE circuite ;

CREATE TABLE circuite (
 IdCircuit NUMBER(5) NOT NULL PRIMARY KEY, 
 DenCircuit VARCHAR2(50) NOT NULL UNIQUE, 
 Localitate VARCHAR2(40), 
 Tara VARCHAR2(30), 
 LungimePista NUMBER(5), 
 NrTururi NUMBER(3)
 );

CREATE TABLE piloti (
 IdPilot NUMBER(10) NOT NULL PRIMARY KEY,
 NumePilot VARCHAR2(50) NOT NULL UNIQUE, 
 Nationalitate VARCHAR(25)	 
 );

CREATE TABLE piloti_echipe (
 IdPilot NUMBER(10) NOT NULL REFERENCES piloti(IdPilot),
 Sezon NUMBER(4) NOT NULL CHECK (Sezon > 1970),	
 Echipa VARCHAR2(30) NOT NULL,
 PRIMARY KEY (IdPilot, Sezon)		
 );

CREATE TABLE locuri_puncte (
 PozitieSosire NUMBER(3) PRIMARY KEY CHECK (PozitieSosire > 0), 
 PunctePozitie NUMBER(3)
 );

CREATE TABLE curse (
 IdCursa NUMBER(10) NOT NULL PRIMARY KEY, 
 DataCursa DATE DEFAULT CURRENT_DATE NOT NULL,
 Sezon NUMBER(4) NOT NULL CHECK (Sezon > 1970),
 Etapa NUMBER(2) NOT NULL CHECK (Etapa > 0),	
 IdCircuit NUMBER(5) NOT NULL REFERENCES circuite (IdCircuit)
 );
 
CREATE TABLE rezultate_curse (
 IdCursa NUMBER(10) NOT NULL REFERENCES curse (IdCursa), 
 IdPilot NUMBER(10) NOT NULL REFERENCES piloti (IdPilot),
 PozitieSosire NUMBER(3) NOT NULL CHECK (PozitieSosire BETWEEN 1 AND 50), 
 PuncteCursa NUMBER(3),
 PunctePenalizare NUMBER(3),
 PRIMARY KEY (IdCursa, IdPilot)
 );

INSERT INTO circuite VALUES (501, 'Esperanza', 'Gonnard', 'Scotia', 3420, 50);
INSERT INTO circuite VALUES (502, 'George Martin', 'Yull', 'Anglia', 3800, 47);
INSERT INTO circuite VALUES (503, 'Yellow', 'Strachan', 'Anglia', 4220, 45);

INSERT INTO piloti VALUES (1701, 'Slash Gordon', 'Losers');
INSERT INTO piloti VALUES (1702, 'Flash Hook', 'Losers');
INSERT INTO piloti VALUES (1703, 'Yourdon Luke', 'Losers');
INSERT INTO piloti VALUES (1704, 'Nonaka John', 'Pistons');
INSERT INTO piloti VALUES (1705, 'Benjamin Walter', 'Pistons');

INSERT INTO piloti_echipe VALUES (1701, 2000, 'Pistons');
INSERT INTO piloti_echipe VALUES (1701, 2001, 'Pistons');
INSERT INTO piloti_echipe VALUES (1701, 2002, 'Losers');
INSERT INTO piloti_echipe VALUES (1701, 2003, 'Losers');
INSERT INTO piloti_echipe VALUES (1701, 2004, 'Pistons');

INSERT INTO piloti_echipe VALUES (1702, 2000, 'Pistons');
INSERT INTO piloti_echipe VALUES (1702, 2001, 'Pistons');
INSERT INTO piloti_echipe VALUES (1702, 2002, 'Pistons');
INSERT INTO piloti_echipe VALUES (1702, 2003, 'Pistons');
INSERT INTO piloti_echipe VALUES (1702, 2004, 'Pistons');

INSERT INTO piloti_echipe VALUES (1703, 2000, 'Losers');
INSERT INTO piloti_echipe VALUES (1703, 2001, 'Losers');
INSERT INTO piloti_echipe VALUES (1703, 2002, 'Pistons');
INSERT INTO piloti_echipe VALUES (1703, 2003, 'Losers');
INSERT INTO piloti_echipe VALUES (1703, 2004, 'Losers');

INSERT INTO piloti_echipe VALUES (1704, 2000, 'Hippies');
INSERT INTO piloti_echipe VALUES (1704, 2001, 'Skinnies');
INSERT INTO piloti_echipe VALUES (1704, 2002, 'Skinnies');
INSERT INTO piloti_echipe VALUES (1704, 2003, 'Hippies');
INSERT INTO piloti_echipe VALUES (1704, 2004, 'Skinnies');

INSERT INTO piloti_echipe VALUES (1705, 2000, 'Skinnies');
INSERT INTO piloti_echipe VALUES (1705, 2001, 'Hippies');
INSERT INTO piloti_echipe VALUES (1705, 2002, 'Hippies');
INSERT INTO piloti_echipe VALUES (1705, 2003, 'Skinnies');
INSERT INTO piloti_echipe VALUES (1705, 2004, 'Hippies');

INSERT INTO locuri_puncte VALUES (1, 10);
INSERT INTO locuri_puncte VALUES (2, 8);
INSERT INTO locuri_puncte VALUES (3, 6);
INSERT INTO locuri_puncte VALUES (4, 5);
INSERT INTO locuri_puncte VALUES (5, 4);
INSERT INTO locuri_puncte VALUES (6, 3);
INSERT INTO locuri_puncte VALUES (7, 2);
INSERT INTO locuri_puncte VALUES (8, 1);


INSERT INTO curse VALUES (9001, DATE'2000-03-23', 2000, 1, 501) ;
INSERT INTO curse VALUES (9002, DATE'2000-04-18', 2000, 2, 502) ;
INSERT INTO curse VALUES (9003, DATE'2000-05-29', 2000, 3, 503) ;
INSERT INTO curse VALUES (9004, DATE'2001-03-19', 2001, 1, 501) ;
INSERT INTO curse VALUES (9005, DATE'2001-04-21', 2001, 2, 502) ;
INSERT INTO curse VALUES (9006, DATE'2001-05-26', 2001, 3, 503) ;
INSERT INTO curse VALUES (9007, DATE'2002-03-16', 2002, 1, 501) ;
INSERT INTO curse VALUES (9008, DATE'2002-04-17', 2002, 2, 502) ;
INSERT INTO curse VALUES (9009, DATE'2002-05-18', 2002, 3, 503) ;
INSERT INTO curse VALUES (9010, DATE'2003-03-23', 2003, 1, 501) ;
INSERT INTO curse VALUES (9011, DATE'2003-04-24', 2003, 2, 502) ;
INSERT INTO curse VALUES (9012, DATE'2003-05-25', 2003, 3, 503) ;
INSERT INTO curse VALUES (9013, DATE'2004-03-23', 2004, 1, 501) ;
INSERT INTO curse VALUES (9014, DATE'2004-04-17', 2004, 2, 502) ;
INSERT INTO curse VALUES (9015, DATE'2004-05-28', 2004, 3, 503) ;

CREATE TABLE rezultate_curse (
 IdCursa NUMBER(10) NOT NULL REFERENCES curse (IdCursa), 
 IdPilot NUMBER(10) NOT NULL REFERENCES piloti (IdPilot),
 PozitieSosire NUMBER(3) NOT NULL CHECK (PozitieSosire BETWEEN 1 AND 50), 
 PuncteCursa NUMBER(3),
 PunctePenalizare NUMBER(3),
 PRIMARY KEY (IdCursa, IdPilot)
 );


-- 2000
INSERT INTO rezultate_curse VALUES (9001, 1701, 1, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9001, 1702, 2, 7, 0) ;
INSERT INTO rezultate_curse VALUES (9001, 1703, 3, 6, 0) ;
INSERT INTO rezultate_curse VALUES (9001, 1704, 4, 5, 0) ;
INSERT INTO rezultate_curse VALUES (9001, 1705, 5, 4, 0) ;

INSERT INTO rezultate_curse VALUES (9002, 1705, 1, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9002, 1703, 2, 7, 0) ;
INSERT INTO rezultate_curse VALUES (9002, 1702, 3, 6, 0) ;
INSERT INTO rezultate_curse VALUES (9002, 1701, 4, 5, 0) ;
INSERT INTO rezultate_curse VALUES (9002, 1704, 5, 4, 0) ;

INSERT INTO rezultate_curse VALUES (9003, 1702, 1, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9003, 1703, 2, 7, 0) ;
INSERT INTO rezultate_curse VALUES (9003, 1704, 3, 6, 0) ;
INSERT INTO rezultate_curse VALUES (9003, 1705, 4, 5, 0) ;
INSERT INTO rezultate_curse VALUES (9003, 1701, 5, 4, 0) ;


-- 2001
INSERT INTO rezultate_curse VALUES (9004, 1701, 1, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9004, 1702, 2, 7, 0) ;
INSERT INTO rezultate_curse VALUES (9004, 1703, 3, 6, 0) ;
INSERT INTO rezultate_curse VALUES (9004, 1704, 4, 5, 0) ;

INSERT INTO rezultate_curse VALUES (9005, 1705, 1, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9005, 1703, 2, 7, 0) ;
INSERT INTO rezultate_curse VALUES (9005, 1701, 3, 6, 0) ;

INSERT INTO rezultate_curse VALUES (9006, 1702, 1, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9006, 1703, 2, 7, 0) ;
INSERT INTO rezultate_curse VALUES (9006, 1704, 3, 6, 0) ;
INSERT INTO rezultate_curse VALUES (9006, 1705, 4, 5, 0) ;
INSERT INTO rezultate_curse VALUES (9006, 1701, 5, 4, 0) ;


-- 2002
INSERT INTO rezultate_curse VALUES (9007, 1701, 1, 10, 0) ;
INSERT INTO rezultate_curse VALUES (9007, 1702, 2, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9007, 1703, 3, 6, 0) ;
INSERT INTO rezultate_curse VALUES (9007, 1704, 4, 5, 0) ;
INSERT INTO rezultate_curse VALUES (9007, 1705, 5, 4, 0) ;

INSERT INTO rezultate_curse VALUES (9008, 1701, 1, 10, 8) ;
INSERT INTO rezultate_curse VALUES (9008, 1702, 2, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9008, 1704, 3, 6, 0) ;
INSERT INTO rezultate_curse VALUES (9008, 1705, 4, 5, 0) ;

INSERT INTO rezultate_curse VALUES (9009, 1705, 1, 10, 0) ;
INSERT INTO rezultate_curse VALUES (9009, 1702, 2, 8, 0) ;
INSERT INTO rezultate_curse VALUES (9009, 1704, 3, 6, 0) ;
INSERT INTO rezultate_curse VALUES (9009, 1703, 4, 5, 0) ;
INSERT INTO rezultate_curse VALUES (9009, 1701, 5, 4, 0) ;

COMMIT ;

SELECT ROWNUM, t.*
FROM 
	(SELECT NumePilot, SUM(PuncteCursa) AS Puncte, 
		SUM(PunctePenalizare) AS Penalizari,
 		SUM(PuncteCursa - PunctePenalizare) AS Total
	FROM rezultate_curse rc INNER JOIN curse c ON rc.IdCursa=c.IdCursa
		INNER JOIN piloti p ON rc.IdPilot=p.IdPilot
	WHERE sezon=2002 AND Etapa <= 2
	GROUP BY NumePilot
	ORDER BY Total DESC) t