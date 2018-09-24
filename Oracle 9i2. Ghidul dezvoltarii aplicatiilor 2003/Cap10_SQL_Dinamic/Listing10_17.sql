CREATE OR REPLACE FUNCTION f_nr_linii  (
  tabela IN VARCHAR2, 
  conditie IN VARCHAR2 ) RETURN INTEGER
IS
    v_rezultat INTEGER;
BEGIN
  EXECUTE IMMEDIATE 'SELECT COUNT(*)  FROM ' || tabela || ' WHERE ' || 
   NVL (conditie, '1=1') INTO v_rezultat ;
  RETURN v_rezultat ;
END;

