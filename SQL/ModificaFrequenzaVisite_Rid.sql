DELIMITER $$

DROP PROCEDURE IF EXISTS ModificaFrequenzaVisite_Rid$$

CREATE PROCEDURE ModificaFrequenzaVisite_Rid (IN cliente VARCHAR(255))
BEGIN
   
	DECLARE inizio_scheda VARCHAR(255) DEFAULT '';
    DECLARE totale_visite INTEGER DEFAULT 0;
   
	SELECT SA.DataInizioScheda INTO inizio_scheda
	FROM SchedaAlimentazione SA
	WHERE SA.Cliente = cliente
		  AND (
               (CURRENT_DATE BETWEEN SA.DataInizioScheda AND SA.DataFineScheda)
               OR 
               (CURRENT_DATE > SA.DataInizioScheda AND SA.DataFineScheda IS NULL)
			  );
	
	IF inizio_scheda IS NOT NULL THEN
		SELECT C.VisiteMedico INTO totale_visite
		FROM Cliente C
		WHERE C.CodFiscale = cliente;
        
		UPDATE SchedaAlimentazione SA
		SET SA.FrequenzaVisita = ROUND(DATEDIFF(CURRENT_DATE, inizio_scheda)/totale_visite)
		WHERE SA.Cliente = cliente
			  AND (
                   (CURRENT_DATE BETWEEN SA.DataInizioScheda AND SA.DataFineScheda)
                   OR 
                   (CURRENT_DATE > SA.DataInizioScheda AND SA.DataFineScheda IS NULL)
			     );
	ELSE
       SELECT "Impossibile aggiornare FrequenzaVisite. Non esiste una scheda per il paziente.";
	END IF;

END$$
DELIMITER ;

INSERT INTO `fitness`.`cliente`(`CodFiscale`,`Nome`,`Cognome`,`Indirizzo`,`DataNascita`,`CodDocumento`,`Prefettura`,`Username`,`Password`,`VisiteMedico`,`Medico`,`Tutor`,`Scopo`)VALUES("aaa1","Adriano","Altobelli","piazza Piazza 1","1900-10-01",12,"Cecina","abdul","de",13,"OBWUSS39P17L433J","GKKPEZ75N51L084K","Dimagrimento");
INSERT INTO `fitness`.`schedaalimentazione`(`DataInizioScheda`,`DataFineScheda`,`FrequenzaVisita`,`Obiettivo`,`Cliente`,`Medico`,`Dieta`)VALUES("2017-01-23",NULL,10,"perdere peso","aaa1","OBWUSS39P17L433J",1);
INSERT INTO visita (`DataVisita`,`Medico`,`Cliente`) VALUES ("2017-02-03","OBWUSS39P17L433J","aaa1");
CALL ModificaFrequenzaVisite_Rid("aaa1");

SELECT *
FROM schedaalimentazione
WHERE Cliente="aaa1";
