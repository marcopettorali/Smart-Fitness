DELIMITER $$

DROP PROCEDURE IF EXISTS ModificaFrequenzaVisite$$

CREATE PROCEDURE ModificaFrequenzaVisite (IN cliente VARCHAR(255))
BEGIN

   
	DECLARE medico VARCHAR(255) DEFAULT 0;
	DECLARE inizio_scheda VARCHAR(255) DEFAULT '';
    DECLARE totale_visite INTEGER DEFAULT 0;
      
	SELECT C.Medico INTO medico
	FROM Cliente C
	WHERE C.CodFiscale = cliente;
   
	SELECT SA.DataInizioScheda INTO inizio_scheda
	FROM SchedaAlimentazione SA
	WHERE SA.Cliente = cliente
		  AND (
               (CURRENT_DATE BETWEEN SA.DataInizioScheda AND SA.DataFineScheda)
               OR 
               (CURRENT_DATE > SA.DataInizioScheda AND SA.DataFineScheda IS NULL)
			  );
         
	
	IF inizio_scheda IS NOT NULL THEN
	   SELECT COUNT(*) INTO totale_visite
	   FROM Visita V
	   WHERE V.Cliente = cliente
			 AND V.Medico = medico
			 AND V.DataVisita > inizio_scheda;
			
		
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

INSERT INTO `fitness`.`schedaalimentazione`(`DataInizioScheda`,`DataFineScheda`,`FrequenzaVisita`,`Obiettivo`,`Cliente`,`Medico`,`Dieta`)VALUES("2017-01-23",NULL,10,"perdere peso","QJDEJM67A93E918Q","OBWUSS39P17L433J",1);
INSERT INTO visita (`DataVisita`,`Medico`,`Cliente`) VALUES ("2017-02-03","OBWUSS39P17L433J","QJDEJM67A93E918Q");
CALL ModificaFrequenzaVisite("QJDEJM67A93E918Q");

SELECT *
FROM schedaalimentazione
WHERE Cliente="QJDEJM67A93E918Q";
