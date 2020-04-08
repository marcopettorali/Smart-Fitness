DELIMITER $$

DROP PROCEDURE IF EXISTS PrestazioneMedia$$

CREATE PROCEDURE PrestazioneMedia (IN esercizio INTEGER)
BEGIN
	
    SELECT AVG(D.DurataC) AS DurataMedia,
           AVG(D.ValutazionePrestazione) AS GiudizioMedio
    FROM (
		  SELECT PE.*, 
			     TIME_TO_SEC(TIMEDIFF(PE.TimestampFine, PE.TimestampInizio)) AS DurataC
		  FROM PrestazioneEsercizio PE
		  WHERE PE.Esercizio = esercizio
		 ) AS D;

END$$
DELIMITER ;

CALL PrestazioneMedia(2);
