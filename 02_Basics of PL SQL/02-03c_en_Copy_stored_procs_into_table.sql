
/* We want to copy the code of procedures, functions and packages in 
    current (sub) schema into a table (that can be exported in .txt, .sql, ... files) */
CREATE TABLE table_with_code (
        object_name VARCHAR2(75),
        line NUMBER(5),
        text VARCHAR2(4000)
        ) ;              

-- we'll write two procedures in a package
CREATE OR REPLACE PACKAGE source_code IS

	PROCEDURE object_names (object_type_ VARCHAR2) ;
	
	PROCEDURE get_code (object_name_ VARCHAR2, object_type_ VARCHAR2) ;
	
	PROCEDURE get_code_all_objects ;

END source_code ;
/

--======================================================================================
CREATE OR REPLACE PACKAGE BODY source_code IS
----------------------------------------------------------------------------------------
PROCEDURE object_names (object_type_ VARCHAR2) 
IS
    v_object_type VARCHAR2(50) := object_type_;
    
    CURSOR c_object_names (v_object_type VARCHAR2) IS 
        SELECT OBJECT_NAME FROM USER_OBJECTS WHERE OBJECT_TYPE = v_object_type ;
		
    rec_object_name c_object_names%ROWTYPE ;
BEGIN 
    DELETE FROM table_with_code ;

	-- pachetul este object_name_ul procedural care are și specificații și corp (mai este și tipul, 
    --      dar momentan nu ne interesează 
    IF INSTR('PACKAGE',v_object_type) > 0 THEN
        v_object_type := 'PACKAGE' ;
        FOR rec_object_name IN c_object_names (v_object_type) LOOP
            INSERT INTO table_with_code VALUES (rec_object_name.OBJECT_NAME || 
                ' (' || object_type_ || ')', 
                -2, ' ') ;
            INSERT INTO table_with_code VALUES (rec_object_name.OBJECT_NAME || 
                ' (' || object_type_ || ')', 
                -1, '=============================================================== ') ;
            get_code(rec_object_name.OBJECT_NAME, 'PACKAGE') ;
        END LOOP ;
			
        v_object_type := 'PACKAGE BODY' ;
        FOR rec_object_name IN c_object_names (v_object_type) LOOP
            INSERT INTO table_with_code VALUES (rec_object_name.OBJECT_NAME || ' (' || object_type_ || ')', 
                -2, ' ') ;
            INSERT INTO table_with_code VALUES (rec_object_name.OBJECT_NAME || ' (' || object_type_ || ')', 
                -1, '=============================================================== ') ;
            get_code(rec_object_name.OBJECT_NAME, 'PACKAGE BODY') ;
        END LOOP ;
		ELSE
        -- object_name_ul nu este pachet (ci procedură sau funcție)
        FOR rec_object_name IN c_object_names (v_object_type) LOOP
            INSERT INTO table_with_code VALUES (rec_object_name.OBJECT_NAME, -2, ' ') ;
            INSERT INTO table_with_code VALUES (rec_object_name.OBJECT_NAME, 
                -1, '=============================================================== ') ;
            get_code(rec_object_name.OBJECT_NAME, v_object_type) ;
        END LOOP ;
		END IF ;
END ;
	
-------------------------------------------------------------------------------------
PROCEDURE get_code (object_name_ VARCHAR2, object_type_ VARCHAR2) 
IS
    CURSOR c_source IS 
			SELECT 0 AS line, 'Source code of ' || object_name_ || ' (' || object_type_ || ')' AS text
			FROM DUAL
			UNION 
			SELECT line, text
			FROM USER_SOURCE
			WHERE TYPE = object_type_ AND NAME = object_name_ 
			ORDER BY 1;
		rec_c_source c_source%ROWTYPE ;
BEGIN 
		FOR rec_c_source IN c_source LOOP
            INSERT INTO table_with_code VALUES (object_name_ || ' (' || object_type_ ||
                 ')', rec_c_source.line, rec_c_source.text)	;
		END LOOP ;
END ;	


-------------------------------------------------------------------------------------
PROCEDURE get_code_all_objects 
IS
    CURSOR c_types IS 
        SELECT DISTINCT type FROM user_source 
        WHERE type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE')
BEGIN
    FOR rec_types in c_types LOOP
        object_names (rec_types.type) ;
    END LOOP ;
END ;

END source_code ;
/



---------------------------------------------------------------
-- test
DELETE FROM table_with_code ;
EXECUTE source_code.object_names('PROCEDURE') ;

SELECT * FROM table_with_code ORDER BY 1, 2 ;



----------------------------------------

BEGIN
  source_code.object_names('FUNCTION') ;
END ;
/
----------------------------------------
SELECT * FROM table_with_code ORDER BY 1, 2 ;


BEGIN
  source_code.object_names('PACKAGE') ;
END ;
/
----------------------------------------
SELECT * FROM table_with_code ORDER BY 1, 2 ;


