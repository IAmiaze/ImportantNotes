/* Formatted on 6/16/2023 3:45:04 PM (QP5 v5.360) */
SELECT CASE
           WHEN ROW_NUMBER ()
                    OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) =
                1
           THEN
               DEPARTMENT_NAME
           ELSE
               NULL
       END    DEPARTMENT,
       EMPLOYEE_ID,
       EMPLOYEE_NAME,
       SALARY,
       RANKS
  FROM (  SELECT a.DEPARTMENT_ID,
                 EMPLOYEE_ID,
                 FIRST_NAME                                                      EMPLOYEE_NAME,
                 b.DEPARTMENT_NAME,
                 SALARY,
                 ROW_NUMBER ()
                     OVER (PARTITION BY a.DEPARTMENT_ID ORDER BY SALARY DESC)    RANKs
            FROM HR.EMPLOYEES a, HR.DEPARTMENTS b
           WHERE a.DEPARTMENT_ID = b.DEPARTMENT_ID
        ORDER BY SALARY DESC)
 WHERE RANKS BETWEEN 1 AND 3