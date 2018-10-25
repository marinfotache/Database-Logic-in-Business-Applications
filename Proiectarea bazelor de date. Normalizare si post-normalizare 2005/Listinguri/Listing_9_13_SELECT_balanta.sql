SELECT SimbolCont AS Cont, DenumireCont, TipCont,
	(SELECT NVL(SUM(SoldInitDB),0) FROM conturi_elementare 
 WHERE SUBSTR(ContElementar, 1, LENGTH(pc.SimbolCont))
= pc.SimbolCont) SoldInitDB,
	(SELECT NVL(SUM(SoldInitCR),0) FROM conturi_elementare 
 WHERE SUBSTR(ContElementar, 1, LENGTH(pc.SimbolCont))
= pc.SimbolCont) SoldInitCR,
	(SELECT NVL(SUM(RulajDB),0) FROM conturi_elementare 
 WHERE SUBSTR(ContElementar, 1, LENGTH(pc.SimbolCont))
= pc.SimbolCont) RulajDB,
	(SELECT NVL(SUM(RulajCR),0) FROM conturi_elementare 
 WHERE SUBSTR(ContElementar, 1, LENGTH(pc.SimbolCont))
= pc.SimbolCont) RulajCR,
	(SELECT NVL(SUM(SoldInitDB),0)+ NVL(SUM(RulajDB),0)
 FROM conturi_elementare 
 WHERE SUBSTR(ContElementar, 1, LENGTH(pc.SimbolCont))
= pc.SimbolCont) TotalSumeDB,
	(SELECT NVL(SUM(SoldInitCR),0)+ NVL(SUM(RulajCR),0)
 FROM conturi_elementare 
 WHERE SUBSTR(ContElementar, 1, LENGTH(pc.SimbolCont))
= pc.SimbolCont) TotalSumeCR,
(SELECT NVL(SUM(
CASE TipCont
WHEN ‘A’ THEN NVL(SoldInitDB,0) + NVL(RulajDB,0)
- NVL(RulajCR ,0)
WHEN ‘P’ THEN 0
ELSE 
CASE WHEN NVL(SoldInitDB,0) + NVL(RulajDB,0)
- NVL(RulajCR ,0) < 0
THEN 0 ELSE NVL(SoldInitDB,0) + NVL(RulajDB,0)
 - NVL(RulajCR,0)
END
END), 0) 
FROM conturi_elementare 
WHERE SUBSTR(ContElementar, 1, LENGTH(pc.SimbolCont))
= pc.SimbolCont) SoldFinalDB,
(SELECT NVL(SUM(
CASE TipCont
WHEN ‘P’ THEN NVL(SoldInitCR,0) + NVL(RulajCR,0)
- NVL(RulajDB ,0)
WHEN ‘A’ THEN 0
ELSE 
CASE WHEN NVL(SoldInitCR,0) + NVL(RulajCR,0)
- NVL(RulajDB ,0) < 0
THEN 0 ELSE NVL(SoldInitCR,0) + NVL(RulajCR,0)
 - NVL(RulajDB,0)
END
END), 0) 
FROM conturi_elementare 
WHERE SUBSTR(ContElementar, 1, LENGTH(pc.SimbolCont))
= pc.SimbolCont) SoldFinalCR
FROM plan_conturi pc
WHERE LENGTH(SimbolCont)=4 OR LENGTH(SimbolCont)=3 
UNION 
SELECT ‘=====’, ‘=== T O T A L ‘, ‘=’,
	(SELECT NVL(SUM(SoldInitDB),0) FROM conturi_elementare),
	(SELECT NVL(SUM(SoldInitCR),0) FROM conturi_elementare),
	(SELECT SUM(RulajDB) FROM conturi_elementare),
(SELECT SUM(RulajCR) FROM conturi_elementare),
	(SELECT NVL(SUM(SoldInitDB),0)+ NVL(SUM(RulajDB),0)
 FROM conturi_elementare), 
 (SELECT NVL(SUM(SoldInitCR),0)+ NVL(SUM(RulajCR),0)
 FROM conturi_elementare),
(SELECT NVL(SUM(
CASE TipCont
WHEN ‘A’ THEN NVL(SoldInitDB,0) + NVL(RulajDB,0)
- NVL(RulajCR ,0)
WHEN ‘P’ THEN 0
ELSE 
CASE WHEN NVL(SoldInitDB,0) + NVL(RulajDB,0)
- NVL(RulajCR ,0) < 0
THEN 0 ELSE NVL(SoldInitDB,0) + NVL(RulajDB,0)
 - NVL(RulajCR,0)
END
END), 0) 
FROM conturi_elementare ce INNER JOIN plan_conturi pc2
ON contelementar=pc2.simbolcont),
(SELECT NVL(SUM(
CASE TipCont
WHEN ‘P’ THEN NVL(SoldInitCR,0) + NVL(RulajCR,0)
- NVL(RulajDB ,0)
WHEN ‘A’ THEN 0
ELSE 
CASE WHEN NVL(SoldInitCR,0) +
 NVL(RulajCR,0)- NVL(RulajDB ,0) < 0
THEN 0 
ELSE NVL(SoldInitCR,0) + NVL(RulajCR,0)
 - NVL(RulajDB,0)
END
END), 0) 
FROM conturi_elementare ce INNER JOIN plan_conturi pc2
ON contelementar=pc2.simbolcont)
FROM dual 
