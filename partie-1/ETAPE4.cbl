       IDENTIFICATION DIVISION.
       PROGRAM-ID. ETAPE4.

      * PROGRAMME D'INSERTION D'UN PRODUIT DANS LA TABLE PRODUCTS
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.

      * INCLUSION DU DCLGEN PROD
           EXEC SQL
               INCLUDE PROD
           END-EXEC.

      * VARIABLES DE SAISIE
       77 WS-NUMERO        PIC X(10).
       77 WS-DESCRIPTION   PIC X(20).
       77 WS-PRIX          PIC X(10).

      * VARIABLES DE CONVERSION
       77 WS-PRIX-NUM      PIC 9(3)V99.
       77 WS-PRIX-TEMP     PIC X(10).
       77 WS-I             PIC 99.
       77 WS-ANO           PIC 99 VALUE ZERO.

      * VARIABLES D'EDITION
       77 ED-PRIX          PIC ZZ9,99.

       PROCEDURE DIVISION.

           DISPLAY "=== PROGRAMME D'INSERTION PRODUIT ==="
           DISPLAY " "

      * SAISIE DES DONNEES DU PRODUIT
           DISPLAY "SAISIE DU PRODUIT :"
           DISPLAY "==================="
           
           MOVE "P11" TO WS-NUMERO
           MOVE "Usb Flash Drive" TO WS-DESCRIPTION
           MOVE "16,50" TO WS-PRIX

           DISPLAY "P_NO         : ", WS-NUMERO
           DISPLAY "DESCRIPTION  : ", WS-DESCRIPTION
           DISPLAY "PRIX         : ", WS-PRIX
           DISPLAY " "

      * PREPARATION DES DONNEES POUR DB2
           PERFORM PREPARER-DONNEES

      * INSERTION EN BASE
           PERFORM INSERER-PRODUIT

      * VALIDATION DE LA TRANSACTION
           EXEC SQL COMMIT END-EXEC
           IF SQLCODE = ZERO
               DISPLAY "COMMIT EFFECTUE AVEC SUCCES"
           ELSE
               DISPLAY "ERREUR LORS DU COMMIT - SQLCODE : ", SQLCODE
           END-IF

           DISPLAY " "
           DISPLAY "=== FIN DU PROGRAMME ==="

           GOBACK.

       PREPARER-DONNEES.
           DISPLAY "PREPARATION DES DONNEES..."
           
      * PREPARATION P_NO (3 premiers caracteres)
           MOVE WS-NUMERO(1:3) TO PROD-P-NO 
           
      * PREPARATION DESCRIPTION
           MOVE LENGTH OF WS-DESCRIPTION TO PROD-DESCRIPTION-LEN 
           MOVE WS-DESCRIPTION TO PROD-DESCRIPTION-TEXT 
           
      * CONVERSION DU PRIX (format francais vers numerique)
           PERFORM CONVERTIR-PRIX
           MOVE WS-PRIX-NUM TO PROD-PRICE

           DISPLAY "DONNEES PREPAREES :"
           DISPLAY "  P_NO     : '", PROD-P-NO , "'"
           DISPLAY "  DESC LEN : ", PROD-DESCRIPTION-LEN 
           DISPLAY "  DESC     : '", PROD-DESCRIPTION-TEXT , "'"
           MOVE PROD-PRICE  TO ED-PRIX
           DISPLAY "  PRIX     : ", ED-PRIX
           DISPLAY " "
           .

       INSERER-PRODUIT.
           DISPLAY "INSERTION DU PRODUIT EN BASE..."
           
           EXEC SQL
               INSERT INTO PRODUCTS
                   (P_NO, DESCRIPTION, PRICE)
               VALUES
                   (:PROD-P-NO, 
                    :PROD-DESCRIPTION,
                    :PROD-PRICE)
           END-EXEC

           EVALUATE SQLCODE
               WHEN ZERO
                   DISPLAY "PRODUIT ", PROD-P-NO, 
                           " INSERE AVEC SUCCES"
               WHEN -803
                   DISPLAY "ERREUR : PRODUIT ", PROD-P-NO, 
                           " DEJA EXISTANT (DOUBLON)"
               WHEN OTHER
                   IF SQLCODE < 0 THEN
                       DISPLAY "ERREUR INSERTION - SQLCODE : ", SQLCODE
                       PERFORM ABEND-PROG
                   ELSE
                       DISPLAY "WARNING INSERTION - SQLCODE : ", SQLCODE
                   END-IF
           END-EVALUATE
           .

       ABEND-PROG.
           DISPLAY "ANOMALIE GRAVE DETECTEE"
           EXEC SQL ROLLBACK END-EXEC
           DISPLAY "ROLLBACK EFFECTUE"
           COMPUTE WS-ANO = 1 / WS-ANO
           .

       CONVERTIR-PRIX.
      * CONVERSION DU PRIX FORMAT FRANCAIS (16,50) VERS NUMERIQUE
           MOVE WS-PRIX TO WS-PRIX-TEMP
           
      * REMPLACER LA VIRGULE PAR UN POINT
           PERFORM VARYING WS-I FROM 1 BY 1 
                   UNTIL WS-I > LENGTH OF WS-PRIX-TEMP
               IF WS-PRIX-TEMP(WS-I:1) = ","
                   MOVE "." TO WS-PRIX-TEMP(WS-I:1)
               END-IF
           END-PERFORM
           
      * CONVERSION EN NUMERIQUE
           MOVE WS-PRIX-TEMP TO WS-PRIX-NUM
           
           DISPLAY "PRIX CONVERTI : ", WS-PRIX, " -> ", WS-PRIX-NUM
           .