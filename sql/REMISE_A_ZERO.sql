 --   Pour les parties 1, 2, 3
 --   remet à zéro les tables


      DELETE FROM API6.ITEMS 
      WHERE O_NO IN (500, 501, 502, 503, 504, 505); 
                                                     
      DELETE FROM API6.ORDERS 
      WHERE O_NO IN (500, 501, 502, 503, 504, 505); 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = BALANCE - 231.41 
      WHERE C_NO = 4; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = BALANCE - 1216.83 
      WHERE C_NO = 3; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = BALANCE - 576.97 
      WHERE C_NO = 2; 
                                                     
      UPDATE API6.CUSTOMERS 
      SET BALANCE = BALANCE - 812.50 
      WHERE C_NO = 1; 
                                                     
      DELETE FROM PRODUCTS WHERE P_NO > 'P07'; 
                                                     
      COMMIT; 