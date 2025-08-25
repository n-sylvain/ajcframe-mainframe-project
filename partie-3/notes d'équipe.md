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




Absolument. Voici un résumé structuré des points clés de votre conversation, spécifiquement adapté pour la Partie 3 de votre projet. Vous pouvez réutiliser ces éléments pour votre documentation ou pour clarifier votre plan d'action.

### Résumé de la Partie 3 : Génération des Factures

**Objectif Final :** Générer une facture par commande et toutes les enregistrer dans un seul fichier `PROJET.FACTURES.DATA`.

---

#### 1. Stratégie d'Extraction des Données (`PROJET.EXTRACT.DATA`)

*   **Méthode :** Utilisation d'une **requête SQL DB2** unique qui joint toutes les tables nécessaires (`customer`, `orders`, `departments`, `employee`, `items`, `product`).
*   **Exécution :** La requête sera exécutée depuis le programme COBOL à l'aide d'**un curseur SQL**.
*   **Parcours des données :** Le programme bouclera sur les résultats du curseur ligne par ligne.
*   **Format de sortie :** Les données extraites seront écrites dans un **fichier séquentiel** (et non indexé).
*   **Justification du fichier séquentiel :** La clé naturelle (`order_num`) n'est pas unique dans le dataset extrait car une commande peut contenir plusieurs produits (plusieurs lignes). La logique de rupture de commande sera gérée lors de la lecture séquentielle de ce fichier.

---

#### 2. Stratégie de Génération des Factures (`PROJET.FACTURES.DATA`)

*   **Source des données :** Le programme de génération lira le fichier séquentiel `PROJET.EXTRACT.DATA`.
*   **Logique de traitement :** Le programme effectuera une **lecture séquentielle** du fichier d'extraction. Il gérera une **rupture sur le numéro de commande** : tant que le numéro de commande est le même, les lignes lues appartiennent à la même facture.
*   **Format du fichier de sortie :** Le fichier `PROJET.FACTURES.DATA` sera un fichier séquentiel qui contiendra toutes les factures formatées à la suite les unes des autres.
*   **Formatage d'une facture :** Chaque facture est un bloc de texte formaté sur plusieurs lignes, conformément au modèle fourni dans l'énoncé. Il s'agit d'alimenter un "prototype de ligne" en COBOL avec les données lues.
*   **Information fixe :** La ville dans l'en-tête de la facture (ex: "New York") est une information fixe liée au siège de l'entreprise et ne dépend pas de la ville de l'employé.

---

#### 3. Points de Vigilance / Actions à Finaliser

*   **Optimisation de la requête SQL :** Vérifier que la requête jointant toutes les tables est performante et adaptée si le schéma de la base évolue.
*   **Gestion des Curseurs DB2 :** Maîtriser la syntaxe COBOL/DB2 pour la déclaration, l'ouverture, la lecture et la fermeture du curseur.
*   **Logique de Rupture :** Bien développer l'algorithme qui détecte le changement de numéro de commande dans le fichier séquentiel pour terminer une facture et en commencer une nouvelle.
*   **Calculs :** S'assurer que les calculs (sous-total, TVA, total général) sont corrects, contrairement à l'exemple précédent qui contenait une erreur.