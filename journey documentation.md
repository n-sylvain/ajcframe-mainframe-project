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




Absolument. Voici un résumé de la réunion structuré selon les principes agiles.

---

### **Compte-rendu de Réunion Agile**

**Titre de la réunion :** Reprise du projet et stratégie d'utilisation des IA
**Date :** 25 Août
**Participants :** Denis, Léa, Sylvain (Anor ?)
**Scrum Master / Équipe :** L'équipe de développement

---

#### 1. **Événements marquants / Progrès (Done)**
*   **Léa** a finalisé et intégré un sous-programme complexe en COBOL pour formater la date en toutes lettres (jour de la semaine, mois, etc.), une fonctionnalité critique pour la génération des factures (Partie 3).
*   **Denis** a avancé sur le projet pendant les vacances et a identifié des défis avec les suggestions d'IA.

#### 2. **Planification (To Do)**
Les priorités pour la journée/semaine sont :
*   **Léa :** Terminer la Partie 3 (Factures) en récupérant et en formatant toutes les informations de commande, puis l'enregistrer dans le fichier `projet-facture.data`.
*   **Sylvain/Anor :** Se remettre dans le bain et commencer à travailler sur les Parties 1 et 2.
*   **Équipe :** Se préparer à implémenter des tests unitaires (ex: fonction de mise en majuscule) la semaine prochaine, comme anticipé par Denis.

#### 3. **Problèmes / Obstacles (Blockers)**
*   **Problèmes techniques :** Connexion audio instable et latence pendant la réunion.
*   **Bruit :** Le micro de Denis capte beaucoup de bruits de clavier, ce qui perturbe la concentration.
*   **Reprise difficile :** Sentiment général d'avoir "tout oublié" après la pause vacances. Besoin d'une période de remise à niveau.
*   **Outils IA :** Les modèles comme ChatGPT donnent parfois de mauvaises pistes ou des réponses dégradées. La limite de contexte des versions gratuites (Claude, ChatGPT) est un frein pour les questions techniques complexes.
*   **Clarté technique :** Incertitude sur la façon de structurer le fichier de sortie des factures (une ligne par facture ou par résultat ?).

#### 4. **Décisions prises**
*   **Stratégie d'utilisation des IA :**
    *   Utiliser **Claude** pour les questions techniques complexes (code).
    *   Utiliser **ChatGPT** pour les demandes plus simples.
    *   Les prompts doivent être très précis pour être efficaces.
*   **Point de synchronisation :** Un point de sync. agile sera organisé en fin de matinée pour faire un état des lieux des progrès.
*   **Gestion des batches (Partie 4) :** Clarification reçue : il faut créer un programme COBOL qui lit un fichier hebdomadaire (`new-part`) et en ajoute le contenu à la table `parts` en base de données. Ce n'est pas une tâche automatique du système.

#### 5. **Actions et Responsables**
| Action | Responsable | Délai |
| :--- | :--- | :--- |
| Se remettre dans le bain et avancer sur les Parties 1 & 2 | Sylvain/Anor | Journalier |
| Finaliser la récupération des données pour la Partie 3 | Léa | Journalier |
| Pousser le code de la Partie 3 sur le dépôt Git | Léa | ASAP |
| Organiser un point de sync. en fin de matinée | Tous | Aujourd'hui |
| Préparer une session sur les tests unitaires | Denis/Steve | Semaine prochaine |

---

#### **Notes additionnelles :**
*   **Disponibilités :** Denis sera absent de 16h00 à 16h20.
*   **Prochain point :** Un point général avec Steve est prévu dans l'après-midi.
*   **Ambiance :** L'équipe est motivée malgré la difficulté de la reprise et les problèmes techniques.




26/8 - 
Absolument. Voici un résumé agile de cette conversation, structuré pour un stand-up meeting.

### **Résumé de la Réunion (Style Stand-up Agile)**

**Date:** 26 Août
**Projet:** Développement SQL et Intégration de données
**Participants:** Moi (Sylvain), Arnaud, Denis, Steve (mentor)

---

#### **1. Ce qui a été fait depuis la dernière fois (Sylvain)**
*   Récupération réussie des données depuis les tables DB2 (n° de commande, employé, client) via une requête SQL.
*   Implémentation d'un curseur pour fetcher les données et les enregistrer dans un fichier séquentiel, après validation de l'approche par Steve.
*   **Progression globale:** La partie "extraction" de la tâche 3 est terminée.

#### **2. Objectifs du jour / Prochaines étapes**

*   **Sylvain (Tâche 3):** Finaliser le formatage des factures et les enregistrer dans le fichier `facture_data`. Estime que cette partie devrait être rapide.
*   **Arnaud (Tâches 1 & 2):** Comprendre comment créer un fichier séquentiel à partir d'un CSV et intégrer les données en vérifiant les doublons. Doit aller voir Steve pour être débloqué sur le point de départ.
*   **Denis (Partie CICS):** Se concentrer sur le débogage de ses programmes CICS (problèmes de "zones mémoires fantômes", versions qui persistent). Avance lentement et trouve le processus fastidieux.

#### **3. Blocages / Impédiments**

