/* Formatted on 8/30/2026 1:11:30 PM (QP5 v5.388) */
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
GROUP BY GROUPING SETS ((department_id, job_id),             -- Detailed Level
                        (department_id),                      -- Dept Subtotal
                        (job_id),                              -- Job Subtotal
                        (  )                                    -- Grand Total
                            )
ORDER BY grp_id, department_id;



  SELECT NULL AS JOB_ID, DEPARTMENT_ID, SUM (SALARY) TOTAL_SALARY
    FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
UNION ALL
  SELECT JOB_ID, NULL AS DEPARTMENT_ID, SUM (SALARY) TOTAL_SALARY
    FROM EMPLOYEES
GROUP BY JOB_ID;

   ----Avoid This we can use below query--



  SELECT GROUPING (JOB_ID)                      AS g_job,
         GROUPING (DEPARTMENT_ID)               AS g_dept,
         GROUPING_ID (JOB_ID, DEPARTMENT_ID)    AS grp_id,
         CASE
             WHEN GROUPING (JOB_ID) = 1 THEN 'All jobs'
             ELSE TO_CHAR (JOB_ID)
         END                                    AS JOBS,
         CASE
             WHEN GROUPING (DEPARTMENT_ID) = 1 THEN 'All Departments'
             ELSE TO_CHAR (DEPARTMENT_ID)
         END                                    AS Department,
         JOB_ID,
         DEPARTMENT_ID,
         SUM (SALARY)                           AS total_salary
    FROM EMPLOYEES
GROUP BY GROUPING SETS ((JOB_ID, DEPARTMENT_ID),               ---01:Group_000
                        (JOB_ID),                              ---02:Group_001
                        (DEPARTMENT_ID),                       ---03:Group_002
                        (  )                                 ---04:Grand Total
                            );



  SELECT GROUPING (department_id)
             AS dept_grp,
         GROUPING (job_id)
             AS job_grp,
         -- GROUPING = 1 ??? 'All Departments' ??????
         CASE
             WHEN GROUPING (department_id) = 1 THEN 'All Departments'
             ELSE TO_CHAR (department_id)
         END
             AS department,
         -- GROUPING = 1 ??? 'All Jobs' ??????
         CASE WHEN GROUPING (job_id) = 1 THEN 'All Jobs' ELSE job_id END
             AS job,
         SUM (salary)
             AS total_salary
    FROM hr.employees
GROUP BY GROUPING SETS ((department_id, job_id),
                        (department_id),
                        (job_id),
                        (  ));

  SELECT GROUPING_ID (department_id, job_id)     AS grp_id,
         department_id,
         job_id,
         SUM (salary)                            AS total_salary
    FROM hr.employees
GROUP BY GROUPING SETS ((department_id, job_id),                 -- GRP_ID = 0
                        (department_id),                         -- GRP_ID = 1
                        (job_id),                                -- GRP_ID = 2
                        (  )                                     -- GRP_ID = 3
                            )
  HAVING GROUPING_ID (department_id, job_id) IN (1, 3);