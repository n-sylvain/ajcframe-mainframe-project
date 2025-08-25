       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXO04.
       
      * AFFICHER LES INFORMATIONS DES COMMANDES AVEC CURSEUR
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       
       DATA DIVISION.
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
       77 WS-P-NO           PIC X(3).
       77 WS-DESCRIPTION    PIC X(30).
       77 WS-QUANTITY       PIC S9(2)V USAGE COMP-3.
       77 WS-PRICE          PIC S9(3)V9(2) USAGE COMP-3.
       77 WS-LINE-TOTAL     PIC S9(5)V9(2) USAGE COMP-3.
       
      * VARIABLES D'EDITION POUR L'AFFICHAGE
       77 ED-O-NO           PIC ZZ9.
       77 ED-QUANTITY       PIC ZZ9.
       77 ED-PRICE          PIC ZZ9,99.
       77 ED-LINE-TOTAL     PIC ZZZ9,99.
       
      * VARIABLES DE CONTROLE
       77 WS-ANO            PIC 99 VALUE ZERO.
       77 WS-COUNTER        PIC 999 VALUE ZERO.
       
      * INDICATEURS DE VARIABLES (pour les champs nullable) - SMALLINT requis
       77 IND-FNAME         PIC S9(4) USAGE COMP-4.
       77 IND-ADDRESS       PIC S9(4) USAGE COMP-4.
       
       PROCEDURE DIVISION.
       
           DISPLAY "=== DEBUT DU PROGRAMME EXO04 ==="
       
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
               PERFORM DISPLAY-ORDER-INFO
               PERFORM FETCH-ORDER
           END-PERFORM
       
      * FERMETURE DU CURSEUR
           EXEC SQL
               CLOSE CORDERS
           END-EXEC
           PERFORM TEST-SQLCODE
       
           DISPLAY "=== NOMBRE TOTAL DE LIGNES : ", WS-COUNTER, " ==="
           DISPLAY "=== FIN DU PROGRAMME EXO04 ==="
       
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
                    :WS-P-NO,
                    :WS-DESCRIPTION,
                    :WS-QUANTITY,
                    :WS-PRICE,
                    :WS-LINE-TOTAL
           END-EXEC
           PERFORM TEST-SQLCODE
           .
       
       DISPLAY-ORDER-INFO.
      * FORMATAGE POUR L'AFFICHAGE
           MOVE WS-O-NO TO ED-O-NO
           MOVE WS-QUANTITY TO ED-QUANTITY
           MOVE WS-PRICE TO ED-PRICE
           MOVE WS-LINE-TOTAL TO ED-LINE-TOTAL
       
      * AFFICHAGE DES INFORMATIONS
           DISPLAY "--- COMMANDE N° ", ED-O-NO, " ---"
           DISPLAY "SOCIETE    : ", WS-COMPANY
           DISPLAY "ADRESSE    : ", WS-ADDRESS
           DISPLAY "VILLE      : ", WS-CITY, " ", WS-STATE, " ", WS-ZIP
           DISPLAY "DATE CMD   : ", WS-ODATE-ISO
           DISPLAY "DEPARTEMENT: ", WS-DNAME
           DISPLAY "VENDEUR    : ", WS-FNAME, " ", WS-LNAME
           DISPLAY "PRODUIT    : ", WS-P-NO, " - ", WS-DESCRIPTION
           DISPLAY "QUANTITE   : ", ED-QUANTITY
           DISPLAY "PRIX UNIT. : ", ED-PRICE
           DISPLAY "TOTAL LIGNE: ", ED-LINE-TOTAL
           DISPLAY "---------------------------------------"
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