*   **Arnaud:** Bloqué au démarrage des tâches 1 et 2. Se sent en panique et a l'impression d'avoir tout oublié. **Besoin:** Une session avec Steve pour obtenir des directives claires.
*   **Denis:** Bloqué par des problèmes techniques complexes sur CICS (manque de familiarité, problèmes de désinstallation des programmes). Son setup matériel/Mac est une contrainte majeure (pas d'import/export facile vers TSO, doit passer par d'autres pour transférer le code).
*   **Risque général:** La lenteur globale de progression fait craindre de ne pas pouvoir terminer à temps. La communication (problèmes Discord hier) et les setups techniques sont des points de friction.

#### **4. Actions & Coordination d'équipe**

*   **Sylvain** reste concentré sur sa tâche (3) pour la terminer au plus vite, puis se rendra disponible pour aider Arnaud et Denis.
*   **Arnaud** va préparer des questions précises et voir Steve individuellement pour se débloquer.
*   **Point de sync prévu** en fin de matinée pour faire un récapitulatif de la progression et des blocages après la session avec Steve.
*   **Denis** continue de chercher des solutions de son côté en attendant le renfort de Sylvain.

**Note d'ambiance:** L'équipe est stressée et rencontre des difficultés techniques importantes, mais essaye de rester positive et solidaire ("on ne te laissera pas tomber").




---

Absolument ! Voici un résumé agile de cette réunion, structuré pour être clair et actionnable.

### Résumé de la Réunion du 27 Août - Format Agile

**Sujet :** Point d'avancement sur le Projet COBOL (Partie 3) et coordination de l'équipe.

---

#### 1. 🟢 Suivi d'Avancement (What's Done)

*   **Partie 3 (Génération de factures) est quasiment terminée et fonctionnelle.**
    *   **Sébastien** a présenté une démo live :
        *   Le programme `EXTRACT` exécute une grande jointure SQL via un curseur et produit un fichier de données.
        *   Le programme `FACTURE` formate les données en factures avec un cadre, gère les calculs (décimaux, TVA) et appelle un sous-programme pour la date en toutes lettres.
        *   Le sous-programme `DATEFMT` utilise l'algorithme de congruence de Zeller pour convertir une date en jour de la semaine (ex: "Mercredi 1 janvier 2025").
    *   Le code est déjà poussé sur **GitHub** et documenté.
    *   **Prochaine action :** Finaliser les tests unitaires (notamment sur `DATEFMT`).

#### 2. 🟡 Défis & Blocages (Blockers)

*   **Outils IA (Claude, ChatGPT) :** Ils sont indispensables mais doivent être utilisés stratégiquement.
    *   **Problème :** Ils proposent parfois du code utilisant des fonctions non supportées par la version COBOL de l'environnement TSO (ex: `PROCEDURE DIVISION MAIN LOGIC`).
    *   **Solution :** Validation manuelle et débogage étape par étape sont nécessaires. Combinaison de plusieurs IA (Claude pour l'architecture, ChatGPT pour le débogage ponctuel).
*   **Limites des comptes IA :** Les comptes gratuits (notamment Claude) ont des limites de prompts, ce qui nécessite une planification.
*   **Partie 1 (Mise à jour de la base de données) :** **Anwar** est bloqué sur l'interprétation de l'énoncé.
    *   **Blocage :** La priorité n'est pas de formater le fichier CSV d'entrée, mais de traiter ses données ligne par ligne avec des requêtes SQL pour mettre à jour la base.

#### 3. 📊 Démonstration & Livrables (Demo)

*   **Démo réussie** de la partie 3 :
    1.  Suppression du fichier extract existant.
    2.  Exécution du programme `EXTRACT` pour générer de nouvelles données.
    3.  Exécution du programme `FACTURE` avec un paramètre de TVA pour générer le fichier de factures formaté.
*   **Diagramme de flux (Mermaid)** généré par Claude pour la documentation et la future présentation.

#### 4. ➡️ Prochaines Étapes (Next Steps)

| Qui? | Quoi? | Quand? |
| :--- | :--- | :--- |
| **Sébastien** | Basculer sur la **Partie 1** pour aider Anwar à débloquer la mise à jour de la BDD. | Aujourd'hui (après 10h15) |
| **Anwar** | Partager avec Sébastien les retours précis de Steve sur l'approche SQL pour la Partie 1. | ASAP |
| **Toute l'équipe** | Examiner le code de la Partie 3 sur GitHub et poser des questions. | Cette semaine |
| **Toute l'équipe** | Commencer à préparer la **structure de la présentation** (en utilisant le diagramme et les notes générées). | Vendredi |

#### 5. 💡 Rétrospective / Apprentissages (Learnings)

*   **Stratégie IA confirmée :** Claude est meilleur pour l'architecture et la compréhension du code, ChatGPT pour le débogage ponctuel.
*   **Approche de développement :** Mieux vaut avoir un code fonctionnel ("qui marche") en premier, puis l'optimiser et le rendre plus élégant dans un second temps.
*   **Communication :** Le partage d'écran et les démos live sont très efficaces pour se synchroniser.



28 août:

Absolument. Voici un résumé complet et structuré de la réunion.

---

### **Résumé de la Réunion de Coordination Technique**

**Titre :** Code review et coordination technique avec Denis sur le projet de base de données et extraction de factures
**Date :** 28 août
**Participants :** Moi (Animateur), Denis, Anne Noire

---

#### **1. Objectif Principal de la Réunion**
Faire le point sur l'avancement des différentes parties du projet (notamment la gestion de base de données DB2 et l'extraction de factures), résoudre des problèmes techniques bloquants et se coordonner pour la suite des développements.

