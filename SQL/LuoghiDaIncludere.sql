DELIMITER $$

DROP PROCEDURE IF EXISTS LuoghiDaIncludere$$

CREATE PROCEDURE LuoghiDaIncludere (IN centro INTEGER)
BEGIN
   
	SELECT DISTINCT L.*
	FROM Luogoallenamento L
		 INNER JOIN Offertaluogo OL ON OL.Luogo = L.CodLuogo
		 INNER JOIN Offerta O ON OL.Offerta = O.CodOfferta
		 INNER JOIN InclusioneOfferta IOF ON O.CodOfferta = IOF.Offerta
	WHERE O.TipoOfferta = 'personalizzata'
		  AND L.Centro = centro
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
						FROM luogoallenamento L1
							 INNER JOIN OffertaLuogo OL1
										ON OL1.Luogo = L1.CodLuogo
							 INNER JOIN Offerta O2
										ON OL1.Offerta = O2.CodOfferta
							 INNER JOIN InclusioneOfferta IOF2 
										ON O2.CodOfferta = IOF2.Offerta
						WHERE O2.Centro = centro
							  AND O2.TipoOfferta <> 'personalizzata'
							  AND L1.CodLuogo = L.CodLuogo
					 );

END$$
DELIMITER ;

CALL LuoghiDaIncludere(7);