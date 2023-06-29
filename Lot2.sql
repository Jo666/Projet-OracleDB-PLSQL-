----------------------------------------
--////// LOT 2 \\\\\\
----------------------------------------

-- FUNCTIONS : la plupart des fonctions ci-dessous n'etaient pas demandees (cf. Lot2(package) )

CREATE OR REPLACE FUNCTION Montant_Opt (IdOpt number) RETURN   
number  
IS   
v_montant number;   
BEGIN   
SELECT MontantOperation INTO v_montant FROM OPERATION WHERE IdOperation = IdOpt;   
RETURN v_montant;   
END Montant_Opt;
/ 
--------------------------------
CREATE OR REPLACE FUNCTION Compte_Opt (IdOpt number) RETURN   
number  
IS   
v_compte number;   
BEGIN   
SELECT IdCompte INTO v_compte FROM OPERATION WHERE IdOperation = IdOpt;   
RETURN v_compte;   
END Compte_Opt;
/
--------------------------------
CREATE OR REPLACE FUNCTION decouvert (Cpt INTEGER) RETURN   
number  
IS   
v_decouvert number;   
BEGIN   
SELECT DecouvertAutorise INTO v_decouvert FROM COMPTE WHERE IdCompte = Cpt;   
RETURN v_decouvert;   
END decouvert;
/
--------------------------------
CREATE OR REPLACE FUNCTION typeDeCompte (Cpt INTEGER) RETURN   
number  
IS   
v_idCompte number;   
BEGIN   
SELECT IdCompte INTO v_idCompte FROM COMPTE WHERE IdCompte = Cpt;   
RETURN v_idCompte;   
END typeDeCompte;
/
--------------------------------
--*FUNCTION SOLDECOMPTE*
CREATE OR REPLACE FUNCTION SOLDECOMPTE (Cpt INTEGER) RETURN   
INTEGER 
IS   
v_montant INTEGER;   
BEGIN   
SELECT SoldeCompte INTO v_montant FROM COMPTE WHERE IdCompte = Cpt;   
RETURN v_montant;   
END SOLDECOMPTE;
/ 
--------------------------------
-- on veut avec cette fonction empecher une operation de se declencher (un mecanismle similaire est implanté dans le trigger qui ne concerne que le calcul du solde)
CREATE OR REPLACE FUNCTION operationPossible (Cpt INTEGER, value NUMBER) RETURN   
boolean  
IS      
BEGIN   
IF ( (typeDeCompte(Cpt) != 1) AND (SOLDECOMPTE(Cpt)> - value) )
OR ( (typeDeCompte(Cpt) = 1) AND (value < 0) AND (SOLDECOMPTE(Cpt) > - decouvert(Cpt)) )
OR ( (typeDeCompte(Cpt) = 1) AND (value > 0) )
THEN RETURN TRUE;
ELSE 
DBMS_OUTPUT.PUT_LINE('Operation impossible. Veuillez consulter votre compte');
RETURN FALSE;
END IF;
END operationPossible;
/
--------------------------------

-- PROCEDURES 

--*PROCEDURE AJOUTNOUVOPERATION* 
CREATE OR replace PROCEDURE AJOUTNOUVOPERATION (
    pIdcompte INTEGER, 
    pValue NUMBER
) 
IS

BEGIN
	IF (operationPossible(pIdcompte, pValue)) THEN
INSERT INTO
	OPERATION
VALUES
	(
		SeqIdOperation.NEXTVAL,
		SYSDATE,
		pValue,
		pIdcompte
	);
end IF;
end AJOUTNOUVOPERATION;
/

--------------------------------

--*PROCEDURE ANNULEROPERATION*
CREATE OR REPLACE PROCEDURE ANNULEROPERATION (
    IdOpt number
) 
IS 
 
BEGIN 
AJOUTNOUVOPERATION(Compte_Opt(IdOpt),-Montant_Opt(IdOpt)) ; 
 
END ANNULEROPERATION;
/

--------------------------------

--*PROCEDURE MAJDECOUVERTAUTORISE*
CREATE OR REPLACE PROCEDURE MAJDECOUVERTAUTORISE (
    pIdcompte INTEGER ,
    pValue NUMBER
)
IS

BEGIN 

UPDATE compte SET DecouvertAutorise = pValue
WHERE IdCompte IN (SELECT IdCompte 
                     FROM compte 
                     WHERE IdCompte = pIdcompte) ;
                     
END MAJDECOUVERTAUTORISE;
/

--------------------------------

--*PROCEDURE MAJMONTANTOPERATION*
CREATE OR REPLACE PROCEDURE MAJMONTANTOPERATION (
    pIdoperation INTEGER ,
    pValue NUMBER
)
IS

BEGIN 
ANNULEROPERATION(pIdoperation) ;
AJOUTNOUVOPERATION(Compte_Opt(pIdoperation),pValue) ;

END MAJMONTANTOPERATION;
/

--------------------------------

--*PROCEDURE FAIRETRANSFERTCOMPTE*
CREATE OR REPLACE PROCEDURE FAIRETRANSFERTCOMPTE (
    CptOrig INTEGER ,
    CptDest INTEGER ,
    pValue NUMBER
) 
IS 
 
BEGIN  
IF (operationPossible(CptOrig,-pValue)) THEN
AJOUTNOUVOPERATION(CptOrig,-pValue) ;
AJOUTNOUVOPERATION(CptDest,pValue) ;

END IF;
END FAIRETRANSFERTCOMPTE;
/

--------------------------------

--*FUNCTION BANQUEOPERATION*
CREATE OR REPLACE FUNCTION BANQUEOPERATION(Idopt INTEGER) RETURN VARCHAR
IS
TRes VARCHAR(50);
BEGIN

SELECT B .LibelleBanque
INTO TRes FROM BANQUE B
INNER JOIN (COMPTE C INNER JOIN OPERATION O ON C.IdCompte = O.IdCompte)
ON B.IdBanque = C.IdBanque
WHERE O.IdOperation = Idopt;
RETURN TRes;
END  BANQUEOPERATION;
/

--------------------------------












 


