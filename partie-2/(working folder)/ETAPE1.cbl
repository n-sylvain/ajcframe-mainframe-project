       IDENTIFICATION DIVISION.
       PROGRAM-ID.    ETAPE1.
      
      ********************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT VENTESEU ASSIGN TO VENTESEU
            ORGANIZATION IS SEQUENTIAL.
      
            SELECT VENTESAS ASSIGN TO VENTESAS
            ORGANIZATION IS SEQUENTIAL.
      
      ********************************************************
       DATA DIVISION.
       FILE SECTION.
       FD VENTESEU.
       01 ENR-VENTESEU.
          05 VEU-NUM-CMD     PIC 9(3).
          05 VEU-DATE-CMD    PIC X(10).
          05 VEU-NUM-EMP     PIC 9(2).
          05 VEU-NUM-CLI     PIC 9(4).
          05 VEU-NUM-PROD    PIC X(3).
          05 VEU-PRIX        PIC X(5).
          05 VEU-QTE         PIC 9(2).
          05 VEU-RESERVE     PIC X(6).
      
       FD VENTESAS.
       01 ENR-VENTESAS.
          05 VAS-NUM-CMD     PIC 9(3).
          05 VAS-DATE-CMD    PIC X(10).
          05 VAS-NUM-EMP     PIC 9(2).
          05 VAS-NUM-CLI     PIC 9(4).
          05 VAS-NUM-PROD    PIC X(3).
          05 VAS-PRIX        PIC X(5).
          05 VAS-QTE         PIC 9(2).
          05 VAS-RESERVE     PIC X(6).

       WORKING-STORAGE SECTION.
       
      * INCLUSION SQLCA ET DCLGEN PRODUCTS
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
               INCLUDE PROD
           END-EXEC.

      * Variables de travail pour la conversion de la date
       01 WS-DATE-TEMP.
          05 WS-DAY    PIC 9(2).
          05 FILLER    PIC X.
          05 WS-MONTH  PIC 9(2).
          05 FILLER    PIC X.
          05 WS-YEAR   PIC 9(4).

       01 WS-DATE-FORMATTED PIC X(10).

       01 WS-FF-VEU PIC 9 VALUE ZERO.
           88 NFF-VEU VALUE 0.
           88 FF-VEU  VALUE 1.
       01 WS-FF-VAS PIC 9 VALUE ZERO.
           88 NFF-VAS VALUE 0.
           88 FF-VAS  VALUE 1.
      
       01 WS-CLE-VEU.
          05 WS-CMD-VEU       PIC 9(3).
          05 WS-CLI-VEU       PIC 9(4).
          05 WS-EMP-VEU       PIC 9(2).
      
       01 WS-CLE-VAS.
          05 WS-CMD-VAS       PIC 9(3).
          05 WS-CLI-VAS       PIC 9(4).
          05 WS-EMP-VAS       PIC 9(2).
      
       01 WS-CLE-COURANTE.
          05 WS-CMD-COUR      PIC 9(3).
          05 WS-CLI-COUR      PIC 9(4).
          05 WS-EMP-COUR      PIC 9(2).
       
       01 WS-PRIX-WORK       PIC 9(5).
       01 WS-PRIX-FINAL      PIC 9(3)V99.

      * VARIABLES DE TRAVAIL POUR DB2
       01 WS-PRIX-RECUP      PIC S9(7)V99 USAGE COMP-3.
       01 WS-PROD-NO         PIC X(3).
       01 WS-CHIFFRE-AFF     PIC 9(5)V99.
       
      * VARIABLES POUR CA TOTAL COMMANDE
       01 WS-CA-TOTAL-CMD    PIC 9(7)V99 VALUE ZERO.
       01 WS-CMD-PRECEDENTE  PIC 9(3) VALUE ZERO.
       01 WS-PREMIERE-LIGNE  PIC 9 VALUE 1.
           88 PREMIERE-LIGNE VALUE 1.
           88 AUTRE-LIGNE    VALUE 0.
       
      * VARIABLES D'EDITION
       01 ED-PRIX            PIC Z(7),99.
       01 ED-CHIFFRE-AFF     PIC Z(5),99.
       01 ED-CA-TOTAL        PIC Z(7),99.
      
      ********************************************************
       PROCEDURE DIVISION.
      
           OPEN INPUT VENTESEU VENTESAS
           PERFORM LECT-VEU
           PERFORM LECT-VAS
      
           PERFORM UNTIL FF-VEU AND FF-VAS
              EVALUATE TRUE
              WHEN WS-CLE-VEU < WS-CLE-VAS
                 DISPLAY 'VENTE EUROPE UNIQUEMENT:'
                 PERFORM TRT-VEU
              WHEN WS-CLE-VEU > WS-CLE-VAS
                 DISPLAY 'VENTE ASIE UNIQUEMENT:'
                 PERFORM TRT-VAS
              WHEN OTHER
                 DISPLAY 'VENTE EUROPE ET ASIE (MEME CLE):'
                 PERFORM TRT-VEU
                 PERFORM TRT-VAS
              END-EVALUATE
              DISPLAY ' '
           END-PERFORM
      
           CLOSE VENTESEU VENTESAS
      
           GOBACK.

       ABEND-PROG.
           DISPLAY "ANOMALIE GRAVE : "
           MOVE ZERO TO WS-CMD-PRECEDENTE
           COMPUTE WS-CMD-PRECEDENTE = 1 / WS-CMD-PRECEDENTE.
      
       TRT-VEU.
           MOVE WS-CLE-VEU TO WS-CLE-COURANTE
           PERFORM UNTIL WS-CLE-COURANTE NOT = WS-CLE-VEU OR FF-VEU
              PERFORM AFF-VEU
              PERFORM LECT-VEU
           END-PERFORM
      * AFFICHAGE DU CA TOTAL A LA FIN DU TRAITEMENT VEU
           IF NOT PREMIERE-LIGNE
              MOVE WS-CA-TOTAL-CMD TO ED-CA-TOTAL
              DISPLAY 'TOTAL CA COMMANDE ' WS-CMD-PRECEDENTE ' : '
                      ED-CA-TOTAL
              DISPLAY ' '
           END-IF.
      
       TRT-VAS.
           MOVE WS-CLE-VAS TO WS-CLE-COURANTE
           PERFORM UNTIL WS-CLE-COURANTE NOT = WS-CLE-VAS OR FF-VAS
              PERFORM AFF-VAS
              PERFORM LECT-VAS
           END-PERFORM
      * AFFICHAGE DU CA TOTAL A LA FIN DU TRAITEMENT VAS
           IF NOT PREMIERE-LIGNE
              MOVE WS-CA-TOTAL-CMD TO ED-CA-TOTAL
              DISPLAY 'TOTAL CA COMMANDE ' WS-CMD-PRECEDENTE ' : '
                      ED-CA-TOTAL
              DISPLAY ' '
           END-IF.
      
       AFF-VEU.
           MOVE VEU-NUM-PROD TO WS-PROD-NO
           
      *    * GESTION DU CA TOTAL PAR COMMANDE
           IF VEU-NUM-CMD NOT = WS-CMD-PRECEDENTE
              MOVE VEU-NUM-CMD TO WS-CMD-PRECEDENTE
              MOVE ZERO TO WS-CA-TOTAL-CMD
              SET AUTRE-LIGNE TO TRUE
           END-IF
           
      *    DISPLAY 'VEU-PRIX = ' VEU-PRIX
           IF VEU-PRIX = SPACES
              PERFORM RECUPERER-PRIX-DB2
              MOVE WS-PRIX-RECUP TO WS-PRIX-FINAL
           ELSE
              MOVE VEU-PRIX TO WS-PRIX-WORK
              COMPUTE WS-PRIX-FINAL = WS-PRIX-WORK / 100
           END-IF
           
           MOVE WS-PRIX-FINAL TO WS-PRIX-RECUP
           MOVE WS-PRIX-FINAL TO ED-PRIX
           
           COMPUTE WS-CHIFFRE-AFF = VEU-QTE * WS-PRIX-RECUP
           ADD WS-CHIFFRE-AFF TO WS-CA-TOTAL-CMD
           MOVE WS-CHIFFRE-AFF TO ED-CHIFFRE-AFF
           
           DISPLAY 'CMD=' VEU-NUM-CMD ' DATE=' WS-DATE-FORMATTED
                   ' EMP=' VEU-NUM-EMP ' CLI=' VEU-NUM-CLI
           DISPLAY 'PROD=' VEU-NUM-PROD ' PRIX=' ED-PRIX
                   ' QTE=' VEU-QTE ' CA=' ED-CHIFFRE-AFF.
      
       AFF-VAS.
           MOVE VAS-NUM-PROD TO WS-PROD-NO
           
      *    * GESTION DU CA TOTAL PAR COMMANDE
           IF VAS-NUM-CMD NOT = WS-CMD-PRECEDENTE
              MOVE VAS-NUM-CMD TO WS-CMD-PRECEDENTE
              MOVE ZERO TO WS-CA-TOTAL-CMD
              SET AUTRE-LIGNE TO TRUE
           END-IF
           
      *    DISPLAY 'VAS-PRIX = ' VAS-PRIX
           IF VAS-PRIX = SPACES
              PERFORM RECUPERER-PRIX-DB2
              MOVE WS-PRIX-RECUP TO WS-PRIX-FINAL
           ELSE
              MOVE VAS-PRIX TO WS-PRIX-WORK
              COMPUTE WS-PRIX-FINAL = WS-PRIX-WORK / 100
           END-IF
           
           MOVE WS-PRIX-FINAL TO WS-PRIX-RECUP
           MOVE WS-PRIX-FINAL TO ED-PRIX
           
           COMPUTE WS-CHIFFRE-AFF = VAS-QTE * WS-PRIX-RECUP
           ADD WS-CHIFFRE-AFF TO WS-CA-TOTAL-CMD
           MOVE WS-CHIFFRE-AFF TO ED-CHIFFRE-AFF

           DISPLAY 'CMD=' VAS-NUM-CMD ' DATE=' WS-DATE-FORMATTED
                   ' EMP=' VAS-NUM-EMP ' CLI=' VAS-NUM-CLI
           DISPLAY 'PROD=' VAS-NUM-PROD ' PRIX=' ED-PRIX
                   ' QTE=' VAS-QTE ' CA=' ED-CHIFFRE-AFF.

       RECUPERER-PRIX-DB2.
           EXEC SQL
               SELECT PRICE
               INTO :WS-PRIX-RECUP
               FROM API6.PRODUCTS
               WHERE P_NO = :WS-PROD-NO
           END-EXEC
           
           EVALUATE SQLCODE
               WHEN ZERO
                   CONTINUE
               WHEN +100
                   DISPLAY 'PRODUIT NON TROUVE : ' WS-PROD-NO
                   MOVE ZERO TO WS-PRIX-RECUP
               WHEN OTHER
                   DISPLAY 'ERREUR SQL : ' SQLCODE ' - PRODUIT : '
                                                           WS-PROD-NO
                   MOVE ZERO TO WS-PRIX-RECUP
           END-EVALUATE.
      
       LECT-VEU.
           READ VENTESEU AT END
                 SET FF-VEU TO TRUE
                 MOVE 999 TO WS-CMD-VEU
                 MOVE 9999 TO WS-CLI-VEU
                 MOVE 99 TO WS-EMP-VEU
           NOT AT END
                 MOVE VEU-NUM-CMD TO WS-CMD-VEU
                 MOVE VEU-NUM-CLI TO WS-CLI-VEU
                 MOVE VEU-NUM-EMP TO WS-EMP-VEU

      *          * Convertir et formater la date
                 MOVE VEU-DATE-CMD TO WS-DATE-TEMP
                 STRING WS-YEAR '-' WS-MONTH '-' WS-DAY
                 DELIMITED BY SIZE
                 INTO WS-DATE-FORMATTED
           END-READ.
      
       LECT-VAS.
           READ VENTESAS AT END
                 SET FF-VAS TO TRUE
                 MOVE 999 TO WS-CMD-VAS
                 MOVE 9999 TO WS-CLI-VAS
                 MOVE 99 TO WS-EMP-VAS
           NOT AT END
                 MOVE VAS-NUM-CMD TO WS-CMD-VAS
                 MOVE VAS-NUM-CLI TO WS-CLI-VAS
                 MOVE VAS-NUM-EMP TO WS-EMP-VAS

      *          * Convertir et formater la date
                 MOVE VEU-DATE-CMD TO WS-DATE-TEMP
                 STRING WS-YEAR '-' WS-MONTH '-' WS-DAY
                 DELIMITED BY SIZE
                 INTO WS-DATE-FORMATTED
           END-READ.