DELETE FROM salarii ;
DELETE FROM retineri ;
DELETE FROM sporuri ;
DELETE FROM pontaje ;
DELETE FROM personal ;

INSERT INTO personal VALUES (101, 'Angajat 1', 'IT', TO_DATE('12/10/1980', 'DD/MM/YYYY'),56000, 55000, 'N') ;
INSERT INTO personal VALUES (102, 'Angajat 2', 'CONTA', TO_DATE('12/11/1978', 'DD/MM/YYYY'),57500, 56000, 'N') ;
INSERT INTO personal VALUES (103, 'Angajat 3', 'IT', TO_DATE('02/07/1976', 'DD/MM/YYYY'),67500, 66000, 'N' ) ;
INSERT INTO personal VALUES (104, 'Angajat 4', 'PROD', TO_DATE('05/01/1982', 'DD/MM/YYYY'),67500, 66000, 'N' ) ;
INSERT INTO personal VALUES (105, 'Angajat 5', 'IT', TO_DATE('12/11/1977', 'DD/MM/YYYY'),62500, 62000, 'N' ) ;
INSERT INTO personal VALUES (106, 'Angajat 6', 'CONTA', TO_DATE('11/04/1985', 'DD/MM/YYYY'),71500, 70000, 'N' ) ;
INSERT INTO personal VALUES (107, 'Angajat 7', 'CONTA', TO_DATE('21/11/1991', 'DD/MM/YYYY'),61500, 60000, 'N' ) ;
INSERT INTO personal VALUES (108, 'Angajat 8', 'PROD', TO_DATE('30/12/1994', 'DD/MM/YYYY'),54500, 52000, 'N' ) ;


begin 
FOR i IN 100..999 LOOP
 INSERT INTO personal VALUES (i * 10 + 1, 'Angajat '||(i*10 + 1), 'PERS', TO_DATE('11/04/1982', 'DD/MM/YYYY'),44600, 44500, 'N' ) ; 
 INSERT INTO personal VALUES (i * 10 + 2, 'Angajat '||(i*10 + 2), 'PROD', TO_DATE('10/12/1987', 'DD/MM/YYYY'),45600, 45500, 'N' ) ; 
 INSERT INTO personal VALUES (i * 10 + 3, 'Angajat '||(i*10 + 3), 'MARK', TO_DATE('01/07/1990', 'DD/MM/YYYY'),46600, 45500, 'N' ) ; 
 INSERT INTO personal VALUES (i * 10 + 4, 'Angajat '||(i*10 + 4), 'IT', TO_DATE('20/08/1994', 'DD/MM/YYYY'),47600, 46500, 'N' ) ; 
 INSERT INTO personal VALUES (i * 10 + 5, 'Angajat '||(i*10 + 5), 'PROD', TO_DATE('11/10/1994', 'DD/MM/YYYY'),48600, 47000, 'N' ) ; 
 INSERT INTO personal VALUES (i * 10 + 6, 'Angajat '||(i*10 + 6), 'CONTA', TO_DATE('23/11/1989', 'DD/MM/YYYY'),43600, 42000, 'N' ) ; 
END LOOP ;

COMMIT ;
end ;
