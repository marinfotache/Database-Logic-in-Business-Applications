CREATE OR REPLACE PACKAGE pac_loc AS 
 loc_init distante.loc1%TYPE := 'Iasi';
 loc_dest distante.loc1%TYPE := 'Focsani' ;
 FUNCTION f_loc_init RETURN loc_init%TYPE ;
 FUNCTION f_loc_dest RETURN loc_init%TYPE ;
END  ;
/
-----------------------------------------------
CREATE OR REPLACE PACKAGE BODY pac_loc AS 
FUNCTION f_loc_init RETURN loc_init%TYPE IS
BEGIN 
 RETURN pac_loc.loc_init ;
END ;
  
FUNCTION f_loc_dest RETURN loc_init%TYPE IS
BEGIN 
 RETURN pac_loc.loc_dest ;
END ;
END ;
/
 ----------------------
DROP VIEW v_ordin1 ;

CREATE  VIEW v_ordin1 AS
 SELECT loc1, loc2, distanta, '*'|| loc1 || '**' || loc2 ||'*' AS sir
 FROM distante
 WHERE loc1=pac_loc.f_loc_init() 
 UNION
 SELECT loc2, loc1, distanta, '*'|| loc2 || '**' || loc1 ||'*' AS sir
 FROM distante
 WHERE loc2=pac_loc.f_loc_init() 
WITH READ ONLY ;

----------------------
DROP VIEW v_ordin2 ;
CREATE  VIEW v_ordin2 AS
SELECT v.loc1, v.loc2, d.loc2 AS loc3, v.distanta + d.distanta AS distanta,
 sir ||'*'|| d.loc2 ||'*' AS sir 
FROM v_ordin1 v INNER JOIN distante d ON v.loc2=d.loc1
WHERE INSTR(sir, '*'||d.loc2||'*') = 0 AND v.loc2 <> pac_loc.f_loc_dest() 
UNION
SELECT v.loc1, v.loc2, d.loc1, v.distanta + d.distanta, 
 sir ||'*'|| d.loc1 ||'*' AS sir 
FROM v_ordin1 v INNER JOIN distante d ON v.loc2=d.loc2 
WHERE INSTR(sir, '*'||d.loc1||'*') = 0 AND v.loc2 <> pac_loc.f_loc_dest() 
WITH READ ONLY ;

----------------------
DROP VIEW v_ordin3 ;
CREATE  VIEW v_ordin3 AS
SELECT v.loc1, v.loc2, v.loc3, d.loc2 AS loc4, v.distanta + d.distanta AS distanta,
 sir ||'*'|| d.loc2 ||'*' AS sir 
FROM v_ordin2 v INNER JOIN distante d ON v.loc3=d.loc1
WHERE INSTR(sir, '*'||d.loc2||'*') = 0 AND v.loc3 <> pac_loc.f_loc_dest()
UNION
SELECT v.loc1, v.loc2, v.loc3, d.loc1, v.distanta + d.distanta, 
 sir ||'*'|| d.loc1 ||'*' AS sir 
FROM v_ordin2 v INNER JOIN distante d ON v.loc3=d.loc2 
WHERE INSTR(sir, '*'||d.loc1||'*') = 0 AND v.loc3 <> pac_loc.f_loc_dest()
WITH READ ONLY ;

----------------------
DROP VIEW v_ordin4 ;
CREATE  VIEW v_ordin4 AS
SELECT v.loc1, v.loc2, v.loc3, v.loc4, d.loc2 AS loc5, v.distanta + d.distanta AS distanta,
 sir ||'*'|| d.loc2 ||'*' AS sir 
FROM v_ordin3 v INNER JOIN distante d ON v.loc4=d.loc1
WHERE INSTR(sir, '*'||d.loc2||'*') = 0 AND v.loc4 <> pac_loc.f_loc_dest()
UNION
SELECT v.loc1, v.loc2, v.loc3, v.loc4, d.loc1, v.distanta + d.distanta, 
 sir ||'*'|| d.loc1 ||'*' AS sir 
FROM v_ordin3 v INNER JOIN distante d ON v.loc4=d.loc2 
WHERE INSTR(sir, '*'||d.loc1||'*') = 0 AND v.loc4 <> pac_loc.f_loc_dest() 
WITH READ ONLY ;

----------------------
DROP VIEW v_ordin5 ;
CREATE  VIEW v_ordin5 AS
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, d.loc2 AS loc6, 
  v.distanta + d.distanta AS distanta, sir ||'*'|| d.loc2 ||'*' AS sir 
FROM v_ordin4 v INNER JOIN distante d ON v.loc5=d.loc1
WHERE INSTR(sir, '*'||d.loc2||'*') = 0 AND v.loc5 <> pac_loc.f_loc_dest()
UNION
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, d.loc1, v.distanta + d.distanta, 
 sir ||'*'|| d.loc1 ||'*' AS sir 
FROM v_ordin4 v INNER JOIN distante d ON v.loc5=d.loc2 
WHERE INSTR(sir, '*'||d.loc1||'*') = 0 AND v.loc5 <> pac_loc.f_loc_dest() 
WITH READ ONLY ;

----------------------
DROP VIEW v_ordin6 ;
CREATE  VIEW v_ordin6 AS
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, v.loc6, d.loc2 AS loc7, 
  v.distanta + d.distanta AS distanta, sir ||'*'|| d.loc2 ||'*' AS sir 
