       IDENTIFICATION DIVISION.
       PROGRAM-ID. ETAPE1.
      
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
           05 LIGNE-NEWPRODS    PIC X(45).
      
       WORKING-STORAGE SECTION.
       77 FS-NEWPRODS      PIC 99.
       77 FF-NEWPRODS      PIC 9 VALUE ZERO.
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
      
       PROCEDURE DIVISION.
      
           PERFORM OUV-NEWPRODS
           PERFORM LECT-NEWPRODS
      
           PERFORM UNTIL FF-NEWPRODS = 1
               ADD 1 TO WS-COMPTEUR
               DISPLAY "==================================="
               DISPLAY "ENREGISTREMENT N° : ", WS-COMPTEUR
               DISPLAY "LIGNE BRUTE : ", LIGNE-NEWPRODS
               
      *        * Découpage de la ligne CSV
               PERFORM DECOUPE-CSV
               
      *        * Affichage des champs extraits
               DISPLAY "NUMERO PRODUIT : ", WS-NUMERO
               DISPLAY "DESCRIPTION    : ", WS-DESCRIPTION  
               DISPLAY "PRIX           : ", WS-PRIX
               DISPLAY "DEVISE         : ", WS-DEVISE
               
               PERFORM LECT-NEWPRODS
           END-PERFORM
      
           DISPLAY "==================================="
           DISPLAY "TOTAL ENREGISTREMENTS : ", WS-COMPTEUR
           PERFORM FERM-NEWPRODS
           
           GOBACK.
      
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
           
      *    * Extraction du prix (3ème champ)
           PERFORM TROUVE-CHAMP
           MOVE LIGNE-NEWPRODS(WS-DEBUT:WS-LONGUEUR) TO WS-PRIX
           
      *    * Extraction de la devise (4ème champ)
           PERFORM TROUVE-CHAMP
           MOVE LIGNE-NEWPRODS(WS-DEBUT:WS-LONGUEUR) TO WS-DEVISE

           IF WS-LONGUEUR > 0 THEN
               MOVE LIGNE-NEWPRODS(WS-DEBUT:WS-LONGUEUR) TO WS-DEVISE
           END-IF
           .
      
       TROUVE-CHAMP.
           MOVE ZERO TO WS-LONGUEUR
           MOVE WS-POSITION TO WS-DEBUT
           
      *    * Cherche le prochain point-virgule
           PERFORM VARYING WS-POSITION FROM WS-POSITION BY 1 
               UNTIL WS-POSITION > FUNCTION LENGTH(LIGNE-NEWPRODS)
                  OR LIGNE-NEWPRODS(WS-POSITION:1) = ";"
               ADD 1 TO WS-LONGUEUR
           END-PERFORM
           
      *    * Passe le point-virgule pour le champ suivant
           IF WS-POSITION <= FUNCTION LENGTH(LIGNE-NEWPRODS) THEN
               ADD 1 TO WS-POSITION
           END-IF
           .
      
       OUV-NEWPRODS.
           OPEN INPUT NEWPRODS
           IF FS-NEWPRODS NOT = ZERO THEN
               DISPLAY "ERR OPEN NEWPRODS - FS : ", FS-NEWPRODS
               MOVE 1 TO FF-NEWPRODS
           END-IF.
      
       FERM-NEWPRODS.
           CLOSE NEWPRODS
           IF FS-NEWPRODS NOT = ZERO THEN
               DISPLAY "ERR CLOSE NEWPRODS - FS : ", FS-NEWPRODS
           END-IF.
      
       LECT-NEWPRODS.
           READ NEWPRODS AT END
               DISPLAY "FIN DE FICHIER NEWPRODS - FS : ", FS-NEWPRODS
               MOVE 1 TO FF-NEWPRODS
           END-READ.