---

#### **2. Points Techniques Abordés et Problèmes Rencontrés**

*   **Problème de Denis (Partie DB2 - Mise à jour de table) :**
    *   **Problème :** Denis travaille sur un batch pour alimenter la table `PARTS` de la base de données à partir d'un fichier (`NEWPART.KSDS`). Son code JCL rencontre une erreur (`module not found`), potentiellement liée à une référence à un module interne `API6D` (lié au processus BIND).
    *   **Solution proposée :** L'animateur recommande de s'inspirer de l'exercice 4 du cours de Steve, qui couvre toutes les interactions CRUD avec DB2. Il est également suggéré de bien générer et inclure le `DCLGEN` pour la table `PARTS` et de placer le programme COBOL dans le dossier `db2` et non `cobol` pour éviter des erreurs de chemin.

*   **Problème de Coordination des Fichiers :**
    *   **Conflit :** Denis et l'animateur ont tous deux créé un fichier nommé `Étape4` dans des dossiers différents, ce qui a causé un problème de merge sur GitHub.
    *   **Solution adoptée :** Pour éviter les conflits futurs, il a été décidé que Denis travaillerait dans un sous-dossier dédié (ex: `partie1-anoua`) au sein du dossier `data`.

*   **Code Review de la Partie 3 (Extraction de Factures) par Anoua :**
    *   **Retours positifs :** Anoua a passé plusieurs heures à analyser le code et le trouve bien structuré et complet ("un sacré travail").
    *   **Questions et anomalies relevées :**
        1.  **Variable temporaire redondante :** Ligne ~48k, un `MOVE` vers une variable de travail (`EXT-QUANTITY`) semble inutile et peut être supprimé.
        2.  **Logique de l'Error Flag :** La variable `WS-ERROR-FLAG` (utilisée comme un booléen) semble toujours positionnée sur "Yes" et sa logique (valeur 88) n'est pas claire, notamment dans le traitement par défaut du taux de TVA.
        3.  **Compréhension du fichier de sortie :** Confusion sur le nombre de lignes dans le fichier `EXTRACT` (4 lignes car une entreprise a commandé deux produits) et sur la largeur des enregistrements (280 caractères, nécessitant la touche F11 pour tout voir sous TSO).
    *   **Actions :** Anoua va tester le code sur sa machine, le refactoriser et corriger les anomalies identifiées.

*   **Avancement de l'Animateur (Partie 1 - DB2) :**
    *   Il travaille sur la mise à jour de la base DB2 via SQL et a rencontré un bug sur le formatage des champs numériques (prix avec décimales). Son code n'est pas encore poussé car il n'est pas totalement clean.

---

#### **3. Démonstration de Denis**
Denis a fait une démo de son interface IHM (saisie de nouvelles pièces) :
*   **Fonctionnalité :** Un écran de login qui valide les credentials contre un fichier, puis un écran de saisie avec des contrôles de validation (champs obligatoires).
*   **Problème persistant :** Un "glitch" graphique (affichage corrompu) entre deux écrans (`MAPS`) qui bloque la fluidité de l'IHM.
*   **Verdict :** Le cœur de la fonctionnalité (insertion contrôlée en base) fonctionne, mais l'interface utilisateur a besoin de corrections.

---

#### **4. Coordination et Prochaines Étapes**

*   **Répartition des tâches :**
    *   **Anoua :** Se concentre sur le test, la correction et l'amélioration de la **Partie 3 (Factures)**. Il devra également regarder les tests unitaires (potentiellement sur la fonction de gestion des dates).
    *   **Denis :** Se concentre sur la correction du **glitch IHM** et sur la finalisation du **batch de mise à jour de la table PARTS**.
    *   **Animateur :** Se concentre sur la finalisation des **Parties 1 et 2 (DB2)**.

*   **Gestion de Code :** Utilisation de GitHub pour le versionnement. Il a été rappelé à Denis comment faire des commits et des pushes corrects via VS Code.

*   **Planning :** La team est globalement en retard. Une prochaine point est prévu à **14h** le jour même. Le travail le week-end est envisagé (à partir de 10h-10h30) pour rattraper le retard.

*   **Présentation finale :** Denis a préparé un visuel de présentation. Il est convenu d'en discuter plus tard, une fois l'avancement technique plus concret.

---

#### **5. Informations Diverses / Apartés**
*   La réunion a été perturbée par des bruits de travaux chez l'animateur et chez Anoua.
*   Brève discussion informelle sur l'envoi de CV et le marché de l'emploi COBOL (banques, assurances).











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