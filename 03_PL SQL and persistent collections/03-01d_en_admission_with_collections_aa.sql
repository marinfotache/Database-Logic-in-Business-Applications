------------------------------------------------------------------------------------
--          the third version of admission package - using collections - 
--              two types of ASSOCIATIVE ARRAYS
-- the same requirements/specifications as for the second version:
-- in case two (or more) candidates applied for the same programme 
--    and they have the same admission_avg_points,
--    one applicant's acceptance entails the other applicant's acceptance, 
--     even if the programme positions have been filled with the former applicant 


--=========================================================================================
                    CREATE OR REPLACE PACKAGE pac_admission_3 AS
--=========================================================================================

    -----------------------------------------------------------------------
    -- first type of ASSOCIATIVE ARRAYS (INDEX BY PLS_INTEGER)
    
    -- public type for a record related to a master programme information
    TYPE t_r_prog_abbreviation_aa_1 IS RECORD (
        prog_abbreviation VARCHAR2(4),
        n_of_positions NUMBER(3),
        n_of_filled_positions NUMBER(3),
        last_accepted_avg_points number(5,3)
        );

    -- public type for the associative arrays related to master programmes information	
	TYPE t_master_progs_aa_1 IS TABLE OF t_r_prog_abbreviation_aa_1 INDEX BY PLS_INTEGER ;

    -- public associative array variable
	v_master_progs_aa_1  t_master_progs_aa_1 ;
	
    PROCEDURE p_admission_aa_1 ;
	
	FUNCTION f_free_position_aa_1 (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
	        admission_avg_points_ NUMBER) RETURN boolean ;

	PROCEDURE p_after_acceptance_aa_1 (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
	    admission_avg_points_ master_progs.last_accepted_avg_points%TYPE) ;


    -----------------------------------------------------------------------
    -- second type of ASSOCIATIVE ARRAYS (INDEX BY VARCHAR2)
    TYPE t_r_prog_abbreviation_aa_2   IS RECORD (
        n_of_positions NUMBER(3), 
        n_of_filled_positions NUMBER(3),
        last_accepted_avg_points NUMBER(5,3)
        );

    TYPE t_master_progs_aa_2 IS TABLE OF t_r_prog_abbreviation_aa_2  INDEX BY VARCHAR2(4) ;

    v_master_progs_aa_2 t_master_progs_aa_2 ;

    PROCEDURE p_admission_aa_2 ;
    
    FUNCTION f_free_position_aa_2 (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
        admission_avg_points_ NUMBER) RETURN boolean;

    PROCEDURE p_after_acceptance_aa_2 (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
        admission_avg_points_ master_progs.last_accepted_avg_points%TYPE) ;

END pac_admission_3;
/



--=========================================================================================
                CREATE OR REPLACE PACKAGE BODY pac_admission_3 AS
--=========================================================================================

--------------------------------------------------------------------------------------
PROCEDURE p_admission_aa_1  
IS
    v_has_been_accepted BOOLEAN ;
