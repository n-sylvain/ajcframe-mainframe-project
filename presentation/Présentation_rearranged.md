![background image](Présentation_rearranged001.png)

**Equipe #5**

**Sylvain Ni, Denis Ten Ket Kian, Anouar Adyel**

**juin-sept 2025**

**Projet de fin de formation**

**Développeur Grands Systèmes**  
![background image](Présentation_rearranged002.png)

**Denis TEN KET KIAN**

**Sylvain Ni**

**Anouar Adyel**

•

20 ans d'expertise en   
systèmes d'information

géographique

•

Profil développeur et   
gestionnaire de bases de   
données

•

8 ans d'expérience en   
finance de marché

•

Spécialisé dans   
l'automatisation de   
processus métier et la   
programmation

•

Formation ingénieur   
complétée par un Master en

Data Science

•

10 ans d'expérience :   
planification de vol   
(aviation) puis analyses   
ferroviaires

**L'équipe**  
![background image](Présentation_rearranged003.png)

**Sommaire**

**I.**

**Introduction \& Contexte**

**II.**

**Architecture technique, Outils \&**

**Gestion de projet**

**III.**

**Architecture Globale**

**IV.**

**Description et Démonstration des**

**modules développés**

o

**Import de nouveaux produits**

o

**Intégration des ventes**

o

**Génération des factures**

o

**Interface CICS sécurisée**

**V. Difficultés rencontrées \& solutions apportée**

**VI. Axes d'amélioration \& perspectives**

**VII. Conclusion**  
![background image](Présentation_rearranged004.png)

**I. Contexte métier AJCFRAME**

**AJCFRAME**

: société spécialisée dans la

**vente de produits**

informatiques

Entreprise qui commercialise des produits provenant de différents pays opérant sur les marchés

**européen et**

**asiatique**

**Problématiques rencontrées :**

L'entreprise fait face à plusieurs défis opérationnels

qui nécessitent une solution informatique :

**1.**

**Gestion des nouveautés**

: Besoin d'importer

régulièrement les nouveaux produits dans leur

base de données

**2.**

**Consolidation des ventes externes**

:

Récupération et intégration des données de

ventes réalisées par des prestataires externes en

Europe et en Asie

**3.**

**Facturation**

: Édition automatisée des factures

pour les commandes clients

**4.**

**Interface utilisateur**

: Création d'une IHM

sécurisée pour la saisie des informations de

pièces

**Enjeux business :**

❑

**Centralisation des données**

: Consolider toutes les

informations produits et ventes dans un système unique

❑

**Automatisation**

: Réduire les tâches manuelles répétitives

❑

**Traçabilité**

: Suivre les ventes réalisées à l'international

❑

**Efficacité**

: Optimiser les processus de gestion des

produits et de facturation

**Object technique :**

Modernisation du SI via

**Mainframe (z/OS, COBOL, DB2,**

**CICS, Gestion de fichiers séquentiels et indexés (KSDS))**  
![background image](Présentation_rearranged005.png)

**II. Architecture technique, Outils \& Gestion de projet**

**Outils techniques**

❑

**Développement / IDE**

▪

VS Code, Notepad++, MS

Office 365 (Powerpoint), IDE

TSO

❑

**Modélisation / Diagrammes**

▪

MIRO, Bizagi Modeler,

Mermaid

❑

**Versioning / Collaboration code**

▪

Git, GitHub

**Intelligence Artificielle**

•

ChatGPT (aide au debug et à la

documentation)

•

Claude AI (architecture et

analyse)

•

Deep Seek

**Organisation et travail d'équipe**

❑

**Méthodologie**

•

Agile \& Scrum, Daily SCRUM 15 min, Backlog avec priorisation

des tâches

❑

**M**

**éthodologie de développement**

•

Approche incrémentale (fonctionnel d'abord, optimisation

ensuite), tests unitaires, gestion des messages d'erreurs

❑

**Coordination \& suivi**



Dépôt GitHub commun, Miro Kanban, Discord, code review,

résolution de blocages en pair programming

❑

**Répartition des tâches**

•

Anouar : Code review + corrections Partie 3

•

Sylvain : Développement Parties 1 \& 2

•

Denis : Partie 4 (CICS) + présentation

Tous : support mutuel, tests unitaires, gestion erreurs  
![background image](Présentation_rearranged006.png)

**Architecture Globale**  
![background image](Présentation_rearranged007.png)

**MODULE 1**

Mise à jour des produits depuis

fichiers CSV  
![background image](Présentation_rearranged008.png)

**Diagramme fonctionnel Module 1**

