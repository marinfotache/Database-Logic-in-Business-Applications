CREATE OR REPLACE PACKAGE pachet_exista AS

-- prima forma verifica existenta (marcii) in PERSONAL 
FUNCTION f_exista (
  marca_ personal.marca%TYPE) RETURN BOOLEAN ;

-- a doua forma verifica existenta (marcii/zilei) in PONTAJE
FUNCTION f_exista (
 marca_ personal.marca%TYPE,
 data_ pontaje.data%TYPE) RETURN BOOLEAN ;

-- a treia forma verifica existenta combinatiei (marca/an/luna) intr-una
-- din tabelele SPORURI, RETINERI, SALARII
FUNCTION f_exista (
 marca_ personal.marca%TYPE, an_ salarii.an%TYPE, luna_ salarii.luna%TYPE,
 tabela_ VARCHAR2) RETURN BOOLEAN ;

END pachet_exista ;
