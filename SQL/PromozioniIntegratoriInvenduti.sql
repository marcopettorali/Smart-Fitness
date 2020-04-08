DELIMITER $$

DROP PROCEDURE IF EXISTS PromozioniIntegratoriInvenduti$$

CREATE PROCEDURE PromozioniIntegratoriInvenduti (IN centro INTEGER)
BEGIN
	
	DROP TEMPORARY TABLE IF EXISTS OrdiniIntegratori;
    
    CREATE TEMPORARY TABLE OrdiniIntegratori(
		Integratore INTEGER NOT NULL,
        TotaleOrdini INTEGER NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
	DROP TEMPORARY TABLE IF EXISTS AcquistiIntegratori;
    
    CREATE TEMPORARY TABLE AcquistiIntegratori(
		Integratore INTEGER NOT NULL,
        TotaleAcquisti INTEGER NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = latin1;
    
    INSERT INTO OrdiniIntegratori
	SELECT OI.Integratore, SUM(OI.Quantita)
	FROM Ordine O
		 INNER JOIN OrdineIntegratore OI on O.CodOrdine = OI.Ordine
	WHERE O.Centro = centro
	GROUP BY OI.Integratore;

	INSERT INTO AcquistiIntegratori
	SELECT A.Integratore, SUM(A.Quantita) AS TotaleAcquisti
	FROM Cliente C
		 INNER JOIN Contratto CO on C.CodFiscale = CO.Cliente
		 INNER JOIN Acquisto A on C.CodFiscale = A.Cliente
	WHERE CO.Centro = centro
	GROUP BY A.Integratore;
	
	SELECT OI.Integratore, 
		   OI.TotaleOrdini, 
		   IFNULL(AI.TotaleAcquisti,0) AS TotaleAcquisti,
		   100*
		   (1-(IFNULL(AI.TotaleAcquisti,0)/OI.TotaleOrdini))*
		   (1-(I.PrezzoIngrosso/I.PrezzoDettaglio)) AS Promozione
	FROM OrdiniIntegratori OI
		 LEFT OUTER JOIN AcquistiIntegratori AI USING (Integratore)
		 INNER JOIN Integratore I on OI.Integratore = I.CodIntegratore;


END$$
DELIMITER ;

INSERT INTO integratore (`NomeCommerciale`,`Sostanza`,`Concentrazione`,`DataScadenza`,`NumeroPezzi`,`Forma`,`PrezzoIngrosso`,`PrezzoDettaglio`) VALUES ("Integradol","Arsenico",1000,"2020-10-02",1,"Compressa",1,5);
INSERT INTO `fornitore`(`PartitaIva`,`NomeCommerciale`,`NumeroTelefonico`,`Indirizzo`,`FormaSocietaria`)VALUES(1502,"Camorria",0586,"via dei Tubi","Spa");
INSERT INTO `ordine`(`Stato`,`DataEvasione`,`DataConsegna`,`Centro`,`Fornitore`)VALUES("evaso","2010-08-10","2010-08-20",1,1502);
INSERT INTO ordineintegratore VALUES (1,1,100);
INSERT INTO `acquisto`(`DataAcquisto`,`Quantita`,`Integratore`,`Cliente`,`Importo`)VALUES("2010-01-01",35,1,"BINGER56U83C437P",175);

CALL PromozioniIntegratoriInvenduti(1);
