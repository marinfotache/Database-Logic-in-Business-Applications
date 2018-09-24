CREATE OR REPLACE PACKAGE BODY pachet_exista AS

-- prima forma verifica existenta (marcii) in PERSONAL 
FUNCTION f_exista (
 marca_ personal.marca%TYPE) RETURN BOOLEAN
IS
 v_unu NUMBER(1) ;
BEGIN
 SELECT 1 INTO v_unu FROM personal WHERE marca = marca_ ;
 RETURN TRUE ;
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 RETURN FALSE ;
END f_exista ;

-- a doua forma verifica existenta (marcii/zilei) in PONTAJE
FUNCTION f_exista (
 marca_ personal.marca%TYPE,
 data_ pontaje.data%TYPE) RETURN BOOLEAN
IS
 v_unu NUMBER(1) ;
BEGIN
 SELECT 1 INTO v_unu FROM pontaje WHERE marca = marca_ AND data=data_;
 RETURN TRUE ;
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 RETURN FALSE ;
END f_exista ;

-- a treia forma verifica existenta combinatiei (marca/an/luna) intr-una
-- din tabelele SPORURI, RETINERI, SALARII
FUNCTION f_exista (
 marca_ personal.marca%TYPE, an_ salarii.an%TYPE, luna_ salarii.luna%TYPE,
 tabela_ VARCHAR2) RETURN BOOLEAN
IS
 v_unu NUMBER(1) ;
BEGIN
  CASE
  WHEN UPPER(tabela_) = 'SPORURI' THEN 
    SELECT 1 INTO v_unu FROM sporuri 
    WHERE marca=marca_ AND an=an_ AND luna=luna_ ;
  WHEN UPPER(tabela_) = 'RETINERI' THEN 
    SELECT 1 INTO v_unu FROM retineri 
    WHERE marca=marca_ AND an=an_ AND luna=luna_ ;
  WHEN UPPER(tabela_) = 'SALARII' THEN 
    SELECT 1 INTO v_unu FROM salarii 
    WHERE marca=marca_ AND an=an_ AND luna=luna_ ;
  END CASE ;
  RETURN TRUE ;
EXCEPTION 
 WHEN NO_DATA_FOUND THEN 
 RETURN FALSE ;
END f_exista ;


END pachet_exista ;

