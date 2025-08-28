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
           05 WS-DEVISE        PIC X(3).
      
      *> prix en devise locale/en USD - FORMAT COMP-3
       77 WS-PRIX-NUM     PIC 9(7)V99 VALUE 0.   
       77 WS-PRIX-USD     PIC S9(3)V9(2) USAGE COMP-3 VALUE 0.
       77 WS-I            PIC 99 VALUE 0.

      ** Variables d'édition
       77 ED-PRIX-USD     PIC ZZZ,99.

      ** Variables pour le formatage de la description
       77 WS-MAJUSCULES  PIC X(26) VALUE "ABCDEFGHIJKLMNOPQRSTUVWXYZ".
       77 WS-MINUSCULES  PIC X(26) VALUE "abcdefghijklmnopqrstuvwxyz".
       77 WS-IDX         PIC 99 VALUE 0.
       77 WS-POS         PIC 99 VALUE 0.
       77 WS-PREV-CHAR   PIC X VALUE SPACE.
       77 WS-CHAR        PIC X.

      ** Variables pour la recherche de taux
       77 WS-CODE-DEV-LU   PIC X(3).
       77 WS-TAUX-LU       PIC X(10).
       77 WS-TAUX-NUM      PIC 9(3)V9(5).
       77 WS-DEVISE-TROUVE PIC X VALUE 'N'.

       PROCEDURE DIVISION.

           PERFORM OUV-NEWPRODS
           PERFORM LECT-NEWPRODS

           PERFORM UNTIL FF-NEWPRODS = 1
               ADD 1 TO WS-COMPTEUR
               DISPLAY "==================================="
               DISPLAY "ENREGISTREMENT N : ", WS-COMPTEUR
               DISPLAY "LIGNE BRUTE : ", LIGNE-NEWPRODS

      *        * Découpage de la ligne CSV
               PERFORM DECOUPE-CSV

      *        * Recherche du taux pour cette devise
               PERFORM RECHERCHE-TAUX-DEVISE

      *        * Affichage des champs extraits
               DISPLAY "NUMERO PRODUIT : ", WS-NUMERO
               DISPLAY "DESCRIPTION    : ", WS-DESCRIPTION
               DISPLAY "PRIX ORIGINE   : ", WS-PRIX, " ", WS-DEVISE
               DISPLAY "PRIX EN USD    : ", WS-PRIX-USD

      *        * Formatage du prix pour affichage
               MOVE WS-PRIX-USD TO ED-PRIX-USD
               DISPLAY "PRIX FORMATE   : ", ED-PRIX-USD

               PERFORM LECT-NEWPRODS
           END-PERFORM

           DISPLAY "==================================="
           DISPLAY "TOTAL ENREGISTREMENTS : ", WS-COMPTEUR
           PERFORM FERM-NEWPRODS

           GOBACK.

       RECHERCHE-TAUX-DEVISE.
           MOVE 'N' TO WS-DEVISE-TROUVE
           MOVE ZERO TO WS-TAUX-NUM
           
      *    * Si c'est du dollar, pas besoin de chercher
           IF WS-DEVISE = "DO" OR WS-DEVISE = "USD" THEN
               MOVE 'O' TO WS-DEVISE-TROUVE
               DISPLAY "DEVISE DE BASE (USD) : ", WS-DEVISE
           ELSE
               PERFORM OUV-TAUX
               IF FF-TAUX = 0 THEN
                   PERFORM LECT-TAUX
                   
                   PERFORM UNTIL FF-TAUX = 1 OR WS-DEVISE-TROUVE = 'O'
                       PERFORM DECOUPE-TAUX
                       
      *                * Vérifier si c'est la devise recherchée
                       IF WS-CODE-DEV-LU = WS-DEVISE THEN
                           MOVE 'O' TO WS-DEVISE-TROUVE
                           COMPUTE WS-TAUX-NUM = 
                                            FUNCTION NUMVAL(WS-TAUX-LU)
                           DISPLAY "TAUX TROUVE POUR ",
                                   WS-DEVISE, " : ", 
                                   WS-TAUX-LU
                       END-IF
                       
                       IF WS-DEVISE-TROUVE = 'N' THEN
                           PERFORM LECT-TAUX
                       END-IF
                   END-PERFORM
                   
                   PERFORM FERM-TAUX
               END-IF
               
               IF WS-DEVISE-TROUVE = 'N' THEN
                   DISPLAY "DEVISE NON TROUVEE : ", WS-DEVISE
               END-IF
           END-IF

           IF WS-DEVISE = "DO" OR WS-DEVISE = "USD"
               MOVE WS-PRIX-NUM TO WS-PRIX-USD
           ELSE
               COMPUTE WS-PRIX-USD = WS-PRIX-NUM * WS-TAUX-NUM
           END-IF
           .

       DECOUPE-TAUX.
      *    * Initialisation
           MOVE SPACES TO WS-CODE-DEV-LU
           MOVE SPACES TO WS-TAUX-LU
           MOVE 1 TO WS-POSITION
           MOVE 1 TO WS-DEBUT

      *    * Extraction de la devise (1er champ)
           PERFORM TROUVE-CHAMP-TAUX
           MOVE LIGNE-TAUX(WS-DEBUT:WS-LONGUEUR) TO WS-CODE-DEV-LU

      *    * Extraction du taux (2ème champ)
           PERFORM TROUVE-CHAMP-TAUX
           MOVE LIGNE-TAUX(WS-DEBUT:WS-LONGUEUR) TO WS-TAUX-LU
           .

       TROUVE-CHAMP-TAUX.
           MOVE ZERO TO WS-LONGUEUR
           MOVE WS-POSITION TO WS-DEBUT

      *    * Cherche le prochain point-virgule ou la fin de ligne
           PERFORM VARYING WS-POSITION FROM WS-POSITION BY 1
               UNTIL WS-POSITION > 20
                  OR LIGNE-TAUX(WS-POSITION:1) = ";"
                  OR LIGNE-TAUX(WS-POSITION:1) = SPACE
               ADD 1 TO WS-LONGUEUR
           END-PERFORM

      *    * Passe le point-virgule pour le champ suivant
           IF WS-POSITION <= 20 
              AND LIGNE-TAUX(WS-POSITION:1) = ";" THEN
               ADD 1 TO WS-POSITION
           END-IF
           .

       CONVERT-POINT-TO-COMMA.
           PERFORM VARYING WS-I FROM 1 BY 1
               UNTIL WS-I > LENGTH OF WS-PRIX
               IF WS-PRIX(WS-I:1) = "."
                   MOVE "," TO WS-PRIX(WS-I:1)
               END-IF
           END-PERFORM.

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
           PERFORM CONVERT-POINT-TO-COMMA
           COMPUTE WS-PRIX-NUM = FUNCTION NUMVAL(WS-PRIX)

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
           IF WS-POSITION <= 45 
              AND LIGNE-NEWPRODS(WS-POSITION:1) = ";" THEN
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
           ELSE
               MOVE 0 TO FF-TAUX
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
               MOVE 1 TO FF-TAUX
           END-READ.

       FORMATE-DESCRIPTION.
           MOVE SPACE TO WS-PREV-CHAR
       
           PERFORM VARYING WS-IDX FROM 1 BY 1
               UNTIL WS-IDX > FUNCTION LENGTH(WS-DESCRIPTION)
       
               MOVE WS-DESCRIPTION(WS-IDX:1) TO WS-CHAR
       
      *       *--- Tout passer en minuscules ---
               MOVE 0 TO WS-POS
               PERFORM VARYING WS-POS FROM 1 BY 1 UNTIL WS-POS > 26
                   IF WS-CHAR = WS-MAJUSCULES(WS-POS:1)
                       MOVE WS-MINUSCULES(WS-POS:1) TO WS-CHAR
                       MOVE 99 TO WS-POS
                   END-IF
               END-PERFORM
       
      *       *--- Majuscule si début de mot ---
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