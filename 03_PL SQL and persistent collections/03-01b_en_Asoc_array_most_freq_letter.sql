-- The same problem as in scripts 03-01d and 03-02b:
-- Find and display the most frequent letter in a given string

-- Here is a new solution based on an associative array
--    indexed by strings!
---------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION p_most_freq_letter_aa (string_ NVARCHAR2)
    RETURN NVARCHAR2
IS
    v_no_max NUMBER(7) := 0 ;
    v_return NVARCHAR2(1000) := ' ' ;
    TYPE t_aa_characters IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2 (1 CHAR) ;
    v_aa_char t_aa_characters ;  
    j VARCHAR2 (1 CHAR) ;
BEGIN
    v_aa_char.DELETE ;
    
    -- intialize the associative array variable (ex. v_aa_char ('a') = 11, v_aa_char ('ă') = 9, ...)  
    FOR i IN 1..LENGTH(string_) LOOP
        IF v_aa_char.EXISTS (UPPER(SUBSTR(string_, i, 1))) THEN
            v_aa_char (UPPER(SUBSTR(string_, i, 1))) := 
                  v_aa_char (UPPER(SUBSTR(string_, i, 1))) + 1 ;
        ELSE
            v_aa_char (UPPER(SUBSTR(string_, i, 1))) := 1 ;        
        END IF ;
    END LOOP ;

    -- find the greatest number of occurrences of a char in the string_ (v_no_max)
    j := v_aa_char.FIRST ;
    WHILE j < v_aa_char.LAST LOOP
        IF v_aa_char.EXISTS (j) THEN
            IF v_no_max < v_aa_char(j) THEN
                v_no_max := v_aa_char(j) ; 
            END IF ;
        END IF ;
        j := v_aa_char.NEXT(j) ;
    END LOOP ;

    -- return 
    v_return :=  'The most frequent letter(s) is (are):  ' ;
    j := v_aa_char.FIRST ;
    WHILE j <= v_aa_char.LAST LOOP
        IF v_aa_char.EXISTS (j) THEN
            IF v_no_max = v_aa_char(j) THEN
                IF v_return = 'The most frequent letter(s) is (are):  ' THEN
                    v_return := v_return || j  ;
                ELSE
                    v_return := v_return || ', ' || j  ;
                END IF ;     
            END IF ;    
        END IF ;
        j := v_aa_char.NEXT(j) ;
    END LOOP ;

    v_return := v_return || ' which occur(s) ' || 
        v_no_max || ' times in the string.' ;
    
    RETURN v_return ;
END ;
/


-- test 
BEGIN
  DBMS_OUTPUT.PUT_LINE(p_most_freq_letter_aa('Ana are mere ăăășșșțțțuuu')) ;
END ;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE(p_most_freq_letter_aa('Ana are mere')) ;
END ;
/