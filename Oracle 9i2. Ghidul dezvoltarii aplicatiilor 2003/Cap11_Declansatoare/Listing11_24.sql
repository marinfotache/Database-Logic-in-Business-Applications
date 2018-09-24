CREATE OR REPLACE PROCEDURE re_compilare
IS
	TYPE t_nume_obiecte IS TABLE OF user_objects.object_name%TYPE
		INDEX BY PLS_INTEGER ;
	v_nume_obiecte t_nume_obiecte ;
	TYPE t_tipuri_obiecte IS TABLE OF user_objects.object_type%TYPE
		INDEX BY PLS_INTEGER ;
	v_tipuri_obiecte t_tipuri_obiecte ;
	v_sir VARCHAR2(200) ;
	erori_la_compilare EXCEPTION ;
	PRAGMA EXCEPTION_INIT (erori_la_compilare, -24344) ;

BEGIN
	pac_administrare.v_temp.DELETE ;
 
	-- stocam in cei doi vectori numele si tipul fiecarui bloc de (re)compilat
	SELECT object_name, object_type 
		BULK COLLECT INTO v_nume_obiecte, v_tipuri_obiecte
	FROM user_objects 
	WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY',
		'TRIGGER') AND object_name NOT IN ('RE_COMPILARE', 'LA_LOGARE', 'PAC_ADMINISTRARE')
	ORDER BY CASE WHEN object_type ='PACKAGE BODY' THEN 1 ELSE 
		CASE WHEN object_type='TRIGGER' THEN 2 ELSE 0 END END , object_id ;

	-- initializarea primei componente a tabloului
	pac_administrare.v_temp(1) := ' Logarea din ' || SYSTIMESTAMP || '. Iata erorile:'  ; 
        
	-- re-compilarea "dinamica"
	FOR i IN 1..v_nume_obiecte.COUNT LOOP
		v_sir := ' ALTER ' ;
		CASE v_tipuri_obiecte(i) 
		WHEN 'PACKAGE' THEN v_sir := v_sir || ' PACKAGE ' || v_nume_obiecte(i) ||
			' COMPILE SPECIFICATION ' ;
		WHEN 'PACKAGE BODY' THEN v_sir := v_sir || ' PACKAGE ' || v_nume_obiecte(i) ||
			' COMPILE BODY ' ;
		     ELSE  v_sir := v_sir || v_tipuri_obiecte(i) || ' ' || v_nume_obiecte(i) || ' COMPILE ' ;
		END CASE ;
		
		BEGIN
			EXECUTE IMMEDIATE v_sir ;
		EXCEPTION
		WHEN erori_la_compilare THEN
			pac_administrare.v_temp(pac_administrare.v_temp.COUNT + 1) := SYSTIMESTAMP ||
				' - Blocul ' || v_nume_obiecte(i) || ' prezinta erori !'  ; 
		WHEN OTHERS THEN
			pac_administrare.v_temp(pac_administrare.v_temp.COUNT + 1) := SYSTIMESTAMP ||
			' - La blocul ' || v_nume_obiecte(i) || ' apare o eroare ciudata !'  ; 
	   END ;  
 END LOOP ;
END re_compilare ;
/
