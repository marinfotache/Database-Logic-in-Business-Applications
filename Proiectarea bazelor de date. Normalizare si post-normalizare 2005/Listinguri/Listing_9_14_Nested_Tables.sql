DROP TABLE clienti3;
DROP TYPE nt_adrese_email ;
DROP TYPE nt_telefoane ;

CREATE TYPE nt_telefoane AS TABLE OF CHAR(11) 
/

CREATE TYPE nt_adrese_email AS TABLE OF VARCHAR2(30) 
/

CREATE TABLE CLIENTI3 (
	CodCl NUMBER(6) PRIMARY KEY, 
	DenCl VARCHAR2(40), 
	CodFiscal CHAR(8), 
	StradaCl VARCHAR2(30), 
	NrStadaCl VARCHAR2(7),  
	BlocScApCl VARCHAR2(25), 
	CodPost NUMBER(6), 
	Telefoane nt_telefoane, 
	eMailuri nt_adrese_email
	) 
NESTED TABLE telefoane STORE AS telefoane_tab,	
NESTED TABLE eMailuri STORE AS eMailuri_tab
/

INSERT INTO clienti3 VALUES (1001, 'Client 1', 'R133303', 'Sapientei',
	'22bis', NULL, 710710, 
	nt_telefoane('0232344444', '0788881919', '0744444444'),
	nt_adrese_email('client1@k.ro', 'client.1@yahoo.com')
	 ) ; 
INSERT INTO clienti3 VALUES (1002, 'Client 2', 'R1344533', 'Pacientei',
	'13bis', 'Bl.H, Sc.B, Ap.5', 710705, 
	nt_telefoane('0239344554', '0723881919', '0722444444', '0744456789'),
	nt_adrese_email('client2@hotmail.ro', 'client2@yahoo.com')
	 ) ; 

SELECT * FROM clienti3 c ;

SELECT * 
FROM TABLE (SELECT c.telefoane FROM clienti3 c
		WHERE c.codcl=1002) x ;

SELECT c.dencl, t.*
FROM clienti3 c, TABLE(c.telefoane) t WHERE codcl=1002 ;


SELECT c.codcl, t.*
FROM clienti3 c, TABLE(c.telefoane) t  ;



