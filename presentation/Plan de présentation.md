# Plan de Présentation - Projet AJCFRAME
**Durée totale : 30 minutes (25 min présentation + 5 min questions)**

## 1. Ouverture et Présentation de l'équipe (3 min)
- **Sylvain :** 8 ans finance de marché, automatisation, programmation
- **Denis :** 20 ans systèmes d'information géographique, développeur/DBA
- **Anouar :** Ingénieur + Master Data Science, 10 ans aviation + ferroviaire
- **Répartition réelle :** Sylvain (Parties 1&2), Denis (Partie 4), Anouar (Code review Partie 3 + corrections)
- **Méthodologie :** Agile/SCRUM avec daily meetings 15min

---

## 2. Contexte et Enjeux du Projet (4 min)
- **Entreprise AJCFRAME** : Société de vente de produits
- **Problématiques métier identifiées :**
  - Gestion des nouveaux produits multi-devises
  - Synchronisation des ventes internationales
  - Automatisation de la facturation
  - Interface utilisateur pour la saisie
- **Objectifs techniques :** Modernisation du SI mainframe

---

## 3. Architecture Technique et Outils (3 min)
- **Environnement :** z/OS, DB2, COBOL, CICS
- **Organisation du code :** GitHub + VS Code
- **Gestion de projet :** Discord, Miro Kanban, Daily SCRUM
- **Stratégie IA :** Claude (architecture), ChatGPT (débogage)

---

## 4. Vue d'ensemble de la Solution (4 min)
### Diagramme fonctionnel global
- **4 modules interconnectés :**
  - Module 1 : Import produits (NEWPRODS → DB2)
  - Module 2 : Import ventes (VENTESEU/AS → DB2)
  - Module 3 : Génération factures (DB2 → FACTURES)
  - Module 4 : Interface CICS (Saisie temps réel)

### Flux de données
```
Fichiers CSV → Traitement COBOL → Base DB2 → Génération Factures
                                     ↑
                               Interface CICS
```

---

## 5. Démonstration Technique (10 min)
### 5.1 Partie 1 - Import Nouveaux Produits (2 min)
- **Demo live :** Exécution MAJPROD avec conversion devises EUR/USD/YEN
- **Points clés :** Formatage descriptions, chargement taux en mémoire (optimisation)
- **Challenge résolu :** Fonction TRIM non native, recodage nécessaire

### 5.2 Partie 2 - Synchronisation Ventes (2 min)  
- **Demo :** Fusion fichiers VENTESEU/VENTESAS + mise à jour balances clients
- **Algorithme :** Logique de synchronisation avec rupture de contrôle
- **Résultats :** CA par commande + soldes clients actualisés

### 5.3 Partie 3 - Génération Factures (3 min)
- **Demo complète :** EXTRACT → FACTURE → Résultat formaté
- **Valeur ajoutée :** Sous-programme DATEFMT (algorithme Zeller)
- **Fonctionnalités :** TVA paramétrable + Commission dynamique employé
- **Code review :** Corrections bugs + optimisations Anouar

### 5.4 Partie 4 - Interface CICS (3 min)
- **Demo :** Authentification employé + IHM saisie nouvelles pièces
- **Architecture :** 2 écrans (login + saisie), fichier KSDS EMPLOYE + NEWPARTS  
- **Défis :** Debugging complexe, procédures compilation/installation

---

## 6. Approche Technique et Organisation (4 min)
### 6.1 Méthodologie de développement
- **Approche incrémentale :** Fonctionnel d'abord, optimisation ensuite
- **Tests unitaires :** Focus sur DATEFMT (cas normaux, limites, erreurs)
- **Gestion d'erreurs :** SQLCODE, ROLLBACK/COMMIT, validation données

### 6.2 Travail d'équipe
- **Coordination :** Daily SCRUM 15min (fait/difficultés/prévisions)
- **Outils collaboratifs :** GitHub, Miro, Discord
- **Résolution de blocages :** Support mutuel, sessions de débogage

---

## 7. Défis Rencontrés et Solutions (2 min)
### Défis techniques
- **Setup environnement :** Mac 2012 Anouar, XQuartz, transferts fichiers
- **Limitations IA :** Versions COBOL non supportées, limites de contexte
- **Bugs spécifiques :** "Glitches" CICS, conflits GitHub

### Solutions apportées
- **Adaptation :** Transferts via x3270, stratégie IA combinée
- **Collaboration :** Partage d'écran, sessions de debugging
- **Qualité :** Code reviews, documentation partagée

---

## 8. Améliorations et Perspectives (1 min)
- **Performance :** Optimisation des requêtes SQL, indexation
- **Robustesse :** Gestion d'erreurs étendue, logs détaillés
- **Fonctionnalités :** Interface web, exports multiples formats
- **Monitoring :** Tableaux de bord, alertes automatiques

---

## 9. Conclusion et Questions (1 min)
- **Bilan :** 4 modules fonctionnels, architecture scalable
- **Apprentissages :** Travail d'équipe agile, technologies mainframe
- **Ouverture aux questions**

---

### Répartition du temps de parole (équilibré)
- **Sylvain :** Introduction équipe + Parties 1&2 + Tests unitaires (10 min)
- **Denis :** Contexte + Partie 4 CICS + Méthodologie/Organisation (10 min)  
- **Anouar :** Architecture + Partie 3 + Code review + Défis/Améliorations (10 min)

### Tips pour la soutenance
- **Screenshots préparés** pour chaque démonstration
- **Backup plan** si problèmes techniques en live
- **Synchronisation** : Qui passe la parole à qui
- **Gestion du temps :** Timekeeper désigné