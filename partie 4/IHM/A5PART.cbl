000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. A5PART.
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
001300      COPY MS5PART.
001800
00181
001900 01 ZONE.
002100     05 INFOS         PIC X(62).
           05 ID-COMM       PIC X(2).
002310
002397 01 ERR-MESS PIC X(60) VALUE 'FIN'.
002399 77 WS-CD-ERR     PIC 9(2).

002409 77 WS-CONT-OP    PIC S9(1) VALUE ZERO.
002510 77 WS-TEMPS      PIC S9(15) COMP-3.
002530 77 WS-RES        PIC S9(10) VALUE ZERO.
002531
       77 WS-RESP       PIC S9(8) COMP.
       77 WS-RESP2      PIC S9(8) COMP.
       77 WS-RESP3      PIC S9(8) COMP.


       01 ENREG-KSDS.
           05 WS-IDK        PIC X(2).
           05 WS-NOMK       PIC X(30).
           05 WS-COULEURK   PIC X(20).
           05 WS-POIDSK     PIC S9(2) COMP-3.
           05 WS-VILLEK     PIC X(20).
       01 ZONE-ED.
           05 FILLER        PIC X(4) VALUE 'ERR '.
           05 ERR-TYPE      PIC X(4).
           05 FILLER        PIC X(3) VALUE ' : '.
           05 ERR-ED        PIC Z9   VALUE ' 0'.
002540
002550 LINKAGE SECTION.
002560 01 DFHCOMMAREA.
           05 ERR-MESS-LK PIC X(60).
002570
002600 PROCEDURE DIVISION USING DFHCOMMAREA.
002800********************************************************
002900* EIBCALEN CORRESPOND A LAL LG DES PARAMETRES TRANSMIS
003000* SI EIBCALEN = 0 ==> PREMIERE FOIS
003100********************************************************
003110      EVALUATE EIBTRNID
003120       WHEN 'T5PA'

003200        IF EIBCALEN = ZERO  THEN
003210         MOVE LOW-VALUE TO MAP5PARO
               PERFORM ENVOI-ECRAN
              ELSE
                   MOVE 'EIB  sup  ZERO' TO MESS1O

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
004312        IF EIBAID = DFHENTER
004313             PERFORM LECT-ECRAN
004327        END-IF
004328
005473       WHEN OTHER
005476         MOVE LOW-VALUE TO MAP5PARO
               PERFORM ENVOI-ECRAN
