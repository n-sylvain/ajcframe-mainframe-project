# Guide de Présentation - Projet MAJDB
## Synchronisation des Données de Ventes COBOL/DB2

---

## 1. Présentation de l'Équipe
- **Membres du projet** : [À compléter avec vos noms]
- **Rôles et responsabilités** :
  - Partie 1 (Nouveaux produits) : [Nom]
  - Partie 2 (Synchronisation ventes) : Sylvain
  - Partie 3 (Facturation) : [Nom]
  - Documentation et présentation : Équipe

---

## 2. Contexte du Projet

### Problématique
La société **AJCFRAME** reçoit deux fichiers recensant les ventes réalisées par des prestataires en **Europe** et en **Asie**. L'objectif est d'importer ces ventes en base de données tout en mettant à jour le chiffre d'affaires (balance) de chaque client.

### Enjeux
- Synchronisation de données provenant de deux sources
- Intégrité des données lors de la fusion
- Mise à jour cohérente des soldes clients
- Performance du traitement batch

---

## 3. Outils et Gestion de Projet

### Stack Technique
- **Langage** : COBOL (Enterprise)
- **Base de données** : IBM DB2 z/OS
- **Environnement** : z/OS Mainframe
- **Outils** : QMF (Query Management Facility), DCLGEN

### Gestion de Version
- **Repository** : Git/GitHub
- **Collaboration** : PowerPoint Online partagé
- **Documentation** : Markdown + Mermaid

---

## 4. Solution Fonctionnelle

### Architecture Générale
Le programme **MAJDB** traite simultanément deux fichiers triés et maintient la synchronisation grâce à un algorithme de fusion intelligent.

### Flux de Données
```
Fichiers VENTES → Programme MAJDB → Tables DB2
    ↓                    ↓              ↓
VENTESEU           Synchronisation   ORDERS
VENTESAS           Calculs CA        ITEMS
                   Format données    CUSTOMERS
```

### Fonctionnalités Clés
1. **Lecture synchronisée** de deux fichiers triés
2. **Gestion des ruptures** sur changement de commande/client
3. **Récupération automatique** des prix manquants
4. **Mise à jour transactionnelle** des bases

---

## 5. Diagramme Fonctionnel
*[Référencer le diagramme Mermaid créé séparément]*

---

## 6. Proposition Technique

### Structure du Programme

#### Variables de Contrôle
```cobol
01 WS-CLE-VEU.          * Clé fichier Europe
01 WS-CLE-VAS.          * Clé fichier Asie  
01 WS-CLE-COURANTE.     * Clé en cours de traitement
01 WS-CA-TOTAL-CMD.     * Chiffre d'affaires par commande
01 WS-CA-CLIENT.        * Chiffre d'affaires par client
```

#### DCLGEN Inclus
- **PROD** : Table PRODUCTS
- **CUST** : Table CUSTOMERS
- **ORD** : Table ORDERS
- **ITEM** : Table ITEMS

### Algorithme de Synchronisation

La logique principale utilise un **EVALUATE** pour comparer les clés :

```cobol
EVALUATE TRUE
WHEN WS-CLE-VEU < WS-CLE-VAS
   * Europe en avance → traiter Europe
WHEN WS-CLE-VEU > WS-CLE-VAS  
   * Asie en avance → traiter Asie
WHEN OTHER
   * Même clé → traiter les deux
END-EVALUATE
```

---

## 7. Détails des Étapes du Projet

### Phase 1 : Analyse et Conception
- **Analyse des fichiers** : Structure, format, tri
- **Modélisation DB2** : Relations entre tables
- **Conception algorithme** : Fusion deux fichiers triés

### Phase 2 : Développement
- **Génération DCLGEN** pour chaque table
- **Programmation COBOL** avec embedded SQL
- **Gestion d'erreurs** et codes de retour
- **Tests unitaires** par section

