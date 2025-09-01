      ******************************************************************
      * DCLGEN TABLE(API6.PRODUCTS)                                    *
      *        LIBRARY(API6.SOURCE.DCLGEN(PROD))                       *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(PROD-)                                            *
      *        STRUCTURE(ST-PROD)                                      *
      *        QUOTE                                                   *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE API6.PRODUCTS TABLE
           ( P_NO                           CHAR(3) NOT NULL,
             DESCRIPTION                    VARCHAR(30) NOT NULL,
             PRICE                          DECIMAL(5, 2) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE API6.PRODUCTS                      *
      ******************************************************************
       01  ST-PROD.
      *                       P_NO
           10 PROD-P-NO            PIC X(3).
           10 PROD-DESCRIPTION.
      *                       DESCRIPTION LENGTH
              49 PROD-DESCRIPTION-LEN  PIC S9(4) USAGE COMP.
      *                       DESCRIPTION
              49 PROD-DESCRIPTION-TEXT  PIC X(30).
      *                       PRICE
           10 PROD-PRICE           PIC S9(3)V9(2) USAGE COMP-3.
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  IPRODUCTS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 3 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 3       *
      ******************************************************************