BEGIN
    -- initialize the attributes to be updated by this procedure
	UPDATE applicants SET prog_abbreviation_accepted = NULL ;
	UPDATE master_progs SET n_of_filled_positions = 0, last_accepted_avg_points = 10 ;

    -- load records from table "master_progs" into the associative 
    --    array variable "v_master_progs_aa_1"
	SELECT prog_abbreviation, n_of_positions, 0, 10 BULK COLLECT INTO v_master_progs_aa_1  
	FROM master_progs ;
 	
    /* if you want to check the associative array content, you can de-comment this loop  
	FOR i IN v_master_progs.FIRST..v_master_progs.LAST LOOP
		DBMS_OUTPUT.PUT_LINE('i=' || i || ', v_master_progs(i).prog_abbreviation ' || 
		    v_master_progs(i).prog_abbreviation) ; 
	END LOOP ;
    */ 

	/* next loop will attemp to assign each applicant one program he filled 
	    in the application form   */
	FOR rec_applicant IN (
	    SELECT c.*, grades_avg * 0.6 + dissertation_avg * 0.4 AS admission_avg_points 
        FROM applicants c ORDER BY grades_avg * 0.6 + dissertation_avg * 0.4 DESC
                    ) LOOP 
		v_has_been_accepted := false ;
        -- use the same old cursor for loading applicant's options
		FOR rec_preference IN (
		    SELECT 1 AS no, rec_applicant.prog1_abbreviation AS prog_abbreviation FROM DUAL UNION
			SELECT 2, rec_applicant.prog2_abbreviation AS prog_abbreviation FROM DUAL UNION
			SELECT 3, rec_applicant.prog3_abbreviation FROM DUAL UNION
			SELECT 4, rec_applicant.prog4_abbreviation FROM DUAL UNION
			SELECT 5, rec_applicant.prog5_abbreviation FROM DUAL UNION
			SELECT 6, rec_applicant.prog6_abbreviation FROM DUAL  ORDER BY 1) LOOP

            -- if current option (1..6) is filled...
			IF rec_preference.prog_abbreviation IS NOT NULL THEN
			    
			    -- check if current option (programme) still has unfilled positions            
    			IF f_free_position_aa_1 (rec_preference.prog_abbreviation, 
    			        rec_applicant.admission_avg_points) THEN
					
					-- success! the applicant will be accepted to the current programme
					UPDATE applicants 
					SET prog_abbreviation_accepted = rec_preference.prog_abbreviation 
						WHERE applicant_id=rec_applicant.applicant_id ;
        
                    -- call the procedure for updating the associative array record 
                    --   related to master programme's filled positions and 
                    --     last_accepted_avg_points
					p_after_acceptance_aa_1 (rec_preference.prog_abbreviation, 
					    rec_applicant.admission_avg_points)  ;  
                    
                    -- since the applicant has been accepted, cancel his next options    
					v_has_been_accepted := TRUE ;
					EXIT ;
				END IF ;
			ELSE
			    -- no more options in the application form, so exit from the loop
				EXIT ;
			END IF ;   
		END LOOP ;                
      
        -- just to be sure that unaccepted applicants have NULL in
        --    "prog_abbreviation_accepted" attribute 
		IF v_has_been_accepted = FALSE THEN
			UPDATE applicants 
			SET prog_abbreviation_accepted = null 
			WHERE applicant_id=rec_applicant.applicant_id ;
		END IF ;
	END LOOP ;
  
    -- copy the associative array content into the original table
	FORALL i IN v_master_progs_aa_1.FIRST..v_master_progs_aa_1.LAST 
		UPDATE master_progs 
		SET n_of_filled_positions = v_master_progs_aa_1(i).n_of_filled_positions, 
		    last_accepted_avg_points = v_master_progs_aa_1(i).last_accepted_avg_points
		WHERE prog_abbreviation = v_master_progs_aa_1(i).prog_abbreviation ;
		
END p_admission_aa_1;

--------------------------------------------------------------------------------------
FUNCTION f_free_position_aa_1 (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
    admission_avg_points_ NUMBER) RETURN boolean
IS
--	v_no master_progs.n_of_positions%TYPE ;
--	v_um master_progs.last_accepted_avg_points%TYPE ;
BEGIN
    -- locate the associative array element related to 'prog_abbreviation_' programme
    FOR i IN v_master_progs_aa_1.FIRST..v_master_progs_aa_1.LAST LOOP
        IF v_master_progs_aa_1(i).prog_abbreviation = prog_abbreviation_ THEN
            -- test if there are unfilled positions
            IF v_master_progs_aa_1(i).n_of_positions > 
                    v_master_progs_aa_1(i).n_of_filled_positions THEN
                RETURN TRUE ;
            ELSE
                -- if there are no unfilled positions, but the applicant has the
                --   same average points as the last accepted, she/he will be also accepted
                --   at this programme
                IF admission_avg_points_ >= v_master_progs_aa_1(i).last_accepted_avg_points THEN
                    RETURN TRUE ;
                ELSE
                    RETURN FALSE ;
                END IF ;
            END IF ;
            EXIT ;
        END IF ;
    END LOOP ;
    RETURN FALSE ;
END f_free_position_aa_1 ;

--------------------------------------------------------------------------------------
PROCEDURE p_after_acceptance_aa_1 (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
    admission_avg_points_ master_progs.last_accepted_avg_points%TYPE) IS
BEGIN
    -- locate the associative array element related to 'prog_abbreviation_' programme    
    FOR i IN v_master_progs_aa_1.FIRST..v_master_progs_aa_1.LAST LOOP
        -- update the number of filled positions and the last accepted average points
        IF v_master_progs_aa_1(i).prog_abbreviation = prog_abbreviation_ THEN
            v_master_progs_aa_1(i).n_of_filled_positions := v_master_progs_aa_1(i).n_of_filled_positions + 1 ;
            v_master_progs_aa_1(i).last_accepted_avg_points := admission_avg_points_ ;			
            EXIT ;
        END IF ;
   END LOOP ;
END p_after_acceptance_aa_1 ;


--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
PROCEDURE p_admission_aa_2  
IS
    v_has_been_accepted BOOLEAN ;
    v_index_string VARCHAR2(4) ;
