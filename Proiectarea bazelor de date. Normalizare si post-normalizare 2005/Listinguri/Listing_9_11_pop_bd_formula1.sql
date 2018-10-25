
DELETE FROM rezultate_curse ;
DELETE FROM curse ;
DELETE FROM locuri_puncte ;
DELETE FROM piloti ;
DELETE FROM circuite ;

INSERT INTO circuite VALUES (501, 'Esperanza', 'Gonnard', 'Scotia', 3420, 50);
INSERT INTO circuite VALUES (502, 'George Martin', 'Yull', 'Anglia', 3800, 47);
INSERT INTO circuite VALUES (503, 'Yellow', 'Strachan', 'Anglia', 4220, 45);

INSERT INTO piloti VALUES (1701, 'Slash Gordon', 'Losers');
INSERT INTO piloti VALUES (1702, 'Flash Hook', 'Losers');
INSERT INTO piloti VALUES (1703, 'Yourdon Luke', 'Losers');
INSERT INTO piloti VALUES (1704, 'Nonaka John', 'Pistons');
INSERT INTO piloti VALUES (1705, 'Benjamin Walter', 'Pistons');

INSERT INTO locuri_puncte VALUES (1, 10);
INSERT INTO locuri_puncte VALUES (2, 8);
INSERT INTO locuri_puncte VALUES (3, 6);
INSERT INTO locuri_puncte VALUES (4, 5);
INSERT INTO locuri_puncte VALUES (5, 4);
INSERT INTO locuri_puncte VALUES (6, 3);
INSERT INTO locuri_puncte VALUES (7, 2);
INSERT INTO locuri_puncte VALUES (8, 1);

INSERT INTO curse VALUES (9001, DATE '2004-03-23', 501) ;
INSERT INTO curse VALUES (9002, DATE '2004-04-10', 502) ;
INSERT INTO curse VALUES (9003, DATE '2004-04-29', 503) ;
INSERT INTO curse VALUES (9004, DATE '2004-05-11', 501) ;
INSERT INTO curse VALUES (9005, DATE '2004-05-20', 502) ;

INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9001, 1, 1701) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9001, 2, 1704) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9001, 3, 1703) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9001, 5, 1705) ;

INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9002, 1, 1701) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9002, 2, 1702) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9002, 3, 1703) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9002, 5, 1704) ;

INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9003, 1, 1703) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9003, 2, 1701) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9003, 3, 1702) ;
INSERT INTO rezultate_curse (IdCursa, PozitieSosire, IdPilot) VALUES (9003, 5, 1704) ;

COMMIT ;
