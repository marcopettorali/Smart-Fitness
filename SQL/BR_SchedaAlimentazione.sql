DELIMITER $$

DROP TRIGGER IF EXISTS BR_SchedaAlimentazione $$

CREATE TRIGGER BR_SchedaAlimentazione
BEFORE INSERT ON SchedaAlimentazione
FOR EACH ROW
BEGIN

	DECLARE counter INTEGER DEFAULT 0;

	SELECT COUNT(*) INTO counter
    FROM SchedaAlimentazione SA
    WHERE SA.Cliente = NEW.Cliente
          AND (SA.DataFineScheda > NEW.DataInizioScheda) 
          AND (SA.DataInizioScheda < NEW.DataFineScheda);
          
	IF counter <> 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Scheda di alimentazione non valida: collisione con altre schede.';
	END IF;

END$$

DELIMITER ;

INSERT INTO schedaalimentazione (`DataInizioScheda`,`DataFineScheda`,`FrequenzaVisita`,`Obiettivo`,`Cliente`,`Medico`,`Dieta`) VALUES ("2017-10-01","2017-10-26",13,"Perdere peso","UQIZOV25V73C272I","OMWNJU43A25S323Z",47);
INSERT INTO schedaalimentazione (`DataInizioScheda`,`DataFineScheda`,`FrequenzaVisita`,`Obiettivo`,`Cliente`,`Medico`,`Dieta`) VALUES ("2017-10-10","2017-10-30",13,"Perdere peso","UQIZOV25V73C272I","OMWNJU43A25S323Z",47);