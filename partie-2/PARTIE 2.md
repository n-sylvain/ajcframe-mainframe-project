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



COBOL TP10 - SYNCHRO

ETAPE1 : afficher les données consolidées de VentesEU et VENTESAS en utilisant la notion de synchro (exercice de référence)
ETAPE2 : afficher en display en sysout pour chaque vente les informations qui vont être updaté et dans quelles bases.
ETAPE3 : màj les bases mais on va pour le moment essayer qu'une seule base (la base ORDERS) et si ça fonctionne, on fera les autres bases