/* Formatted on 9/13/2026 9:24:06 PM (QP5 v5.388) */


SELECT FIRST_NAME,
       LAST_NAME,
       SALARY,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS WHERE DEPARTMENT_ID = e.DEPARTMENT_ID)    INLINE_SUBQUERY,
       CORSQ.DEPARTMENT_ID
  FROM EMPLOYEES  e 
       JOIN                                                    ---CORRELATED--
            (SELECT DEPARTMENT_NAME, DEPARTMENT_ID
               FROM DEPARTMENTS
              WHERE DEPARTMENT_ID IN (40, 50)) CORSQ
           ON (e.DEPARTMENT_ID = CORSQ.DEPARTMENT_ID);

--------------------------------

SELECT last_name, salary,job_id
  FROM employees
 WHERE salary > ALL (SELECT salary
                       FROM employees
                      WHERE job_id = 'IT_PROG');


/* Formatted on 9/13/2026 9:24:06 PM (QP5 v5.388) */


SELECT FIRST_NAME,
       LAST_NAME,
       SALARY,
       (SELECT DEPARTMENT_NAME FROM DEPARTMENTS WHERE DEPARTMENT_ID = e.DEPARTMENT_ID)    INLINE_SUBQUERY,
       CORSQ.DEPARTMENT_ID
  FROM EMPLOYEES  e 
       JOIN                                                    ---CORRELATED--
            (SELECT DEPARTMENT_NAME, DEPARTMENT_ID
               FROM DEPARTMENTS
              WHERE DEPARTMENT_ID IN (40, 50)) CORSQ
           ON (e.DEPARTMENT_ID = CORSQ.DEPARTMENT_ID);


--- Departments with at least one employee 
SELECT d.department_name 
FROM departments d 
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id); 

 -- Departments with NO employees 
