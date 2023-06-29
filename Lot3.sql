----------------------------------------
--////// LOT 3 \\\\\\
----------------------------------------

--*TRIGGER maj_solde*
CREATE OR REPLACE TRIGGER maj_solde  
BEFORE INSERT  ON operation  
FOR EACH ROW   
DECLARE   
    cpt_nouvo number ; 
    valOpt_nouvo number ; 
    idOpt_nouvo number ;
    
    v_libelle VARCHAR(30) ; 
    v_solde number ; 
    v_Decouvert number ;
    v_typeCompte number ; 
    
    solde_nouvo number;
    depassement number ; 
    
  
BEGIN   
    cpt_nouvo := :NEW.idCompte ;  
    valOpt_nouvo := :NEW.MontantOperation ;  
    idOpt_nouvo := :NEW.IdOperation ; 
     
    SELECT 
    LibelleCompte, 
    SoldeCompte, 
    DecouvertAutorise, 	     
    IdTypeCompte 
    into 
    v_libelle, 
    v_solde, 
    v_Decouvert, 
    v_typeCompte 
    FROM COMPTE WHERE IdCompte=cpt_nouvo ; 
    
    solde_nouvo := v_solde + valOpt_nouvo ;
    depassement := -(solde_nouvo + v_Decouvert) ;
    
    -- le trigger se lancera si je reçois un salaire par exple
    -- ou si je fais une dépense sans être encore à découvert
    -- ou si je fais un virement depuis mon compte epargne qui le laisse positif
    IF (valOpt_nouvo > 0) 
    OR (v_typeCompte = 1) AND ( (valOpt_nouvo < 0) AND (v_solde > - v_Decouvert) )
    OR (v_typeCompte != 1) AND (v_solde > - valOpt_nouvo)
    THEN
      		
begin
	-- routine : mise à jour du solde du compte concerné
	UPDATE compte set SoldeCompte = SoldeCompte + valOpt_nouvo WHERE IdCompte=cpt_nouvo;
	
	-- conditionnel : mise à decouvert par debit sur mon compte courant
   	if (v_typeCompte = 1) AND (valOpt_nouvo < 0) AND (v_solde + v_Decouvert < -valOpt_nouvo)
   	THEN  
   	INSERT INTO  
    	AUDITDECOUVERT  
	VALUES  
    	(  
        SeqIdAudit.NEXTVAL,  
        cpt_nouvo,  
        v_libelle,  
        solde_nouvo,  
        v_Decouvert,  
        depassement,  
        idOpt_nouvo  
    	); 
    	-- conditionnel : annulation du decouvert par credit sur mon compte (courant)
    	elsif (valOpt_nouvo > 0) AND (v_solde + v_Decouvert > -valOpt_nouvo)
    	THEN 
    	DELETE
    	FROM AUDITDECOUVERT
    	WHERE IdCompte = cpt_nouvo ;
    	end if;  
      
end;
END IF;

END maj_solde;

