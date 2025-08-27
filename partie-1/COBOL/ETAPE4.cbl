       IDENTIFICATION DIVISION.
       PROGRAM-ID. UPDPRODS.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT NEWPRODS ASSIGN TO NEWPRODS
           ORGANIZATION IS SEQUENTIAL
           FILE STATUS IS FS-NEWPRODS.

       DATA DIVISION.
       FILE SECTION.
       FD NEWPRODS.
       01 ENR-NEWPRODS.
           05 LIGNE-NEWPRODS    PIC X(100).

       WORKING-STORAGE SECTION.
       77 FS-NEWPRODS      PIC 99.
       77 FF-NEWPRODS      PIC 9 VALUE ZERO.
       77 WS-COMPTEUR      PIC 9(5) VALUE ZERO.

      * Champs produits
       01 WS-PRODUIT.
           05 WS-NUMERO        PIC X(10).
           05 WS-DESCRIPTION   PIC X(50).
           05 WS-PRIX          PIC X(15).
           05 WS-DEVISE        PIC X(3).

       77 WS-PRIX-NUM     PIC 9(7)V99 VALUE 0.   
       77 WS-PRIX-USD     PIC 9(7)V99 VALUE 0.

      * SQL communication area obligatoire
       EXEC SQL INCLUDE SQLCA END-EXEC.

      * Variables hôtes pour DB2
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 HST-NUMERO      PIC X(10).
       01 HST-DESCRIPTION PIC X(50).
       01 HST-PRIX-USD    PIC S9(7)V99 COMP-3.
       EXEC SQL END DECLARE SECTION END-EXEC.

       PROCEDURE DIVISION.

      * Connexion à la base (si DSN pas défini par JCL)
           EXEC SQL
              CONNECT TO :WS-DB-NAME USER :WS-USER USING :WS-PASSWORD
           END-EXEC

      * Lecture fichier produits
           PERFORM OUV-NEWPRODS
           PERFORM LECT-NEWPRODS

           PERFORM UNTIL FF-NEWPRODS = 1
               ADD 1 TO WS-COMPTEUR

               PERFORM DECOUPE-CSV
               PERFORM RECHERCHE-TAUX-DEVISE

      *    Chargement des variables hôtes
               MOVE WS-NUMERO      TO HST-NUMERO
               MOVE WS-DESCRIPTION TO HST-DESCRIPTION
               MOVE WS-PRIX-USD    TO HST-PRIX-USD

      *    Mise à jour / insertion dans DB2
               EXEC SQL
                   MERGE INTO PRODUITS P
                   USING (VALUES (:HST-NUMERO,
                                  :HST-DESCRIPTION,
                                  :HST-PRIX-USD)) AS N(NUM, DESCR, PRIX)
                   ON P.NUMERO_PRODUIT = N.NUM
                   WHEN MATCHED THEN
                       UPDATE SET DESCRIPTION = N.DESCR,
                                  PRIX_USD     = N.PRIX
                   WHEN NOT MATCHED THEN
                       INSERT (NUMERO_PRODUIT, DESCRIPTION, PRIX_USD)
                       VALUES (N.NUM, N.DESCR, N.PRIX)
               END-EXEC

               IF SQLCODE NOT = 0
                   DISPLAY "ERREUR SQL : " SQLCODE " SUR PRODUIT "
                           WS-NUMERO
               END-IF

               PERFORM LECT-NEWPRODS
           END-PERFORM

      * Commit des mises à jour
           EXEC SQL COMMIT END-EXEC

           DISPLAY "TOTAL ENREGISTREMENTS TRAITES : " WS-COMPTEUR
           PERFORM FERM-NEWPRODS

           GOBACK.

       OUV-NEWPRODS.
           OPEN INPUT NEWPRODS
           IF FS-NEWPRODS NOT = ZERO
               MOVE 1 TO FF-NEWPRODS
           END-IF.

       FERM-NEWPRODS.
           CLOSE NEWPRODS.

       LECT-NEWPRODS.
           READ NEWPRODS AT END
               MOVE 1 TO FF-NEWPRODS
           END-READ.

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