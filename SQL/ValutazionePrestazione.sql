DELIMITER $$

DROP TRIGGER IF EXISTS ValutazionePrestazione$$

CREATE TRIGGER ValutazionePrestazione
BEFORE UPDATE ON PrestazioneEsercizio
FOR EACH ROW
BEGIN
   
	DECLARE giudizio DOUBLE DEFAULT 0;
    DECLARE counter INTEGER DEFAULT 0;
	
	IF(OLD.TimestampFine IS NULL AND NEW.TimestampFine IS NOT NULL) THEN
    
        SELECT IFNULL(COUNT(*),0) INTO counter
        FROM Aerobico A
        WHERE A.CodEsercizio = NEW.Esercizio;
        
        IF counter = 1 THEN
			SELECT POW(TIMEDIFF(PE.TimestampFine,PE.TimestampInizio)/AE.Durata, 2)*10 INTO giudizio
			FROM prestazioneesercizio PE
				 INNER JOIN Esercizio E ON PE.Esercizio = E.CodEsercizio
				 INNER JOIN Aerobico AE ON AE.CodEsercizio = E.CodEsercizio
			WHERE PE.Esercizio = NEW.Esercizio;
		
        ELSE
       
			SELECT POW(
						((E.TotDurata/E.TotEsecuzioni)/TIME_TO_SEC(TIMEDIFF(NEW.TimestampFine,NEW.TimestampInizio)))
						*(AN.TempoRecupero/PE.TempoRecupero)
						*(AN.NumeroRipetizioni/PE.NumeroRipetizioni)
						,2
					   )*10 INTO giudizio
							  
			FROM prestazioneesercizio PE
				 INNER JOIN Esercizio E ON PE.Esercizio = E.CodEsercizio
				 INNER JOIN Anaerobico AN ON AN.CodEsercizio = E.CodEsercizio
			WHERE PE.Esercizio = NEW.Esercizio;
            
		END IF;
            
        
            
		SELECT IF(giudizio > 10, 10, giudizio) INTO giudizio;
        
        
            
		SET NEW.ValutazionePrestazione = giudizio;
        
    END IF;

END$$
DELIMITER ;

INSERT INTO `esercizio`(`CodEsercizio`,`Nome`,`DispendioEnergetico`,`TotEsecuzioni`,`TotDurata`,`TotVoto`)VALUES(51,"Trivella",500,10,340,70);
INSERT INTO anaerobico VALUES (51, 15, 3);
INSERT INTO `PrestazioneEsercizio` (CodPrestazione,`ValutazionePrestazione`,`TimestampInizio`,`TimestampFine`,`Cliente`,`Esercizio`,`Durata`,`TempoRecupero`,`NumeroRipetizioni`) VALUES (201,NULL,"2017-07-02 15:00:00",NULL,"TNAJWU76Z04W587D",51,NULL,15,3);
 
  
SELECT *
FROM prestazioneesercizio
WHERE CodPrestazione = 201; 
 
UPDATE PrestazioneEsercizio
 SET TimestampFine = "2017-07-02 15:00:30", Durata=30
 WHERE CodPrestazione = 201;
 
SELECT *
FROM prestazioneesercizio
WHERE CodPrestazione = 201; 