### Phase 3 : Intégration et Tests
- **Compilation DB2/COBOL** via JCL
- **Tests de non-régression** avec jeux de données
- **Validation des calculs** de chiffre d'affaires
- **Tests de performance** sur gros volumes

### Démarche Algorithmique

1. **Tri et fusion** : Algorithme classique de fusion de fichiers triés
2. **Gestion des ruptures** : Détection automatique des changements de clé
3. **Accumulation** : Calculs progressifs du CA par commande et par client
4. **Transaction** : Mise à jour atomique des bases

### Travail en Équipe
- **Répartition par parties** fonctionnelles du projet
- **Documentation partagée** via PowerPoint Online
- **Synchronisation** régulière via repository Git
- **Tests croisés** entre parties pour validation

---

## 8. Démonstration

### Scenario de Démonstration

1. **État initial** : Montrer les balances clients avant traitement
2. **Exécution** : Lancer le job MAJDB en direct
3. **Monitoring** : Suivre les messages de traitement
4. **Vérification** : Contrôler les données mises à jour
5. **Statistiques** : Afficher le récapitulatif final

### Données de Test
- **6 commandes** créées (500-505)
- **~15 items** insérés
- **4-5 clients** mis à jour

### Points à Démontrer
- Synchronisation des deux fichiers
- Gestion des prix manquants (ex: P11, P14, P18)
- Calcul correct des balances clients
- Robustesse face aux erreurs

---

## 9. Problèmes Rencontrés et Solutions

### Problème 1 : Formatage des Dates
**Problème** : Format JJ/MM/AAAA dans fichiers vs AAAA-MM-DD en DB2
**Solution** : Conversion via STRING avec restructuration

```cobol
MOVE VEU-DATE-CMD TO WS-DATE-TEMP
STRING WS-YEAR '-' WS-MONTH '-' WS-DAY
DELIMITED BY SIZE INTO WS-DATE-FORMATTED
```

### Problème 2 : Gestion des Décimales
**Problème** : Prix en centimes dans fichiers, en euros en DB2
**Solution** : Division par 100 avec DECIMAL-POINT IS COMMA

