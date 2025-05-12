CREATE OR REPLACE PROCEDURE EMOB.PRC_COMM_EXPENSE_TRANSACTION (
   pEntryUser          VARCHAR2,
   pErrorFlag      OUT VARCHAR2,
   pErrorMessage   OUT VARCHAR2)
IS
   vMyException         EXCEPTION;
   vCommPostingFlag     EMOB.MB_TRAN_COMM_DTL.CHG_NATURE%TYPE;
   vProvPayableGLId     EMOB.MB_TRAN_COMM_DTL.BANK_DR_GLID%TYPE;
   vChargeValue         EMOB.MB_TRAN_COMM_DTL.CHG_VALUE%TYPE;
   vCollectFrom         EMOB.MB_TRAN_COMM_DTL.COLLECT_FROM%TYPE;
   vBankDRGlId          EMOB.MB_TRAN_COMM_DTL.BANK_DR_GLID%TYPE;
   vAgentComm           EMOB.MB_TRAN_COMM_DTL.AGENT_COMM%TYPE;
   vBankCrGlId          EMOB.MB_TRAN_COMM_DTL.BANK_CR_GLID%TYPE;
   vVatInclude          EMOB.MB_TRAN_COMM_DTL.VAT_INCLUDE%TYPE;
   vStatus              EMOB.MB_TRAN_COMM_DTL.STATUS%TYPE;
   vChargeAmount        EMOB.MB_TRAN_COMM_DTL.CHG_VALUE%TYPE;
   vVATPercent          EMOB.MB_GLOBAL_RULE.VAT_PERCENT%TYPE;
   vVATAmount           EMOB.MB_TRAN_COMM_DTL.CHG_VALUE%TYPE;
   vVATGlId             EMOB.MB_TRAN_COMM_DTL.BANK_CR_GLID%TYPE;
   vProvPayableGLCode   VARCHAR2 (1024);
   vVATGlCode           VARCHAR2 (1024);
   vCommId              NUMBER;
   vPoint               NUMBER;
   vAgentAccountId      NUMBER;
   vUserAgentNo         NUMBER;
   vCountEligibleAc     NUMBER;
