La société AJCFRAME, spécialisée dans la vente de produits, vous sollicite afin de pouvoir l'aider à répondre à certaines problématiques auxquelles elle fait face.

# PROBLEMATIQUE

1. Dans un premier temps, elle souhaite importer au sein de sa base de données les nouveautés.
2. Également, elle doit récupérer les ventes passées par des prestataires
externes. Ces ventes peuvent concerner des clients basés en EUROPE et/ou en ASIE.
3. De plus, elle vous demande d’éditer les factures des commandes passées par ces clients.
4. Pour finir, elle souhaite proposer une interface de saisie afin d’ajouter les informations concernant les pièces.

## PARTIE 1 : Traitement des Nouveaux Produits pour AJCFRAME

**AJCFRAME** vend des produits provenant de différents pays. Elle reçoit régulièrement des fichiers avec les nouveautés.

* Le fichier transmis est organisé comme un fichier **CSV**.
* **Séparateur** utilisé : `;`
* **Taille maximale** d’un enregistrement : **45 caractères**
* **Nom du fichier** : `PROJET.NEWPRODS.DATA`

**Structure du Fichier**

| Champ/Nom             | Observations                          |
| --------------------- | ------------------------------------- |
| **NUMERO DE PRODUIT** | Unique dans le fichier                |
| **DESCRIPTION**       | Description du produit                |
| **PRIX**              | 5 chiffres dont 2 décimales           |
| **DEVISE**            | EU : Euro<br>DO : Dollar<br>YU : Yuan |

**Contenu du Fichier**

| NUMERO | DESCRIPTION      | PRIX   | DEVISE | RESERVE |
| ------ | ---------------- | ------ | ------ | ------- |
| P10    | USB FLASH DRIVE  | 15     | EU     |         |
| P11    | HEADPHONES       | 30.5   | DO     |         |
| P12    | MICRO            | 25.75  | YU     |         |
| P13    | TABLET           | 125.20 | YU     |         |
| P14    | LAPTOP           | 899.99 | DO     |         |
| P15    | MOTHERBOARD      | 60     | EU     |         |
| P16    | DESKTOP COMPUTER | 350.55 | DO     |         |
| P17    | DOCKING STATION  | 200    | EU     |         |
| P18    | NETWORK SWITCH   | 150.75 | YU     |         |
| P19    | LAPTOP GAMER     | 900    | EU     |         |
| P20    | SSD HARD DISK    | 152.50 | YU     |         |

**Objectif**

Traiter ce fichier et **insérer les données des nouveaux produits** dans la base de données :

* **Formater les descriptions** :
  → Première lettre de chaque mot en majuscule, les autres en minuscules.
  *Exemple : `USB FLASH DRIVE` → `Usb Flash Drive`*

* **Convertir les prix en dollars (\$)** :
  → Utiliser un fichier ou `SYSIN` pour les **taux de conversion**.

* Prévoir la possibilité d’**ajouter de nouvelles devises** ultérieurement.

**QUESTION/COURS**

- KSDS, VSAM
- description majuscule/minuscule
- format en entrée, format en sortie
  - y a-t-il d'autres fichiers ?
- format table taux de conversion en fichier
  - doit-on donner la main à l'utilisateur pour ajouter des informations de FX ?
- exercice code traitement entrée fichier et devises
- liaison avec la partie 4 CICS

Fichier PROJET.NEWPRODS.DATA
Fichier PROJECT.TAUX.DATA

+ Taux de conversion au sein d'un fichier ou SYSIN -> en fichier
  + 


---

## PARTIE 2 : Intégration des Ventes Europe & Asie

La société **AJCFRAME** reçoit **deux fichiers** contenant les ventes réalisées par des prestataires situés en **Europe** et en **Asie**.

---

**Objectif**

* **Importer** ces ventes dans la base de données.
* **Mettre à jour** le **chiffre d'affaires (balance)** de chaque client concerné.

Fichiers fournis

* `PROJET.VENTESEU.DATA`
* `PROJET.VENTESAS.DATA`

Ces deux fichiers ont **exactement la même structure**.

Structure des fichiers

| Position (Début - Fin) | Longueur | Type | Champ         | Observations                |
| ---------------------- | -------- | ---- | ------------- | --------------------------- |
| 1 - 3                  | 3        | N    | N° COMMANDE   |                             |
| 4 - 13                 | 10       | A    | DATE COMMANDE | Format : JJ/MM/AAAA         |
| 14 - 15                | 2        | N    | N° EMPLOYÉ    |                             |
| 16 - 19                | 4        | N    | N° CLIENT     |                             |
| 20 - 22                | 3        | A    | N° PRODUIT    |                             |
| 23 - 27                | 5        | N    | PRIX          | 5 chiffres dont 2 décimales |
| 28 - 29                | 2        | N    | QUANTITÉ      | Quantité commandée          |
| 30 - 35                | 6        | A    | RÉSERVE       | Zone réservée               |

Tri effectué sur les champs suivants :

1. N° de Commande
2. N° de Client
3. N° d’Employé

Contraintes des fichiers

* Une même commande :

  * ne contient **aucun doublon** de produit
  * est liée à **un seul employé**
  * a **une seule date**
  * concerne **un seul client**

Données fournies

`PROJET.VENTESAS.DATA`

| O\_NO | O\_DATE    | S\_NO | C\_NO | P\_NO | PRIX  | QTÉ |
| ----- | ---------- | ----- | ----- | ----- | ----- | --- |
| 501   | 15/10/2022 | 20    | 0003  | P02   | 01549 | 10  |
| 501   | 15/10/2022 | 20    | 0003  | P03   | 03575 | 02  |
| 502   | 02/11/2022 | 30    | 0002  | P05   | 05025 | 07  |
| 503   | 05/11/2022 | 50    | 0001  | P15   | 02599 | 10  |
| 505   | 17/11/2022 | 40    | 0004  | P10   | 03575 | 01  |
| 505   | 17/11/2022 | 40    | 0004  | P12   | 01000 | 04  |

`PROJET.VENTESEU.DATA`

| O\_NO | O\_DATE    | S\_NO | C\_NO | P\_NO | PRIX  | QTÉ |
| ----- | ---------- | ----- | ----- | ----- | ----- | --- |
| 500   | 10/10/2022 | 10    | 0004  | P01   | 01549 | 03  |
| 500   | 10/10/2022 | 10    | 0004  | P03   | 03575 | 02  |
| 500   | 10/10/2022 | 10    | 0004  | P04   | 01000 | 05  |
| 502   | 02/11/2022 | 30    | 0002  | P02   | 01549 | 03  |
| 502   | 02/11/2022 | 30    | 0002  | P03   | 03575 | 05  |
| 503   | 05/11/2022 | 50    | 0001  | P11   | 02599 | 05  |
| 504   | 07/11/2022 | 40    | 0003  | P14   | 03575 | 01  |
| 504   | 07/11/2022 | 40    | 0003  | P18   | 01000 | 04  |

Proposition de solution

1. **Lire et parser les fichiers** `VENTESEU` et `VENTESAS`.
2. **Vérifier l’intégrité des données** : conformité des dates, produits existants, etc.
3. **Insérer dans la table `ORDERS` et `ITEMS`** :

   * Générer une entrée dans `ORDERS` si `O_NO` n’existe pas.
   * Insérer les lignes de commande dans `ITEMS`.
4. **Mettre à jour la `BALANCE`** des clients dans `CUSTOMERS` :

   * Ajouter `PRIX × QUANTITE` à la balance du `C_NO`.

---

**QUESTIONS**

- du SQL ?
- bien comprendre les différentes bases

