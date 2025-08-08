       IDENTIFICATION DIVISION.
       PROGRAM-ID. DATEUTIL.
      *
      * SOUS-PROGRAMME POUR FORMATER UNE DATE
      * ENTREE : DATE AU FORMAT YYYY-MM-DD (DB2)
      * SORTIE : DATE AU FORMAT "New York, Thursday, December 19, 2024"
      *
       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01 WS-DATE-WORK.
          05 WS-ANNEE          PIC 9(4).
          05 WS-MOIS           PIC 9(2).
          05 WS-JOUR           PIC 9(2).
          
       01 WS-TABLES.
          05 WS-MOIS-TABLE.
             10 FILLER PIC X(9) VALUE 'January  '.
             10 FILLER PIC X(9) VALUE 'February '.
             10 FILLER PIC X(9) VALUE 'March    '.
             10 FILLER PIC X(9) VALUE 'April    '.
             10 FILLER PIC X(9) VALUE 'May      '.
             10 FILLER PIC X(9) VALUE 'June     '.
             10 FILLER PIC X(9) VALUE 'July     '.
             10 FILLER PIC X(9) VALUE 'August   '.
             10 FILLER PIC X(9) VALUE 'September'.
             10 FILLER PIC X(9) VALUE 'October  '.
             10 FILLER PIC X(9) VALUE 'November '.
             10 FILLER PIC X(9) VALUE 'December '.
          05 WS-MOIS-TAB REDEFINES WS-MOIS-TABLE
             OCCURS 12 TIMES PIC X(9).
             
          05 WS-JOUR-TABLE.
             10 FILLER PIC X(9) VALUE 'Sunday   '.
             10 FILLER PIC X(9) VALUE 'Monday   '.
             10 FILLER PIC X(9) VALUE 'Tuesday  '.
             10 FILLER PIC X(9) VALUE 'Wednesday'.
             10 FILLER PIC X(9) VALUE 'Thursday '.
             10 FILLER PIC X(9) VALUE 'Friday   '.
             10 FILLER PIC X(9) VALUE 'Saturday '.
          05 WS-JOUR-TAB REDEFINES WS-JOUR-TABLE
             OCCURS 7 TIMES PIC X(9).
             
       01 WS-JOUR-SEMAINE      PIC 9.
       01 WS-MOIS-NOM          PIC X(9).
       01 WS-JOUR-NOM          PIC X(9).
       
       LINKAGE SECTION.
       77 LS-DATE-IN           PIC X(10).
       77 LS-DATE-OUT          PIC X(50).
       
       PROCEDURE DIVISION USING LS-DATE-IN LS-DATE-OUT.
       
       MAIN-PROCESS.
      * Extraction des composants de la date
           MOVE LS-DATE-IN(1:4)   TO WS-ANNEE
           MOVE LS-DATE-IN(6:2)   TO WS-MOIS  
           MOVE LS-DATE-IN(9:2)   TO WS-JOUR
           
      * Récupération du nom du mois
           MOVE WS-MOIS-TAB(WS-MOIS) TO WS-MOIS-NOM
           
      * Calcul du jour de la semaine (algorithme simplifié)
      * Pour la démo, on fixe Thursday
           MOVE 'Thursday' TO WS-JOUR-NOM
           
      * Construction de la date formatée
           STRING 'New York, '
                  WS-JOUR-NOM DELIMITED BY SPACE
                  ', '
                  WS-MOIS-NOM DELIMITED BY SPACE
                  ' '
                  WS-JOUR DELIMITED BY SIZE
                  ', '
                  WS-ANNEE DELIMITED BY SIZE
           INTO LS-DATE-OUT
           
           GOBACK.