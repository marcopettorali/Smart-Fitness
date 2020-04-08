DELIMITER $$

DROP TRIGGER IF EXISTS BR_DataSfida $$

CREATE TRIGGER BR_DataSfida
BEFORE INSERT ON Sfida
FOR EACH ROW
BEGIN

	IF(NEW.DataInizio > NEW.DataFine) THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile inserire questa sfida: la data di fine è precedente a quella di inizio.';
	END IF;

END$$

DELIMITER ;

INSERT INTO sfida(DataInizio, DataFine, DataLancio, Scopo, Cliente) VALUES ("2017-10-01", "2017-09-01", "2017-10-01", "perdere 10 kg in un mese", "ONWSJL72Q47N702X");