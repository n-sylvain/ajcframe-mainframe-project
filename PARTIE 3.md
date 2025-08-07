PARTIE 3 :
    
voir le tp08 cobol de steeve

SQL

requête info d'une commande et l'intégrer dans 
APIX.project.extract.data
affichage de la facture en M.5
et enregistrement des données de la factures dans
APIX.project.factures.data


extraire les infos utiles a la facturation par requete sql sur notre BDD (exec sql ... ) pour creer un fichier indexe (VSAM) projet.extract.data 

a partir de ce fichier on peut y acceder avec la clé client et creer un fichier sequetiel avec seulement les infos de ce client en particulier necessaires a la facturation : O NO, O DATE, DESCRIPTION, QUANTITY, PRICE (le reste a voir plus tard notamment LNAME FNAME)


tests: vérification données pour une commande


question steeve :
    - formatage facture à faire ?

