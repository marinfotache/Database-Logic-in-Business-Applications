
-- solutia 1 - strazile sediilor clientilor la 8 febr.2005, 8:42 AM 
WITH strazi AS 
	(SELECT codcl, stradacl, datainitiala, datafinala - 1 /(24*60*60) AS datafinala
	FROM clienti_strazi
	UNION 
	SELECT c.codcl, stradacl, 
		NVL((SELECT MAX(datafinala) 
			FROM clienti_strazi 
			WHERE codcl=c.codcl),TO_DATE('1990-01-01','YYYY-MM-DD')),
		SYSDATE	+ 1 / (24*60*60)
	FROM clienti2 c
	ORDER BY codcl, datainitiala
	) 
SELECT dencl, s.stradacl
FROM clienti2 c INNER JOIN strazi s ON c.codcl=s.codcl
	AND TO_DATE('2005-02-08 09:42:00','YYYY-MM-DD HH24:MI:SS') BETWEEN
		datainitiala AND datafinala



-- solutia 2 - strazile sediilor clientilor la 8 febr.2005, 8:42 AM 
SELECT dencl, c.codcl,
	NVL((SELECT stradacl FROM clienti_strazi WHERE codcl=c.codcl
		AND TO_DATE('2005-02-08 09:42:00','YYYY-MM-DD HH24:MI:SS') BETWEEN
		datainitiala AND datafinala-1/(24*60*60)),
	c.stradacl) stradacl
FROM clienti2 c



-- adresele clientilor la 8 febr.2005, 8:42 AM 
SELECT dencl, c.codcl,
	NVL((SELECT stradacl FROM clienti_strazi WHERE codcl=c.codcl
		AND TO_DATE('2005-02-08 09:42:00','YYYY-MM-DD HH24:MI:SS') BETWEEN
		datainitiala AND datafinala-1/(24*60*60)),
	c.stradacl) stradacl,
	NVL((SELECT nrstradacl FROM clienti_nr WHERE codcl=c.codcl
		AND TO_DATE('2005-02-08 09:42:00','YYYY-MM-DD HH24:MI:SS') BETWEEN
		datainitiala AND datafinala-1/(24*60*60)),
	c.nrstradacl) nrstradacl,
	NVL((SELECT blocscapcl FROM clienti_bloc WHERE codcl=c.codcl
		AND TO_DATE('2005-02-08 09:42:00','YYYY-MM-DD HH24:MI:SS') BETWEEN
		datainitiala AND datafinala-1/(24*60*60)),
	c.blocscapcl) blocscapcl,
	NVL((SELECT telefon FROM clienti_tel WHERE codcl=c.codcl
		AND TO_DATE('2005-02-08 09:42:00','YYYY-MM-DD HH24:MI:SS') BETWEEN
		datainitiala AND datafinala-1/(24*60*60)),
	c.telefon) telefon,
	NVL((SELECT codpost FROM clienti_codpost WHERE codcl=c.codcl
		AND TO_DATE('2005-02-08 09:42:00','YYYY-MM-DD HH24:MI:SS') BETWEEN
		datainitiala AND datafinala-1/(24*60*60)),
	c.codpost) codpost
FROM clienti2 c
WHERE dencl='CL1'




