- liaison avec la partie 4 CICS

1. Fichier PROJET.NEWPRODS.DATA
2. Fichier PROJECT.TAUX.DATA

1. NEWPRODS: alimenter avec les nouveaux produits
    https://chatgpt.com/share/6894ae41-3714-800b-a02d-bf44dacd0b87
    - transfert CSV vers mainframe 
    - stocker dans un dataset USER.CSV.FILE
    - indiquer dans le JCL le dataset pour l'intégrer dans le programme
    - runner le programme cobol pour alimenter la table produit
    - ajouter un programme de test (?) par exemple pas de doublon
    - description majuscule/minuscule en utilisant les fonctions


2. TAUX: alimenter avec les nouveaux taux
Taux de conversion au sein d'un fichier ou SYSIN -> en fichier. On assume que l'utilisateur n'a pas la main.
- créer un fichier taux
- l'alimenter avec les différents taux
- Base EUR
- DO_DO = 1
- DO_EU = 0,9
- etc
- dans le JCL, utiliser SYSIN pour alimenter les différents taux
- si taux déjà présent, l'écraser



dans le jcl au niveau du SYSIN : on mettra les conversion de devise
à la fin on met une valeur absurde comme 00000000000000000

on fait un perform until 00000000000 dans le cobol pour traiter les enregistrement du sysin