### Problème 3 : Doublons de Commandes
**Problème** : Même commande peut apparaître dans les deux fichiers
**Solution** : Gestion SQLCODE -803 (contrainte d'unicité)

```cobol
WHEN -803
   SET CMD-DEJA-CREE TO TRUE  * Commande déjà créée
```

### Problème 4 : Prix Manquants
**Problème** : Certains items n'ont pas de prix renseigné
**Solution** : Récupération automatique depuis table PRODUCTS

### Problème 5 : Calcul Balance Client
**Problème** : Client peut avoir des ventes dans les deux zones
**Solution** : Accumulation par client avec mise à jour différée

---

## 10. Améliorations à Apporter

### Performance
- **Fichier indexé** pour les taux de change (évoqué en transcript)
- **Batch commit** tous les N enregistrements
- **Parallélisation** possible par zone géographique

### Robustesse
- **Validation métier** renforcée (cohérence prix, quantités)
- **Logging détaillé** pour audit et debug
- **Gestion des reprises** en cas d'interruption

### Fonctionnalités
- **Interface de monitoring** temps réel
- **Rapports de synthèse** automatiques
- **Alertes** sur anomalies détectées

### Maintenance
- **Paramétrage externe** des seuils et codes
- **Documentation technique** automatisée
- **Tests automatisés** pour non-régression

---

## 11. Conclusion

### Objectifs Atteints
- ✅ Synchronisation réussie des deux fichiers de ventes
- ✅ Mise à jour correcte des tables DB2 (ORDERS, ITEMS)
- ✅ Calcul et application des balances clients
- ✅ Gestion robuste des erreurs et cas particuliers

### Apports Pédagogiques
- Maîtrise de la **programmation COBOL** avancée
- Intégration **COBOL/DB2** avec embedded SQL
- Algorithmes de **fusion de fichiers** triés
- Gestion des **transactions** et de l'intégrité

### Perspectives
Ce projet constitue une base solide pour des développements plus avancés dans un contexte d'entreprise, avec possibilité d'extension vers des architectures distribuées et des interfaces modernes.

---

## Annexes

### Statistiques Finales
- **Commandes créées** : 6
- **Items créés** : 15
- **Clients mis à jour** : 5
- **Temps de traitement** : < 1 seconde

### Structure des Tables
- **CUSTOMERS** : 8 colonnes, focus sur BALANCE
- **ORDERS** : 4 colonnes (O_NO, S_NO, C_NO, O_DATE)
- **ITEMS** : 4 colonnes (O_NO, P_NO, QUANTITY, PRICE)
- **PRODUCTS** : 3 colonnes (P_NO, DESCRIPTION, PRICE)



---

# Notions Techniques et Challenges - Projet MAJDB

## Notions Techniques Mises en Œuvre

### 1. Programmation COBOL Avancée

#### Structures de Données
- **Enregistrements hiérarchiques** avec sous-niveaux (01, 05, 10, 49)
- **Variables de travail** avec zones de stockage optimisées
- **Indicateurs conditionnels** (88-level) pour simplifier la logique
- **Zones d'édition** pour formatage d'affichage (PIC Z, virgules)

#### Gestion des Fichiers
- **Fichiers séquentiels** avec organisation SEQUENTIAL
- **Lecture contrôlée** avec gestion de fin de fichier (AT END)
- **Structure FD** (File Description) pour définition des enregistrements

#### Logique de Contrôle
- **EVALUATE** pour traitement conditionnel multiple
- **PERFORM UNTIL** pour boucles avec conditions complexes
- **Variables de fin de fichier** (88-level NFF/FF)

### 2. Intégration DB2/COBOL

#### Embedded SQL
- **EXEC SQL...END-EXEC** pour intégration des commandes SQL
- **Variables hôtes** (:variable) pour échange COBOL ↔ DB2
- **INCLUDE SQLCA** pour gestion des codes de retour
- **INCLUDE DCLGEN** pour structures de données DB2

#### Opérations CRUD
- **SELECT** avec gestion SQLCODE +100 (aucune ligne)
- **INSERT** avec gestion contraintes d'unicité (-803)
- **UPDATE** pour modification des balances clients
- **Transaction management** (COMMIT/ROLLBACK)

#### DCLGEN (Database Declaration Generator)
- **Génération automatique** des structures COBOL
- **Correspondance types** DB2 ↔ COBOL (DECIMAL, VARCHAR, CHAR)
- **Variables indicatrices** pour valeurs NULL

### 3. Algorithmes de Traitement

#### Fusion de Fichiers Triés
- **Comparaison de clés** multi-critères (commande+client+employé)
- **Avancement coordonné** des deux fichiers
- **Gestion des cas** : fichier 1 seul, fichier 2 seul, les deux

#### Gestion des Ruptures
- **Détection automatique** des changements de niveau
- **Accumulation progressive** des totaux
- **Déclenchement des traitements** de fin de groupe

#### Calculs Financiers
- **Arithmétique décimale** avec USAGE COMP-3
- **Conversion de devises** (division par 100)
- **Accumulation de chiffre d'affaires** avec précision

### 4. Gestion d'Erreurs et Robustesse

#### Codes de Retour SQL
- **SQLCODE 0** : Succès
- **SQLCODE +100** : Aucune donnée trouvée
- **SQLCODE -803** : Violation contrainte unicité
- **Autres codes** : Erreurs critiques → ABEND

#### Stratégies de Récupération
- **Prix manquant** → Recherche en base PRODUCTS
- **Produit inexistant** → Prix à zéro, continuation
- **Commande existante** → Continuation normale
- **Erreur critique** → Rollback et arrêt propre

---

## Challenges Techniques Relevés

### 1. Challenge : Synchronisation de Deux Fichiers Triés

**Problème** : Traiter simultanément deux fichiers avec potentiels chevauchements
**Solution** : Algorithme de fusion avec comparaison de clés complexes
**Complexité** : O(n+m) avec n et m tailles des fichiers

```cobol
* Comparaison de clés composites
IF WS-CMD-VEU < WS-CMD-VAS OR
   (WS-CMD-VEU = WS-CMD-VAS AND WS-CLI-VEU < WS-CLI-VAS) OR  
   (WS-CMD-VEU = WS-CMD-VAS AND WS-CLI-VEU = WS-CLI-VAS AND 
    WS-EMP-VEU < WS-EMP-VAS)
```

### 2. Challenge : Gestion des Ruptures Multi-Niveaux

**Problème** : Détecter les changements de commande ET de client
**Solution** : Ruptures imbriquées avec états mémorisés
**Difficulté** : Maintenir l'état entre les itérations

```cobol
* Rupture commande
IF VEU-NUM-CMD NOT = WS-CMD-PRECEDENTE
   PERFORM TRAITEMENT-RUPTURE-COMMANDE
END-IF

* Rupture client  
IF VEU-NUM-CLI NOT = WS-CLIENT-PREC AND WS-CLIENT-PREC > 0
   PERFORM MAJ-BALANCE-CLIENT
END-IF
```

### 3. Challenge : Conversion et Formatage des Données

**Problème** : Formats différents entre fichiers et DB2
- Date : JJ/MM/AAAA → AAAA-MM-DD
- Prix : Entier centimes → Décimal euros
- Virgule décimale COBOL vs point décimal

**Solution** : Routines de conversion dédiées
```cobol
* Conversion date
MOVE VEU-DATE-CMD TO WS-DATE-TEMP
STRING WS-YEAR '-' WS-MONTH '-' WS-DAY
DELIMITED BY SIZE INTO WS-DATE-FORMATTED

* Conversion prix
COMPUTE WS-PRIX-FINAL = WS-PRIX-WORK / 100
```

### 4. Challenge : Gestion des Prix Manquants

**Problème** : Certains items n'ont pas de prix dans les fichiers
**Solution** : Récupération dynamique depuis table PRODUCTS
**Optimisation** : Une seule requête par produit unique

```cobol
IF VEU-PRIX = SPACES
   PERFORM RECUPERER-PRIX-DB2
ELSE  
   COMPUTE WS-PRIX-FINAL = VEU-PRIX / 100
END-IF
```

### 5. Challenge : Intégrité Transactionnelle

**Problème** : Assurer la cohérence entre tables ORDERS, ITEMS, CUSTOMERS
**Solution** : Gestion fine des SQLCODE et rollback en cas d'erreur
**Robustesse** : Tests de tous les cas d'erreur possibles

```cobol
EVALUATE SQLCODE
   WHEN ZERO
       ADD 1 TO WS-NB-ITEMS
   WHEN -803  
       * Déjà existant, continuer
   WHEN OTHER
       PERFORM ABEND-PROG  * Rollback
END-EVALUATE
```

### 6. Challenge : Optimisation Mémoire

**Problème** : Limites mémoire COBOL pour gros volumes
**Solution** : 
- Traitement séquentiel sans stockage intermédiaire
- Mise à jour progressive des totaux
- Variables de travail réutilisées

### 7. Challenge : Débogage et Tests

**Problème** : Difficulté de debug sur mainframe
**Solution** : 
- Affichages DISPLAY détaillés à chaque étape
- Statistiques de contrôle en fin de traitement
- Jeux de tests complets avec cas limites

```cobol
DISPLAY 'CMD=' VEU-NUM-CMD ' DATE=' WS-DATE-FORMATTED
        ' EMP=' VEU-NUM-EMP ' CLI=' VEU-NUM-CLI
DISPLAY 'PROD=' VEU-NUM-PROD ' PRIX=' ED-PRIX  
        ' QTE=' VE