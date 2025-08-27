
       IDENTIFICATION DIVISION.
       PROGRAM-ID. A5CNX.

       ENVIRONMENT DIVISION.


       DATA DIVISION.


       WORKING-STORAGE SECTION.


       COPY DFHBMSCA.
       COPY DFHAID.
       COPY MS5CONX.

       01 WS-COMMAREA.
           05 WS-LOGIN      PIC X(5).
           05 WS-PWD        PIC X(15).
           05 WS-MESSAGE    PIC X(60).
           05 WS-MSG-COL    PIC X.

       01 WS-RECORD.
           05 WS-ID-REC     PIC X(5).
           05 WS-NOM-REC    PIC X(15).
           05 WS-PREN-REC   PIC X(15).
           05 WS-CP-REC     PIC X(5).
           05 WS-VILLE-REC  PIC X(20).
           05 WS-SAL-REC    PIC 9(5)V99.
           05 WS-FIL-REC    PIC X(3).



       77 WS-RESP         PIC S9(8) COMP.
       77 WS-RESP-TXT     PIC X(10) VALUE SPACES.
       77 WS-FILE-STATUS  PIC XX.
       77 WS-LENGTH       PIC S9(4) COMP VALUE 70.
       77 WS-NXT-IHM      PIC 9     VALUE ZERO.

       77 WS-ID-TR        PIC X(4)  VALUE 'T5CO'.
       77 WS-CD-ERR       PIC 9(2).
       77 WS-CD-ERR-TXT   PIC X(2).
       77 MAPAREA         PIC X(1920).
       77 MAPSET-NAME     PIC X(8)  VALUE 'MS5CONX'.
       77 MAP-NAME        PIC X(8)  VALUE 'MAP5COX'.

       77 WS-SEC-MESS   PIC X(50) VALUE 'ID ou mot de passe incorrect'.


       LINKAGE SECTION.
           COPY A5CMAREA.

       PROCEDURE DIVISION USING DFHCOMMLK.

           MOVE LK-LOGIN TO  WS-LOGIN
           MOVE LK-PWD TO  WS-PWD
           MOVE LK-MESSAGE-CNX TO  WS-MESSAGE



      *     EVALUATE EIBTRNID
      *          WHEN WS-ID-TR

                    IF EIBCALEN = 0 THEN
                        MOVE LOW-VALUE TO MAP5COXO
                        PERFORM AFF
                    ELSE


      *                  MOVE LK-LOGIN TO LOGINO
      *                  MOVE LK-PWD TO PWDO
      *
      *                  MOVE SPACES TO MESS1O
      *                  MOVE LK-MESSAGE-CNX TO MESS1O
      *                  MOVE LK-MSG-COL-CNX TO MESS1C



                        EVALUATE TRUE
                           WHEN DFHCLEAR = EIBAID
                               MOVE 'Au Revoir.' TO WS-MESSAGE
                               PERFORM FIN-TOTALE
                           WHEN DFHENTER = EIBAID

                            PERFORM AFF

      *                    PERFORM MOV
      *                         PERFORM LECT

                           WHEN OTHER
                               MOVE 'Adddddddd' TO WS-MESSAGE
                               PERFORM FIN-TOTALE
                       END-EVALUATE




                    END-IF




      *          WHEN OTHER
      *              MOVE 'Transaction incorrecte.' TO WS-MESSAGE
      *              PERFORM FIN-TOTALE

      *     END-EVALUATE






           GOBACK.


       CHECK.

           MOVE ZERO TO WS-NXT-IHM
           MOVE LOGINI TO WS-LOGIN
           MOVE PWDI TO WS-PWD
           MOVE SPACES TO MESS1O
           MOVE 'Patientez...' TO WS-MESSAGE
           MOVE WS-MESSAGE TO MESS1O
           MOVE DFHDFT TO MESS1C

      *     EXEC CICS READ FILE('A5EMPK')
      *          INTO(WS-RECORD)
      *          RIDFLD(WS-LOGIN)
      *          RESP(WS-RESP)
      *          LENGTH(WS-LENGTH)
      *          EQUAL
      *     END-EXEC


      *     IF WS-LOGIN NOT EQUAL SPACE AND WS-PWD NOT EQUAL SPACE THEN
      *          PERFORM CONNX
      *     ELSE
      *          MOVE DFHRED TO MESS1C
      *         MOVE 'L''ID et mot de passe doivent être renseignés.'
      *          TO WS-MESSAGE
      *     END-IF

      *     MOVE MESS1C TO WS-MSG-COL
      *     MOVE WS-MESSAGE TO MESS1O
           .


       CONNX.

           IF WS-RESP NOT EQUAL DFHRESP(NORMAL) THEN

                EVALUATE WS-RESP
                    WHEN DFHRESP(NOTFND)

                        MOVE WS-SEC-MESS TO WS-MESSAGE

                    WHEN DFHRESP(ILLOGIC)
                        MOVE 'Erreur logique dans le fichier.' TO
                        WS-MESSAGE
                    WHEN DFHRESP(NOTOPEN)
                        MOVE 'Le fichier n''est pas ouvert.' TO
                        WS-MESSAGE
                    WHEN OTHER
                        MOVE 'Erreur inattendue. RESP = ' TO
                        WS-MESSAGE
                        MOVE WS-RESP TO WS-RESP-TXT
                        STRING
                            WS-MESSAGE DELIMITED BY SIZE
                            SPACE DELIMITED BY SIZE
                            WS-RESP-TXT DELIMITED BY SIZE
                            INTO WS-MESSAGE
                        END-STRING
                END-EVALUATE

                MOVE DFHRED TO MESS1C
           ELSE

                IF WS-PREN-REC = WS-PWD THEN
                    MOVE 'CONNEXION REUSSIE.' TO
                    WS-MESSAGE
                    MOVE 1 TO WS-NXT-IHM
                ELSE
                    MOVE WS-SEC-MESS TO WS-MESSAGE
                END-IF

           END-IF

           MOVE MESS1C TO WS-MSG-COL
           PERFORM MOV

           IF WS-NXT-IHM = 1 THEN

                MOVE 1 TO SECURE-ACCESS
                EXEC CICS XCTL
                    PROGRAM('A5PART')
                    COMMAREA(DFHCOMMLK)
                    LENGTH(LENGTH OF DFHCOMMLK)

                END-EXEC
           END-IF

           .



       MOV.

           MOVE WS-LOGIN TO LK-LOGIN
           MOVE WS-PWD TO LK-PWD
           MOVE WS-MESSAGE TO LK-MESSAGE-CNX
           MOVE WS-MSG-COL TO LK-MSG-COL-CNX

           .



       AFF.

           EXEC CICS
                SEND MAP(MAP-NAME)
                MAPSET(MAPSET-NAME)
                FROM(MAP5COXO)
                RESP(WS-CD-ERR)
                ERASE
                CURSOR
                WAIT
           END-EXEC

           IF WS-CD-ERR  NOT EQUAL  DFHRESP(NORMAL)
                MOVE 'ERR SEND' TO WS-MESSAGE
                PERFORM FIN-TOTALE
           END-IF


           EXEC CICS
                RETURN TRANSID('T5CO')
                COMMAREA(DFHCOMMLK)
                RESP(WS-CD-ERR)
                LENGTH(LENGTH OF DFHCOMMLK)
           END-EXEC


           MOVE WS-CD-ERR TO MESS1O

      *     IF WS-CD-ERR  NOT EQUAL  DFHRESP(NORMAL)
      *           MOVE WS-CD-ERR TO WS-CD-ERR-TXT
      *
      *           MOVE 'ERR TRANSID : ' TO WS-MESSAGE
      *
      *           STRING
      *            WS-MESSAGE DELIMITED BY SIZE
      *                  SPACE DELIMITED BY SIZE
      *                WS-CD-ERR-TXT DELIMITED BY SIZE
      *                 INTO WS-MESSAGE
      *              END-STRING
      *
      *           PERFORM FIN-TOTALE
      *     END-IF
           .


       LECT.
           EXEC CICS
                RECEIVE MAP(MAP-NAME)
                MAPSET(MAPSET-NAME)
                INTO(MAP5COXI)
                RESP(WS-CD-ERR)
           END-EXEC


           EVALUATE TRUE

               WHEN WS-CD-ERR = DFHRESP(MAPFAIL)

                   MOVE 'ssssssssssssssssssssss' TO WS-MESSAGE
                   PERFORM FIN-TOTALE



                   MOVE 'Aucune donnee saisie.' TO WS-MESSAGE
                   MOVE WS-MESSAGE TO MESS1O
                   MOVE DFHRED TO MESS1C
                   PERFORM AFF
               WHEN WS-CD-ERR = DFHRESP(NORMAL)

                 MOVE '777777' TO WS-MESSAGE
                   PERFORM FIN-TOTALE





                   PERFORM CHECK
               WHEN OTHER
                   MOVE 'ERR RECEIVE' TO WS-MESSAGE
                   PERFORM FIN-TOTALE


           END-EVALUATE
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
