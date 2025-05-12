SELECT dept_name, salary, RANK
  FROM (SELECT b.DEPARTMENT_NAME                                               dept_name,
               salary,
               DENSE_RANK ()
                   OVER (PARTITION BY a.DEPARTMENT_ID ORDER BY salary DESC)    AS RANK
          FROM HR.EMPLOYEES a, HR.DEPARTMENTS b
         WHERE a.DEPARTMENT_ID = b.DEPARTMENT_ID)
         WHERE RANK IN (1,2,3)