DELIMITER $$

DROP TRIGGER IF EXISTS BR_DataAllenamento $$

CREATE TRIGGER BR_DataAllenamento
BEFORE INSERT ON SchedaAllenamento
FOR EACH ROW
BEGIN

	IF(NEW.DataInizioScheda > NEW.DataFineScheda) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile inserire questa scheda: la data di fine è precedente a quella di inizio.';
	END IF;

END$$

DELIMITER ;

INSERT INTO `SchedaAllenamento` (`DataInizioScheda`,`DataFineScheda`,`Cliente`,`DataAssegnazione`,`Tutor`) VALUES ("2016-11-09","2015-08-18","FCBJVY51E68U062F","2016-07-04","MFBXWE51L86Q996V");