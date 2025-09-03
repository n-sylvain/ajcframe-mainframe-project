## PARTIE 2 : Import des ventes

### Objectifs
- Importer 2 fichiers : `PROJET.VENTESEU.DATA` et `PROJET.VENTESAS.DATA`
- Alimenter les différentes tables de la base de données
- Calculer et mettre à jour la balance (chiffre d'affaires) des clients

### Tables à alimenter
- **orders** - Commandes
- **items** puis **products** - Articles
- **customers** - Clients (calcul balance)
- **employees/depts** - Employés/départements (vérifier si MAJ nécessaire)

### Processus technique
- Beaucoup d'instructions `INSERT INTO`
- Calcul de la balance avec `GROUP BY CUSTOMER`
- Vérifier l'existence des bases avant insertion
- Vérifier les taux de conversion à utiliser

### Tests
- Vérifier la bonne entrée d'info pour chacune des bases
- Contrôle des doublons
- Validation des calculs de balance



COBOL TP10 - SYNCHRO

ETAPE1 : afficher les données consolidées de VentesEU et VENTESAS en utilisant la notion de synchro (exercice de référence)
ETAPE2 : afficher en display en sysout pour chaque vente les informations qui vont être updaté et dans quelles bases.
ETAPE3 : màj les bases mais on va pour le moment essayer qu'une seule base (la base ORDERS) et si ça fonctionne, on fera les autres bases



je travaille sur ce projet pour ma soutenance. J'ai besoin:

ajouter un readme ajouter un diagramme mermaid ajouter des éléments pour la présentation faire une démo en live décrire le processus de réalisation du code faire une liste des notions faire la liste des challenges ne pas oublier de faire des screenshots
décrire le code, la logique, les différents paragraphes avec assez de précision.

Je te joins :
* le programme MAJDB, son JCL, le DCLGEN
* les requetes SQL
* mon transcript de présentation

  --   Pour les parties 1, 2, 3
 --   remet à l'origine les tables
                                                     
      DELETE FROM API6.ITEMS 
      WHERE O_NO IN (500, 501, 502, 503, 504, 505); 
                                                     
      DELETE FROM API6.ORDERS 
      WHERE O_NO IN (500, 501, 502, 503, 504, 505); 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 1500.00 
      WHERE C_NO = 1; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 2500.50 
      WHERE C_NO = 2; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 1800.75 
      WHERE C_NO = 3; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 3200.25 
      WHERE C_NO = 4; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 2000.00 
      WHERE C_NO = 5; 
                                                     
      COMMIT; 


.
(base) sylvain.ni@Mac partie-2 % tree
.
├── DATA
│   ├── VENTESAS.txt
│   └── VENTESEU.txt
├── DB2
│   └── MAJDB.cbl
├── DCLGEN
│   ├── CUST.cbl
│   ├── ITEM.cbl
│   ├── ORD.cbl
│   └── PROD.cbl
├── JCL
│   └── JMAJDB.jcl
├── PARTIE 2.md
├── SQL
│   └── RAZ_partie 2.sql


VENTESAS
50115/10/2022200003P020154910
50115/10/2022200003P030357502
50202/11/2022300002P050502507
50305/11/2022500001P15     10
50517/11/2022400004P10     01
50517/11/2022400004P12     04

VENTESEU
50010/10/2022100004P010259903
50010/10/2022100004P030357502
50010/10/2022100004P040100005
50202/11/2022300002P020154903
50202/11/2022300002P030357505
50305/11/2022500001P11     05
50407/11/2022400003P14     01
50407/11/2022400003P18     04




MAJDB:
"       IDENTIFICATION DIVISION.
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
           DISPLAY ' '."

DCLGEN:
"       ******************************************************************
      * DCLGEN TABLE(API6.CUSTOMERS)                                   *
      *        LIBRARY(API6.SOURCE.DCLGEN(CUST))                       *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(CUST-)                                            *
      *        STRUCTURE(ST-CUST)                                      *
      *        QUOTE                                                   *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE API6.CUSTOMERS TABLE
           ( C_NO                           DECIMAL(4, 0) NOT NULL,
             COMPANY                        VARCHAR(30) NOT NULL,
             ADDRESS                        VARCHAR(100),
             CITY                           VARCHAR(20) NOT NULL,
             STATE                          CHAR(2) NOT NULL,
             ZIP                            CHAR(5) NOT NULL,
             PHONE                          CHAR(10),
             BALANCE                        DECIMAL(10, 2)
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE API6.CUSTOMERS                     *
      ******************************************************************
       01  ST-CUST.
      *                       C_NO
           10 CUST-C-NO            PIC S9(4)V USAGE COMP-3.
           10 CUST-COMPANY.
      *                       COMPANY LENGTH
              49 CUST-COMPANY-LEN  PIC S9(4) USAGE COMP.
      *                       COMPANY
              49 CUST-COMPANY-TEXT  PIC X(30).
           10 CUST-ADDRESS.
      *                       ADDRESS LENGTH
              49 CUST-ADDRESS-LEN  PIC S9(4) USAGE COMP.
      *                       ADDRESS
              49 CUST-ADDRESS-TEXT  PIC X(100).
           10 CUST-CITY.
      *                       CITY LENGTH
              49 CUST-CITY-LEN     PIC S9(4) USAGE COMP.
      *                       CITY
              49 CUST-CITY-TEXT    PIC X(20).
      *                       STATE
           10 CUST-STATE           PIC X(2).
      *                       ZIP
           10 CUST-ZIP             PIC X(5).
      *                       PHONE
           10 CUST-PHONE           PIC X(10).
      *                       BALANCE
           10 CUST-BALANCE         PIC S9(8)V9(2) USAGE COMP-3.
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  ICUSTOMERS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 8 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 8       *
      ******************************************************************

      ******************************************************************
      * DCLGEN TABLE(API6.ITEMS)                                       *
      *        LIBRARY(API6.SOURCE.DCLGEN(ITEM))                       *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(ITEM-)                                            *
      *        STRUCTURE(ST-ITEM)                                      *
      *        QUOTE                                                   *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE API6.ITEMS TABLE
           ( O_NO                           DECIMAL(3, 0) NOT NULL,
             P_NO                           CHAR(3) NOT NULL,
             QUANTITY                       DECIMAL(2, 0) NOT NULL,
             PRICE                          DECIMAL(5, 2) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE API6.ITEMS                         *
      ******************************************************************
       01  ST-ITEM.
      *                       O_NO
           10 ITEM-O-NO            PIC S9(3)V USAGE COMP-3.
      *                       P_NO
           10 ITEM-P-NO            PIC X(3).
      *                       QUANTITY
           10 ITEM-QUANTITY        PIC S9(2)V USAGE COMP-3.
      *                       PRICE
           10 ITEM-PRICE           PIC S9(3)V9(2) USAGE COMP-3.
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  IITEMS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 4 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 4       *
      ******************************************************************

      ******************************************************************
      * DCLGEN TABLE(API6.ORDERS)                                      *
      *        LIBRARY(API6.SOURCE.DCLGEN(ORD))                        *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(ORD-)                                             *
      *        STRUCTURE(ST-ORD)                                       *
      *        QUOTE                                                   *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE API6.ORDERS TABLE
           ( O_NO                           DECIMAL(3, 0) NOT NULL,
             S_NO                           DECIMAL(2, 0) NOT NULL,
             C_NO                           DECIMAL(4, 0) NOT NULL,
             O_DATE                         DATE NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE API6.ORDERS                        *
      ******************************************************************
       01  ST-ORD.
      *                       O_NO
           10 ORD-O-NO             PIC S9(3)V USAGE COMP-3.
      *                       S_NO
           10 ORD-S-NO             PIC S9(2)V USAGE COMP-3.
      *                       C_NO
           10 ORD-C-NO             PIC S9(4)V USAGE COMP-3.
      *                       O_DATE
           10 ORD-O-DATE           PIC X(10).
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  IORDERS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 4 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 4       *
      ******************************************************************

      ******************************************************************
      * DCLGEN TABLE(API6.PRODUCTS)                                    *
      *        LIBRARY(API6.SOURCE.DCLGEN(PROD))                       *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(PROD-)                                            *
      *        STRUCTURE(ST-PROD)                                      *
      *        QUOTE                                                   *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE API6.PRODUCTS TABLE
           ( P_NO                           CHAR(3) NOT NULL,
             DESCRIPTION                    VARCHAR(30) NOT NULL,
             PRICE                          DECIMAL(5, 2) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE API6.PRODUCTS                      *
      ******************************************************************
       01  ST-PROD.
      *                       P_NO
           10 PROD-P-NO            PIC X(3).
           10 PROD-DESCRIPTION.
      *                       DESCRIPTION LENGTH
              49 PROD-DESCRIPTION-LEN  PIC S9(4) USAGE COMP.
      *                       DESCRIPTION
              49 PROD-DESCRIPTION-TEXT  PIC X(30).
      *                       PRICE
           10 PROD-PRICE           PIC S9(3)V9(2) USAGE COMP-3.
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  IPRODUCTS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 3 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 3       *
      ******************************************************************

"

JCL:
//API6ET1D JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H,
//           TIME=(0,30),MSGLEVEL=(1,1)
//***********************************************************
//*  ====> COMPILATION ET EXECUTION    MAJDB AVEC DB2        *
//***********************************************************
//PROCLIB  JCLLIB ORDER=SDJ.FORM.PROCLIB
//*
//         SET SYSUID=API6,
//             NOMPGM=MAJDB
//*
//*--- ETAPE DE COMPILATION DB2/COBOL --------------------
//*
//COMPIL   EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=&SYSUID..SOURCE.DCLGEN,DISP=SHR
//                 DD DSN=CEE.SCEESAMP,DISP=SHR
//STEPDB2.SYSIN    DD DSN=&SYSUID..SOURCE.DB2(&NOMPGM),DISP=SHR
//STEPDB2.DBRMLIB  DD DSN=&SYSUID..SOURCE.DBRMLIB(&NOMPGM),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=&SYSUID..SOURCE.PGMLIB(&NOMPGM),DISP=SHR
//*
//*--- ETAPE DE BIND --------------------------------------
//*
//BIND     EXEC PGM=IKJEFT01,COND=(4,LT)
//DBRMLIB  DD  DSN=&SYSUID..SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (MAJDB) -
       QUALIFIER (API6)    -
       ACTION    (REPLACE) -
       MEMBER    (MAJDB)  -
       VALIDATE  (BIND)    -
       ISOLATION (CS)      -
       ACQUIRE   (USE)     -
       RELEASE   (COMMIT)  -
       EXPLAIN   (NO)
/*
//**************************************************************
//* EXECUTION *
//**************************************************************
//STEPRUN EXEC PGM=IKJEFT01,COND=(4,LT)
//STEPLIB DD DSN=&SYSUID..SOURCE.PGMLIB,DISP=SHR
//VENTESEU DD DSN=API6.PROJET.VENTESEU.DATA,DISP=SHR
//VENTESAS DD DSN=API6.PROJET.VENTESAS.DATA,DISP=SHR
//SYSTSPRT DD SYSOUT=*,OUTLIM=2500
//SYSOUT DD SYSOUT=*,OUTLIM=1000
//SYSTSIN DD *
 DSN SYSTEM (DSN1)
 RUN PROGRAM(MAJDB) PLAN(MAJDB)
/*
"



mon transcript:
"Meeting Title: Mise à jour du projet - synchronisation des données et préparation de la présentation
Date: Aug 29

Transcript:
Me: donc voilà. Je parle aussi de la présentation Parce qu'en fait j'ai fini la partie un et j'ai fini la partie deux. Donc là je suis en train de de prendre enfin de de réunir tous les éléments que je peux mettre dans le cadre de la Donc et  
Them: Okay.  
Me: Donc et en fait je pense que pour la présentation vu qu'on a encore lundi mardi avant l'oral mercredi, et que vous comptez être en ligne le week-end, enfin voilà si vous vous arrivez, vous terminez vous terminez le la partie code et que vous voulez vous mettre sur la présentation, comme ça vous pouvez on, vous pouvez vous mettre sur la présentation et nous on pourra nous tous en fait on pourra avoir travaillé sur le même fichier, on pourra travailler sur le même fichier de présentation. Comme ça lundi, mardi on n'a on n'aura pas besoin de s'envoyer des emails avec des fichiers différents, avec des versions où il faudra consolider. Ça ça vous convient  
Them: Okay. Ouais. Ouais très bien parfait.  
Me: Alors à mon tour, vais vous présenter deux parties comment je donc voilà pour la présentation en tout cas pour le PowerPoint, je propose ça Vous en pensez quoi Ça ça vous convient  
Them: Nickel. Surtout qu'on est tous connectés dessus là, fait on peut a priori on peut tous faire des modifications de dire  
Me: Ça vous va Ok. Je pense qu'en fait que PowerPoint c'est  
Them: donc c'est parfait.  
Me: y a des fonctionnalités plus avancées en termes de présentation que Google Google diapo je ne sais pas comment il s'appelle Google slide. J'ai aussi mis le lien de présentation dans le guide Hub. Vais l'ajouter, j'ai le commit. Julien Julien office online, voilà je fais pull, Si vous êtes survé à ce que je vous conseille de faire un push pull, pull push comme vous voulez, et je vais je vais vous présenter qu'est-ce que je vous présente Okay.  
Them: What?  
Me: vous voyez ma fenêtre Qu'est-ce qu'on fait On fait la partie un. La partie un c'était la partie un devant, ouais.  
Them: Comment mettre rajouter les produits, les nouveaux produits new products  
Me: Oui.  
Them: fallait les rajouter à la base de données.  
Me: Votre objectif sera de traiter ce fichier et d'insérer les données des nouveaux produits au sein de la base base de données. Donc il y a, on a un fichier c a z qui est dans dataset projet, projet et et on a j'ai créé aussi un fichier top donc pour pouvoir également avoir les les taux. Ça je vais vous montrer, on va vérifier déjà vite fait que bien présent. Je fais comme si on était en live. C'était le fichier new prod Donc c'est le fichier c s v avec chacun des champs séparés par un point virgule. Il faudra formater la description du produit et également calculer le prix en dollars. On a les taux sont des fichiers séquentiels. On a les taux dans un autre fichier point data où j'ai mis des exemples de taux euros u n y a q, w n c'est le c'est la monnaie coréenne, et y n c'est le yen c'est le c'est le Japon.  
Them: Sud-Coréen,  
Me: J'ai, j'ai, ouais,  
Them: pas mal  
Me: Corée qu'on pense. Mais c'est, j'ai fait ça parce qu'en fait le Won un euro c'est à peu près mille-deux-cent, mille-trois-cent Won. Donc je me suis dit qu'on allait un petit peu sur le Edge case, voilà donc avec beaucoup de zéros, c'était ça qui m'intéressait, c'était parce que quand c'est un dix, c'est facile, mais quand tu as plus de décimales c'est avec les limitations de cow-bol c'était c'était plus intéressant à travailler dessus. Ok, non.  
Them: comment il fait une, le prof nous a dit que, enfin hier quand je vais parler, a dit que les virgules en fait de cobalt, ne sait pas ce c'est. C'est, mais ça me semble  
Me: Oui en fait c'est les les virgules les virgules en fait c'est quand tu mets un v c'est une virgule virtuelle. Donc il va calculer à partir de ça. Et quand tu mets une virgule dans la  
Them: Which?  
Me: vérifies une virgule, en fait c'est c'est l'affichage.  
Them: Deco.  
Me: Le v limite la position de la v a deux. Mais c'est ça, c'est ça Après je ne connais pas dans les détails. Alors dans la partie un, qu'est-ce qu'il faut s'assurer Il faut s'assurer que, ah oui il que je m'assure parce qu'on va travailler sur la table  
Them: C'est pour une question.  
Me: Donc je vais m'assurer que la table products elle est bien clean et bien sûr je mets tout ça en commentaire Je fais comme si on était tout début du projet, pardon désolé, je ne sais pas préparé. Ok. Donc là j'ai fait une requête SQL qui permet de tous les produits supérieurs à p zéro sept. Ça correspond en fait à tous les produits CSV ici. Dix, p onze, p douze. Et vous allez comprendre pourquoi je parle pourquoi c'est important. Dans il y a un programme principal d b dans le dossier d b deux qui s'appelle mise à jour prod qui va prendre les fichiers new prod et tôt Cette ce programme il va d'abord mettre les tours en Mémoire comme ça il n'y qu'une seule ouverture et fermeture du fichier taux et après il va lire chacune des lignes du fichier c s v ligne par ligne et dans ma démarche en fait avant de l'ordre. L'intégrer en base, j'ai j'ai fait, je me suis déjà assuré que je pouvais afficher tous les toutes les informations correctement du fichier c s v, donc produit, description, prix d'origine, et caetera. Description, il y a un paragraphe qui permet de le mettre en forme, Les et ici et en fait bon vous vous en doutez c'est c'est chaque GPT qui m'a proposé l'algorithme en gros il est tout en minuscule et ensuite chacun des mots regarde  
Them: And then  
Me: il met en majuscule première lettre du mot. Et il n'y avait pas de fonction trim de fonction title case donc il a fallu recoder en fait la fonction. Il n'y avait pas de fonction natif en fait, donc il a fallu le le recoder. Donc le après avoir formaté le prix, le la description pardon, c'est le prix c'est le taux pardon, Donc le taux en fait il va le chercher dans donc en mémoire. Et ensuite il affiche en fait toutes les informations. Après il insère les produits dans la base dans d b deux. Donc avant en fait de de coder en d b deux, de coder tout ce qui est des d b deux, donc on a la requête s q l, mais il faut aussi générer le d c l gène pour la table correspondante. Donc qui est dans le dossier d c l g. Et la générer, la générer. En quoi ça présente chaque fois qu'il y a, chaque fois qu'on interagit avec les b deux, il faut qu'il ait le décès  
Them: Comment ça la gérer c'est la gérer comment Ça l'est généré. Au fait, Oui donc en fait tiens  
Me: n correspondant.  
Them: donc en fait il me suffit juste d'aller sur des cellules gènes et de faire de faire correspondre comme on avait dit un prod à la table product par exemple.  
Me: C'est ça. Ensuite il y a  
Them: Mettant le chiffre  
Me: logiciel correspondant qui est qui est repris du cours en fait donc l'indé et d'exécuter. Donc là j'ai toutes les tables je vais vous montrer aussi vite fait l'interface QMF. Permet de d'afficher des tables. Owner a p I c Et la table qui nous intéresse est produit Donc ici on voit qu'il a p zéro un, zéro sept, et je l'ai pris en screenshot et tous les screenshots je les ai mis dans présentation produit est là donc là je vais ah, neuf, douze, f trois, Je vais rener relancer mon logiciel de mise à jour de produit. Donc j'ai un c sept quatre mais normalement ça a dû fonctionner. Vais dans mon q m f  
Them: Okay. So  
Me: ces produits qui m'intéressent produit c'est display et là on constate que les produits  
Them: Cent dollars.  
Me: été ajoutés. Donc de quel produit parle-t-on de dans data du prod donc juste on en prend un au hasard p zéro six a c'est intéressant ça. P zéro six il y a des a des produits qui dans le fichier new prod ça je n'avais pas vu  
Them: Okay. Tu es sûr, ce n'est pas dix-sept. Et dix-sept.  
Me: Ouais c'est peut-être ça, attends, c'est peut-être  
Them: Je vais aller voir sur  
Me: c'est  
Them: énoncé, enfin sur, agissez,  
Me: à mon avis ce n'est pas ce n'est pas une erreur c'est plus le le prof qui a  
Them: No.  
Me: qui a certainement dû chez expert  
Them: la sexta. Mais au fait ça j'ai bien  
Me: Donc dans ce cas-là qu'est-ce qu'est-ce qu'est-ce qu'est-ce qui me qu'on le, est-ce qu'on le prend et on le met à jour ou est-ce, ah attend attend attend Non c'est c'est c'est peut-être une erreur attend.  
Them: Parfait je viens de voir  
Me: Dix onze douze treize treize quatre quatre  
Them: ouais mais je viens de voir dans le  
Me: treize, quatre,  
Them: le projet de soutenance de la j c, c'est bien zéro six et zéro sept, ce n'est pas pas une erreur de quand on a copié.  
Me: Parce que mon code du coup alors  
Them: Ça veut dire que le profil il veut qu'on affiche qu'il y un conflit peut-être Ah c'est pour, ce n'est pas pour ça qu'il avait dit hier qu'il fallait le faire indexé. Mode indexé.  
Me: non en fait l'indexation c'est par rapport à c'est par rapport au taux que je fasse un fichier indexé et la raison pour laquelle je n'ai pas fait le fichier indexé, c'est parce que je n'y arrivais pas. Et pas, il fallait reprendre la logique notamment pour les virgules pour les décimales et je je n'avais pas le temps. Donc prenons prenons l'enregistrement  
Them: Good.  
Me: Voilà ça c'est ma. Ici c'est écrit produit p zéro six déjà existant. Donc on peut faire le choix soit de dire que le produit existe déjà et déjà donc pas. Ou bien on peut faire le choix de dix  
Them: Niveler des deux  
Me: c'est le p zéro six desktop computer.  
Them: C'est dans Et dans le dans le l'original en fait on a quoi  
Me: L'original c'est projet table table produit. C'est ça.  
Them: Yeah. See, pick external hard drive et ici c'est desktop computer. À le même prix.  
Me: Je pense que quand un produit existe déjà, il il ne faut pas il ne faut pas l'écraser,  
Them: Pas les mêmes prix, donc ce n'est pas un spectre  
Me: faut pas le mettre à jour parce que ça va impacter potentiellement des d'autres factures. Vous voyez ce que je veux dire  
Them: ça a l'air d'être deux nouveaux produits.  
Me: Ce sont des nouveaux produits, ouais. Donc je pense que le le programme vu qu'il détecte les, c'est mieux de laisser comme il est. Mais tu vois ici j'ai une cise out donc qui me qui me fait le récapitulatif de tout ce qu'il y Donc pour chacun des enregistrements, il m'indique la ligne brute, devise, ce qu'il a, ce qu'il voit et aussi s'il la sert ou pas. Pour par exemple si  
Them: Parce que dans l'effet en fait il a écrasé non.  
Me: Non il n'a pas écrasé.  
Them: Ton résultat  
Me: Il n'a pas écrasé parce que parce que quand tu regardes la table de produit, il manque les p zéro p c s tout ça. Quand tu prends p zéro six, toujours le même que qu'avant.  
Them: Il n'a pas mis seize et dix-sept, d'accord.  
Me: Donc je vais poser la question à Steve pour voir si c'est  
Them: Et si on on si on les modifiait en fait et qu'on les qu'on les attend en fait il faudrait peut-être vérifier si dans les  
Me: That's it.  
Them: qu'on vérifie si, ah non, parce qu'on s'en fiche, parce que les factures qui ont été éditées elles elles utilisaient des ordres que eux-mêmes ont passé. Donc en fait on n'utilise pas les nouveaux produits.  
Me: Donc  
Them: Donc ça pas les factures, donc ça c'est c'est la bonne nouvelle.  
Me: donc voilà ça c'est la partie On peut ajouter d'autres taux dans le fichier taux, qui est qui est ici J'ai j'ai pris des screenshots pour la présentation. Donc je pense que pour la partie une ça va. Est-ce que ça vous va vous avez des questions en particulier des commentaires,  
Them: Non.  
Me: Non ça va ça vous ça vous plaît un petit comment  
Them: New York  
Me: Cool.  
Them: Mais il y a il y mon pizza aussi, il se met à déconner quoi. Il y un problème, dès qu'il y a une histoire de vidéo, j'ai l'impression qu'il se met en veille des fois, alors que j'ai débloqué la veille, le la mise en veille. Bon, c'est bon.  
Me: D'accord. Alors maintenant je continue sur la partie deux. La partie deux l'histoire c'est que on a deux fichiers vente e u data, vente a s data. Qui ont ce format là. Et ce qu'il faut faire c'est faire une synchronisation chacun des deux Je vais mettre comme ça comme ça on peut voir, Une synchronisation des des deux fichiers, Par synchronisation en fait il faut calcul, il faut prendre les informations de de de de des deux fichiers mettre à jour les bases. Et dans les bases à mettre à jour, alors attends, je vais mettre dans partie deux, Dans les dans les tables, mettre en fait la le principe enjeu dans dans la partie deux c'est la mise à jour des bases, Mais en fait avant d'arriver à la mise à jour des bases, je fais comme dans la partie un, c'est j'ai déjà procédé par étapes. La première étape c'est déjà pouvoir afficher les informations des déficier et ensuite de pouvoir m'assurer que les informations qui sont récupérées des fichiers soient bien dans le bon format avant de les intégrer en base. Donc qu'est-ce que ça veut dire Donc dans dans les deux fichiers on a ces informations et ceux qui demandaient en fait par exemple on a des informations ici sur la date de la commande, il fallait s'assurer que le format de la date soit corresponde à celui qui est en base. Le format de la date ça m'a donné un petit peu de de fil à retordre donc est pris en compte, je le prends en compte dans mon dans mon programme. N'est pas là, qui est qui est ici. Je ne l'ai pas. Les agents d'API. Bon, je vais vous montrer vite fait, ne vais pas retourner dans le q m f, mais les tables customer département employé, item, order, ça ce sont les tables à l'origine il y avait également et en fait j'ai repris l'exercice de synchronisation qui permettait de et comme les deux fichiers sont triés par par numéro de commande, en fait le fichier à l'élire à les lire par numéro va aller se baser sur le numéro de commande pour pour calculer en fait la balance totale par commande et ensuite l'intégrer à la balance du client. Je vais vous montrer. Je vais vous montrer ici Les agents j'inclure les lichérants d s s gènes des tables qui vont être mises à jour. Des variables dates ici en fait pour m'assurer que le formatage soit correct et le formatage en fait de en base c'est l'année puis le mois puis le jour que dans le fichier vente, est indiqué en string jour, mois, année. Donc ça, c'est pris en compte dans le code. Le code Et en je vous, vous allez comprendre,  
Them: Se ficher la t v two.  
Me: la Alors là, celle à gauche, la partie deux, l'énoncé de la partie deux et à droite, c'est mise à jour d b, c'est le programme principe principal qui permet de mettre à jour en fait les différentes bases en fonction des ventes. Je je vais l'exécuter, va voir la ciseaux, vous allez, ce sera peut-être certainement plus clair. Donc je fais mis, mise à jour d b, Je fais J'ai un accès J'ai un accès c d r, ce qui est très cool. Je vais dans statut et je vais dans la. Je vais en profiter aussi pour faire mes screenshots Donc, attendez, je je vais déjà faire tous mes screenshots, c'est bien, il en a pas trop. Donc si on prend  
Them: It's  
Me: ça je mettra à droite L'algorithme parcourir à chacune des commandes Donc la commande ici c'est cinq cents. Cinq-cents, cinq-cents, cinq-cents, il récupère le prix qui est affiché, qui est renseigné dans les ventes. Quantité, en fait c'est le programme qui calcule le chiffre d'affaires. Donc ici compute trois fois vingt-cinq virgule quatre-vingt-dix-neuf. Il revêt la même chose sur la commande suivante. Avec l'information des prix qui est également ici. Remarque que pour certaines commandes le prix n'est pas présent. Donc ça on va y venir. Ensuite à la fin, dès qu'il voit qu'il voit une rupture, il fait le total de du chiffre d'affaires pour toute la commande. Donc ici, la première commande, ce sera cent-quatre-vingt-dix-neuf virgule quarante-sept. Dans le cas où tu as des commandes sur les deux fichiers, la commande cinq-cent-deux, pareil dès qu'il voit qu'il est dans les deux fichiers, donc il le prend bien en compte. Cinquante-deux je vois que attends, je vois un petit bug ici, totale commande cinq-cent-deux, il le fait comme ça. Je me demande si non non ça ça c'est correct c'est correct. En fait il fait d'abord le fichier vente e u puis ensuite vente asie. J'ai fait le total alors là c'est plus problème d'affichage que c'est plus de l'affichage chose, mais ça n'a pas d'impact sur la mise à jour des d b. C'est, il a considéré que ça, c'est toute la commande et qu'il y une deuxième commande, mais je modifie mon code pour qu'il n'y ait qu'une seule commande ici qui affiche le total sur les deux je dirais sur les deux zones géographiques. Dans le cas t'aller produire dont le prix est manquant par exemple p onze, il récupère en fait, il y une fonction qui récupère le prix dans la base product. Et p onze en fait si vous vous souvenez en fait un nouveau produit qui a été ajouté en base. Donc c'est pour ça qu'on disait que la partie deux avait un lien avec la partie une et qu'on l'avait plus ou moins  
Them: D'ailleurs ça me fait penser au fait que si  
Me: mis ensemble.  
Them: en fait si le dans l'énoncé c'est p seize, p dix-sept, dans le et dans le c s v c'est juste une erreur et en fait il faudra la corriger.  
Me: -être, mais en fait là où il y des erreurs, je pense que c'est fait exprès, poser la question à Steve, ce n'est pas réutilisé en fait dans la partie de deux. Je pense que ce n'est pas pour nous pénaliser pour qu'on enfin pour pas que ça  
Them: Jamais la partie  
Me: ait trop d'impact. Mais en fait le fait de voir qu'il y a  
Them: partie  
Me: des typos dans le CSG, je pense que ce n'est pas ce n'est pas anodin, c'est voulu. Donc chaque fois en fait, dans mon algorithme, il voit qu'il n'y a pas de prix, il va le chercher en base. Ensuite il calcule le total de la commande dans le code en fait il prend ces informations-là, les mettre à jour ensuite dans dans les différentes bases. Donc par exemple, à la fin, il a un statistique de traitement qui dit qu'il a créé six commandes Ces six commandes, elles sont importantes parce qu'elles vont être à ce sont des commandes en plus qui vont être générées dans les factures. La partie trois. Donc dans la partie trois en fait on a je crois trois factures à l'origine quand je testais le programme, mais là comme en base ajouté des commandes supplémentaires, il y aura plus de factures qui vont être générées. Les items qui ont été créés  
Them: Il y aura les il y a l'extract aussi qui doit changer.  
Me: Oui c'est ça. Donc les factures il faut il faut refaire l'extract. Je l'ai testé hier ça ça fonctionne Donc les différentes tables qui ont été misées, et et les tables qui ont été mises à chaud. Donc on peut prendre je pense, ah faire juste une vérification Je je vérifie quelque chose. Table costumer, Justement j'ai oublié de prendre screenshot la balance C'est ballot, mais ce n'est pas grave. Et par exemple, customer, le customer b c avait mille cinq cents. Et ici c'est le client quatre et si je prends par exemple client un est-ce qu'il y a client quatre trois deux Donc il y a il a mille-cinq-cent mille-cinq-cent plus cent-cinquante-deux cinquante plus huit-cent-deux cinquante. On s'attendra, on s'attend à deux mille quatre cent soixante-cinq sur sa balance. On vérifier ça. Deux-mille-quatre-cent-soixante-cinq. Si je vais dans 2.1 q m f f deux, la a p six customer On voit que la balance n'est pas la bonne. Ok. Donc ça je vais investiguer mais on voit que la, on voit que la balance a changé.  
Them: Des conversions peut-être. Un problème de conversion peut-être.  
Me: Alors attends. Je pense que c'est parce C'est parce que la balance elle était sur les ventes sur les deux zones géographiques. J'ai l'impression qu'il a bien pris en compte mais qu'il manque qu'il en manque qui manque juste une des, donc attends, vais regarder Ici six cent soixante et À cinquante-deux à cinquante-deux cinquante. Je sais pas Que c'est pas plus de commandes pour le client un. C'est ou est-ce que c'est un deux Un, deux, trois, quatre, cinq, okay  
Them: On va aussi bien Sylvain nous on te laisse  
Me: see. What  
Them: Ouais.  
Me: vous ai montré  
Them: Dois aussi penser sur l'autre.  
Me: c'est le, c'est la partie deux, j'ai aussi aussi des petits bugs. Donc voilà. Je laisse avancer. À tout à l'heure.  
Them: Parce que moi aussi j'ai j'ai des bugs et je je pense que si je veux mettre un peu plus que la demi-journée.  
Me: C'est un peu frustrant, pensais que c'était que c'était bon de mon côté.  
Them: Bon,  
Me: Mais merci voilà c'est c'est déjà tout ça. Et puis on se recapte tout à l'heure. D'accord D'accord Allez, merci beaucoup, à plus tard.  
Them: Yeah.  
Me: Je préfère vérifier la balance. Yeah. "

l'énoncé du projet:
La société AJCFRAME reçoit 2 fichiers qui recensent les ventes réalisées par des 
prestataires localisés en Europe et en Asie. Elle aimerait importer ces ventes en base. 
Ces ventes devront non seulement être ajoutées en base mais vous augmenterez 
également le Chiffre d'affaires (balance) de chaque client en fonction des ventes 
réalisées à l'étranger.
A vous de proposer une solution en vue de réaliser cet objectif.
Les 2 fichiers ont exactement la même structure.
Voici la description des 2 fichiers : 
PROJET.VENTESEU.DATA ET PROJET.VENTESAS.DATA
DE A LG TYPE NOM OBSERVATIONS
1 3 3 N N° COMMANDE
4 13 10 A DATE COMMANDE JJ/MM/AAAA
14 15 2 N N° EMPLOYE
16 19 4 N N° CLIENT
20 22 3 A N° PRODUIT
23 27 5 N PRIX 5 DONT 2 DECIMALES
28 29 2 N QUANTITE COMMANDEE
30 35 6 A RESERVE
Trié sur :
• le N° de Commande
• le N° de Client
• le N° d'employé
Ces fichiers ont été constitués de telle sorte à ce qu'il n'y ait au sein d'une même 
commande :
• pas de doublon sur le n° de produit
• qu'un seul employé par commande
• qu'une seule date par commande
• qu’un seul client par commande
Voici les jeux de données : 
PROJET.VENTESAS.DATA
O_NO O_DATE S_NO C_NO P_NO PRICE QUANTITY RESERVE
501 15/10/2022 20 0003 P02 01549 10
501 15/10/2022 20 0003 P03 03575 02
502 02/11/2022 30 0002 P05 05025 07
503 05/11/2022 50 0001 P15 10
505 17/11/2022 40 0004 P10 01
505 17/11/2022 40 0004 P12 04
PROJET.VENTESEU.DATA
O_NO O_DATE S_NO C_NO P_NO PRICE QUANTITY RESERVE
500 10/10/2022 10 0004 P01 02599 03
500 10/10/2022 10 0004 P03 03575 02
500 10/10/2022 10 0004 P04 01000 05
502 02/11/2022 30 0002 P02 01549 03
502 02/11/2022 30 0002 P03 03575 05
503 05/11/2022 50 0001 P11 05
504 07/11/2022 40 0003 P14 01
504 07/11/2022 40 0003 P18 04




En outre, vous constituerez une présentation (PowerPoint ou équivalent) qui vous 
servira de fil conducteur le jour de la soutenance. 
Votre présentation devra comporter les éléments suivants : 
• Une présentation de l'équipe
• Contexte du projet
• Outils et gestion de projet
• La solution fonctionnelle
• Diagramme fonctionnel
• Proposition technique
• Détails des étapes du projet. (Organisation. Démarche algorithmique, Travail 
en équipe …)
• Démonstration
• Potentiels problèmes rencontrés et solutions apportées
• Quelles sont les améliorations à apporter ?
• Conclusion 
Ce plan est une suggestion, vous pourrez le suivre ou en proposer un autre.
L’ensemble des travaux réalisés devra être mis sur un dépôt afin de centraliser les 
informations et de faciliter la communication entre les membres du projet. 
Vous ferez en sorte de bien vous répartir les tâches et de prendre connaissance 
des éléments sur le projet, effectués par les autres membres du groupe.
Lors de la soutenance, il va de soi que le temps de parole entre chacun des 
membres du groupe devra être équilibré.

"