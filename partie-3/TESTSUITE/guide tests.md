# Guide des Tests Fonctionnels COBOL

## Vue d'ensemble

Cette suite de tests valide le fonctionnement de vos trois programmes COBOL :
- **DATEFMT** : Formatage des dates
- **EXTRACT** : Extraction des données depuis la base DB2
- **FACTURE** : Génération des factures

## Structure des tests

### Programmes de base nécessaires
- `TESTCONT` (copybook) : Structure de contexte des tests
- `ASSEQDT` : Assertions pour les dates
- `ASSEQ` : Assertions numériques (si besoin pour extensions futures)

### Tests unitaires
1. **DATETEST** : Teste DATEFMT avec différentes dates
2. **EXTRACTTEST** : Valide la structure et le contenu du fichier EXTRACT
3. **FACTURETEST** : Vérifie la génération des factures

### Tests d'intégration
- **INTEGTEST** : Teste le workflow complet
- **TESTSUITE** : Orchestre tous les tests

## Ordre d'exécution recommandé

### 1. Compilation des programmes de production
Assurez-vous que vos programmes principaux sont déjà compilés :
- DATEFMT
- EXTRACT  
- FACTURE

### 2. Compilation des tests
```jcl
//COMPTEST JOB ...
```
Compile tous les programmes de test.

### 3. Exécution des tests unitaires
```jcl
//RUNTESTS JOB ...
```
Exécute la suite complète de tests unitaires.

### 4. Test d'intégration
```jcl
//INTEGTST JOB ...
```
Teste le workflow complet avec génération réelle des factures.

## Types de tests implémentés

### Tests DATEFMT
- Date connue (26/08/2025 → TUESDAY, AUGUST 26, 2025)
- Dates spéciales (samedi, dimanche, 1er janvier)
- Date vide (utilise la date courante)
- Validation de l'algorithme de Zeller

### Tests EXTRACT
- Existence du fichier de données
- Nombre d'enregistrements (4 attendus)
- Structure du premier enregistrement
- Validation des champs numériques

### Tests FACTURE
- Existence du fichier de sortie
- Présence des éléments clés (company, totaux, TVA)
- Structure des cadres
- Nombre de factures générées (3 attendues)

### Tests d'intégration
- Workflow complet fonctionnel
- Présence de toutes les companies (ABC, XYZ, LMN)
- Présence de tous les produits
- Formatage correct des dates

## Interprétation des résultats

### Codes de retour
- **0** : Tous les tests passent
- **8** : Au moins un test a échoué

### Format des messages
```
******** NOM-DU-TEST - PASSED *********
```
ou
```
FAILED : NOM-DU-TEST
EXPECTED: valeur_attendue
ACTUAL  : valeur_reelle
```

### Résumé final
```
TOTAL TESTS   : 12
TOTAL PASSES  : 11
TOTAL FAILURES: 1
STATUT: CERTAINS TESTS ONT ECHOUE
```

## Données de test

### Fichier EXTRACT (simulé)
- 4 enregistrements couvrant 3 commandes
- 3 companies différentes
- 4 produits distincts
- Différentes dates de commande

### Taux de TVA
- Défaut : 20,0%
- Configurable via SYSIN dans les JCL

## Résolution des problèmes courants

### Erreur "FICHIER NON TROUVE"
- Vérifiez que le programme EXTRACT a bien été exécuté
- Contrôlez les noms de datasets dans les JCL

### Erreur "STRUCTURE INCORRECTE"
- Vérifiez la longueur des enregistrements (280 pour EXTRACT, 132 pour FACTURES)
- Contrôlez les formats des champs numériques

### Tests de dates qui échouent
- Les tests de dates fixes peuvent échouer si exécutés à une date différente
- Adaptez les dates attendues selon votre environnement

## Extension des tests

Pour ajouter de nouveaux tests :

1. **Créer un nouveau programme de test** suivant le modèle :
```cobol
CALL 'VOTRE-PROGRAMME' USING parametres
CALL 'ASSERTION-APPROPRIEE' USING context, nom, attendu, reel
```

2. **Ajouter au TESTSUITE** :
```cobol
CALL 'VOTRE-TEST' USING BY REFERENCE TEST-CONTEXT
```

3. **Mettre à jour les JCL de compilation**

## Bonnes pratiques

- **Isolation** : Chaque test doit être indépendant
- **Données** : Utilisez des données de test dédiées
- **Noms** : Noms de tests explicites et descriptifs
- **Messages** : Messages d'erreur informatifs
- **Couverture** : Testez les cas normaux ET les cas d'erreur

## Maintenance

- Mettre à jour les tests quand la logique métier change
- Réviser les données de test régulièrement
- Documenter les nouveaux cas de test
- Maintenir la cohérence des formats de sortie