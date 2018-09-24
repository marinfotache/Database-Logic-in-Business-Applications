-- 
-- The same problem as in listing 03_01d:
-- find and display the most frequent letter in a given string

/* If the database default language is not Romanian, the first version of the 
function can generate an error:
ORA-06502: PL/SQL: numeric or value error: character string buffer too small
ORA-06512: at "SIA.p_most_freq_letter", line 3
06502. 00000 -  "PL/SQL: numeric or value error%s"
*Cause:    
*Action:

that is because romanian letters need more than a byte for internal representation
*/


-- A general solution is to add 'CHAR' at the declaration of "v_lett_max" variable
--  next version of the procedure we'll also be case sensitive
CREATE OR REPLACE PROCEDURE p_most_freq_letter_2 (string_ VARCHAR2)
IS
    v_letters VARCHAR2(70 CHAR) := 
        'abcdefghijklmnopqrstuvwxyzăîșțâABCDEFGHIJKLMNOPQRSTUVWXYZĂÎȘȚÂ' ; -- here is a change
    v_no_max NUMBER(5) := 0 ;
    v_lett_max CHAR(1 CHAR) ;   -- here is another change
    v_no NUMBER(5) ;
    v_displayed VARCHAR2(4000) ;
BEGIN 

    -- take a letter...
    FOR i IN 1..LENGTH (v_letters) LOOP
        -- count how many times it appears in the string_
        v_no := 0 ;
        FOR j IN 1..LENGTH(string_) LOOP
            IF SUBSTR(string_, j, 1) = SUBSTR(v_letters, i, 1) THEN
                v_no := v_no + 1 ;
            END IF ;
        END LOOP ;
        
        -- compare the number of occurences of this letter with maximum one
        IF v_no > v_no_max THEN
            v_no_max := v_no ;
            v_lett_max := SUBSTR(v_letters, i, 1) ;
        END IF ;
    END LOOP ;

    -- we can display the letter (v_lett_max) and its number of occurences...
    --   but what if there are two or more letters with the same maximum number of occurences?
    -- we need another loop
    
    v_displayed := 'The most frequent letter/letters is/are: ' ;
    FOR i IN 1..LENGTH (v_letters) LOOP
        v_no := 0 ;
        FOR j IN 1..LENGTH(string_) LOOP
            IF SUBSTR(string_, j, 1) = SUBSTR(v_letters, i, 1) THEN
                v_no := v_no + 1 ;
            END IF ;
        END LOOP ;
        IF v_no = v_no_max THEN
            IF v_displayed = 'The most frequent letter/letters is/are: ' THEN
                v_displayed := v_displayed || SUBSTR(v_letters, i, 1)  ;
            ELSE
                v_displayed := v_displayed || ', ' || SUBSTR(v_letters, i, 1)  ;
            END IF ;    
        END IF ;
    END LOOP ;
    
    DBMS_OUTPUT.PUT_LINE (v_displayed || '  which appears/appear in the string ' || v_no_max || ' times.') ;
END ;
/

-- test
EXEC p_most_freq_letter_2 ('Ana are mere') 

EXEC p_most_freq_letter_2 ('Ana are mere ăăăăăăăă') 

EXEC p_most_freq_letter_2 ('Șir de test ăăîîșșțțȚȚ') 

-- as "p_most_freq_letter", on schema 'SIA' (FEAA Oracle DB Server) p_most_freq_letter_2
--  does not work well with Romanian letters


-----------------------------------------------------------------------------------
-- Another solution is to use data types NVCHAR and NVARCHAR2 
CREATE OR REPLACE PROCEDURE p_most_freq_letter_3 (string_ NVARCHAR2)
IS
    v_letters NVARCHAR2(80):= 
        'abcdefghijklmnopqrstuvwxyzăîșțâABCDEFGHIJKLMNOPQRSTUVWXYZĂÎȘȚÂ' ; -- here is a change
    v_no_max NUMBER(5) := 0 ;
    v_lett_max NCHAR(1) ;   -- here is another change
    v_no NUMBER(5) ;
    v_displayed NVARCHAR2(4000) ;  -- and here
BEGIN 

    -- take a letter...
    FOR i IN 1..LENGTH (v_letters) LOOP
        -- count how many times it appears in the string_
        v_no := 0 ;
        FOR j IN 1..LENGTH(string_) LOOP
            IF SUBSTR(string_, j, 1) = SUBSTR(v_letters, i, 1) THEN
                v_no := v_no + 1 ;
            END IF ;
        END LOOP ;
        
        -- compare the number of occurences of this letter with maximum one
        IF v_no > v_no_max THEN
            v_no_max := v_no ;
            v_lett_max := SUBSTR(v_letters, i, 1) ;
        END IF ;
    END LOOP ;

    -- we can display the letter (v_lett_max) and its number of occurences...
    --   but what if there are two or more letters with the same maximum number of occurences?
    -- we need another loop
    
    v_displayed := 'The most frequent letter/letters is/are: ' ;
    FOR i IN 1..LENGTH (v_letters) LOOP
        v_no := 0 ;
        FOR j IN 1..LENGTH(string_) LOOP
            IF SUBSTR(string_, j, 1) = SUBSTR(v_letters, i, 1) THEN
                v_no := v_no + 1 ;
            END IF ;
        END LOOP ;
        IF v_no = v_no_max THEN
            IF v_displayed = 'The most frequent letter/letters is/are: ' THEN
                v_displayed := v_displayed || SUBSTR(v_letters, i, 1)  ;
            ELSE
                v_displayed := v_displayed || ', ' || SUBSTR(v_letters, i, 1)  ;
            END IF ;    
        END IF ;
    END LOOP ;
    
    DBMS_OUTPUT.PUT_LINE (v_displayed || '  which appears/appear in the string ' || v_no_max || ' times.') ;
