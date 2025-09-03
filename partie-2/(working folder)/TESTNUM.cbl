       IDENTIFICATION DIVISION.
       PROGRAM-ID.    TESTPRIX.
      
      ********************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
      
      ********************************************************
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
      * Variables de test
       01 WS-PRIX-ALPHA         PIC X(5).
       01 WS-PRIX-WORK          PIC 9(5).
       01 WS-PRIX-FINAL         PIC 9(3)V99.
       01 WS-PRIX-RECUP         PIC S9(7)V99 USAGE COMP-3.
       
      * Variables d'édition
       01 ED-PRIX               PIC Z(7),99.
       
      * Table de test
       77 I                     PIC 9 VALUE 0.
       01 TAB-TEST-PRIX.
          05 PRIX-TEST          PIC X(5) OCCURS 6.
      
      ********************************************************
       PROCEDURE DIVISION.
       
      * Initialisation des valeurs de test
           MOVE '02599' TO PRIX-TEST(1)
           MOVE '01549' TO PRIX-TEST(2)
           MOVE '03575' TO PRIX-TEST(3)
           MOVE '01000' TO PRIX-TEST(4)
           MOVE SPACES  TO PRIX-TEST(5)
           MOVE '00000' TO PRIX-TEST(6)
       
           DISPLAY 'DEBUT TEST CONVERSION PRIX'
           DISPLAY '=============================='
           DISPLAY ' '
           
      * Test des différentes valeurs
           PERFORM VARYING I FROM 1 BY 1 UNTIL I > 6
              MOVE PRIX-TEST(I) TO WS-PRIX-ALPHA
              PERFORM TEST-CONVERSION
           END-PERFORM
           
           DISPLAY ' '
           DISPLAY 'FIN TEST CONVERSION PRIX'
           
           GOBACK.
           
       TEST-CONVERSION.
           DISPLAY 'PRIX ORIGINAL : [' WS-PRIX-ALPHA ']'
           
           IF WS-PRIX-ALPHA = SPACES
              DISPLAY '  -> PRIX VIDE (SPACES)'
              MOVE ZERO TO WS-PRIX-FINAL
           ELSE
              MOVE WS-PRIX-ALPHA TO WS-PRIX-WORK
              COMPUTE WS-PRIX-FINAL = WS-PRIX-WORK / 100
              DISPLAY '  -> PRIX WORK  : ' WS-PRIX-WORK
              DISPLAY '  -> PRIX FINAL : ' WS-PRIX-FINAL
           END-IF
           
           MOVE WS-PRIX-FINAL TO ED-PRIX
           DISPLAY '  -> PRIX EDITE : ' ED-PRIX
           DISPLAY ' '.

           