/* Formatted on 9/9/2026 10:35:54 PM (QP5 v5.388) */
  SELECT DEPARTMENT_NAME,
         e.DEPARTMENT_ID,
         COUNT (*)                   Total_employee,
         SUM (SALARY)                TOTAL_SALARY,
         ROUND (AVG (SALARY), 2)     AVG_SALARY
    FROM EMPLOYEES e JOIN DEPARTMENTS d ON (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
--WHERE SALARY <3000

GROUP BY e.DEPARTMENT_ID, DEPARTMENT_NAME
  HAVING AVG (SALARY) < 4000;


SELECT CASE WHEN DEPARTMENT_ID IS NULL THEN 'JOB_ID' ELSE 'DEPARTMENT_ID' END
           AS GRPBY_TYPE,
       CASE
           WHEN DEPARTMENT_ID IS NULL THEN JOB_ID
           ELSE TO_CHAR (DEPARTMENT_ID)
       END
           AS G_TYPE,
       TOTAL_SALARY
  FROM (  SELECT NULL AS DEPARTMENT_ID, JOB_ID, SUM (SALARY) TOTAL_SALARY
            FROM EMPLOYEES
           WHERE DEPARTMENT_ID IN (90, 60)
        GROUP BY JOB_ID
        UNION ALL
          SELECT DEPARTMENT_ID, NULL AS JOB_ID, SUM (SALARY) TOTAL_SALARY
            FROM EMPLOYEES
           WHERE DEPARTMENT_ID IN (90, 60)
        GROUP BY DEPARTMENT_ID);


        ----Grouping SET----

  SELECT DEPARTMENT_ID, JOB_ID, SUM (SALARY) TOTAL_SALARY
    FROM EMPLOYEES
   WHERE DEPARTMENT_ID IN (90, 60)
GROUP BY GROUPING SETS ((DEPARTMENT_ID),                               --grp01
                                         (JOB_ID),                     --grp02
                                                   (  )          --grand_total
                                                       )
ORDER BY 1;


----Details Explaination----

  SELECT                                                 -- 1.Unit Column Flag
         GROUPING (department_id)
             AS g_dept,
         GROUPING (job_id)
             AS g_job,
         -- 2. Combined of multiple columns decimal ID
         GROUPING_ID (department_id, job_id)
             AS grp_id,
         -- 3. Increasing the readability of level
         CASE
             WHEN GROUPING (department_id) = 1 THEN 'All Departments'
             ELSE TO_CHAR (department_id)
         END
             AS department,
         CASE WHEN GROUPING (job_id) = 1 THEN 'All Jobs' ELSE job_id END
             AS job,
         -- 4.Aggregate Value
         SUM (salary)
             AS total_salary
    FROM hr.employees
   WHERE department_id IN (60, 90) -- for more analysis only specific two departments
GROUP BY GROUPING SETS ((department_id, job_id), ---grp00            -- Detailed Level
                        (department_id), --grp-01                      -- Dept Subtotal
                        (job_id), --grp10--2                              -- Job Subtotal
                        (  )                                    -- Grand Total
                            )
ORDER BY grp_id, department_id;


---inner Joining Ansi---

SELECT e.last_name, d.department_name
  FROM employees  e
       INNER JOIN departments d ON e.department_id = d.department_id;


---Inner Joining Legacy---

SELECT e.last_name, d.department_name
  FROM employees e, departments d
 WHERE e.department_id = d.department_id;

----Left join ANSI---

SELECT A.last_name, B.department_name
  FROM employees  A
       LEFT JOIN departments B ON A.department_id = B.department_id;


----Left join Legacy---

SELECT A.last_name, B.department_name
  FROM employees A, departments B
 WHERE A.department_id = B.department_id(+);

------ANSI---

SELECT A.last_name, B.department_name
  FROM employees  A
       RIGHT JOIN departments B ON A.department_id = B.department_id
 WHERE LAST_NAME IS NULL;


---LEGACY----

SELECT A.last_name, B.department_name
  FROM employees A, departments B
 WHERE A.department_id(+) = B.department_id;

----Findout the Product which is not in order list

SELECT o.PRODUCT_ID, p.PRODUCT_NAME
  FROM ORDERS o RIGHT JOIN PRODUCT p ON o.PRODUCT_ID = p.PRODUCT_ID
 WHERE o.PRODUCT_ID IS NULL;


SELECT A.last_name, B.department_name
  FROM employees  A
       RIGHT JOIN departments B ON A.department_id = B.department_id
 WHERE LAST_NAME IS NULL;

SELECT *
  FROM employees A
 WHERE a.DEPARTMENT_ID IN (60, 90);


SELECT A.last_name, B.department_name
  FROM employees A CROSS JOIN departments B
 WHERE a.DEPARTMENT_ID IN (60, 90);

SELECT FULL_EMPLOYEE.*
  FROM (SELECT EMPLOYEE_ID, LAST_NAME
          FROM EMPLOYEES
         WHERE JOB_ID = 'IT_PROG') IT_PROG
       JOIN (SELECT * FROM EMPLOYEES) FULL_EMPLOYEE
           ON (IT_PROG.EMPLOYEE_ID = FULL_EMPLOYEE.EMPLOYEE_ID);



  SELECT GT_10000.*, LT_10000.*
    FROM (SELECT EMPLOYEE_ID, LAST_NAME, SALARY
            FROM EMPLOYEES
           WHERE SALARY > 10000) GT_10000
         FULL OUTER JOIN (SELECT EMPLOYEE_ID, LAST_NAME, SALARY
                            FROM EMPLOYEES
                           WHERE SALARY < 10000) LT_10000
             ON (GT_10000.EMPLOYEE_ID = LT_10000.EMPLOYEE_ID)
ORDER BY GT_10000.SALARY DESC;



SELECT LAST_NAME,
       DEPARTMENT_NAME,
       STREET_ADDRESS,
       CITY
  FROM EMPLOYEES  e
       JOIN DEPARTMENTS d ON (e.DEPARTMENT_ID = d.DEPARTMENT_ID)
       JOIN LOCATIONS l ON (l.LOCATION_ID = d.LOCATION_ID);



 -- Correlated subquery: departments that have at least one employee 

SELECT d.department_name
  FROM departments d
 WHERE EXISTS
           (SELECT 1
              FROM employees e
             WHERE e.department_id = d.department_id);

             -- Equivalent JOIN, but needs DISTINCT to avoid duplicate departments 

SELECT DISTINCT d.department_name
  FROM departments d JOIN employees e ON e.department_id = d.department_id;