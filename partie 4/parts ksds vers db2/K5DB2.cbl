       IDENTIFICATION DIVISION.
       PROGRAM-ID. K5DB2.

       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PARTK ASSIGN FPARTK
           ORGANIZATION IS INDEXED
           ACCESS MODE IS SEQUENTIAL
           RECORD KEY IS ID-PARTK
           FILE STATUS IS FS-PARTK.


       DATA DIVISION.
       FILE SECTION.
       FD PARTK.
       01 ENR-PARTK.
           05 ID-PARTK         PIC X(2).
           05 NOM-PARTK        PIC X(30).
           05 COULEUR-PARTK    PIC X(20).
           05 POIDS-PARTK      PIC S9(2)V COMP-3.
           05 VILLE-PARTK      PIC X(20).

       WORKING-STORAGE SECTION.

      * INCLUSION DU DCLGEN PARTS
           EXEC SQL
               INCLUDE PARTS
           END-EXEC.

           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.



       77 FS-PARTK             PIC 99.
       77 WS-ANO               PIC 9 VALUE ZERO.

       PROCEDURE DIVISION.

           OPEN INPUT PARTK
           IF FS-PARTK NOT EQUAL ZERO THEN
                DISPLAY 'ERR OPEN - FS-PARTK : ' FS-PARTK
                PERFORM ABEND-PROG
           END-IF



           PERFORM UNTIL FS-PARTK NOT EQUAL ZERO
               PERFORM READ-P
           END-PERFORM

           IF FS-PARTK NOT EQUAL 10 AND NOT EQUAL 0
                DISPLAY 'ERR READ - FS-PARTK : ' FS-PARTK
                PERFORM ABEND-PROG
           END-IF

           CLOSE PARTK
           IF FS-PARTK NOT EQUAL ZERO THEN
                DISPLAY 'ERR CLOSE - FS-PARTK : ' FS-PARTK
                PERFORM ABEND-PROG
           END-IF

           GOBACK.


       READ-P.

           READ PARTK
            AT END
               DISPLAY 'END OF FILE - FS-PARTK : '  FS-PARTK
            NOT AT END
                PERFORM INSRT
           .

       INSRT.


           MOVE ID-PARTK TO PARTPNO
           MOVE NOM-PARTK TO PARTPNAME-TEXT
           MOVE COULEUR-PARTK TO PARTCOLOR-TEXT
           MOVE POIDS-PARTK TO PARTWEIGHT
           MOVE VILLE-PARTK TO PARTCITY-TEXT


           MOVE LENGTH OF NOM-PARTK TO PARTPNAME-LEN
           MOVE LENGTH OF COULEUR-PARTK TO PARTCOLOR-LEN
           MOVE LENGTH OF VILLE-PARTK TO PARTCITY-LEN




           EXEC SQL
            INSERT INTO API4.PARTS (PNO, PNAME, COLOR, WEIGHT, CITY)
            VALUES (:PARTPNO, :PARTPNAME, :PARTCOLOR,
            :PARTWEIGHT, :PARTCITY)
           END-EXEC.

           EVALUATE TRUE
            WHEN SQLCODE = 0
                DISPLAY "INSERT - ID : " ID-PARTK
            WHEN SQLCODE = -803
                DISPLAY "ERR ALREADY IN TABLE - ID : " ID-PARTK
            WHEN OTHER
                DISPLAY "ERR SQL : " SQLCODE
                DISPLAY 'SQLERRMC : ' SQLERRMC
                DISPLAY 'SQLERRP : ' SQLERRP
                DISPLAY PARTPNO ' _ ' PARTPNAME  ' _ '  PARTCOLOR  ' _ '
                PARTWEIGHT ' _ ' PARTCITY
           END-EVALUATE
           .

       ABEND-PROG.
           DISPLAY '---- ABEND-PROG ----'
           COMPUTE WS-ANO = 1 / WS-ANO
           .
