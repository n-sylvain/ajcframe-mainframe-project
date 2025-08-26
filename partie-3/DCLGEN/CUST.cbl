      ******************************************************************
      * DCLGEN TABLE(API6.CUSTOMERS)                                   *
      *        LIBRARY(API6.SOURCE.DCLGEN(CUST))                       *
      *        LANGUAGE(COBOL)                                         *
      *        NAMES(CUST-)                                            *
      *        STRUCTURE(ST-CUST)                                      *
      *        QUOTE                                                   *
      *        COLSUFFIX(YES)                                          *
      *        INDVAR(YES)                                             *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
           EXEC SQL DECLARE API6.CUSTOMERS TABLE
           ( C_NO                           DECIMAL(4, 0) NOT NULL,
             COMPANY                        VARCHAR(30) NOT NULL,
             ADDRESS                        VARCHAR(100),
             CITY                           VARCHAR(20) NOT NULL,
             STATE                          CHAR(2) NOT NULL,
             ZIP                            CHAR(5) NOT NULL,
             PHONE                          CHAR(10),
             BALANCE                        DECIMAL(10, 2)
           ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE API6.CUSTOMERS                     *
      ******************************************************************
       01  ST-CUST.
      *                       C_NO
           10 CUST-C-NO            PIC S9(4)V USAGE COMP-3.
           10 CUST-COMPANY.
      *                       COMPANY LENGTH
              49 CUST-COMPANY-LEN  PIC S9(4) USAGE COMP.
      *                       COMPANY
              49 CUST-COMPANY-TEXT  PIC X(30).
           10 CUST-ADDRESS.
      *                       ADDRESS LENGTH
              49 CUST-ADDRESS-LEN  PIC S9(4) USAGE COMP.
      *                       ADDRESS
              49 CUST-ADDRESS-TEXT  PIC X(100).
           10 CUST-CITY.
      *                       CITY LENGTH
              49 CUST-CITY-LEN     PIC S9(4) USAGE COMP.
      *                       CITY
              49 CUST-CITY-TEXT    PIC X(20).
      *                       STATE
           10 CUST-STATE           PIC X(2).
      *                       ZIP
           10 CUST-ZIP             PIC X(5).
      *                       PHONE
           10 CUST-PHONE           PIC X(10).
      *                       BALANCE
           10 CUST-BALANCE         PIC S9(8)V9(2) USAGE COMP-3.
      ******************************************************************
      * INDICATOR VARIABLE STRUCTURE                                   *
      ******************************************************************
       01  ICUSTOMERS.
           10 INDSTRUC           PIC S9(4) USAGE COMP OCCURS 8 TIMES.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 8       *
      ******************************************************************
