/* Case study (simplified - no positions for tuition fee studies, no two (or more) students
		with the same admission average points ):
    Admission at FEAA master programs
    In previous script we created and populated two tables, "master_progs" and "applicants"

    In this script we will develop a second (simple) solution based on a package
    
    Assumption (unrealistic): no two applicants could have the same `admiss_avg_points`

	2017
*/


--=============================================================================
-----------------------  package specification
CREATE OR REPLACE PACKAGE pac_admiss1
AS

-- a public cursor containing the applicants (ordered by admission average points)
cursor c_applicants is 
    select a.*, grades_avg * .6 + dissertation_avg * .4 as admiss_avg_points 
    from applicants a
    order by admiss_avg_points desc ;


-- a function for checking if, for a given (parameter) programme, there are
--   still unfilled positions
function f_still_available (prog_ master_progs.prog_abbreviation%TYPE)
  return boolean ;

-- main procedure  
procedure p_admiss ;
end ;
/
-----------------------  end of package specification


--=============================================================================
-----------------------  package body
------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_admiss1
AS

------------------------------------------------------------------
function f_still_available (prog_ master_progs.prog_abbreviation%TYPE)
  return boolean 
is
  n_of_available_positions INT ;
begin 
  select n_of_positions - n_of_filled_positions 
  into n_of_available_positions
  from master_progs
  where prog_abbreviation = prog_ ;
  
  if n_of_available_positions >0 then
      return true ;
  else
      return false ;
  end if ;
end f_still_available ;

------------------------------------------------------
procedure p_admiss 
is 

begin 
  -- clean up the data
  update master_progs set n_of_filled_positions = 0 ;
  update applicants set prog_abbreviation_accepted = NULL ;
   
  -- process each applicant (in descending order of `admiss_avg_points`
  for rec_app in pac_admiss1.c_applicants loop
      -- here we process the current applicant
      --dbms_output.put_line( rec_app.applicant_name || ': ' ||
      --    rec_app.admiss_avg_points);
      for rec_options in 
        (
         select *
         from (
         select 1 as opt_no, rec_app.prog1_abbreviation as prog from dual union
         select 2, rec_app.prog2_abbreviation from dual union
         select 3, rec_app.prog3_abbreviation from dual union
         select 4, rec_app.prog4_abbreviation from dual union 
         select 5, rec_app.prog5_abbreviation from dual union
         select 6, rec_app.prog6_abbreviation from dual)
         where prog is not null
         order by opt_no
         ) loop
        
        -- we process the i'th option of an apllicant
        --dbms_output.put_line('    ' || rec_options.opt_no || ': ' ||
        --  rec_options.prog) ;
          
         -- we'll try to assign the current applicant to her/his 
         --   current option         
         if pac_admiss1.f_still_available(rec_options.prog) then
            -- we can assign the current applicant to the current option
            update applicants set prog_abbreviation_accepted = rec_options.prog
            where APPLICANT_ID = rec_app.applicant_id ;
            
            -- increment the number of filled positions for this programme
            update master_progs set n_of_filled_positions = n_of_filled_positions + 1
            where prog_abbreviation = rec_options.prog ;
             
            exit ;
         end if ;   
         
      end loop ;        
  end loop ;

end p_admiss ;

  
end ;
/
-----------------------  end of package body


/*
-- check the solution 

begin 
  pac_admiss1.p_admiss ;
end ;
/

select a.*, grades_avg * .6 + dissertation_avg * .4 as admiss_avg_points 
    from applicants a
order by admiss_avg_points desc ;

    
    
    
    
    


