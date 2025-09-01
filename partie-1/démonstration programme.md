# Script de démonstration et challenges - Projet MAJPROD

## Script de démonstration live

### 1. Préparation de l'environnement (2 minutes)

```sql
-- Montrer l'état initial de la table PRODUCTS
SELECT * FROM PRODUCTS ORDER BY P_NO;
-- Résultat attendu : P01 à P07 (données de base)

-- Exécuter la remise à zéro si nécessaire
DELETE FROM PRODUCTS WHERE P_NO > 'P07';
COMMIT;
```

**Narration :** "Nous partons d'une base de données contenant 7 produits existants. Notre objectif est d'ajouter 11 nouveaux produits depuis un fichier CSV."

### 2. Présentation des fichiers de données (1 minute)

```
-- Montrer le contenu de NEWPRODS.txt
P10;USB FLASH DRIVE;15;EU
P11;HEADPHONES;30.5;DO
P12;MICRO;25.75;YU
[...]
```

**Narration :** "Le fichier CSV contient 11 produits avec 4 devises différentes. Notez le formatage inconsistant des descriptions."

```
-- Montrer le contenu de TAUX.txt
EU;1,10
YU;0,15
WN;0,00075
YN;0,0067
```

**Narration :** "Le fichier des taux permet la conversion vers USD. Ici 1 Euro = 1,10 USD."

### 3. Lancement du programme (3 minutes)

```jcl
// Soumettre le JCL
SUBMIT 'API6.JCL(JMAJPROD)'
```

**Narration :** "Le programme MAJPROD va maintenant traiter ces données en plusieurs étapes."

### 4. Analyse des résultats en temps réel (2 minutes)

**Montrer les logs du programme :**
```
=== PROGRAMME MAJPROD - MAJ PRODUITS ===
CHARGEMENT DES TAUX EN MEMOIRE...
TAUX CHARGE : EU = 1,10000
TAUX CHARGE : YU = 0,15000
NOMBRE DE TAUX CHARGES : 02

ENREGISTREMENT N : 001
LIGNE BRUTE : P10;USB FLASH DRIVE;15;EU
NUMERO PRODUIT : P10
DESCRIPTION    : Usb Flash Drive
PRIX ORIGINE   : 15,00 EU
PRIX EN USD    : 16,50
PRODUIT P10 INSERE AVEC SUCCES
```

**Points à souligner :**
- Chargement optimisé des taux en mémoire
- Formatage automatique de la description
- Conversion automatique des devises
- Insertion sécurisée en base

### 5. Vérification finale (1 minute)

```sql
-- Vérifier l'insertion des nouveaux produits
SELECT P_NO, DESCRIPTION, PRICE 
FROM PRODUCTS 
WHERE P_NO > 'P07' 
ORDER BY P_NO;
```

**Résultat attendu :**
```
P10  Usb Flash Drive      16.50
P11  Headphones          30.50
P12  Micro                3.86
[...]
```

**Narration :** "Les 11 produits ont été insérés avec succès, descriptions formatées et prix convertis en USD."

### 6. Points techniques à mentionner (1 minute)

- **Performance :** Traitement de 11 enregistrements en moins de 2 secondes
- **Robustesse :** Gestion automatique des erreurs et doublons
- **Extensibilité :** Ajout facile de nouvelles devises

---

## Liste complète des challenges techniques

### 1. Challenges de programmation COBOL

#### Challenge 1.1 : Absence de fonctions modernes
**Problème :** Version COBOL sans TRIM, UPPER, LOWER
**Impact :** Formatage manuel des chaînes de caractères
**Solution :** 
- Implémentation de tables de correspondance majuscules/minuscules
- Logique manuelle de détection de début de mot
- Code de 20+ lignes pour une fonction basique