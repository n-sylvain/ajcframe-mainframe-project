# 🚀 **DÉMARCHE AGILE/SCRUM POUR VOTRE PROJET MAINFRAME**

## 📊 **ADAPTATION SCRUM (2 SPRINTS DE 4-5 JOURS)**

### **🎯 RÔLES SCRUM ADAPTÉS**

**Product Owner (PO) :** Membre le plus expérience business/fonctionnel
- Priorise le backlog
- Valide les user stories
- Interface avec le "client" (formateur)
- Responsable acceptance criteria

**Scrum Master :** Membre avec bonnes capacités d'organisation
- Facilite les cérémonies
- Résout les blocages
- Maintient la vélocité
- Gardien de la méthodo

**Dev Team :** Les 3 membres (y compris PO et SM)
- Auto-organisés
- Cross-fonctionnels
- Responsables des estimations

---

## 📅 **PLANNING AGILE DÉTAILLÉ**

### **🎯 SPRINT 0 - Setup (Jours 1-2)**
```
Jour 1 - Vision & Setup
├── Product Vision (2h)
│   ├── Analyse cahier des charges
│   ├── Définition Definition of Done
│   └── Roadmap produit
├── Sprint Planning (1h)
│   ├── Création Product Backlog
│   ├── Story mapping
│   └── Estimations (Planning Poker)
└── Setup technique (2h)
    ├── GitHub + branches
    ├── Environnement dev
    └── Standards équipe

Jour 2 - Architecture & Préparation
├── Architecture Decision Records
├── Spike techniques (POC)
├── Refinement backlog
└── Sprint 1 Planning détaillé
```

### **🏃 SPRINT 1 (Jours 3-6) - MVP Core**
```
SPRINT GOAL: "Livrer un système fonctionnel d'import de données"

Daily Scrum (15min, même heure) :
├── Hier j'ai fait...
├── Aujourd'hui je vais...
├── Mes blocages...
└── Mise à jour Burndown

User Stories prioritaires:
├── US1: Import nouveaux produits avec conversion devise
├── US2: Import ventes EU/AS avec calcul balance
├── US3: Setup base données opérationnelle
└── US4: Tests unitaires core business
```

### **🏃 SPRINT 2 (Jours 7-9) - Features Avancées**
```
SPRINT GOAL: "Compléter le système avec factures et IHM"

User Stories:
├── US5: Génération factures avec sous-programme date
├── US6: Interface CICS avec authentification
├── US7: Module sécurité et gestion erreurs
└── US8: Documentation technique complète
```

### **🎯 SPRINT FINAL (Jour 10) - Release**
```
├── Sprint Review interne
├── Rétrospective finale
├── Package release
└── Préparation soutenance
```

---

## 📋 **BACKLOG PRODUIT STRUCTURÉ**

### **EPICS & USER STORIES**

```markdown
# EPIC 1: Gestion des Produits
## US1.1: Import fichier produits (Story Points: 8)
**En tant que** gestionnaire de catalogue
**Je veux** importer des nouveaux produits depuis un fichier CSV
**Pour** maintenir notre catalogue à jour

**Acceptance Criteria:**
- [ ] Lecture fichier PROJET.NEWPRODS.DATA
- [ ] Validation format et contraintes
- [ ] Formatage descriptions (majuscules)
- [ ] Conversion devises en dollars
- [ ] Insertion en base avec gestion erreurs
- [ ] Log des opérations

## US1.2: Système de conversion devises (Story Points: 5)
**En tant que** système
**Je veux** convertir automatiquement les prix en dollars
**Pour** uniformiser la base de données

**Acceptance Criteria:**
- [ ] Taux de change configurables
- [ ] Support EU/DO/YU + extensibilité
- [ ] Précision calculs (2 décimales)
- [ ] Gestion erreurs de conversion

# EPIC 2: Gestion des Ventes
## US2.1: Import ventes Europe/Asie (Story Points: 13)
**En tant que** gestionnaire des ventes
**Je veux** importer les ventes réalisées à l'étranger
**Pour** consolider notre chiffre d'affaires

**Acceptance Criteria:**
- [ ] Lecture PROJET.VENTESEU.DATA & VENTESAS.DATA
- [ ] Validation contraintes métier
- [ ] Insertion commandes en base
- [ ] Mise à jour balance clients
- [ ] Contrôle cohérence données

# EPIC 3: Facturation
## US3.1: Génération factures (Story Points: 21)
**En tant que** comptable
**Je veux** générer des factures pour chaque commande
**Pour** facturer nos clients

**Acceptance Criteria:**
- [ ] Export données vers PROJET.EXTRACT.DATA
- [ ] Génération factures format imposé
- [ ] Calculs: sous-total, TVA, commission, total
- [ ] Sous-programme date en toutes lettres
- [ ] Une facture par page
- [ ] Sauvegarde PROJET.FACTURES.DATA

# EPIC 4: Interface Utilisateur
## US4.1: Interface CICS pièces (Story Points: 34)
**En tant que** utilisateur métier
**Je veux** saisir de nouvelles pièces via interface
**Pour** enrichir notre catalogue pièces

**Acceptance Criteria:**
- [ ] Interface authentification (login/password)
- [ ] Écrans saisie pièces
- [ ] Validation données saisies
- [ ] Sauvegarde PROJET.NEWPARTS.KSDS
- [ ] Gestion erreurs utilisateur
- [ ] Nomenclature CICS respectée
```

