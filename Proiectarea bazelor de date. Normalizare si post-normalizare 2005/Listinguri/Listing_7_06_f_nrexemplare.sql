CREATE OR REPLACE FUNCTION f_NrExemplare (
 isbn_ titluri.isbn%TYPE) RETURN NUMBER
IS 
 v_nr NUMBER(4) := 0 ;
BEGIN 
 SELECT nrexemplare INTO v_nr
 FROM titluri WHERE isbn=isbn_ ;
 RETURN v_nr ;
END ; 
