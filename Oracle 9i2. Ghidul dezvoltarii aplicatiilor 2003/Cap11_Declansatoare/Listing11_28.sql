CREATE OR REPLACE TRIGGER la_logare
 AFTER LOGON ON FOTACHEM.SCHEMA
BEGIN
	-- renuntam la re_compilare ;
	INSERT INTO istoric_logari VALUES (ora_login_user, SYSTIMESTAMP, 
		NULL, ora_client_ip_address ) ; 
END ;
/     

CREATE OR REPLACE TRIGGER la_delogare
 BEFORE LOGOFF ON FOTACHEM.SCHEMA
DECLARE
	moment_logare TIMESTAMP ; 
BEGIN
	SELECT MAX (datalogarii) INTO moment_logare
	FROM istoric_logari WHERE useru = ora_login_user
		AND datadelogarii IS NULL ;

	UPDATE istoric_logari
	SET datadelogarii = SYSTIMESTAMP
	WHERE useru = ora_login_user AND 
		datalogarii = moment_logare ;
END ;
/     