---

## 🎯 **CÉRÉMONIES SCRUM ADAPTÉES**

### **📅 DAILY SCRUM (15min, 9h00)**
```markdown
# Template Daily Scrum
**Date:** [Date]
**Sprint:** [1 ou 2]

## 👤 [Prénom Membre 1]
- ✅ Hier: 
- 🎯 Aujourd'hui: 
- 🚧 Blocages: 

## 👤 [Prénom Membre 2]
- ✅ Hier: 
- 🎯 Aujourd'hui: 
- 🚧 Blocages: 

## 👤 [Prénom Membre 3]
- ✅ Hier: 
- 🎯 Aujourd'hui: 
- 🚧 Blocages: 

## 📊 Métriques jour
- Burndown: [X story points restants]
- Vélocité: [X SP/jour]
- Blocages à résoudre: [Nombre]
```

### **🎯 SPRINT PLANNING**
```markdown
# Sprint Planning Template

## Part 1: WHAT (1h)
- Sprint Goal défini
- User Stories sélectionnées
- Capacity team évaluée
- Commitment pris

## Part 2: HOW (1h)
- Breakdown stories en tâches
- Estimation tâches (heures)
- Assignment initial tâches
- Plan de développement

## Outputs:
- [ ] Sprint Goal clair
- [ ] Sprint Backlog complet
- [ ] Definition of Done confirmée
- [ ] Capacity vs commitment validé
```

### **🔍 SPRINT REVIEW (1h30)**
```markdown
# Sprint Review Template

## 📊 Métriques Sprint
- Vélocité: [X story points completed]
- Stories Done: [X/Y]
- Bugs découverts: [X]
- Demo success rate: [X%]

## 🎯 Démonstration
- [ ] US1: Demo import produits
- [ ] US2: Demo import ventes
- [ ] US3: Demo génération factures
- [ ] US4: Demo interface CICS

## 📝 Feedback Stakeholders
- Points positifs:
- Points d'amélioration:
- Nouvelles demandes:

## 🎯 Prochaines priorités
```

### **🔄 RETROSPECTIVE (45min)**
```markdown
# Rétrospective Template

## ✅ Start (À commencer)
- 
- 

## 🔄 Stop (À arrêter)
- 
- 

## ⚡ Continue (À continuer)
- 
- 

## 🎯 Actions concrètes Sprint suivant
| Action | Responsable | Date limite |
|--------|-------------|-------------|
|        |             |             |

## 📈 Amélioration continue
- Vélocité team: [Évolution]
- Qualité code: [Indicateurs]
- Communication: [Points d'amélioration]
```

---

## 📊 **OUTILS DE SUIVI AGILE**

### **🏃 BURNDOWN CHART**
```
Story Points
     |
 100 |●
  80 |  ●
  60 |    ●●
  40 |       ●●
  20 |          ●●
   0 |____________●
     1  2  3  4  5  6  Jours
     
Légende:
● Réel    ---- Idéal
```

### **📋 KANBAN BOARD GITHUB PROJECTS**
```
📝 BACKLOG | 🏃 IN PROGRESS | 👀 REVIEW | ✅ DONE
-----------|----------------|-----------|----------
US4.1      | US1.1         | US2.1     | Setup
US3.1      | US1.2         |           | Architecture
...        | Fix Bug #123   |           | US0.1
```

### **⚡ VELOCITY TRACKING**
```markdown
## Vélocité équipe
- Sprint 1: 45 story points
- Sprint 2: 52 story points
- Moyenne: 48.5 SP/sprint
- Capacité: 16 SP/personne/sprint
```

---

## 🎯 **DEFINITION OF DONE**

### **✅ CRITERIA COMMUNS**
```markdown
## Code
- [ ] Code review effectué
- [ ] Standards de code respectés
- [ ] Commentaires appropriés
- [ ] Pas de code mort

## Tests
- [ ] Tests unitaires écrits et passants
- [ ] Tests d'intégration OK
- [ ] Test manuel de la fonctionnalité
- [ ] Pas de régression détectée

## Documentation
- [ ] Documentation technique à jour
- [ ] README mis à jour si nécessaire
- [ ] Captures d'écran pour démo
- [ ] User story validée par PO

## Technique
- [ ] Branch mergée dans develop
- [ ] Code déployé sur environnement test
- [ ] Performance acceptable
- [ ] Gestion d'erreurs implémentée
```

---

## 💡 **RITUELS SPÉCIFIQUES AU CONTEXTE**

### **🎯 CHECKPOINT CLIENT (Formateur)**
**Fréquence :** Tous les 2 jours
**Format :** 15 minutes
**Objectif :** Validation direction, déblocage

### **🔧 TECHNICAL SPIKE**
**Quand :** Début de chaque epic complexe
**Durée :** 2-4h max
**Objectif :** Réduire incertitudes techniques

### **📸 DOCUMENTATION CONTINUE**
**Intégré dans DoD :** Capture screenshots, logs, démos
**Pour :** Alimenter présentation finale

Cette approche agile vous permettra de **livrer de la valeur rapidement**, **s'adapter aux imprévus**, et **maintenir une qualité élevée** tout en préparant efficacement votre soutenance ! 🚀