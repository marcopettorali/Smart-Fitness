DELIMITER $$

DROP PROCEDURE IF EXISTS ClientiPresenti$$

CREATE PROCEDURE ClientiPresenti (IN centro INTEGER)
BEGIN
   
	SELECT COUNT(*) AS ClientiPresenti
    FROM Accesso A
    WHERE A.Centro = centro
          AND A.TimestampUscita IS NULL;

END$$
DELIMITER ;

INSERT INTO `Accesso` (`TimestampIngresso`,`TimestampUscita`,`Centro`,`Cliente`,`Armadietto`) VALUES ("2017-03-02 14:05:01",NULL,1,"MGFFGE15A53P239T",248);
CALL ClientiPresenti(1);