DELIMITER $$

DROP PROCEDURE IF EXISTS ClientiPresenti_Rid$$

CREATE PROCEDURE ClientiPresenti_Rid (IN centro INTEGER)
BEGIN
   
	SELECT C.ClientiPresenti
    FROM Centro C
    WHERE C.CodCentro = centro;

END$$
DELIMITER ;

INSERT INTO `accesso`(`TimestampIngresso`,`TimestampUscita`,`Centro`,`Cliente`,`Armadietto`)VALUES("2017-01-01 15:00:00",NULL,1,"RSVEVW97X95G939O",21);
CALL ClientiPresenti_Rid(1);