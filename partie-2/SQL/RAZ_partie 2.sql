 --   Pour les parties 1, 2, 3
 --   remet à l'origine les tables
                                                     
      DELETE FROM API6.ITEMS 
      WHERE O_NO IN (500, 501, 502, 503, 504, 505); 
                                                     
      DELETE FROM API6.ORDERS 
      WHERE O_NO IN (500, 501, 502, 503, 504, 505); 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 1500.00 
      WHERE C_NO = 1; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 2500.50 
      WHERE C_NO = 2; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 1800.75 
      WHERE C_NO = 3; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 3200.25 
      WHERE C_NO = 4; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = 2000.00 
      WHERE C_NO = 5; 
                                                     
      COMMIT; 