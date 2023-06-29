--*tests*

-- compte2, valeur9 => opt1
execute AJOUTNOUVOPERATION(2, 9);
-- compte2, valeur10 => opt2
execute AJOUTNOUVOPERATION(2,10); 
-- compte2, valeur10 => opt3
execute AJOUTNOUVOPERATION(2,10);
--compte3, valeur33 => opt4 => solde43 (10+33)
execute AJOUTNOUVOPERATION(3,33); 
-- compte4, valeur44 => opt5
execute AJOUTNOUVOPERATION(4,44); 
select * from CONSULTEROPERATION;
--
select * from CONSULTERCOMPTE;
-- 
select BANQUEOPERATION(2) from dual;
select BANQUEOPERATION(5) from dual;

--------------------------------
execute ANNULEROPERATION(5);
select * from CONSULTEROPERATION;
--
select * from CONSULTERCOMPTE;

--------------------------------
-- decouvertAutorise du compte4 à 10
select * from COMPTE; 
execute MAJDECOUVERTAUTORISE(4,100);
-- decouvertAutorise du compte4 à 100
select * from COMPTE;

--------------------------------
-- operation4 du compte3 passe à 100 => solde110 ((43-33)+110)
execute MAJMONTANTOPERATION(4,100);
select * from CONSULTEROPERATION;
--
select * from CONSULTERCOMPTE;

--------------------------------
select * from CONSULTERCOMPTE;
-- compte3 : solde110=>solde93 -/- compte1 : solde1000000=>solde1000017
execute FAIRETRANSFERTCOMPTE(3,1,17); 
select * from CONSULTEROPERATION;
--
select * from CONSULTERCOMPTE;

--------------------------------
-- VIDE (no data found)
select * from  CONSULTERDECOUVERT; 
-- Operation impossible (Compte epargne toujours positif)
execute FAIRETRANSFERTCOMPTE(3,4,94); 
-- Pas d'operation cree
select * from CONSULTEROPERATION; 
--
-- Pas de maj_solde non plus
select * from CONSULTERCOMPTE; 
--
-- toujours VIDE
select * from  CONSULTERDECOUVERT; 

--------------------------------
-- depense qui doit mettre Tony a decouvert (depassement à 1€)
execute AJOUTNOUVOPERATION(1,-1010018); 
--
-- Tony est bien a decouvert
select * from  CONSULTERDECOUVERT; 
--
-- Operation impossible, puisqu'a decouvert
execute AJOUTNOUVOPERATION(1,-1); 
--
-- toujours 1 seule ligne
select * from  CONSULTERDECOUVERT; 
-- pas d'operation
select * from CONSULTEROPERATION;
-- pas de changement du solde
select * from CONSULTERCOMPTE;
--
-- Tony recoit 2€
execute AJOUTNOUVOPERATION(1,2); 
--
-- VIDE (no data found) => Tony n'est plus a decouvert
select * from  CONSULTERDECOUVERT; 





