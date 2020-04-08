DELIMITER $$

DROP TRIGGER IF EXISTS Aggiorna_ClientiPresenti$$

CREATE TRIGGER Aggiorna_ClientiPresenti
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
DELIMITER ;

INSERT INTO Accesso (`TimestampIngresso`,`TimestampUscita`,`Centro`,`Cliente`,`Armadietto`) VALUES ("2017-07-10 10:00:00", NULL, 1, "ZURYUH23F36Q518L", 1);
CALL ClientiPresenti_Rid(1);
