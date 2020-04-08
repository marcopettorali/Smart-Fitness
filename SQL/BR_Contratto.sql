DELIMITER $$

DROP TRIGGER IF EXISTS BR_Contratto $$

CREATE TRIGGER BR_Contratto
BEFORE INSERT ON InclusioneOfferta
FOR EACH ROW
BEGIN

	DECLARE counter INTEGER DEFAULT 0;
    
    SELECT COUNT(DISTINCT D.Centro) INTO counter
    FROM(
			SELECT O.Centro
			FROM InclusioneOfferta IOF
				 INNER JOIN Offerta O ON IOF.Offerta = O.CodOfferta
			WHERE IOF.Contratto = NEW.Contratto
            
            UNION
            
            SELECT O1.Centro
            FROM Offerta O1
            WHERE O1.CodOfferta = NEW.Offerta
            
		) as D;
			
    IF counter > 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossibile aggiungere questa offerta a questo contratto: consentito accesso a massimo 3 sedi.';
	END IF;
    

END$$

DELIMITER ;

INSERT INTO `Offerta` (`TipoOfferta`,`MaxIngressi`,`AccessiPiscine`,`CostoMensile`,`Centro`) VALUES ("silver",31,9,69,1);
INSERT INTO `Offerta` (`TipoOfferta`,`MaxIngressi`,`AccessiPiscine`,`CostoMensile`,`Centro`) VALUES ("silver",31,9,69,2);
INSERT INTO `Offerta` (`TipoOfferta`,`MaxIngressi`,`AccessiPiscine`,`CostoMensile`,`Centro`) VALUES ("silver",31,9,69,3);
INSERT INTO `Offerta` (`TipoOfferta`,`MaxIngressi`,`AccessiPiscine`,`CostoMensile`,`Centro`) VALUES ("silver",31,9,69,4);
INSERT INTO `Contratto` (`Durata`,`Tipologia`,`DataSottoscrizione`,`Importo`,`ModalitaDiPagamento`,`Cliente`,`Consulente`,`Centro`) VALUES (76,"Multisede","2017-03-23",59,"UnicaSoluzione","SCPODM72C62W435K","YIXOCT79A13N744M",8);
INSERT INTO inclusioneofferta VALUES(301,101);
INSERT INTO inclusioneofferta VALUES(301,102);
INSERT INTO inclusioneofferta VALUES(301,103);
INSERT INTO inclusioneofferta VALUES(301,104);