DELIMITER $$

DROP PROCEDURE IF EXISTS NuovaSchedaAllenamento$$

CREATE PROCEDURE NuovaSchedaAllenamento (IN data_inizio DATE, 
                                         IN data_fine DATE,
                                         IN cliente VARCHAR(255),
                                         IN tutor VARCHAR(255),
                                         IN esercizio INTEGER)
BEGIN
   
    DECLARE cod_scheda INTEGER DEFAULT 0;
    DECLARE data_odierna varchar(255) DEFAULT '';
    
    SET data_odierna = CURRENT_DATE;
    
	INSERT INTO SchedaAllenamento(DataInizioScheda, DataFineScheda, Cliente, DataAssegnazione, Tutor)
	VALUES (data_inizio, data_fine, cliente, data_odierna, tutor);

    SELECT CodScheda INTO cod_scheda
	FROM SchedaAllenamento
    WHERE DataAssegnazione = data_odierna
          AND Cliente = cliente
          AND Tutor = tutor
          AND DataInizioScheda = data_inizio
          AND DataFineScheda = data_fine;

	INSERT INTO Composizione
    VALUES (cod_scheda, esercizio);

END$$
DELIMITER ;

CALL NuovaSchedaAllenamento("2017-10-23","2017-11-23", "ZYTMWP14F60D492U", "GKKPEZ75N51L084K", 1);

SELECT *
FROM schedaallenamento
WHERE Cliente="ZYTMWP14F60D492U";
      