SELECT d.department_name 
FROM departments d 
WHERE NOT EXISTS (SELECT 1 FROM employees e WHERE e.department_id = d.department_id); 
------------
SELECT a.POINT_CODE, a.POINT_NAME, a.LOCATION_TYPE, a.AGENT_GENDER,
       a.AS_ON_SAVINGS_AC_NUMBER_OF_AC_MALE, a.AS_ON_SAVINGS_AC_BALANCE_MALE,
       a.AS_ON_SAVINGS_AC_NUMBER_OF_AC_FEMALE, a.AS_ON_SAVINGS_AC_BALANCE_FEMALE,
       a.AS_ON_CURRENT_AC_NUMBER_OF_AC_FEMALE, a.AS_ON_CURRENT_AC_BALANCE_FEMALE,
       a.AS_ON_CURRENT_AC_NUMBER_OF_AC_MALE, a.AS_ON_CURRENT_AC_BALANCE_MALE,
       a.AS_ON_SND_AC_NUMBER_OF_AC_MALE, a.AS_ON_SND_AC_BALANCE_MALE,
       a.AS_ON_SND_AC_NUMBER_OF_AC_FEMALE, a.AS_ON_SND_AC_BALANCE_FEMALE,
       a.AS_ON_SB_AC_NUMBER_OF_AC_MALE, a.AS_ON_SB_AC_BALANCE_MALE,
       a.AS_ON_SB_AC_NUMBER_OF_AC_FEMALE, a.AS_ON_SB_AC_BALANCE_FEMALE,
       a.AS_ON_SDS_AC_NUMBER_OF_AC_MALE, a.AS_ON_SDS_AC_BALANCE_MALE,
       a.AS_ON_SDS_AC_NUMBER_OF_AC_FEMALE, a.AS_ON_SDS_AC_BALANCE_FEMALE,
       a.AS_ON_FDR_AC_NUMBER_OF_AC_MALE, a.AS_ON_FDR_AC_BALANCE_MALE,
       a.AS_ON_FDR_AC_NUMBER_OF_AC_FEMALE, a.AS_ON_FDR_AC_BALANCE_FEMALE,
       d.CURRENT_MONTH_NUMBER_OF_CLOSED_AC,
       b.CURRENT_MONTH_SAVINGS_AC_NUMBER_OF_AC_MALE, b.CURRENT_MONTH_SAVINGS_AC_BALANCE_MALE,
       b.CURRENT_MONTH_SAVINGS_AC_NUMBER_OF_AC_FEMALE, b.CURRENT_MONTH_SAVINGS_AC_BALANCE_FEMALE,
       b.CURRENT_MONTH_CURRENT_AC_NUMBER_OF_AC_FEMALE, b.CURRENT_MONTH_CURRENT_AC_BALANCE_FEMALE,
       b.CURRENT_MONTH_CURRENT_AC_NUMBER_OF_AC_MALE, b.CURRENT_MONTH_CURRENT_AC_BALANCE_MALE,
       b.CURRENT_MONTH_SND_AC_NUMBER_OF_AC_MALE, b.CURRENT_MONTH_SND_AC_BALANCE_MALE,
       b.CURRENT_MONTH_SND_AC_NUMBER_OF_AC_FEMALE, b.CURRENT_MONTH_SND_AC_BALANCE_FEMALE,
       b.CURRENT_MONTH_SB_AC_NUMBER_OF_AC_MALE, b.CURRENT_MONTH_SB_AC_BALANCE_MALE,
       b.CURRENT_MONTH_SB_AC_NUMBER_OF_AC_FEMALE, b.CURRENT_MONTH_SB_AC_BALANCE_FEMALE,
       b.CURRENT_MONTH_SDS_AC_NUMBER_OF_AC_MALE, b.CURRENT_MONTH_SDS_AC_BALANCE_MALE,
       b.CURRENT_MONTH_SDS_AC_NUMBER_OF_AC_FEMALE, b.CURRENT_MONTH_SDS_AC_BALANCE_FEMALE,
       b.CURRENT_MONTH_FDR_AC_NUMBER_OF_AC_MALE, b.CURRENT_MONTH_FDR_AC_BALANCE_MALE,
       b.CURRENT_MONTH_FDR_AC_NUMBER_OF_AC_FEMALE, b.CURRENT_MONTH_FDR_AC_BALANCE_FEMALE,
       c.DEPOSIT_COUNT, c.WITHDRAW_COUNT, c.TRANSFER_COUNT,
       c.DEPOSIT_AMOUNT, c.WITHDRAW_AMOUNT, c.TRANSFER_AMOUNT,
       c.WITHDRAW_COUNT_MALE, c.WITHDRAW_COUNT_FEMALE,
       c.WITHDRAW_AMOUNT_MALE, c.WITHDRAW_AMOUNT_FEMALE,
       c.TRANSFER_COUNT_MALE, c.TRANSFER_COUNT_FEMALE,
       c.TRANSFER_AMOUNT_MALE, c.TRANSFER_AMOUNT_FEMALE
  FROM (  SELECT POINT_CODE, POINT_NAME, LOCATION_TYPE, AGENT_GENDER,
                 SUM(SAVINGS_AC_NUMBER_OF_AC_MALE) AS_ON_SAVINGS_AC_NUMBER_OF_AC_MALE, SUM(SAVINGS_AC_BALANCE_MALE) AS_ON_SAVINGS_AC_BALANCE_MALE,
                 SUM(SAVINGS_AC_NUMBER_OF_AC_FEMALE) AS_ON_SAVINGS_AC_NUMBER_OF_AC_FEMALE, SUM(SAVINGS_AC_BALANCE_FEMALE) AS_ON_SAVINGS_AC_BALANCE_FEMALE,
                 SUM(CURRENT_AC_NUMBER_OF_AC_FEMALE) AS_ON_CURRENT_AC_NUMBER_OF_AC_FEMALE, SUM(CURRENT_AC_BALANCE_FEMALE) AS_ON_CURRENT_AC_BALANCE_FEMALE,
                 SUM(CURRENT_AC_NUMBER_OF_AC_MALE) AS_ON_CURRENT_AC_NUMBER_OF_AC_MALE, SUM(CURRENT_AC_BALANCE_MALE) AS_ON_CURRENT_AC_BALANCE_MALE,
                 SUM(SND_AC_NUMBER_OF_AC_MALE) AS_ON_SND_AC_NUMBER_OF_AC_MALE, SUM(SND_AC_BALANCE_MALE) AS_ON_SND_AC_BALANCE_MALE,
                 SUM(SND_AC_NUMBER_OF_AC_FEMALE) AS_ON_SND_AC_NUMBER_OF_AC_FEMALE, SUM(SND_AC_BALANCE_FEMALE) AS_ON_SND_AC_BALANCE_FEMALE,
                 SUM(SB_AC_NUMBER_OF_AC_MALE) AS_ON_SB_AC_NUMBER_OF_AC_MALE, SUM(SB_AC_BALANCE_MALE) AS_ON_SB_AC_BALANCE_MALE,
                 SUM(SB_AC_NUMBER_OF_AC_FEMALE) AS_ON_SB_AC_NUMBER_OF_AC_FEMALE, SUM(SB_AC_BALANCE_FEMALE) AS_ON_SB_AC_BALANCE_FEMALE,
                 SUM(SDS_AC_NUMBER_OF_AC_MALE) AS_ON_SDS_AC_NUMBER_OF_AC_MALE, SUM(SDS_AC_BALANCE_MALE) AS_ON_SDS_AC_BALANCE_MALE,
                 SUM(SDS_AC_NUMBER_OF_AC_FEMALE) AS_ON_SDS_AC_NUMBER_OF_AC_FEMALE, SUM(SDS_AC_BALANCE_FEMALE) AS_ON_SDS_AC_BALANCE_FEMALE,
                 SUM(FDR_AC_NUMBER_OF_AC_MALE) AS_ON_FDR_AC_NUMBER_OF_AC_MALE, SUM(FDR_AC_BALANCE_MALE) AS_ON_FDR_AC_BALANCE_MALE,
                 SUM(FDR_AC_NUMBER_OF_AC_FEMALE) AS_ON_FDR_AC_NUMBER_OF_AC_FEMALE, SUM(FDR_AC_BALANCE_FEMALE) AS_ON_FDR_AC_BALANCE_FEMALE
            FROM (SELECT POINT_CODE, POINT_NAME, LOCATION_TYPE, AGENT_GENDER,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SAVINGS_AC' THEN NUMBER_OF_AC ELSE 0 END SAVINGS_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SAVINGS_AC' THEN NUMBER_OF_AC ELSE 0 END SAVINGS_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='CURRENT_AC' THEN NUMBER_OF_AC ELSE 0 END CURRENT_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='CURRENT_AC' THEN NUMBER_OF_AC ELSE 0 END CURRENT_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SND_AC'     THEN NUMBER_OF_AC ELSE 0 END SND_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SND_AC'     THEN NUMBER_OF_AC ELSE 0 END SND_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SB_AC'      THEN NUMBER_OF_AC ELSE 0 END SB_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SB_AC'      THEN NUMBER_OF_AC ELSE 0 END SB_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SDS_AC'     THEN NUMBER_OF_AC ELSE 0 END SDS_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SDS_AC'     THEN NUMBER_OF_AC ELSE 0 END SDS_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='FDR_AC'     THEN NUMBER_OF_AC ELSE 0 END FDR_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='FDR_AC'     THEN NUMBER_OF_AC ELSE 0 END FDR_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SAVINGS_AC' THEN BALANCE ELSE 0 END SAVINGS_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SAVINGS_AC' THEN BALANCE ELSE 0 END SAVINGS_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='CURRENT_AC' THEN BALANCE ELSE 0 END CURRENT_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='CURRENT_AC' THEN BALANCE ELSE 0 END CURRENT_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SND_AC'     THEN BALANCE ELSE 0 END SND_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SND_AC'     THEN BALANCE ELSE 0 END SND_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SB_AC'      THEN BALANCE ELSE 0 END SB_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SB_AC'      THEN BALANCE ELSE 0 END SB_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SDS_AC'     THEN BALANCE ELSE 0 END SDS_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SDS_AC'     THEN BALANCE ELSE 0 END SDS_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='FDR_AC'     THEN BALANCE ELSE 0 END FDR_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='FDR_AC'     THEN BALANCE ELSE 0 END FDR_AC_BALANCE_FEMALE
                    FROM (SELECT POINT_CODE, POINT_NAME, LOCATION_TYPE,
                                 DECODE((SELECT AGN_TYPE FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID),
                                        'INS',(SELECT GENDER FROM EMOB.MB_AGENT_OWNER_MST WHERE CUST_CODE=(SELECT CUST_CODE FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID) AND ROWNUM=1),
                                        (SELECT GENDER FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID)) AGENT_GENDER,
                                 AC_TYPE, AC_GENDER, NUMBER_OF_AC, BALANCE
                            FROM (  SELECT c.POINT_CODE, c.POINT_NAME, c.LOCATION_TYPE, c.AGENT_ID,
                                           CASE WHEN pm.DEP_NATURE='R' AND pm.CATEGORY='S' THEN 'SAVINGS_AC'
                                                WHEN pm.DEP_NATURE='R' AND pm.CATEGORY='C' THEN 'CURRENT_AC'
                                                WHEN pm.DEP_NATURE='R' AND pm.CATEGORY='N' THEN 'SND_AC'
                                                WHEN pm.DEP_NATURE='F' AND pm.CATEGORY='F' THEN 'FDR_AC'
                                                WHEN pm.DEP_NATURE='C' AND pm.CATEGORY='D' THEN 'SDS_AC'
                                                WHEN pm.DEP_NATURE='R' AND pm.CATEGORY='M' THEN 'SB_AC' END AC_TYPE,
                                           d.GENDER AC_GENDER, COUNT(a.ac_no) NUMBER_OF_AC, SUM(a.BALANCE) BALANCE
                                      FROM emob.MB_ACCOUNT_BALANCE_DATA a, EMOB.MB_ACCOUNT_MST b,
                                           EMOB.ST_AGENT_POINT c, EMOB.MB_CUSTOMER_MST d, EMOB.MB_PRODUCT_MST pm
                                     WHERE a.ac_no=b.ac_no AND b.cust_no=d.cust_no AND b.POINT_ID=c.POINT_ID
                                       AND b.AC_TYPE_ID=pm.AC_TYPE_ID AND pm.AC_TYPE_ID<>8
                                       AND a.MONTH_CODE=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')
                                       AND a.ac_no IN (SELECT AC_NO FROM EMOB.MB_ACCOUNT_MST WHERE AC_NO IN
                                                       (SELECT DISTINCT AC_NO FROM EMOB.MB_ACCOUNT_BALANCE_DATA
                                                         WHERE TO_CHAR(OPEN_DATE,'RRRRMM')<=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')))
                                  GROUP BY c.POINT_CODE,c.POINT_NAME,c.AGENT_ID,d.GENDER,b.ac_type,c.LOCATION_TYPE,pm.DEP_NATURE,pm.CATEGORY
                                  ORDER BY c.POINT_CODE)
                          UNION ALL
                          SELECT POINT_CODE, POINT_NAME, LOCATION_TYPE,
                                 DECODE((SELECT AGN_TYPE FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID),
                                        'INS',(SELECT GENDER FROM EMOB.MB_AGENT_OWNER_MST WHERE CUST_CODE=(SELECT CUST_CODE FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID) AND ROWNUM=1),
                                        (SELECT GENDER FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID)) AGENT_GENDER,
                                 NULL AC_TYPE, NULL AC_GENDER, 0 NUMBER_OF_AC, 0 BALANCE
                            FROM EMOB.ST_AGENT_POINT
                           WHERE POINT_CODE NOT IN
                                 (SELECT DISTINCT POINT_CODE FROM
                                  (  SELECT c.POINT_CODE,c.POINT_NAME,c.LOCATION_TYPE,c.AGENT_ID,b.ac_type,
                                            d.GENDER AC_GENDER,COUNT(a.ac_no) NUMBER_OF_AC,SUM(a.BALANCE) BALANCE
                                       FROM emob.MB_ACCOUNT_BALANCE_DATA a,EMOB.MB_ACCOUNT_MST b,
                                            EMOB.ST_AGENT_POINT c,EMOB.MB_CUSTOMER_MST d
                                      WHERE a.ac_no=b.ac_no AND b.cust_no=d.cust_no AND b.POINT_ID=c.POINT_ID
                                        AND a.MONTH_CODE=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')
                                        AND a.ac_no IN (SELECT AC_NO FROM EMOB.MB_ACCOUNT_MST WHERE AC_NO IN
                                                        (SELECT DISTINCT AC_NO FROM EMOB.MB_ACCOUNT_BALANCE_DATA
                                                          WHERE TO_CHAR(OPEN_DATE,'RRRRMM')<=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')))
                                  GROUP BY c.POINT_CODE,c.POINT_NAME,c.AGENT_ID,d.GENDER,b.ac_type,c.LOCATION_TYPE
                                  ORDER BY c.POINT_CODE))
                             AND STATUS='A' AND TO_CHAR(APPROVED_DATE,'RRRRMM')<=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')))
        GROUP BY POINT_CODE,POINT_NAME,LOCATION_TYPE,AGENT_GENDER) a,
       (  SELECT POINT_CODE,
                 SUM(SAVINGS_AC_NUMBER_OF_AC_MALE) CURRENT_MONTH_SAVINGS_AC_NUMBER_OF_AC_MALE, SUM(SAVINGS_AC_BALANCE_MALE) CURRENT_MONTH_SAVINGS_AC_BALANCE_MALE,
                 SUM(SAVINGS_AC_NUMBER_OF_AC_FEMALE) CURRENT_MONTH_SAVINGS_AC_NUMBER_OF_AC_FEMALE, SUM(SAVINGS_AC_BALANCE_FEMALE) CURRENT_MONTH_SAVINGS_AC_BALANCE_FEMALE,
                 SUM(CURRENT_AC_NUMBER_OF_AC_FEMALE) CURRENT_MONTH_CURRENT_AC_NUMBER_OF_AC_FEMALE, SUM(CURRENT_AC_BALANCE_FEMALE) CURRENT_MONTH_CURRENT_AC_BALANCE_FEMALE,
                 SUM(CURRENT_AC_NUMBER_OF_AC_MALE) CURRENT_MONTH_CURRENT_AC_NUMBER_OF_AC_MALE, SUM(CURRENT_AC_BALANCE_MALE) CURRENT_MONTH_CURRENT_AC_BALANCE_MALE,
                 SUM(SND_AC_NUMBER_OF_AC_MALE) CURRENT_MONTH_SND_AC_NUMBER_OF_AC_MALE, SUM(SND_AC_BALANCE_MALE) CURRENT_MONTH_SND_AC_BALANCE_MALE,
                 SUM(SND_AC_NUMBER_OF_AC_FEMALE) CURRENT_MONTH_SND_AC_NUMBER_OF_AC_FEMALE, SUM(SND_AC_BALANCE_FEMALE) CURRENT_MONTH_SND_AC_BALANCE_FEMALE,
                 SUM(SB_AC_NUMBER_OF_AC_MALE) CURRENT_MONTH_SB_AC_NUMBER_OF_AC_MALE, SUM(SB_AC_BALANCE_MALE) CURRENT_MONTH_SB_AC_BALANCE_MALE,
                 SUM(SB_AC_NUMBER_OF_AC_FEMALE) CURRENT_MONTH_SB_AC_NUMBER_OF_AC_FEMALE, SUM(SB_AC_BALANCE_FEMALE) CURRENT_MONTH_SB_AC_BALANCE_FEMALE,
                 SUM(SDS_AC_NUMBER_OF_AC_MALE) CURRENT_MONTH_SDS_AC_NUMBER_OF_AC_MALE, SUM(SDS_AC_BALANCE_MALE) CURRENT_MONTH_SDS_AC_BALANCE_MALE,
                 SUM(SDS_AC_NUMBER_OF_AC_FEMALE) CURRENT_MONTH_SDS_AC_NUMBER_OF_AC_FEMALE, SUM(SDS_AC_BALANCE_FEMALE) CURRENT_MONTH_SDS_AC_BALANCE_FEMALE,
                 SUM(FDR_AC_NUMBER_OF_AC_MALE) CURRENT_MONTH_FDR_AC_NUMBER_OF_AC_MALE, SUM(FDR_AC_BALANCE_MALE) CURRENT_MONTH_FDR_AC_BALANCE_MALE,
                 SUM(FDR_AC_NUMBER_OF_AC_FEMALE) CURRENT_MONTH_FDR_AC_NUMBER_OF_AC_FEMALE, SUM(FDR_AC_BALANCE_FEMALE) CURRENT_MONTH_FDR_AC_BALANCE_FEMALE
            FROM (SELECT POINT_CODE, POINT_NAME, LOCATION_TYPE, AGENT_GENDER,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SAVINGS_AC' THEN NUMBER_OF_AC ELSE 0 END SAVINGS_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SAVINGS_AC' THEN NUMBER_OF_AC ELSE 0 END SAVINGS_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='CURRENT_AC' THEN NUMBER_OF_AC ELSE 0 END CURRENT_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='CURRENT_AC' THEN NUMBER_OF_AC ELSE 0 END CURRENT_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SND_AC'     THEN NUMBER_OF_AC ELSE 0 END SND_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SND_AC'     THEN NUMBER_OF_AC ELSE 0 END SND_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SB_AC'      THEN NUMBER_OF_AC ELSE 0 END SB_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SB_AC'      THEN NUMBER_OF_AC ELSE 0 END SB_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SDS_AC'     THEN NUMBER_OF_AC ELSE 0 END SDS_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SDS_AC'     THEN NUMBER_OF_AC ELSE 0 END SDS_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='FDR_AC'     THEN NUMBER_OF_AC ELSE 0 END FDR_AC_NUMBER_OF_AC_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='FDR_AC'     THEN NUMBER_OF_AC ELSE 0 END FDR_AC_NUMBER_OF_AC_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SAVINGS_AC' THEN BALANCE ELSE 0 END SAVINGS_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SAVINGS_AC' THEN BALANCE ELSE 0 END SAVINGS_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='CURRENT_AC' THEN BALANCE ELSE 0 END CURRENT_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='CURRENT_AC' THEN BALANCE ELSE 0 END CURRENT_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SND_AC'     THEN BALANCE ELSE 0 END SND_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SND_AC'     THEN BALANCE ELSE 0 END SND_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SB_AC'      THEN BALANCE ELSE 0 END SB_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SB_AC'      THEN BALANCE ELSE 0 END SB_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='SDS_AC'     THEN BALANCE ELSE 0 END SDS_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='SDS_AC'     THEN BALANCE ELSE 0 END SDS_AC_BALANCE_FEMALE,
                         CASE WHEN AC_GENDER='M' AND AC_TYPE='FDR_AC'     THEN BALANCE ELSE 0 END FDR_AC_BALANCE_MALE,
                         CASE WHEN AC_GENDER='F' AND AC_TYPE='FDR_AC'     THEN BALANCE ELSE 0 END FDR_AC_BALANCE_FEMALE
                    FROM (SELECT POINT_CODE, POINT_NAME, LOCATION_TYPE,
                                 DECODE((SELECT AGN_TYPE FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID),
                                        'INS',(SELECT GENDER FROM EMOB.MB_AGENT_OWNER_MST WHERE CUST_CODE=(SELECT CUST_CODE FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID) AND ROWNUM=1),
                                        (SELECT GENDER FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID)) AGENT_GENDER,
                                 AC_TYPE, AC_GENDER, NUMBER_OF_AC, BALANCE
                            FROM (  SELECT c.POINT_CODE, c.POINT_NAME, c.LOCATION_TYPE, c.AGENT_ID,
                                           CASE WHEN pm.DEP_NATURE='R' AND pm.CATEGORY='S' THEN 'SAVINGS_AC'
                                                WHEN pm.DEP_NATURE='R' AND pm.CATEGORY='C' THEN 'CURRENT_AC'
                                                WHEN pm.DEP_NATURE='R' AND pm.CATEGORY='N' THEN 'SND_AC'
                                                WHEN pm.DEP_NATURE='F' AND pm.CATEGORY='F' THEN 'FDR_AC'
                                                WHEN pm.DEP_NATURE='C' AND pm.CATEGORY='D' THEN 'SDS_AC'
                                                WHEN pm.DEP_NATURE='R' AND pm.CATEGORY='M' THEN 'SB_AC' END AC_TYPE,
                                           d.GENDER AC_GENDER, COUNT(a.ac_no) NUMBER_OF_AC, SUM(a.BALANCE) BALANCE
                                      FROM EMOB.MB_ACCOUNT_BALANCE_DATA a, EMOB.MB_ACCOUNT_MST b,
                                           EMOB.ST_AGENT_POINT c, EMOB.MB_CUSTOMER_MST d, EMOB.MB_PRODUCT_MST pm
                                     WHERE a.ac_no=b.ac_no AND b.cust_no=d.cust_no AND b.POINT_ID=c.POINT_ID
                                       AND b.AC_TYPE_ID=pm.AC_TYPE_ID AND pm.AC_TYPE_ID<>8
                                       AND a.MONTH_CODE=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')
                                       AND a.ac_no IN (SELECT AC_NO FROM EMOB.MB_ACCOUNT_MST WHERE AC_NO IN
                                                       (SELECT DISTINCT AC_NO FROM EMOB.MB_ACCOUNT_BALANCE_DATA
                                                         WHERE TO_CHAR(OPEN_DATE,'RRRRMM')=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')))
                                  GROUP BY c.POINT_CODE,c.POINT_NAME,c.AGENT_ID,d.GENDER,b.ac_type,c.LOCATION_TYPE,pm.DEP_NATURE,pm.CATEGORY
                                  ORDER BY c.POINT_CODE)
                          UNION ALL
                          SELECT POINT_CODE, POINT_NAME, LOCATION_TYPE,
                                 DECODE((SELECT AGN_TYPE FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID),
                                        'INS',(SELECT GENDER FROM EMOB.MB_AGENT_OWNER_MST WHERE CUST_CODE=(SELECT CUST_CODE FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID) AND ROWNUM=1),
                                        (SELECT GENDER FROM EMOB.MB_CUSTOMER_MST WHERE CUST_NO=AGENT_ID)) AGENT_GENDER,
                                 NULL AC_TYPE, NULL AC_GENDER, 0 NUMBER_OF_AC, 0 BALANCE
                            FROM EMOB.ST_AGENT_POINT
                           WHERE POINT_CODE NOT IN
                                 (SELECT DISTINCT POINT_CODE FROM
                                  (  SELECT c.POINT_CODE,c.POINT_NAME,c.LOCATION_TYPE,c.AGENT_ID,b.ac_type,
                                            d.GENDER AC_GENDER,COUNT(a.ac_no) NUMBER_OF_AC,SUM(a.BALANCE) BALANCE
                                       FROM EMOB.MB_ACCOUNT_BALANCE_DATA a,EMOB.MB_ACCOUNT_MST b,
                                            EMOB.ST_AGENT_POINT c,EMOB.MB_CUSTOMER_MST d
                                      WHERE a.ac_no=b.ac_no AND b.cust_no=d.cust_no AND b.POINT_ID=c.POINT_ID
                                        AND a.MONTH_CODE=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')
                                        AND a.ac_no IN (SELECT AC_NO FROM EMOB.MB_ACCOUNT_MST WHERE AC_NO IN
                                                        (SELECT DISTINCT AC_NO FROM EMOB.MB_ACCOUNT_BALANCE_DATA
                                                          WHERE TO_CHAR(OPEN_DATE,'RRRRMM')=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')))
                                  GROUP BY c.POINT_CODE,c.POINT_NAME,c.AGENT_ID,d.GENDER,b.ac_type,c.LOCATION_TYPE
                                  ORDER BY c.POINT_CODE))
                             AND STATUS='A' AND TO_CHAR(APPROVED_DATE,'RRRRMM')=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')))
        GROUP BY POINT_CODE,POINT_NAME,LOCATION_TYPE,AGENT_GENDER) b,
       (  SELECT POINT_CODE,
                 SUM(TRAN_VALUE_DEPOSIT) DEPOSIT_COUNT, SUM(TRAN_VALUE_WITHDRAW) WITHDRAW_COUNT, SUM(TRAN_VALUE_TRANSFER) TRANSFER_COUNT,
                 SUM(TRAN_AMT_DEPOSIT) DEPOSIT_AMOUNT, SUM(TRAN_AMT_WITHDRAW) WITHDRAW_AMOUNT, SUM(TRAN_AMT_TRANSFER) TRANSFER_AMOUNT,
                 SUM(TRAN_VALUE_WITHDRAW_MALE) WITHDRAW_COUNT_MALE, SUM(TRAN_VALUE_WITHDRAW_FEMALE) WITHDRAW_COUNT_FEMALE,
                 SUM(TRAN_AMT_WITHDRAW_MALE) WITHDRAW_AMOUNT_MALE, SUM(TRAN_AMT_WITHDRAW_FEMALE) WITHDRAW_AMOUNT_FEMALE,
                 SUM(TRAN_VALUE_TRANSFER_MALE) TRANSFER_COUNT_MALE, SUM(TRAN_VALUE_TRANSFER_FEMALE) TRANSFER_COUNT_FEMALE,
                 SUM(TRAN_AMT_TRANSFER_MALE) TRANSFER_AMOUNT_MALE, SUM(TRAN_AMT_TRANSFER_FEMALE) TRANSFER_AMOUNT_FEMALE
            FROM (SELECT CASE WHEN NATURE_ID=1 THEN 1 ELSE 0 END TRAN_VALUE_DEPOSIT,
                         CASE WHEN NATURE_ID=2 THEN 1 ELSE 0 END TRAN_VALUE_WITHDRAW,
                         CASE WHEN NATURE_ID=3 THEN 1 ELSE 0 END TRAN_VALUE_TRANSFER,
                         CASE WHEN NATURE_ID=1 THEN TRAN_AMT_LC ELSE 0 END TRAN_AMT_DEPOSIT,
                         CASE WHEN NATURE_ID=2 THEN TRAN_AMT_LC ELSE 0 END TRAN_AMT_WITHDRAW,
                         CASE WHEN NATURE_ID=3 THEN TRAN_AMT_LC ELSE 0 END TRAN_AMT_TRANSFER,
                         CASE WHEN NATURE_ID=2 AND GENDER='M' THEN 1 ELSE 0 END TRAN_VALUE_WITHDRAW_MALE,
                         CASE WHEN NATURE_ID=2 AND GENDER='F' THEN 1 ELSE 0 END TRAN_VALUE_WITHDRAW_FEMALE,
                         CASE WHEN NATURE_ID=2 AND GENDER='M' THEN TRAN_AMT_LC ELSE 0 END TRAN_AMT_WITHDRAW_MALE,
                         CASE WHEN NATURE_ID=2 AND GENDER='F' THEN TRAN_AMT_LC ELSE 0 END TRAN_AMT_WITHDRAW_FEMALE,
                         CASE WHEN NATURE_ID=3 AND GENDER='M' THEN 1 ELSE 0 END TRAN_VALUE_TRANSFER_MALE,
                         CASE WHEN NATURE_ID=3 AND GENDER='F' THEN 1 ELSE 0 END TRAN_VALUE_TRANSFER_FEMALE,
                         CASE WHEN NATURE_ID=3 AND GENDER='M' THEN TRAN_AMT_LC ELSE 0 END TRAN_AMT_TRANSFER_MALE,
                         CASE WHEN NATURE_ID=3 AND GENDER='F' THEN TRAN_AMT_LC ELSE 0 END TRAN_AMT_TRANSFER_FEMALE,
                         TRAN_POINT_ID
                    FROM (SELECT M.BRANCH_CODE, M.TRAN_POINT_ID, M.DOC_DATE, M.DOC_NUM, M.AC_NO, M.TRAN_AMT_LC,
                                 NATURE_ID, C.CUST_NO, NVL(C.GENDER,'M') AS GENDER,
                                 NVL(C.LOCATION_TYPE, M.LOCATION_TYPE) LOCATION_TYPE
                            FROM (SELECT Z.BRANCH_CODE, Z.TRAN_POINT_ID, Z.DOC_DATE, Z.DOC_NUM,
                                         Z.AC_NO, Z.TRAN_AMT_LC, AG.LOCATION_TYPE, NATURE_ID
                                    FROM (SELECT TB.BRANCH_CODE, TB.TRAN_POINT_ID, TB.DOC_NUM, TB.DOC_DATE,
                                                 TB.AC_NO, TB.TRAN_AMT_LC, TB.CHARGE_FLAG, E.NATURE_ID
                                            FROM EMOB.ST_TRANSACTION_CODE E
                                                 JOIN (SELECT DISTINCT VT.BRANCH_CODE, VT.TRAN_POINT_ID, VT.TRAN_CODE,
                                                              VT.DOC_NUM, VT.DOC_DATE, VT.CR_AC_NO AS AC_NO,
                                                              VT.TRAN_AMT_LC, VT.CHARGE_FLAG
                                                         FROM VW_ABSD_TRAN_BASE VT WHERE VT.CR_AC_NO IS NOT NULL
                                                       UNION ALL
                                                       SELECT DISTINCT VT.BRANCH_CODE, VT.TRAN_POINT_ID, VT.TRAN_CODE,
                                                              VT.DOC_NUM, VT.DOC_DATE, VT.DR_AC_NO,
                                                              VT.TRAN_AMT_LC, VT.CHARGE_FLAG
                                                         FROM VW_ABSD_TRAN_BASE VT WHERE VT.DR_AC_NO IS NOT NULL) TB
                                                     ON (TB.TRAN_CODE=E.TRAN_CODE AND E.NATURE_ID IN (2,1,3) AND TB.AC_NO IS NOT NULL)
                                           WHERE TB.CHARGE_FLAG='N') Z
                                         JOIN EMOB.ST_AGENT_POINT AG ON (Z.TRAN_POINT_ID=AG.POINT_ID)) M
                                 LEFT JOIN
                                 (SELECT CUST.BRANCH_CODE, CUST.AC_NO, CUST.CUST_NO, CUST.GENDER,
                                         CUST.AGENT_POINT_ID, AP.LOCATION_TYPE
                                    FROM EMOB.ST_AGENT_POINT AP
                                         JOIN (SELECT C.BRANCH_CODE, C.AC_TYPE_ID, C.AC_ID, C.AC_NO, CM.CUST_NO,
                                                      CASE CM.GENDER WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE 'M' END GENDER,
                                                      CM.AGENT_POINT_ID, CM.CUST_TYPE
                                                 FROM EMOB.MB_ACCOUNT_MST C
                                                      JOIN EMOB.MB_CUSTOMER_MST CM ON (C.CUST_NO=CM.CUST_NO AND CM.CUST_TYPE='CUS')) CUST
                                             ON (AP.POINT_ID=CUST.AGENT_POINT_ID)) C
                                     ON (M.BRANCH_CODE=C.BRANCH_CODE AND M.TRAN_POINT_ID=C.AGENT_POINT_ID AND M.AC_NO=C.AC_NO))) MD
                 JOIN EMOB.ST_AGENT_POINT AG ON (MD.TRAN_POINT_ID=AG.POINT_ID)
          GROUP BY POINT_CODE, POINT_NAME, AG.AGENT_ID, POINT_ID) c,
       (  SELECT POINT_CODE, COUNT(1) CURRENT_MONTH_NUMBER_OF_CLOSED_AC
            FROM EMOB.CLOSE_AC_LIST a, EMOB.MB_ACCOUNT_MST b, EMOB.ST_AGENT_POINT c
           WHERE a.ACCOUNT_NO=b.AC_NO AND b.POINT_ID=c.POINT_ID
             AND a.MONTH_CODE=SYS_CONTEXT('ABSD_CTX','MONTH_CODE')
        GROUP BY POINT_CODE) d
 WHERE a.POINT_CODE=c.POINT_CODE(+) AND a.POINT_CODE=b.POINT_CODE(+) AND a.POINT_CODE=d.POINT_CODE(+)
ORDER BY a.POINT_CODE;

---Multiset Condition----

SELECT * FROM EMPLOYEES
WHERE (DEPARTMENT_ID,SALARY,JOB_ID) 
IN ( (50 ,2600,'SH_CLERK'), 
     (10 ,4400,'AD_ASST'));
 
-------CTE= Common table Expression----------  

WITH dept_avg AS ( 
SELECT e.department_id, AVG(salary) AS avg_sal ,department_name 
FROM employees e join departments d on (e.department_id= d.department_id)
GROUP BY e.department_id ,department_name 
) 
SELECT last_name, department_name,round(avg_sal,2) avg_salary
FROM employees e JOIN  dept_avg  ON (e.department_id = dept_avg.department_id);

-----------------------------------------------------------------------------------------

WITH

 AGENT_POINT AS (SELECT POINT_ID,
       POINT_CODE,
       OPEN_DATE,
       ROUND (MONTHS_BETWEEN (TRUNC (SYSDATE), OPEN_DATE) / 12, 2) AS YEARS_OF_AGENT_EXPERIENCE
  FROM EMOB.ST_AGENT_POINT)

,
 REMITTANCE AS (
   SELECT AGENT_POINT_ID,

       COUNT(CASE
                 WHEN RELATION_TYPE IN ('MOT','WFE','DTR','SIS',
                                        'GMO','AUN','NIE')
                 THEN 1
             END) AS INWARD_REMITTANCE_BY_FEMALE,

       COUNT(CASE
                 WHEN RELATION_TYPE NOT IN ('MOT','WFE','DTR','SIS',
                                            'GMO','AUN','NIE')
                 THEN 1
             END) AS INWARD_REMITTANCE_BY_MALE,

       SUM(CASE
               WHEN RELATION_TYPE IN ('MOT','WFE','DTR','SIS',
                                      'GMO','AUN','NIE')
               THEN VERIFY_AMOUNT
               ELSE 0
           END) AS AMOUNT_OF_INWARD_REMITTANCE_BY_FEMALE,

       SUM(CASE
               WHEN RELATION_TYPE NOT IN ('MOT','WFE','DTR','SIS',
                                          'GMO','AUN','NIE')
               THEN VERIFY_AMOUNT
               ELSE 0
           END) AS AMOUNT_OF_INWARD_REMITTANCE_BY_MALE

FROM EMOB.RM_PAYMENT_REQUEST
WHERE VERIFY_FLAG = 'P'
  AND TO_CHAR(PAY_DATE, 'RRRRMM') =
      SYS_CONTEXT('ABSD_CTX', 'MONTH_CODE')
GROUP BY AGENT_POINT_ID
)
,
 UTILITY AS (  SELECT COUNT (*)            NO_OF_TRANSACTION_OTHERS_PAYMENTS,
         SUM (DUE_AMOUNT)     AMOUNT_OF_TRANSACTION_OTHERS_PAYMENTS,
         POINT_ID
    FROM EMOB.UTL_BILL_COLLECTION
    WHERE TO_CHAR(PAY_DATE, 'RRRRMM') = SYS_CONTEXT('ABSD_CTX','MONTH_CODE')
    AND REF_DOC_NO IS NOT NULL
GROUP BY POINT_ID)

,
COMMISSION AS (
  SELECT POINT_ID, AGENT_AC_ID, SUM (AMOUNT) COMMISSION_FEES_EARNED
    FROM (  SELECT AGENT_AC_ID,
                   POINT_ID,
                     SUM (AGENT_CHARGE)
                   - ROUND (
                          SUM (DECODE (VAT_APPLICABLE, 'N', 0, AGENT_CHARGE))
                        * 15
                        / 115,
                        2)
                      AMOUNT,
                   ROUND (
                        SUM (DECODE (VAT_APPLICABLE, 'N', 0, AGENT_CHARGE))
                      * 15
                      / 115,
                      2)
                      VAT
              FROM EMOB.MB_TRAN_COMM_PROVISION
             WHERE     MONTH_CODE = SYS_CONTEXT('ABSD_CTX','MONTH_CODE')
                   --AND POST_FLAG = 'Y'
                  
          GROUP BY AGENT_AC_ID, POINT_ID)
GROUP BY AGENT_AC_ID, POINT_ID)

SELECT
           0                                           AS NO_OF_AC_RECURRING_DEPOSIT,
           0                                           AS BALANCE_RECURRING_DEPOSIT,
           0                                           AS NO_OF_AC_FARMER,
           0                                           AS BALANCE_FARMER,
           0                                           AS NO_OF_AC_SOCIAL_SAFETY_NET,
           0                                           AS BALANCE_SOCIAL_SAFETY_NET,
           0                                           AS NO_OF_AC_OTHERS,
           0                                           AS BALANCE_OTHERS,
           0                                           AS TOTAL_DEPOSIT_AC_OTHERS,
           0                                           AS TOTAL_DEPOSIT_BALANCE_OTHERS,
           0                                           AS NO_OF_NEW_LOAN_AC,
           0                                           AS NO_OF_AC_CMSME,
           0                                           AS OUTSTANDING_CMSME,
           0                                           AS NO_OF_AC_AGRI_RURAL_CREDIT,
           0                                           AS OUTSTANDING_AGRI_RURAL_CREDIT,
           0                                           AS NO_OF_AC_PERSONAL_LOAN,
           0                                           AS OUTSTANDING_PERSONAL_LOAN,
           0                                           AS NO_OF_AC_SOD,
           0                                           AS OUTSTANDING_SOD,
           0                                           AS NO_OF_AC_OTHER_LOANS,
           0                                           AS OUTSTANDING_BALANCE_OTHER_LOANS,
           0                                           AS NO_OF_LOAN_AC_MALE,
           0                                           AS LOAN_OUTSTANDING_MALE,
           0                                           AS NO_OF_LOAN_AC_FEMALE,
           0                                           AS LOAN_OUTSTANDING_FEMALE,
           0                                           AS NO_OF_LOAN_AC_OTHERS,
           0                                           AS LOAN_OUTSTANDING_OTHERS,
           0                                           AS TOTAL_NO_OF_LOAN_AC,
           0                                           AS TOTAL_LOAN_OUTSTANDING,
           0                                           AS LOAN_DISBURSE_AMOUNT,
           0                                           AS LOAN_RECOVERY_AMOUNT,
           0                                           AS UNCLASSIFIED_LOAN_OUTSTANDING,
           0                                           AS CLASSIFIED_LOAN_OUTSTANDING,
           NVL(R.INWARD_REMITTANCE_BY_MALE, 0)+NVL(R.INWARD_REMITTANCE_BY_FEMALE, 0)                        AS NO_OF_TRANSACTION_INWARD_REMITTANCE,
           NVL(R.AMOUNT_OF_INWARD_REMITTANCE_BY_MALE, 0)+NVL(R.AMOUNT_OF_INWARD_REMITTANCE_BY_FEMALE, 0)    AS AMOUNT_OF_TRANSACTION_INWARD_REMITTANCE,
           0                                           AS NO_OF_TRANSACTION_UTILITY_BILL,
           0                                           AS AMOUNT_OF_TRANSACTION_UTILITY_BILL,
           NVL(NO_OF_TRANSACTION_OTHERS_PAYMENTS,0)    AS NO_OF_TRANSACTION_OTHERS_PAYMENTS,
           NVL(AMOUNT_OF_TRANSACTION_OTHERS_PAYMENTS,0)AS AMOUNT_OF_TRANSACTION_OTHERS_PAYMENTS,
           0                                           AS NO_OF_TRANSACTION_MALE,
           0                                           AS AMOUNT_OF_TRANSACTION_MALE,
           0                                           AS NO_OF_TRANSACTION_FEMALE,
           0                                           AS AMOUNT_OF_TRANSACTION_FEMALE,
           0                                           AS NO_OF_TRANSACTION_OTHERS,
           0                                           AS AMOUNT_OF_TRANSACTION_OTHERS,
           0                                           AS NO_OF_CASH_DEPOSIT_IN_BRANCH,
           0                                           AS AMOUNT_OF_CASH_DEPOSIT_IN_BRANCH,
           0                                           AS NO_OF_CASH_WITHDRAWL_IN_BRANCH,
           0                                           AS AMOUNT_OF_CASH_WITHDRAWL_IN_BRANCH,
           0                                           AS NO_OF_FUND_TRANSFER_IN_BRANCH,
           0                                           AS AMOUNT_OF_FUND_TRANSFER_IN_BRANCH,
           0                                           AS NO_OF_INWARD_REMITTANCE_RECEIVED,
           0                                           AS AMOUNT_OF_INWARD_REMITTANCE_RECEIVED,
           0                                           AS NO_OF_SOCIAL_SAFETY_NET_G2P_RECEIVED,
           0                                           AS AMOUNT_OF_SOCIAL_SAFETY_NET_G2P_RECEIVED,
           0                                           AS TOTAL_NO_OF_INTERNET_BANKING_USERS,
           0                                           AS NO_OF_ECOMMERCE_TRANSACTION,
           0                                           AS AMOUNT_OF_ECOMMERCE_TRANSACTION,
           0                                           AS NO_OF_TRANSACTION_UTILITY_BILL_OUTSIDE,
           0                                           AS AMOUNT_OF_UTILITY_BILL_OUTSIDE,
           0                                           AS NO_OF_TRANSACTION_OTHER_PAYMENTS_OUTSIDE,
           0                                           AS AMOUNT_OF_OTHER_PAYMENTS_OUTSIDE,
           0                                           AS NO_OF_CASH_DEPOSITS_IN_CRM_CDM_RTDM,
           0                                           AS AMOUNT_OF_CASH_DEPOSITS_IN_CRM_CDM_RTDM,
           0                                           AS NO_OF_CASH_WITHDRAWAL_IN_ATM_CRM,
           0                                           AS AMOUNT_OF_CASH_WITHDRAWAL_IN_ATM_CRM,
           0                                           AS NO_OF_FUND_TRANSFER_AC,
           0                                           AS AMOUNT_OF_FUND_TRANSFER_AC,
           0                                           AS NO_OF_FUND_TRANSFER_MFS_AC,
           0                                           AS AMOUNT_OF_FUND_TRANSFER_MFS_AC,
           0                                           AS NO_OF_TRANSACTION_POS,
           0                                           AS AMOUNT_OF_TRANSACTION_POS,
           0                                           AS NO_OF_TRANSACTION_OTHERS_OUTSIDE,
           0                                           AS AMOUNT_OF_TRANSACTION_OTHERS_OUTSIDE,
           0                                           AS NO_OF_TRANSACTION_MALE_OUTSIDE_OUTLET,
           0                                           AS AMOUNT_OF_TRANSACTION_MALE_OUTSIDE_OUTLET,
           0                                           AS NO_OF_TRANSACTION_FEMALE_OUTSIDE_OUTLET,
           0                                           AS AMOUNT_OF_TRANSACTION_FEMALE_OUTSIDE_OUTLET,
           0                                           AS NO_OF_TRANSACTION_OTHERS_OUTSIDE_OUTLET,
           0                                           AS AMOUNT_OF_TRANSACTION_OTHERS_OUTSIDE_OUTLET,
           0                                           AS TOTAL_NO_OF_TRANSACTION_OUTSIDE_OUTLET,
           0                                           AS TOTAL_AMOUNT_OF_TRANSACTION_OUTSIDE_OUTLET,
           0                                           AS TOTAL_NO_OF_TRANSACTION_MALE,
           0                                           AS TOTAL_AMOUNT_OF_TRANSACTION_MALE,
           0                                           AS TOTAL_NO_OF_TRANSACTION_FEMALE,
           0                                           AS TOTAL_AMOUNT_OF_TRANSACTION_FEMALE,
           0                                           AS TOTAL_NO_OF_TRANSACTION_OTHERS,
           0                                           AS TOTAL_AMOUNT_OF_TRANSACTION_OTHERS,
           0                                           AS TOTAL_NO_OF_DEBIT_CARD_ISSUED,
           0                                           AS NO_OF_DEBIT_CARD_ISSUED_MALE,
           0                                           AS NO_OF_DEBIT_CARD_ISSUED_FEMALE,
           0                                           AS NO_OF_DEBIT_CARD_TRANSACTION_MALE,
           0                                           AS NO_OF_DEBIT_CARD_TRANSACTION_FEMALE,
           0                                           AS AMOUNT_OF_DEBIT_CARD_TRANSACTION_MALE,
           0                                           AS AMOUNT_OF_DEBIT_CARD_TRANSACTION_FEMALE,
           0                                           AS TOTAL_NO_OF_DEBIT_CARD_TRANSACTION,
           0                                           AS TOTAL_AMOUNT_OF_DEBIT_CARD_TRANSACTION,
           0                                           AS TOTAL_NO_OF_CREDIT_CARD_ISSUED,
           0                                           AS NO_OF_CREDIT_CARD_ISSUED_MALE,
           0                                           AS NO_OF_CREDIT_CARD_ISSUED_FEMALE,
           0                                           AS NO_OF_CREDIT_CARD_TRANSACTION_MALE,
           0                                           AS NO_OF_CREDIT_CARD_TRANSACTION_FEMALE,
           0                                           AS AMOUNT_OF_CREDIT_CARD_TRANSACTION_MALE,
           0                                           AS AMOUNT_OF_CREDIT_CARD_TRANSACTION_FEMALE,
           0                                           AS TOTAL_NO_OF_CREDIT_CARD_TRANSACTION,
           0                                           AS TOTAL_AMOUNT_OF_CREDIT_CARD_TRANSACTION,
           NVL(C.COMMISSION_FEES_EARNED,0)               AS COMMISSION_FEES_EARNED,
           0                                           AS EXPENSE_PREMISES_RENT,
           0                                           AS EXPENSE_STAFF_SALARY,
           0                                           AS EXPENSE_UTILITY_BILL,
           0                                           AS ENTERTAINMENT_COST,
           0                                           AS STATIONARY_COST,
           0                                           AS TRANSPORT_CONVEYANCE_COURIER_COST,
           0                                           AS MAINTENANCE_COST,
           0                                           AS EXPENSES_MARKETING,
           0                                           AS MISCELLANEOUS_EXPENSES,
           0                                           AS TOTAL_EXPENSES,
           0                                           AS PROFIT_LOSS,
           0                                           AS MALE_EMPLOYEE,
           0                                           AS FEMALE_EMPLOYEE,
           0                                           AS TOTAL_NO_OF_EMPLOYEE,
           CAST(NULL AS VARCHAR2(100))                 AS SELF_EMPLOYED_YN,
           NVL(AP.YEARS_OF_AGENT_EXPERIENCE,0)            AS YEARS_OF_AGENT_EXPERIENCE,
           CAST(NULL AS VARCHAR2(100))                 AS AGENT_HIGHEST_LEVEL_OF_EDUCATION,
           CAST(NULL AS VARCHAR2(100))                 AS SERVICE_PROVIDING_IN_HOLIDAY_YN,
           0                                           AS AVERAGE_SERVICE_HOUR_PER_DAY,
           CAST(NULL AS VARCHAR2(100))                 AS NATURE_OF_OUTLET,
           CAST(NULL AS VARCHAR2(100))                 AS SOLAR_POWERED_AGENT_OUTLETS_YN,
           CAST(NULL AS VARCHAR2(100))                 AS ENVIRONMENT_FRIENDLY_AGENT_OUTLETS_YN,
           CAST(NULL AS VARCHAR2(100))                 AS CONDUCT_ANY_CAMPAIGN_YN,
           0                                           AS NO_OF_COMPLAINT,
           0                                           AS NO_OF_COMPLAINT_MITIGATED,
           AP.POINT_ID                                 AS AGENT_POINT_ID,
           NVL(R.INWARD_REMITTANCE_BY_MALE, 0)         AS NO_OF_INWARD_REMITTANCE_BY_MALE,
           R.AMOUNT_OF_INWARD_REMITTANCE_BY_MALE       AS AMOUNT_OF_INWARD_REMITTANCE_BY_MALE,
           NVL(R.INWARD_REMITTANCE_BY_FEMALE, 0)       AS NO_OF_INWARD_REMITTANCE_BY_FEMALE,
           R.AMOUNT_OF_INWARD_REMITTANCE_BY_FEMALE     AS AMOUNT_OF_INWARD_REMITTANCE_BY_FEMALE
      FROM DUAL
      CROSS JOIN AGENT_POINT AP
      LEFT JOIN  REMITTANCE R ON (R.AGENT_POINT_ID = AP.POINT_ID )
      LEFT JOIN UTILITY U ON (AP.POINT_ID = U.POINT_ID )
	  LEFT JOIN COMMISSION C ON (AP.POINT_ID = C.POINT_ID );
	  
	  
	  
	  
	  