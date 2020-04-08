DELIMITER $$

DROP TRIGGER IF EXISTS BR_Turnazione $$

CREATE TRIGGER BR_Turnazione
BEFORE INSERT ON Turnazione
FOR EACH ROW
BEGIN

	DECLARE counter INTEGER DEFAULT 0;

	SELECT COUNT(*) INTO counter
    FROM Turnazione T
    WHERE T.Dipendente = NEW.Dipendente
          AND (T.OraFineTurno > NEW.OraInizioTurno) 
          AND (T.OraInizioTurno < NEW.OraFineTurno);
          
	IF counter <> 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Piano di turnazione non valido: collisione con altri turni.';
	END IF;

END$$

DELIMITER ;

INSERT INTO turnazione (OraInizioTurno, OraFineTurno, Centro, Giorno, Dipendente) VALUES ("10:00", "11:00", 1, "Lunedi", "ATUOJH74Q20B130T");
INSERT INTO turnazione (OraInizioTurno, OraFineTurno, Centro, Giorno, Dipendente) VALUES ("11:00", "12:00", 1, "Lunedi", "ATUOJH74Q20B130T");
INSERT INTO turnazione (OraInizioTurno, OraFineTurno, Centro, Giorno, Dipendente) VALUES ("10:30", "11:30", 1, "Lunedi", "ATUOJH74Q20B130T");
