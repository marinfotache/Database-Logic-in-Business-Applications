------------------------------------------------------------------------------------
--          the second version of admission package - using cursors
-- changed requirements/specifications:
-- in case two (or more) candidates applied for the same programme 
--    and they have the same admission_avg_points,
--    one applicant's acceptance entails the other applicant's acceptance, 
--     even if the programme positions have been filled with the former applicant 
--  2017


--===========================================================================
CREATE OR REPLACE PACKAGE pac_admiss2
AS

-- the public cursor
cursor c_applicants is 
    select a.*, grades_avg * .6 + dissertation_avg * .4 as admiss_avg_points 
    from applicants a
    order by admiss_avg_points desc ;

-- a new version of the function that checks if a given programme could
--  still receive applicants (the are still unfilled postions)
function f_still_available (prog_ master_progs.prog_abbreviation%TYPE,
      crt_average_ master_progs.last_admitted_avg%TYPE)
  return boolean ;

-- main procedure  
 procedure p_admiss ;
 
 
end ; -- end of package specification
/


--===========================================================================
CREATE OR REPLACE PACKAGE BODY pac_admiss2
AS

------------------------------------------------------------------
function f_still_available (prog_ master_progs.prog_abbreviation%TYPE,
      crt_average_ master_progs.last_admitted_avg%TYPE)
  return boolean 
is
  n_of_available_positions INT ;
  last_avg master_progs.last_admitted_avg%TYPE ;
begin 
  select n_of_positions - n_of_filled_positions, last_admitted_avg 
  into n_of_available_positions, last_avg
  from master_progs
  where prog_abbreviation = prog_ ;
  
  if n_of_available_positions > 0 
      or  n_of_available_positions <= 0 and crt_average_ >= last_avg then
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
  for rec_app in pac_admiss2.c_applicants loop
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
         if pac_admiss2.f_still_available(rec_options.prog, rec_app.admiss_avg_points) then
            -- we can assign the current applicant to the current option
            update applicants set prog_abbreviation_accepted = rec_options.prog
            where APPLICANT_ID = rec_app.applicant_id ;
            
            -- increment the number of filled positions for this programme
            update master_progs set n_of_filled_positions = n_of_filled_positions + 1,
                last_admitted_avg = rec_app.admiss_avg_points
            where prog_abbreviation = rec_options.prog ;
             
            exit ;
         end if ;   
         
      end loop ;        
  end loop ;

end p_admiss ;

  
end  -- end of package body;
/


--===========================================================================
-- test the solution

/*
EXECUTE pac_admiss2.p_admiss

-- or...
    begin 
  pac_admiss2.p_admiss ;
end ;
/


select a.*, grades_avg * .6 + dissertation_avg * .4 as admiss_avg_points 
    from applicants a
order by admiss_avg_points desc ;

    
select a.*, grades_avg * .6 + dissertation_avg * .4 as admiss_avg_points 
    from applicants a
where prog_abbreviation_accepted = 'FAB' 
order by admiss_avg_points desc ;
    
*/    
    


