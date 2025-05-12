CREATE OR REPLACE PACKAGE EMOB.PKG_AGENT_FLOAT_PROVISION
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
                                      pBranchCode            VARCHAR2);

    PROCEDURE PRC_FLOAT_PROVISION (pBranchCode VARCHAR2, pDate IN DATE);

    PROCEDURE FLOAT_SHARING_EXPENSE (pDate               DATE,
                                     pVatRate            NUMBER,
                                     pBranchCode         VARCHAR2,
                                     pDocNum             VARCHAR2,
                                     pErrorflag      OUT VARCHAR2,
                                     pErrormessage   OUT VARCHAR2,
                                     pOracleerror    OUT VARCHAR2);

    PROCEDURE FLOAT_SHARING_EXPENSE_REV (pDate               DATE,
                                         pErrorFlag      OUT VARCHAR2,
                                         pErrormessage   OUT VARCHAR2,
                                         pOracleerror    OUT VARCHAR2);
END;
/