**Objectifs**

•

Traiter un fichier CSV contenant de nouveaux produits

•

Convertir automatiquement les prix dans différentes devises vers le dollar (USD)

•

Formater les descriptions (majuscule au début de chaque mot)

•

Insérer les données dans la table PRODUCTS de la base DB2

**Fonctionnalités principales**

**1. Lecture et traitement du fichier CSV**

•

Parsing des champs séparés par   
point-virgule

•

Validation des données d'entrée

•

Gestion des erreurs de format

**2. Conversion des devises**

•

Chargement en mémoire des taux

de change

•

Support des devises : EU (Euro), DO   
(Dollar), YU (Yuan)

•

Calcul automatique vers USD

**3. Formatage des descriptions**

•

Conversion en format "Title Case"

•

Première lettre de chaque mot en

majuscule

•

Autres lettres en minuscules

**4. Intégration base de données**

•

Insertion via SQL embedded

•

Gestion des doublons (erreur -803)  
![background image](Présentation_rearranged009.png)

**Module 1**

**Gestion des erreurs**

•

Fichiers non trouvés : Affichage d'un message d'erreur explicite

•

Doublons : Détection et signalement (SQLCODE -803)

•

Devises inconnues : Traitement par défaut en USD

•

Erreurs SQL : Rollback automatique

**Performances**

Optimisation mémoire : Chargement des taux en table interne  
Lecture séquentielle : Traitement optimisé des fichiers  
Transaction unique : Commit final pour toutes les insertions

**Statistiques de traitement**

Le programme affiche en fin d'exécution :

•

Nombre total d'enregistrements lus

•

Nombre de produits insérés avec succès

•

Nombre d'erreurs détectées  
![background image](Présentation_rearranged010.png)

**Module 1**

**Résultat de l'exécution du programme MAJPROD**

À droite, SYSOUT du programme MAJPROD après l'exécution

En bas, table PRODUCTS après la màj  
![background image](Présentation_rearranged011.png)

**Objectif du test :**

Vérifier que la fonction FMTDESC formate

correctement en Title Case

**Architecture de test**

•

ASSEQTXT.cbl : compare valeurs attendues / réelles

•

FMTDESC.cbl : fonction de formatage de description

•

DESCTEST.cbl : lance les cas de tests unitaires

•

JCL API6DESC.jcl : compile, link et exécute les tests

**Cas de tests validés**

PRODUIT

→

Produit

produit

→

Produit

pRoDuIt

→

Produit

produit ALIMENTAIRE

→

Produit Alimentaire

mot avec espaces

→

Mot Avec Espaces

Chaîne vide

→

Chaîne vide

**Module 1**

**--**

**Test Unitaire**  
![background image](Présentation_rearranged012.png)

**MODULE 2**

Synchronisation/Consolidation

Ventes et Màj des BD  
![background image](Présentation_rearranged013.png)

**Diagramme fonctionnel Module 2**

**Fonctionnalités Principales**

**1. Traitement des Fichiers de Ventes**

•

Lecture synchronisée de deux fichiers triés (VENTESEU et

VENTESAS)

•

Fusion intelligente basée sur la clé de commande (N°   
commande + N° client + N° employé)

•

Gestion des ruptures pour calculer le chiffre d'affaires   
total par commande

**2. Mise à Jour Base de Données**

•

Création des commandes dans la table ORDERS

•

Insertion des items dans la table ITEMS avec prix et   
quantités

•

Mise à jour du solde client (BALANCE) dans la table

CUSTOMERS

**3. Gestion des Prix**

•

Prix explicite : utilisation du prix fourni dans le fichier

•

Prix manquant : récupération automatique depuis la

table PRODUCTS  
![background image](Présentation_rearranged014.png)

**Architecture Technique**

**Tables DB2 Impliquées**

•

**API6.CUSTOMERS**

: Informations clients et balance

•

**API6.ORDERS**

: En-têtes des commandes

•

**API6.ITEMS**

: Détails des lignes de commande

•

**API6.PRODUCTS**

: Catalogue produits avec prix

**Module 2**

**Logique de Traitement**

**Phase d'initialisation**

•

Ouverture des fichiers VENTESEU et VENTESAS

•

Lecture initiale des deux fichiers

**Boucle principale de synchronisation**

•

Comparaison des clés de tri (CMD+CLI+EMP)

•

Traitement selon trois cas :

•

Vente Europe uniquement

•

Vente Asie uniquement

•

Vente dans les deux zones (même clé)

**Traitement par rupture**

•

Calcul du chiffre d'affaires total par commande

•

