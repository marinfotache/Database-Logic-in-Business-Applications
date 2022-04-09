CREATE OR REPLACE PROCEDURE test_utl_ref (v_ref IN REF ANGAJAT) IS
 	obj_clona_angajat ANGAJAT;
 BEGIN
	-- pas 1 – obtinere obiect
	UTL_REF.SELECT_OBJECT(v_ref,obj_clona_angajat);
	INSERT INTO TEMP VALUES ('Pas1/ variabila locala detine o copie a ob. din tabela:                          '
                            ||obj_clona_angajat.Marca || '  ' || obj_clona_angajat.Nume);

	-- pas 2 – inlocuire obiect la referinta
	UTL_REF.UPDATE_OBJECT(v_ref, new Angajat(120,'TEST2',null,0,0,0,0));
	INSERT INTO TEMP VALUES  
		('Pas2/ dupa modificare varibila locala detine in continuare copia veche:          '
                    || obj_clona_angajat.Marca || '  ' || obj_clona_angajat.Nume);

	-- pas 3 – obtinere obiect nou din referinta
	UTL_REF.SELECT_OBJECT(v_ref,obj_clona_angajat);
	INSERT INTO TEMP VALUES (
		'Pas3/ Variabila locala a preluat valoarea obiectului nou de la aceeasi 	referinta:'
            || obj_clona_angajat.Marca || '  ' || obj_clona_angajat.Nume);

	-- pas 4 – stegere obiect
	UTL_REF.DELETE_OBJECT(v_ref);

 END;
/