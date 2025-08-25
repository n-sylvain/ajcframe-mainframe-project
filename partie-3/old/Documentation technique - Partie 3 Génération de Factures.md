

# 🧾 PARTIE 3 - GÉNÉRATION DE FACTURES
## Documentation Technique - Projet AJCFRAME

### 📋 Vue d'ensemble
La Partie 3 implémente un système complet de génération de factures automatisées à partir des données de commandes stockées en DB2. Le processus est divisé en deux étapes principales :
1. **Extraction des données** depuis DB2 vers un fichier VSAM indexé
2. **Génération des factures** formatées à partir du fichier VSAM

---

## 🏗️ Architecture de la solution

### Composants développés
1. **DATEUTIL** - Sous-programme de formatage de date
2. **EXTRACT** - Programme d'extraction DB2 → VSAM
3. **GENEFACT** - Programme principal de génération des factures
4. **JCL de traitement** - Orchestration complète du processus

### Flux de traitement
```
DB2 Tables → [EXTRACT] → VSAM File → [GENEFACT] → Factures formatées
    ↑                                      ↑
Jointures SQL                        Sous-programme DATEUTIL
```

---

## 📊 Structure des données

### Fichier VSAM d'extraction (PROJET.EXTRACT.DATA)
```cobol
01 ENR-EXTRACT.
   05 EXT-KEY.
      10 EXT-O-NO         PIC 9(3).       * Clé primaire
   05 EXT-O-DATE          PIC X(10).      * Date commande
   05 EXT-S-NO            PIC 9(2).       * N° employé
   05 EXT-C-NO            PIC 9(4).       * N° client
   05 EXT-COMPANY         PIC X(30).      * Données client
   05 EXT-ADDRESS         PIC X(100).
   05 EXT-CITY            PIC X(20).
   05 EXT-STATE           PIC X(2).
   05 EXT-ZIP             PIC X(5).
   05 EXT-DEPT            PIC 9(4).       * Données employé
   05 EXT-DNAME           PIC X(20).
   05 EXT-LNAME           PIC X(20).
   05 EXT-FNAME           PIC X(20).
   05 EXT-P-NO            PIC X(3).       * Données produit
   05 EXT-DESCRIPTION     PIC X(30).
   05 EXT-QUANTITY        PIC 9(2).
   05 EXT-PRICE           PIC 9(3)V99.
```

### Fichier de sortie factures (PROJET.FACTURES.DATA)
- **Format :** Séquentiel, LRECL=80
- **Contenu :** Factures formatées prêtes à imprimer
- **Structure :** Une facture par commande avec calculs automatiques

---

## 🔍 Requête SQL d'extraction

Le programme EXTRACT utilise une requête SQL complexe avec jointures multiples :

```sql
SELECT O.O_NO, O.O_DATE, O.S_NO, O.C_NO,
       C.COMPANY, C.ADDRESS, C.CITY, C.STATE, C.ZIP,
       E.DEPT, D.DNAME, E.LNAME, E.FNAME,
       I.P_NO, P.DESCRIPTION, I.QUANTITY, I.PRICE
FROM API6.ORDERS O
INNER JOIN API6.CUSTOMERS C ON O.C_NO = C.C_NO
INNER JOIN API6.EMPLOYEES E ON O.S_NO = E.E_NO  
INNER JOIN API6.DEPTS D ON E.DEPT = D.DEPT
INNER JOIN API6.ITEMS I ON O.O_NO = I.O_NO
INNER JOIN API6.PRODUCTS P ON I.P_NO = P.P_NO
ORDER BY O.O_NO, I.P_NO
```

### Contraintes respectées
- **Tri :** O_NO/P_NO (pas E_NO comme spécifié dans les contraintes)
- **Données complètes :** Toutes les informations nécessaires à la facture
- **Performance :** Index sur les clés de jointure

---

## 📄 Format de facture généré

### Exemple de sortie
```
COMPANY NAME
ADDRESS LINE  
CITY, ZIP
STATE

New York, Thursday, December 19, 2024

101
2022-02-15

Your contact within the department Sales : Doe, John

P_NO   DESCRIPTION         QUANTITY   PRICE      LINE TOTAL
----   -----------         --------   -----      ----------
P01    Mouse Bluetooth        3      25.99        77.97
P03    Router                 2      35.75        71.50
                                                --------
                                    SUB TOTAL    149.47
                                    SALES TAX     XX.XX
                                    COMMISSION     X.XX  
                                                --------
                                    TOTAL        XXX.XX
```