BEGIN

    UPDATE applicants SET prog_abbreviation_accepted = NULL ;
    UPDATE master_progs set n_of_filled_positions = 0, last_accepted_avg_points = 0 ;

    -- load the associative array "v_master_progs_aa_2"
    FOR rec_master_progs IN (SELECT * FROM master_progs) LOOP
        v_master_progs_aa_2(rec_master_progs.prog_abbreviation).n_of_positions := 
            rec_master_progs.n_of_positions ;
        v_master_progs_aa_2(rec_master_progs.prog_abbreviation).n_of_filled_positions := 
            rec_master_progs.n_of_filled_positions ;
        v_master_progs_aa_2(rec_master_progs.prog_abbreviation).last_accepted_avg_points := 10 ;	
			
    END LOOP ;

   /* if you want to check the associative array content, you can de-comment this loop  
    v_index_string := v_master_progs_aa_2.FIRST ;
    WHILE v_index_string <= v_master_progs_aa_2.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('v_index_string=' || v_index_string 
            || ', positions: '|| v_master_progs_aa_2(v_index_string).n_of_positions ) ;
        v_index_string := v_master_progs_aa_2.NEXT (v_index_string) ;
    END LOOP ;
    */
    
	/* next loop will attemp to assign each applicant one program he filled 
	    in the application form   */
    FOR rec_applicant IN (
            SELECT c.*, grades_avg * 0.6 + dissertation_avg * 0.4 AS admission_avg_points
            FROM applicants c 
            ORDER BY grades_avg * 0.6 + dissertation_avg * 0.4 DESC
                        ) LOOP
        v_has_been_accepted := false ;
        FOR rec_preference IN (
                SELECT 1 AS no, rec_applicant.prog1_abbreviation AS prog_abbreviation FROM DUAL UNION
                SELECT 2, rec_applicant.prog2_abbreviation FROM DUAL UNION
                SELECT 3, rec_applicant.prog3_abbreviation FROM DUAL UNION
                SELECT 4, rec_applicant.prog4_abbreviation FROM DUAL UNION
                SELECT 5, rec_applicant.prog5_abbreviation FROM DUAL UNION
                SELECT 6, rec_applicant.prog6_abbreviation FROM DUAL
                ORDER BY 1          ) LOOP
           IF rec_preference.prog_abbreviation IS NOT NULL THEN
              IF f_free_position_aa_2 (rec_preference.prog_abbreviation, 
                    rec_applicant.admission_avg_points) THEN
                  -- success!
                  UPDATE applicants SET prog_abbreviation_accepted = rec_preference.prog_abbreviation
                      WHERE applicant_id=rec_applicant.applicant_id ;
                  p_after_acceptance_aa_2 (rec_preference.prog_abbreviation, 
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

    v_index_string := v_master_progs_aa_2.FIRST ;
    WHILE v_index_string <= v_master_progs_aa_2.LAST LOOP
        UPDATE master_progs
          SET n_of_filled_positions = v_master_progs_aa_2(v_index_string).n_of_filled_positions,
              last_accepted_avg_points = v_master_progs_aa_2(v_index_string).last_accepted_avg_points
            WHERE prog_abbreviation = v_index_string ;
            
         v_index_string := v_master_progs_aa_2.NEXT (v_index_string) ;
    END LOOP ;
    
END p_admission_aa_2;

----------------------------------------------------------------
FUNCTION f_free_position_aa_2 (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
        admission_avg_points_ NUMBER) RETURN boolean
IS
    v_no master_progs.n_of_positions%TYPE ;
    v_um master_progs.last_accepted_avg_points%TYPE ;
BEGIN
    IF v_master_progs_aa_2(prog_abbreviation_).n_of_positions > 
            v_master_progs_aa_2(prog_abbreviation_).n_of_filled_positions THEN
        RETURN TRUE ;
    ELSE
        IF admission_avg_points_ >= v_master_progs_aa_2(prog_abbreviation_).last_accepted_avg_points THEN
            RETURN TRUE ;
        ELSE
            RETURN FALSE ;
        END IF ;
    END IF ;  
END f_free_position_aa_2 ;
----------------------------------------------------------------------------

PROCEDURE p_after_acceptance_aa_2 (prog_abbreviation_ master_progs.prog_abbreviation%TYPE, 
        admission_avg_points_ master_progs.last_accepted_avg_points%TYPE) 
IS
BEGIN
    v_master_progs_aa_2(prog_abbreviation_).n_of_filled_positions := 
            v_master_progs_aa_2(prog_abbreviation_).n_of_filled_positions + 1 ;
    v_master_progs_aa_2(prog_abbreviation_).last_accepted_avg_points := 
            admission_avg_points_ ;
END p_after_acceptance_aa_2 ;

----------------------------------------------------------------------------

END ; -- package body
/


-- test (launch next commands in Oracle SQL Developer)

EXECUTE pac_admission_3.p_admission_aa_1

SELECT * FROM applicants 
ORDER BY grades_avg * 0.6 + dissertation_avg * 0.4 DESC, grades_avg DESC 
/

SELECT * FROM master_progs 
/


EXECUTE pac_admission_3.p_admission_aa_2

SELECT * FROM applicants 
ORDER BY grades_avg * 0.6 + dissertation_avg * 0.4 DESC, grades_avg DESC 
/
SELECT * FROM master_progs 
/



