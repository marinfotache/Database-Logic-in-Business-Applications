/* Given table "studs_feaa" created and populated in the previous script,
    we want to randomize student first names and/or family names 
    (this sort of operation is necessary for providing anonymity of the 
    students and can be extended for other real-world cases)

We will create two procedures, one for family names and the other for the
   first name; both procedures will randomly replace every family name (or first name)
   with the family name of another student

The problem can be solved using associative arrays (for family name and first name)
which are initialized by BULK COLLECT clause. 

*/

-- before that we make a copy of the table (to test the further procedures)

-- CREATE TABLE studs_feaa_anonim AS SELECT * FROM studs_feaa ;

-- alter table studs_feaa_anonim add (stud_id INTEGER) ;

-- update studs_feaa_anonim SET stud_id = rownum ;

 
 

--==================================================================================
-- the second version of the package will use public types and variables for
--   the associative arrays elementes and indexes
--==================================================================================
CREATE OR REPLACE PACKAGE pac_anonymization_2 AS
        -- public associative array type that will store the family name or the first name
        TYPE t_aa_name IS TABLE OF studs_feaa_anonim.family_name%TYPE INDEX BY PLS_INTEGER ;
        
        -- associative array variable that will store the family name or the first name
        v_aa_name t_aa_name ;
        
        -- public associative array type that will store the index of the associative array
        TYPE t_aa_index_name IS TABLE OF studs_feaa_anonim.family_name%TYPE INDEX BY VARCHAR2(70) ;
        
        -- associative array variable that will store the index of the family name
        --     or of the first name
        v_aa_name_index t_aa_index_name ;
        
        -- an integer variables for random generated indexes 
        k PLS_INTEGER ;

    PROCEDURE p_change_family_name ;
    PROCEDURE p_change_first_name ;
END ; -- end of package spec    
/


-- ... and the package body
--==================================================================================
CREATE OR REPLACE PACKAGE BODY pac_anonymization_2 AS

    ----------------------------------------------------
    PROCEDURE p_change_family_name 
    IS
        -- nothing to declare (like in airport customs :-) )
    BEGIN  
        -- first loade into the associative array variable all the family names
        SELECT DISTINCT family_name BULK COLLECT INTO v_aa_name 
            FROM studs_feaa_anonim ORDER BY family_name ;
            
        -- for each family name, replace it randomly with another student's family name    
        FOR i IN 1..v_aa_name.COUNT LOOP
            -- the random index
            k := TRUNC(DBMS_RANDOM.VALUE(1, v_aa_name.COUNT),0) ;
            -- current student family name will be replaces with
            --     the family name of the student referred by random index
            v_aa_name_index(v_aa_name(i)) := v_aa_name(k) ; 
        END LOOP ;

        -- now update the table "studs_feaa" with shuffled family names
        FOR rec_stud IN (SELECT * FROM studs_feaa_anonim ORDER BY stud_id) LOOP
            UPDATE studs_feaa_anonim 
            SET family_name = v_aa_name_index (rec_stud.family_name) 
            WHERE stud_id =rec_stud.stud_id ;
        END LOOP ;
    END ; -- p_change_family_name

    ----------------------------------------------------
    PROCEDURE p_change_first_name
    IS
    BEGIN
        SELECT DISTINCT first_name BULK COLLECT INTO v_aa_name FROM studs_feaa_anonim ORDER BY first_name ;
  
        FOR i IN 1..v_aa_name.COUNT LOOP
            k := TRUNC(DBMS_RANDOM.VALUE(1, v_aa_name.COUNT),0) ;
            v_aa_name_index(v_aa_name(i)) := v_aa_name(k) ; 
        END LOOP ;

        FOR rec_stud IN (SELECT * FROM studs_feaa_anonim ORDER BY stud_id) LOOP
            UPDATE studs_feaa_anonim 
            SET first_name = v_aa_name_index (rec_stud.first_name) 
            WHERE stud_id = rec_stud.stud_id ;
        END LOOP ;

    END p_change_first_name;

END ; -- end of package BODY    
/


-- test 
EXECUTE pac_anonymization_2.p_change_family_name
EXECUTE pac_anonymization_2.p_change_first_name

SELECT * FROM studs_feaa ORDER BY 1 ;
SELECT * FROM studs_feaa_anonim ORDER BY stud_id ;


alter table studs_feaa_anonim drop column full_name ;





