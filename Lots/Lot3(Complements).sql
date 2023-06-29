----------------------------------------
--////// LOT 3 \\\\\\
----------------------------------------

--*VIEW CONSULTERCOMPTE*
CREATE VIEW CONSULTERCOMPTE AS
SELECT
	C.IdCompte,
	C.LibelleCompte,
	C.SoldeCompte,
	TC.LibelleTypeCompte
FROM
	COMPTE C
	INNER JOIN TYPECOMPTE TC ON C.IdTypeCompte = TC.IdTypeCompte;


--*VIEW CONSULTERDECOUVERT*
CREATE VIEW CONSULTERDECOUVERT AS
SELECT
	A.IdCompte,
	A.LibelleCompte,
	TC.LibelleTypeCompte,
	A.SoldeCompte,
	A.Depassement
FROM
	(
		AUDITDECOUVERT A
		INNER JOIN COMPTE C ON A.IdCompte = C.IdCompte
	)
	INNER JOIN TYPECOMPTE TC ON C.IdTypeCompte = TC.IdTypeCompte
WHERE
	TC.IdTypeCompte = C .IdTypeCompte;


--*VIEW CONSULTEROPERATION*
CREATE VIEW CONSULTEROPERATION AS
SELECT
	O.IdOperation,
	O.MontantOperation,
	O.DateOperation
FROM
	OPERATION O
ORDER BY
	O.DateOperation ASC;
