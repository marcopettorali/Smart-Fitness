DELIMITER $$

DROP TRIGGER IF EXISTS BR_DataAlimentazioneData $$

CREATE TRIGGER BR_DataAlimentazioneData
BEFORE INSERT ON SchedaAlimentazione
FOR EACH ROW
BEGIN

	IF(NEW.DataInizioScheda > NEW.DataFineScheda) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile inserire questa scheda: la data di fine è precedente a quella di inizio.';
	END IF;

END$$

DELIMITER ;

INSERT schedaalimentazione (`DataInizioScheda`,`DataFineScheda`,`FrequenzaVisita`,`Obiettivo`,`Cliente`,`Medico`,`Dieta`) VALUES ("2017-10-01","2017-09-26",13,"Perdere peso","UQIZOV25V73C272I","OMWNJU43A25S323Z",47)