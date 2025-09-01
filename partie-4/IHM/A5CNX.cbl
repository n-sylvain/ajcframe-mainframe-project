000010******************************************************************
000020*  PROGRAMME PERMET DE MONTRER LA GESTION DES TRANSACTIONS
000040*
000041******************************************************************
000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. A5CNX.
000300
000400 ENVIRONMENT DIVISION.
000500 CONFIGURATION SECTION.
000600 SPECIAL-NAMES.
000700     DECIMAL-POINT IS COMMA.
000800
000900 DATA DIVISION.
001000 WORKING-STORAGE SECTION.
001100      COPY DFHBMSCA.
001200      COPY DFHAID.
001300      COPY MS5CONX.
001800
00181
001900 01 ZONE.
002100     05 INFOS         PIC X(62).

002397 01 ERR-MESS PIC X(60) VALUE 'FIN'.

       01 WS-RECORD.
           05 WS-ID-REC     PIC X(5).
           05 WS-NOM-REC    PIC X(15).
           05 WS-PREN-REC   PIC X(15).
           05 WS-CP-REC     PIC X(5).
           05 WS-VILLE-REC  PIC X(20).
           05 WS-SAL-REC    PIC 9(5)V99.
           05 WS-FIL-REC    PIC X(3).

       01 ZONE-ED.
           05 FILLER        PIC X(6) VALUE 'ERR : '.
           05 ERR-ED        PIC Z9   VALUE ' 0'.

       77 WS-CD-ERR     PIC 9(2).
       77 WS-TEMPS      PIC S9(15) COMP-3.
       77 WS-RES        PIC S9(10) VALUE ZERO.
       77 WS-RESP       PIC S9(8) COMP.
       77 WS-PROG       PIC X(8)  VALUE 'A5PART'.
002540
002550 LINKAGE SECTION.
002560 01 DFHCOMMAREA.
           05 ERR-MESS-LK PIC X(60).
           05 SEC-SMPDF56 PIC X(10).
002570
002600 PROCEDURE DIVISION USING DFHCOMMAREA.
002800********************************************************
002900* EIBCALEN CORRESPOND A LAL LG DES PARAMETRES TRANSMIS
003000* SI EIBCALEN = 0 ==> PREMIERE FOIS
003100********************************************************
003110      EVALUATE EIBTRNID
003120       WHEN 'T5CO'
003200        IF EIBCALEN = ZERO  THEN
003210                MOVE LOW-VALUE TO MAP5COXO
003310                PERFORM ENVOI-ECRAN

003400        END-IF
003500
003600********************************************************
003700* EIBAID PERMET DE RECUPERER LA TOUCHE APPUYEE
003800* DFHCLEAR ==> ESC
003900********************************************************
004000        IF EIBAID = DFHCLEAR
004100              MOVE 'BYE !!' TO ERR-MESS
004200              PERFORM FIN-TOTALE
004300        END-IF
004301
004306
004311
004312        IF EIBAID = DFHENTER

004313             PERFORM LECT-ECRAN
004314
004327        END-IF
004328
005473       WHEN OTHER
005476            CONTINUE
005477      END-EVALUATE
005478      PERFORM ENVOI-ECRAN
008500      .
008700
010610******************************************************************
010620*                       LISTE DES PARAGRAPHES
010640******************************************************************
010650 ENVOI-ECRAN.
010651
010665******************************************************************
010666*       ICI ON ENVOIE LES DIFFERNTES MAPS CONSTITUANT LE MAPSET
010667******************************************************************
010670
010700* ENVOI MAP
010710*****************
010800      EXEC CICS
010900         SEND MAP('MAP5COX')
011000              MAPSET('MS5CONX')
011600              RESP(WS-CD-ERR)
011610              ERASE
011620              CURSOR
011630              WAIT
011700      END-EXEC
011800      IF WS-CD-ERR  NOT EQUAL  DFHRESP(NORMAL)
011900           MOVE 'ERR SEND' TO ERR-MESS
012000           PERFORM FIN-TOTALE
012100      END-IF
013200
013210****************************************************
013220* REAFFICHE LA TRANSACTION, ELLE PERMET DE POUVOIR
013230* DE NOUVO RECUPERER LES ELEMENTS SAISIS
013240*****************************************************
013250     EXEC CICS
013260          RETURN TRANSID ('T5CO')
013270          COMMAREA (ZONE)
013280          LENGTH (LENGTH OF ZONE)
013290     END-EXEC
013291     .
013310
013320
014110 FIN-TOTALE.
014120     EXEC CICS
014130       SEND FROM (ERR-MESS)
014140       LENGTH (LENGTH OF ERR-MESS)
014150       WAIT
014160       ERASE
014170     END-EXEC
014180     EXEC CICS RETURN END-EXEC
           .

014190 RENS-CHAMPS.
           MOVE 'Renseignez les champs avec les bonnes valeurs.'
           TO ERR-MESS
           MOVE ERR-MESS TO MESS1O
           MOVE DFHRED TO MESS1C
           .

       check.
           MOVE 'Patientez...' TO MESS1O
           MOVE DFHDFT TO MESS1C
           INITIALIZE WS-RECORD
           EXEC CICS READ FILE('A5EMPK')
               INTO(WS-RECORD)
               RIDFLD(LOGIDI)
               RESP(WS-RESP)
               LENGTH(LENGTH OF WS-RECORD)
               EQUAL
           END-EXEC

           MOVE ' ' TO MESS1O
           MOVE DFHRED TO MESS1C

           EVALUATE TRUE

               WHEN WS-RESP = 13
                   PERFORM RENS-CHAMPS
               WHEN WS-RESP = DFHRESP(NORMAL)
                   MOVE WS-PREN-REC TO  MESS1O
                   IF WS-PREN-REC = PWDI THEN
                       MOVE LOW-VALUE TO MAP5COXO
                       MOVE 'EDGSJ566' TO SEC-SMPDF56
                       EXEC CICS SEND CONTROL
                           ERASE
                           FREEKB
                       END-EXEC

                       EXEC CICS XCTL
                           PROGRAM(WS-PROG)
                           COMMAREA(DFHCOMMAREA)
                            LENGTH(LENGTH OF DFHCOMMAREA)
                            RESP (WS-CD-ERR)
                        END-EXEC



                       IF WS-CD-ERR  NOT EQUAL  DFHRESP(NORMAL)
004337                      MOVE 'ERR XCTL' TO ERR-MESS
004338                      PERFORM FIN-TOTALE
004339                 END-IF


                   ELSE
                      PERFORM RENS-CHAMPS

                   END-IF

               WHEN OTHER

                   MOVE WS-RESP TO ERR-ED
                   MOVE ZONE-ED TO MESS1O

           END-EVALUATE

           .


014191 LECT-ECRAN.
014200
014210      EXEC CICS
014220         RECEIVE MAP('MAP5COX')
014230              MAPSET('MS5CONX')
                    INTO(MAP5COXI)
014240              RESP(WS-CD-ERR)
014280      END-EXEC

           EVALUATE TRUE

               WHEN LOGIDI = SPACES OR PWDI = SPACES
                   PERFORM RENS-CHAMPS
               WHEN WS-CD-ERR = DFHRESP(MAPFAIL)
                   PERFORM RENS-CHAMPS
               WHEN WS-CD-ERR = DFHRESP(NORMAL)
                   PERFORM CHECK
               WHEN OTHER
                   MOVE 'ERR RECEIVE' TO ERR-MESS
                   PERFORM FIN-TOTALE

           END-EVALUATE




014300     .
014400
014500
