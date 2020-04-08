DELIMITER $$

DROP PROCEDURE IF EXISTS AttesaSale$$

CREATE PROCEDURE AttesaSale (IN centro INTEGER)
BEGIN
   
	SELECT D.Sala, AVG(D.Attesa) as AttesaMedia
	FROM (
			SELECT PE1.CodPrestazione as Prestazione,
				   S1.Luogo as Sala,
				   TIME_TO_SEC(TIMEDIFF(PE2.TimestampInizio,PE1.TimestampFine)) as Attesa
			FROM PrestazioneEsercizio PE1
				 INNER JOIN PrestazioneEsercizio PE2 USING (Cliente)
                 
				 INNER JOIN Esercizio E1 ON PE1.Esercizio = E1.CodEsercizio
				 INNER JOIN ConfigurazioneEsercizio C1 ON C1.Esercizio=E1.CodEsercizio
				 INNER JOIN Attrezzatura A1 ON C1.Attrezzatura=A1.CodAttrezzatura
				 INNER JOIN Sala S1 ON A1.Sala = S1.Luogo
				 INNER JOIN LuogoAllenamento L1 ON S1.Luogo = L1.CodLuogo
                 
				 INNER JOIN Esercizio E2 ON PE2.Esercizio = E2.CodEsercizio
				 INNER JOIN ConfigurazioneEsercizio C2 ON C2.Esercizio=E2.CodEsercizio
				 INNER JOIN Attrezzatura A2 ON C2.Attrezzatura=A2.CodAttrezzatura
				 INNER JOIN Sala S2 ON A2.Sala = S2.Luogo
				 INNER JOIN LuogoAllenamento L2 ON S2.Luogo = L2.CodLuogo
                 
			WHERE S2.Luogo=S1.Luogo
				  AND L1.Centro = centro 
				  AND PE2.TimestampInizio > PE1.TimestampFine
				  AND PE2.Cliente = PE1.Cliente
				  AND NOT EXISTS(
								 SELECT *
								 FROM PrestazioneEsercizio PE3
								 WHERE PE3.Cliente = PE1.Cliente
									   AND PE3.TimestampInizio >
										   PE1.TimestampInizio
									   AND PE3.TimestampInizio <
										   PE2.TimestampInizio
								)
			) AS D

	GROUP BY D.Sala;



END$$
DELIMITER ;

INSERT INTO configurazioneesercizio(`CodConfigurazione`,`Esercizio`,`Attrezzatura`)VALUES(1,1,1);

INSERT INTO `fitness`.`cliente`(`CodFiscale`,`Nome`,`Cognome`,`Indirizzo`,`DataNascita`,`CodDocumento`,`Prefettura`,`Username`,`Password`,`VisiteMedico`,`Medico`,`Tutor`,`Scopo`)VALUES("aaa1","Adriano","Altobelli","piazza Piazza 1","1900-10-01",12,"Cecina","abdul","de",13,"OBWUSS39P17L433J","GKKPEZ75N51L084K","Dimagrimento");
INSERT INTO `fitness`.`prestazioneesercizio`(`CodPrestazione`,`ValutazionePrestazione`,`TimestampInizio`,`TimestampFine`,`Cliente`,`Esercizio`,`Durata`,`TempoRecupero`,`NumeroRipetizioni`)VALUES(201,3,"2017-10-02 15:00:00","2017-10-02 15:00:30","aaa1",1,NULL,NULL,NULL);
INSERT INTO `fitness`.`prestazioneesercizio`(`CodPrestazione`,`ValutazionePrestazione`,`TimestampInizio`,`TimestampFine`,`Cliente`,`Esercizio`,`Durata`,`TempoRecupero`,`NumeroRipetizioni`)VALUES(202,3,"2017-10-02 16:00:00","2017-10-02 16:00:30","aaa1",1,NULL,NULL,NULL);
CALL AttesaSale(7);

DELETE FROM CONFIGURAZIONEESERCIZIO;
DELETE FROM prestazioneesercizio WHERE cliente = "aaa1";
DELETE FROM cliente WHERE CodFiscale= "aaa1";