END ;
/

-- test
EXEC p_most_freq_letter_3 ('Ana are mere') 

EXEC p_most_freq_letter_3 ('Ana are mere ăăăăăăăă') 

EXEC p_most_freq_letter_3 ('Șir de test ăăîîșșțțȚȚ') 



---------------------------------------------------------------------------------------
-- Another solution transformed in function and based on a temporary table
CREATE OR REPLACE FUNCTION f_most_freq_letter (string_ NVARCHAR2) RETURN NVARCHAR2
IS
    v_no NUMBER(4) := 0 ;
    v_return NVARCHAR2(1000) ;
BEGIN
    -- before first execution of this function, the global temporary table
    --    must be created (just  launching in SQL Developer the nect command):
    --      CREATE GLOBAL TEMPORARY TABLE gtt_letters  (x NCHAR(1))  ON COMMIT PRESERVE ROWS ;
    DELETE FROM gtt_letters ;
    
    FOR i IN 1..LENGTH(string_) LOOP
        INSERT INTO gtt_letters VALUES (UPPER(SUBSTR(string_, i, 1))) ;
    END LOOP ;
    
    v_return :=  'The most frequent letter/letters is/are: ' ;

    FOR rec_letter IN (SELECT x AS caracter, COUNT(*) AS No 
                       FROM gtt_letters 
                       GROUP BY x
                       HAVING COUNT(*) = (SELECT MAX (COUNT(*)) FROM gtt_letters GROUP BY x) ) LOOP
            v_no := rec_letter.No ;
            IF v_return =  'The most frequent letter(s) is (are): ' THEN 
                v_return := v_return || ' ' || rec_letter.caracter ;
            ELSE
                v_return := v_return || ', ' || rec_letter.caracter  ;            
            END IF ;    
    END LOOP ;
    v_return := v_return|| ' which appear(s) ' || v_no || ' times in the string.' ;
    
    RETURN v_return ;
END ;
/

-- test
SELECT f_most_freq_letter ('Ana are mere') FROM dual ;


ORA-14551: nu se pot efectua operatii DML într-o interogare 
ORA-06512: la "SIA.F_MOST_FREQ_LETTER", linia 10
14551. 00000 -  "cannot perform a DML operation inside a query "
*Cause:    DML operation like insert, update, delete or select-for-update
           cannot be performed inside a query or under a PDML slave.
*Action:   Ensure that the offending DML operation is not performed or
           use an autonomous transaction to perform the DML operation within
           the query or PDML slave.
           
SELECT f_most_freq_letter ('Ana are mere ăăăăăăăă')  FROM dual ;

SELECT p_most_freq_letter ('Șir de test ăăîîșșțțȚȚ')  FROM dual ;


---------------------------------------------------------------------------------------
-- It's time for an autonomous transaction
CREATE OR REPLACE FUNCTION f_most_freq_letter (string_ NVARCHAR2) RETURN NVARCHAR2
IS
    PRAGMA AUTONOMOUS_TRANSACTION ;

    v_no NUMBER(4) := 0 ;
    v_return NVARCHAR2(1000) ;
BEGIN
    -- before first execution of this function, the global temporary table
    --    must be created (just  launching in SQL Developer the nect command):
    --      CREATE GLOBAL TEMPORARY TABLE gtt_letters  (x NCHAR(1))  ON COMMIT PRESERVE ROWS ;

    DELETE FROM gtt_letters ;
    FOR i IN 1..LENGTH(string_) LOOP
        INSERT INTO gtt_letters VALUES (UPPER(SUBSTR(string_, i, 1))) ;
    END LOOP ;
    COMMIT ;
    
    v_return :=  'The most frequent letter(s) is (are): ' ;

    FOR rec_letter IN (SELECT x AS letter, COUNT(*) AS No 
                       FROM gtt_letters 
                       GROUP BY x
                       HAVING COUNT(*) = (SELECT MAX (COUNT(*)) FROM gtt_letters GROUP BY x) ) LOOP
            v_no := rec_letter.No ;
            IF v_return = 'The most frequent letter(s) is (are): ' THEN 
                v_return := v_return || ' ' || rec_letter.letter ;
            ELSE
                v_return := v_return || ', ' || rec_letter.letter  ;            
            END IF ;    
    END LOOP ;
    v_return := v_return|| ' which appear(s) ' || v_no || ' times in the string.' ;
    
    RETURN v_return ;
END ;
/

-- test
SELECT f_most_freq_letter ('Ana are mere') FROM dual ;


SELECT f_most_freq_letter ('Ana are mere ăăăăăăăă')  FROM dual ;

SELECT f_most_freq_letter ('Șir de test ăăîîșșțțȚȚ')  FROM dual ;

# now it works






