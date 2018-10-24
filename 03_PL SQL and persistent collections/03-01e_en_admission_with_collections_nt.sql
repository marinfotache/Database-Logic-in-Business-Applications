------------------------------------------------------------------------------------
--          the fourth version of admission package - using collections - 
--              NESTED TABLES
-- the same requirements/specifications as for the second version:
-- in case two (or more) candidates applied for the same programme 
--    and they have the same admission_avg_points,
--    one applicant's acceptance entails the other applicant's acceptance, 
--     even if the programme positions have been filled with the former applicant 


--===============================================================================================
                    CREATE OR REPLACE PACKAGE pac_admission_4 AS
 
    -- public type for a record related to a master programme information
    TYPE t_r_prog_abbreviation IS RECORD (
        prog_abbreviation VARCHAR2(4),
        n_of_positions NUMBER(3),
        n_of_filled_positions NUMBER(3),
        last_accepted_avg_points number(5,3)
        );

    -- the nested table type
    TYPE t_master_progs_nt IS TABLE OF t_r_prog_abbreviation ;

    -- the nested table variable
    v_master_progs_nt t_master_progs_nt ;

    PROCEDURE p_admission_nt ;

    FUNCTION f_free_position_nt (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
        admission_avg_points_ NUMBER) RETURN boolean ;

    PROCEDURE p_after_acceptance_nt (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
        admission_avg_points_ master_progs.last_accepted_avg_points%TYPE) ;

END pac_admission_4;
/


--===============================================================================================
                    CREATE OR REPLACE PACKAGE BODY pac_admission_4 AS
--===============================================================================================

-------------------------------------------------------------------------------
PROCEDURE p_admission_nt
IS
    v_has_been_accepted BOOLEAN ;
BEGIN
    UPDATE applicants SET prog_abbreviation_accepted = NULL ;
    UPDATE master_progs set n_of_filled_positions = 0, last_accepted_avg_points = 0 ;

    -- load nested table variable
    SELECT prog_abbreviation, n_of_positions, 0, 10 BULK COLLECT INTO v_master_progs_nt 
    FROM master_progs ;

    /* if you want to check the nested table content, you can de-comment this loop  
    	FOR i IN 1..v_master_progs_nt.COUNT LOOP
        	DBMS_OUTPUT.PUT_LINE('i=' || i || ', v_master_progs_nt(i).prog_abbreviation ' 
        	    || v_master_progs_nt(i).prog_abbreviation) ;
     	END LOOP ;*/
    
	/* next loop will attemp to assign each applicant one program he filled 
	    in the application form   */
    FOR rec_applicant IN (
            SELECT c.*, grades_avg * 0.6 + dissertation_avg * 0.4 AS admission_avg_points
            FROM applicants c ORDER BY grades_avg * 0.6 + dissertation_avg * 0.4 DESC) LOOP
        v_has_been_accepted := false ;
        FOR rec_preference IN (
                SELECT 1 AS no, rec_applicant.prog1_abbreviation AS prog_abbreviation FROM DUAL UNION
                SELECT 2, rec_applicant.prog2_abbreviation FROM DUAL UNION
                SELECT 3, rec_applicant.prog3_abbreviation FROM DUAL UNION
                SELECT 4, rec_applicant.prog4_abbreviation FROM DUAL UNION
                SELECT 5, rec_applicant.prog5_abbreviation FROM DUAL UNION
                SELECT 6, rec_applicant.prog6_abbreviation FROM DUAL
                      ORDER BY 1) LOOP
            IF rec_preference.prog_abbreviation IS NOT NULL THEN
                IF f_free_position_nt (rec_preference.prog_abbreviation, 
                        rec_applicant.admission_avg_points) THEN
                    -- success!
                    UPDATE applicants 
                    SET prog_abbreviation_accepted = rec_preference.prog_abbreviation
                    WHERE applicant_id=rec_applicant.applicant_id ;
                    
                    -- call the procedure for updating the nested table component
                    --   related to master programme's filled positions and 
                    --     last_accepted_avg_points
                    p_after_acceptance_nt (rec_preference.prog_abbreviation, 
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

    -- update the tables based on the nested table variable
    FORALL i IN 1..v_master_progs_nt.COUNT
        UPDATE master_progs
            SET n_of_filled_positions = v_master_progs_nt(i).n_of_filled_positions, 
                last_accepted_avg_points = v_master_progs_nt(i).last_accepted_avg_points
          WHERE prog_abbreviation = v_master_progs_nt(i).prog_abbreviation ;
END p_admission_nt;


------------------------------------------------------------------------------------
FUNCTION f_free_position_nt (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
    admission_avg_points_ NUMBER) RETURN boolean
IS
BEGIN
    -- locate the master in the nested table...
    FOR i IN 1..v_master_progs_nt.COUNT LOOP
        IF v_master_progs_nt(i).prog_abbreviation = prog_abbreviation_ THEN
            -- check for unfilled positions and/or the last accepted's average points
            IF v_master_progs_nt(i).n_of_positions > v_master_progs_nt(i).n_of_filled_positions THEN
                RETURN TRUE ;
            ELSE
                IF admission_avg_points_ >= v_master_progs_nt(i).last_accepted_avg_points THEN
                    RETURN TRUE ;
                ELSE
                    RETURN FALSE ;
                END IF ;
            END IF ;
            EXIT ;
        END IF ;
    END LOOP ;
    RETURN FALSE ;
END f_free_position_nt ;


------------------------------------------------------------------------------------
PROCEDURE p_after_acceptance_nt (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
    admission_avg_points_ master_progs.last_accepted_avg_points%TYPE)
IS
BEGIN
    -- similar to procedures for associative arrays
    FOR i IN 1..v_master_progs_nt.COUNT LOOP
        IF v_master_progs_nt(i).prog_abbreviation = prog_abbreviation_ THEN
            v_master_progs_nt(i).n_of_filled_positions := v_master_progs_nt(i).n_of_filled_positions + 1 ;
            v_master_progs_nt(i).last_accepted_avg_points := admission_avg_points_ ;
            EXIT ;
        END IF ;
    END LOOP ;
END p_after_acceptance_nt ;

END pac_admission_4;

/



-- test 
EXECUTE pac_admission_4.p_admission_nt

SELECT * FROM applicants 
ORDER BY grades_avg * 0.6 + dissertation_avg * 0.4 DESC, grades_avg DESC 
/
SELECT * FROM master_progs 
/