FROM v_ordin5 v INNER JOIN distante d ON v.loc6=d.loc1
WHERE INSTR(sir, '*'||d.loc2||'*') = 0 AND v.loc6 <> pac_loc.f_loc_dest()
UNION
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, v.loc6, d.loc1, v.distanta + d.distanta, 
 sir ||'*'|| d.loc1 ||'*' AS sir 
FROM v_ordin5 v INNER JOIN distante d ON v.loc6=d.loc2 
WHERE INSTR(sir, '*'||d.loc1||'*') = 0 AND v.loc6 <> pac_loc.f_loc_dest()
WITH READ ONLY ;

----------------------
DROP VIEW v_ordin7 ;
CREATE  VIEW v_ordin7 AS
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, v.loc6, v.loc7, d.loc2 AS loc8, 
  v.distanta + d.distanta AS distanta, sir ||'*'|| d.loc2 ||'*' AS sir 
FROM v_ordin6 v INNER JOIN distante d ON v.loc7=d.loc1
WHERE INSTR(sir, '*'||d.loc2||'*') = 0 AND v.loc7 <> pac_loc.f_loc_dest()
UNION
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, v.loc6, v.loc7, d.loc1, v.distanta + d.distanta, 
 sir ||'*'|| d.loc1 ||'*' AS sir 
FROM v_ordin6 v INNER JOIN distante d ON v.loc7=d.loc2 
WHERE INSTR(sir, '*'||d.loc1||'*') = 0 AND v.loc7 <> pac_loc.f_loc_dest() 
WITH READ ONLY ;

----------------------
DROP VIEW v_ordin8 ;
CREATE  VIEW v_ordin8 AS
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, v.loc6, v.loc7, v.loc8, d.loc2 AS loc9, 
  v.distanta + d.distanta AS distanta, sir ||'*'|| d.loc2 ||'*' AS sir 
FROM v_ordin7 v INNER JOIN distante d ON v.loc8=d.loc1
WHERE INSTR(sir, '*'||d.loc2||'*') = 0 AND v.loc8 <> pac_loc.f_loc_dest()
UNION
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, v.loc6, v.loc7, v.loc8, d.loc1, v.distanta + d.distanta, 
 sir ||'*'|| d.loc1 ||'*' AS sir 
FROM v_ordin7 v INNER JOIN distante d ON v.loc8=d.loc2 
WHERE INSTR(sir, '*'||d.loc1||'*') = 0 AND v.loc8 <> pac_loc.f_loc_dest() 
WITH READ ONLY ;

----------------------
DROP VIEW v_ordin9 ;
CREATE  VIEW v_ordin9 AS
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, v.loc6, v.loc7, v.loc8, 
 v.loc9, d.loc2 AS loc10, 
  v.distanta + d.distanta AS distanta, sir ||'*'|| d.loc2 ||'*' AS sir 
FROM v_ordin8 v INNER JOIN distante d ON v.loc9=d.loc1
WHERE INSTR(sir, '*'||d.loc2||'*') = 0 AND v.loc9 <> pac_loc.f_loc_dest()
UNION
SELECT v.loc1, v.loc2, v.loc3, v.loc4, v.loc5, v.loc6, v.loc7, v.loc8, 
 v.loc9, d.loc1, v.distanta + d.distanta, 
 sir ||'*'|| d.loc1 ||'*' AS sir 
FROM v_ordin8 v INNER JOIN distante d ON v.loc9=d.loc2 
WHERE INSTR(sir, '*'||d.loc1||'*') = 0 AND v.loc9 <> pac_loc.f_loc_dest()
WITH READ ONLY ;

DROP VIEW trasee ;
CREATE VIEW trasee AS
 SELECT sir, distanta FROM v_ordin1 WHERE loc1= pac_loc.f_loc_init() AND loc2=pac_loc.f_loc_dest()  
 UNION
 SELECT sir, distanta FROM v_ordin2 WHERE loc1= pac_loc.f_loc_init() AND loc3=pac_loc.f_loc_dest()  
 UNION
 SELECT sir, distanta FROM v_ordin3 WHERE loc1= pac_loc.f_loc_init() AND loc4=pac_loc.f_loc_dest()  
 UNION
 SELECT sir, distanta FROM v_ordin4 WHERE loc1= pac_loc.f_loc_init() AND loc5=pac_loc.f_loc_dest()  
 UNION
 SELECT sir, distanta FROM v_ordin5 WHERE loc1= pac_loc.f_loc_init() AND loc6=pac_loc.f_loc_dest()  
 UNION
 SELECT sir, distanta FROM v_ordin6 WHERE loc1= pac_loc.f_loc_init() AND loc7=pac_loc.f_loc_dest()  
 UNION
 SELECT sir, distanta FROM v_ordin7 WHERE loc1= pac_loc.f_loc_init() AND loc8=pac_loc.f_loc_dest()  
 UNION
 SELECT sir, distanta FROM v_ordin8 WHERE loc1= pac_loc.f_loc_init() AND loc9=pac_loc.f_loc_dest()  
 UNION
 SELECT sir, distanta FROM v_ordin9 WHERE loc1= pac_loc.f_loc_init() AND loc10=pac_loc.f_loc_dest()  
WITH READ ONLY ;


