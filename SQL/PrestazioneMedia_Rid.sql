DELIMITER $$

DROP PROCEDURE IF EXISTS PrestazioneMedia_Rid$$

CREATE PROCEDURE PrestazioneMedia_Rid (IN esercizio INTEGER)
BEGIN
	
    SELECT (E.TotDurata / E.TotEsecuzioni) AS DurataMedia,
           (E.TotVoto / E.TotEsecuzioni) AS GiudizioMedio
    FROM Esercizio E
    WHERE E.CodEsercizio = esercizio;

END$$
DELIMITER ;

INSERT INTO `esercizio`(`CodEsercizio`,`Nome`,`DispendioEnergetico`,`TotEsecuzioni`,`TotDurata`,`TotVoto`)VALUES(51,"Trivella",500,10,340,70);

CALL PrestazioneMedia_Rid(51);

DELETE 
FROM esercizio
WHERE CodEsercizio = 51;