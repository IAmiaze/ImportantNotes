CREATE OR REPLACE PACKAGE BODY EMOB.PKG_AGENT_FLOAT_PROVISION
IS
   PROCEDURE INSERT_FLOAT_ERROR_LOG (pProcessId             VARCHAR2,
                                     pProcessName           VARCHAR2,
                                     pOracleErrorMessage    VARCHAR2,
                                     pCustomErrorMessage    VARCHAR2,
                                     pCustomerCode          VARCHAR2,
                                     pAccountNo             VARCHAR2,
                                     pDescription           VARCHAR2,
                                     pRunUser               VARCHAR2,
                                     pDbtableName           VARCHAR2,
                                     pDbcolumnName          VARCHAR2,
                                     pBranchCode            VARCHAR2)
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
      vErrorId   MB_ERROR_DETAIL.ERROR_ID%TYPE;
   BEGIN
      vErrorId := ERROR_DETAIL_SEQ.NEXTVAL;

      INSERT INTO EMOB.MB_ERROR_DETAIL (ERROR_ID,
                                        PROCESS_NAME,
                                        ORACLE_ERROR_MESSAGE,
                                        CUSTOM_ERROR_MESSAGE,
                                        PROCESS_TIME,
                                        PROCESS_ID,
                                        CUSTOMER_CODE,
                                        ACCOUNT_NO,
                                        DESCRIPTION,
                                        RUN_USER,
                                        DBTABLE_NAME,
                                        DBCOLUMN_NAME,
                                        BRANCH_CODE)
           VALUES (vErrorId,
                   pProcessName,
                   SUBSTR (pOracleErrorMessage, 1, 500),
                   SUBSTR (pCustomErrorMessage, 1, 500),
                   SYSDATE,
                   pProcessId,
                   pCustomerCode,
                   pAccountNo,
                   pDescription,
                   pRunUser,
                   pDbtableName,
                   pDbcolumnName,
                   pBranchCode);

      COMMIT;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   PROCEDURE PRC_FLOAT_PROVISION (pBranchCode VARCHAR2, pDate IN DATE)
   IS
      vYearDays             NUMBER;
      vPayableGl            NUMBER;
      vVatRate              NUMBER;
      vProvExists           NUMBER;
      vMyException          EXCEPTION;
      vErrorFlag            VARCHAR2 (1);
      vErrorMessage         VARCHAR2 (1024);
      vOracleError          VARCHAR2 (1024);

      TYPE BRANCH_LIST_TYPE IS RECORD
      (
         BRANCH_CODE   EMOB.CBS_BRANCH_LIST.BRANCH_CODE%TYPE,
         BRANCH_NAME   EMOB.CBS_BRANCH_LIST.BRANCH_NAME%TYPE
      );

      TYPE BRANCH_TBL IS TABLE OF BRANCH_LIST_TYPE;

      ALL_BRANCH            BRANCH_TBL := BRANCH_TBL (); --initialization-----------------

      TYPE ACTYPE_WISE_FLOAT IS RECORD
      (
         AC_TYPE_ID   EMOB.MB_PRODUCT_CHG_MST.AC_TYPE_ID%TYPE,
         FLOAT_RATE   EMOB.MB_PRODUCT_CHG_MST.CHG_VALUE%TYPE,
         DR_GLAC_ID   EMOB.MB_PRODUCT_CHG_MST.DR_GLAC_ID%TYPE,
         CR_GLAC_ID   EMOB.MB_PRODUCT_CHG_MST.CR_GLAC_ID%TYPE
      );

      TYPE ACTYPE_FLOAT_TBL IS TABLE OF ACTYPE_WISE_FLOAT;

      ACTYPE_FLOAT          ACTYPE_FLOAT_TBL := ACTYPE_FLOAT_TBL (); --initialization-----------------

      TYPE ACTYPE_WISE_PROV IS RECORD
      (
         PROVISION_ID   EMOB.MB_AGENT_COMM_PROVISION_DTL.PROVISION_ID%TYPE,
         BRANCH_CODE    EMOB.MB_AGENT_COMM_PROVISION_DTL.BRANCH_CODE%TYPE,
         AGENT_NO       EMOB.MB_AGENT_COMM_PROVISION_DTL.AGENT_NO%TYPE,
         POINT_ID       EMOB.MB_AGENT_COMM_PROVISION_DTL.POINT_ID%TYPE,
         AC_TYPE_ID     EMOB.MB_AGENT_COMM_PROVISION_DTL.AC_TYPE_ID%TYPE,
         AC_TYPE_DESC   EMOB.MB_PRODUCT_MST.FULL_DESC%TYPE,
         BALANCE_DATE   EMOB.MB_AGENT_COMM_PROVISION_DTL.BALANCE_DATE%TYPE,
         BALANCE_AMT    EMOB.MB_AGENT_COMM_PROVISION_DTL.BALANCE_AMT%TYPE,
         FLOAT_RATE     EMOB.MB_AGENT_COMM_PROVISION_DTL.FLOAT_RATE%TYPE,
         INT_AMT        EMOB.MB_AGENT_COMM_PROVISION_DTL.INT_AMT%TYPE,
         DEBIT_GL       EMOB.MB_AGENT_COMM_PROVISION_DTL.DEBIT_GL%TYPE,
         CREDIT_GL      EMOB.MB_AGENT_COMM_PROVISION_DTL.CREDIT_GL%TYPE
      );

      TYPE ACTYPE_PROV_TBL IS TABLE OF ACTYPE_WISE_PROV;

      ACTYPE_WISE_BALANCE   ACTYPE_PROV_TBL := ACTYPE_PROV_TBL (); --initialization-----------------

      vIntAmount            NUMBER := 0;
      ex_dml_errors         EXCEPTION;
      PRAGMA EXCEPTION_INIT (ex_dml_errors, -24381);
      vFloatRate            NUMBER := 0;
      vDrGL                 NUMBER := 0;
      vCrGL                 NUMBER := 0;
      vNewDocnum            EMOB.MB_TRANSACTION_DAILY.DOC_NUM%TYPE;
   BEGIN
      BEGIN
         SELECT GL_AC_ID
           INTO vPayableGl
           FROM EMOB.ST_COM_TRAN_GL_SETUP
          WHERE GL_AC_TYPE = 'PAY' AND STSTUS = 'Y';
      EXCEPTION
         WHEN OTHERS
         THEN
            vOracleError := SQLERRM;
            vErrorFlag := 'Y';
            vErrorMessage :=
               'Float Share Payable GL Finding Problem  On ' || pDate;

            GOTO END_LEVEL;
      END;

      BEGIN
         SELECT YEAR_DAY_FLT, VAT_PERCENT
           INTO vYearDays, vVatRate
           FROM EMOB.MB_GLOBAL_RULE;
      EXCEPTION
         WHEN OTHERS
         THEN
            vOracleError := SQLERRM;
            vErrorMessage :=
               'Global Rule - VAT Percentage not Found On ' || pDate;
            vErrorFlag := 'Y';
            GOTO END_LEVEL;
      END;

      BEGIN
           SELECT DISTINCT X.BRANCH_CODE, X.BRANCH_NAME
             BULK COLLECT INTO ALL_BRANCH
             FROM (SELECT A.BRANCH_CODE, A.BRANCH_NAME
                     FROM EMOB.CBS_BRANCH_LIST A
                          JOIN EMOB.ST_AGENT_POINT B
                             ON (    A.BRANCH_CODE = B.BRANCH_CODE
                                 AND b.branch_code =
                                        DECODE (pBranchCode,
                                                'ALL', b.branch_code,
                                                pBranchCode))) x
         ORDER BY 1;
      EXCEPTION
         WHEN OTHERS
         THEN
            vOracleError := SQLERRM;
            vErrorMessage := 'Branch Selection Problem   On ' || pDate;
            vErrorFlag := 'Y';
            GOTO END_LEVEL;
      END;

      BEGIN
         SELECT B.AC_TYPE_ID,
                B.CHG_VALUE,
                B.DR_GLAC_ID,
                vPayableGl
           BULK COLLECT INTO ACTYPE_FLOAT
           FROM EMOB.MB_PRODUCT_MST a, EMOB.MB_PRODUCT_CHG_MST b
          WHERE     A.AC_TYPE_ID = B.AC_TYPE_ID
                AND NVL (a.FLOAT_SHARING_ALLOW, 'N') = 'Y'
                AND pDate BETWEEN b.EFF_DATE AND TRUNC (SYSDATE);
      EXCEPTION
         WHEN OTHERS
         THEN
            vOracleError := SQLERRM;
            vErrorMessage :=
                  'Product Wise Float Rate & Expense GL Selection Problem  On '
               || pDate;
            vErrorFlag := 'Y';
            GOTO END_LEVEL;
      END;

      IF ALL_BRANCH.COUNT > 0
      THEN                    -- Main Branch Collection Has records to process
         FOR X IN ALL_BRANCH.FIRST .. ALL_BRANCH.LAST
         LOOP
            ACTYPE_WISE_BALANCE.DELETE;

            BEGIN
               SELECT COUNT (*)
                 INTO vProvExists
                 FROM EMOB.MB_AGENT_COMM_PROVISION_DTL
                WHERE     BRANCH_CODE = ALL_BRANCH (X).BRANCH_CODE
                      AND BALANCE_DATE = pDate;
            EXCEPTION
               WHEN OTHERS
               THEN
                  vOracleError := SQLERRM;
                  vErrorFlag := 'Y';
                  vErrorMessage :=
                     'Agent Commission Finding problem  On ' || pDate;
                  GOTO BRANCH_END_LEVEL;
            END;


            IF vProvExists > 0
            THEN
               vErrorFlag := 'Y';
               vErrorMessage :=
                     'Float Share Commission Already Done for This Branch on '
                  || pDate;
               GOTO BRANCH_END_LEVEL;
            END IF;

            BEGIN
               SELECT 0 PROVISION_ID,
                      BAL_INFO.BRANCH_CODE,
                      AGN_INFO.AGENT_ID,
                      BAL_INFO.POINT_ID,
                      BAL_INFO.AC_TYPE_ID,
                      PRM.FULL_DESC,
                      BAL_INFO.BALANCE_DATE,
                      BAL_INFO.TOTAL_BALANCE,
                      0 FLOAT_RATE,
                      0 INT_AMT,
                      0 DEBIT_GL,
                      0 CREDIT_GL
                 BULK COLLECT INTO ACTYPE_WISE_BALANCE
                 FROM (  SELECT AC_DTL.BRANCH_CODE,
                                AC_DTL.AC_TYPE_ID,
                                AC_DTL.POINT_ID,
                                ADB.BALANCE_DATE,
                                SUM (ADB.BALANCE) TOTAL_BALANCE
                           FROM EMOB.MB_ACCOUNT_DAILY_BALANCE ADB
                                JOIN
                                (SELECT ACM.BRANCH_CODE,
                                        ACM.CUST_NO,
                                        ACM.AC_TYPE_ID,
                                        ACM.AC_NO,
                                        (CASE
                                            WHEN ACM.POINT_ID IS NULL
                                            THEN
                                               (SELECT APO.POINT_ID
                                                  FROM EMOB.ST_AGENT_POINT APO
                                                 WHERE APO.AGENT_ID =
                                                          ACM.CUST_NO)
                                            ELSE
                                               ACM.POINT_ID
                                         END)
                                           POINT_ID
                                   FROM EMOB.MB_ACCOUNT_MST ACM
                                  WHERE ACM.BRANCH_CODE =
                                           ALL_BRANCH (X).BRANCH_CODE) AC_DTL
                                   ON (    ADB.ACCOUNT_NO = AC_DTL.AC_NO
                                       AND ADB.BALANCE_DATE = pDate)
                       GROUP BY AC_DTL.BRANCH_CODE,
                                AC_DTL.AC_TYPE_ID,
                                AC_DTL.POINT_ID,
                                ADB.BALANCE_DATE) BAL_INFO
                      JOIN EMOB.ST_AGENT_POINT AGN_INFO
                         ON (BAL_INFO.POINT_ID = AGN_INFO.POINT_ID)
                      JOIN EMOB.MB_PRODUCT_MST PRM
                         ON     (BAL_INFO.AC_TYPE_ID = PRM.AC_TYPE_ID)
                            AND NVL (PRM.FLOAT_SHARING_ALLOW, 'N') = 'Y';
            EXCEPTION
               WHEN OTHERS
               THEN
                  vOracleError := SQLERRM;
                  vErrorMessage :=
                        'Product Wise Balance Generation Problem for Branch '
                     || ALL_BRANCH (X).BRANCH_CODE
                     || ', On '
                     || pDate;

                  vErrorFlag := 'Y';
                  GOTO BRANCH_END_LEVEL;
            END;

            IF ACTYPE_WISE_BALANCE.COUNT > 0
            THEN
               FOR Y IN ACTYPE_WISE_BALANCE.FIRST .. ACTYPE_WISE_BALANCE.LAST
               LOOP
                  IF ACTYPE_FLOAT.COUNT > 0
                  THEN
                     FOR Z IN ACTYPE_FLOAT.FIRST .. ACTYPE_FLOAT.LAST
                     LOOP
                        IF ACTYPE_WISE_BALANCE (Y).AC_TYPE_ID =
                              ACTYPE_FLOAT (Z).AC_TYPE_ID
                        THEN
                           vFloatRate := ACTYPE_FLOAT (Z).FLOAT_RATE;
                           vDrGL := ACTYPE_FLOAT (Z).DR_GLAC_ID;
                           vCrGL := ACTYPE_FLOAT (Z).CR_GLAC_ID;

                           vIntAmount :=
                              ROUND (
                                   (  vFloatRate
                                    * ACTYPE_WISE_BALANCE (Y).BALANCE_AMT)
                                 / (vYearDays * 100),
                                 2);
                        END IF;
                     END LOOP;                        -- END ACTYPE_FLOAT LOOP

                     IF     NVL (vFloatRate, 0) = 0
                        AND ACTYPE_WISE_BALANCE (Y).BALANCE_AMT > 0
                     THEN
                        vOracleError := SQLERRM;
                        vErrorFlag := 'Y';
                        vErrorMessage :=
                              'Float Provision Rate not Found or Float Provision is Zero for Porduct '
                           || ACTYPE_WISE_BALANCE (Y).AC_TYPE_DESC
                           || ', On '
                           || pDate;
                        GOTO BRANCH_END_LEVEL;
                     END IF;

                     IF NVL (vDrGL, 0) = 0
                     THEN
                        vOracleError := SQLERRM;
                        vErrorFlag := 'Y';
                        vErrorMessage :=
                              'Expense GL not Found for Porduct '
                           || ACTYPE_WISE_BALANCE (Y).AC_TYPE_DESC
                           || ', On '
                           || pDate;
                        GOTO BRANCH_END_LEVEL;
                     END IF;

                     ACTYPE_WISE_BALANCE (Y).FLOAT_RATE := vFloatRate;
                     ACTYPE_WISE_BALANCE (Y).INT_AMT := vIntAmount;
                     ACTYPE_WISE_BALANCE (Y).DEBIT_GL := vDrGL;
                     ACTYPE_WISE_BALANCE (Y).CREDIT_GL := vPayableGl;
                  ELSE
                     vErrorFlag := 'Y';
                     vErrorMessage :=
                        'Product Wise Float Rate not found On ' || pDate;
                     GOTO END_LEVEL;
                  END IF;
               END LOOP;                       -- END ACTYPE_WISE_BALANCE LOOP
            ELSE
               vOracleError := SQLERRM;
               vErrorMessage :=
                     'Product Wise Balance Not Found for Branch '
                  || ALL_BRANCH (X).BRANCH_CODE
                  || ', On '
                  || pDate;

               vErrorFlag := 'Y';
               GOTO BRANCH_END_LEVEL;
            END IF;

            IF ACTYPE_WISE_BALANCE.COUNT > 0
            THEN
               BEGIN
                  EMOB.PRC_DOC_NUM_GENERATION (ALL_BRANCH (X).BRANCH_CODE,
                                               'IN',
                                               1,
                                               TRUNC (SYSDATE),
                                               vErrorFlag,
                                               vErrorMessage,
                                               vNewDocnum);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     vOracleError := SQLERRM;
                     vErrorFlag := 'Y';
                     vErrorMessage :=
                           'DOC Number Generation Problem for Branch'
                        || ALL_BRANCH (X).BRANCH_CODE
                        || ', On '
                        || pDate;
                     GOTO BRANCH_END_LEVEL;
               END;
            END IF;

            BEGIN
               IF ACTYPE_WISE_BALANCE.COUNT > 0
               THEN
                  FORALL W
                      IN ACTYPE_WISE_BALANCE.FIRST ..
                         ACTYPE_WISE_BALANCE.LAST
                    SAVE EXCEPTIONS
                     INSERT
                       INTO EMOB.MB_AGENT_COMM_PROVISION_DTL (PROVISION_ID,
                                                              BRANCH_CODE,
                                                              AGENT_NO,
                                                              POINT_ID,
                                                              AC_TYPE_ID,
                                                              BALANCE_DATE,
                                                              BALANCE_AMT,
                                                              FLOAT_RATE,
                                                              INT_AMT,
                                                              DEBIT_GL,
                                                              CREDIT_GL,
                                                              POST_FLAG,
                                                              EXPENSE_FLAG,
                                                              EXP_DOC_NO,
                                                              EXP_DOC_DATE)
                     VALUES (PROCESS_ID_SEQ.NEXTVAL,
                             ACTYPE_WISE_BALANCE (w).BRANCH_CODE,
                             ACTYPE_WISE_BALANCE (w).AGENT_NO,
                             ACTYPE_WISE_BALANCE (w).POINT_ID,
                             ACTYPE_WISE_BALANCE (w).AC_TYPE_ID,
                             ACTYPE_WISE_BALANCE (w).BALANCE_DATE,
                             ACTYPE_WISE_BALANCE (w).BALANCE_AMT,
                             ACTYPE_WISE_BALANCE (w).FLOAT_RATE,
                             ACTYPE_WISE_BALANCE (w).INT_AMT,
                             ACTYPE_WISE_BALANCE (w).DEBIT_GL,
                             ACTYPE_WISE_BALANCE (w).CREDIT_GL,
                             'N',
                             'Y',
                             vNewDocnum,
                             TRUNC (SYSDATE));
               END IF;
            EXCEPTION
               WHEN ex_dml_errors
               THEN
                  vOracleError := SQLERRM;
                  vErrorFlag := 'Y';
                  vErrorMessage :=
                        'Branch, Agent & Point wise Provision Creation Problem for - '
                     || ALL_BRANCH (X).BRANCH_CODE
                     || ', On '
                     || pDate;
                  GOTO BRANCH_END_LEVEL;
            END;

            IF ACTYPE_WISE_BALANCE.COUNT > 0
            THEN
               BEGIN
                  EMOB.PKG_AGENT_FLOAT_PROVISION.FLOAT_SHARING_EXPENSE (
                     pDate           => pDate,
                     pVatRate        => vVatRate,
                     pBranchCode     => ALL_BRANCH (X).BRANCH_CODE,
                     pDocNum         => vNewDocnum,
                     pErrorflag      => vErrorFlag,
                     pErrormessage   => vErrorMessage,
                     pOracleerror    => vOracleError);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     vOracleError := SQLERRM;
                     vErrorFlag := 'Y';
                     vErrorMessage :=
                           'Provision Share Expense & Payable Problem for Branch '
                        || ALL_BRANCH (X).BRANCH_CODE
                        || ', On '
                        || pDate;
                     GOTO BRANCH_END_LEVEL;
               END;

               IF NVL (vErrorFlag, 'N') = 'Y'
               THEN
                  vOracleError := SQLERRM;
                  vErrorFlag := 'Y';
                  GOTO BRANCH_END_LEVEL;
               END IF;
            END IF;

           ---------------Provision End----------
           <<BRANCH_END_LEVEL>>
            IF NVL (vErrorFlag, 'N') = 'Y'
            THEN
               ROLLBACK;

               BEGIN
                  PKG_AGENT_FLOAT_PROVISION.INSERT_FLOAT_ERROR_LOG (
                     pProcessId            => 'FLT_PROVISION',
                     PProcessName          => 'PKG_AGENT_FLOAT_PROVISION',
                     pOracleErrorMessage   => vOracleError,
                     pCustomErrorMessage   => vErrorMessage,
                     pCustomerCode         => NULL,
                     pAccountNo            => NULL,
                     pDescription          => vErrorMessage,
                     pRunUser              => 'SYSTEM',
                     PDbTableName          => NULL,
                     PDbColumnName         => NULL,
                     pBranchCode           => ALL_BRANCH (X).BRANCH_CODE);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     NULL;
               END;
            END IF;

            COMMIT;
         END LOOP;                                         --- END Branch Loop
      END IF;

      COMMIT;

     <<END_LEVEL>>
      IF NVL (vErrorFlag, 'N') = 'Y'
      THEN
         BEGIN
            PKG_AGENT_FLOAT_PROVISION.INSERT_FLOAT_ERROR_LOG (
               pProcessId            => 'FLT_PROVISION',
               PProcessName          => 'PKG_AGENT_FLOAT_PROVISION',
               pOracleErrorMessage   => vOracleError,
               pCustomErrorMessage   => vErrorMessage,
               pCustomerCode         => NULL,
               pAccountNo            => NULL,
               pDescription          => vErrorMessage,
               pRunUser              => 'SYSTEM',
               PDbTableName          => NULL,
               PDbColumnName         => NULL,
               pBranchCode           => NULL);
         EXCEPTION
            WHEN OTHERS
            THEN
               NULL;
         END;
      END IF;
   END;

   PROCEDURE FLOAT_SHARING_EXPENSE (pDate               DATE,
                                    pVatRate            NUMBER,
                                    pBranchCode         VARCHAR2,
                                    pDocNum             VARCHAR2,
                                    pErrorflag      OUT VARCHAR2,
                                    pErrorMessage   OUT VARCHAR2,
                                    pOracleError    OUT VARCHAR2)
   IS
      CURSOR PROVISION_LIST
      IS
         (  SELECT BRANCH_CODE,
                   DEBIT_GL,
                   CREDIT_GL,
                   SUM (NVL (BALANCE_AMT, 0)) PROCESS_AMT,
                   SUM (NVL (INT_AMT, 0)) INT_AMT
              FROM EMOB.MB_AGENT_COMM_PROVISION_DTL
             WHERE BRANCH_CODE = pBranchCode AND BALANCE_DATE = pDate
          GROUP BY BRANCH_CODE, DEBIT_GL, CREDIT_GL);

      vSerialNo       NUMBER := 0;
      vMyException    EXCEPTION;
      vDocsl          NUMBER := 0;
      vTranDocnum     VARCHAR2 (25);
      vVATCrGl        NUMBER;
      vErrorFlag      VARCHAR2 (10);
      vErrormessage   VARCHAR2 (1024);
      vOracleError    VARCHAR2 (1024);
   --  vProvisionTranSl NUMBER :=0;
   BEGIN
      BEGIN
         SELECT GL_AC_ID
           INTO vVATCrGl
           FROM EMOB.ST_COM_TRAN_GL_SETUP
          WHERE GL_AC_TYPE = 'VAT' AND STSTUS = 'Y';
      EXCEPTION
         WHEN OTHERS
         THEN
            pOracleError := SQLERRM;
            pErrorflag := 'Y';
            pErrormessage :=
                  'VAT GL finding Problem for Branch '
               || pBranchCode
               || ' on '
               || pDate;
            GOTO END_EXECUTION;
      END;


      FOR I IN PROVISION_LIST
      LOOP
         IF NVL (I.INT_AMT, 0) > 0
         THEN
            ----------------------------- Debit Payable &  Credit Agent Account-----------------------------
            vSerialNo := vSerialNo + 1;
            vDocSl := vDocSl + 1;
            vTranDocnum := pDocNum || vDocSl;

            BEGIN
               INSERT INTO EMOB.MB_TRANSACTION_DAILY (TRAN_ID,
                                                      BRANCH_CODE,
                                                      TRAN_TYPE,
                                                      DOC_NUM,
                                                      DOC_DATE,
                                                      VALUE_DATE,
                                                      SL_NUM,
                                                      TRAN_CODE,
                                                      NARATION,
                                                      DRCR_CODE,
                                                      CUR_CODE,
                                                      EX_RATE,
                                                      AC_TYPE_ID,
                                                      AC_ID,
                                                      TRAN_AMT_FC,
                                                      TRAN_AMT_LC,
                                                      CREATE_BY,
                                                      CREATE_DATE,
                                                      TRANS_BRANCH_CODE,
                                                      TRAN_DOC_NO,
                                                      CBS_STATUS,
                                                      CBS_REV_STATUS,
                                                      DR_AC_NO,
                                                      CR_AC_NO)
                    VALUES (EMOB.TRAN_ID_SEQ.NEXTVAL,
                            I.BRANCH_CODE,
                            'IN',
                            pDocNum,
                            TRUNC (SYSDATE),
                            TRUNC (SYSDATE),
                            vSerialNo,
                            '20',
                            'Expense Debit For Agent Float Commission',
                            'C',
                            'BDT',
                            1,
                            NULL,
                            NULL,
                            I.INT_AMT,
                            I.INT_AMT,
                            'SYSTEM',
                            SYSDATE,
                            I.BRANCH_CODE,
                            vTranDocnum,
                            'P',
                            NULL,
                            PKG_GLOBAL_OBJECTS.GET_CBSGL_CODE (I.DEBIT_GL),
                            PKG_GLOBAL_OBJECTS.GET_CBSGL_CODE (I.CREDIT_GL));
            EXCEPTION
               WHEN OTHERS
               THEN
                  pOracleError := SQLERRM;
                  pErrorFlag := 'Y';
                  pErrorMessage :=
                        'Expense Debit in Transaction Daily failed for Branch '
                     || pBranchCode
                     || ' on '
                     || pDate;

                  GOTO END_EXECUTION;
            END;
         END IF;
      END LOOP;

      IF vSerialNo = 0
      THEN
         pErrorFlag := 'Y';
         pErrorMessage :=
               'No Record Creation for Expense in Transaction Daily for Branch '
            || pBranchCode
            || ' on '
            || pDate;
         GOTO END_EXECUTION;
      END IF;


      BEGIN
         EMOB.PROCESS_TRANSACTION (pDocNum       => pDocNum,
                                   pBranchCode   => pBranchCode,
                                   pErrFlag      => vErrorFlag,
                                   pErrMsg       => vErrorMessage);
      EXCEPTION
         WHEN OTHERS
         THEN
            vErrorMessage := 'Process For CBS API Calling Problem.';
            vOracleError := SUBSTR (SQLERRM, 1, 500);
            vErrorFlag := 'Y';
            GOTO END_EXECUTION;
      END;

      IF NVL (vErrorFlag, 'N') = 'Y'
      THEN
         pErrorFlag := 'Y';
         pErrorMessage :=
               'CBS Transaction. API Error for Branch  '
            || pBranchCode
            || ' on '
            || pDate
            || vErrorMessage;
         GOTO END_EXECUTION;
      END IF;

      BEGIN
         INSERT INTO EMOB.MB_TRAN_COMM_PROVISION (TRAN_DATE,
                                                  DOC_NUM,
                                                  TRAN_CODE,
                                                  TRAN_AMOUNT,
                                                  COMM_ID,
                                                  CHARGE_AMOUNT,
                                                  AGENT_CHARGE,
                                                  BANK_CHARGE,
                                                  VAT_AMOUNT,
                                                  AGENT_AC_ID,
                                                  AGENT_NO,
                                                  REF_DOC_NO,
                                                  POST_FLAG,
                                                  POST_DATE,
                                                  POST_DOC_NUM,
                                                  CREATE_BY,
                                                  CREATE_DATE,
                                                  PAYABLE_GLID,
                                                  VAT_GLID,
                                                  BANK_CR_GLID,
                                                  POINT_ID,
                                                  REV_FLAG,
                                                  MONTH_CODE)
            (  SELECT TRUNC (SYSDATE),
                      pDocNum,
                      '20',
                      SUM (NVL (BALANCE_AMT, 0)) PROCESS_AMT,
                      NULL,                                      ----:COMM_ID,
                      SUM (NVL (INT_AMT, 0)) TOT_AMT,
                        SUM (NVL (INT_AMT, 0))
                      --   - ROUND ((  (SUM (NVL (INT_AMT, 0)) * pVatRate)/ (100 + pVatRate)), 2) it will decided vat will caclculate on posting time
                         AGENT_AMT,
                      0,
                      ROUND (
                         (  (SUM (NVL (INT_AMT, 0)) * pVatRate)
                          / (100 + pVatRate)),
                         2)
                         VAT_AMT,
                      (SELECT AC_ID
                         FROM EMOB.MB_ACCOUNT_MST
                        WHERE CUST_NO = C.AGENT_NO AND AC_STATUS = 'ACT')
                         AGENT_AC_ID,
                      AGENT_NO,
                      NULL,
                      'N',
                      NULL,
                      NULL,
                      'SYSTEM',
                      SYSDATE,
                      CREDIT_GL,
                      vVATCrGl,
                      NULL,
                      POINT_ID,
                      'N',
                      TO_CHAR (pDate, 'RRRRMM')
                 FROM EMOB.MB_AGENT_COMM_PROVISION_DTL C
                WHERE BRANCH_CODE = pBranchCode AND BALANCE_DATE = pDate
             GROUP BY AGENT_NO, POINT_ID, CREDIT_GL);
      EXCEPTION
         WHEN OTHERS
         THEN
            pOracleError := SQLERRM;
            pErrorFlag := 'Y';
            pErrorMessage :=
                  'Transaction Commission Provisioning Problem for Branch  '
               || pBranchCode
               || ' on '
               || pDate;
            GOTO END_EXECUTION;
      END;

      IF SQL%ROWCOUNT = 0
      THEN
         pErrorFlag := 'Y';
         pErrorMessage :=
               'No Record Create for Transaction Commission Provisioning for Branch  '
            || pBranchCode
            || ' on '
            || pDate;
         GOTO END_EXECUTION;
      END IF;

     <<END_EXECUTION>>
      IF NVL (pErrorFlag, 'N') = 'Y'
      THEN
         BEGIN
            PKG_AGENT_FLOAT_PROVISION.INSERT_FLOAT_ERROR_LOG (
               pProcessId            => 'FLT_EXPENSE',
               PProcessName          => 'PKG_PROVISION_AUTO.FLOAT_SHARING_EXPENSE',
               pOracleErrorMessage   => pOracleError,
               pCustomErrorMessage   => pErrorMessage || pBranchCode,
               pCustomerCode         => NULL,
               pAccountNo            => NULL,
               pDescription          => pErrorMessage || pBranchCode,
               pRunUser              => 'SYSTEM',
               PDbTableName          => NULL,
               PDbColumnName         => NULL,
               pBranchCode           => pBranchCode);
         EXCEPTION
            WHEN OTHERS
            THEN
               pErrorflag := 'Y';
               pErrorMessage := 'Error Log Generation Problem.';
               RAISE vMyException;
         END;
      END IF;
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorflag := 'Y';
   END;

   PROCEDURE FLOAT_SHARING_EXPENSE_REV (pDate               DATE,
                                        pErrorFlag      OUT VARCHAR2,
                                        pErrormessage   OUT VARCHAR2,
                                        pOracleerror    OUT VARCHAR2)
   IS
      CURSOR PROVISION_LIST (pDate DATE)
      IS
         (  SELECT BRANCH_CODE,
                   DEBIT_GL,
                   CREDIT_GL,
                   SUM (NVL (BALANCE_AMT, 0)) PROCESS_AMT,
                   SUM (NVL (INT_AMT, 0)) INT_AMT,
                   --SUM (NVL (VAT_AMT, 0))
                   0 VAT_AMT
              FROM EMOB.MB_AGENT_COMM_PROVISION_DTL C
             WHERE C.EXPENSE_FLAG = 'Y' AND BALANCE_DATE = pDate
          GROUP BY BRANCH_CODE, DEBIT_GL, CREDIT_GL);

      vSerialno       NUMBER := 0;
      vNewdocnum      VARCHAR2 (100);
      vMyException    EXCEPTION;
      vDocsl          NUMBER := 0;
      vTrandocnum     VARCHAR2 (25);
      vVATCrGl        NUMBER;
      vErrormessage   VARCHAR2 (1024);
      vOracleerror    VARCHAR2 (1024);
      vErrorflag      VARCHAR2 (10);
      vExpPostExist   NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO vExpPostExist
           FROM EMOB.MB_TRAN_COMM_PROVISION
          WHERE POST_FLAG = 'Y' AND TRAN_DATE = pDate AND TRAN_CODE = 20;
      EXCEPTION
         WHEN OTHERS
         THEN
            vOracleError := SQLERRM;
            pErrormessage := 'Post data Finding Problems';
            RAISE vMyException;
      END;


      IF vExpPostExist > 0
      THEN
         pErrormessage := 'Commission Already Posted For This Day';
         RAISE vMyException;
      END IF;


      BEGIN
         SELECT GL_AC_ID
           INTO vVATCrGl
           FROM EMOB.ST_COM_TRAN_GL_SETUP
          WHERE GL_AC_TYPE = 'VAT' AND STSTUS = 'Y';
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrormessage := 'Vat Gl Finding Problem';
            RAISE vMyException;
      END;


      BEGIN
         DELETE FROM EMOB.MB_TRAN_COMM_PROVISION
               WHERE     TRAN_DATE = pDate
                     AND POST_FLAG = 'N'
                     AND TRAN_CODE = '20';
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrormessage := 'Agent comnission  Delete Problem.-' || SQLERRM;
            RAISE vMyException;
      END;


      FOR I IN PROVISION_LIST (pDate)
      LOOP
         IF I.INT_AMT IS NOT NULL
         THEN
            BEGIN
               EMOB.PRC_DOC_NUM_GENERATION (I.BRANCH_CODE,
                                            'IN',
                                            1,
                                            pDate,
                                            pErrorFlag,
                                            pErrorMessage,
                                            vNewDocnum);
            EXCEPTION
               WHEN OTHERS
               THEN
                  vOracleError := SQLERRM;
                  vErrorMessage := 'Doc Number Generation Problem';
                  vErrorFlag := 'Y';
                  GOTO NEXT_LOOP;
            END;

            ----------------------------- Debit Payable &  Credit Expense-----------------------------

            vSerialNo := vSerialNo + 1;
            vDocSl := vDocSl + 1;
            vTranDocnum := vNewDocnum || vDocSl;


            BEGIN
               INSERT INTO EMOB.MB_TRANSACTION_DAILY (TRAN_ID,
                                                      BRANCH_CODE,
                                                      TRAN_TYPE,
                                                      DOC_NUM,
                                                      DOC_DATE,
                                                      VALUE_DATE,
                                                      SL_NUM,
                                                      TRAN_CODE,
                                                      NARATION,
                                                      DRCR_CODE,
                                                      CUR_CODE,
                                                      EX_RATE,
                                                      AC_TYPE_ID,
                                                      AC_ID,
                                                      TRAN_AMT_FC,
                                                      TRAN_AMT_LC,
                                                      CREATE_BY,
                                                      CREATE_DATE,
                                                      TRANS_BRANCH_CODE,
                                                      TRAN_DOC_NO,
                                                      CBS_STATUS,
                                                      CBS_REV_STATUS,
                                                      DR_AC_NO,
                                                      CR_AC_NO)
                    VALUES (EMOB.TRAN_ID_SEQ.NEXTVAL,
                            I.BRANCH_CODE,
                            'IN',
                            vNewDocnum,
                            TRUNC (pDate),
                            TRUNC (SYSDATE),
                            vSerialNo,
                            '20',
                            'Expense Reverse For Agent Float Commission',
                            'C',
                            'BDT',
                            1,
                            NULL,
                            NULL,
                            I.INT_AMT,
                            I.INT_AMT,
                            'SYSTEM',
                            SYSDATE,
                            I.BRANCH_CODE,
                            vTranDocnum,
                            'P',
                            NULL,
                            PKG_GLOBAL_OBJECTS.GET_CBSGL_CODE (I.CREDIT_GL),
                            PKG_GLOBAL_OBJECTS.GET_CBSGL_CODE (I.DEBIT_GL));
            EXCEPTION
               WHEN OTHERS
               THEN
                  vOracleError := SQLERRM;
                  vErrorMessage :=
                     'Expense Debit in Transaction Daily failed for -';
                  vErrorFlag := 'Y';
                  GOTO NEXT_LOOP;
            END;


            BEGIN
               DELETE FROM EMOB.MB_AGENT_COMM_PROVISION_DTL
                     WHERE     EXPENSE_FLAG = 'Y'
                           AND BRANCH_CODE = I.BRANCH_CODE
                           AND BALANCE_DATE = pDate;
            EXCEPTION
               WHEN OTHERS
               THEN
                  vOracleError := SQLERRM;
                  vErrorMessage := 'Agent Provision Delete Problem';
                  vErrorFlag := 'Y';
                  GOTO NEXT_LOOP;
            END;

            IF SQL%ROWCOUNT = 0
            THEN
               vErrorMessage := 'No record found for Update';
               vErrorFlag := 'Y';
               GOTO NEXT_LOOP;
            END IF;
         END IF;

         BEGIN
            EMOB.PROCESS_TRANSACTION (pDocNum       => vNewDocnum,
                                      pBranchCode   => I.BRANCH_CODE,
                                      pErrFlag      => vErrorFlag,
                                      pErrMsg       => vErrorMessage);
         EXCEPTION
            WHEN OTHERS
            THEN
               vErrorMessage := 'Process For CBS API Calling Problem.';
               vOracleError := SUBSTR (SQLERRM, 1, 500);
               vErrorFlag := 'Y';
               GOTO NEXT_LOOP;
         END;


         IF NVL (vErrorFlag, 'N') = 'Y'
         THEN
            vErrorMessage := 'API Error - ' || vErrorMessage;
            GOTO NEXT_LOOP;
         END IF;

        <<NEXT_LOOP>>
         IF NVL (vErrorFlag, 'N') = 'Y'
         THEN
            BEGIN
               PKG_AGENT_FLOAT_PROVISION.INSERT_FLOAT_ERROR_LOG (
                  pProcessId            => 'FLT_EXPENSE',
                  PProcessName          => 'PKG_PROVISION_AUTO.FLOAT_SHARING_EXPENSE',
                  pOracleErrorMessage   => vOracleError,
                  pCustomErrorMessage   => vErrorMessage || i.BRANCH_CODE,
                  pCustomerCode         => NULL,
                  pAccountNo            => NULL,
                  pDescription          => vErrorMessage || i.BRANCH_CODE,
                  pRunUser              => 'SYSTEM',
                  PDbTableName          => NULL,
                  PDbColumnName         => NULL,
                  pBranchCode           => i.BRANCH_CODE);
            EXCEPTION
               WHEN OTHERS
               THEN
                  GOTO END_LOOP;
            END;

            ROLLBACK;
         END IF;

         COMMIT;

        <<END_LOOP>>
         NULL;
      END LOOP;
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorFlag := 'Y';
   END;
END;
/
