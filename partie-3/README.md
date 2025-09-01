# Projet de Génération de Factures - Partie 3

## Description générale

Ce projet implémente un système de génération automatique de factures pour la société AJCFRAME. Il extrait les données de commande depuis une base DB2 et génère des factures formatées avec calculs automatiques de TVA et commission.

## Architecture du système

Le projet suit une architecture modulaire en 3 étapes :

1. **Extraction des données** : Programme EXTRACT (COBOL/DB2)
2. **Génération des factures** : Programme FACTURE (COBOL batch)
3. **Formatage des dates** : Sous-programme DATEFMT

## Structure des fichiers

```
├── COBOL/              # Programmes principaux
│   ├── DATEFMT.cbl     # Sous-programme de formatage de dates
│   └── FACTURE.cbl     # Programme principal de génération
├── DATA/               # Données d'exemple
│   ├── EXTRACT.txt     # Données extraites de DB2
│   └── FACTURES.txt    # Factures générées (exemple)
├── DB2/                # Programmes avec accès DB2
│   └── EXTRACT.cbl     # Extraction des données depuis DB2
├── DCLGEN/             # Structures de tables DB2
│   ├── CUST.cbl        # Table CUSTOMERS
│   ├── DEPT.cbl        # Table DEPARTMENTS  
│   ├── EMP.cbl         # Table EMPLOYEES
│   ├── ITEM.cbl        # Table ITEMS
│   ├── ORD.cbl         # Table ORDERS
│   └── PROD.cbl        # Table PRODUCTS
├── JCL/                # Jobs de compilation et exécution
│   ├── JCDTFM.jcl      # Compilation DATEFMT
│   ├── JCFACT.jcl      # Compilation FACTURE
│   ├── JEFACT.jcl      # Exécution génération factures
│   ├── JEXTRACT.jcl    # Compilation et exécution EXTRACT
│   └── JEXTSUPP.jcl    # Suppression préalable fichier extract
└── SQL/                # Requêtes SQL
    └── SELECT_EXTRACT.sql # Requête d'extraction des données
```

## Description détaillée des composants

### Programmes COBOL

#### DATEFMT.cbl
- **Rôle** : Sous-programme de formatage de dates
- **Entrée** : Date au format AAAAMMJJ (ou vide pour date courante)
- **Sortie** : Date formatée "JOUR, MOIS JJ, AAAA"
- **Algorithme** : Utilise l'algorithme de Zeller pour calculer le jour de la semaine

#### FACTURE.cbl
- **Rôle** : Programme principal de génération de factures
- **Entrée** : Fichier EXTRACT.DATA (280 caractères/enreg)
- **Sortie** : Fichier FACTURES.DATA (132 caractères/enreg formatées)
- **Paramètres** : Taux de TVA via SYSIN
- **Fonctionnalités** :
  - Lecture séquentielle des données extraites
  - Groupement par numéro de commande
  - Calcul automatique TVA + commission (9,9%)
  - Formatage avec cadres ASCII

#### EXTRACT.cbl
- **Rôle** : Extraction des données depuis DB2
- **Base de données** : Tables API6 (CUSTOMERS, ORDERS, EMPLOYEES, etc.)
- **Sortie** : Fichier EXTRACT.DATA
- **Requête** : Jointures multiples pour récupérer toutes les informations nécessaires

#### JEXTSUPP.jcl
- **Rôle** : Suppression préalable du fichier EXTRACT.DATA
- **Nécessité** : Évite les erreurs de conflit si le fichier existe déjà
- **Usage** : Doit être exécuté avant JEXTRACT.jcl
- **Fonctionnement** : Utilise IEFBR14 avec DISP=(OLD,DELETE)

#### Enregistrement EXTRACT (280 caractères)
```
EXT-COMPANY      (30) : Nom de l'entreprise
EXT-ADDRESS     (100) : Adresse
EXT-CITY         (20) : Ville
EXT-ZIP           (5) : Code postal
EXT-STATE         (2) : État
EXT-O-NO          (3) : Numéro de commande
EXT-ODATE-ISO    (10) : Date de commande (ISO)
EXT-DNAME        (20) : Nom du département
EXT-LNAME        (20) : Nom de famille employé
EXT-FNAME        (20) : Prénom employé
EXT-P-NO          (3) : Numéro produit
EXT-DESCRIPTION  (30) : Description produit
EXT-QUANTITY      (2) : Quantité
EXT-PRICE      (3V99) : Prix unitaire
EXT-LINE-TOTAL (5V99) : Montant ligne
```

#### Format de sortie facture (132 caractères)
- Cadres ASCII avec caractères `+`, `-`, `|`
- En-tête avec adresse client encadrée
- Date et lieu de facturation
- Détails de commande et contact
- Tableau des produits
- Totaux avec TVA et commission

## Workflow d'exécution

### Étape 1 : Compilation des programmes
```jcl
// Soumettre JCDTFM.jcl    (compilation DATEFMT)
// Soumettre JCFACT.jcl    (compilation FACTURE)
// Soumettre JEXTRACT.jcl  (compilation EXTRACT)
```

### Étape 2 : Préparation et extraction des données
```jcl
// Soumettre JEXTSUPP.jcl  (suppression ancien fichier EXTRACT - OBLIGATOIRE)
// Soumettre JEXTRACT.jcl  (exécution EXTRACT)
// Vérifier création API6.PROJET.EXTRACT.DATA
```

### Étape 3 : Génération des factures
```jcl
// Modifier JEFACT.jcl si nécessaire (taux TVA dans SYSIN)
// Soumettre JEFACT.jcl
// Vérifier création API6.PROJET.FACTURES.DATA
```

### Étape 4 : Consultation des résultats
```jcl
// Consulter API6.PROJET.FACTURES.DATA via ISPF 3.4
// Vérifier format et calculs
```

## Paramètres configurables

### Taux de TVA
- Défini dans SYSIN de JEFACT.jcl
- Format : `XX,X` (exemple : `20,0` pour 20%)
- Valeur par défaut : 20% si erreur de saisie

### Taux de commission
- Fixé à 9,9% dans le code FACTURE.cbl
- Variable WS-COMMISSION-RATE (ligne 006300)

### Formats de sortie
- Largeur facture : 119 caractères utiles + 2 bordures = 132 total
- Ville de facturation : "New York" (codée en dur)

## Points techniques importants

### Gestion des erreurs
- Contrôle des statuts de fichiers (WS-EXTRACT-STATUS, WS-FACTURE-STATUS)
- Validation du taux de TVA avec fonction NUMVAL
- Gestion des fins de fichier avec indicateur EOF-EXTRACT

### Conversions de données
- Transformation COMP-3 vers zones d'édition
- Formatage monétaire avec virgules décimales
- Gestion des espaces et alignements

### Performance
- Lecture séquentielle optimisée
- Groupement automatique par numéro de commande
- Écriture batch des enregistrements

## Exemples de sortie

Le fichier FACTURES.txt montre le format de sortie avec :
- 3 factures générées (commandes 101, 102, 103)
- Calculs corrects de TVA et commission
- Formatage professionnel avec cadres
- Séparation des factures par lignes vides

## Dépendances

### Environnement mainframe requis
- COBOL Enterprise Edition
- DB2 pour z/OS
- JCL batch processing
- Tables API6.* accessibles

### Bibliothèques système
- CEE.SCEESAMP (compilation)
- CEE.SCEELKED (link-edit)
- SDJ.FORM.PROCLIB (procédures DB2)

Cette architecture modulaire facilite la maintenance et permet l'évolution des composants indépendamment.