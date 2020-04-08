DELIMITER $$

DROP PROCEDURE IF EXISTS EserciziSvolti$$

CREATE PROCEDURE EserciziSvolti ()
BEGIN
   
   SELECT PE.Esercizio, COUNT(*)
   FROM PrestazioneEsercizio PE
   WHERE PE.TimestampFine IS NULL
   GROUP BY PE.Esercizio;

END$$
DELIMITER ;

INSERT INTO `PrestazioneEsercizio` (`ValutazionePrestazione`,`TimestampInizio`,`TimestampFine`,`Cliente`,`Esercizio`,`Durata`,`TempoRecupero`,`NumeroRipetizioni`) VALUES (NULL,"2017-07-02 15:00:00",NULL,"TNAJWU76Z04W587D",4,142,NULL,NULL);
CALL EserciziSvolti();