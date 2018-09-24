/* Case study (simplified - no positions for tuition fee studies):
    Admission at FEAA master programs
    In previous script we created and populated two tables, "master_progs" and "applicants"

    In this script we will develop a simple solution based on anonymous PL/SQL bloc
    
    Assumption (unrealistic): no two applicants could have the same `admiss_avg_points`

	Solution written on 2017-10-23, 16:00-18:00 (Data Mining / Sisteme Informationale pentru Afaceri Course)
*/


-- select current_timestamp from dual ;


--select * from master_progs ;
-- select * from applicants ;

declare
    crt_prog APPLICANTS.PROG1_ABBREVIATION%TYPE ;
    n_of_available_positions INT ;
begin
  -- clean up the data
  update master_progs set n_of_filled_positions = 0 ;
  update applicants set prog_abbreviation_accepted = NULL ;
   
  -- process each applicant (in descending order of `admiss_avg_points`
  for rec_app in c_applicants loop
      -- here we process the current applicant
      dbms_output.put_line( rec_app.applicant_name || ': ' ||
          rec_app.admiss_avg_points);
      for rec_options in 
        (select *
         from  
            (select 1 as opt_no, rec_app.prog1_abbreviation as prog from dual union
            select 2, rec_app.prog2_abbreviation from dual union
            select 3, rec_app.prog3_abbreviation from dual union
            select 4, rec_app.prog4_abbreviation from dual union 
            select 5, rec_app.prog5_abbreviation from dual union
            select 6, rec_app.prog6_abbreviation from dual)
         where prog is not null)   
            loop
        
         -- we process the i'th option of an apllicant
        dbms_output.put_line('    ' || rec_options.opt_no || ': ' ||
          rec_options.prog) ;
          
         -- we'll try to assign the current applicant to her/his 
         --   current option
         crt_prog := rec_options.prog ;
         
         -- check if there is an availble position at this programme
         SELECT n_of_positions - n_of_filled_positions
         INTO n_of_available_positions
         FROM master_progs
         WHERE prog_abbreviation = crt_prog ;
         
         IF n_of_available_positions > 0 THEN
            
            -- success!
            UPDATE applicants
            SET PROG_ABBREVIATION_ACCEPTED = crt_prog
            WHERE applicant_id = rec_app.applicant_id ;
 
            UPDATE master_progs
            SET N_OF_FILLED_POSITIONS = N_OF_FILLED_POSITIONS + 1
            WHERE prog_abbreviation = crt_prog ;
            
            -- exit from the second loop
            EXIT ;
  
         END IF ;
         
      end loop ;        
       
  end loop ;

end ;
/


/* check the solution
-- 1. Run the above PL/SQL block

--- ... and then:
select a.*, grades_avg * .6 + dissertation_avg * .4 as admiss_avg_points 
from applicants a
order by admiss_avg_points desc ;
*/

