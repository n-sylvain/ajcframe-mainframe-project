       IDENTIFICATION DIVISION.
       PROGRAM-ID.    MAJDB.
      
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
       
      * INCLUSION SQLCA ET DCLGEN
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

           EXEC SQL
               INCLUDE PROD
           END-EXEC.

           EXEC SQL
               INCLUDE CUST
           END-EXEC.

           EXEC SQL
               INCLUDE ITEM
           END-EXEC.

           EXEC SQL
               INCLUDE ORD
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

      * VARIABLES POUR LA MAJ DB2
       01 WS-CMD-DEJA-CREE   PIC 9 VALUE ZERO.
           88 CMD-DEJA-CREE  VALUE 1.
           88 CMD-PAS-CREE   VALUE 0.
       
       01 WS-CLIENT-PREC     PIC 9(4) VALUE ZERO.
       01 WS-CA-CLIENT       PIC S9(8)V9(2) USAGE COMP-3 VALUE ZERO.
       
       01 WS-NB-ORDERS       PIC 9(5) VALUE ZERO.
       01 WS-NB-ITEMS        PIC 9(5) VALUE ZERO.
       01 WS-NB-CLIENTS-MAJ  PIC 9(3) VALUE ZERO.
       
       01 WS-DATE-FORMAT     PIC X(10).
       01 ED-CA-CLIENT       PIC Z(8),99.
      
      ********************************************************
       PROCEDURE DIVISION.
      
           DISPLAY 'DEBUT PROGRAMME MAJDB - MAJ BASE DE DONNEES'
           OPEN INPUT VENTESEU VENTESAS
           PERFORM LECT-VEU
           PERFORM LECT-VAS
      
           PERFORM UNTIL FF-VEU AND FF-VAS
              
      * GESTION DE LA RUPTURE SUR LA COMMANDE
              IF WS-CLE-COURANTE NOT = WS-CLE-VEU AND 
                 WS-CLE-COURANTE NOT = WS-CLE-VAS AND
                 NOT PREMIERE-LIGNE
                 
                 PERFORM TRAITEMENT-RUPTURE
              END-IF

              EVALUATE TRUE
              WHEN WS-CLE-VEU < WS-CLE-VAS
                 DISPLAY 'VENTE EUROPE UNIQUEMENT:'
                 MOVE WS-CLE-VEU TO WS-CLE-COURANTE
                 PERFORM TRAITER-LIGNE-VEU
              WHEN WS-CLE-VEU > WS-CLE-VAS
                 DISPLAY 'VENTE ASIE UNIQUEMENT:'
                 MOVE WS-CLE-VAS TO WS-CLE-COURANTE
                 PERFORM TRAITER-LIGNE-VAS
              WHEN OTHER
                 DISPLAY 'VENTE EUROPE ET ASIE (MEME CLE):'
                 MOVE WS-CLE-VEU TO WS-CLE-COURANTE
                 PERFORM TRAITER-LIGNE-VEU
                 PERFORM TRAITER-LIGNE-VAS
              END-EVALUATE
           END-PERFORM

      * Traitement de la derniere rupture et mise a jour du dernier client
           PERFORM TRAITEMENT-RUPTURE
           
      * MAJ DU DERNIER CLIENT
           IF WS-CLIENT-PREC > 0 AND WS-CA-CLIENT > 0
              PERFORM MAJ-BALANCE-CLIENT
           END-IF
      
           CLOSE VENTESEU VENTESAS
           
           PERFORM AFFICHER-STATS
           DISPLAY 'FIN PROGRAMME MAJDB'
           GOBACK.

       ABEND-PROG.
           DISPLAY "ANOMALIE GRAVE : "
           DISPLAY "ERREUR SQL : " SQLCODE
           EXEC SQL
               ROLLBACK
           END-EXEC
           MOVE ZERO TO WS-CMD-PRECEDENTE
           COMPUTE WS-CMD-PRECEDENTE = 1 / WS-CMD-PRECEDENTE.
      
       TRAITEMENT-RUPTURE.
           IF NOT PREMIERE-LIGNE
              MOVE WS-CA-TOTAL-CMD TO ED-CA-TOTAL
              DISPLAY 'TOTAL CA COMMANDE ' WS-CMD-PRECEDENTE ' : '
                      ED-CA-TOTAL
              DISPLAY ' '
           END-IF
           MOVE ZERO TO WS-CA-TOTAL-CMD.
      
       TRAITER-LIGNE-VEU.
           PERFORM UNTIL WS-CLE-COURANTE NOT = WS-CLE-VEU OR FF-VEU
              PERFORM TRAITER-DETAIL-VEU
              PERFORM LECT-VEU
           END-PERFORM.

       TRAITER-LIGNE-VAS.
           PERFORM UNTIL WS-CLE-COURANTE NOT = WS-CLE-VAS OR FF-VAS
              PERFORM TRAITER-DETAIL-VAS
              PERFORM LECT-VAS
           END-PERFORM.
           
       TRAITER-DETAIL-VEU.
           SET CMD-DEJA-CREE TO TRUE
           IF PREMIERE-LIGNE OR VEU-NUM-CMD NOT = WS-CMD-PRECEDENTE
              MOVE VEU-NUM-CMD TO WS-CMD-PRECEDENTE
              MOVE ZERO TO WS-CA-TOTAL-CMD
              SET AUTRE-LIGNE TO TRUE
              SET CMD-PAS-CREE TO TRUE
           END-IF
           
           MOVE VEU-NUM-PROD TO WS-PROD-NO
           
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
                   ' QTE=' VEU-QTE ' CA=' ED-CHIFFRE-AFF

           PERFORM MAJ-DB2-VEU
           
           PERFORM GERER-CA-CLIENT-VEU.
      
       TRAITER-DETAIL-VAS.
           SET CMD-DEJA-CREE TO TRUE
           IF PREMIERE-LIGNE OR VAS-NUM-CMD NOT = WS-CMD-PRECEDENTE
              MOVE VAS-NUM-CMD TO WS-CMD-PRECEDENTE
              MOVE ZERO TO WS-CA-TOTAL-CMD
              SET AUTRE-LIGNE TO TRUE
              SET CMD-PAS-CREE TO TRUE
           END-IF
           
           MOVE VAS-NUM-PROD TO WS-PROD-NO
           
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
                   ' QTE=' VAS-QTE ' CA=' ED-CHIFFRE-AFF

           PERFORM MAJ-DB2-VAS

           PERFORM GERER-CA-CLIENT-VAS.

      * ===== NOUVELLES SECTIONS POUR LA MAJ DB2 =====
       MAJ-DB2-VEU.
      * CREATION DE LA COMMANDE SI PREMIERE LIGNE
           IF CMD-PAS-CREE
              PERFORM CREER-COMMANDE-VEU
           END-IF
           
      * CREATION DE L'ITEM
           PERFORM CREER-ITEM-VEU.
           
       MAJ-DB2-VAS.
      * CREATION DE LA COMMANDE SI PREMIERE LIGNE
           IF CMD-PAS-CREE
              PERFORM CREER-COMMANDE-VAS
           END-IF
           
      * CREATION DE L'ITEM
           PERFORM CREER-ITEM-VAS.

       CREER-COMMANDE-VEU.
           MOVE VEU-NUM-CMD TO ORD-O-NO
           MOVE VEU-NUM-EMP TO ORD-S-NO
           MOVE VEU-NUM-CLI TO ORD-C-NO
           MOVE WS-DATE-FORMATTED TO ORD-O-DATE
           
           EXEC SQL
               INSERT INTO API6.ORDERS 
               (O_NO, S_NO, C_NO, O_DATE)
               VALUES (:ORD-O-NO, :ORD-S-NO, :ORD-C-NO, :ORD-O-DATE)
           END-EXEC
           
           EVALUATE SQLCODE
               WHEN ZERO
                   ADD 1 TO WS-NB-ORDERS
                   SET CMD-DEJA-CREE TO TRUE
               WHEN -803
                   SET CMD-DEJA-CREE TO TRUE
               WHEN OTHER
                   PERFORM ABEND-PROG
           END-EVALUATE.

       CREER-COMMANDE-VAS.
           MOVE VAS-NUM-CMD TO ORD-O-NO
           MOVE VAS-NUM-EMP TO ORD-S-NO
           MOVE VAS-NUM-CLI TO ORD-C-NO
           MOVE WS-DATE-FORMATTED TO ORD-O-DATE
           
           EXEC SQL
               INSERT INTO API6.ORDERS 
               (O_NO, S_NO, C_NO, O_DATE)
               VALUES (:ORD-O-NO, :ORD-S-NO, :ORD-C-NO, :ORD-O-DATE)
           END-EXEC
           
           EVALUATE SQLCODE
               WHEN ZERO
                   ADD 1 TO WS-NB-ORDERS
                   SET CMD-DEJA-CREE TO TRUE
               WHEN -803
                   SET CMD-DEJA-CREE TO TRUE
               WHEN OTHER
                   PERFORM ABEND-PROG
           END-EVALUATE.

       CREER-ITEM-VEU.
           MOVE VEU-NUM-CMD TO ITEM-O-NO
           MOVE VEU-NUM-PROD TO ITEM-P-NO
           MOVE VEU-QTE TO ITEM-QUANTITY
           MOVE WS-PRIX-FINAL TO ITEM-PRICE
           
           EXEC SQL
               INSERT INTO API6.ITEMS 
               (O_NO, P_NO, QUANTITY, PRICE)
               VALUES (:ITEM-O-NO, :ITEM-P-NO, 
                       :ITEM-QUANTITY, :ITEM-PRICE)
           END-EXEC
           
           EVALUATE SQLCODE
               WHEN ZERO
                   ADD 1 TO WS-NB-ITEMS
               WHEN OTHER
                   PERFORM ABEND-PROG
           END-EVALUATE.

       CREER-ITEM-VAS.
           MOVE VAS-NUM-CMD TO ITEM-O-NO
           MOVE VAS-NUM-PROD TO ITEM-P-NO
           MOVE VAS-QTE TO ITEM-QUANTITY
           MOVE WS-PRIX-FINAL TO ITEM-PRICE
           
           EXEC SQL
               INSERT INTO API6.ITEMS 
               (O_NO, P_NO, QUANTITY, PRICE)
               VALUES (:ITEM-O-NO, :ITEM-P-NO, 
                       :ITEM-QUANTITY, :ITEM-PRICE)
           END-EXEC
           
           EVALUATE SQLCODE
               WHEN ZERO
                   ADD 1 TO WS-NB-ITEMS
               WHEN OTHER
                   PERFORM ABEND-PROG
           END-EVALUATE.

       GERER-CA-CLIENT-VEU.
           IF VEU-NUM-CLI NOT = WS-CLIENT-PREC AND WS-CLIENT-PREC > 0
              PERFORM MAJ-BALANCE-CLIENT
              MOVE ZERO TO WS-CA-CLIENT
           END-IF
           
           MOVE VEU-NUM-CLI TO WS-CLIENT-PREC
           ADD WS-CHIFFRE-AFF TO WS-CA-CLIENT.

       GERER-CA-CLIENT-VAS.
           IF VAS-NUM-CLI NOT = WS-CLIENT-PREC AND WS-CLIENT-PREC > 0
              PERFORM MAJ-BALANCE-CLIENT
              MOVE ZERO TO WS-CA-CLIENT
           END-IF
           
           MOVE VAS-NUM-CLI TO WS-CLIENT-PREC
           ADD WS-CHIFFRE-AFF TO WS-CA-CLIENT.

       MAJ-BALANCE-CLIENT.
           MOVE WS-CLIENT-PREC TO CUST-C-NO
           
           EXEC SQL
               UPDATE API6.CUSTOMERS 
               SET BALANCE = BALANCE + :WS-CA-CLIENT
               WHERE C_NO = :CUST-C-NO
           END-EXEC
           
           EVALUATE SQLCODE
               WHEN ZERO
                   ADD 1 TO WS-NB-CLIENTS-MAJ
               WHEN +100
                   CONTINUE
               WHEN OTHER
                   PERFORM ABEND-PROG
           END-EVALUATE.

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

       AFFICHER-STATS.
           DISPLAY ' '
           DISPLAY 'STATISTIQUES DE TRAITEMENT :'
           DISPLAY '============================'
           DISPLAY 'COMMANDES CREEES     : ' WS-NB-ORDERS
           DISPLAY 'ITEMS CREES          : ' WS-NB-ITEMS  
           DISPLAY 'CLIENTS MISE A JOUR  : ' WS-NB-CLIENTS-MAJ
           DISPLAY ' '.