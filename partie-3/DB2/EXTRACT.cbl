       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXTRACT.

      * EXTRACTION DES DONNEES VERS FICHIER SEQUENTIEL
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT EXTRACT-FILE ASSIGN TO EXTRACT
           ORGANIZATION IS SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD  EXTRACT-FILE
           RECORDING MODE IS F
           RECORD CONTAINS 281 CHARACTERS.
       01  EXTRACT-RECORD.
           05 EXT-COMPANY           PIC X(30).
           05 EXT-ADDRESS           PIC X(100).
           05 EXT-CITY              PIC X(20).
           05 EXT-ZIP               PIC X(5).
           05 EXT-STATE             PIC X(2).
           05 EXT-O-NO              PIC 9(3).
           05 EXT-ODATE-ISO         PIC X(10).
           05 EXT-DNAME             PIC X(20).
           05 EXT-LNAME             PIC X(20).
           05 EXT-FNAME             PIC X(20).
           05 EXT-COM               PIC 9V99.
           05 EXT-P-NO              PIC X(3).
           05 EXT-DESCRIPTION       PIC X(30).
           05 EXT-QUANTITY          PIC 9(2).
           05 EXT-PRICE             PIC 9(3)V99.
           05 EXT-LINE-TOTAL        PIC 9(5)V99.
           05 FILLER                PIC X(1).

       WORKING-STORAGE SECTION.
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

      * INCLUSION DE TOUS LES DCLGEN
           EXEC SQL
               INCLUDE CUST
           END-EXEC.

           EXEC SQL
               INCLUDE EMP
           END-EXEC.

           EXEC SQL
               INCLUDE DEPT
           END-EXEC.

           EXEC SQL
               INCLUDE ORD
           END-EXEC.

           EXEC SQL
               INCLUDE ITEM
           END-EXEC.

           EXEC SQL
               INCLUDE PROD
           END-EXEC.

      * DECLARATION DU CURSEUR POUR LA REQUETE COMPLEXE
           EXEC SQL
               DECLARE CORDERS CURSOR
               FOR
               SELECT
                   C.COMPANY,
                   C.ADDRESS,
                   C.CITY,
                   C.ZIP,
                   C.STATE,
                   O.O_NO,
                   CHAR(O.O_DATE) AS ODATE_ISO,
                   D.DNAME,
                   E.LNAME,
                   E.FNAME,
                   E.COM,
                   I.P_NO,
                   P.DESCRIPTION,
                   I.QUANTITY,
                   I.PRICE,
                   DECIMAL(I.QUANTITY * I.PRICE, 7, 2) AS LINE_TOTAL
               FROM
                   API6.ORDERS O
               INNER JOIN API6.CUSTOMERS C ON O.C_NO = C.C_NO
               INNER JOIN API6.EMPLOYEES E ON O.S_NO = E.E_NO
               INNER JOIN API6.DEPTS D ON E.DEPT = D.DEPT
               INNER JOIN API6.ITEMS I ON O.O_NO = I.O_NO
               INNER JOIN API6.PRODUCTS P ON I.P_NO = P.P_NO
               ORDER BY
                   O.O_NO, I.P_NO
           END-EXEC.

      * VARIABLES DE TRAVAIL POUR LES RESULTATS
        77 WS-COMPANY        PIC X(30).
        77 WS-ADDRESS        PIC X(100).
        77 WS-CITY           PIC X(20).
        77 WS-ZIP            PIC X(5).
        77 WS-STATE          PIC X(2).
        77 WS-O-NO           PIC S9(3)V USAGE COMP-3.
        77 WS-ODATE-ISO      PIC X(10).
        77 WS-DNAME          PIC X(20).
        77 WS-LNAME          PIC X(20).
        77 WS-FNAME          PIC X(20).
        77 WS-COM            PIC S9(1)V9(2) USAGE COMP-3.
        77 WS-P-NO           PIC X(3).
        77 WS-DESCRIPTION    PIC X(30).
        77 WS-QUANTITY       PIC S9(2)V USAGE COMP-3.
        77 WS-PRICE          PIC S9(3)V9(2) USAGE COMP-3.
        77 WS-LINE-TOTAL     PIC S9(5)V9(2) USAGE COMP-3.

      * VARIABLES DE CONTROLE
        77 WS-ANO            PIC 99 VALUE ZERO.
        77 WS-COUNTER        PIC 999 VALUE ZERO.
        77 WS-FILE-STATUS    PIC XX.

      * VARIABLES D'EDITION POUR CONVERSION
        77 ED-O-NO           PIC 999.
        77 ED-QUANTITY       PIC 99.
        77 ED-PRICE          PIC 9(3),99.
        77 ED-COM            PIC 9,99.
        77 ED-LINE-TOTAL     PIC 9(5),99.

       PROCEDURE DIVISION.

           DISPLAY "=== DEBUT EXTRACTION VERS FICHIER ==="

      * OUVERTURE DU FICHIER D'EXTRACTION
           OPEN OUTPUT EXTRACT-FILE
           IF WS-FILE-STATUS NOT = '00'
               DISPLAY "ERREUR OUVERTURE FICHIER : ", WS-FILE-STATUS
               PERFORM ABEND-PROG
           END-IF

      * OUVERTURE DU CURSEUR
           EXEC SQL
               OPEN CORDERS
           END-EXEC
           PERFORM TEST-SQLCODE

      * PREMIER FETCH
           PERFORM FETCH-ORDER

      * BOUCLE DE TRAITEMENT
           PERFORM UNTIL SQLCODE = +100
               ADD 1 TO WS-COUNTER
               PERFORM WRITE-EXTRACT-RECORD
               PERFORM FETCH-ORDER
           END-PERFORM

      * FERMETURE DU CURSEUR
           EXEC SQL
               CLOSE CORDERS
           END-EXEC
           PERFORM TEST-SQLCODE

      * FERMETURE DU FICHIER
           CLOSE EXTRACT-FILE
           IF WS-FILE-STATUS NOT = '00'
               DISPLAY "ERREUR FERMETURE FICHIER : ", WS-FILE-STATUS
           END-IF

           DISPLAY "=== NOMBRE TOTAL DE LIGNES EXTRAITES : ", WS-COUNTER, " ==="
           DISPLAY "=== FIN EXTRACTION ==="

           GOBACK.

       FETCH-ORDER.
           EXEC SQL
               FETCH CORDERS
               INTO :WS-COMPANY,
                    :WS-ADDRESS,
                    :WS-CITY,
                    :WS-ZIP,
                    :WS-STATE,
                    :WS-O-NO,
                    :WS-ODATE-ISO,
                    :WS-DNAME,
                    :WS-LNAME,
                    :WS-FNAME,
                    :WS-COM,
                    :WS-P-NO,
                    :WS-DESCRIPTION,
                    :WS-QUANTITY,
                    :WS-PRICE,
                    :WS-LINE-TOTAL
           END-EXEC
           PERFORM TEST-SQLCODE
           .

       WRITE-EXTRACT-RECORD.
      * PREPARATION DE L'ENREGISTREMENT
           MOVE WS-COMPANY TO EXT-COMPANY
           MOVE WS-ADDRESS TO EXT-ADDRESS
           MOVE WS-CITY TO EXT-CITY
           MOVE WS-ZIP TO EXT-ZIP
           MOVE WS-STATE TO EXT-STATE
           MOVE WS-ODATE-ISO TO EXT-ODATE-ISO
           MOVE WS-DNAME TO EXT-DNAME
           MOVE WS-LNAME TO EXT-LNAME
           MOVE WS-FNAME TO EXT-FNAME
           MOVE WS-P-NO TO EXT-P-NO
           MOVE WS-DESCRIPTION TO EXT-DESCRIPTION

      * CONVERSION DES DONNEES NUMERIQUES
           MOVE WS-O-NO TO ED-O-NO
           MOVE ED-O-NO TO EXT-O-NO

           MOVE WS-QUANTITY TO ED-QUANTITY
           MOVE ED-QUANTITY TO EXT-QUANTITY

           MOVE WS-PRICE TO ED-PRICE
           MOVE ED-PRICE TO EXT-PRICE

           MOVE WS-COM TO ED-COM
           MOVE ED-COM TO EXT-COM

           MOVE WS-LINE-TOTAL TO ED-LINE-TOTAL
           MOVE ED-LINE-TOTAL TO EXT-LINE-TOTAL

      * ECRITURE DE L'ENREGISTREMENT
           WRITE EXTRACT-RECORD
           IF WS-FILE-STATUS NOT = '00'
               DISPLAY "ERREUR ECRITURE FICHIER : ", WS-FILE-STATUS
               PERFORM ABEND-PROG
           END-IF
           .

       TEST-SQLCODE.
           EVALUATE TRUE
               WHEN SQLCODE = ZERO
                       CONTINUE
               WHEN SQLCODE > ZERO
                   IF SQLCODE = +100 THEN
                       DISPLAY "JEU DE DONNEES VIDE OU FINI"
                   ELSE
                       DISPLAY "WARNING : ", SQLCODE
                   END-IF
               WHEN SQLCODE < ZERO
                   PERFORM ABEND-PROG
           END-EVALUATE
           .

       ABEND-PROG.
           DISPLAY "ANOMALIE GRAVE : ", SQLCODE
           COMPUTE WS-ANO = 1 / WS-ANO
           .