### Calculs automatiques
- **LINE TOTAL :** QUANTITY × PRICE
- **SUB TOTAL :** Σ(LINE TOTAL) 
- **SALES TAX :** SUB TOTAL × TAUX_TVA (lu depuis SYSIN)
- **COMMISSION :** SUB TOTAL × 0.099
- **TOTAL :** SUB TOTAL + SALES TAX + COMMISSION

---

## 🛠️ Sous-programme DATEUTIL

### Fonctionnalité
Convertit une date DB2 (YYYY-MM-DD) en format lisible américain.

### Interface
```cobol
CALL 'DATEUTIL' USING input-date output-formatted-date
```

### Exemple de transformation
```
Input:  '2024-12-19'
Output: 'New York, Thursday, December 19, 2024'
```

### Implémentation
- Tables internes pour noms de mois
- Algorithme de calcul du jour de la semaine (simplifié)
- Formatage avec STRING

---

## ⚙️ Aspects techniques avancés

### Gestion des erreurs
1. **Fichier VSAM :** Contrôle FILE STATUS à chaque opération
2. **DB2 :** Vérification SQLCODE après chaque SQL
3. **Curseur :** Gestion propre ouverture/fermeture
4. **Rollback :** En cas d'erreur DB2

### Performance
- **Curseur DB2 :** Lecture séquentielle optimisée  
- **VSAM indexé :** Accès rapide par clé O_NO
- **Ordre de traitement :** Une passe, génération à la volée

### Bonnes pratiques appliquées
- **Modularité :** Séparation extraction/génération
- **Réutilisabilité :** Sous-programme DATEUTIL
- **Maintenabilité :** Code structuré, commenté
- **Robustesse :** Gestion d'erreurs complète

---

## 🧪 Tests recommandés

### Tests unitaires - DATEUTIL
```cobol
* Test 1: Date valide
INPUT: '2024-12-19'  
EXPECTED: 'New York, Thursday, December 19, 2024'

* Test 2: Changement d'année
INPUT: '2023-01-01'
EXPECTED: 'New York, [jour], January 1, 2023'
```

### Tests d'intégration
1. **Extraction :** Vérifier que toutes les commandes sont extraites
2. **Génération :** Une facture par commande O_NO
3. **Calculs :** Vérifier SUB TOTAL, TAX, COMMISSION, TOTAL
4. **Format :** Alignement colonnes, espacement

### Tests de non-régression
- Commandes avec 1 produit vs multiples produits
- Valeurs décimales et arrondis
- Taux TVA différents (0%, 5.5%, 20%)

---

## 📝 Points d'amélioration futurs

### Fonctionnalités
1. **Numérotation de pages** pour factures multi-pages
2. **Logos et en-têtes** personnalisés
3. **Devises multiples** avec conversion
4. **Remises** et promotions

### Performance
1. **Optimisation SQL** avec hints
2. **Traitement par lots** de commandes
3. **Parallélisation** extraction/génération
4. **Cache** données référentielles

### Maintenance
1. **Logs détaillés** des traitements
2. **Statistiques** de production
3. **Alertes** en cas d'erreur
4. **Sauvegarde** automatique des factures

---

## 🚀 Mise en production

### Prérequis
- Tables DB2 créées et alimentées
- Plan DB2 `API6PLAN` défini
- Autorisations d'écriture sur datasets
- Taux TVA configuré dans le JCL

### Déploiement
1. Compilation des programmes (JCL fourni)
2. Test en environnement d'intégration
3. Validation des formats de sortie
4. Migration en production

### Surveillance
- Codes retour des programmes
- Volumétrie des fichiers générés
- Temps d'exécution
- Messages d'erreur DB2

---

## 👨‍💻 Notes pour la soutenance

### Points forts à démontrer
1. **Architecture modulaire** avec sous-programme
2. **Intégration DB2-COBOL-VSAM** maîtrisée
3. **Formatage professionnel** des factures
4. **Gestion d'erreurs** robuste
5. **JCL complet** prêt à l'emploi

### Défis techniques surmontés
- Jointures SQL complexes (6 tables)
- Formatage précis des montants
- Gestion des fins de fichiers
- Synchronisation extraction/génération

### Démonstration suggérée
1. Montrer le code source commenté
2. Exécuter le JCL complet
3. Présenter une facture générée
4. Expliquer les calculs
5. Montrer la gestion d'erreurs

---

*Développé par : **Sylvain** - Partie 3/4 du projet AJCFRAME*