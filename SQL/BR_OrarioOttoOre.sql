DELIMITER $$

DROP TRIGGER IF EXISTS BR_OrarioOttoOre $$

CREATE TRIGGER BR_OrarioOttoOre
BEFORE INSERT ON Turnazione
FOR EACH ROW
BEGIN

	DECLARE somma_secondi INTEGER DEFAULT 0;
    DECLARE somma_secondi_attuale INTEGER DEFAULT 0;
    DECLARE inizio TIME DEFAULT '';
    DECLARE fine TIME DEFAULT '';
    DECLARE finito INTEGER DEFAULT 0;
    
	DECLARE curTurni CURSOR FOR
	SELECT T.OraInizioTurno, T.OraFineTurno
    FROM Turnazione T
    WHERE T.Dipendente = NEW.Dipendente
          AND T.Giorno = NEW.Giorno;
          
	DECLARE CONTINUE HANDLER FOR
		NOT FOUND SET finito = 1;
        
    OPEN curTurni;
    
	preleva:LOOP
		FETCH curTurni INTO inizio, fine;
        
        IF finito = 1 THEN
			LEAVE preleva;
		END IF;
        
        SET somma_secondi = somma_secondi + TIME_TO_SEC(TIMEDIFF(fine, inizio));
	END LOOP;
    
    
    SET somma_secondi_attuale = somma_secondi + TIME_TO_SEC(TIMEDIFF(NEW.OraFineTurno, NEW.OraInizioTurno));
    
    
    IF (somma_secondi_attuale/3600) > 8 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Piano di turnazione non valido: orario complessivo di lavoro oltre le 8 ore.';
	END IF;
	

END$$

DELIMITER ;

INSERT INTO turnazione(OraInizioTurno, OraFineTurno, Centro, Giorno, Dipendente) VALUES ("10:00", "17:00", 1, "Lunedi", "SKAXXG12V16W363W");
INSERT INTO turnazione(OraInizioTurno, OraFineTurno, Centro, Giorno, Dipendente) VALUES ("17:00", "20:00", 1, "Lunedi", "SKAXXG12V16W363W");
