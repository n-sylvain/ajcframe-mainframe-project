       IDENTIFICATION DIVISION.
       PROGRAM-ID. ETAPE3.
      
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT NEWPRODS ASSIGN TO NEWPRODS
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS FS-NEWPRODS.
           
           SELECT TAUX ASSIGN TO TAUX
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS FS-TAUX.
      
       DATA DIVISION.
       FILE SECTION.
       FD NEWPRODS.
       01 ENR-NEWPRODS.
           05 LIGNE-NEWPRODS    PIC X(45).
           
       FD TAUX.
       01 ENR-TAUX.
           05 LIGNE-TAUX        PIC X(20).
      
       WORKING-STORAGE SECTION.
       77 FS-NEWPRODS      PIC 99.
       77 FF-NEWPRODS      PIC 9 VALUE ZERO.
       77 FS-TAUX          PIC 99.
       77 FF-TAUX          PIC 9 VALUE ZERO.
       77 WS-COMPTEUR      PIC 999 VALUE ZERO.
      
      ** Variables pour découpage CSV
       77 WS-POSITION      PIC 99 VALUE 1.
       77 WS-DEBUT         PIC 99 VALUE 1.
       77 WS-LONGUEUR      PIC 99 VALUE ZERO.
      
      ** Champs extraits
       01 WS-PRODUIT.
           05 WS-NUMERO        PIC X(10).
           05 WS-DESCRIPTION   PIC X(20).
           05 WS-PRIX          PIC X(10).
           05 WS-DEVISE        PIC X(2).

      ** Variables pour le formatage de la description
       77 WS-MAJUSCULES  PIC X(26) VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
       77 WS-MINUSCULES  PIC X(26) VALUE "abcdefghijklmnopqrstuvwxyz".
       77 WS-IDX         PIC 99 VALUE 0.
       77 WS-POS         PIC 99 VALUE 0.
       77 WS-PREV-CHAR   PIC X VALUE SPACE.
       77 WS-CHAR        PIC X.

      ** Variables pour les taux de change
       01 WS-TABLE-TAUX.
           05 WS-NB-TAUX       PIC 99 VALUE ZERO.
           05 WS-TAUX-DEVISE   OCCURS 20 TIMES.
               10 WS-CODE-DEV  PIC X(3).
               10 WS-TAUX-CHG  PIC 9(3)V9(5).

      ** Variables pour conversion
       77 WS-PRIX-NUM      PIC 9(5)V99 VALUE ZERO.
       77 WS-PRIX-USD      PIC 9(7)V99 VALUE ZERO.
       77 WS-TAUX-TROUVE   PIC 9(3)V9(5) VALUE ZERO.
       77 WS-DEVISE-TROUVE PIC X VALUE 'N'.
       
      ** Variables pour traitement des taux
       77 WS-TAUX-ALPHA    PIC X(10).
       77 WS-VIRGULE-POS   PIC 99.
       77 WS-PARTIE-ENT    PIC X(5).
       77 WS-PARTIE-DEC    PIC X(5).
       77 WS-TAUX-TEMP     PIC X(10).
      
       PROCEDURE DIVISION.
      
           PERFORM CHARGE-TAUX
           PERFORM OUV-NEWPRODS
           PERFORM LECT-NEWPRODS
      
           PERFORM UNTIL FF-NEWPRODS = 1
               ADD 1 TO WS-COMPTEUR
               DISPLAY "==================================="
               DISPLAY "ENREGISTREMENT N° : ", WS-COMPTEUR
               DISPLAY "LIGNE BRUTE : ", LIGNE-NEWPRODS
               
      *        * Découpage de la ligne CSV
               PERFORM DECOUPE-CSV
               
      *        * Conversion du prix
               PERFORM CONVERSION-PRIX
               
      *        * Affichage des champs extraits
               DISPLAY "NUMERO PRODUIT : ", WS-NUMERO
               DISPLAY "DESCRIPTION    : ", WS-DESCRIPTION  
               DISPLAY "PRIX ORIGINE   : ", WS-PRIX, " ", WS-DEVISE
               DISPLAY "PRIX EN USD    : ", WS-PRIX-USD
               
               PERFORM LECT-NEWPRODS
           END-PERFORM
      
           DISPLAY "==================================="
           DISPLAY "TOTAL ENREGISTREMENTS : ", WS-COMPTEUR
           PERFORM FERM-NEWPRODS
           
           GOBACK.

       CHARGE-TAUX.
           DISPLAY "********************************* TOP OF DAT"
           PERFORM OUV-TAUX
           PERFORM LECT-TAUX
           
           PERFORM UNTIL FF-TAUX = 1
               ADD 1 TO WS-NB-TAUX
               PERFORM DECOUPE-TAUX
               PERFORM LECT-TAUX
           END-PERFORM
           
           PERFORM FERM-TAUX
           DISPLAY "FIN DE FICHIER TAUX - FS : ", FS-TAUX
           DISPLAY "TAUX CHARGES : ", WS-NB-TAUX, " DEVISES"
           DISPLAY "==================================="
           .

       DECOUPE-TAUX.
           MOVE 1 TO WS-POSITION
           MOVE 1 TO WS-DEBUT
           
      *    * Extraction de la devise (1er champ)
           PERFORM TROUVE-CHAMP-TAUX
           MOVE LIGNE-TAUX(WS-DEBUT:WS-LONGUEUR) 
               TO WS-CODE-DEV(WS-NB-TAUX)
           
      *    * Extraction du taux (2ème champ)
           PERFORM TROUVE-CHAMP-TAUX
           MOVE LIGNE-TAUX(WS-DEBUT:WS-LONGUEUR) TO WS-TAUX-ALPHA
           
      *    * Conversion du taux décimal en numérique
           PERFORM CONVERTIT-TAUX
           
           DISPLAY "DEVISE : ", WS-CODE-DEV(WS-NB-TAUX),
                   "  - TAUX : ", WS-TAUX-CHG(WS-NB-TAUX)
           .

       CONVERTIT-TAUX.
      *    * Traitement manuel de la conversion décimale
           MOVE SPACES TO WS-PARTIE-ENT
           MOVE SPACES TO WS-PARTIE-DEC
           MOVE 0 TO WS-VIRGULE-POS
           
      *    * Cherche la position de la virgule
           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > 10 OR WS-TAUX-ALPHA(WS-IDX:1) = ","
                  OR WS-TAUX-ALPHA(WS-IDX:1) = SPACE
               IF WS-TAUX-ALPHA(WS-IDX:1) = "," THEN
                   MOVE WS-IDX TO WS-VIRGULE-POS
               END-IF
           END-PERFORM
           
           IF WS-VIRGULE-POS > 0 THEN
      *        * Il y a une virgule - séparer partie entière et décimale
               MOVE WS-TAUX-ALPHA(1:WS-VIRGULE-POS - 1) TO WS-PARTIE-ENT
               MOVE WS-TAUX-ALPHA(WS-VIRGULE-POS + 1:5) TO WS-PARTIE-DEC
           ELSE
      *        * Pas de virgule - nombre entier
               MOVE WS-TAUX-ALPHA TO WS-PARTIE-ENT
               MOVE "00000" TO WS-PARTIE-DEC
           END-IF
           
      *    * Construction du nombre formaté pour COBOL
           STRING WS-PARTIE-ENT DELIMITED BY SPACE
                  WS-PARTIE-DEC DELIMITED BY SPACE
                  INTO WS-TAUX-TEMP
           END-STRING
           
      *    * Conversion directe en numérique
           MOVE WS-TAUX-TEMP TO WS-TAUX-CHG(WS-NB-TAUX)
           .

       TROUVE-CHAMP-TAUX.
           MOVE ZERO TO WS-LONGUEUR
           MOVE WS-POSITION TO WS-DEBUT
           
      *    * Cherche le prochain point-virgule
           PERFORM VARYING WS-POSITION FROM WS-POSITION BY 1 
               UNTIL WS-POSITION > 20
                  OR LIGNE-TAUX(WS-POSITION:1) = ";"
               ADD 1 TO WS-LONGUEUR
           END-PERFORM
           
      *    * Passe le point-virgule pour le champ suivant
           IF WS-POSITION <= 20 THEN
               ADD 1 TO WS-POSITION
           END-IF
           .

       CONVERSION-PRIX.
      *    * Conversion manuelle du prix texte en numérique
           MOVE WS-PRIX TO WS-PRIX-NUM
           
      *    * Si c'est du dollar, pas de conversion
           IF WS-DEVISE = "DO" OR WS-DEVISE = "US" THEN
               MOVE WS-PRIX-NUM TO WS-PRIX-USD
           ELSE
      *        * Recherche du taux de change
               PERFORM RECHERCHE-TAUX
               IF WS-DEVISE-TROUVE = 'O' THEN
                   COMPUTE WS-PRIX-USD = WS-PRIX-NUM * WS-TAUX-TROUVE
               ELSE
                   DISPLAY "DEVISE INCONNUE : ", WS-DEVISE
                   MOVE WS-PRIX-NUM TO WS-PRIX-USD
               END-IF
           END-IF
           .

       RECHERCHE-TAUX.
           MOVE 'N' TO WS-DEVISE-TROUVE
           MOVE ZERO TO WS-TAUX-TROUVE
           
           PERFORM VARYING WS-IDX FROM 1 BY 1 
               UNTIL WS-IDX > WS-NB-TAUX OR WS-DEVISE-TROUVE = 'O'
      *        * Comparaison en tenant compte des codes à 2 ou 3 caractères
               IF WS-DEVISE = WS-CODE-DEV(WS-IDX)(1:2) THEN
                   MOVE 'O' TO WS-DEVISE-TROUVE
                   MOVE WS-TAUX-CHG(WS-IDX) TO WS-TAUX-TROUVE
                   DISPLAY "TAUX TROUVE POUR ", WS-DEVISE, " : ", 
                           WS-TAUX-TROUVE
               END-IF
           END-PERFORM
           .
      
       DECOUPE-CSV.
      *    * Initialisation
           MOVE SPACES TO WS-PRODUIT
           MOVE 1 TO WS-POSITION
           MOVE 1 TO WS-DEBUT
           
      *    * Extraction du numéro de produit (1er champ)
           PERFORM TROUVE-CHAMP
           MOVE LIGNE-NEWPRODS(WS-DEBUT:WS-LONGUEUR) TO WS-NUMERO
           
      *    * Extraction de la description (2ème champ)  
           PERFORM TROUVE-CHAMP
           MOVE LIGNE-NEWPRODS(WS-DEBUT:WS-LONGUEUR) TO WS-DESCRIPTION
           PERFORM FORMATE-DESCRIPTION
           
      *    * Extraction du prix (3ème champ)
           PERFORM TROUVE-CHAMP
           MOVE LIGNE-NEWPRODS(WS-DEBUT:WS-LONGUEUR) TO WS-PRIX
           
      *    * Extraction de la devise (4ème champ)
           PERFORM TROUVE-CHAMP
           IF WS-LONGUEUR > 0 THEN
               MOVE LIGNE-NEWPRODS(WS-DEBUT:WS-LONGUEUR) TO WS-DEVISE
           END-IF
           .
      
       TROUVE-CHAMP.
           MOVE ZERO TO WS-LONGUEUR
           MOVE WS-POSITION TO WS-DEBUT
           
      *    * Cherche le prochain point-virgule
           PERFORM VARYING WS-POSITION FROM WS-POSITION BY 1 
               UNTIL WS-POSITION > 45
                  OR LIGNE-NEWPRODS(WS-POSITION:1) = ";"
               ADD 1 TO WS-LONGUEUR
           END-PERFORM
           
      *    * Passe le point-virgule pour le champ suivant
           IF WS-POSITION <= 45 THEN
               ADD 1 TO WS-POSITION
           END-IF
           .
      
       OUV-NEWPRODS.
           OPEN INPUT NEWPRODS
           IF FS-NEWPRODS NOT = ZERO THEN
               DISPLAY "ERR OPEN NEWPRODS - FS : ", FS-NEWPRODS
               MOVE 1 TO FF-NEWPRODS
           END-IF.

       OUV-TAUX.
           OPEN INPUT TAUX
           IF FS-TAUX NOT = ZERO THEN
               DISPLAY "ERR OPEN TAUX - FS : ", FS-TAUX
               MOVE 1 TO FF-TAUX
           END-IF.
      
       FERM-NEWPRODS.
           CLOSE NEWPRODS
           IF FS-NEWPRODS NOT = ZERO THEN
               DISPLAY "ERR CLOSE NEWPRODS - FS : ", FS-NEWPRODS
           END-IF.

       FERM-TAUX.
           CLOSE TAUX
           IF FS-TAUX NOT = ZERO THEN
               DISPLAY "ERR CLOSE TAUX - FS : ", FS-TAUX
           END-IF.
      
       LECT-NEWPRODS.
           READ NEWPRODS AT END
               DISPLAY "FIN DE FICHIER NEWPRODS - FS : ", FS-NEWPRODS
               MOVE 1 TO FF-NEWPRODS
           END-READ.

       LECT-TAUX.
           READ TAUX AT END
               DISPLAY "FIN DE FICHIER TAUX - FS : ", FS-TAUX
               MOVE 1 TO FF-TAUX
           END-READ.

       FORMATE-DESCRIPTION.
           MOVE SPACE TO WS-PREV-CHAR
       
           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > 20
       
               MOVE WS-DESCRIPTION(WS-IDX:1) TO WS-CHAR
       
      *        *--- Tout passer en minuscules ---
               MOVE 0 TO WS-POS
               PERFORM VARYING WS-POS FROM 1 BY 1 UNTIL WS-POS > 26
                   IF WS-CHAR = WS-MAJUSCULES(WS-POS:1)
                       MOVE WS-MINUSCULES(WS-POS:1) TO WS-CHAR
                       MOVE 99 TO WS-POS
                   END-IF
               END-PERFORM
       
      *        *--- Majuscule si début de mot ---
               IF WS-PREV-CHAR = SPACE
                   MOVE 0 TO WS-POS
                   PERFORM VARYING WS-POS FROM 1 BY 1 UNTIL WS-POS > 26
                       IF WS-CHAR = WS-MINUSCULES(WS-POS:1)
                           MOVE WS-MAJUSCULES(WS-POS:1) TO WS-CHAR
                           MOVE 99 TO WS-POS
                       END-IF
                   END-PERFORM
               END-IF
       
               MOVE WS-CHAR TO WS-DESCRIPTION(WS-IDX:1)
               MOVE WS-CHAR TO WS-PREV-CHAR
           END-PERFORM
           .