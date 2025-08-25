## PARTIE 3 : Génération de factures

### Objectifs
- Générer une facture par commande
- Exporter les données vers des fichiers dédiés
- Formatage selon modèle imposé

### Fichiers de sortie
1. **`PROJET.EXTRACT.DATA`** - Données extraites de la BDD (fichier indexé VSAM)
2. **`PROJET.FACTURES.DATA`** - Factures formatées pour impression

### Processus technique
1. **Extraction des données**
   ```sql
   -- Requête SQL pour extraire infos utiles à la facturation
   EXEC SQL ... 
   ```
   - Créer fichier indexé (VSAM) `PROJET.EXTRACT.DATA`
   - Accès par clé client
   - Données nécessaires : O_NO, O_DATE, DESCRIPTION, QUANTITY, PRICE

2. **Génération factures**
   - Affichage en M.5 (format terminal)
   - Enregistrement formaté dans `PROJET.FACTURES.DATA`
   - Une commande par page
   - Formatage avec espaces, underscores, etc.

### Contraintes techniques
- Taux TVA défini en SYSIN
- Programme de date en toutes lettres = sous-programme
- Référence : **TP08 COBOL de Steve**

### Tests
- Vérification données pour une commande
- Contrôle formatage facture

### Questions en suspens
- **Confirmé par Steve :** Le formatage complet de la facture doit être enregistré dans le fichier (avec cadres, espacements, etc.)

---




dayofweek, accept en cobol

squelette programme
https://claude.ai/chat/a46d5e33-0aca-41d2-89a4-8fdf7cf20d93


8/8/2025 :
- l'appel au sous programme fonctionne
- le renvoi fonctionne
- la compilation fonctionne
- l'exécution fonctionne

à faire
- renommer les programmes dans TSO et ici
- merger les JCL à la fin

