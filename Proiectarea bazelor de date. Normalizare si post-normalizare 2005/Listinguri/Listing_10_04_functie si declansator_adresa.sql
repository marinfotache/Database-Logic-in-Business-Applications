CREATE OR REPLACE FUNCTION f_data_ultimei_modif (
	codcl_ clienti2.CodCl%TYPE,
	atribut_ VARCHAR2) RETURN DATE 
AS
	v_data DATE ;
	v_tabela VARCHAR2(20) ;
BEGIN
	CASE atribut_
	WHEN 'StradaCl' THEN 
		v_tabela := 'CLIENTI_STRAZI';
	WHEN 'NrStradaCl' THEN 
		v_tabela := 'CLIENTI_NR';
	WHEN 'BlocScApCl' THEN 
		v_tabela := 'CLIENTI_BLOC';
	WHEN 'Telefon' THEN 
		v_tabela := 'CLIENTI_TEL';
	WHEN 'CodPost' THEN 
		v_tabela := 'CLIENTI_CODPOST';
	END CASE ;

	EXECUTE IMMEDIATE 'SELECT MAX(DataFinala)  FROM '
		|| v_tabela || ' WHERE CodCl = :1 ' INTO v_data USING codcl_ ;
	RETURN v_data ;
END ;
/


-------------------------------------------------------------------
-- modificarea unui element din adresa in tabele CLIENTI
CREATE OR REPLACE TRIGGER trg_clienti_upd2
	AFTER UPDATE OF StradaCl, NrStradaCl, BlocScApCl,
	Telefon, CodPost ON clienti2 FOR EACH ROW
BEGIN
	-- s-a modificat strada ?
	IF NVL(:NEW.StradaCl,' ') <> NVL(:OLD.StradaCl,' ') THEN
		INSERT INTO clienti_strazi VALUES (:OLD.CodCl, NVL(:OLD.StradaCl,' '),
		NVL(f_data_ultimei_modif (:OLD.CodCl, 'StradaCl'), DATE'1990-01-01'),
		SYSDATE);
	END IF ;

	-- s-a modificat numarul ?
	IF NVL(:NEW.NrStradaCl,' ') <> NVL(:OLD.NrStradaCl,' ') THEN
		INSERT INTO clienti_nr VALUES (:OLD.CodCl,NVL(:OLD.NrStradaCl,' '),
		NVL(f_data_ultimei_modif (:OLD.CodCl, 'NrStradaCl'), DATE'1990-01-01'),
		SYSDATE);
	END IF ;

	-- s-a modificat blocul/scara/apartamentul ?
	IF NVL(:NEW.BlocScApCl,' ') <> NVL(:OLD.BlocScApCl,' ') THEN
		INSERT INTO clienti_bloc VALUES (:OLD.CodCl,NVL(:OLD.BlocScApCl,' ') ,
		NVL(f_data_ultimei_modif (:OLD.CodCl, 'BlocScApCl'), DATE'1990-01-01'),
		SYSDATE);
	END IF ;

	-- s-a modificat numarul de telefon ?
	IF NVL(:NEW.Telefon, ' ') <> NVL(:OLD.Telefon,' ') THEN
		INSERT INTO clienti_tel VALUES (:OLD.CodCl,NVL(:OLD.Telefon, ' '),
		NVL(f_data_ultimei_modif (:OLD.CodCl, 'Telefon'), DATE'1990-01-01'),
		SYSDATE);
	END IF ;

	-- s-a modificat codul postal ?
	IF NVL(:NEW.CodPost,0) <> NVL(:OLD.CodPost,0) THEN
		INSERT INTO clienti_codpost VALUES (:OLD.CodCl, NVL(:OLD.CodPost,0),
		NVL(f_data_ultimei_modif (:OLD.CodCl, 'CodPost'), DATE'1990-01-01'),
		SYSDATE);
	END IF ;
END ;
/

select * from clienti2;
select * from clienti_strazi;
select * from clienti_nr;
select * from clienti_bloc ;
select * from clienti_tel;
select * from clienti_codpost ;

UPDATE clienti2 SET stradacl='Strada 1' WHERE codcl=1001;

UPDATE clienti2 SET stradacl='Strada 2', NrStradaCl='2bis', BLOCSCAPCL='Bloc H3, Sc.A, ap.4',
telefon='2222222', codpost=700506 where codcl=1002 ;

UPDATE clienti2 SET stradacl='Strada 3', NrStradaCl='3bis', BLOCSCAPCL='Bloc H33, Sc.C, ap.3',
telefon='3333333', codpost=700506 where codcl=1003 ;

UPDATE clienti2 SET stradacl='Strada 1 noua', NrStradaCl='1B', BLOCSCAPCL='Bloc H1, Sc.A, ap.1',
	codpost=700506 where codcl=1001 ;


INSERT INTO clienti2 VALUES (1004, 'Cl 4', 'R4', NULL, NULL, NULL, NULL, 700505);
INSERT INTO clienti2 VALUES (1005, 'Cl 5', 'R4', 'Str.5', NULL, NULL, NULL, 700505);

UPDATE clienti2 SET stradacl='Strada 4' WHERE codcl=1004;

UPDATE clienti2 SET stradacl='Strada 44' WHERE codcl=1004;

UPDATE clienti2 SET nrstradacl='4C' WHERE codcl=1004;

