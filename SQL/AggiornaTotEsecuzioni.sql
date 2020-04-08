DELIMITER $$

DROP TRIGGER IF EXISTS Aggiorna_TotEsecuzioni$$

CREATE TRIGGER Aggiorna_TotEsecuzioni
AFTER UPDATE ON PrestazioneEsercizio
FOR EACH ROW
BEGIN
    
    IF (NEW.TimestampFine IS NOT NULL 
       AND OLD.TimestampFine IS NULL) THEN
		
		UPDATE Esercizio
		SET TotEsecuzioni=TotEsecuzioni + 1
		WHERE CodEsercizio=NEW.Esercizio;
		
		UPDATE Esercizio
		SET TotVoto=TotVoto + NEW.ValutazionePrestazione
		WHERE CodEsercizio=NEW.Esercizio;
		
		UPDATE Esercizio
		SET TotDurata=TotDurata + TIME_TO_SEC(TIMEDIFF(NEW.TimestampFine, NEW.TimestampInizio))
		WHERE CodEsercizio=NEW.Esercizio;
        
	END IF;

END$$
DELIMITER ;

 SELECT *
 FROM esercizio
 WHERE CodEsercizio=4;

 INSERT INTO `PrestazioneEsercizio` (`ValutazionePrestazione`,`TimestampInizio`,`TimestampFine`,`Cliente`,`Esercizio`,`Durata`,`TempoRecupero`,`NumeroRipetizioni`) VALUES (NULL,"2017-07-02 15:00:00",NULL,"TNAJWU76Z04W587D",4,NULL,NULL,NULL);
 
 UPDATE PrestazioneEsercizio
 SET ValutazionePrestazione=7, TimestampFine = "2017-07-02 15:00:30", Durata=30
 WHERE CodPrestazione = 201;
 
 SELECT *
 FROM esercizio
 WHERE CodEsercizio=4;
