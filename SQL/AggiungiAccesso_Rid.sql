DELIMITER $$

DROP PROCEDURE IF EXISTS AggiungiAccesso_Rid$$

CREATE PROCEDURE AggiungiAccesso_Rid (IN timestamp_ingresso DATETIME,
									  IN timestamp_uscita DATETIME, 
                                      IN centro INTEGER, 
                                      IN cliente VARCHAR(255),
									  IN armadietto INTEGER)
BEGIN
    
	DECLARE clienti_presenti INTEGER DEFAULT 0;
    DECLARE max_clienti INTEGER DEFAULT 0;
    
	SELECT C.ClientiPresenti INTO clienti_presenti
    FROM Centro C
    WHERE C.CodCentro = centro;
          
	SELECT MaxClienti INTO max_clienti
    FROM Centro C
    WHERE C.CodCentro = centro;
		
	IF max_clienti > clienti_presenti THEN
		INSERT INTO `Accesso` (`TimestampIngresso`,`TimestampUscita`,`Centro`,`Cliente`,`Armadietto`) 
        VALUES (timestamp_ingresso,timestamp_uscita, centro, cliente, armadietto);
	END IF;

END$$
DELIMITER ;

INSERT INTO `Centro` (`Indirizzo`,`NumeroTelefonico`,`Dimensione`,`MaxClienti`,`ClientiPresenti`,`Direttore`) VALUES ("via Fumagalli e Preziosi 69","31209",3200,1,1,"BNQVEH76N29F860W");
CALL AggiungiAccesso_Rid("2016-03-02 14:05:01",NULL,21,"MGFFGE15A53P239T",248);

