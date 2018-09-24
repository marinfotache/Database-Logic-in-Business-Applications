/* Al doilea exemplu de cursor implicit */
DECLARE
 marca_etalon personal.marca%TYPE := 1011  ;
 v_nume personal.numepren%TYPE ;
BEGIN 

 /* in cazul SELECT-ului, daca nu exista nici o inregistrare care 
 sa indeplineasca conditia, se declanseaza exceptia */
 SELECT numepren 
 INTO v_nume 
 FROM personal
 WHERE marca = marca_etalon ;
 
 -- in acest punct se ajunge numai daca SELECT-ul extrage o inregistrare
 IF SQL%FOUND THEN 
     DBMS_OUTPUT.PUT_LINE('Exista angajatul cu marca'|| marca_etalon)   ;
  ELSE
     -- aceasta ramura nu se va executa niciodata, din cauza excepriei NO_DATA_FOUND
     DBMS_OUTPUT.PUT_LINE('Nu exista angajatul cu marca'|| marca_etalon)   ;
  END IF  ;
 
EXCEPTION
 WHEN NO_DATA_FOUND THEN 
  -- aici sare executia blocului daca SELECT-ul nu extrage nici o linie
  DBMS_OUTPUT.PUT_LINE('Nu exista angajatul cu marca '|| marca_etalon)   ;
END;
/
