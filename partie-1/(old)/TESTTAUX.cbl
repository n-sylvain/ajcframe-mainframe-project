       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTTAUX.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TAUX ASSIGN TO TAUX
                  ORGANIZATION IS SEQUENTIAL
                  FILE STATUS IS FS-TAUX.

       DATA DIVISION.
       FILE SECTION.
       FD TAUX.
       01 ENR-TAUX.
          05 LIGNE-TAUX PIC X(20).

       WORKING-STORAGE SECTION.
       77 FS-TAUX       PIC 99.
       77 FF-TAUX       PIC 9 VALUE 0.
       77 WS-COMPTEUR   PIC 999 VALUE 0.

      * Extraction
       77 WS-CODE-DEV   PIC X(2).
       77 WS-TAUX-ALPHA PIC X(10).
       77 WS-TAUX-NUM   PIC S9(3)V9(5) COMP-3.
       77 WS-TAUX-ALPHA-POINT PIC X(10).

       PROCEDURE DIVISION.

           DISPLAY "=== DEBUT TEST LECTURE TAUX ==="

           PERFORM OUV-TAUX

           IF FF-TAUX = 0
               PERFORM LECT-TAUX
               PERFORM UNTIL FF-TAUX = 1
                   ADD 1 TO WS-COMPTEUR

      *            * Extraction devise et taux
                   MOVE LIGNE-TAUX(1:2) TO WS-CODE-DEV
                   MOVE LIGNE-TAUX(4:17) TO WS-TAUX-ALPHA

      *            * Conversion numérique
                   COMPUTE WS-TAUX-NUM = FUNCTION NUMVAL(WS-TAUX-ALPHA)

                   DISPLAY "LIGNE ", WS-COMPTEUR,
                           ": DEVISE=", WS-CODE-DEV,
                           " TAUX=", WS-TAUX-NUM

                   PERFORM LECT-TAUX
               END-PERFORM
           END-IF

           DISPLAY "=== FIN TEST - ", WS-COMPTEUR, " LIGNES LUES ==="

           PERFORM FERM-TAUX
           GOBACK.

       OUV-TAUX.
           OPEN INPUT TAUX
           IF FS-TAUX NOT = 0
              DISPLAY "ERREUR OUVERTURE TAUX - FS : ", FS-TAUX
              MOVE 1 TO FF-TAUX
           END-IF
           .

       FERM-TAUX.
           CLOSE TAUX
           IF FS-TAUX NOT = 0
              DISPLAY "ERREUR FERMETURE TAUX - FS : ", FS-TAUX
           END-IF
           .

       LECT-TAUX.
           READ TAUX AT END
               DISPLAY "FIN DE FICHIER TAUX"
               MOVE 1 TO FF-TAUX
           END-READ
           .

