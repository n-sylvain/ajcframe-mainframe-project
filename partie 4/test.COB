       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO-WORLD.


       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.



       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-DATA       PIC X(10).
       01 WS-DATE       REDEFINES WS-DATA.
           05 JOUR       PIC 99  .
           05 MOIS       PIC 99  .
           05 ANNEE      PIC 9(4)  .

       01  TABLE-GRP.
           05  TAB-ELEM  PIC X(10) OCCURS 5 TIMES.

       01  ZONE-TEXTE  PIC X(50).


       01  W-SQLCODE      PIC +++9.

       77  MINVAL pic s99 value zero.
       77 WS-ssss PIC ----9 value zero.


       77 MA-CHAINE PIC X(100) value all 'j'.


       01 MDP-REEL    PIC X(20).        *> Pour stocker la vraie valeur
       01 MDP-MASQUE  PIC X(20) VALUE SPACES.
       01 I           PIC 9(02) VALUE 1.

       01 ENR-PARTK.
           05 ID-PARTK         PIC X(2).
           05 NOM-PARTK        PIC X(30).
           05 COULEUR-PARTK    PIC X(20).
           05 POIDS-PARTK      PIC S9(2)V COMP-3.
           05 VILLE-PARTK      PIC X(20).


       01 CODE-REPONSE     PIC 9(2)V99.
          88 CODE-VALIDE    VALUE 5 THRU 6 , 10 THRU 20, 50.
          88 CODE-ERREUR    VALUE 21 THRU 99.

       01 MONTANT-NBR     PIC s9(10)V9(3) VALUE -00000000 .
       01 MONTANT-EDIT    PIC +zzzz9,999 blank when zeroes .


       01 PRIX         PIC 9(4)V99 VALUE 25,50.
       01 QUANTITE     PIC 9(3) VALUE 4.
       01 TOTAL        PIC 9(5)V99.
       01 MOYENNE      PIC 9(3)V99.
       01 MOYENNE2      PIC 9(3)V99.


       77 ws-compt pic 999 value zeroes.




       PROCEDURE DIVISION.
       move 20,3 to POIDS-PARTK

       compute POIDS-PARTK = (POIDS-PARTK + 1)


       display POIDS-PARTK 'rrrrrrrrrrrrrrrrrr'

       compute  ws-compt  = ( 3 +
       3 -ws-compt )


       move 'e'  to MA-CHAINE

       display MA-CHAINE ']'

       divide  10 by 0  giving  MOYENNE2
           ON SIZE ERROR
               DISPLAY " Erreur : division impossible  "  MOYENNE2
           NOT ON SIZE ERROR
               DISPLAY "  Résultat : "

       end-divide










       MOVE MONTANT-NBR TO MONTANT-EDIT.
       DISPLAY "Montant : [" MONTANT-EDIT ']'.






         MOVE 50 TO CODE-REPONSE.

           IF CODE-VALIDE
            DISPLAY "Reponse valide"
           ELSE IF CODE-ERREUR
            DISPLAY "eponse en erreur"
           ELSE
            DISPLAY "Reponse inconnue"
           END-IF





       MOVE 'eedddeeeeeeeeeeeeee' TO MDP-REEL.

      *> Étape 3 : Masquer visuellement
       PERFORM UNTIL I > LENGTH OF MDP-REEL
           IF MDP-REEL(I:1) NOT = SPACE
            MOVE "*" TO MDP-MASQUE(I:1)
           END-IF
           ADD 1 TO I
       END-PERFORM



       display  I '  '  MDP-REEL(3:1)




       MOVE ALL "X" TO MA-CHAINE(10:50)




       display MA-CHAINE

       MOVE FUNCTION MIN(1, -2, -3) TO MINVAL

       move 9999 to W-SQLCODE


         display  W-SQLCODE


        display  W-SQLCODE

       display function TRIM('     rrrr   ')


       move  'eeee' to TAB-ELEM(1)
       move  'szsssss' to TAB-ELEM(2)

       MOVE TABLE-GRP  TO ZONE-TEXTE


       display TABLE-GRP


       move 'rrrrrrrrrr' to WS-DATA

       move 10 to WS-DATA

       DISPLAY WS-DATA



       perform AAA
       exit

       if WS-DATA not equal  all '1' then

       DISPLAY "Adqqqqqqqqqqqqqqqqq "

       end-if


       IF 1 < 18
         DISPLAY "Accdddd  autor "
          NEXT SENTENCE
       ELSE
          DISPLAY "Accès autorisé"
       END-IF
       DISPLAY "Fin du contrôle d’âge".




       MOVE 'ABCeeeeeZ' TO WS-DATA

       move 12 TO JOUR
       DISPLAY  WS-DATA
       DISPLAY  JOUR
       DISPLAY   WS-DATA








       perform EEE.


       EEE.
       STOP RUN.

       AAA.
       DISPLAY 'Hel  ld!'
       exit
       .
