   SELECT 
       CASE DAYOFWEEK(CURRENT DATE) 
           WHEN 1 THEN 'SUNDAY' 
           WHEN 2 THEN 'MONDAY' 
           WHEN 3 THEN 'TUESDAY' 
           WHEN 4 THEN 'WEDNESDAY' 
           WHEN 5 THEN 'THURSDAY' 
           WHEN 6 THEN 'FRIDAY' 
           WHEN 7 THEN 'SATURDAY' 
       END || ', ' || 
       CASE MONTH(CURRENT DATE) 
           WHEN 1 THEN 'JANUARY' 
           WHEN 2 THEN 'FEBRUARY' 
           WHEN 3 THEN 'MARCH' 
           WHEN 4 THEN 'APRIL' 
           WHEN 5 THEN 'MAY' 
           WHEN 6 THEN 'JUNE' 
           WHEN 7 THEN 'JULY' 
           WHEN 8 THEN 'AUGUST' 
           WHEN 9 THEN 'SEPTEMBER' 
           WHEN 10 THEN 'OCTOBER' 
           WHEN 11 THEN 'NOVEMBER' 
           WHEN 12 THEN 'DECEMBER' 
       END || ' ' || 
       VARCHAR(DAY(CURRENT DATE)) || ', ' || 
       VARCHAR(YEAR(CURRENT DATE)) 
   FROM SYSIBM.SYSDUMMY1; 