## PARTIE 1 : Import des nouveaux produits

### Objectifs
- Traiter le fichier CSV `PROJET.NEWPRODS.DATA`
- Insérer les nouveaux produits dans la base de données
- Convertir les prix en dollars
- Formater les descriptions (majuscule au début de chaque mot)

### Fichiers nécessaires
1. **`PROJET.NEWPRODS.DATA`** - Fichier CSV des nouveaux produits
2. **`PROJET.TAUX.DATA`** - Fichier des taux de conversion

### Processus technique
1. **Transfert CSV vers mainframe**
   - Stocker dans un dataset `USER.CSV.FILE`
   - Indiquer le dataset dans le JCL
   - Runner le programme COBOL pour alimenter la table produit

2. **Gestion des taux de conversion**
   - Créer un fichier taux externe (plus propre qu'en SYSIN)
   - Base de référence : Dollar (DO_DO = 1)
   - Exemples : DO_EU = 0.9, etc.
   - Si taux déjà présent, l'écraser

3. **Utilisation SYSIN dans JCL**
   ```cobol
   // Dans le JCL : conversions de devise via SYSIN
   // À la fin : valeur absurde comme 00000000000000000
   // COBOL : PERFORM UNTIL 00000000000 pour traiter les enregistrements SYSIN
   ```

### Tests
- Vérification pas de doublons
- Description correctement formatée (majuscule/minuscule)
- Conversion des devises correcte

### Liaison avec PARTIE 4 (CICS)
- Interface permettra d'ajouter des nouveaux produits dans `PROJET.NEWPRODS.DATA`
- Assurer la compatibilité entre la partie 1 et CICS






+ ; / 45 caractères
+ projet.newprods.data
+ traiter le fichier
+ paragraphe : majuscule sur la première lettre
+ attention à la devise, convertir le prix en dollars.
+  tx de conversion au sein d'un fichier, soit en sysin
+    en fichier, faire un fichier taux
+ insérer les produits dans la base de données PRODUCTS

+mise en mémoire des taux