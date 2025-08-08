Jour 1:
- setup de github sur les PC
  - setup de xquartz sur mac anouar à faire
  - lecture du projet

Jour 2:
+ setup organisation quotidienne (sumup in sumup out)
    15 min:
      5 min chacun sur
        ce qu'on a fait
        les difficultés
        ce qu'on prévoit de faire
+ setup laptop anouar (github, xquartz)
    -> setup anouar pas idéal - vieux mac de 2012, pas à jour, impossibilité d'installer l'outil de transfert de fichier
    beaucoup de problème lié au pc anouar
+ coordination sur github and miro kanban
  - github - Sylvain
  - Miro - Denis
- point d'étape sur la compréhension du projet, partie 1, 2, 3
- éclaircir le formattage de la facture - denis à raison
- partie 3 - sylvain
- partie 4 - denis
- partie 1 & 2 - anouar


Jour 3:

daily scrum
installation des bases
- APIX.SOURCE.SQL.BDDORDER
- APIX.SOURCE.SQL.BDDPARTS
kanban màj par denis

### État d’avancement du projet

- Débrief terminé hier - clarification sur chaque partie du projet
- Points d’interprétation différents résolus
- Notes mises à jour dans le repos Git
- Attribution des parties :
  - Partie 3 : Sylvainni007
  - Partie 4 : Denis
  - Parties 1 et 2 : Arnaud

### Objectifs journée

- Sylvainni007 : Focus total sur partie 3
  - Relecture détaillée des notes
  - Exercice existant identifié par Denis
  - Objectif : quelque chose qui tourne avant pause estivale
- Denis : Conversion fichier employé
  - Maps physiques préparées (interface connexion + saisie nouvelles pièces)
  - Conversion fichier séquentiel vers KSDS pour CICS
  - Installation via CEDA/SEDADEF
  - Développement programme COBOL vérification connexion
- Arnaud : Création bases de données
  - Configuration via SPUFFY (M.16)
  - Questions sur fichiers orders vs parts

### Configuration bases de données

- Transfert fichiers BDD via interface x3270
- Tables créées avec succès :
  - BDD.PARTS : P1 à P5 (stock pièces de rechange)
  - BDD.ORDERS : commandes clients
- Problème résolu pour Denis : table customer pré-existante
- Tous les participants ont maintenant bases identiques

### Problèmes techniques résolus

- Difficultés copier-coller terminal Mac d’Arnaud
  - Solution : transfert fichiers via x3270
  - Éviter risques erreurs sur code long (>20 lignes)
- Configuration écran TSO variable selon utilisateurs
- API différentes nécessitent adaptation des scripts

### Coordination équipe

- Test réussi partage d’écran simultané Discord
- Décision : rester sur Discord pour communication
- Support mutuel pour blocages techniques
- Rappel : rester connecté sur AGC pour décompte temps












🔹 Jour 2 – Début du Développement Partie 1 (NEWPRODS)
Objectif : Débuter le traitement COBOL de NEWPRODS.txt

✅ Tâches à faire :
 Créer une version propre du fichier PROJET.NEWPRODS.DATA

 Écrire le programme COBOL newprods.cbl :

Lire un fichier séquentiel

Nettoyer la description (majuscule au début de chaque mot)

Convertir le prix selon la devise

Générer les INSERT dans la table PRODUCTS

 Écrire un fichier SYSIN taux_conversion.txt (ex : 1 EUR = 1.08 USD, etc.)

 Créer un JCL JCLNEWPRODS.jcl pour tester

 Si possible : faire un test unitaire de ce programme (test_newprods.cbl)

📌 Résumé des 4 parties du projet (PDF)
🔸 Partie 1 : Import de nouveaux produits (NEWPRODS.txt)
Lire le fichier CSV (séparateur ;, max 45 caractères)

Convertir les prix en dollars

Nettoyer les descriptions

Alimenter la table PRODUCTS

🔸 Partie 2 : Import des ventes (VENTEAS.txt & VENTEEU.txt)
Fichiers à structure fixe

Insérer dans ORDERS + ITEMS

Mettre à jour le BALANCE du client concerné

🔸 Partie 3 : Génération de factures
Récupérer les commandes depuis la BDD

Générer un fichier FACTURES.DATA

Format type facture, calcul TVA, commission, etc.

Appel d’un sous-programme COBOL pour afficher la date en toutes lettres

🔸 Partie 4 : Interface CICS
Authentification via EMPLOYE.KSDS

Saisie d’une nouvelle pièce dans NEWPARTS.KSDS

Respecter nomenclature des noms (PARTSX, USERSX, MAPX, TX)

🛠️ À faire à moyen terme
 Automatiser les tests unitaires

 Préparer un plan de démo (script + présentation)

 Ajouter un fichier README.md clair et structuré pour GitHub