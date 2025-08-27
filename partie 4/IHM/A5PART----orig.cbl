
       IDENTIFICATION DIVISION.
       PROGRAM-ID. A5PART.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * EXEC SQL INCLUDE SQLCA END-EXEC.

       COPY DFHBMSCA.
       COPY DFHAID.
       COPY MS5PART.




       01 WS-COMMAREA.
           05 WS-ID         PIC X(2).
           05 WS-NOM        PIC X(30).
           05 WS-COULEUR    PIC X(20).
           05 WS-POIDS      PIC S9(2) COMP-3.
           05 WS-VILLE      PIC X(20).
           05 WS-MESSAGE    PIC X(60).
           05 WS-MSG-COL    PIC X.

       01 ENREG-KSDS.
           05 WS-IDK        PIC X(2).
           05 WS-NOMK       PIC X(30).
           05 WS-COULEURK   PIC X(20).
           05 WS-POIDSK     PIC S9(2) COMP-3.
           05 WS-VILLEK     PIC X(20).



       77 WS-RESP         PIC S9(8) COMP.
       77 WS-RESP-TXT     PIC X(10) VALUE SPACES.
       77 WS-ID-TR        PIC X(4) VALUE 'T5PA'.
       77 WS-CD-ERR       PIC 9(2).
       77 MAPAREA         PIC X(1920).
       77 MAPSET-NAME     PIC X(8) VALUE 'MS5PART'.
       77 MAP-NAME        PIC X(8) VALUE 'MAP5PAR'.





       LINKAGE SECTION.
           COPY A5CMAREA.

       PROCEDURE DIVISION USING DFHCOMMLK.

           IF SECURE-ACCESS = 0 THEN
                PERFORM SECUR
           END-IF




           EVALUATE EIBTRNID
                WHEN WS-ID-TR

                    IF EIBCALEN = 0 THEN
                        MOVE LOW-VALUE TO MAP5PARO

                    ELSE
                        MOVE LK-ID TO IDO
                        MOVE LK-NOM TO NOMO
                        MOVE LK-COULEUR TO COULO
                        MOVE LK-POIDS TO POIDSO
                        MOVE LK-VILLE TO VILLEO
                        MOVE SPACES TO MESS1O
                        MOVE LK-MESSAGE TO MESS1O
                        MOVE LK-MSG-COL TO MESS1C

                        MOVE LK-ID TO  WS-ID
                        MOVE LK-NOM TO  WS-NOM
                        MOVE LK-COULEUR TO  WS-COULEUR
                        MOVE LK-POIDS TO  WS-POIDS
                        MOVE LK-VILLE TO WS-VILLE
                        MOVE LK-MESSAGE TO  WS-MESSAGE
                        MOVE LK-MSG-COL TO WS-MSG-COL
                    END-IF
                    PERFORM AFF
                WHEN OTHER
                    MOVE 'Transaction incorrecte.' TO WS-MESSAGE
                    PERFORM FIN-TOTALE

           END-EVALUATE




           IF EIBAID = DFHCLEAR
                MOVE 'Au Revoir.' TO WS-MESSAGE
                PERFORM FIN-TOTALE
           END-IF

           IF EIBAID = DFHENTER THEN
                PERFORM LECT
           END-IF


           GOBACK.

       SECUR.

           MOVE 'La connexion n''a pas été autorisée.'
           TO WS-MESSAGE
           PERFORM FIN-TOTALE
           .

       INSERT.



           EXEC SQL
                SELECT PNO
                FROM PARTS
                WHERE PNO = :WS-ID
           END-EXEC.



           EVALUATE TRUE

                WHEN SQLCODE = 0
                    PERFORM MSG-DOUBLON
                WHEN SQLCODE = 100

                    EXEC CICS READ FILE('A5PARK')
                        INTO(ENREG-KSDS)
                        RIDFLD(WS-ID)
                        RESP(WS-RESP)
                        LENGTH(LENGTH OF ENREG-KSDS)
                        EQUAL
                   END-EXEC


                   EVALUATE TRUE
                        WHEN WS-RESP = DFHRESP(NOTFND)
                            PERFORM EXEC-INSERT
                        WHEN WS-RESP = DFHRESP(NORMAL)
                            PERFORM UPDT
                        WHEN OTHER
                            PERFORM ERR-OTHER
                   END-EVALUATE



                WHEN OTHER
                    MOVE "Erreur - SQLCODE :" TO WS-MESSAGE
                    STRING
                        WS-MESSAGE DELIMITED BY SIZE
                        SPACE DELIMITED BY SIZE
                        SQLCODE DELIMITED BY SIZE
                        INTO WS-MESSAGE
                    END-STRING


           END-EVALUATE
           MOVE MESS1C TO  WS-MSG-COL
           MOVE WS-MESSAGE TO MESS1O
           PERFORM MOV
           .

       MSG-POIDS.
           MOVE 'Le poids doit être de type numérique.'  TO WS-MESSAGE
           .

       MSG-DOUBLON.
           MOVE 'Doublon : identifiant '''  TO WS-MESSAGE
           STRING
                WS-MESSAGE DELIMITED BY SIZE
                WS-ID DELIMITED BY SIZE
                ''' déjà existant.' DELIMITED BY SIZE
                INTO WS-MESSAGE
           END-STRING
           .


       MOVK.


           MOVE WS-ID TO WS-IDK
           MOVE WS-NOM TO WS-NOMK
           MOVE WS-COULEUR TO WS-COULEURK
           MOVE WS-POIDS TO WS-POIDSK
           MOVE WS-VILLE TO WS-VILLEK

           .

       UPDT.

           MOVE DFHRED TO MESS1C
           PERFORM MOVK


           EXEC CICS READ
                FILE('A5PARK')
                INTO(ENREG-KSDS)
                RIDFLD(WS-IDK)
                UPDATE
                RESP(WS-RESP)
           END-EXEC


           EVALUATE TRUE
                WHEN WS-RESP = DFHRESP(NORMAL)
                    EXEC CICS REWRITE
                        FILE('A5PARK')
                        FROM(ENREG-KSDS)
                        RESP(WS-RESP)
                    END-EXEC

                    EVALUATE TRUE
                        WHEN WS-RESP = DFHRESP(NORMAL)
                            MOVE 'MAJ reussie dans le fichier KSDS.'
                            TO WS-MESSAGE
                            MOVE DFHDFT TO MESS1C
                        WHEN OTHER
                            PERFORM ERR-OTHER
                    END-EVALUATE

                WHEN OTHER
                    PERFORM ERR-OTHER
           END-EVALUATE

           .

       EXEC-INSERT.

           MOVE DFHRED TO MESS1C
      * A5PARK est le fichier API4.PROJET.NEWPARTS.KSDS
      * il faut le def et ins file dans CICS

           PERFORM MOVK

           EXEC CICS WRITE
                FILE('A5PARK')
                FROM(ENREG-KSDS)
                RIDFLD(WS-IDK)
                LENGTH(LENGTH OF ENREG-KSDS)
                RESP(WS-RESP)
           END-EXEC.



           EVALUATE TRUE
                WHEN WS-RESP = DFHRESP(NORMAL)
                    MOVE 'Insertion réussie dans la table PARTS.'
                    TO WS-MESSAGE
                    MOVE DFHDFT TO MESS1C
                WHEN WS-RESP = DFHRESP(DUPREC)
                    PERFORM MSG-DOUBLON
                WHEN WS-RESP = DFHRESP(NOTOPEN)
                    MOVE 'Erreur : fichier non ouvert.' TO WS-MESSAGE
                WHEN WS-RESP = DFHRESP(NOSPACE)
                    MOVE 'Erreur : pas d''espace disponible.'
                        TO WS-MESSAGE


                WHEN OTHER
                    PERFORM ERR-OTHER

           END-EVALUATE


           .


       ERR-OTHER.

           MOVE 'Erreur - WS-RESP :' TO WS-MESSAGE
           MOVE WS-RESP TO WS-RESP-TXT
           STRING
                WS-MESSAGE DELIMITED BY SIZE
                SPACE DELIMITED BY SIZE
                WS-RESP-TXT DELIMITED BY SIZE
                INTO WS-MESSAGE
           END-STRING
           .

       AFF.

           EXEC CICS
                SEND MAP(MAP-NAME)
                MAPSET(MAPSET-NAME)
                RESP(WS-CD-ERR)
                ERASE
                CURSOR
           END-EXEC

           IF WS-CD-ERR  NOT EQUAL  DFHRESP(NORMAL)
                MOVE 'ERR SEND' TO WS-MESSAGE
                perform FIN-TOTALE
           END-IF


           PERFORM MOV

           EXEC CICS
                RETURN TRANSID(WS-ID-TR)
                COMMAREA(DFHCOMMLK)
                LENGTH(LENGTH OF DFHCOMMLK)
                RESP(WS-CD-ERR)
           END-EXEC

           IF WS-CD-ERR  NOT EQUAL  DFHRESP(NORMAL)
                MOVE 'ERR TRANSID' TO WS-MESSAGE
                perform FIN-TOTALE
           END-IF

           .


       MOV.
           MOVE WS-ID TO LK-ID
           MOVE WS-NOM TO LK-NOM
           MOVE WS-COULEUR TO LK-COULEUR
           MOVE WS-POIDS TO LK-POIDS
           MOVE WS-VILLE TO LK-VILLE
           MOVE WS-MESSAGE TO LK-MESSAGE
           MOVE WK-MSG-COL TO LK-MSG-COL
           .

       LECT.

           MOVE '¨Patientez...' TO WS-MESSAGE
           MOVE WS-MESSAGE TO MESS1O
           MOVE DFHDFT TO MESS1C

           EXEC CICS
                RECEIVE MAP(MAP-NAME)
                MAPSET(MAPSET-NAME)
                RESP(WS-CD-ERR)
           END-EXEC
           IF WS-CD-ERR  NOT EQUAL  DFHRESP(NORMAL)
               MOVE 'ERR RECEIVE' TO WS-MESSAGE
               PERFORM FIN-TOTALE
           END-IF



           MOVE IDI TO WS-ID
           MOVE NOMI TO WS-NOM
           MOVE COULI TO WS-COULEUR
           MOVE POIDSI TO WS-POIDS
           MOVE VILLEI TO WS-VILLE
           MOVE SPACES TO WS-MESSAGE

           MOVE SPACES TO MESS1O
           MOVE DFHRED TO MESS1C



           IF WS-NOM = SPACES OR WS-ID = SPACES THEN
               MOVE 'Renseignez l''ID et/ou le nom.' TO WS-MESSAGE
               MOVE WS-MESSAGE TO MESS1O


           ELSE

               IF WS-POIDS IS NOT NUMERIC THEN
                   IF WS-POIDS = SPACES THEN
                       PERFORM INSERT
                   ELSE
                       PERFORM MSG-POIDS
                       MOVE WS-MESSAGE TO MESS1O
                   END-IF
               ELSE
                   PERFORM INSERT
               END-IF



           END-IF
           .

       FIN-TOTALE.
           EXEC CICS
                SEND FROM (WS-MESSAGE)
                LENGTH (LENGTH OF WS-MESSAGE)
                WAIT
                ERASE
           END-EXEC
           EXEC CICS RETURN END-EXEC
           .
