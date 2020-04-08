DELIMITER $$

-- Nuovo accesso di un cliente
DROP TRIGGER IF EXISTS Aggiorna_Accesso_Entrata$$

CREATE TRIGGER Aggiorna_Accesso_Entrata
AFTER INSERT ON Accesso
FOR EACH ROW
BEGIN

	DECLARE presenti INTEGER DEFAULT 0;
	DECLARE massimi INTEGER DEFAULT 0;

	SELECT C.MaxClienti INTO massimi
	FROM Centro C
	WHERE C.CodCentro = NEW.Centro;

	SELECT C.ClientiPresenti INTO presenti
	FROM Centro C
	WHERE C.CodCentro = NEW.Centro;
	
	IF presenti = massimi THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT='Impossibile accedere a questo centro: numero massimo di clienti raggiunto';
	END IF;

	UPDATE Centro
	SET ClientiPresenti=ClientiPresenti + 1
	WHERE CodCentro=NEW.Centro;

END$$

INSERT INTO `Centro` (`Indirizzo`,`NumeroTelefonico`,`Dimensione`,`MaxClienti`,`ClientiPresenti`,`Direttore`) VALUES ("via Fumagalli e Preziosi 69","31209",3200,1,0,"BNQVEH76N29F860W")$$

INSERT INTO `Accesso` (`TimestampIngresso`,`TimestampUscita`,`Centro`,`Cliente`,`Armadietto`) VALUES ("2016-03-02 14:05:01",NULL,21,"MGFFGE15A53P239T",248)$$
INSERT INTO `Accesso` (`TimestampIngresso`,`TimestampUscita`,`Centro`,`Cliente`,`Armadietto`) VALUES ("2016-03-02 14:05:05",NULL,21,"MGFFGE15A53P239T",248)$$


-- Cliente che esce

CREATE TRIGGER Aggiorna_Accesso_Uscita
AFTER UPDATE ON Accesso
FOR EACH ROW
BEGIN

	
	IF(NEW.TimestampUscita <> OLD.TimestampUscita) THEN
		UPDATE Centro
		SET ClientiPresenti=ClientiPresenti - 1
		WHERE CodCentro=NEW.Centro;
     END IF;

END$$


DELIMITER ;

UPDATE accesso
SET TimestampUscita = current_timestamp()
WHERE CodAccesso = 501;

SELECT *
FROM Centro
WHERE CodCentro = 21;
