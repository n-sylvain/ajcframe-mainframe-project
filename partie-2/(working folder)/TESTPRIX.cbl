       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TESTPRIX.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
            DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

      * --- Liste des produits (occurs + subscript numérique)
       77  NB-PROD           PIC 9 VALUE 6.
       77  I                 PIC 9 VALUE 0.

       01  TAB-PRODUITS.
           05 PROD-CODE      PIC X(3) OCCURS 6.

      * --- Variables DB2 + affichage
       01  WS-PROD-NO        PIC X(3).
       01  WS-PRIX-RECUP     PIC S9(7)V99 COMP-3.
       01  ED-PRIX           PIC Z(7),99.

       PROCEDURE DIVISION.

      * Initialisation simple (sans REDEFINES, sans VALUE dans OCCURS)
           MOVE 'P15' TO PROD-CODE(1).
           MOVE 'P10' TO PROD-CODE(2).
           MOVE 'P12' TO PROD-CODE(3).
           MOVE 'P11' TO PROD-CODE(4).
           MOVE 'P14' TO PROD-CODE(5).
           MOVE 'P18' TO PROD-CODE(6).

      * Boucle de lecture des prix
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > NB-PROD
              MOVE PROD-CODE(I) TO WS-PROD-NO
              PERFORM RECUPERER-PRIX-DB2
              MOVE WS-PRIX-RECUP TO ED-PRIX
              DISPLAY 'PRODUIT=' WS-PROD-NO ' PRIX=' ED-PRIX
           END-PERFORM

           GOBACK.

      * --- Récupération DB2
       RECUPERER-PRIX-DB2.
           EXEC SQL
               SELECT PRICE
               INTO :WS-PRIX-RECUP
               FROM API6.PRODUCTS
               WHERE P_NO = :WS-PROD-NO
           END-EXEC

           EVALUATE SQLCODE
             WHEN 0
                CONTINUE
             WHEN 100
                DISPLAY 'PRODUIT NON TROUVE : ' WS-PROD-NO
                MOVE ZERO TO WS-PRIX-RECUP
             WHEN OTHER
                DISPLAY 'ERREUR SQL : ' SQLCODE
                        ' - PRODUIT : ' WS-PROD-NO
                MOVE ZERO TO WS-PRIX-RECUP
           END-EVALUATE.
