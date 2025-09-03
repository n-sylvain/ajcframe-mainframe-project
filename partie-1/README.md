# Projet MAJPROD - Mise à jour des produits depuis fichiers CSV

## Présentation du projet

Le projet MAJPROD répond à une problématique de la société AJCFRAME qui souhaite importer automatiquement de nouveaux produits dans sa base de données depuis des fichiers CSV, avec conversion des devises et formatage des descriptions.

## Objectifs

- Traiter un fichier CSV contenant de nouveaux produits
- Convertir automatiquement les prix dans différentes devises vers le dollar (USD)
- Formater les descriptions (majuscule au début de chaque mot)
- Insérer les données dans la table PRODUCTS de la base DB2

## Architecture du projet

```
PROJET-MAJPROD/
├── DATA/
│   ├── NEWPRODS.txt     # Fichier CSV des nouveaux produits
│   └── TAUX.txt         # Fichier des taux de conversion
├── DB2/
│   └── MAJPROD.cbl      # Programme principal COBOL
├── DCLGEN/
│   └── PROD.cbl         # Structure de données DB2
├── JCL/
│   └── JMAJPROD.jcl     # Job Control Language
├── SQL/
│   └── DELETE_PROD.sql  # Script de remise à zéro
└── README.md
```

## Technologies utilisées

- **COBOL** : Langage de programmation principal
- **DB2** : Base de données relationnelle
- **JCL** : Job Control Language pour l'exécution
- **SQL** : Gestion des données
- **z/OS** : Système d'exploitation mainframe

## Fonctionnalités principales

### 1. Lecture et traitement du fichier CSV
- Parsing des champs séparés par point-virgule
- Validation des données d'entrée
- Gestion des erreurs de format

### 2. Conversion des devises
- Chargement en mémoire des taux de change
- Support des devises : EU (Euro), DO (Dollar), YU (Yuan)
- Calcul automatique vers USD

### 3. Formatage des descriptions
- Conversion en format "Title Case"
- Première lettre de chaque mot en majuscule
- Autres lettres en minuscules

### 4. Intégration base de données
- Insertion sécurisée via SQL embedded
- Gestion des doublons (erreur -803)
- Transaction avec commit/rollback

## Structure des fichiers de données

### NEWPRODS.txt (Format CSV)
```
Format: NUMERO;DESCRIPTION;PRIX;DEVISE
Exemple: P10;USB FLASH DRIVE;15;EU
```

### TAUX.txt (Taux de change)
```
Format: DEVISE;TAUX
Exemple: EU;1,10
```

## Utilisation

### 1. Préparation
```sql
-- Exécuter le script de remise à zéro
@SQL/DELETE_PROD.sql
```

### 2. Compilation et exécution
```jcl
// Soumettre le JCL
SUBMIT 'API6.JCL(JMAJPROD)'
```

### 3. Vérification
```sql
SELECT * FROM PRODUCTS;
```

## Gestion des erreurs

- **Fichiers non trouvés** : Affichage d'un message d'erreur explicite
- **Doublons** : Détection et signalement (SQLCODE -803)
- **Devises inconnues** : Traitement par défaut en USD
- **Erreurs SQL** : Rollback automatique

## Performances

- **Optimisation mémoire** : Chargement des taux en table interne
- **Lecture séquentielle** : Traitement optimisé des fichiers
- **Transaction unique** : Commit final pour toutes les insertions

## Statistiques de traitement

Le programme affiche en fin d'exécution :
- Nombre total d'enregistrements lus
- Nombre de produits insérés avec succès
- Nombre d'erreurs détectées

## Exemple d'exécution

```
=== PROGRAMME MAJPROD - MAJ PRODUITS ===
========================================
CHARGEMENT DES TAUX EN MEMOIRE...
TAUX CHARGE : EU = 1,10000
TAUX CHARGE : YU = 0,15000
NOMBRE DE TAUX CHARGES : 02

===================================
ENREGISTREMENT N : 001
LIGNE BRUTE : P10;USB FLASH DRIVE;15;EU
NUMERO PRODUIT : P10
DESCRIPTION    : Usb Flash Drive
PRIX ORIGINE   : 15,00 EU
PRIX EN USD    : 16,50
PRODUIT P10 INSERE AVEC SUCCES
===================================

=== STATISTIQUES FINALES ===
TOTAL ENREGISTREMENTS LUS : 011
PRODUITS INSERES         : 011
ERREURS DETECTEES        : 000
========================================
```

## Auteur

Développé dans le cadre du projet AJCFRAME
Soutenance technique - Traitement de données CSV en environnement mainframe