DELIMITER $$

DROP PROCEDURE IF EXISTS IscrittiCorso$$

CREATE PROCEDURE IscrittiCorso (IN corso INTEGER)
BEGIN

    SELECT C.*
    FROM Iscrizione I
		INNER JOIN Cliente C ON I.Cliente = C.CodFiscale
	WHERE I.Corso = corso;

END$$
DELIMITER ;

CALL IscrittiCorso(1);