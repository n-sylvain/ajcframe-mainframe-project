## PARTIE 2 : Import des ventes

### Objectifs
- Importer 2 fichiers : `PROJET.VENTESEU.DATA` et `PROJET.VENTESAS.DATA`
- Alimenter les différentes tables de la base de données
- Calculer et mettre à jour la balance (chiffre d'affaires) des clients

### Tables à alimenter
- **orders** - Commandes
- **items** puis **products** - Articles
- **customers** - Clients (calcul balance)
- **employees/depts** - Employés/départements (vérifier si MAJ nécessaire)

### Processus technique
- Beaucoup d'instructions `INSERT INTO`
- Calcul de la balance avec `GROUP BY CUSTOMER`
- Vérifier l'existence des bases avant insertion
- Vérifier les taux de conversion à utiliser

### Tests
- Vérifier la bonne entrée d'info pour chacune des bases
- Contrôle des doublons
- Validation des calculs de balance
