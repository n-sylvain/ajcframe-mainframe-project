
       IDENTIFICATION DIVISION.
       PROGRAM-ID. A5CNX.

       ENVIRONMENT DIVISION.


       DATA DIVISION.


       WORKING-STORAGE SECTION.


       COPY DFHBMSCA.
       COPY MS5CONX.
       COPY DFHAID.


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
           05 WS-VILLE-REC  PIC X(5).
           05 WS-SAL-REC    PIC 9(5)V99.




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



           EVALUATE EIBTRNID
                WHEN WS-ID-TR

                   IF EIBCALEN = 0
                    MOVE LOW-VALUE TO MAP5COXO
                    MOVE 'eeffffff' TO MESS1O
                    PERFORM AFF
                   ELSE
                    PERFORM LECT

                   END-IF

                WHEN OTHER
                    MOVE 'Transaction incorrecte.' TO WS-MESSAGE
                    PERFORM FIN-TOTALE

           END-EVALUATE



           EVALUATE TRUE
                WHEN DFHCLEAR = EIBAID
                    MOVE 'Au Revoir.' TO WS-MESSAGE
                    PERFORM FIN-TOTALE
                WHEN DFHENTER = EIBAID
                    PERFORM LECT
                    MOVE  '9999zzzf' TO MESS1O
           END-EVALUATE


           GOBACK.


       CHECK.

           MOVE 'zzzzzzzzzzzzf' TO MESS1O
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


           IF WS-ID-TR = SPACES
               MOVE 'T5CO' TO WS-ID-TR
           END-IF

           MOVE 'ee99999999999999' TO MESS1O

           EXEC CICS
                RETURN TRANSID('T5CO')
                COMMAREA(DFHCOMMLK)
                RESP(WS-CD-ERR)
                LENGTH(LENGTH OF DFHCOMMLK)
           END-EXEC


           .


       LECT.

               EXEC CICS
                RECEIVE MAP(MAP-NAME)
                MAPSET(MAPSET-NAME)
                INTO(MAP5COXI)
                RESP(WS-CD-ERR)
               END-EXEC

               IF WS-CD-ERR NOT = DFHRESP(NORMAL)
                MOVE 'Erreur RECEIVE' TO WS-MESSAGE
                PERFORM FIN-TOTALE
               END-IF

               MOVE LOGINI TO WS-LOGIN
               MOVE PWDI   TO WS-PWD
               PERFORM TRAITEMENT
           .

       TRAITEMENT.

           IF WS-LOGIN = 'aaa' AND WS-PWD = 'secret'
            MOVE 'Connexion réussie' TO WS-MESSAGE
            MOVE 'T5CO' TO WS-ID-TR
            PERFORM FIN-TOTALE
           ELSE
            MOVE WS-SEC-MESS TO WS-MESSAGE
            PERFORM FIN-TOTALE
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
