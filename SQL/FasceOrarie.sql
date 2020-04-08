DELIMITER $$

DROP PROCEDURE IF EXISTS FasceOrarie$$

CREATE PROCEDURE FasceOrarie (IN centro INTEGER)
BEGIN
   
	DROP TABLE IF EXISTS FasceOrarie;
	CREATE TEMPORARY TABLE FasceOrarie(
	  OraInizio INTEGER NOT NULL,
	  OraFine INTEGER NOT NULL,
	  PRIMARY KEY (OraInizio)
	) ENGINE = InnoDB DEFAULT CHARSET = latin1;

	INSERT INTO FasceOrarie
	VALUES (8,9),(9,10),(10,11),(11,12),(12,13),(13,14),(14,15),(15,16),(16,17),(17,18),(18,19),(19,20),(20,21),(21,22);

	SELECT FO.OraInizio, 
		   FO.OraFine, 
		   DAYOFWEEK(A.TimestampIngresso) AS GiornoSettimana,
		   COUNT(*) AS Accessi
	FROM accesso A
		 CROSS JOIN FasceOrarie FO
	WHERE A.Centro = centro
		  AND(
          
			  (HOUR(TimestampIngresso)=FO.OraInizio)
              
			  OR
              
			  (
			   (HOUR(TimestampIngresso)<FO.OraInizio)
				AND 
				TimestampUscita IS NOT NULL
				AND
				HOUR(TimestampUscita)>FO.OraFine
			   )
               
			  OR
              
			  (
			   (HOUR(TimestampIngresso)<FO.OraInizio)
				AND 
				TimestampUscita IS NULL
			  )
			)
	GROUP BY FO.OraInizio, FO.OraFine, DAYOFWEEK(A.TimestampIngresso);  



END$$
DELIMITER ;


CALL FasceOrarie(1);