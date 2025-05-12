MATERIALIZED view Create in Oracle
-----------------------------------------

CREATE MATERIALIZED VIEW MV_AGENT_TRANSACTION_COMMISSION
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
ENABLE QUERY REWRITE
AS
    SELECT COMM_TAB.TRAN_DATE                                  TRAN_DATE,
           COMM_TAB.TRAN_CODE                                  TRAN_CODE,
           COMM_TAB.DOC_NUM,
           COMM_TAB.CHARGE_AMOUNT                              NET,
           ROUND ((COMM_TAB.CHARGE_AMOUNT * 15) / 115, 2)      VAT,
             COMM_TAB.CHARGE_AMOUNT
           - ROUND ((COMM_TAB.CHARGE_AMOUNT * 15) / 115, 2)    EARNED_COMM,
           COMM_TAB.MONTH_CODE,
           CASE
               WHEN COMM_TAB.TRAN_CODE = '26' THEN 'Remittance Payment'
               ELSE TRAN_TAB.NARATION
           END                                                 PARTICULAR,
           AGENT_NO                                            AGENT_NO
      FROM (SELECT TRAN_DATE,
                   DOC_NUM,
                   TRAN_CODE,
                   CHARGE_AMOUNT,
                   MONTH_CODE,
                   AGENT_NO
              FROM EMOB.MB_TRAN_COMM_PROVISION
             WHERE     TRAN_CODE NOT IN ('20', '24', '33')
            UNION ALL
            SELECT TRAN_DATE,
                   DOC_NUM,
                   TRAN_CODE,
                   MOTHER_AGENT_CHARGE,
                   MONTH_CODE,
                   MOTHER_AGENT_CUST_NO AGENT_NO
              FROM EMOB.MB_TRAN_COMM_PROVISION
             WHERE    TRAN_CODE NOT IN ('20', '24', '33')) COMM_TAB
           LEFT JOIN
           (SELECT DOC_DATE,
                   DOC_NUM,
                   TRAN_CODE,
                   NARATION,
                   CHARGE_FLAG
              FROM EMOB.MB_TRANSACTION_DAILY
            UNION ALL
            SELECT DOC_DATE,
                   DOC_NUM,
                   TRAN_CODE,
                   NARATION,
                   CHARGE_FLAG
              FROM EMOB.MB_TRANSACTION_DTL) TRAN_TAB
               ON (    COMM_TAB.TRAN_DATE = TRAN_TAB.DOC_DATE
                   AND COMM_TAB.DOC_NUM = TRAN_TAB.DOC_NUM
                   AND COMM_TAB.TRAN_CODE = TRAN_TAB.TRAN_CODE
                   AND NVL (TRAN_TAB.CHARGE_FLAG, 'N') = 'N');