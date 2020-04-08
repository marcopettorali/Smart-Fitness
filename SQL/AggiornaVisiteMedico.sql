DELIMITER $$

DROP TRIGGER IF EXISTS Aggiorna_VisiteMedico$$

CREATE TRIGGER Aggiorna_VisiteMedico
AFTER INSERT ON Visita
FOR EACH ROW
BEGIN

	DECLARE Medico VARCHAR(255) DEFAULT 0;
	DECLARE Counter INTEGER DEFAULT 0;

	SELECT COUNT(*) INTO Counter
	FROM schedaalimentazione SA
	WHERE SA.Cliente = NEW.Cliente
          AND SA.Medico = NEW.Medico
          AND SA.DataInizioScheda < NEW.DataVisita
          AND SA.DataFineScheda IS NULL;
          
	SELECT C.Medico INTO Medico
    FROM Cliente C
    WHERE C.CodFiscale = NEW.Cliente;
          
	IF Counter <> 0 THEN
		IF Medico = NEW.Medico THEN
			UPDATE Cliente C
            SET C.VisiteMedico = C.VisiteMedico + 1
            WHERE C.CodFiscale = NEW.Cliente;
		END IF;
	ELSE
		UPDATE Cliente C
		SET C.VisiteMedico = 0
		WHERE C.CodFiscale = NEW.Cliente;
    END IF;
    

END$$
DELIMITER ;

INSERT INTO schedaalimentazione(`DataInizioScheda`,`DataFineScheda`,`FrequenzaVisita`,`Obiettivo`,`Cliente`,`Medico`,`Dieta`) VALUES ("2017-01-03",NULL, 5, "perdere peso","QJDEJM67A93E918Q","OBWUSS39P17L433J",1);
INSERT INTO visita (`DataVisita`,`Medico`,`Cliente`) VALUES ("2017-02-03","OBWUSS39P17L433J","QJDEJM67A93E918Q");
CALL TotVisite_Rid("QJDEJM67A93E918Q");

