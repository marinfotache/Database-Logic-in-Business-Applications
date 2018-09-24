UPDATE sporuri sp
	SET spvech =
(
		SELECT ROUND((SUM(orelucrate * salorar * procent_sv ) + 
SUM(oreco * salorarco * procent_sv  )) /100,-3)
FROM personal pe INNER  JOIN pontaje po ON pe.marca=po.marca
	INNER JOIN transe_sv ON TRUNC(MONTHS_BETWEEN (
DATE'2003-07-01', datasv )/12,0) >= ani_limita_inf AND 
TRUNC(MONTHS_BETWEEN (
DATE'2003-07-01', datasv )/12,0) < ani_limita_sup
		GROUP BY pe.marca, EXTRACT (YEAR FROM data), EXTRACT (MONTH FROM data)
HAVING pe.marca=sp.marca AND EXTRACT (YEAR FROM data)=sp.an AND 
EXTRACT (MONTH FROM data) = sp.luna 
		), 
		orenoapte = (SELECT SUM (orenoapte) FROM pontaje WHERE marca=sp.marca AND
	EXTRACT (YEAR FROM data)=sp.an AND 
EXTRACT (MONTH FROM data) = sp.luna ),
		spnoapte = 
			(
			SELECT ROUND(SUM(orenoapte * salorar * .15 ) ,-3)
FROM personal pe INNER  JOIN pontaje po ON pe.marca=po.marca
			GROUP BY pe.marca, EXTRACT (YEAR FROM data), EXTRACT (MONTH FROM data)
HAVING pe.marca=sp.marca AND EXTRACT (YEAR FROM data)=sp.an AND 
EXTRACT (MONTH FROM data) = sp.luna 
			)



UPDATE sporuri sp
	SET spvech =
(
		SELECT ROUND((SUM(orelucrate * salorar * procent_sv ) + 
SUM(oreco * salorarco * procent_sv  )) /100,-3)
FROM personal pe INNER  JOIN pontaje po ON pe.marca=po.marca
	INNER JOIN transe_sv ON TRUNC(MONTHS_BETWEEN (
DATE'2003-07-01', datasv )/12,0) >= ani_limita_inf AND 
TRUNC(MONTHS_BETWEEN (
DATE'2003-07-01', datasv )/12,0) < ani_limita_sup
		GROUP BY pe.marca, EXTRACT (YEAR FROM data), EXTRACT (MONTH FROM data)
HAVING pe.marca=sp.marca AND EXTRACT (YEAR FROM data)=sp.an AND 
EXTRACT (MONTH FROM data) = sp.luna 
		)


rollback

SELECT TRUNC(MONTHS_BETWEEN (DATE'2003-07-01', datasv )/12,0) FROM personal where marca=101
SELECT * FROM SPORURI
SELECT SUM(ORELUCRATE), SUM(ORECO) FROM PONTAJE WHERE MARCA = 101 and to_char(data,'MM/YYYY')='07/2003'
SELECT * FROM TRANSE_SV
