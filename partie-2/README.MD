# Projet MAJDB - Synchronisation des Données de Ventes

## Vue d'ensemble
Le projet MAJDB (Mise À Jour DataBase) est une solution COBOL/DB2 développée pour la société AJCFRAME. Il permet de traiter et synchroniser les données de ventes provenant de deux zones géographiques (Europe et Asie) et de mettre à jour automatiquement la base de données.

## Structure du Projet

```
projet/
├── DATA/
│   ├── VENTESAS.txt      # Données ventes Asie
│   └── VENTESEU.txt      # Données ventes Europe
├── DB2/
│   └── MAJDB.cbl         # Programme principal COBOL
├── DCLGEN/
│   ├── CUST.cbl          # DCLGEN table CUSTOMERS
│   ├── ITEM.cbl          # DCLGEN table ITEMS
│   ├── ORD.cbl           # DCLGEN table ORDERS
│   └── PROD.cbl          # DCLGEN table PRODUCTS
├── JCL/
│   └── JMAJDB.jcl        # Job Control Language
└── SQL/
    └── RAZ_partie2.sql   # Script de remise à zéro
```

## Fonctionnalités Principales

### 1. Traitement des Fichiers de Ventes
- **Lecture synchronisée** de deux fichiers triés (VENTESEU et VENTESAS)
- **Fusion intelligente** basée sur la clé de commande (N° commande + N° client + N° employé)
- **Gestion des ruptures** pour calculer le chiffre d'affaires total par commande

### 2. Mise à Jour Base de Données
- **Création automatique** des commandes dans la table ORDERS
- **Insertion des items** dans la table ITEMS avec prix et quantités
- **Mise à jour du solde client** (BALANCE) dans la table CUSTOMERS

### 3. Gestion des Prix
- **Prix explicite** : utilisation du prix fourni dans le fichier
- **Prix manquant** : récupération automatique depuis la table PRODUCTS
- **Conversion automatique** des prix (division par 100 pour les centimes)

## Format des Données

### Structure des fichiers VENTES (EU/AS)
```
Positions  Type  Champ           Description
1-3        N     NUM_CMD         Numéro de commande
4-13       A     DATE_CMD        Date commande (JJ/MM/AAAA)
14-15      N     NUM_EMP         Numéro employé
16-19      N     NUM_CLI         Numéro client
20-22      A     NUM_PROD        Numéro produit
23-27      N     PRIX            Prix (5 dont 2 décimales)
28-29      N     QTE             Quantité commandée
30-35      A     RESERVE         Zone réservée
```

### Exemple de données
**VENTESEU** :
```
50010/10/2022100004P010259903
50010/10/2022100004P030357502
50010/10/2022100004P040100005
```

**VENTESAS** :
```
50115/10/2022200003P020154910
50115/10/2022200003P030357502
50202/11/2022300002P050502507
```

## Architecture Technique

### Tables DB2 Impliquées
- **API6.CUSTOMERS** : Informations clients et balance
- **API6.ORDERS** : En-têtes des commandes
- **API6.ITEMS** : Détails des lignes de commande
- **API6.PRODUCTS** : Catalogue produits avec prix

### Logique de Traitement

1. **Phase d'initialisation**
   - Ouverture des fichiers VENTESEU et VENTESAS
   - Lecture initiale des deux fichiers

2. **Boucle principale de synchronisation**
   - Comparaison des clés de tri (CMD+CLI+EMP)
   - Traitement selon trois cas :
     - Vente Europe uniquement
     - Vente Asie uniquement  
     - Vente dans les deux zones (même clé)

3. **Traitement par rupture**
   - Calcul du chiffre d'affaires total par commande
   - Mise à jour de la balance client à chaque changement de client

4. **Mise à jour DB2**
   - Insertion des commandes (gestion des doublons avec SQLCODE -803)
   - Insertion des items de commande
   - Mise à jour des balances clients

## Algorithmes Clés

### Gestion des Ruptures
```cobol
EVALUATE TRUE
WHEN WS-CLE-VEU < WS-CLE-VAS
   * Traiter uniquement Europe
WHEN WS-CLE-VEU > WS-CLE-VAS
   * Traiter uniquement Asie  
WHEN OTHER
   * Traiter Europe ET Asie (même commande)
END-EVALUATE
```

### Calcul du Chiffre d'Affaires
```cobol
IF PRIX = SPACES
   PERFORM RECUPERER-PRIX-DB2
ELSE
   COMPUTE WS-PRIX-FINAL = PRIX / 100
END-IF

COMPUTE WS-CHIFFRE-AFF = QUANTITE * PRIX-FINAL
ADD WS-CHIFFRE-AFF TO WS-CA-TOTAL-CMD
```

## Gestion d'Erreurs

### Codes de Retour SQL
- **SQLCODE = 0** : Opération réussie
- **SQLCODE = -803** : Violation de contrainte d'unicité (commande déjà existante)
- **SQLCODE = +100** : Aucune ligne trouvée
- **Autres codes** : Erreur critique → ABEND

### Récupération Automatique
- Prix manquant → Recherche dans table PRODUCTS
- Produit inexistant → Prix = 0 et continuation du traitement
- Erreur SQL critique → Rollback et arrêt du programme

## Compilation et Exécution

### Prérequis
- Environnement z/OS avec DB2
- Tables API6 créées et accessibles
- Fichiers de données présents dans les datasets

### Commandes
```jcl
//API6ET1D JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H
//COMPIL   EXEC COMPDB2
//BIND     EXEC PGM=IKJEFT01
//STEPRUN  EXEC PGM=IKJEFT01
```

## Statistiques de Traitement

Le programme affiche en fin d'exécution :
- Nombre de commandes créées
- Nombre d'items créés
- Nombre de clients mis à jour

## Utilisation

### Préparation
1. Exécuter le script `RAZ_partie2.sql` pour remettre les données à l'état initial
2. S'assurer que les fichiers VENTESEU et VENTESAS sont présents
3. Vérifier les droits d'accès aux tables DB2

### Exécution
1. Soumettre le JCL `JMAJDB.jcl`
2. Vérifier les codes de retour dans le SYSOUT
3. Contrôler les statistiques affichées

### Vérification
- Contrôler les nouvelles commandes dans API6.ORDERS
- Vérifier les items dans API6.ITEMS
- Valider les balances mises à jour dans API6.CUSTOMERS

## Points d'Attention

### Formatage des Données
- **Dates** : Conversion de JJ/MM/AAAA vers AAAA-MM-DD
- **Prix** : Division par 100 si fourni explicitement
- **Décimales** : Utilisation de la virgule comme séparateur décimal

### Optimisations
- Lecture en une seule passe des deux fichiers
- Gestion mémoire optimisée pour les ruptures
- Traitement batch pour les mises à jour DB2

## Auteur
Projet réalisé dans le cadre du cours de développement COBOL/DB2