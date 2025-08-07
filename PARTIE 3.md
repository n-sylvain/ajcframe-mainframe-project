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