BEGIN
   BEGIN
      SELECT COLLECT_FROM,
             CHG_VALUE,
             BANK_DR_GLID,
             AGENT_COMM,
             BANK_CR_GLID,
             VAT_INCLUDE,
             STATUS,
             COMM_ID
        INTO vCollectFrom,
             vChargeValue,
             vBankDrGlId,
             vAgentComm,
             vBankCrGlId,
             vVatInclude,
             vStatus,
             vCommId
        FROM (SELECT eff_date,
                     NVL (
                        LEAD (eff_date - 1)
                           OVER (PARTITION BY TRAN_CODE ORDER BY eff_date),
                        TRUNC (SYSDATE + 1000))
                        exp_date,
                     COLLECT_FROM,
                     CHG_NATURE,
                     CHG_VALUE,
                     MIN_VALUE,
                     MAX_VALUE,
                     BANK_DR_GLID,
                     AGENT_COMM,
                     BANK_CR_GLID,
                     VAT_INCLUDE,
                     STATUS,
                     COMM_ID
                FROM EMOB.MB_TRAN_COMM_DTL
               WHERE TRAN_CODE = 33)
       WHERE TRUNC (SYSDATE) BETWEEN eff_date AND exp_date;
   END;


   -------------Read payable  account transaction naturewise-------
   BEGIN
      SELECT COMM_POST,
             PAYABLE_AC,
             VAT_AC,
             EMOB.PKG_GLOBAL_OBJECTS.GET_CBSGL_CODE (PAYABLE_AC),
             EMOB.PKG_GLOBAL_OBJECTS.GET_CBSGL_CODE (VAT_AC)
        INTO vCommPostingFlag,
             vProvPayableGLID,
             vVATGlID,
             vProvPayableGLCode,
             vVATGlCode
        FROM EMOB.MB_TRAN_COMM_MST
       WHERE NATURE_ID = (SELECT NATURE_ID
                            FROM ST_TRANSACTION_CODE
                           WHERE TRAN_CODE = 33);
   EXCEPTION
      WHEN OTHERS
      THEN
         pErrorMessage := 'Commission Setup Not Found.' || SQLERRM;
         RAISE vMyException;
   END;

   BEGIN
      SELECT POINT_ID
        INTO vPoint
        FROM EMOB.MB_ACCOUNT_MST
       WHERE AC_ID = pAccId;


      SELECT b.AC_ID, b.CUST_NO
        INTO vAgentAccountId, vUserAgentNo
        FROM EMOB.MB_CUSTOMER_MST a, EMOB.MB_ACCOUNT_MST b
       WHERE     a.CUST_NO = B.CUST_NO
             AND AC_STATUS = 'ACT'
             AND CUST_TYPE = 'AGN'
             AND a.CUST_NO = (SELECT AGENT_ID
                                FROM EMOB.ST_AGENT_POINT
                               WHERE POINT_ID = vPoint);
   EXCEPTION
      WHEN OTHERS
      THEN
         pErrorMessage := 'Point Finding Problem.' || SQLERRM;
         RAISE vMyException;
   END;

   BEGIN
      SELECT VAT_PERCENT INTO vVATPercent FROM EMOB.MB_GLOBAL_RULE;

      IF vVATPercent IS NULL
      THEN
         vVATPercent := 0;
      END IF;
   EXCEPTION
      WHEN OTHERS
      THEN
         pErrorFlag := 'Y';
         pErrorMessage := 'VAT Percentage Not Found.';
         RAISE vMyException;
   END;

   SELECT COUNT (*)
     INTO vCountEligibleAc
     FROM EMOB.MB_INCENTIVE_ELIGIBLE_AC
    WHERE NVL (EXP_DEBIT_FLAG, 'N') = 'N';

   vVATAmount :=
      ROUND ( (vChargeValue * vVATPercent / (100 + vVATPercent)), 2);

   vChargeAmount := (vChargeValue - vVATAmount) * vCountEligibleAc;


   BEGIN
      INSERT INTO EMOB.MB_TRAN_COMM_PROVISION (TRAN_DATE,
                                               DOC_NUM,
                                               TRAN_CODE,
                                               TRAN_AMOUNT,
                                               COMM_ID,
                                               CHARGE_AMOUNT,
                                               AGENT_CHARGE,
                                               VAT_AMOUNT,
                                               AGENT_AC_ID,
                                               AGENT_NO,
                                               PAYABLE_GLID,
                                               BANK_CHARGE,
                                               VAT_GLID,
                                               POST_FLAG,
                                               POINT_ID,
                                               CREATE_BY,
                                               CREATE_DATE)
           VALUES (TRUNC (SYSDATE),
                   'TR' || EMOB.DOC_NUM_TR_SEQ.NEXTVAL || '33',
                   33,
                   vChargeValue,
                   vCommId,
                   vChargeValue,
                   vChargeAmount,
                   vVATAmount,
                   vAgentAccountId,
                   vUserAgentNo,
                   vProvPayableGLID,
                   0,
                   vVATGlID,
                   'N',
                   vPoint,
                   pRunUser,
                   SYSDATE);

      BEGIN
         UPDATE EMOB.MB_INCENTIVE_ELIGIBLE_AC
            SET EXP_DEBIT_FLAG = 'Y'
          WHERE NVL (EXP_DEBIT_FLAG, 'N') = 'N';
      END;
   EXCEPTION
      WHEN OTHERS
      THEN
         pErrorMessage := 'Commission Log Creation Problem. ' || SQLERRM;
         RAISE vMyException;
   END;
EXCEPTION
   WHEN vMyException
   THEN
      ROLLBACK;
      pErrorFlag := 'Y';
END;
/