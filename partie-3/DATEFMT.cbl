       IDENTIFICATION DIVISION. 
       PROGRAM-ID. DATEFMT.

       ENVIRONMENT DIVISION. 

       DATA DIVISION. 
       WORKING-STORAGE SECTION. 

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01 WS-DATE-INPUT      PIC  X(10).
       01 WS-DATE-FORMATTED  PIC  X(40).

       PROCEDURE DIVISION.

           DISPLAY 'Entrer une date (YYY-MM-DD) : '
           ACCEPT WS-DATE-INPUT

           EXEC SQL 
              SELECT VARCHAR_FORMAT(
                 DATE(:WS-DATE-INPUT),
                 'Day, Month DD, YYY'
              )
              INTO :WS-DATE-FORMATTED
              FROM SYSIBM.SYSDUMMY1
           END-EXEC

           IF SQLCODE = 0
              DISPLAY 'Date formatée : ' WS-DATE-FORMATTED
           ELSE
              DISPLAY "Eurreur SQL : " SQLCODE
           END-IF

           STOP RUN.