Voici un résumé détaillé de votre projet final MAINFRAME :

## 📋 **CONTEXTE GÉNÉRAL**

Vous travaillez pour la société **AJCFRAME** (spécialisée dans la vente de produits) dans le cadre d'un projet final de formation. Ce projet dure environ **10 jours** et se termine par une **soutenance orale de 30 minutes** par groupe.

### **Organisation :**
- **Groupes de 3 personnes** (5 groupes au total)
- Travail en **autonomie** avec répartition des tâches
- Machines : API1-API3 sur machine 1, API4-API7 sur machine 2
- Votre formateur joue le rôle du "client" et peut vous aiguiller mais ne donne pas les solutions

## 🎯 **LES 4 PARTIES DU PROJET**

### **PARTIE 1 : Import des nouveautés produits**
- **Fichier source :** `PROJET.NEWPRODS.DATA` (format CSV, séparateur `;`)
- **Contenu :** Numéro produit, Description, Prix, Devise (EU/DO/YU)
- **Objectifs :**
  - Importer les données en base
  - Formater les descriptions (majuscule au début de chaque mot)
  - **Convertir tous les prix en dollars** (prévoir les taux de change)
  - Anticiper l'ajout de nouvelles devises

### **PARTIE 2 : Import des ventes étrangères**
- **Fichiers :** `PROJET.VENTESEU.DATA` et `PROJET.VENTESAS.DATA`
- **Structure :** N° commande, Date, N° employé, N° client, N° produit, Prix, Quantité
- **Objectifs :**
  - Importer les ventes en base
  - **Mettre à jour le chiffre d'affaires (balance) de chaque client**

### **PARTIE 3 : Génération de factures**
- **Fichier de sortie :** `PROJET.FACTURES.DATA`
- **Contraintes :**
  - Une facture par commande
  - Exporter d'abord vers `PROJET.EXTRACT.DATA`
  - Taux TVA défini en SYSIN
  - Programme de date en toutes lettres = **sous-programme obligatoire**
  - Format précis avec company info, détails produits, totaux, etc.

### **PARTIE 4 : Interface CICS (IHM)**
- **Objectif :** Créer une interface pour ajouter des pièces
- **Fichier cible :** `PROJET.NEWPARTS.KSDS`
- **Sécurité :** Authentification obligatoire avec `AJC.EMPLOYE.KSDS`
- **Nomenclature stricte :** PARTSX, USERSX, MSX, MAPX, TX (X = numéro groupe)

## 📊 **BASE DE DONNÉES**

**Structure fournie :**
- **Partie Pièces :** Tables PARTS, PARTSUP, SUPPLIER
- **Partie Commandes :** Tables ORDER, PRODUCT, CUSTOMER, EMPLOYEE, DEPARTMENT
- **Scripts fournis :** Pas besoin de créer la BD, juste lancer les scripts
- **Important :** Remplacer "APIX" par votre numéro API partout

## 🎤 **SOUTENANCE (CRUCIAL)**

### **Présentation PowerPoint obligatoire :**
1. Présentation de l'équipe
2. Contexte du projet  
3. Outils et gestion de projet
4. Solution fonctionnelle + diagramme
5. Proposition technique
6. Détails des étapes (organisation, algorithmes, travail d'équipe)
7. **Démonstration en direct**
8. Problèmes rencontrés et solutions
9. Améliorations possibles
10. Conclusion

### **Contraintes de soutenance :**
- **Temps de parole équilibré** entre les 3 membres
- Chacun doit connaître le travail des autres
- Présentation enregistrée
- Questions à l'issue

## 📁 **LIVRABLES FINAUX**

- **ZIP complet** avec tous les sources (programmes, JCL, etc.)
- Présentation PowerPoint
- Éventuellement accès à un dépôt Git
- **Tests unitaires** sur une fonctionnalité choisie

## ⚠️ **POINTS D'ATTENTION**

- **Récoltez screenshots/éléments au fur et à mesure** pour la présentation
- **Centralisez vos travaux** (dépôt commun)
- **Planifiez bien** avant la pause (ne pas s'arrêter au milieu d'une tâche)
- Utilisez l'IA avec prudence (vérifiez les informations)
- **Pas de copie** des exemples montrés

## 👥 **VOTRE GROUPE**
D'après la transcription, les groupes sont définis mais vous devrez noter le vôtre lors de la prochaine session.

**En résumé :** C'est un projet complet qui teste vos compétences techniques (COBOL, CICS, DB2) et votre capacité à travailler en équipe sur un cas concret d'entreprise, avec une forte composante présentation/communication.