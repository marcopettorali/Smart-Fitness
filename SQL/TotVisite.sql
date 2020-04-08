DELIMITER $$

DROP PROCEDURE IF EXISTS TotVisite$$

CREATE PROCEDURE TotVisite (IN cliente VARCHAR(255))
BEGIN
   
	DECLARE medico VARCHAR(255) DEFAULT 0;
	DECLARE inizio_scheda VARCHAR(255) DEFAULT "";
   
	SELECT C.Medico INTO medico
	FROM Cliente C
	WHERE C.CodFiscale = cliente;
   
	SELECT SA.DataInizioScheda INTO inizio_scheda
	FROM SchedaAlimentazione SA
	WHERE SA.Cliente = cliente
		  AND CURRENT_DATE BETWEEN SA.DataInizioScheda AND SA.DataFineScheda;
	
	IF inizio_scheda IS NOT NULL THEN
	   SELECT COUNT(*) AS TotaleVisite 
	   FROM Visita V
	   WHERE V.Cliente = cliente
			 AND V.Medico = medico
			 AND V.DataVisita > inizio_scheda;
	ELSE
       SELECT 0 AS TotaleVisite;
	END IF;

END$$
DELIMITER ;

INSERT INTO visita (`DataVisita`,`Medico`,`Cliente`) VALUES ("2017-02-03","OBWUSS39P17L433J","QJDEJM67A93E918Q");
CALL TotVisite("QJDEJM67A93E918Q");