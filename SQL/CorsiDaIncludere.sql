DELIMITER $$

DROP PROCEDURE IF EXISTS CorsiDaIncludere$$

CREATE PROCEDURE CorsiDaIncludere (IN centro INTEGER)
BEGIN
   
	SELECT DISTINCT C.*
	FROM Corso C
		 INNER JOIN Pianificazionecorso PC ON C.CodCorso = PC.Corso
		 INNER JOIN LuogoAllenamento LA ON PC.Luogo = LA.CodLuogo
		 INNER JOIN OffertaCorso AC ON AC.Corso = C.CodCorso
		 INNER JOIN Offerta O ON AC.Offerta = O.CodOfferta
		 INNER JOIN InclusioneOfferta IO ON O.CodOfferta = IO.Offerta
	WHERE O.TipoOfferta = 'personalizzata'
		  AND LA.Centro = centro
		  AND 0.1 * 
					(
					  SELECT COUNT(*)
					  FROM Contratto CO
						   INNER JOIN InclusioneOfferta IO1 
									  ON IO1.Contratto=CO.CodContratto
						   INNER JOIN Offerta O1
									  ON O1.CodOfferta = IO1.Offerta
					  WHERE O1.Centro = centro
					 )>(
						SELECT COUNT(*)
						FROM Corso C1
							 INNER JOIN OffertaCorso AC1
										ON AC1.Corso = C1.CodCorso
							 INNER JOIN Offerta O2
										ON AC1.Offerta = O2.CodOfferta
							 INNER JOIN InclusioneOfferta IO2 
										ON O2.CodOfferta = IO2.Offerta
						WHERE O2.Centro = 7
							  AND O2.TipoOfferta <> 'personalizzata'
							  AND C1.CodCorso = C.CodCorso
					);

END$$
DELIMITER ;

CALL CorsiDaIncludere(7);