Mise à jour de la balance client à chaque

changement de client

•

**Mise à jour DB2**

•

Insertion des commandes (gestion des

doublons avec SQLCODE -803)

•

Insertion des items de commande

•

Mise à jour des balances clients  
![background image](Présentation_rearranged015.png)

**Module 2**

**Résultat de l'exécution du programme**

**MAJDB**

À droite, table CUSTOMERS avec les balances màj  
En bas, table PRODUCTS, ORDERS et ITEMS après màj  
![background image](Présentation_rearranged016.png)

**MODULE 3**

Génération des factures  
![background image](Présentation_rearranged017.png)

**Diagramme fonctionnel Module 3**

**Objectifs**

•

Extraire les données

**commandes / clients / produits**

de DB2

•

Générer un

**fichier séquentiel**

**d'extraction**

**(280 caractères)**

•

Produire des

**factures formatées (132 caractères)**

prêtes à

l'impression

**Architecture**

**EXTRACT.cbl**

SQL embarqué (DB2)

Curseur multi-jointures (CUSTOMERS, ORDERS, EMPLOYEES,   
DEPTS, ITEMS, PRODUCTS)

Génération du fichier séquentiel

d'extraction

**FACTURE.cbl**

Lecture du fichier

d'extraction

Mise en page des factures (cadres, adresses, produits, totaux)  
Calculs automatiques (Sous-total, TVA, commission, Total TTC)

**Flux de traitement**

**EXTRACT**

Ouverture curseur DB2

FETCH ligne par ligne

Conversion / Écriture dans fichier séquentiel

**FACTURE**

Lecture séquentielle du fichier  
Mise en page ASCII (cadres, entêtes, tableau produits)

Calcul TVA (20%) + commission (9,9%)

Génération facture finale  
![background image](Présentation_rearranged018.png)

**Ajouter screenshots factures et requête**

**SQL**  
![background image](Présentation_rearranged019.png)

**Ajouter partie test unitaire sur DATEFMT**  
![background image](Présentation_rearranged020.png)

**MODULE 4**

IHM \& CICS  
![background image](Présentation_rearranged021.png)

**IHM CICS**  
![background image](Présentation_rearranged022.png)

**BATCH**  
![background image](Présentation_rearranged023.png)

**Diagramme fonctionnel partie 4**  
![background image](Présentation_rearranged024.png)

**Défis techniques,**

**Solutions, Améliorations**  
![background image](Présentation_rearranged025.png)

**Problèmes et solutions**

❑

Manque compatibilité avec les Apple MAC

•

Matériel vétuste

•

Pas d'outil d'upload de fichier

•

Pas de touche F11 pour se déplacer à droite de

l'écran

❑

IA: Versions COBOL non supportées, limites de

contexte

❑

Bugs spécifiques : incident critique CICS, conflits

GitHub

❑

Adaptation :

Transferts via x3270, stratégie IA combinée

❑

Collaboration : Partage d'écran, sessions de debugging

❑

Qualité :

Code reviews, documentation partagée

❑

Redémarrage de serveur, reconfiguration du PDS SOURCE.BMS

qui était mal configuré et qui générait des membres

excessivement lourds, ce qui faisait bloquer CICS  
![background image](Présentation_rearranged026.png)

**Pistes d'amélioration**

❑

Cybersécurité :

•

Créer une table \<\< employes \>\> avec un champ

chiffré (algorithme de hachage + salage) pour le

mot de passe

•

Ou utiliser Active Directory pour la connexion des

utilisateurs à l'IHM pour saisir de nouvelles pièces

❑

Ajout des nouvelles pièces:

•

Se passer de l'étape du fichier intermédiaire

newparts.ksds

•

Préférer insertion directe dans la table PARTS

❑

Historicisation des données :

•

Pas de champ calculé (champ BALANCE)

•

Mettre en places des tables annexes pour stocker les

ventes Customers

•

Voire mettre en place un datawarehouse  
![background image](Présentation_rearranged027.png)

❑

Réalisations

•

import automatisé des nouveaux produits avec

conversion monétaire

•

intégration des ventes internationales

•

Génération automatique de factures

•

Mise en place d'une interface sécurisée de

saisie.

❑

Compétences développées

•

Maîtrise des technologies mainframe (COBOL,

CICS, DB2, VSAM)

•

Gestion de fichiers séquentiels et bases de

données

•

Développement d'interfaces utilisateur

sécurisées

•

Mise en œuvre de tests unitaires

•

Travail collaboratif et gestion de projet

**Conclusion**

❑

Valeur ajoutée pour AJCFRAME

•

