-----------------------------------------------------------------------
-------------------Urban, Rural ,And Total Balance---------------------
-----------------------------------------------------------------------

DECLARE
   vUrbanBal     NUMBER;
   vRuralBal     NUMBER;
   vCurrentBal   NUMBER;
   vTotalBal     NUMBER;
BEGIN
   SELECT   NVL (SUM (URBAN_MALE_BALANCE), 0)
          + NVL (SUM (URBAN_FEMALE_BALANCE), 0)
             URBAN_TOTAL,
            NVL (SUM (RURAL_MALE_BALANCE), 0)
          + NVL (SUM (RURAL_FEMALE_BALANCE), 0)
             RURAL_TOTAL,
          NVL (SUM (CASE WHEN X.AC_TYPE = 'CDSAB' THEN X.BALANCE ELSE 0 END),
               0)
             TOTAL_CURRENT_BALANCE,
          NVL (SUM (CASE WHEN X.AC_TYPE = 'SDSAB' THEN X.BALANCE ELSE 0 END),
               0)
             TOTAL_SAVING_BALANCE,
            NVL (SUM (URBAN_MALE_BALANCE), 0)
          + NVL (SUM (URBAN_FEMALE_BALANCE), 0)
          + NVL (SUM (RURAL_MALE_BALANCE), 0)
          + NVL (SUM (RURAL_FEMALE_BALANCE), 0)
             TOTAL_BALANCE
     INTO vUrbanBal,
          vRuralBal,
          vCurrentBal,
          vTotalBal
     FROM (SELECT DECODE (GENDER, 'M', BALANCE) URBAN_MALE_BALANCE,
                  DECODE (GENDER, 'F', BALANCE) URBAN_FEMALE_BALANCE,
                  DECODE (GENDER, 'M', BALANCE) RURAL_MALE_BALANCE,
                  DECODE (GENDER, 'F', BALANCE) RURAL_FEMALE_BALANCE,
                  AC_TYPE,
                  BALANCE
             FROM (SELECT DECODE (B.LOCATION_TYPE, 'U', AC_ID) URBAN_AC,
                          DECODE (B.LOCATION_TYPE, 'R', AC_ID) RURAL_AC,
                          C.GENDER,
                          A.AC_TYPE,
                          D.BALANCE
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
                                                                      - 2)) x;
END;