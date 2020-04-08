DELIMITER $$

DROP PROCEDURE IF EXISTS ArmadiettiLiberi$$

CREATE PROCEDURE ArmadiettiLiberi (IN centro INTEGER)
BEGIN
   
   SELECT AR.Spogliatoio, AR.CodArmadietto
   FROM Armadietto AR
        INNER JOIN Spogliatoio SP ON AR.Spogliatoio = SP.CodSpogliatoio
   WHERE SP.Centro = centro
         AND NOT EXISTS (
						 SELECT *
						 FROM Accesso AC
						 WHERE AC.TimestampUscita IS NULL
							   AND AC.Armadietto = AR.CodArmadietto
						)
   ORDER BY AR.Spogliatoio, AR.CodArmadietto;

END$$
DELIMITER ;

CALL ArmadiettiLiberi(1);
INSERT INTO `Accesso` (`TimestampIngresso`,`TimestampUscita`,`Centro`,`Cliente`,`Armadietto`) VALUES ("2017-03-02 14:05:01", NULL ,11,"MGFFGE15A53P239T",146);
CALL ArmadiettiLiberi(1);
