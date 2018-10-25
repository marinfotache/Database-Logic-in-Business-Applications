------------------------------------------------------------------------------------
--          the fifth version of admission package - using collections - 
--              VARRAYS
-- the same requirements/specifications as for the second version:
-- in case two (or more) candidates applied for the same programme 
--    and they have the same admission_avg_points,
--    one applicant's acceptance entails the other applicant's acceptance, 
--     even if the programme positions have been filled with the former applicant 
  

--=====================================================================================
    CREATE OR REPLACE PACKAGE pac_admission_5 AS
--====================================================================================

    -- public type for a record related to a master programme information
    TYPE t_r_prog_abbreviation IS RECORD (
        prog_abbreviation VARCHAR2(4),
        n_of_positions NUMBER(3),
        n_of_filled_positions NUMBER(3),
        last_accepted_avg_points number(5,3)
        );

    -- the varray type
    TYPE t_master_progs_varray IS VARRAY(20) OF t_r_prog_abbreviation ;

    -- the varray variable
    v_master_progs_varray t_master_progs_varray ;

    -- we'll also use an associative array for a better access to VARRAY components
    TYPE t_indexes IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(4) ;
    v_indexes t_indexes ;

    -- admission procedure operating the varray variable
    PROCEDURE p_admission_varray ;

    FUNCTION f_free_position_varray (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
        admission_avg_points_ NUMBER) RETURN boolean ;

    PROCEDURE p_after_acceptance_varray (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
        admission_avg_points_ master_progs.last_accepted_avg_points%TYPE) ;

END pac_admission_5 ;
/


--====================================================================================
            CREATE OR REPLACE PACKAGE BODY pac_admission_5 AS
--====================================================================================

--------------------------------------------------------------------------------------
PROCEDURE p_admission_varray  AS
  v_has_been_accepted BOOLEAN ;
BEGIN
    UPDATE applicants SET prog_abbreviation_accepted = NULL ;
    UPDATE master_progs set n_of_filled_positions = 0, last_accepted_avg_points = 0 ;

    -- varray variable initialization
    SELECT prog_abbreviation, n_of_positions, 0, 10 BULK COLLECT INTO v_master_progs_varray 
    FROM master_progs ;

    -- associative array variable iinitialization
    FOR i IN 1..v_master_progs_varray.COUNT LOOP
        v_indexes (v_master_progs_varray(i).prog_abbreviation ) := i ;
    END LOOP ;
    
    /* main loop, as in previous prcedures   */
    FOR rec_applicant IN (
            SELECT c.*, grades_avg * 0.6 + dissertation_avg * 0.4 AS admission_avg_points 
            FROM applicants c ORDER BY grades_avg * 0.6 + dissertation_avg * 0.4 DESC) LOOP 
        v_has_been_accepted := false ;
        FOR rec_preference IN (
                SELECT 1 AS no, rec_applicant.prog1_abbreviation AS prog_abbreviation FROM DUAL UNION
                SELECT 2, rec_applicant.prog2_abbreviation AS prog_abbreviation FROM DUAL UNION
                SELECT 3, rec_applicant.prog3_abbreviation FROM DUAL UNION
                SELECT 4, rec_applicant.prog4_abbreviation FROM DUAL UNION
                SELECT 5, rec_applicant.prog5_abbreviation FROM DUAL UNION
                SELECT 6, rec_applicant.prog6_abbreviation FROM DUAL 
                      ORDER BY 1) LOOP
            IF rec_preference.prog_abbreviation IS NOT NULL THEN            
                IF f_free_position_varray (rec_preference.prog_abbreviation, rec_applicant.admission_avg_points) THEN
                    -- success!
                    UPDATE applicants 
                        SET prog_abbreviation_accepted = rec_preference.prog_abbreviation 
                        WHERE applicant_id=rec_applicant.applicant_id ;
                    
                    p_after_acceptance_varray (rec_preference.prog_abbreviation, 
                        rec_applicant.admission_avg_points)  ;  
                    v_has_been_accepted := TRUE ;
                    EXIT ;
                END IF ;
            ELSE
                EXIT ;
            END IF ;   
        END LOOP ;                
        IF v_has_been_accepted = FALSE THEN
            UPDATE applicants 
            SET prog_abbreviation_accepted = null 
            WHERE applicant_id=rec_applicant.applicant_id ;
        END IF ;
    END LOOP ;

    FORALL i IN 1..v_master_progs_varray.COUNT 
      UPDATE master_progs 
            SET n_of_filled_positions = v_master_progs_varray(i).n_of_filled_positions, 
                last_accepted_avg_points = v_master_progs_varray(i).last_accepted_avg_points
            WHERE prog_abbreviation = v_master_progs_varray(i).prog_abbreviation ;

END p_admission_varray;

--------------------------------------------------------------------------------------
FUNCTION f_free_position_varray (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
    admission_avg_points_ NUMBER) RETURN boolean  
IS
BEGIN
    IF v_master_progs_varray(v_indexes(prog_abbreviation_)).n_of_positions >
             v_master_progs_varray(v_indexes(prog_abbreviation_)).n_of_filled_positions THEN
        RETURN TRUE ;
    ELSE
        IF admission_avg_points_ >= 
                v_master_progs_varray(v_indexes(prog_abbreviation_)).last_accepted_avg_points THEN
            RETURN TRUE ;
        ELSE
            RETURN FALSE ;
        END IF ;
    END IF ;    
END f_free_position_varray;

-------------------------------------------------------------------------------------
PROCEDURE p_after_acceptance_varray (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
    admission_avg_points_ master_progs.last_accepted_avg_points%TYPE)  
IS
BEGIN
    v_master_progs_varray(v_indexes(prog_abbreviation_)).n_of_filled_positions :=
        v_master_progs_varray(v_indexes(prog_abbreviation_)).n_of_filled_positions + 1 ;
    v_master_progs_varray(v_indexes(prog_abbreviation_)).last_accepted_avg_points := 
        admission_avg_points_ ;
END p_after_acceptance_varray;

END pac_admission_5 ;
/



-- test (launch next commands in Oracle SQL Developer)
EXECUTE pac_admission_5.p_admission_varray

SELECT * FROM applicants 
ORDER BY grades_avg * 0.6 + dissertation_avg * 0.4 DESC, grades_avg DESC 
/
SELECT * FROM master_progs 
/


