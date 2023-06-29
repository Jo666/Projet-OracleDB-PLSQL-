--*creation d'un jeu de données*

INSERT INTO BANQUE VALUES(1,'BANQUE POPULAIRE',75016,'3 rue des chats','Paris');
INSERT INTO BANQUE VALUES(2,'HSBC',91150,'3 avenue des champs non elysees','Geneve');
INSERT INTO TYPECOMPTE VALUES(1,'Courant');
INSERT INTO TYPECOMPTE VALUES(2,'Epargne');
INSERT INTO COMPTE VALUES(1,'compte de Tony',1000000,10000,sysdate,1,1);
INSERT INTO COMPTE VALUES(2,'compte de Maryam',5000000,0,sysdate,1,2);
INSERT INTO COMPTE VALUES(3,'compte de Geoffrey',10,0,sysdate,2,2);
INSERT INTO COMPTE VALUES(4,'compte de Florence',250000,10,sysdate,2,1);
