      ******************************************************************
      * DCLGEN TABLE(API6.DEPTS)                                       *
      *        LIBRARY(API6.SOURCE.DCLGEN(DEPT))                       *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(DEPT-)                                            *
      *        STRUCTURE(ST-DEPT)                                      *
      *        QUOTE                                                   *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE API6.DEPTS TABLE
           ( DEPT                           DECIMAL(4, 0) NOT NULL,
             DNAME                          VARCHAR(20) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE API6.DEPTS                         *
      ******************************************************************
       01  ST-DEPT.
      *                       DEPT
           10 DEPT-DEPT            PIC S9(4)V USAGE COMP-3.
           10 DEPT-DNAME.
      *                       DNAME LENGTH
              49 DEPT-DNAME-LEN    PIC S9(4) USAGE COMP.
      *                       DNAME
              49 DEPT-DNAME-TEXT   PIC X(20).
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  IDEPTS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 2 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 2       *
      ******************************************************************
