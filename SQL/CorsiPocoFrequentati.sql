DELIMITER $$

DROP PROCEDURE IF EXISTS CorsiPocoFrequentati$$

CREATE PROCEDURE CorsiPocoFrequentati (IN centro INTEGER)
BEGIN
   
	SELECT *
	FROM(
		  SELECT C.CodCorso, 
				 C.Disciplina, 
		         C.Livello, 
		         (COUNT(*)/C.MaxPartecipanti) AS RapportoIscrittiMaxIscritti
		  FROM iscrizione I
	           INNER JOIN corso C ON I.Corso = C.CodCorso
	           INNER JOIN PianificazioneCorso PC ON PC.Corso=C.CodCorso
	           INNER JOIN LuogoAllenamento L ON L.CodLuogo=PC.Luogo
		  WHERE L.Centro = centro
			    AND C.DataFineCorso > CURRENT_DATE
		  GROUP BY C.CodCorso, C.Disciplina, C.Livello
		 ) AS D
	ORDER BY D.RapportoIscrittiMaxIscritti;


END$$
DELIMITER ;

CALL CorsiPocoFrequentati(3);