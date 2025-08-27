      * a mettre dans API4.SOURCE.COPY
       01 DFHCOMMAREA.
           05 XCTL-DATA.
                10 SECURE-ACCESS  PIC 9 .
           05 TRANSID-PART.
                10 LK-ID          PIC X(2).
                10 LK-NOM         PIC X(30).
                10 LK-COULEUR     PIC X(20).
                10 LK-POIDS       PIC S9(2) COMP-3.
                10 LK-VILLE       PIC X(20).
                10 LK-MESSAGE     PIC X(60).
                10 LK-MSG-COL     PIC X.
           05 TRANSID-CONX.
               10 LK-LOGIN        PIC X(5).
               10 LK-PWD          PIC X(15).
               10 LK-MESSAGE-CNX  PIC X(60).
               10 LK-MSG-COL-CNX  PIC X.
