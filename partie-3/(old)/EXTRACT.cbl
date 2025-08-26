IDENTIFICATION DIVISION.
       PROGRAM-ID. EXTRACT.
      *
      * PROGRAMME D'EXTRACTION DES DONNEES DB2 VERS FICHIER VSAM
      * POUR GENERATION DES FACTURES
      * PARTIE 3 - PROJET AJCFRAME
      *
       
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
           
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EXTRACT-FILE ASSIGN TO EXTRACT
           ORGANIZATION IS INDEXED
           ACCESS MODE IS SEQUENTIAL
           RECORD KEY IS EXT-KEY
           FILE STATUS IS WS-STATUS-EXT.
           
       DATA DIVISION.
       
       FILE SECTION.
       FD EXTRACT-FILE.
       01 ENR-EXTRACT.
          05 EXT-KEY.
             10 EXT-O-NO         PIC 9(3).
          05 EXT-O-DATE          PIC X(10).
          05 EXT-S-NO            PIC 9(2).
          05 EXT-C-NO            PIC 9(4).
          05 EXT-COMPANY         PIC X(30).
          05 EXT-ADDRESS         PIC X(100).
          05 EXT-CITY            PIC X(20).
          05 EXT-STATE           PIC X(2).
          05 EXT-ZIP             PIC X(5).
          05 EXT-DEPT            PIC 9(4).
          05 EXT-DNAME           PIC X(20).
          05 EXT-LNAME           PIC X(20).
          05 EXT-FNAME           PIC X(20).
          05 EXT-P-NO            PIC X(3).
          05 EXT-DESCRIPTION     PIC X(30).
          05 EXT-QUANTITY        PIC 9(2).
          05 EXT-PRICE           PIC 9(3)V99.
          
       WORKING-STORAGE SECTION.
       
      * INCLUDE POUR DB2
           EXEC SQL INCLUDE SQLCA END-EXEC.
           
      * VARIABLES DE STATUT
       77 WS-STATUS-EXT        PIC XX.
       77 WS-RETURN-CODE       PIC S9(4) COMP VALUE ZERO.
       
      * VARIABLES HOST DB2
       01 HV-EXTRACTION.
          05 HV-O-NO           PIC S9(4) COMP.
          05 HV-O-DATE         PIC X(10).
          05 HV-S-NO           PIC S9(4) COMP.
          05 HV-C-NO           PIC S9(8) COMP.
          05 HV-COMPANY        PIC X(30).
          05 HV-ADDRESS        PIC X(100).
          05 HV-CITY           PIC X(20).
          05 HV-STATE          PIC X(2).
          05 HV-ZIP            PIC X(5).
          05 HV-DEPT           PIC S9(8) COMP.
          05 HV-DNAME          PIC X(20).
          05 HV-LNAME          PIC X(20).
          05 HV-FNAME          PIC X(20).
          05 HV-P-NO           PIC X(3).
          05 HV-DESCRIPTION    PIC X(30).
          05 HV-QUANTITY       PIC S9(4) COMP.
          05 HV-PRICE          PIC S9(5)V99 COMP-3.
          
      * CURSEUR POUR EXTRACTION
           EXEC SQL DECLARE CURSOR_EXTRACT CURSOR FOR
               SELECT O.O_NO,
                      O.O_DATE,
                      O.S_NO,
                      O.C_NO,
                      C.COMPANY,
                      C.ADDRESS,
                      C.CITY,
                      C.STATE,
                      C.ZIP,
                      E.DEPT,
                      D.DNAME,
                      E.LNAME,
                      E.FNAME,
                      I.P_NO,
                      P.DESCRIPTION,
                      I.QUANTITY,
                      I.PRICE
               FROM API6.ORDERS O
               INNER JOIN API6.CUSTOMERS C ON O.C_NO = C.C_NO
               INNER JOIN API6.EMPLOYEES E ON O.S_NO = E.E_NO
               INNER JOIN API6.DEPTS D ON E.DEPT = D.DEPT
               INNER JOIN API6.ITEMS I ON O.O_NO = I.O_NO
               INNER JOIN API6.PRODUCTS P ON I.P_NO = P.P_NO
               ORDER BY O.O_NO, I.P_NO
           END-EXEC.
           
       PROCEDURE DIVISION.
       
       MAIN-PROCESS.
      * Ouverture du fichier VSAM
           OPEN OUTPUT EXTRACT-FILE
           
           IF WS-STATUS-EXT NOT = '00'
              DISPLAY 'ERREUR OUVERTURE FICHIER EXTRACT: ' 
                      WS-STATUS-EXT
              PERFORM TERMINER-ANORMAL
           END-IF
           
      * Ouverture du curseur DB2
           EXEC SQL OPEN CURSOR_EXTRACT END-EXEC
           
           IF SQLCODE NOT = ZERO
              DISPLAY 'ERREUR OUVERTURE CURSEUR: ' SQLCODE
              PERFORM TERMINER-ANORMAL
           END-IF
           
      * Boucle de traitement
           PERFORM LIRE-CURSEUR
           PERFORM UNTIL SQLCODE NOT = ZERO
               PERFORM ECRIRE-EXTRACT
               PERFORM LIRE-CURSEUR
           END-PERFORM
           
      * Vérification fin normale
           IF SQLCODE NOT = +100
              DISPLAY 'ERREUR LECTURE CURSEUR: ' SQLCODE
              PERFORM TERMINER-ANORMAL
           END-IF
           
      * Fermetures
           EXEC SQL CLOSE CURSOR_EXTRACT END-EXEC
           CLOSE EXTRACT-FILE
           
           DISPLAY 'EXTRACTION TERMINEE AVEC SUCCES'
           STOP RUN.
           
       LIRE-CURSEUR.
           EXEC SQL FETCH CURSOR_EXTRACT
               INTO :HV-O-NO,
                    :HV-O-DATE,
                    :HV-S-NO,
                    :HV-C-NO,
                    :HV-COMPANY,
                    :HV-ADDRESS,
                    :HV-CITY,
                    :HV-STATE,
                    :HV-ZIP,
                    :HV-DEPT,
                    :HV-DNAME,
                    :HV-LNAME,
                    :HV-FNAME,
                    :HV-P-NO,
                    :HV-DESCRIPTION,
                    :HV-QUANTITY,
                    :HV-PRICE
           END-EXEC.
           
       ECRIRE-EXTRACT.
      * Transfert des données host variables vers enregistrement
           MOVE HV-O-NO TO EXT-O-NO
           MOVE HV-O-DATE TO EXT-O-DATE
           MOVE HV-S-NO TO EXT-S-NO
           MOVE HV-C-NO TO EXT-C-NO
           MOVE HV-COMPANY TO EXT-COMPANY
           MOVE HV-ADDRESS TO EXT-ADDRESS
           MOVE HV-CITY TO EXT-CITY
           MOVE HV-STATE TO EXT-STATE
           MOVE HV-ZIP TO EXT-ZIP
           MOVE HV-DEPT TO EXT-DEPT
           MOVE HV-DNAME TO EXT-DNAME
           MOVE HV-LNAME TO EXT-LNAME
           MOVE HV-FNAME TO EXT-FNAME
           MOVE HV-P-NO TO EXT-P-NO
           MOVE HV-DESCRIPTION TO EXT-DESCRIPTION
           MOVE HV-QUANTITY TO EXT-QUANTITY
           MOVE HV-PRICE TO EXT-PRICE
           
      * Écriture dans le fichier VSAM
           WRITE ENR-EXTRACT
           
           IF WS-STATUS-EXT NOT = '00'
              DISPLAY 'ERREUR ECRITURE EXTRACT: ' WS-STATUS-EXT
              DISPLAY 'COMMANDE: ' EXT-O-NO
              PERFORM TERMINER-ANORMAL
           END-IF.
           
       TERMINER-ANORMAL.
           EXEC SQL ROLLBACK END-EXEC
           CLOSE EXTRACT-FILE
           MOVE 8 TO RETURN-CODE
           STOP RUN.