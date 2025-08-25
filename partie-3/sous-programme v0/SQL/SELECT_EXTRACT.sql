   SELECT 
       C.COMPANY, 
       C.ADDRESS, 
       C.CITY, 
       C.ZIP, 
       C.STATE, 
       O.O_NO, 
       CHAR(O.O_DATE)           AS ODATE_ISO,     -- 'YYYY-MM-DD' 
       D.DNAME, 
       E.LNAME, 
       E.FNAME, 
       I.P_NO, 
       P.DESCRIPTION, 
       I.QUANTITY, 
       I.PRICE, 
       DECIMAL(I.QUANTITY * I.PRICE, 7, 2) AS LINE_TOTAL 
   FROM 
       API6.ORDERS O 
       INNER JOIN API6.CUSTOMERS C ON O.C_NO = C.C_NO 
       INNER JOIN API6.EMPLOYEES E ON O.S_NO = E.E_NO 
       INNER JOIN API6.DEPTS     D ON E.DEPT = D.DEPT 
       INNER JOIN API6.ITEMS     I ON O.O_NO = I.O_NO 
       INNER JOIN API6.PRODUCTS  P ON I.P_NO = P.P_NO 
   ORDER BY 
       O.O_NO, I.P_NO; 
                                                                    