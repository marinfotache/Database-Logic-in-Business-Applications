SELECT NumePren, Punctaj_pe_post, T1.IdPost 
FROM 
(SELECT  NumePren, IdPost, SUM(Nivel) AS Punctaj_pe_post
 FROM 
	(SELECT NumePren, marca, p9.idpost, IdCompFrunza, 
		NivelMinimAcceptat, Nivel 
	 FROM personal9 p9 INNER JOIN competente_posturi cpo	
		ON p9.IdPost=cpo.IdPost 
	INNER JOIN competente_personal cpe ON p9.marca=cpe.marca
		AND cpo.IdCompFrunza=cpe.IdCompFrunza AND
		NivelMinimAcceptat <= Nivel
	)	 
GROUP BY numepren, IdPost) T1 INNER JOIN 
	(SELECT IdPost, MAX(Puncte) AS Pct_MAX
	 FROM 
		(SELECT  IdPost, NumePren, SUM(Nivel) AS Puncte
		 FROM 
			(SELECT NumePren, marca, p9.idpost, IdCompFrunza, 
				NivelMinimAcceptat, Nivel 
			 FROM personal9 p9 INNER JOIN competente_posturi cpo	
				ON p9.IdPost=cpo.IdPost 
				INNER JOIN competente_personal cpe ON p9.marca=cpe.marca
				AND cpo.IdCompFrunza=cpe.IdCompFrunza AND
				NivelMinimAcceptat <= Nivel
			)
		GROUP BY IdPost, NumePren)
	GROUP BY IdPost
	) T2 ON T1.IdPost=T2.IdPost AND Punctaj_pe_post =  Pct_MAX