005477      END-EVALUATE
005478
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
010900         SEND MAP('MAP5PAR')
011000              MAPSET('MS5PART')
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
013260          RETURN TRANSID ('T5PA')
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

       MSG-POIDS.
           MOVE 'Le poids doit être de type numérique.'  TO ERR-MESS
           .

       MSG-DOUBLON.
           MOVE 'Doublon identifiant'  TO ERR-MESS

           .



       CHECK.
           MOVE 'Patientez...' TO MESS1O
           MOVE DFHDFT TO MESS1C


           MOVE 0 TO WS-CONT-OP

           IF WS-CONT-OP = ZERO THEN
               IF IDI = SPACES OR IDI = LOW-VALUES OR IDL = ZERO
                   MOVE 1 TO WS-CONT-OP
                   MOVE 'L''ID doit être renseigné.' TO MESS1O
               END-IF

           END-IF



           IF WS-CONT-OP = ZERO THEN

               IF NOMI = SPACES OR NOMI = LOW-VALUES OR NOML = ZERO
                   MOVE 1 TO WS-CONT-OP
                   MOVE 'Le nom doit être renseigné.' TO MESS1O
               END-IF

           END-IF

           IF WS-CONT-OP = ZERO THEN
               IF  POIDSI IS NOT NUMERIC THEN
                   IF POIDSI = SPACES  OR POIDSL = ZERO THEN
                       MOVE 00 TO POIDSI
                       MOVE 0 TO WS-CONT-OP
                   ELSE
                      MOVE 'Le poids doit être une valeur numérique.'
                      TO MESS1O
                      MOVE 1 TO WS-CONT-OP
                   END-IF
               ELSE
                   MOVE 0 TO WS-CONT-OP
               END-IF

           END-IF


           IF WS-CONT-OP = ZERO THEN

               INITIALIZE ENREG-KSDS
               MOVE IDI TO WS-IDK
               MOVE NOMI TO WS-NOMK
               MOVE COULI TO WS-COULEURK
               MOVE POIDSI TO WS-POIDSK
               MOVE VILLEI TO WS-VILLEK


      *         EXEC CICS WRITE
      *            FILE('A5PARK')
      *             FROM(ENREG-KSDS)
      *             RIDFLD(IDI)
      *             LENGTH(LENGTH OF ENREG-KSDS)
      *             RESP(WS-RESP)
      *         END-EXEC
      *


                EXEC CICS
                  WRITE DATASET ('A5PARK')
                        FROM (ENREG-KSDS)
                        RIDFLD (IDI)
                        RESP (WS-RESP)
                END-EXEC




               MOVE DFHRED TO MESS1C

               EVALUATE TRUE
                   WHEN WS-RESP = DFHRESP(NOTFND)
                        MOVE 'Issss.'
                        TO MESS1O
                   WHEN WS-RESP = DFHRESP(NORMAL)
                       MOVE 'Insertion réussie.'
                        TO MESS1O
                       MOVE DFHDFT TO MESS1C
                   WHEN WS-RESP = DFHRESP(DUPKEY) OR
                   WS-RESP = DFHRESP(DUPREC) OR
                   WS-RESP = 14
                       MOVE 'Annulation pour cause de doublon.'
                       TO MESS1O


      *               EXEC CICS READ FILE('A5PARK')
      *                     INTO(ENREG-KSDS)
      *                     RIDFLD(IDI)
      *                      RESP(WS-RESP3)
      *                 END-EXEC
      *
      *                 EVALUATE TRUE
      *                     WHEN WS-RESP3  = DFHRESP(NORMAL)
      *                         PERFORM RWRT
      *                     WHEN OTHER
      *                         INITIALIZE ZONE-ED
      *                         MOVE 'RESP' TO ERR-TYPE
      *                         MOVE WS-RESP TO ERR-ED
      *                         MOVE ZONE-ED TO MESS1O
      *
      *                 END-EVALUATE
      *
                   WHEN OTHER
                        INITIALIZE ZONE-ED
                        MOVE 'RESP' TO ERR-TYPE
                        MOVE WS-RESP TO ERR-ED
                        MOVE ZONE-ED TO MESS1O
               END-EVALUATE

           END-IF



           .

       RWRT.

           EXEC CICS REWRITE
                FILE('A5PARK')
                FROM(ENREG-KSDS)
                RESP(WS-RESP2)
           END-EXEC


           EVALUATE TRUE
               WHEN WS-RESP2 = DFHRESP(NORMAL)
                   MOVE 'MAJ reussie dans le fichier KSDS.'
                   TO MESS1O
                   MOVE DFHDFT TO MESS1C
               WHEN OTHER
                   INITIALIZE ZONE-ED
                   MOVE 'RESP' TO ERR-TYPE
                   MOVE WS-RESP2 TO ERR-ED
                   MOVE ZONE-ED TO MESS1O

           END-EVALUATE

           .


014191 LECT-ECRAN.


           MOVE '¨Patientez..' TO ERR-MESS
           MOVE ERR-MESS TO MESS1O
           MOVE DFHDFT TO MESS1C
014200
014210     EXEC CICS
014220         RECEIVE MAP('MAP5PAR')
014230         MAPSET('MS5PART')
               INTO(MAP5PARI)
014240         RESP(WS-CD-ERR)
014280     END-EXEC

           EVALUATE TRUE

               WHEN WS-CD-ERR = DFHRESP(MAPFAIL)
                   MOVE 'Renseignez les champs.' TO MESS1O
               WHEN WS-CD-ERR = DFHRESP(NORMAL)
                   PERFORM CHECK
               WHEN OTHER
                   MOVE 'ERR RECEIVE' TO ERR-MESS
                   PERFORM FIN-TOTALE
           END-EVALUATE


014300     .
014400
014500