Automatisation des processus manuels

chronophages

•

Centralisation et fiabilisation des données

❑

Amélioration de la traçabilité des ventes

internationales

•

Interface moderne pour la gestion des pièces

•

Solution évolutive pour l'ajout de nouvelles

devises

❑

Perspectives d'évolution

•

Extension à d'autres zones géographiques

(Amérique, Afrique)

•

Amélioration de l'interface utilisateur avec des

fonctionnalités avancées

•

Intégration d'outils de reporting et d'analyse

•

Optimisation des performances pour des

volumes de données plus importants  
![background image](Présentation_rearranged028.png)

**SEANCE DES QUESTIONS**  
![background image](Présentation_rearranged029.png)

**Merciiii**

[❑](mailto:fadyel@yahoo.fr)

[fadyel@yahoo.fr](mailto:fadyel@yahoo.fr)

[❑](mailto:ten_denis@hotmail.com)

[ten_denis@hotmail.com](mailto:ten_denis@hotmail.com)

[❑](mailto:sylvainni@msn.com)

[sylvainni@msn.com](mailto:sylvainni@msn.com)

*** ** * ** ***

Document Outline
================

* [Diapositive 1 Projet de fin de formation Développeur Grands Systèmes](Présentation_rearranged.html#1)
* [Diapositive 2 L'équipe](Présentation_rearranged.html#2)
* [Diapositive 3 Sommaire](Présentation_rearranged.html#3)
* [Diapositive 4 Contexte métier AJCFRAME](Présentation_rearranged.html#4)
* [Diapositive 5 II. Architecture technique, Outils \& Gestion de projet](Présentation_rearranged.html#5)
* [Diapositive 6 Architecture Globale](Présentation_rearranged.html#6)
* [Diapositive 7 MODULE 1](Présentation_rearranged.html#7)
* [Diapositive 8 Diagramme fonctionnel Module 1](Présentation_rearranged.html#8)
* [Diapositive 9 Module 1](Présentation_rearranged.html#9)
* [Diapositive 10 Module 1](Présentation_rearranged.html#10)
* [Diapositive 11](Présentation_rearranged.html#11)
* [Diapositive 12 MODULE 2](Présentation_rearranged.html#12)
* [Diapositive 13 Diagramme fonctionnel Module 2](Présentation_rearranged.html#13)
* [Diapositive 14 Module 2](Présentation_rearranged.html#14)
* [Diapositive 15 Module 2](Présentation_rearranged.html#15)
* [Diapositive 16 MODULE 3](Présentation_rearranged.html#16)
* [Diapositive 17 Diagramme fonctionnel Module 3](Présentation_rearranged.html#17)
* [Diapositive 18 Ajouter screenshots factures et requête SQL](Présentation_rearranged.html#18)
* [Diapositive 19 Ajouter partie test unitaire sur DATEFMT](Présentation_rearranged.html#19)
* [Diapositive 20 MODULE 4](Présentation_rearranged.html#20)
* [Diapositive 21 IHM CICS](Présentation_rearranged.html#21)
* [Diapositive 22 BATCH](Présentation_rearranged.html#22)
* [Diapositive 23 Diagramme fonctionnel partie 4](Présentation_rearranged.html#23)
* [Diapositive 24 Défis techniques, Solutions, Améliorations](Présentation_rearranged.html#24)
* [Diapositive 25 Problèmes et solutions](Présentation_rearranged.html#25)
* [Diapositive 26 Pistes d'amélioration](Présentation_rearranged.html#26)
* [Diapositive 27 Conclusion](Présentation_rearranged.html#27)
* [Diapositive 28 SEANCE DES QUESTIONS](Présentation_rearranged.html#28)
* [Diapositive 29 Merciiii](Présentation_rearranged.html#29)
* Diapositive 30 Sélection d'aides visuelles
* Diapositive 31 PROBLEMES ET SOLUTIONS
* Diapositive 32 CONCLUSION
* Diapositive 33 Techniques de livraison efficaces
* Diapositive 34 Navigation dans les sessions questions et réponses
* Diapositive 35 -------
* Diapositive 36 dddddddd
* Diapositive 37 Mesures d'engagement du discours
* Diapositive 38 Derniers conseils et points à retenir
* Diapositive 39 CONTEXTE
* Diapositive 40 CONTEXTE
* Diapositive 41 OUTILS \& GESTION DE PROJET
* Diapositive 42 ETAPES DU PROJET
* Diapositive 43 APPROCHE TECHNIQUE ET ORGANISATION
* Diapositive 44 ETAPES DU PROJET / Workflow
