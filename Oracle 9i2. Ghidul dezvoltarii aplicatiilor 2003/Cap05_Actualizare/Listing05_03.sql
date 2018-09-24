DELETE FROM pontaje ;

-- 1 iulie 2003
INSERT INTO pontaje 
 SELECT marca, DATE'2003-07-01', 8, 0, 0, 0 FROM personal ;

-- 2 iulie 2003
INSERT INTO pontaje (marca, data, orelucrate, oreco)
 SELECT marca, DATE'2003-07-02', 8, 0 FROM personal  WHERE marca NOT IN (102,107)
 UNION SELECT marca, DATE'2003-07-02', 0, 8 FROM personal WHERE marca IN (102,107) ;

-- 3 iulie 2003
INSERT INTO pontaje (marca, data, orelucrate, oreco)
 SELECT marca, DATE'2003-07-03', 8, 0 FROM personal  WHERE marca NOT IN (102,107)
 UNION SELECT marca, DATE'2003-07-03', 0, 8 FROM personal WHERE marca IN (102,107) ;

-- 4 iulie 2003
INSERT INTO pontaje (marca, data, orelucrate, oreco)
 SELECT marca, DATE'2003-07-04', 8, 0 FROM personal  WHERE marca NOT IN (102,107)
 UNION SELECT marca, DATE'2003-07-04', 0, 8 FROM personal WHERE marca IN (102,107) ;

-- 7 iulie 2003
INSERT INTO pontaje 
 SELECT marca, DATE'2003-07-07', CASE WHEN marca IN (102,107) THEN 0 ELSE 8 END AS OreLucru,
  CASE WHEN marca IN (102, 107) THEN 8 ELSE 0 END AS OreCO,
    CASE marca WHEN 103 THEN 4 ELSE 0 END AS OreNoapte,
    CASE marca WHEN 105 THEN 2 ELSE 0 END AS OreAbsente
 FROM personal ;

-- 8 iulie 2003
INSERT INTO pontaje 
 SELECT marca, DATE'2003-07-08', CASE WHEN marca=103 THEN 0 ELSE 8 END AS OreLucru,
  CASE WHEN marca=103 THEN 8 ELSE 0 END AS OreCO,
    CASE marca WHEN 104 THEN 2 ELSE 0 END AS OreNoapte,
    CASE marca WHEN 105 THEN 1 ELSE 0 END AS OreAbsente
 FROM personal ;

/* pe luna august introducem aceleasi date ca si pe iulie, insa cu 0 la absente nemotivate
  orenoapte; in plus se evita pontaje pentru siimbete si duminici */
INSERT INTO pontaje 
  SELECT marca, ADD_MONTHS(data,1), orelucrate, oreco, 0 AS orenoapte, 0 AS absnem 
  FROM pontaje 
  WHERE EXTRACT (MONTH FROM data) = 7 AND
      RTRIM(TO_CHAR(ADD_MONTHS(data,1),'DAY')) NOT IN ('SATURDAY', 'SUNDAY') ;

/* pe luna septembrie, preluam datele din iulie, ca si pentru august 
 in plus, nimeni nu mai e in concediu  */
INSERT INTO (SELECT marca, data FROM pontaje)
   SELECT marca, ADD_MONTHS(data,2)
   FROM pontaje 
   WHERE EXTRACT (MONTH FROM data) = 7 AND 
    RTRIM(TO_CHAR(ADD_MONTHS(data,2),'DAY')) NOT IN ('SATURDAY', 'SUNDAY') ;

COMMIT ;
