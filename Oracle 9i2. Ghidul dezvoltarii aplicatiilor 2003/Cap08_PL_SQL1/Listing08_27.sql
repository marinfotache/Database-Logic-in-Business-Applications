-- populare tabelei PONTAJE - folosirea colectiilor si clauzelor BULK COLLECT si FORALL
DECLARE
an salarii.an%TYPE := 2003;
luna salarii.luna%TYPE := 3 ;
zi DATE ; -- variabila folosita la ciclare
k PLS_INTEGER := 1 ; -- alta variabila necesara lucrului cu vectorii

TYPE t_marca IS TABLE OF personal.marca%TYPE INDEX BY PLS_INTEGER ;
v_marca t_marca ;

TYPE t_pont_marca IS TABLE OF pontaje.marca%TYPE INDEX BY PLS_INTEGER ;
v_pont_marca t_pont_marca ;
 
TYPE t_pont_data IS TABLE OF pontaje.data%TYPE INDEX BY PLS_INTEGER ;
v_pont_data t_pont_data ;

BEGIN 
/* Se initializeaza vectorul v_marca folosindu-se clauza BULK COLLECT */
SELECT marca BULK COLLECT INTO v_marca FROM PERSONAL ;

/* tablourile V_PONT_MARCA si V_PONT_DATA contin elemente 
pentru toate zilele lucratoare si angajatii */
FOR i IN 1..TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('01/' || luna || '/' || an, 
'DD/MM/YYYY')),'DD')) LOOP
zi := TO_DATE( TO_CHAR(i,'99') || '/' || luna || '/' || an, 'DD/MM/YYYY') ;
IF TO_CHAR(zi, 'DAY') IN ('SAT', 'SUN') THEN
-- e zi nelucratoare (simbata sau duminica)
NULL ;
ELSE
FOR j IN 1..v_marca.COUNT LOOP 
v_pont_marca(k) := v_marca(j) ;
v_pont_data(k) := zi ;
k := k + 1 ;
END LOOP ;
END IF ;
END LOOP ;
/* inserare cu folosirea comenzii FORALL. Se foloseste un bloc inclus pentru
 tratarea eventualei erori de violare a cheii primare */
BEGIN 
FORALL i IN 1..k-1
INSERT INTO pontaje (marca, data) VALUES (v_pont_marca(i), v_pont_data(i) ) ;
EXCEPTION   -- se preia eventuala violare a cheii primare
WHEN DUP_VAL_ON_INDEX THEN
-- se sterg mai intai inregistrarile pentru ziua curenta
DELETE FROM pontaje WHERE TO_NUMBER(TO_CHAR(data, 'YYYY')) = an 
 AND TO_NUMBER(TO_CHAR(data, 'MM')) = luna ;     
COMMIT ;
-- apoi se reinsereaza inregistrarile
DBMS_OUTPUT.PUT_LINE ('Se reinsereaza ' );
FORALL i IN 1..k-1
INSERT INTO pontaje (marca, data) VALUES (v_pont_marca(i), v_pont_data(i) ) ;
END ;   -- aici se termina blocul inclus    
COMMIT ;
END ;

