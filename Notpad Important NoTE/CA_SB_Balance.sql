  ----------------------------------------------------------------------
  -------------Account Balance for (Current ,Savings )------------------
  ----------------------------------------------------------------------
  SELECT 
         NVL(SUM (CURRENT_AC_BALANCE),0) CURRENT_AC_BALANCE,
         NVL(SUM (SAVINGS_AC_BALANCE),0) SAVINGS_AC_BALANCE,
         NVL(SUM (URBAN_AC_BALANCE),0) URBAN_AC_BALANCE,
         NVL(SUM (RURAL_AC_BALANCE),0) RURAL_AC_BALANCE
    FROM (SELECT DECODE (AC_TYPE, 'CDSAB', BALANCE) CURRENT_AC_BALANCE,
                 DECODE (AC_TYPE, 'SDSAB', BALANCE) SAVINGS_AC_BALANCE,
                 DECODE (LOCATION_TYPE, 'U', BALANCE) URBAN_AC_BALANCE,
                 DECODE (LOCATION_TYPE, 'R', BALANCE) RURAL_AC_BALANCE,
                 POINT_CODE,
                 POINT_NAME,
                 AGENT_ID
            FROM (SELECT D.BALANCE,
                         A.AC_TYPE,
                         POINT_CODE,
                         POINT_NAME,
                         AGENT_ID,
                         B.LOCATION_TYPE
                    FROM EMOB.MB_ACCOUNT_MST A,
                         EMOB.ST_AGENT_POINT B,
                         EMOB.MB_CUSTOMER_MST C,
                         EMOB.MB_ACCOUNT_BALANCE_DATA D
                   WHERE     A.CUST_NO = C.CUST_NO
                         AND A.POINT_ID = B.POINT_ID
                         AND A.AC_STATUS = 'ACT'
                         AND A.AC_NO = D.AC_NO
                         AND TO_CHAR (A.OPEN_DATE, 'YYYYMM') BETWEEN '202205'
                                                                 AND   '202205'
                                                                     - 2)) X