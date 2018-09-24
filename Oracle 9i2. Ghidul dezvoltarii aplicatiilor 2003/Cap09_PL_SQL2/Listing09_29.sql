DECLARE
 v_marca personal.marca%TYPE ;
 v_data pontaje.data%TYPE ;
 v_an salarii.an%TYPE ;
 v_luna salarii.luna%TYPE ;

BEGIN
 v_marca := 101 ;
 -- cautare in PERSONAL 
 IF pachet_exista.f_exista (v_marca) THEN 
   DBMS_OUTPUT.PUT_LINE('In PERSONAL exista angajat cu marca ' || v_marca) ; 
 ELSE
    DBMS_OUTPUT.PUT_LINE('In PERSONAL NU exista angajat cu marca ' || v_marca) ; 
 END IF ;
 
 -- cautare in PONTAJE
 v_data := TO_DATE('07/01/2003','DD/MM/YYYY') ;
 IF pachet_exista.f_exista (v_marca, v_data) THEN 
   DBMS_OUTPUT.PUT_LINE('In PONTAJE exista inregistrare pentru marca ' ||
     v_marca || ' si ziua '|| v_data) ; 
 ELSE
   DBMS_OUTPUT.PUT_LINE('In PONTAJE NU exista inregistrare pentru marca ' ||
     v_marca || ' si ziua '|| v_data) ; 
 END IF ;

 -- cautare in SPORURI, RETINERI, SALARII
 v_an := 2002 ;
 v_luna := 5 ; 
 IF pachet_exista.f_exista (v_marca, v_an, v_luna, 'SALARII') THEN 
   DBMS_OUTPUT.PUT_LINE('In SALARII exista inregistrare pentru marca ' ||
     v_marca || ', anul '|| v_an || ' si luna ' || v_luna) ; 
  ELSE
   DBMS_OUTPUT.PUT_LINE('In SALARII NU exista inregistrare pentru marca ' ||
     v_marca || ', anul '|| v_an || ' si luna ' || v_luna) ; 
  END IF ;
  
END ;   

/

