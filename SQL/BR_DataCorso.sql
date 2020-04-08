DELIMITER $$

DROP TRIGGER IF EXISTS BR_DataCorso $$

CREATE TRIGGER BR_DataCorso
BEFORE INSERT ON Corso
FOR EACH ROW
BEGIN

	IF(NEW.DataInizioCorso > NEW.DataFineCorso) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile inserire questo corso: la data di fine è precedente a quella di inizio.';
	END IF;

END$$

DELIMITER ;

INSERT INTO `Corso` (`DataInizioCorso`,`DataFineCorso`,`Livello`,`MaxPartecipanti`,`Istruttore`,`Disciplina`) VALUES ("2016-10-28","2015-08-07",3,16,"TYSNBD89Q35E676H","Zumba");