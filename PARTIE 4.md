## PARTIE 4 : Interface CICS

### Objectifs
- Interface Homme-Machine pour ajouter des pièces
- Authentification sécurisée
- Ajout dans fichier `PROJET.NEWPARTS.KSDS`

### Nomenclature imposée (X = nom du groupe)
- Fichier `PROJET.NEWPARTS.KSDS` ➔ **PARTSX**
- Fichier `PROJET.EMPLOYE.KSDS` ➔ **USERSX** 
- Mapset(s) ➔ **MSX**
- Map(s) ➔ **MAPX**
- Transaction(s) ➔ **TX**

### Authentification
- Fichier `AJC.EMPLOYE.KSDS`
- Login = code employé
- Password = prénom employé

### État d'avancement
- Denis a commencé l'implémentation
- Problèmes de bugs en cours de résolution

---

## Organisation et Répartition

### Répartition des tâches
- **Denis :** Partie 4 (CICS) + Partie 1 ou 2 si temps
- **Sylvain :** Partie 3 (Factures) 
- **Anouar :** Partie 1 ou 2

### Stratégie technique
1. Chacun réplique la création des tables dans son API
2. Travail en autonomie puis consolidation
3. Check-ups réguliers
4. Une fois une partie terminée, renfort sur les autres

### Points à clarifier avec Steve
- ✅ **Formatage facture :** Confirmé - enregistrement complet du format dans le fichier
- Types de tests attendus (unitaires détaillés ou basiques ?)

---

## Tests Unitaires
- À implémenter sur une fonctionnalité choisie
- Exemples :
  - Formatage descriptions (majuscule/minuscule)
  - Conversion devises
  - Contrôle doublons
  - Validation données factures

---

## Ressources et Références
- **TP08 COBOL** de Steve pour la partie factures
- Scripts SQL fournis : `BDDORDER`, `BDDPARTS`
- Fichiers de données fournis dans le projet
- Extension VS Code : **KanPilot** pour gestion Kanban