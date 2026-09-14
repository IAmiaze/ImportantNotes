/* Formatted on 8/29/2026 10:12:59 PM (QP5 v5.388) */
----------- Group Function and Combined with Single Function-------

SELECT *
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NOT NULL;

 ----CTRL+SHIFT+F For Formatting-----


SELECT COUNT (*)                   TOTAL_EMPLOYEES,
       SUM (SALARY)                TOTAL_SALARY,
       ROUND (AVG (SALARY), 2)     AVG_SALARY
  FROM EMPLOYEES;


  SELECT e.DEPARTMENT_ID,
         DEPARTMENT_NAME,
         COUNT (*)                   TOTAL_EMPLOYEES,
         SUM (SALARY)                TOTAL_SALARY,
         ROUND (AVG (SALARY), 2)     AVG_SALARY,
         MIN (SALARY)                MIN_SALARY,
         MAX (SALARY)                MAX_SALARY
    FROM EMPLOYEES e JOIN DEPARTMENTS d ON (e.DEPARTMENT_ID = d.department_id)
GROUP BY e.DEPARTMENT_ID, DEPARTMENT_NAME
ORDER BY e.DEPARTMENT_ID, DEPARTMENT_NAME;



  SELECT ROWNUM SL_NO, FIRST_NAME, MIN (SALARY) MIN_SALARY
    FROM EMPLOYEES
GROUP BY FIRST_NAME,
         LAST_NAME,
         SALARY,
         ROWNUM
ORDER BY ROWNUM, SALARY;

---Common Misatke---

SELECT COUNT (*)                    TOTAL_EMPLOYEES,
       SUM (SALARY)                 TOTAL_SALARY,
       SUM (SALARY) / COUNT (*)     AVG_SALARY,
       AVG (SALARY)                 AVG_SALARY_FNC
  FROM EMPLOYEES;


SELECT *
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 20;

 -----When I want know Exact Number of Department include in Empoyees

SELECT COUNT (DISTINCT department_id) FROM employees;


 --------Having for Filtering Group By Function-----

  SELECT e.DEPARTMENT_ID,
         DEPARTMENT_NAME,
         COUNT (*)                   TOTAL_EMPLOYEES,
         SUM (SALARY)                TOTAL_SALARY,
         ROUND (AVG (SALARY), 2)     AVG_SALARY,
         MIN (SALARY)                MIN_SALARY,
         MAX (SALARY)                MAX_SALARY
    FROM EMPLOYEES e JOIN DEPARTMENTS d ON (e.DEPARTMENT_ID = d.department_id)
   WHERE e.DEPARTMENT_ID = 20
GROUP BY e.DEPARTMENT_ID, DEPARTMENT_NAME
  HAVING MIN (SALARY) > 3000
ORDER BY e.DEPARTMENT_ID, DEPARTMENT_NAME;

  SELECT e.DEPARTMENT_ID, DEPARTMENT_NAME, COUNT (*) TOTAL_EMPLOYEES
    FROM EMPLOYEES e JOIN DEPARTMENTS d ON (e.DEPARTMENT_ID = d.department_id)
   WHERE e.DEPARTMENT_ID = 50
GROUP BY e.DEPARTMENT_ID, DEPARTMENT_NAME;

---Block
--Header (Adddress ROWID)
----10% Future update 
------ROW DATA  
---EXISTING BLOCK (8KB)---> Update ----> 10 KB ------> Transfer ----(another new block)



