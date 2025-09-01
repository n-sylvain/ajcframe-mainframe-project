      ******************************************************************
      * DCLGEN TABLE(API6.ITEMS)                                       *
      *        LIBRARY(API6.SOURCE.DCLGEN(ITEM))                       *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(ITEM-)                                            *
      *        STRUCTURE(ST-ITEM)                                      *
      *        QUOTE                                                   *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE API6.ITEMS TABLE
           ( O_NO                           DECIMAL(3, 0) NOT NULL,
             P_NO                           CHAR(3) NOT NULL,
             QUANTITY                       DECIMAL(2, 0) NOT NULL,
             PRICE                          DECIMAL(5, 2) NOT NULL
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE API6.ITEMS                         *
      ******************************************************************
       01  ST-ITEM.
      *                       O_NO
           10 ITEM-O-NO            PIC S9(3)V USAGE COMP-3.
      *                       P_NO
           10 ITEM-P-NO            PIC X(3).
      *                       QUANTITY
           10 ITEM-QUANTITY        PIC S9(2)V USAGE COMP-3.
      *                       PRICE
           10 ITEM-PRICE           PIC S9(3)V9(2) USAGE COMP-3.
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  IITEMS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 4 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 4       *
      ******************************************************************
