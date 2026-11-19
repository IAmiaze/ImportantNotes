DROP PACKAGE GUMS.APEX_JWT_TOKEN;

CREATE OR REPLACE PACKAGE GUMS.APEX_JWT_TOKEN
AS
    PROCEDURE GET_TOKEN (pUserName       VARCHAR2,
                         pUserPass       VARCHAR2,
                         pStatus     OUT VARCHAR2,
                         ptoken      OUT VARCHAR2,
                         pMsg        OUT VARCHAR2);

    PROCEDURE TOKEN_VALIDATION (pAuthorization       VARCHAR2,
                                pUserId          OUT VARCHAR2,
                                pUserCode        OUT VARCHAR2,
                                pUserName        OUT VARCHAR2,
                                pMobileNo        OUT VARCHAR2,
                                pEmail           OUT VARCHAR2,
                                pBranchCode      OUT VARCHAR2,
                                pLogId           OUT VARCHAR2,
                                pStatus          OUT VARCHAR2,
                                pMsg             OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.APP_CHANGE_IMG;

CREATE OR REPLACE PACKAGE GUMS.APP_CHANGE_IMG
IS
    TYPE DB_RECORD_BLOB IS RECORD
    (
        DB_col_name         VARCHAR2 (100),
        DB_col_value        BLOB,
        db_col_value_vc2    VARCHAR2 (1024) DEFAULT NULL,
        db_col_value_clob   CLOB DEFAULT NULL,
        db_col_mime_type   CLOB DEFAULT NULL,
        db_col_file_name   CLOB DEFAULT NULL
    );

    TYPE DB_OLD_BLOB IS TABLE OF DB_RECORD_BLOB
        INDEX BY BINARY_INTEGER;



    PROCEDURE REQUEST_CHANGE_LOG (pColList              DB_OLD_BLOB,
                                  pRunUser              VARCHAR2,
                                  pTableName            VARCHAR2,
                                  pKeyCol               VARCHAR2,
                                  pSchemaName           VARCHAR2,
                                  pKeyColvalue          VARCHAR2,
                                  pSessionId            VARCHAR2,
                                  pPageId               NUMBER,
                                  pBranchCode           VARCHAR2,
                                  pRequestPurpose       VARCHAR2,
                                  pRequestStatus        VARCHAR2,
                                  pKeyCol2              VARCHAR2,
                                  pKeyColValue2         VARCHAR2,
                                  pRecIdentifier    OUT  NUMBER,
                                  pOutData          OUT CLOB,
                                  pErrorFlag        OUT VARCHAR2,
                                  pErrorMsg         OUT VARCHAR2);

    PROCEDURE REQUEST_INCLUDE_LOG (--pInJson               CLOB,
                                   pColList              DB_OLD_BLOB,
                                   pRunUser              VARCHAR2,
                                   pTableName            VARCHAR2,
                                   pKeyCol               VARCHAR2,
                                   pSchemaName           VARCHAR2,
                                   pKeyColvalue          VARCHAR2,
                                   pSessionId            VARCHAR2,
                                   pPageId               NUMBER,
                                   pBranchCode           VARCHAR2,
                                   pRequestPurpose       VARCHAR2,
                                   pRequestStatus        VARCHAR2,
                                   pKeyCol2              VARCHAR2,
                                   pKeyColValue2         VARCHAR2,
                                   pRecIdentifier   IN  NUMBER,
                                   pOutData          OUT CLOB,
                                   pErrorFlag        OUT VARCHAR2,
                                   pErrorMsg         OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.BO_TRANSACTION;

CREATE OR REPLACE PACKAGE GUMS.BO_TRANSACTION
IS
    PROCEDURE PRC_BO_TRANSFER_TRANSACTION (pEntryType              VARCHAR2,
                                           pAiBanchCode            VARCHAR2,
                                           pAiUserId               VARCHAR2,
                                           pRunUser                VARCHAR2,
                                           pAmount                 NUMBER,
                                           pDrCr                   VARCHAR2,
                                           pTempTranNo      IN OUT VARCHAR2,
                                           pAcNo                   VARCHAR2,
                                           pAcType                 VARCHAR2,
                                           pAcTypeId               VARCHAR2,
                                           pTranType               VARCHAR2,
                                           pTempTranNoDis   IN OUT VARCHAR2,
                                           pTempTranNoLov   IN OUT VARCHAR2,
                                           pTranNature             VARCHAR2,
                                           pBranchCode             VARCHAR2,
                                           pNarration              VARCHAR2,
                                           pOprType                VARCHAR2,
                                           pTranMode               VARCHAR2,
                                           pTranCode               VARCHAR2,
                                           pErrorFlag          OUT VARCHAR2,
                                           pErrorMsg           OUT VARCHAR2);

    PROCEDURE PRC_BO_TRANSFER_TRAN_UPDATE (pEntryType            VARCHAR2,
                                           pAiBanchCode          VARCHAR2,
                                           pAiUserId             VARCHAR2,
                                           pRunUser              VARCHAR2,
                                           pAmount               NUMBER,
                                           pTempTranNo    IN     VARCHAR2,
                                           pDrCr                 VARCHAR2,
                                           pAcNo                 VARCHAR2,
                                           pAcType               VARCHAR2,
                                           pAcTypeId             VARCHAR2,
                                           pTranType             VARCHAR2,
                                           pTranNature           VARCHAR2,
                                           pBranchCode           VARCHAR2,
                                           pNarration            VARCHAR2,
                                           pErrorFlag        OUT VARCHAR2,
                                           pErrorMsg         OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.CORE_BANK_API_CONSUME;

CREATE OR REPLACE PACKAGE GUMS.CORE_BANK_API_CONSUME
IS
   PROCEDURE LIB_MONTH_END_APPROVAL (pModuleDate     IN     DATE,
                                     pAcTypeId       IN     NUMBER,
                                     pAiUserId       IN     VARCHAR2,
                                     pAiLogId        IN     VARCHAR2,
                                     pApprovReject   IN     VARCHAR2,
                                     pErrorFlag         OUT VARCHAR2,
                                     pErrorMessage      OUT VARCHAR2);

   PROCEDURE ASS_MONTH_END_APPROVAL (pModuleDate     IN     DATE,
                                     pAcTypeId       IN     NUMBER,
                                     pAiUserId       IN     VARCHAR2,
                                     pAiLogId        IN     VARCHAR2,
                                     pApprovReject   IN     VARCHAR2,
                                     pPROVISION_ID   IN     VARCHAR2,
                                     pErrorFlag         OUT VARCHAR2,
                                     pErrorMessage      OUT VARCHAR2);

   PROCEDURE RESCHEDULE_APPROVAL (pModuleDate     IN     DATE,
                                  pAcId           IN     NUMBER,
                                  pAiUserId       IN     VARCHAR2,
                                  pAiLogId        IN     VARCHAR2,
                                  pApprovReject   IN     VARCHAR2,
                                  pDocNum            OUT VARCHAR2,
                                  pErrorFlag         OUT VARCHAR2,
                                  pErrorMessage      OUT VARCHAR2);

   PROCEDURE LOAN_RESCHEDULE_CALCULATION (
      pModuleDate          IN     DATE,
      pBranchCode          IN     VARCHAR2,
      pAcNo                IN     VARCHAR2,
      pAcId                   OUT NUMBER,
      pCustNo                 OUT NUMBER,
      pAcTypeId               OUT NUMBER,
      pAccountTitle           OUT VARCHAR2,
      pIntRate                OUT NUMBER,
      pInsFrequency           OUT VARCHAR2,
      pNoOfInstall         IN OUT NUMBER,
      pTotalIntAmt            OUT NUMBER,
      pPrinInstallAmt         OUT NUMBER,
      pIntInstallAmt          OUT NUMBER,
      pNonPostIntAmt          OUT NUMBER,
      pDayBasisIntAmt         OUT NUMBER,
      pAcBalAmt               OUT NUMBER,
      pClStatus               OUT VARCHAR2,
      pSusAmt                 OUT NUMBER,
      pBlAmt                  OUT NUMBER,
      pReschAmt               OUT NUMBER,
      pLastProvisionDate      OUT VARCHAR2,
      pErrorFlag              OUT VARCHAR2,
      pErrorMessage           OUT VARCHAR2);

   PROCEDURE POST_DPS_ACCOUNT_CREATION_API (
      pModuleDate       IN     VARCHAR2,
      pBranchCode       IN     VARCHAR2,
      pAcTypeId         IN     NUMBER,
      pAcTitle          IN     VARCHAR2,
      pCustno           IN     NUMBER,
      pGuarMemberCode   IN     VARCHAR2,
      pOprIns           IN     VARCHAR2,
      pSector           IN     VARCHAR2,
      pInstallAmt       IN     NUMBER,
      pInsFrq           IN     VARCHAR2,
      pInterestRate     IN     NUMBER,
      pTermPeriod       IN     NUMBER,
      pTimeFrq          IN     VARCHAR2,
      pMaturityDate     IN     VARCHAR2,
      pMaturityAmt      IN     NUMBER,
      pEffectFrom       IN     VARCHAR2,
      pEffectDate       IN     VARCHAR2,
      pLinkAcDr         IN     VARCHAR2,
      pIntroType        IN     VARCHAR2,
      pIntroAcNo        IN     VARCHAR2,
      pIntroName        IN     VARCHAR2,
      pIntroAddress     IN     VARCHAR2,
      pIntroMobile      IN     VARCHAR2,
      pIntroRelation    IN     VARCHAR2,
      pIntroPosition    IN     VARCHAR2,
      pIntroOthers      IN     VARCHAR2,
      pAiUserId         IN     VARCHAR2,
      pAcId                OUT NUMBER,
      pAcNo                OUT VARCHAR2,
      pErrorFlag           OUT VARCHAR2,
      pErrorMessage        OUT VARCHAR2);

   PROCEDURE POST_DPS_ACCOUNT_NOMINEE_IMG_API (
      pNomineeId      IN     NUMBER,
      pNomImg         IN     CLOB,
      pDocFrontImg    IN     CLOB,
      pDocBackImg     IN     CLOB,
      pcreateby       IN     VARCHAR2,
      pErrorFlag         OUT VARCHAR2,
      pErrorMessage      OUT VARCHAR2);

   PROCEDURE PRC_DPS_RESULT_INFO (pAcId                IN     NUMBER,
                                  pExamName            IN     VARCHAR2,
                                  pBoardName           IN     VARCHAR2,
                                  pRegNo               IN     VARCHAR2,
                                  pRollNo              IN     VARCHAR2,
                                  pDefaultIntRate      IN     NUMBER,
                                  pAfterGPAIntRate     IN     NUMBER,
                                  pResultPublishDate   IN     VARCHAR2,
                                  pGpa                 IN     NUMBER,
                                  pAiUserId            IN     VARCHAR2,
                                  pErrorFlag              OUT VARCHAR2,
                                  pErrorMessage           OUT VARCHAR2);

   PROCEDURE POST_DPS_ACCOUNT_NOMINEE_CREATION_API (
      pCustno             IN     NUMBER,
      pAcId               IN     NUMBER,
      pNomineeName        IN     VARCHAR2,
      pNomiFatherName     IN     VARCHAR2,
      pNomiMotherName     IN     VARCHAR2,
      pNomiDob            IN     VARCHAR2,
      pNomiRelation       IN     VARCHAR2,
      pNominomPercent     IN     NUMBER,
      pNomiDocumentType   IN     VARCHAR2,
      pNomiDocmentNo      IN     VARCHAR2,
      pNomiType           IN     VARCHAR2,
      pAiUserId           IN     VARCHAR2,
      pNomineeId             OUT NUMBER,
      pErrorFlag             OUT VARCHAR2,
      pErrorMessage          OUT VARCHAR2);

   PROCEDURE GET_DPS_SERVICE_INFO_API (pModuleDate        IN     VARCHAR2,
                                       pEffectDate        IN     VARCHAR2,
                                       pAcTypeId          IN     NUMBER,
                                       pInstallAmt        IN     NUMBER,
                                       pTermPeriod        IN     NUMBER,
                                       pDepositInterval      OUT VARCHAR2,
                                       pIntRate              OUT NUMBER,
                                       pMaturityDate         OUT DATE,
                                       pMaturityAmount       OUT NUMBER,
                                       pErrorFlag            OUT VARCHAR2,
                                       pErrorMessage         OUT VARCHAR2);

   PROCEDURE DPS_CLOSE_CALCULATION (pModuleDate      IN     DATE,
                                    pBranchCode      IN     VARCHAR2,
                                    pAcNo            IN     VARCHAR2,
                                    pAcId               OUT NUMBER,
                                    pAcTypeId           OUT NUMBER,
                                    pAccountTitle       OUT VARCHAR2,
                                    pOpenDate           OUT DATE,
                                    pLinkAcNo           OUT NUMBER,
                                    pMobileNo           OUT VARCHAR2,
                                    pMatureRate         OUT NUMBER,
                                    pMaturityDate       OUT DATE,
                                    pDpsBalance         OUT NUMBER,
                                    pInstAmt            OUT NUMBER,
                                    pTotalInstNo        OUT NUMBER,
                                    pPaidInstNo         OUT NUMBER,
                                    pPrematureRate      OUT NUMBER,
                                    pIntProfit          OUT NUMBER,
                                    pClosingChg         OUT NUMBER,
                                    pIncomeTax          OUT NUMBER,
                                    pExciseDuty         OUT NUMBER,
                                    pPostedIntAmt       OUT NUMBER,
                                    pProvIntAmt         OUT NUMBER,
                                    pProvRevAmt         OUT NUMBER,
                                    pProvAdjAmt         OUT NUMBER,
                                    pPostIntAmt         OUT NUMBER,
                                    pPostRevAmt         OUT NUMBER,
                                    pTotalPayable       OUT NUMBER,
                                    pErrorFlag          OUT VARCHAR2,
                                    pErrorMessage       OUT VARCHAR2);


   PROCEDURE CASA_CLOSE_CALCULATION (pModuleDate     IN     DATE,
                                     pBranchCode     IN     VARCHAR2,
                                     pAcNo           IN     VARCHAR2,
                                     pAcId              OUT NUMBER,
                                     pCustNo            OUT NUMBER,
                                     pAcTypeId          OUT NUMBER,
                                     pAccountTitle      OUT VARCHAR2,
                                     pAcStatus          OUT VARCHAR2,
                                     pOpenDate          OUT DATE,
                                     pMemberCode        OUT VARCHAR2,
                                     pMemberName        OUT VARCHAR2,
                                     pMobileNo          OUT VARCHAR2,
                                     pCurrBalance       OUT NUMBER,
                                     pBlockAmt          OUT NUMBER,
                                     pIntProfit         OUT NUMBER,
                                     pClosingChg        OUT NUMBER,
                                     pIncomeTax         OUT NUMBER,
                                     pExciseDuty        OUT NUMBER,
                                     pPostedIntAmt      OUT NUMBER,
                                     pProvIntAmt        OUT NUMBER,
                                     pProvRevAmt        OUT NUMBER,
                                     pPostIntAmt        OUT NUMBER,
                                     pPostRevAmt        OUT NUMBER,
                                     pTotalPayable      OUT NUMBER,
                                     pGovGrant          OUT NUMBER,
                                     pErrorFlag         OUT VARCHAR2,
                                     pErrorMessage      OUT VARCHAR2);



   PROCEDURE DPS_CLOSE_REQUEST (pModuleDate      IN     DATE,
                                pBranchCode      IN     VARCHAR2,
                                pAcTypeId        IN     NUMBER,
                                pAcId            IN     NUMBER,
                                pClosingReason   IN     VARCHAR2,
                                pAiUserId        IN     VARCHAR2,
                                pAccountTitle    IN     VARCHAR2,
                                pOpenDate        IN     DATE,
                                pLinkAcNo        IN     NUMBER,
                                pMobileNo        IN     VARCHAR2,
                                pMatureRate      IN     NUMBER,
                                pMaturityDate    IN     DATE,
                                pDpsBalance      IN     NUMBER,
                                pInstAmt         IN     NUMBER,
                                pTotalInstNo     IN     NUMBER,
                                pPaidInstNo      IN     NUMBER,
                                pPrematureRate   IN     NUMBER,
                                pIntProfit       IN     NUMBER,
                                pClosingChg      IN     NUMBER,
                                pIncomeTax       IN     NUMBER,
                                pExciseDuty      IN     NUMBER,
                                pPostedIntAmt    IN     NUMBER,
                                pProvIntAmt      IN     NUMBER,
                                pProvRevAmt      IN     NUMBER,
                                pProvAdjAmt      IN     NUMBER,
                                pPostIntAmt      IN     NUMBER,
                                pPostRevAmt      IN     NUMBER,
                                pTotalPayable    IN     NUMBER,
                                pErrorFlag          OUT VARCHAR2,
                                pErrorMessage       OUT VARCHAR2);

   PROCEDURE POST_DEAD_REQUEST (pBranchCode     IN     VARCHAR2,
                                pSamiteeCode    IN     VARCHAR2,
                                pCustNo         IN     NUMBER,
                                pDeathDate      IN     DATE,
                                pDeathDecDate    IN     DATE,
                                pOverDue        IN     NUMBER,
                                pDocDeadImage   IN     CLOB,
                                pAiUserId       IN     VARCHAR2,
                                pErrorFlag         OUT VARCHAR2,
                                pErrorMessage      OUT VARCHAR2);

   PROCEDURE PRC_INSERT_DEAD_CERTIFICATE (pCustNo         IN     NUMBER,
                                          pDocDeadImage   IN     CLOB,
                                          pAiUserId       IN     VARCHAR2,
                                          pErrorFlag         OUT VARCHAR2,
                                          pErrorMessage      OUT VARCHAR2);

   PROCEDURE PRC_INSERT_BANK_LOGO (pBankCode       IN     VARCHAR2,
                                   pBankLogo       IN     CLOB,
                                   pErrorFlag         OUT VARCHAR2,
                                   pErrorMessage      OUT VARCHAR2);

   PROCEDURE DPS_CLOSE_APPROVAL (pModuleDate     IN     DATE,
                                 pBranchCode     IN     VARCHAR2,
                                 pAcId           IN     NUMBER,
                                 pAiUserId       IN     VARCHAR2,
                                 pAiLogId        IN     VARCHAR2,
                                 pApprovReject   IN     VARCHAR2,
                                 pDocNum            OUT VARCHAR2,
                                 pErrorFlag         OUT VARCHAR2,
                                 pErrorMessage      OUT VARCHAR2);

   PROCEDURE CASA_CLOSE_APPROVAL (pModuleDate     IN     DATE,
                                  pBranchCode     IN     VARCHAR2,
                                  pAcId           IN     NUMBER,
                                  pAiUserId       IN     VARCHAR2,
                                  pAiLogId        IN     VARCHAR2,
                                  pApprovReject   IN     VARCHAR2,
                                  pDocNum            OUT VARCHAR2,
                                  pErrorFlag         OUT VARCHAR2,
                                  pErrorMessage      OUT VARCHAR2);

   PROCEDURE GET_DPS_AGE_INFO_API (pModuleDate     IN     VARCHAR2,
                                   pMemberCode     IN     VARCHAR2,
                                   pAcTypeId       IN     NUMBER,
                                   pErrorFlag         OUT VARCHAR2,
                                   pErrorMessage      OUT VARCHAR2);

   PROCEDURE REQUEST_CHANGE_LOG (pInJson              CLOB,
                                 pRecIdentifier   OUT NUMBER,
                                 pOutData         OUT CLOB,
                                 pErrorFlag       OUT VARCHAR2,
                                 pErrorMsg        OUT VARCHAR2);

   PROCEDURE REQUEST_INCLUDE_LOG (pInJson              CLOB,
                                  pRecIdentifier   OUT NUMBER,
                                  pOutData         OUT CLOB,
                                  pErrorFlag       OUT VARCHAR2,
                                  pErrorMsg        OUT VARCHAR2);

   PROCEDURE SEND_CUSTOMER_DOC_API (pRequestID         PLS_INTEGER,
                                    pDocType           VARCHAR2,
                                    pDocNo             VARCHAR2,
                                    pIssueDate         DATE,
                                    pExpireDate        DATE,
                                    pIssuePlace        VARCHAR2,
                                    pDocFrontImg       CLOB,
                                    pDocBackImg        CLOB,
                                    pSuccessMsg    OUT VARCHAR2,
                                    pErrorFlag     OUT VARCHAR2,
                                    pErrorMsg      OUT VARCHAR2);

   PROCEDURE SEND_GUARANTOR_DOC_API (pCustNo               NUMBER,
                                     pDocType              VARCHAR2,
                                     pDocNo                VARCHAR2,
                                     pDocStatus            VARCHAR2,
                                     pIssueDate            DATE,
                                     pExpireDate           DATE,
                                     pIssuePlace           VARCHAR2,
                                     pDocFront             CLOB,
                                     pDocBack              CLOB,
                                     pErrorMessage     OUT VARCHAR2,
                                     pErrorFlag        OUT VARCHAR2,
                                     pSuccessMessage   OUT VARCHAR2);

   PROCEDURE SEND_TM_CUST_IMG_API (pRequestID        PLS_INTEGER,
                                   pCustImage        CLOB,
                                   pErrorflag    OUT VARCHAR2,
                                   pErrorMsg     OUT VARCHAR2,
                                   pSuccessMsg   OUT VARCHAR2);

   PROCEDURE REQUEST_CHANGE_APPROVAL (pRecordIdentifier       NUMBER,
                                      pRunUser                VARCHAR2,
                                      pErrorFlag          OUT VARCHAR2,
                                      pErrorMessage       OUT VARCHAR2);

   PROCEDURE REQUEST_REJECT (pRecordIdentifier       NUMBER,
                             pRunUser                VARCHAR2,
                             pErrorFlag          OUT VARCHAR2,
                             pErrorMessage       OUT VARCHAR2);

   PROCEDURE INCLUDE_REQUEST_APPROVAL (pRecordIdentifier       NUMBER,
                                       pRunUser                VARCHAR2,
                                       pErrorFlag          OUT VARCHAR2,
                                       pErrorMessage       OUT VARCHAR2);

   PROCEDURE GET_GLAC_CODE (pParentId           NUMBER,
                            pParentChild        VARCHAR2,
                            pParentGlCode       VARCHAR2,
                            pDisplaySl      OUT NUMBER,
                            pLevelCode      OUT NUMBER,
                            pGlAcCode       OUT VARCHAR2,
                            pErrorFlag      OUT VARCHAR2,
                            pErrorMessage   OUT VARCHAR2);

   PROCEDURE GET_HOLIDAY_ID (pBranchCode         NUMBER,
                             pDate               DATE,
                             pHolidayDesc    OUT NUMBER,
                             pHolidayId      OUT NUMBER,
                             pActiveFlag     OUT VARCHAR2,
                             pErrorFlag      OUT VARCHAR2,
                             pErrorMessage   OUT VARCHAR2);

   PROCEDURE CUSTOMER_REVIEW_REQUEST_API (pRequestID           PLS_INTEGER,
                                          pReviewStatius       VARCHAR2,
                                          pAppUser             VARCHAR2,
                                          pRemarks             VARCHAR2,
                                          pMemberCode      OUT VARCHAR2,
                                          pErrorflag       OUT VARCHAR2,
                                          pErrorMsg        OUT VARCHAR2,
                                          pSuccessMsg      OUT VARCHAR2);

   PROCEDURE PRODUCT_APPROVAL (pRequestId            NUMBER,
                               pApprovalStatus       VARCHAR2,
                               pRunUser              VARCHAR2,
                               pErrorMsg         OUT VARCHAR2,
                               pErrorFlag        OUT VARCHAR2);

   PROCEDURE CASA_NOMINEE_ADD (pNomineeId      IN     NUMBER,
                               pNomImg         IN     CLOB,
                               pDocFrontImg    IN     CLOB,
                               pDocBackImg     IN     CLOB,
                               pcreateby       IN     VARCHAR2,
                               pErrorFlag         OUT VARCHAR2,
                               pErrorMessage      OUT VARCHAR2);

   PROCEDURE PRC_TAX_RETURN_REQUEST (pBranchCode       VARCHAR2,
                                     pAcNo             VARCHAR2,
                                     pCustNo           NUMBER,
                                     pACId             NUMBER,
                                     pDocfrontimage    CLOB,
                                     pDocbackimage     CLOB,
                                     pAssesyear        VARCHAR2,
                                     pTin              VARCHAR2,
                                     pCircle           VARCHAR2,
                                     pTaxzone          VARCHAR2,
                                     pSerialno         VARCHAR2,
                                     pSubmitdate       DATE,
                                     pStatus           VARCHAR2,
                                     pAiUserId         VARCHAR2,
                                     pErrorFlag   OUT     VARCHAR2,
                                     pErrorMessage  OUT   VARCHAR2);
END;
/


DROP PACKAGE GUMS.CORE_BANK_API_CONSUME_IMG;

CREATE OR REPLACE PACKAGE GUMS.CORE_BANK_API_CONSUME_IMG
IS
    TYPE DB_RECORD_BLOB IS RECORD
    (
        DB_col_name         VARCHAR2 (100),
        DB_col_value        BLOB,
        db_col_value_vc2    VARCHAR2 (1024) DEFAULT NULL
    );

    TYPE DB_OLD_BLOB IS TABLE OF DB_RECORD_BLOB
        INDEX BY BINARY_INTEGER;



    PROCEDURE REQUEST_CHANGE_LOG (pInJson               CLOB,
                                  pColList              DB_OLD_BLOB,
                                  pRunUser              VARCHAR2,
                                  pTableName            VARCHAR2,
                                  pKeyCol               VARCHAR2,
                                  pSchemaName           VARCHAR2,
                                  pKeyColvalue          VARCHAR2,
                                  pSessionId            VARCHAR2,
                                  pPageId               NUMBER,
                                  pBranchCode           VARCHAR2,
                                  pRequestPurpose       VARCHAR2,
                                  pRequestStatus        VARCHAR2,
                                  pKeyCol2              VARCHAR2,
                                  pKeyColValue2         VARCHAR2,
                                  pRecIdentifier    OUT NUMBER,
                                  pOutData          OUT CLOB,
                                  pErrorFlag        OUT VARCHAR2,
                                  pErrorMsg         OUT VARCHAR2);

    PROCEDURE REQUEST_INCLUDE_LOG (pInJson               CLOB,
                                   pColList              DB_OLD_BLOB,
                                   pRunUser              VARCHAR2,
                                   pTableName            VARCHAR2,
                                   pKeyCol               VARCHAR2,
                                   pSchemaName           VARCHAR2,
                                   pKeyColvalue          VARCHAR2,
                                   pSessionId            VARCHAR2,
                                   pPageId               NUMBER,
                                   pBranchCode           VARCHAR2,
                                   pRequestPurpose       VARCHAR2,
                                   pRequestStatus        VARCHAR2,
                                   pKeyCol2              VARCHAR2,
                                   pKeyColValue2         VARCHAR2,
                                   pRecIdentifier    OUT NUMBER,
                                   pOutData          OUT CLOB,
                                   pErrorFlag        OUT VARCHAR2,
                                   pErrorMsg         OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.CORE_TRANSACTION;

CREATE OR REPLACE PACKAGE GUMS.CORE_TRANSACTION
IS
    PROCEDURE GET_AC_INFO_DEPOSIT (pAcNo                   VARCHAR2,
                                   pBranchCode             VARCHAR2,
                                   pAcId               OUT NUMBER,
                                   pAcTypeId           OUT NUMBER,
                                   pCustNo             OUT NUMBER,
                                   pCustCode           OUT VARCHAR2,
                                   pAcTitle            OUT VARCHAR2,
                                   pAcBranch           OUT VARCHAR2,
                                   pAvailableBalance   OUT NUMBER,
                                   pBlockAmount        OUT NUMBER,
                                   pMobileNo           OUT VARCHAR2,
                                   pAcType             OUT VARCHAR2,
                                   pDepNature          OUT VARCHAR2,
                                   pAcStatus           OUT VARCHAR2,
                                   pErrorFlag          OUT VARCHAR2,
                                   pErrorMessage       OUT VARCHAR2);

    PROCEDURE GET_AC_INFO_WITHDRAW (pAcNo                   VARCHAR2,
                                    pBranchCode             VARCHAR2,
                                    pCustNo             OUT NUMBER,
                                    pCustCode           OUT VARCHAR2,
                                    pAcTitle            OUT VARCHAR2,
                                    pAcBranch           OUT VARCHAR2,
                                    pAvailableBalance   OUT NUMBER,
                                    pBlockAmount        OUT NUMBER,
                                    pMobileNo           OUT VARCHAR2,
                                    pAcType             OUT VARCHAR2,
                                    pErrorFlag          OUT VARCHAR2,
                                    pErrorMessage       OUT VARCHAR2);
                                    
                                    
                                    
PROCEDURE GET_AC_INFO_DEPOSIT_ALL (pAcNo                   VARCHAR2,
                                   pBranchCode             VARCHAR2,
                                   pAcId               OUT NUMBER,
                                   pAcTypeId           OUT NUMBER,
                                   pCustNo             OUT NUMBER,
                                   PCustName           OUT VARCHAR2,
                                   pCustCode           OUT VARCHAR2,
                                   pAcTitle            OUT VARCHAR2,
                                   pAcBranch           OUT VARCHAR2,
                                   pAvailableBalance   OUT NUMBER,
                                   pBlockAmount        OUT NUMBER,
                                   pMobileNo           OUT VARCHAR2,
                                   pAcType             OUT VARCHAR2,
                                   pDepNature          OUT VARCHAR2,
                                   pAcStatus           OUT VARCHAR2,
                                   pErrorFlag          OUT VARCHAR2,
                                   pErrorMessage       OUT VARCHAR2);

PROCEDURE GET_AC_INFO_CASA (pAcNo                   VARCHAR2,
                                   pBranchCode             VARCHAR2,
                                   pAcId               OUT NUMBER,
                                   pAcTypeId           OUT NUMBER,
                                   pCustNo             OUT NUMBER,
                                   pCustCode           OUT VARCHAR2,
                                   pAcTitle            OUT VARCHAR2,
                                   pAcBranch           OUT VARCHAR2,
                                   pAvailableBalance   OUT NUMBER,
                                   pBlockAmount        OUT NUMBER,
                                   pMobileNo           OUT VARCHAR2,
                                   pAcType             OUT VARCHAR2,
                                   pDepNature          OUT VARCHAR2,
                                   pAcStatus           OUT VARCHAR2,
                                   pErrorFlag          OUT VARCHAR2,
                                   pErrorMessage       OUT VARCHAR2);
                                   
PROCEDURE GET_LINK_AC_INFO (pAcNo                   VARCHAR2,
                                   pBranchCode             VARCHAR2,
                                   pAcId               OUT NUMBER,
                                   pAcTypeId           OUT NUMBER,
                                   pCustNo             OUT NUMBER,
                                   PCustName           OUT VARCHAR2,
                                   pFatherName         OUT VARCHAR2,
                                   pMotherName         OUT VARCHAR2,
                                   pCustDob            OUT DATE,
                                   pGender             OUT VARCHAR2,
                                   pMemberCode         OUT VARCHAR2,
                                   pAcTitle            OUT VARCHAR2,
                                   pAcBranch           OUT VARCHAR2,
                                   pAvailableBalance   OUT NUMBER,
                                   pBlockAmount        OUT NUMBER,
                                   pMobileNo           OUT VARCHAR2,
                                   pAcType             OUT VARCHAR2,
                                   pDepNature          OUT VARCHAR2,
                                   pAcStatus           OUT VARCHAR2,
                                   pLinkDbAc           OUT NUMBER,
                                   pLinkCrAc           OUT NUMBER,
                                   pErrorFlag          OUT VARCHAR2,
                                   pErrorMessage       OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.DPK_SECURITY;

CREATE OR REPLACE PACKAGE GUMS.DPK_SECURITY
IS
    FUNCTION DFN_CREATE_PASSWORD_ENCRYPTED (userid   IN VARCHAR2,
                                            passwd   IN VARCHAR2)
        RETURN VARCHAR2;

    FUNCTION DFN_PASSWORD_POLICY
        RETURN VARCHAR2;

    PROCEDURE DPR_PASSWORD_CHANGE (in_userid        IN     VARCHAR2,
                                   in_oldpassword   IN     VARCHAR2,
                                   in_newpassword   IN     VARCHAR2,
                                   in_repassword    IN     VARCHAR2,
                                   out_message         OUT VARCHAR2,
                                   out_code            OUT INTEGER);

    PROCEDURE PRC_UPDATE_LOGOUT_INFORMATION (pLogId VARCHAR2 DEFAULT NULL);

    PROCEDURE DPR_PASSWORD_FORGOT (pUserCode           VARCHAR2,
                                   pUserDOB            DATE,
                                   pMobileNo           VARCHAR2,
                                   pErrorFlag      OUT VARCHAR2,
                                   pErrorMessage   OUT VARCHAR2);

    PROCEDURE DPR_PASSWORD_RESET (pUserid         IN     VARCHAR2,
                                  pRunUser        IN     VARCHAR2,
                                  pErrorMessage      OUT VARCHAR2,
                                  pErrorFlag         OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.GET_LOAN_REPAYMENT_CLOSING;

CREATE OR REPLACE PACKAGE GUMS.GET_LOAN_REPAYMENT_CLOSING
IS
    PROCEDURE LOAN_REPAYMENT_AC_DETAILS (pLoanAcNo       IN     VARCHAR2,
                                         pPayAmount      IN     NUMBER,
                                         pPaymentType    IN     VARCHAR2,
                                         pBranchCode     IN     VARCHAR2,
                                         pAcTittle          OUT VARCHAR2,
                                         pLinkAcNo          OUT VARCHAR2,
                                         pLinkAcTittle      OUT VARCHAR2,
                                         pLinkAcBal         OUT NUMBER,
                                         pProduct           OUT VARCHAR2,
                                         pLoanAmt           OUT NUMBER,
                                         pDisburseDate      OUT DATE,
                                         pIntRate           OUT NUMBER,
                                         pExpIntRate        OUT NUMBER,
                                         pTerm              OUT NUMBER,
                                         pDuePrincipal      OUT NUMBER,
                                         pDueInt            OUT NUMBER,
                                         pDueInstallNo      OUT NUMBER,
                                         pInstallNo         OUT NUMBER,
                                         pLoanType          OUT VARCHAR2,
                                         pOnlyEmp           OUT VARCHAR2,
                                         pLinkAcBranch      OUT VARCHAR2,
                                         pLoanAcBranch      OUT VARCHAR2,
                                         pErrorFlag         OUT VARCHAR2,
                                         pErrorMessage      OUT VARCHAR2);

    PROCEDURE LOAN_CLOSE_AC_DETAILS (pLoanAcNo        IN     VARCHAR2,
                                     pPaymentType     IN     VARCHAR2,
                                     pBranchCode      IN     VARCHAR2,
                                     pRunUser         IN     VARCHAR2,
                                     pLogId           IN     VARCHAR2,
                                     pModuleDate      IN     DATE,
                                     pSettlementAmt      OUT NUMBER,
                                     pAcTittle           OUT VARCHAR2,
                                     pLinkAcNo           OUT VARCHAR2,
                                     pLinkAcTittle       OUT VARCHAR2,
                                     pLinkAcBal          OUT NUMBER,
                                     pProduct            OUT VARCHAR2,
                                     pLoanAmt            OUT NUMBER,
                                     pDisburseDate       OUT DATE,
                                     pIntRate            OUT NUMBER,
                                     pExpIntRate         OUT NUMBER,
                                     pTerm               OUT NUMBER,
                                     pDuePrincipal       OUT NUMBER,
                                     pDueInt             OUT NUMBER,
                                     pDueInstallNo       OUT NUMBER,
                                     pInstallNo          OUT NUMBER,
                                     pLoanType           OUT VARCHAR2,
                                     pOnlyEmp            OUT VARCHAR2,
                                     pLinkAcBranch       OUT VARCHAR2,
                                     pLoanAcBranch       OUT VARCHAR2,
                                     pErrorFlag          OUT VARCHAR2,
                                     pErrorMessage       OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.JWT_UTIL;

CREATE OR REPLACE PACKAGE GUMS.jwt_util AS
  FUNCTION generate_token(
    p_username IN VARCHAR2,
    p_expiry_minutes IN NUMBER
  ) RETURN VARCHAR2;
  
  FUNCTION verify_token(
    p_token IN VARCHAR2
  ) RETURN BOOLEAN;
END jwt_util;
/


DROP PACKAGE GUMS.PKG_CHANGE_REQUEST_APP;

CREATE OR REPLACE PACKAGE GUMS.PKG_CHANGE_REQUEST_APP
IS
   TYPE DB_RECORD IS RECORD
   (
      DB_col_name    VARCHAR2 (100),
      DB_col_value   VARCHAR2 (2048)
   );

   TYPE DB_OLD IS TABLE OF DB_Record
      INDEX BY BINARY_INTEGER;



   TYPE DB_RECORD_CLOB IS RECORD
   (
      DB_col_name        VARCHAR2 (100),
      DB_col_value       BLOB,
      DB_Img_flag        VARCHAR2 (1) DEFAULT 'Y',
      db_col_value_vc2   VARCHAR2 (1024) DEFAULT NULL
   );

   TYPE DB_OLD_clob IS TABLE OF DB_Record_clob
      INDEX BY BINARY_INTEGER;


   TYPE DB_RECORD_CLOB_TBL IS RECORD
   (
      DB_col_name        VARCHAR2 (100),
      APP_LEVEL_NAME     VARCHAR2 (100) DEFAULT NULL,
      DB_col_value       BLOB,
      DB_Img_flag        VARCHAR2 (1) DEFAULT 'Y',
      db_col_value_vc2   VARCHAR2 (1024) DEFAULT NULL
   );

   TYPE DB_TBL_clob IS TABLE OF DB_RECORD_CLOB_TBL
      INDEX BY BINARY_INTEGER;



   FUNCTION IS_NUMBER (p_string IN VARCHAR2)
      RETURN INT;

   FUNCTION BLOB_COMPARE (pBLOB1 BLOB, pBLOB2 BLOB)
      RETURN INT;

   PROCEDURE REQUEST_CHANGE_LOG (
      pTableName            VARCHAR2,
      pKeyCol               VARCHAR2,
      pKeyColValue          VARCHAR2,
      pNewData              CLOB,
      pOldData              CLOB DEFAULT NULL,
      pRequestPurpose       VARCHAR2,
      pPageId               NUMBER,
      pPageName             VARCHAR2,
      pRunUser              VARCHAR2,
      pSessionId            VARCHAR2,
      pBranchCode           VARCHAR2 DEFAULT NULL,
      pRecIdentifier    OUT NUMBER,
      pSchemaName           VARCHAR2 DEFAULT 'GUMS',
      pRequestStatus        VARCHAR2 DEFAULT 'R',
      pRetData          OUT CLOB,
      pErrorFlag        OUT VARCHAR2,
      pErrorMessage     OUT VARCHAR2);

   PROCEDURE DB_OLD_VALUE_RETRIVE (
      pColName            VARCHAR2,
      pTableName          VARCHAR2,
      pKeyCol             VARCHAR2,
      pKeyColValue        VARCHAR2,
      pSchemaName         VARCHAR2 DEFAULT 'GUMS',
      pDbOldData      OUT GUMS.PKG_CHANGE_REQUEST_APP.DB_OLD,
      pErrorFlag      OUT VARCHAR2,
      pErrorMessage   OUT VARCHAR2);

   PROCEDURE REQUEST_CHANGE_APPROVAL (
      pRecordIdentifier       VARCHAR2,
      pKeyColumn              VARCHAR2,
      pKeyColValue            VARCHAR2,
      pTableName              VARCHAR2,
      pRunUser                VARCHAR2,
      pTaskID                 NUMBER DEFAULT NULL,
      pErrorFlag          OUT VARCHAR2,
      pErrorMessage       OUT VARCHAR2);

   PROCEDURE APPROVE_CHANGE_REQUEST (
      pRecordIdentifier       NUMBER,
      pRunUser                VARCHAR2,
      pTaskID                 NUMBER DEFAULT NULL,
      pErrorFlag          OUT VARCHAR2,
      pErrorMessage       OUT VARCHAR2);

   PROCEDURE REQUEST_INCLUDE_LOG (
      pTableName            VARCHAR2,
      pRequestPurpose       VARCHAR2,
      pPageId               NUMBER,
      pPageName             VARCHAR2,
      pRunUser              VARCHAR2,
      pSessionId            VARCHAR,
      pBranchCode           VARCHAR2 DEFAULT NULL,
      pDetailInfo           VARCHAR2 DEFAULT NULL,
      pRecIdentifier    OUT NUMBER,
      pSchemaName           VARCHAR2 DEFAULT 'GUMS',
      pRequestStatus        VARCHAR2 DEFAULT 'R',
      pNewData              CLOB,
      pRetData          OUT CLOB,
      pErrorFlag        OUT VARCHAR2,
      pErrorMessage     OUT VARCHAR2);

   PROCEDURE REQUEST_INCLUDE_APPROVAL (
      pRecIdentifier       NUMBER,
      pRunUser             VARCHAR2,
      pTaskID              NUMBER DEFAULT NULL,
      pErrorFlag       OUT VARCHAR2,
      pErrorMessage    OUT VARCHAR2);

   PROCEDURE REQUEST_REJECT (pRecIdentifier       NUMBER,
                             pRunUser             VARCHAR2,
                             pTaskID              NUMBER DEFAULT NULL,
                             pErrorFlag       OUT VARCHAR2,
                             pErrorMessage    OUT VARCHAR2);

   PROCEDURE PRC_CREATE_USER (p_user_login_id   IN     VARCHAR2,
                              p_user_name       IN     VARCHAR2,
                              p_user_dob        IN     DATE,
                              p_mobile_no       IN     VARCHAR2,
                              p_email_id        IN     VARCHAR2,
                              p_branch          IN     VARCHAR2,
                              pCreateBy         IN     VARCHAR2,
                              pCreateDate       IN     DATE,
                              pTaskId           IN     NUMBER,
                              p_ai_user_id      IN     NUMBER,  -- :AI_USER_ID
                              p_role_json       IN     CLOB, -- :ROLE (JSON with Roles array)
                              p_ai_app_link     IN     VARCHAR2, -- :AI_APP_LINK (base URL)
                              pErrorFlag           OUT VARCHAR2,
                              pErrorMsg            OUT VARCHAR2);

   PROCEDURE PRC_USER_INFO_CHANGE (
      -- User identity & basic info
      p_user_id               IN VARCHAR2,
      p_user_name             IN GUMS.MB_USER_MST.USER_NAME%TYPE,
      p_user_name_h           IN GUMS.MB_USER_MST.USER_NAME%TYPE,
      p_dob                   IN DATE,
      p_dob_h                 IN DATE,
      p_mobile_no             IN VARCHAR2,
      p_mobile_no_h           IN VARCHAR2,
      p_email                 IN GUMS.MB_USER_MST.EMAIL_ID%TYPE,
      p_email_h               IN GUMS.MB_USER_MST.EMAIL_ID%TYPE,
      p_branch                IN GUMS.MB_USER_MST.BRANCH_CODE%TYPE,
      p_branch_h              IN GUMS.MB_USER_MST.BRANCH_CODE%TYPE,
      p_status                IN GUMS.MB_USER_MST.USER_STS%TYPE,
      p_status_h              IN GUMS.MB_USER_MST.USER_STS%TYPE,
      -- Role change JSON & old role snapshot
      p_role_old              IN CLOB,
      p_role_change           IN CLOB,
      -- Image flag (equivalent of :IMAGE item; value unused except NULL check)
      p_image_flag            IN CLOB,
      -- APEX approval/task context
      p_apex_task_id          IN NUMBER,
      p_apex_task_subject     IN VARCHAR2,
      p_apex_task_initiator   IN VARCHAR2,
      -- Application context
      p_app_user              IN VARCHAR2,
      p_ai_user_id            IN NUMBER,
      p_ai_app_link           IN VARCHAR2,
      pErrorFlag              OUT VARCHAR2,
      pErrorMsg               OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.PKG_DPS_AC_CASH_TRANSACTION;

CREATE OR REPLACE PACKAGE GUMS.PKG_DPS_AC_CASH_TRANSACTION
IS
   PROCEDURE PRC_DPS_CASH_INFO (pAcTypeId             NUMBER,
                                pAcId                 NUMBER,
                                pOprBranch            VARCHAR2,
                                pTimePeriod       OUT NUMBER,
                                pDueIns           OUT NUMBER,
                                pPaidIns          OUT NUMBER,
                                pInsAmount        OUT NUMBER,
                                pDpsTotalInsAmt   OUT NUMBER,
                                pDpsInsPenal      OUT NUMBER,
                                pTotalAmt         OUT NUMBER,
                                pChargeCrGlAc     OUT VARCHAR2,
                                pEffDate          OUT VARCHAR2,
                                pErrorFlag        OUT VARCHAR2,
                                pErrorMessage     OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.PKG_FDR_PRODUCT;

CREATE OR REPLACE PACKAGE GUMS.PKG_FDR_PRODUCT
IS
    PROCEDURE GET_FDR_SERVICE_INFO_API (pModuleDate       IN     VARCHAR2,
                                        pAcTypeId         IN     NUMBER,
                                        pInstallAmt       IN     NUMBER,
                                        pTermPeriod       IN     NUMBER,
                                        pIntRate             OUT NUMBER,
                                        pMaturityDate        OUT VARCHAR2,
                                        pMaturityAmount      OUT NUMBER,
                                        pErrorFlag           OUT VARCHAR2,
                                        pErrorMessage        OUT VARCHAR2);

    PROCEDURE POST_FDR_ACCOUNT_CREATION_API (pModuleDate     IN     VARCHAR2,
                                             pBranchCode     IN     VARCHAR2,
                                             pAcTypeId       IN     NUMBER,
                                             pAcTitle        IN     VARCHAR2,
                                             pCustno         IN     NUMBER,
                                             pMaturityIns    IN     VARCHAR2,
                                             pInstallAmt     IN     NUMBER,
                                             pInsFrq         IN     VARCHAR2,
                                             pInterestRate   IN     NUMBER,
                                             pTermPeriod     IN     NUMBER,
                                             pTimeFrq        IN     VARCHAR2,
                                             pMaturityDate   IN     VARCHAR2,
                                             pMaturityAmt    IN     NUMBER,
                                             pLinkAcDr       IN     VARCHAR2,
                                             pAiUserId       IN     VARCHAR2,
                                             pAcId              OUT NUMBER,
                                             pAcNo              OUT VARCHAR2,
                                             pErrorFlag         OUT VARCHAR2,
                                             pErrorMessage      OUT VARCHAR2);

    PROCEDURE FDR_CLOSE_CALCULATION_API (pmoduledate         IN     DATE,
                                         pbranchcode         IN     VARCHAR2,
                                         pacno               IN     VARCHAR2,
                                         pacid                  OUT NUMBER,
                                         pactypeid              OUT NUMBER,
                                         paccounttitle          OUT VARCHAR2,
                                         popendate              OUT VARCHAR2,
                                         plinkacno              OUT NUMBER,
                                         pmobileno              OUT VARCHAR2,
                                         pfdrtermmonths         OUT VARCHAR2,
                                         pmaturerate            OUT NUMBER,
                                         pmaturitydate          OUT VARCHAR2,
                                         pdpsbalance            OUT NUMBER,
                                         pincometax             OUT NUMBER,
                                         pexciseduty            OUT NUMBER,
                                         pprovision             OUT NUMBER,
                                         pneedprovision         OUT NUMBER,
                                         preverseprovision      OUT NUMBER,
                                         pprofitpayable         OUT NUMBER,
                                         ptotalpayable          OUT NUMBER,
                                         perrorflag             OUT VARCHAR2,
                                         perrormessage          OUT VARCHAR2);


    PROCEDURE FDR_CLOSE_REQUEST_API (pModuleDate         IN     DATE,
                                     pBranchCode         IN     VARCHAR2,
                                     pAcNo               IN     VARCHAR2,
                                     pAcTypeId           IN     NUMBER,
                                     pAcId               IN     NUMBER,
                                     pClosingReason      IN     VARCHAR2,
                                     pAiUserId           IN     VARCHAR2,
                                     pAccountTitle       IN     VARCHAR2,
                                     pOpenDate           IN     DATE,
                                     pLinkAcNo           IN     NUMBER,
                                     pMobileNo           IN     VARCHAR2,
                                     pMatureRate         IN     NUMBER,
                                     pMaturityDate       IN     DATE,
                                     pDpsBalance         IN     NUMBER,
                                     pIncomeTax          IN     NUMBER,
                                     pExciseDuty         IN     NUMBER,
                                     pProvision          IN     NUMBER,
                                     pNeedProvision      IN     NUMBER,
                                     pReverseProvision   IN     NUMBER,
                                     pProfitpayable      IN     NUMBER,
                                     pTotalPayable       IN     NUMBER,
                                     pErrorFlag             OUT VARCHAR2,
                                     pErrorMessage          OUT VARCHAR2);


    PROCEDURE FDR_CLOSE_APPROVAL_API (pmoduledate     IN     DATE,
                                      pbranchcode     IN     VARCHAR2,
                                      pacid           IN     NUMBER,
                                      paiuserid       IN     VARCHAR2,
                                      pailogid        IN     VARCHAR2,
                                      papprovreject   IN     VARCHAR2,
                                      pDocNum            OUT VARCHAR2,
                                      perrorflag         OUT VARCHAR2,
                                      perrormessage      OUT VARCHAR2);


    PROCEDURE GET_FDR_ACC_INFO_API (pmoduledate            IN     DATE,
                                    pbranchcode            IN     VARCHAR2,
                                    pacno                  IN     VARCHAR2,
                                    pacid                     OUT NUMBER,
                                    pactypeid                 OUT NUMBER,
                                    paccounttitle             OUT VARCHAR2,
                                    pfulldesc                OUT VARCHAR2,
                                    paccountstatus            OUT VARCHAR2,
                                    pmobileno                 OUT VARCHAR2,
                                    pcustno                   OUT NUMBER,
                                    psamiteecode              OUT VARCHAR2,
                                    pmembercode               OUT VARCHAR2,
                                    pmaturerate               OUT NUMBER,
                                    pmaturitydate             OUT VARCHAR2,
                                    pmaturityamount           OUT NUMBER,
                                    pdepositamount            OUT NUMBER,
                                    pfdrtermmonths            OUT VARCHAR2,
                                    pfdrtermmonthsdis            OUT VARCHAR2,
                                    popendate                 OUT VARCHAR2,
                                    pmaturityinstructiondsc   OUT VARCHAR2,
                                    pmaturityinstruction      OUT VARCHAR2,
                                    perrorflag                OUT VARCHAR2,
                                    perrormessage             OUT VARCHAR2);
END PKG_FDR_PRODUCT;
/


DROP PACKAGE GUMS.PKG_FETCH_FROM_REST;

CREATE OR REPLACE PACKAGE GUMS.PKG_FETCH_FROM_REST
IS
    TYPE rec_account_info IS RECORD
    (
        sl_no                  INTEGER,
        branch_code            VARCHAR2 (4 BYTE),
        ac_type_id             NUMBER,
        ac_id                  NUMBER,
        ac_no                  VARCHAR2 (16 BYTE),
        ac_title               VARCHAR2 (200 BYTE),
        cust_no                NUMBER,
        open_date              DATE,
        close_date             DATE,
        ac_status              VARCHAR2 (3 BYTE),
        create_by              VARCHAR2 (50 BYTE),
        create_date            DATE,
        update_by              VARCHAR2 (50 BYTE),
        update_date            DATE,
        sector_code            VARCHAR2 (10 BYTE),
        security_code          VARCHAR2 (5 BYTE),
        economy_code           VARCHAR2 (5 BYTE),
        final_check            VARCHAR2 (1 BYTE),
        final_check_by         VARCHAR2 (50 BYTE),
        final_check_date       DATE,
        final_remarks          VARCHAR2 (200 BYTE),
        ac_nature              VARCHAR2 (1 BYTE),
        opr_ins                VARCHAR2 (3 BYTE),
        last_provision_date    DATE,
        asst_lib               VARCHAR2 (1 BYTE),
        cl_status              VARCHAR2 (3 BYTE),
        is_prov_allow          VARCHAR2 (1 BYTE),
        old_ac_no              VARCHAR2 (16 BYTE),
        loan_amount            NUMBER
    );

    TYPE ACCOUNT_INFO_TB IS TABLE OF rec_account_info;

    TYPE rec_customer_info IS RECORD
    (
        sl_no                 INTEGER,
        branch_code           VARCHAR2 (7 BYTE),
        samitee_code          VARCHAR2 (12 BYTE),
        cust_no               NUMBER,
        member_code           VARCHAR2 (11 BYTE),
        member_type           VARCHAR2 (3 BYTE),
        parent_member         NUMBER,
        first_name            VARCHAR2 (100 BYTE),
        last_name             VARCHAR2 (60 BYTE),
        father_name           VARCHAR2 (60 BYTE),
        mother_name           VARCHAR2 (60 BYTE),
        cust_dob              VARCHAR2 (50 BYTE),
        gender                VARCHAR2 (1 BYTE),
        maritual_status       VARCHAR2 (3 BYTE),
        spouse_name           VARCHAR2 (60 BYTE),
        nationality           VARCHAR2 (3 BYTE),
        no_of_children        NUMBER,
        son                   NUMBER,
        daughter              NUMBER,
        no_of_dependant       NUMBER (3),
        religious_code        VARCHAR2 (3 BYTE),
        last_education        VARCHAR2 (3 BYTE),
        cust_status           VARCHAR2 (3 BYTE),
        occupation_code       VARCHAR2 (3 BYTE),
        sector_code           VARCHAR2 (3 BYTE),
        employee_id           VARCHAR2 (50 BYTE),
        annual_income         NUMBER,
        source_of_fund        NUMBER,
        is_verified_sof       VARCHAR2 (1 BYTE),
        fund_source           VARCHAR2 (10 BYTE),
        resident_status       VARCHAR2 (1 BYTE),
        political_exposed     VARCHAR2 (1 BYTE),
        income_person         NUMBER,
        income_male           NUMBER,
        income_female         NUMBER,
        media                 VARCHAR2 (3 BYTE),
        live_period           NUMBER,
        home_desc             VARCHAR2 (100 BYTE),
        family_guardian       VARCHAR2 (1 BYTE),
        father_land           VARCHAR2 (1 BYTE),
        REMARK                VARCHAR2 (150 BYTE),
        create_by             VARCHAR2 (50 BYTE),
        create_date           DATE,
        update_by             VARCHAR2 (50 BYTE),
        update_date           DATE,
        check_by              VARCHAR2 (50 BYTE),
        check_date            DATE,
        review_status         VARCHAR2 (1 BYTE),
        close_by              VARCHAR2 (50 BYTE),
        close_date            DATE,
        mobile_no             VARCHAR2 (200 BYTE),
        mail_id               VARCHAR2 (200 BYTE),
        mobile_no2            VARCHAR2 (30 BYTE),
        is_nid_verified       VARCHAR2 (1 BYTE),
        nid_approve_date      DATE,
        nid_approve_user      VARCHAR2 (5 BYTE),
        is_dead               VARCHAR2 (1 BYTE),
        death_date            DATE,
        death_approve_date    DATE,
        death_approve_user    VARCHAR2 (20 BYTE)
    );



    TYPE CUSTOMER_INFO_TB IS TABLE OF REC_CUSTOMER_INFO;

    TYPE rec_product_info IS RECORD
    (
        sl_no                          INTEGER,
        ac_type_id                     NUMBER,
        asst_lib                       VARCHAR2 (1),
        opening_date                   DATE,
        product_class                  VARCHAR2 (3),
        ac_type                        VARCHAR2 (3),
        full_desc                      VARCHAR2 (100),
        short_desc                     VARCHAR2 (10),
        cl_cat_no                      VARCHAR2 (5),
        cl_sub_cat                     VARCHAR2 (5),
        over_due_extend                NUMBER,
        min_sanc_amt                   NUMBER,
        max_sanc_amt                   NUMBER,
        term                           NUMBER,
        is_visible                     VARCHAR2 (1) DEFAULT 'N',
        grace_period_allowed           VARCHAR2 (2),
        grace_period_month             NUMBER,
        idgp                           VARCHAR2 (2) DEFAULT 'N',
        only_employee                  VARCHAR2 (1) DEFAULT 'N',
        product_glac_id                NUMBER,
        income_gl_acc                  NUMBER,
        prv_debit_glac_id              NUMBER,
        prv_credit_glac_id             NUMBER,
        allow_debit_bal                VARCHAR2 (1),
        cheque_allow                   VARCHAR2 (1),
        create_by                      VARCHAR2 (50),
        create_date                    DATE,
        check_status                   VARCHAR2 (1),
        check_by                       VARCHAR2 (50),
        check_date                     DATE,
        dep_nature                     VARCHAR2 (1),
        realization_seq_principle      NUMBER (1),
        realization_seq_int            NUMBER (1),
        realization_seq_charge         NUMBER (1),
        int_post_period                VARCHAR2 (3),
        int_cal_method                 VARCHAR2 (1),
        realization_seq_ioo            NUMBER,
        realization_seq_penal_int      NUMBER,
        allow_int_provision            VARCHAR2 (1),
        min_bal                        NUMBER,
        tp_allow                       VARCHAR2 (1),
        ins_frequency                  VARCHAR2 (1),
        max_default_ins_allow          NUMBER (22),
        fine_allow                     VARCHAR2 (1),
        ins_start_day                  NUMBER (22),
        ins_end_day                    NUMBER (22),
        ins_holiday_allow              VARCHAR2 (1),
        default_ins_maturity_alllow    VARCHAR2 (1),
        grace_period_days              NUMBER (3),
        update_by                      VARCHAR2 (50),
        update_date                    DATE,
        death_risk_allow               VARCHAR2 (1),
        link_ac_mandatory              VARCHAR2 (1),
        nid_verify_req                 VARCHAR2 (1),
        is_minor  VARCHAR2 (1)
    );

    TYPE rec_nominee_info IS RECORD
    (
        sl_no            INTEGER,
        NOMINEE_ID       NUMBER,
        AC_ID            NUMBER,
        NOMINEE_NAME     VARCHAR2 (1000),
        FATHER_NAME      VARCHAR2 (1000),
        MOTHER_NAME      VARCHAR2 (1000),
        DOB              DATE,
        RELATION         VARCHAR2 (10),
        NOM_PERCENT      NUMBER,
        CREATE_BY        VARCHAR2 (1000),
        CREATE_DATE      DATE,
        UPDATE_BY        VARCHAR2 (1000),
        UPDATE_DATE      DATE,
        CUST_NO          NUMBER,
        DOCUMENT_TYPE    VARCHAR2 (10),
        DOCMENT_NO       VARCHAR2 (30)
    );

    TYPE NOMINEE_INFO_TB IS TABLE OF rec_nominee_info;

    TYPE PRODUCT_INFO_TB IS TABLE OF REC_PRODUCT_INFO;

    FUNCTION PRC_API_CALL_EMOB_REST_ENABLED_SQL (pSqltextclob CLOB)
        RETURN CLOB;

    FUNCTION GET_ACCOUNT_INFO
        RETURN ACCOUNT_INFO_TB
        PIPELINED;

    FUNCTION GET_CUSTOMER_INFO
        RETURN CUSTOMER_INFO_TB
        PIPELINED;

    FUNCTION GET_CUSTOMER_INFO_BY_FILTER (pBranchCode    VARCHAR2,
                                          pSamiteeCode   VARCHAR2)
        RETURN CUSTOMER_INFO_TB
        PIPELINED;

    FUNCTION GET_PRODUCT_INFO
        RETURN PRODUCT_INFO_TB
        PIPELINED;

    FUNCTION GET_NOMINEE_INFO
        RETURN NOMINEE_INFO_TB
        PIPELINED;

    FUNCTION PRC_API_CALL_MEMIMG_REST_ENABLED_SQL (pSqltextclob CLOB)
        RETURN CLOB;

    FUNCTION GET_ACCOUNT_INFO_FILTER_BY_BRANCH (
        pBranchCode   VARCHAR2,
        pCustNo       NUMBER DEFAULT NULL,
        pAcTypeId     NUMBER DEFAULT NULL)
        RETURN ACCOUNT_INFO_TB
        PIPELINED;
END PKG_FETCH_FROM_REST;
/


DROP PACKAGE GUMS.PKG_GLOBAL_EMAIL;

CREATE OR REPLACE PACKAGE GUMS.PKG_GLOBAL_EMAIL
IS
    -- Public types
    TYPE T_SPLIT_ARRAY IS TABLE OF VARCHAR2 (4000);


    TYPE MSG_BOX IS RECORD
    (
        user_code VARCHAR2 (100),
        failed_code VARCHAR2 (5),
        failed_reason VARCHAR2 (1024),
        failed_count NUMBER
    );

    TYPE USER_MSG_BOX IS TABLE OF msg_box
        INDEX BY BINARY_INTEGER;

    PROCEDURE EMAIL_GENERATE_SEND (pMailType              VARCHAR2, -- Not nulll GUMS.MAIL_TYPE_INFO.MAIL_TYPE
                                   pMailTo                VARCHAR2, -- NOT null,   UESR/CUSTOMER/ACCHolder
                                   pMailRefNo             VARCHAR2, -- NOT null if USER then user_id, if Customer then cust_nn so on,
                                   p1                     VARCHAR2 DEFAULT NULL,
                                   p2                     VARCHAR2 DEFAULT NULL,
                                   p3                     VARCHAR2 DEFAULT NULL,
                                   p4                     VARCHAR2 DEFAULT NULL,
                                   p5                     VARCHAR2 DEFAULT NULL,
                                   pSendTo         IN     VARCHAR2,
                                   pSendCc         IN     VARCHAR2 DEFAULT NULL,
                                   pSendBcc        IN     VARCHAR2 DEFAULT NULL,
                                   pRunUser        IN     VARCHAR2,
                                   pErrorFlag         OUT VARCHAR2,
                                   pErrorMessage      OUT VARCHAR2);

    FUNCTION SPLIT_TEXT (pText IN CLOB, pDelimeter IN VARCHAR2 DEFAULT ',')
        RETURN GUMS.PKG_GLOBAL_EMAIL.t_split_array;


    -- PROCEDURE print_clob_htp (p_clob IN CLOB);

    -- PROCEDURE print_clob_htp_old (p_clob IN CLOB);

    FUNCTION EMAIL_CHECK (pMailId IN VARCHAR2)
        RETURN INT;

    PROCEDURE PROCESS_RECIPIENTS (pMailConn   IN OUT SYS.UTL_SMTP.connection,
                                  pList       IN     VARCHAR2);

    PROCEDURE HTML_EMAIL (p_to             IN VARCHAR2,
                          p_from           IN VARCHAR2,
                          p_subject        IN VARCHAR2,
                          p_text           IN VARCHAR2 DEFAULT NULL,
                          p_html           IN VARCHAR2 DEFAULT NULL,
                          p_smtp_portnum   IN VARCHAR2);

    PROCEDURE SEND_EMAIL (pSendTo    IN VARCHAR2,
                          pSendCc    IN VARCHAR2 DEFAULT NULL,
                          pSendBcc   IN VARCHAR2 DEFAULT NULL,
                          pSubject   IN VARCHAR2,
                          pMessage   IN VARCHAR2);

    FUNCTION SEND_EMAIL_OTP (P_E_ADDRESS    VARCHAR2,
                             P_SUBJECT      VARCHAR2,
                             P_BODY         VARCHAR2)
        RETURN INTEGER;
END;
/


DROP PACKAGE GUMS.PKG_GLOBAL_OBJECTS;

CREATE OR REPLACE PACKAGE GUMS.PKG_GLOBAL_OBJECTS
AS
    PROCEDURE VALIDATE_MOBILE_NO (pMobileNo           VARCHAR2,
                                  pErrorFlag      OUT VARCHAR2,
                                  pErrorMessage   OUT VARCHAR2);

    FUNCTION GET_USER_CODE_BY_ID (pUserId VARCHAR2)
        RETURN VARCHAR2;

    FUNCTION GET_USER_NAME_BY_ID (pUserId VARCHAR2)
        RETURN VARCHAR2;

    FUNCTION GET_USER_ID_BY_CODE (pUserCode VARCHAR2)
        RETURN PLS_INTEGER;

    PROCEDURE VALIDATE_EMAIL (pEmail          IN     VARCHAR2,
                              pErrorFlag         OUT VARCHAR2,
                              pErrorMessage      OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.PKG_IMG_CHANGE_REQUEST_APP;

CREATE OR REPLACE PACKAGE GUMS.PKG_IMG_CHANGE_REQUEST_APP
IS

    TYPE DB_RECORD_BLOB IS RECORD
    (
        DB_col_name VARCHAR2 (100),
        DB_col_value BLOB,
        db_col_value_vc2    VARCHAR2 (1024) DEFAULT NULL
    );

    TYPE DB_OLD_BLOB IS TABLE OF DB_Record_BLOB
        INDEX BY BINARY_INTEGER;

    FUNCTION BLOB_COMPARE (pBLOB1 BLOB, pBLOB2 BLOB)
        RETURN INT;

    PROCEDURE REQUEST_INCLUDE_LOG_BLOB (
        pTableName            VARCHAR2,
        pRequestPurpose       VARCHAR2,
        pKeyCol               VARCHAR2 DEFAULT NULL,
        pKeyColValue          VARCHAR2 DEFAULT NULL,
        pKeyCol2               VARCHAR2 DEFAULT NULL,
        pKeyColValue2          VARCHAR2 DEFAULT NULL,
        pPageId               NUMBER,
        pRunUser              VARCHAR2,
        pSessionId            VARCHAR,
        pBranchCode           VARCHAR2 DEFAULT NULL,
        pColList              GUMS.PKG_IMG_CHANGE_REQUEST_APP.DB_OLD_BLOB,
        pRecIdentifier        NUMBER,
        pSchemaName           VARCHAR2 DEFAULT 'MEMMIMG',
        pRequestStatus        VARCHAR2 DEFAULT 'R',
        pErrorFlag        OUT VARCHAR2,
        pErrorMessage     OUT VARCHAR2);

    PROCEDURE DB_OLD_VALUE_RETRIVE_BLOB(
        pColName            VARCHAR2,
        pTableName          VARCHAR2,
        pKeyCol             VARCHAR2,
        pKeyColValue        VARCHAR2,
        pSchemaName         VARCHAR2 DEFAULT 'EMOB',
        pDbOldData      OUT DB_OLD_BLOB,
        pErrorFlag      OUT VARCHAR2,
        pErrorMessage   OUT VARCHAR2);
        
END;
/


DROP PACKAGE GUMS.PKG_LOAN_REPAYMENT_CLOSING;

CREATE OR REPLACE PACKAGE GUMS.PKG_LOAN_REPAYMENT_CLOSING
IS
   PROCEDURE LOAN_REPAYMENT_AC_DETAILS (pLoanAcNo          IN     VARCHAR2,
                                        pPaymentType       IN     VARCHAR2,
                                        pBranchCode        IN     VARCHAR2,
                                        pAcTittle             OUT VARCHAR2,
                                        pLinkAcNo             OUT VARCHAR2,
                                        pLinkAcTittle         OUT VARCHAR2,
                                        pLinkAcBal            OUT NUMBER,
                                        pProduct              OUT VARCHAR2,
                                        pLoanAmt              OUT NUMBER,
                                        pDisburseDate         OUT DATE,
                                        pIntRate              OUT NUMBER,
                                        pExpIntRate           OUT NUMBER,
                                        pTerm                 OUT NUMBER,
                                        pDuePrincipal         OUT NUMBER,
                                        pDueInt               OUT NUMBER,
                                        pDueExpInt            OUT NUMBER,
                                        pDueInstallNo         OUT NUMBER,
                                        pInstallNo            OUT NUMBER,
                                        pLoanType             OUT VARCHAR2,
                                        pOnlyEmp              OUT VARCHAR2,
                                        pLinkAcBranch         OUT VARCHAR2,
                                        pLoanAcBranch         OUT VARCHAR2,
                                        pLoanExpDate          OUT DATE,
                                        pLoanGrantDate        OUT DATE,
                                        pLoanOutStanding      OUT NUMBER,
                                        pChargeAmount         OUT NUMBER,
                                        pLastRepayDate        OUT VARCHAR2,
                                        pLastRepayAmt         OUT NUMBER,
                                        pTotalPaid            OUT NUMBER,
                                        pErrorFlag            OUT VARCHAR2,
                                        pErrorMessage         OUT VARCHAR2);

   PROCEDURE LOAN_CLOSE_AC_DETAILS (pLoanAcNo             IN     VARCHAR2,
                                    pPaymentType          IN     VARCHAR2,
                                    pBranchCode           IN     VARCHAR2,
                                    pRunUser              IN     VARCHAR2,
                                    pLogId                IN     VARCHAR2,
                                    pModuleDate           IN     DATE,
                                    pSuspenseAmt             OUT NUMBER,
                                    pSettlementAmt           OUT NUMBER,
                                    pAcTittle                OUT VARCHAR2,
                                    pAcOutstanding           OUT NUMBER,
                                    pExpDate                 OUT DATE,
                                    pBlIntAmt                OUT NUMBER,
                                    pDueAccural              OUT NUMBER,
                                    pLastProvDate            OUT DATE,
                                    pProvStopDate            OUT DATE,
                                    pDueExpChg               OUT NUMBER,
                                    pRepayStatus             OUT VARCHAR2,
                                    pLastRescheduleDate      OUT DATE,
                                    pClStatus                OUT VARCHAR2,
                                    pRebateAmt               OUT NUMBER,
                                    pLinkAcNo                OUT VARCHAR2,
                                    pLinkAcTittle            OUT VARCHAR2,
                                    pLinkAcBal               OUT NUMBER,
                                    pProduct                 OUT VARCHAR2,
                                    pLoanAmt                 OUT NUMBER,
                                    pDisburseDate            OUT DATE,
                                    pIntRate                 OUT NUMBER,
                                    pExpIntRate              OUT NUMBER,
                                    pTerm                    OUT NUMBER,
                                    pDuePrincipal            OUT NUMBER,
                                    pDueInt                  OUT NUMBER,
                                    pDueInstallNo            OUT NUMBER,
                                    pInstallNo               OUT NUMBER,
                                    pEarlyClosingChg         OUT NUMBER,
                                    pEarlyClosureGl          OUT NUMBER,
                                    pOtherCharge             OUT NUMBER,
                                    pExciseDuty              OUT NUMBER,
                                    pLoanType                OUT VARCHAR2,
                                    pOnlyEmp                 OUT VARCHAR2,
                                    pLinkAcBranch            OUT VARCHAR2,
                                    pLoanAcBranch            OUT VARCHAR2,
                                    pErrorFlag               OUT VARCHAR2,
                                    pErrorMessage            OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.PKG_MOBILE_APPS;

CREATE OR REPLACE PACKAGE GUMS.PKG_MOBILE_APPS
IS
    PROCEDURE PRC_DEVICE_REGISTRATION (pUserType       VARCHAR2,
                                       pUserId         VARCHAR2,
                                       pDeviceId       VARCHAR2,
                                       pStatus     OUT VARCHAR2,
                                       pMessage    OUT VARCHAR2);

    PROCEDURE PRC_OTP_VERIFICATION (pUserType       VARCHAR2,
                                    pUserId         VARCHAR2,
                                    pPassword       VARCHAR2,
                                    pDeviceId       VARCHAR2,
                                    pOTP            VARCHAR2,
                                    pStatus     OUT VARCHAR2,
                                    pMessage    OUT VARCHAR2);

    PROCEDURE PRC_LOGIN (pUserType           VARCHAR2,
                         pUserId             VARCHAR2,
                         pPassword           VARCHAR2,
                         pDeviceId           VARCHAR2,
                         pToken          OUT VARCHAR2,
                         pUserName       OUT VARCHAR2,
                         pUserMobileNo   OUT VARCHAR2,
                         pUserMail       OUT VARCHAR2,
                         pStatus         OUT VARCHAR2,
                         pMessage        OUT VARCHAR2);

    PROCEDURE GET_API_TOKEN (Client_Id       IN VARCHAR2,
                             Client_Secret   IN VARCHAR2);

    FUNCTION PRC_SAMITI_LIST (pToken CLOB)
        RETURN CLOB;

    FUNCTION PRC_MEMBER_LIST (pToken CLOB, pSamitiCode VARCHAR2)
        RETURN CLOB;

    FUNCTION PRC_AC_LIST (pToken CLOB, pMemberCode VARCHAR2)
        RETURN CLOB;

    FUNCTION PRC_LOAN_AC_LIST (pToken        CLOB,
                               pMemberCode   VARCHAR2,
                               pAmount       NUMBER)
        RETURN CLOB;

    FUNCTION PRC_LOAN_AC_INFO (pToken CLOB, pAcNo VARCHAR2, pAmount NUMBER)
        RETURN CLOB;

    PROCEDURE GET_DEPOSIT_AC_INFO (pToken                   CLOB,
                                   pAcNo                    VARCHAR2,
                                   pAcId                OUT NUMBER,
                                   pAcTypeId            OUT NUMBER,
                                   pCustNo              OUT NUMBER,
                                   pCustCode            OUT VARCHAR2,
                                   pAcTitle             OUT VARCHAR2,
                                   pAcBranch            OUT VARCHAR2,
                                   pAvailableBalance    OUT NUMBER,
                                   pBlockAmount         OUT NUMBER,
                                   pMobileNo            OUT VARCHAR2,
                                   pAcType              OUT VARCHAR2,
                                   pDepNature           OUT VARCHAR2,
                                   pAcStatus            OUT VARCHAR2,
                                   pTimePeriod          OUT NUMBER,
                                   pDueIns              OUT NUMBER,
                                   pPaidIns             OUT NUMBER,
                                   pInsAmount           OUT NUMBER,
                                   pDpsTotalInsAmt      OUT NUMBER,
                                   pDpsInsPenal         OUT NUMBER,
                                   pTotalAmt            OUT NUMBER,
                                   pChargeCrGlAc        OUT VARCHAR2,
                                   pEffDate             OUT VARCHAR2,
                                   pTotalAmtwithPenal   OUT VARCHAR2,
                                   pErrorFlag           OUT VARCHAR2,
                                   pErrorMessage        OUT VARCHAR2);

    PROCEDURE PRC_TRANSACTION_DEPOSIT_AC (pToken              CLOB,
                                          pInputBody          BLOB,
                                          pDocNum         OUT CLOB,
                                          pErrorFlag      OUT VARCHAR2,
                                          pErrorMessage   OUT VARCHAR2);

    PROCEDURE PRC_LOGOUT (pToken              CLOB,
                          pErrorFlag      OUT VARCHAR2,
                          pErrorMessage   OUT VARCHAR2);

    FUNCTION PRC_AC_STATEMENT_LIST (pToken      CLOB,
                                    pAcNo       VARCHAR2,
                                    pFromDate   VARCHAR2,
                                    pToDate     VARCHAR2)
        RETURN CLOB;

    PROCEDURE GET_UNSETTLE_AMOUNT (pToken              CLOB,
                                   pAmount         OUT NUMBER,
                                   pErrorFlag      OUT VARCHAR2,
                                   pErrorMessage   OUT VARCHAR2);

    FUNCTION PRC_DEPOSIT_HISTORY_LIST (pToken      CLOB,
                                       pFromDate   VARCHAR2,
                                       pToDate     VARCHAR2)
        RETURN CLOB;

    PROCEDURE PRC_PASSWORD_FORGOT (pUserType           VARCHAR2,
                                   pUserCode           VARCHAR2,
                                   pUserDOB            VARCHAR2,
                                   pDeviceId           VARCHAR2,
                                   pErrorFlag      OUT VARCHAR2,
                                   pErrorMessage   OUT VARCHAR2);

    PROCEDURE PRC_PASSWORD_FORGOT_OTP_VERIFICATION (
        pUserType           VARCHAR2,
        pUserCode           VARCHAR2,
        pPassword           VARCHAR2,
        pDeviceId           VARCHAR2,
        pOTP                VARCHAR2,
        pErrorFlag      OUT VARCHAR2,
        pErrorMessage   OUT VARCHAR2);

    FUNCTION PRC_AC_LIST_BN (pToken CLOB)
        RETURN CLOB;

    FUNCTION PRC_AC_STATEMENT_LIST_BN (pToken      CLOB,
                                       pAcNo       VARCHAR2,
                                       pFromDate   VARCHAR2,
                                       pToDate     VARCHAR2)
        RETURN CLOB;
END;
/


DROP PACKAGE GUMS.PKG_NID_VERIFICATION;

CREATE OR REPLACE PACKAGE GUMS.PKG_NID_VERIFICATION
IS
    PROCEDURE EC_API_CALL_NEW (pToken      IN     VARCHAR2,
                               pNid               VARCHAR2,
                               pName              VARCHAR2,
                               pDob               VARCHAR2,
                               pResponse      OUT CLOB,
                               pErrFlag       OUT VARCHAR2,
                               pErrMsg        OUT VARCHAR2);

    PROCEDURE PROC_GET_TOKEN_NID_VERIFY (pAccessToken    OUT VARCHAR2,
                                         pErrorFlag      OUT VARCHAR2,
                                         pErrorMessage   OUT VARCHAR2);

    PROCEDURE PROC_NID_VERIFICATION (
        pBranchCode     IN     VARCHAR2,
        pNid10          IN     VARCHAR2 DEFAULT NULL,
        pNid17          IN     VARCHAR2 DEFAULT NULL,
        pDob            IN     VARCHAR2,
        pCustNo         IN     NUMBER,
        pRunUserID      IN     VARCHAR2,
        pErrorFlag         OUT VARCHAR2,
        pErrorMessage      OUT VARCHAR2);



    PROCEDURE PROC_GET_NID_RESPONSE (
        pBranchCode         IN     VARCHAR2,
        pNid10              IN     VARCHAR2 DEFAULT NULL,
        pNid17              IN     VARCHAR2 DEFAULT NULL,
        pDob                IN     VARCHAR2,
        pCustNo             IN     NUMBER,
        pRunUserID          IN     VARCHAR2,
        pNAME                  OUT VARCHAR2,
        pMother                OUT VARCHAR2,
        pFather                OUT VARCHAR2,
        pDobOut                OUT DATE,
        pPermanentAddress      OUT VARCHAR2,
        pPresentAddress        OUT VARCHAR2,
        pPhotoURL              OUT VARCHAR2,
        pImageFlag             OUT VARCHAR2,
        pErrorFlag             OUT VARCHAR2,
        pErrorMessage          OUT VARCHAR2);

    /*PROCEDURE PROC_NID_REQUEST_AUTHENTICATE (pRequestID      IN     VARCHAR2,
                                             pRequestUser    IN     VARCHAR2,
                                             pErrorFlag         OUT VARCHAR2,
                                             pErrorMessage      OUT VARCHAR2);*/

    PROCEDURE GET_NID_EC_DATA (
        pCustNo                          IN     NUMBER,
        pNAME_EN                            OUT VARCHAR2,
        pDOB                                OUT VARCHAR2,
        pMOTHER_NAME                        OUT VARCHAR2,
        pFATHER_NAME                        OUT VARCHAR2,
        pspouse                             OUT VARCHAR2,
        poccupation                         OUT VARCHAR2,
        pDivision                           OUT VARCHAR2,
        pDistrict                           OUT VARCHAR2,
        pUpozila                            OUT VARCHAR2,
        pcityCorporationOrMunicipality      OUT VARCHAR2,
        punionOrWard                        OUT VARCHAR2,
        PostOffice                          OUT VARCHAR2,
        Postal_Code                         OUT VARCHAR2,
        RMO                                 OUT VARCHAR2,
        Mouza_Moholla                       OUT VARCHAR2,
        Village_Road                        OUT VARCHAR2,
        Home_Holding_No                     OUT VARCHAR2,
        Region                              OUT VARCHAR2,
        pre_Division                        OUT VARCHAR2,
        pre_District                        OUT VARCHAR2,
        pre_Upozila                         OUT VARCHAR2,
        pre_cityCorOrMunici                 OUT VARCHAR2,
        pre_unionOrWard                     OUT VARCHAR2,
        pre_PostOffice                      OUT VARCHAR2,
        pre_Postal_Code                     OUT VARCHAR2,
        pre_RMO                             OUT VARCHAR2,
        pre_Mouza_Moholla                   OUT VARCHAR2,
        pre_Village_Road                    OUT VARCHAR2,
        pre_Home_Holding_No                 OUT VARCHAR2,
        pre_Region                          OUT VARCHAR2,
        pErrorFlag                          OUT VARCHAR2,
        pErrorMessage                       OUT VARCHAR2);
END;
/


DROP PACKAGE GUMS.PKG_STORE_LOG;

CREATE OR REPLACE PACKAGE GUMS.PKG_STORE_LOG
IS
    PROCEDURE PRC_SUCCESS_LOGIN (pUserId             NUMBER,
                                 pUserCode           VARCHAR2,
                                 pSessionId          VARCHAR2,
                                 pBranchCode         VARCHAR2,
                                 pReqFrom            VARCHAR2 DEFAULT NULL,
                                 pDeviceId           VARCHAR2 DEFAULT NULL,
                                 pLogId          OUT NUMBER,
                                 pErrorFlag      OUT VARCHAR2,
                                 pErrorMessage   OUT VARCHAR2);

    PROCEDURE PRC_FAILED_LOGIN (pUserId             NUMBER,
                                pUserCode           VARCHAR2,
                                pSessionId          VARCHAR2,
                                pErrorFlag      OUT VARCHAR2,
                                pErrorMessage   OUT VARCHAR2);

    PROCEDURE STORE_MAIL_TEXT_LOG (pMailId             VARCHAR2,
                                   pCC                 VARCHAR2,
                                   pBCC                VARCHAR2,
                                   pSubject            VARCHAR2,
                                   pMailText           VARCHAR2,
                                   pLoginId            VARCHAR2,
                                   pRunUser            VARCHAR2,
                                   pSessionId          NUMBER,
                                   pErrorFlag      OUT VARCHAR2,
                                   pErrorMessage   OUT VARCHAR2);
END;
/
DROP PACKAGE BODY GUMS.APEX_JWT_TOKEN;

CREATE OR REPLACE PACKAGE BODY GUMS.APEX_JWT_TOKEN
AS
    PROCEDURE GET_TOKEN (pUserName       VARCHAR2,
                         pUserPass       VARCHAR2,
                         pStatus     OUT VARCHAR2,
                         ptoken      OUT VARCHAR2,
                         pMsg        OUT VARCHAR2)
    IS
        l_token        VARCHAR2 (4000);
        vUserId        NUMBER;
        vMsg           VARCHAR2 (2000);
        vUserStatus    VARCHAR2 (5);
        vUserPwd       VARCHAR2 (100);
        vOutPassword   VARCHAR2 (100);
        vMobileNo      VARCHAR2 (20);
        vUserName      VARCHAR2 (20);
        vDob           DATE;
        vEmail         VARCHAR2 (100);
        vBranch        VARCHAR2 (5);
        vMyException   EXCEPTION;
    BEGIN
        pStatus := '200';
        pMsg := 'SUCCESS';

        IF pUserName IS NULL
        THEN
            pStatus := '401';
            vMsg := 'Please Enter Your User ID.';
            RAISE vMyException;
        END IF;

        IF pUserPass IS NULL
        THEN
            pStatus := '401';
            vMsg := 'Please Enter Your Password.';
            RAISE vMyException;
        END IF;

        -- check User code
        BEGIN
            SELECT a.USER_ID,
                   a.USER_STS,
                   a.USER_PWD,
                   a.USER_NAME,
                   a.USER_DOB,
                   a.EMAIL_ID,
                   a.MOBILE_NO,
                   a.BRANCH_CODE
              INTO vUserId,
                   vUserStatus,
                   vUserPwd,
                   vUserName,
                   vDob,
                   vEmail,
                   vMobileNo,
                   vBranch
              FROM GUMS.MB_USER_MST a
             WHERE UPPER (a.USER_CODE) = UPPER (pUserName);
        EXCEPTION
            WHEN OTHERS
            THEN
                pStatus := '401';
                vMsg := 'Please Enter Valid User ID.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vUserStatus != 'A'
        THEN
            IF vUserStatus = 'L'
            THEN
                pStatus := '401';
                vMsg := 'User is Locked.';
                RAISE vMyException;
            ELSIF vUserStatus = 'I'
            THEN
                pStatus := '401';
                vMsg := 'Invalid Login Credentials.';
                RAISE vMyException;
            ELSIF vUserStatus = 'H'
            THEN
                pStatus := '401';
                vMsg := 'User Temporarily Hold.';
                RAISE vMyException;
            END IF;
        END IF;


        BEGIN
            SELECT GUMS.DPK_SECURITY.DFN_CREATE_PASSWORD_ENCRYPTED (
                       UPPER (pUserName) || vUserId,
                       pUserPass)
              INTO vOutPassword
              FROM DUAL;
        EXCEPTION
            WHEN OTHERS
            THEN
                pStatus := '401';
                vMsg := 'Password Encryption Problem.';
                RAISE vMyException;
        END;

        IF vOutPassword != vUserPwd
        THEN
            pStatus := '401';
            vMsg := 'Password Not Valid.';
            RAISE vMyException;
        END IF;

        /***
        use the apex_jwt package to generate the jwt token
        @param p_iss the issuer of the token
        @param p_sub the "sub" (subject) claim identifies the principal that is the
               subject of the JWT
        @param p_aud the "aud" (audience) claim identifies the recipients
               that the JWT is intended for
        @param p_iat_ts the "iat" (issued at) claim identifies the time at
               which the JWT was issued
        @param p_exp_sec token expiration in seconds
        @param p_signature_key signature key used to encrypt the token
        ***/
        BEGIN
            l_token :=
                apex_jwt.encode (
                    p_iss             => 'PSB',
                    p_sub             => pUserName,
                    -- p_aud             => pUserPass, --'Admins',              --l_user_role,
                    p_iat_ts          => SYSDATE,
                    p_exp_sec         => 5,
                    -- p_jti             => vMobileNo,
                    p_other_claims    =>
                           '"user_id": '
                        || apex_json.stringify (vUserId)
                        || ',"mobile_no": '
                        || apex_json.stringify (vMobileNo)
                        || ',"user_name": '
                        || apex_json.stringify (vUserName)
                        || ',"date_of_birth": '
                        || apex_json.stringify (vDob)
                        || ',"email": '
                        || apex_json.stringify (vEmail)
                        || ',"branch_code": '
                        || apex_json.stringify (vBranch),
                    p_signature_key   => sys.UTL_RAW.cast_to_raw ('secretKey'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pStatus := '401';
                vMsg := 'Token Encoding Problem.' || SQLERRM;
                RAISE vMyException;
        --return the token with success message in json format
        END;

        ptoken := l_token;
    EXCEPTION
        WHEN vMyException
        THEN
            pstatus := '401';
            pMsg := vMsg;
    END;

    PROCEDURE TOKEN_VALIDATION (pAuthorization       VARCHAR2,
                                pUserId          OUT VARCHAR2,
                                pUserCode        OUT VARCHAR2,
                                pUserName        OUT VARCHAR2,
                                pMobileNo        OUT VARCHAR2,
                                pEmail           OUT VARCHAR2,
                                pBranchCode      OUT VARCHAR2,
                                pLogId           OUT VARCHAR2,
                                pStatus          OUT VARCHAR2,
                                pMsg             OUT VARCHAR2)
    IS
        l_token          APEX_JWT.T_TOKEN;
        l_user_object    APEX_JSON.T_VALUES;
        l_bearer_token   VARCHAR2 (5000);
        l_scope          VARCHAR2 (200);
        vMsg             VARCHAR2 (5000);
        vUserId          VARCHAR2 (5);
        vBearer          VARCHAR2 (10);
        vMyException     EXCEPTION;
    BEGIN
        pStatus := '200';
        pMsg := 'SUCCESS';

        IF pAuthorization IS NULL
        THEN
            vMsg := 'Token not Found';
            pStatus := '401';
            RAISE vMyException;
        END IF;


        vBearer := SUBSTR (pAuthorization, 1, 7);

        IF UPPER (vBearer) != UPPER ('Bearer ')
        THEN
            vMsg := 'Token Should be Bearer';
            pStatus := '401';
            RAISE vMyException;
        END IF;

        l_bearer_token := SUBSTR (pAuthorization, 8);

        --decode the token using apex_jwt, note that will should use the same

        --signature key
        BEGIN
            l_token :=
                apex_jwt.DECODE (
                    p_value           => l_bearer_token,
                    p_signature_key   => sys.UTL_RAW.cast_to_raw ('PSBfoMobileApPS2024'));
        EXCEPTION
            WHEN OTHERS
            THEN
                vMsg := 'Token Not Valid';
                pStatus := '401';
                RAISE vMyException;
        END;

        /***
        validate the token using the apex_jwt package
        @param p_token the JWT
        @param p_iss if not null, verify that the "iss" claim equals p_iss
        @param p_aud if not null, verify that the single "aud" value equals
        p_aud. If "aud" is an array, verify that the "azp" (Authorized Party) claim equals p_aud. This is an OpenID extension
        ***/
        BEGIN
            apex_jwt.VALIDATE (p_token => l_token);
        EXCEPTION
            WHEN OTHERS
            THEN
                vMsg := 'Token Expired.';
                pStatus := '401';
                RAISE vMyException;
        END;

        --extract the payload from the token
        apex_json.parse (l_user_object, l_token.payload);

        --check if the subject and audince claims exists
        IF NOT apex_json.does_exist (p_path     => 'sub',
                                     p_values   => l_user_object)
        THEN
            vMsg := 'Not Authorized';
            pStatus := '401';
            RAISE vMyException;
        END IF;

        --extract the aud value from the json
        l_scope :=
            apex_json.get_varchar2 (p_path => 'sub', p_values => l_user_object);

        pUserCode := l_scope;

        pUserId :=
            apex_json.get_varchar2 (p_path     => 'user_id',
                                    p_values   => l_user_object);
        pUserName :=
            apex_json.get_varchar2 (p_path     => 'user_name',
                                    p_values   => l_user_object);

        pMobileNo :=
            apex_json.get_varchar2 (p_path     => 'mobile_no',
                                    p_values   => l_user_object);

        pEmail :=
            apex_json.get_varchar2 (p_path     => 'email',
                                    p_values   => l_user_object);
        pBranchCode :=
            apex_json.get_varchar2 (p_path     => 'branch_code',
                                    p_values   => l_user_object);
        pLogId :=
            apex_json.get_varchar2 (p_path     => 'log_id',
                                    p_values   => l_user_object);
    /*SELECT TO_CHAR(
               FROM_TZ(
                   CAST(TO_TIMESTAMP('1989-02-01T00:00:00', 'YYYY-MM-DD"T"HH24:MI:SS') AS TIMESTAMP),
                   'UTC'
               ) AT TIME ZONE 'Asia/Dhaka',
               'DD/MM/YYYY'
           ) AS dhaka_time
    FROM dual;*/
    EXCEPTION
        WHEN vMyException
        THEN
            pMsg := vMsg;
            pStatus := '401';
    END;
END;
/


DROP PACKAGE BODY GUMS.APP_CHANGE_IMG;

CREATE OR REPLACE PACKAGE BODY GUMS.APP_CHANGE_IMG
IS
    PROCEDURE REQUEST_CHANGE_LOG (pColList              DB_OLD_BLOB,
                                  pRunUser              VARCHAR2,
                                  pTableName            VARCHAR2,
                                  pKeyCol               VARCHAR2,
                                  pSchemaName           VARCHAR2,
                                  pKeyColvalue          VARCHAR2,
                                  pSessionId            VARCHAR2,
                                  pPageId               NUMBER,
                                  pBranchCode           VARCHAR2,
                                  pRequestPurpose       VARCHAR2,
                                  pRequestStatus        VARCHAR2,
                                  pKeyCol2              VARCHAR2,
                                  pKeyColValue2         VARCHAR2,
                                  pRecIdentifier    OUT NUMBER,
                                  pOutData          OUT CLOB,
                                  pErrorFlag        OUT VARCHAR2,
                                  pErrorMsg         OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vMyException   EXCEPTION;
    BEGIN
        -- Loop through column list and handle BLOB or CLOB
        FOR i IN 1 .. pColList.COUNT
        LOOP
            IF    pColList (i).DB_COL_VALUE IS NOT NULL
               OR pColList (i).db_col_value_clob IS NOT NULL
            THEN
                BEGIN
                    INSERT INTO GUMS.MB_APP_IMG_REQUEST_CHANGE_LOG (
                                    LOG_ID,
                                    TABLE_NAME,
                                    COL_NAME,
                                    NEW_VAL_blob,
                                    NEW_VAL_clob,
                                    OLD_VAL_blob,
                                    STATUS,
                                    REQUEST_PURPOSE,
                                    REQUEST_PAGE_ID,
                                    REQUEST_FOR,
                                    SESSION_ID,
                                    RECORD_IDENTIFIER,
                                    SCHEMA_NAME,
                                    APP_ID,
                                    KEY_COL_NAME,
                                    KEY_COL_VALUE,
                                    CREATE_BY,
                                    CREATE_DATE,
                                    BRANCH_CODE,
                                    KEY_COL_NAME2,
                                    KEY_COL_VALUE2)
                         VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                                 pTableName,
                                 pColList (i).DB_COL_NAME,
                                 pColList (i).DB_COL_VALUE,
                                 pColList (i).db_col_value_clob,
                                 NULL,
                                 pRequestStatus,
                                 pRequestPurpose,
                                 pPageId,
                                 'U',
                                 pSessionId,
                                 pRecIdentifier,
                                 pSchemaName,
                                 106,
                                 pKeyCol,
                                 pKeyColValue,
                                 pRunUser,
                                 SYSDATE,
                                 pBranchCode,
                                 pKeyCol2,
                                 pKeyColValue2);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMsg :=
                               'MB_Request_Change_LOG insert problem: '
                            || SQLERRM;
                        RAISE vMyException;
                END;
            END IF;
        END LOOP;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END REQUEST_CHANGE_LOG;



    PROCEDURE REQUEST_INCLUDE_LOG (pColList                 DB_OLD_BLOB,
                                   pRunUser                 VARCHAR2,
                                   pTableName               VARCHAR2,
                                   pKeyCol                  VARCHAR2,
                                   pSchemaName              VARCHAR2,
                                   pKeyColvalue             VARCHAR2,
                                   pSessionId               VARCHAR2,
                                   pPageId                  NUMBER,
                                   pBranchCode              VARCHAR2,
                                   pRequestPurpose          VARCHAR2,
                                   pRequestStatus           VARCHAR2,
                                   pKeyCol2                 VARCHAR2,
                                   pKeyColValue2            VARCHAR2,
                                   pRecIdentifier    IN     NUMBER,
                                   pOutData             OUT CLOB,
                                   pErrorFlag           OUT VARCHAR2,
                                   pErrorMsg            OUT VARCHAR2)
    IS
        vMyException   EXCEPTION;
    BEGIN
        -- Handle image or CLOB insert in Request Log
        FOR i IN 1 .. pColList.COUNT
        LOOP
            IF    pColList (i).DB_COL_VALUE IS NOT NULL
               OR pColList (i).db_col_value_clob IS NOT NULL
            THEN
                BEGIN
                    INSERT INTO GUMS.MB_APP_IMG_REQUEST_CHANGE_LOG (
                                    LOG_ID,
                                    TABLE_NAME,
                                    COL_NAME,
                                    NEW_VAL_blob,
                                    NEW_VAL_clob,
                                    OLD_VAL_blob,
                                    STATUS,
                                    REQUEST_PURPOSE,
                                    REQUEST_PAGE_ID,
                                    REQUEST_FOR,
                                    SESSION_ID,
                                    RECORD_IDENTIFIER,
                                    SCHEMA_NAME,
                                    APP_ID,
                                    KEY_COL_NAME,
                                    KEY_COL_VALUE,
                                    CREATE_BY,
                                    CREATE_DATE,
                                    BRANCH_CODE,
                                    KEY_COL_NAME2,
                                    KEY_COL_VALUE2,
                                    MIME_TYPE,
                                    FILE_NAME)
                         VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                                 pTableName,
                                 pColList (i).DB_COL_NAME,
                                 pColList (i).DB_COL_VALUE,
                                 pColList (i).db_col_value_clob, -- ? pass CLOB if present
                                 NULL,
                                 pRequestStatus,
                                 pRequestPurpose,
                                 pPageId,
                                 'I',
                                 pSessionId,
                                 pRecIdentifier,
                                 pSchemaName,
                                 106,
                                 pKeyCol,
                                 pKeyColValue,
                                 pRunUser,
                                 SYSDATE,
                                 pBranchCode,
                                 pKeyCol2,
                                 pKeyColValue2,
                                 pColList (i).db_col_mime_type,
                                 pColList (i).db_col_file_name);
                EXCEPTION
                    WHEN VALUE_ERROR
                    THEN
                        pErrorMsg :=
                               'Check null or missing value for '
                            || pRecIdentifier;
                        RAISE vMyException;
                    WHEN OTHERS
                    THEN
                        pErrorMsg :=
                               'MB_Request_Change_LOG insert problem: '
                            || SQLERRM;
                        RAISE vMyException;
                END;
            END IF;
        END LOOP;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END REQUEST_INCLUDE_LOG;
END APP_CHANGE_IMG;
/


DROP PACKAGE BODY GUMS.BO_TRANSACTION;

CREATE OR REPLACE PACKAGE BODY GUMS.BO_TRANSACTION
IS
    PROCEDURE PRC_BO_TRANSFER_TRANSACTION (pEntryType              VARCHAR2,
                                           pAiBanchCode            VARCHAR2,
                                           pAiUserId               VARCHAR2,
                                           pRunUser                VARCHAR2,
                                           pAmount                 NUMBER,
                                           pDrCr                   VARCHAR2,
                                           pTempTranNo      IN OUT VARCHAR2,
                                           pAcNo                   VARCHAR2,
                                           pAcType                 VARCHAR2,
                                           pAcTypeId               VARCHAR2,
                                           pTranType               VARCHAR2,
                                           pTempTranNoDis   IN OUT VARCHAR2,
                                           pTempTranNoLov   IN OUT VARCHAR2,
                                           pTranNature             VARCHAR2,
                                           pBranchCode             VARCHAR2,
                                           pNarration              VARCHAR2,
                                           pOprType                VARCHAR2,
                                           pTranMode               VARCHAR2,
                                           pTranCode               VARCHAR2,
                                           pErrorFlag          OUT VARCHAR2,
                                           pErrorMsg           OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl := vUrl || '/psb/psbcore/coresrc/prc_bo_transfer_transaction/';

        vRequest :=
               '{
    "pentrytype": "'
            || pEntryType
            || '",
    "paibanchcode": "'
            || pAibanchCode
            || '",
    "paiuserid": "'
            || pAiUserid
            || '",
    "prunuser": "'
            || pRunUser
            || '",
    "pamount": "'
            || pAmount
            || '",
    "pdrcr": "'
            || pDrCr
            || '",
    "ptemptranno": "'
            || pTempTranno
            || '",
    "pacno": "'
            || pAcNo
            || '",
    "pactype": "'
            || pAcType
            || '",
    "pactypeid": "'
            || pAcTypeId
            || '",
    "ptrantype": "'
            || pTranType
            || '",
    "ptemptrannodis": "'
            || pTempTranNoDis
            || '",
    "ptemptrannolov": "'
            || pTempTranNoLov
            || '",
    "ptrannature": "'
            || pTranNature
            || '",
    "pbranchcode": "'
            || pBranchCode
            || '",
    "pnarration": "'
            || pNarration
            || '",
    "poprtype": "'
            || pOprType
            || '",
    "ptranmode": "'
            || pTranMode
            || '",
    "ptrancode": "'
            || pTranCode
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem.';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pTempTranNoDis := apex_json.get_varchar2 ('ptemptrannodis');
        pTempTranNo := apex_json.get_varchar2 ('ptemptranno');
        pTempTranNoLov := apex_json.get_varchar2 ('ptemptrannolov');
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMsg := apex_json.get_varchar2 ('perrormsg');
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
        WHEN OTHERS
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
            pErrorMsg := 'System Error: ' || SQLERRM;
    END;

    PROCEDURE PRC_BO_TRANSFER_TRAN_UPDATE (pEntryType            VARCHAR2,
                                           pAiBanchCode          VARCHAR2,
                                           pAiUserId             VARCHAR2,
                                           pRunUser              VARCHAR2,
                                           pAmount               NUMBER,
                                           pTempTranNo    IN     VARCHAR2,
                                           pDrCr                 VARCHAR2,
                                           pAcNo                 VARCHAR2,
                                           pAcType               VARCHAR2,
                                           pAcTypeId             VARCHAR2,
                                           pTranType             VARCHAR2,
                                           pTranNature           VARCHAR2,
                                           pBranchCode           VARCHAR2,
                                           pNarration            VARCHAR2,
                                           pErrorFlag        OUT VARCHAR2,
                                           pErrorMsg         OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl := vUrl || '/psb/psbcore/emob/prc_bo_transfer_tran_update/';

        vRequest :=
               '{
    "pentrytype": "'
            || pEntryType
            || '",
    "paibanchcode": "'
            || pAibanchCode
            || '",
    "paiuserid": "'
            || pAiUserid
            || '",
    "prunuser": "'
            || pRunUser
            || '",
    "pamount": "'
            || pAmount
            || '",
    "pdrcr": "'
            || pDrCr
            || '",
    "ptemptranno": "'
            || pTempTranno
            || '",
    "pacno": "'
            || pAcNo
            || '",
    "pactype": "'
            || pAcType
            || '",
    "pactypeid": "'
            || pAcTypeId
            || '",
    "ptrantype": "'
            || pTranType
            || '",
    "ptrannature": "'
            || pTranNature
            || '",
    "pbranchcode": "'
            || pBranchCode
            || '",
    "pnarration": "'
            || pNarration
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem.';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMsg := apex_json.get_varchar2 ('perrormsg');
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
        WHEN OTHERS
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
            pErrorMsg := 'System Error: ' || SQLERRM;
    END;
END;
/


DROP PACKAGE BODY GUMS.CORE_BANK_API_CONSUME;

CREATE OR REPLACE PACKAGE BODY GUMS.CORE_BANK_API_CONSUME
IS
    PROCEDURE LIB_MONTH_END_APPROVAL (pModuleDate     IN     DATE,
                                      pAcTypeId       IN     NUMBER,
                                      pAiUserId       IN     VARCHAR2,
                                      pAiLogId        IN     VARCHAR2,
                                      pApprovReject   IN     VARCHAR2,
                                      pErrorFlag         OUT VARCHAR2,
                                      pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_lib_month_end/DPS_INTEREST_PROV_APPROVAL';

        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",
   "pactypeid": "'
            || pAcTypeId
            || '",   
    "prunuser": "'
            || pAiUserId
            || '",

    "papprovestatus": "'
            || pApprovReject
            || '",
     "pailogid": "'
            || pAiLogId
            || '"
}';


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
        WHEN OTHERS
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
            pErrorMessage := 'System  error - ' || SQLERRM;
    END;

    PROCEDURE ASS_MONTH_END_APPROVAL (pModuleDate     IN     DATE,
                                      pAcTypeId       IN     NUMBER,
                                      pAiUserId       IN     VARCHAR2,
                                      pAiLogId        IN     VARCHAR2,
                                      pApprovReject   IN     VARCHAR2,
                                      pPROVISION_ID   IN     VARCHAR2,
                                      pErrorFlag         OUT VARCHAR2,
                                      pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;



        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/loan_accural_approval/PRO_LOAN_ACCURAL_APPROVAL';

        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",
   "pactypeid": "'
            || pAcTypeId
            || '",   
    "pcreateby": "'
            || pAiUserId
            || '",
    "papprovreject": "'
            || pApprovReject
            || '",
     "pailogid": "'
            || pAiLogId
            || '",
     "pprovisionid": "'
            || pPROVISION_ID
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);


        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE RESCHEDULE_APPROVAL (pModuleDate     IN     DATE,
                                   pAcId           IN     NUMBER,
                                   pAiUserId       IN     VARCHAR2,
                                   pAiLogId        IN     VARCHAR2,
                                   pApprovReject   IN     VARCHAR2,
                                   pDocNum            OUT VARCHAR2,
                                   pErrorFlag         OUT VARCHAR2,
                                   pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vDmlType        VARCHAR2 (1);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_loan_reschedule/RESCHEDULE_APPROVAL';

        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",   
    "pacid": "'
            || pAcId
            || '",   
    "paiuserid": "'
            || pAiUserId
            || '",
    "pailogid": "'
            || pAiLogId
            || '",
    "papprovreject": "'
            || pApprovReject
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');
        pDocNum := apex_json.get_varchar2 ('pdocnum');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE LOAN_RESCHEDULE_CALCULATION (
        pModuleDate          IN     DATE,
        pBranchCode          IN     VARCHAR2,
        pAcNo                IN     VARCHAR2,
        pAcId                   OUT NUMBER,
        pCustNo                 OUT NUMBER,
        pAcTypeId               OUT NUMBER,
        pAccountTitle           OUT VARCHAR2,
        pIntRate                OUT NUMBER,
        pInsFrequency           OUT VARCHAR2,
        pNoOfInstall         IN OUT NUMBER,
        pTotalIntAmt            OUT NUMBER,
        pPrinInstallAmt         OUT NUMBER,
        pIntInstallAmt          OUT NUMBER,
        pNonPostIntAmt          OUT NUMBER,
        pDayBasisIntAmt         OUT NUMBER,
        pAcBalAmt               OUT NUMBER,
        pClStatus               OUT VARCHAR2,
        pSusAmt                 OUT NUMBER,
        pBlAmt                  OUT NUMBER,
        pReschAmt               OUT NUMBER,
        pLastProvisionDate      OUT VARCHAR2,
        pErrorFlag              OUT VARCHAR2,
        pErrorMessage           OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_loan_reschedule/RESCHEDULE_CALCULATION';


        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",
    "pbranchcode": "'
            || pBranchCode
            || '",
    "pacno": "'
            || pAcNo
            || '"  ,
      "pnoofinstall": "'
            || pNoOfInstall
            || '"  
                }';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pAcId := apex_json.get_number ('pacid');
        pCustNo := apex_json.get_number ('pcustno');
        pAcTypeId := apex_json.get_number ('pactypeid');
        pAccountTitle := apex_json.get_varchar2 ('paccounttitle');
        pIntRate := apex_json.get_number ('pintrate');
        pInsFrequency := apex_json.get_varchar2 ('pinsfrequency');
        pNoOfInstall := apex_json.get_number ('pnoofinstall');
        pTotalIntAmt := apex_json.get_number ('ptotalintamt');
        pPrinInstallAmt := apex_json.get_number ('pprininstallamt');
        pIntInstallAmt := apex_json.get_number ('pintinstallamt');
        pNonPostIntAmt := apex_json.get_number ('pnonpostintamt');
        pDayBasisIntAmt := apex_json.get_number ('pdaybasisintamt');
        pAcBalAmt := apex_json.get_number ('pacbalamt');
        pClStatus := apex_json.get_varchar2 ('pclstatus');
        pSusAmt := apex_json.get_number ('psusamt');
        pBlAmt := apex_json.get_number ('pblamt');
        pReschAmt := apex_json.get_number ('preschamt');
        pLastProvisionDate := apex_json.get_varchar2 ('plastprovisiondate');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE POST_DPS_ACCOUNT_CREATION_API (
        pModuleDate       IN     VARCHAR2,
        pBranchCode       IN     VARCHAR2,
        pAcTypeId         IN     NUMBER,
        pAcTitle          IN     VARCHAR2,
        pCustno           IN     NUMBER,
        pGuarMemberCode   IN     VARCHAR2,
        pOprIns           IN     VARCHAR2,
        pSector           IN     VARCHAR2,
        pInstallAmt       IN     NUMBER,
        pInsFrq           IN     VARCHAR2,
        pInterestRate     IN     NUMBER,
        pTermPeriod       IN     NUMBER,
        pTimeFrq          IN     VARCHAR2,
        pMaturityDate     IN     VARCHAR2,
        pMaturityAmt      IN     NUMBER,
        pEffectFrom       IN     VARCHAR2,
        pEffectDate       IN     VARCHAR2,
        pLinkAcDr         IN     VARCHAR2,
        pIntroType        IN     VARCHAR2,
        pIntroAcNo        IN     VARCHAR2,
        pIntroName        IN     VARCHAR2,
        pIntroAddress     IN     VARCHAR2,
        pIntroMobile      IN     VARCHAR2,
        pIntroRelation    IN     VARCHAR2,
        pIntroPosition    IN     VARCHAR2,
        pIntroOthers      IN     VARCHAR2,
        pAiUserId         IN     VARCHAR2,
        pAcId                OUT NUMBER,
        pAcNo                OUT VARCHAR2,
        pErrorFlag           OUT VARCHAR2,
        pErrorMessage        OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMemberName    VARCHAR2 (1024);
        vnomineeid     NUMBER;
        l_value        VARCHAR2 (3);
        vJson          CLOB;
        vMyException   EXCEPTION;
    BEGIN
        BEGIN
            -- Tell APEX_JSON to write to a CLOB buffer
            apex_json.initialize_clob_output;

            -- Root object {
            apex_json.open_object;

            -- "NOMINEES": [
            apex_json.open_array ('NOMINEES');

            FOR r
                IN (  SELECT a.c001
                                 AS member_code,
                             a.c003
                                 AS nominee_name,
                             a.c004
                                 AS fathers_name,
                             a.c005
                                 AS mother_name,
                             a.c006
                                 AS relation,
                             a.c007
                                 AS document_type,
                             a.c008
                                 AS document_no,
                             a.d001
                                 AS dob,
                             a.n001
                                 AS nomi_percent,
                             -- image CLOBs from collection
                             (SELECT clob001
                                FROM apex_collections i
                               WHERE     i.collection_name = 'NOMINEE'
                                     AND i.c002 = 'NOMIMG'
                                     AND i.c003 = a.c003
                                     AND i.c001 = a.c001
                                     AND ROWNUM = 1)
                                 AS nomimg,
                             (SELECT clob001
                                FROM apex_collections i
                               WHERE     i.collection_name = 'NOMINEE'
                                     AND i.c002 = 'DOCFRNT'
                                     AND i.c003 = a.c003
                                     AND i.c001 = a.c001
                                     AND ROWNUM = 1)
                                 AS docfrnt,
                             (SELECT clob001
                                FROM apex_collections i
                               WHERE     i.collection_name = 'NOMINEE'
                                     AND i.c002 = 'DOCBACK'
                                     AND i.c003 = a.c003
                                     AND i.c001 = a.c001
                                     AND ROWNUM = 1)
                                 AS docback
                        FROM apex_collections a
                       WHERE a.collection_name = 'NOMINEE' AND a.c001 = pCustNo
                    GROUP BY a.c001,
                             a.c003,
                             a.c004,
                             a.c005,
                             a.c006,
                             a.c007,
                             a.c008,
                             a.d001,
                             a.n001)
            LOOP
                -- each nominee as an object { ... }
                apex_json.open_object;

                apex_json.write ('member_code', r.member_code);
                apex_json.write ('nominee_name', r.nominee_name);
                apex_json.write ('fathers_name', r.fathers_name);
                apex_json.write ('mother_name', r.mother_name);
                apex_json.write ('relation', r.relation);
                apex_json.write ('document_type', r.document_type);
                apex_json.write ('document_no', r.document_no);
                apex_json.write ('dob', TO_CHAR (r.dob, 'YYYY-MM-DD'));
                apex_json.write ('nomi_percent', r.nomi_percent);

                -- Image CLOBs (assuming base64 text stored in clob001)
                IF r.nomimg IS NOT NULL
                THEN
                    apex_json.write ('nominee_image', r.nomimg);       -- CLOB
                ELSE
                    apex_json.write ('nominee_image', l_value);
                END IF;

                IF r.docfrnt IS NOT NULL
                THEN
                    apex_json.write ('doc_front', r.docfrnt);          -- CLOB
                ELSE
                    apex_json.write ('doc_front', l_value);
                END IF;

                IF r.docback IS NOT NULL
                THEN
                    apex_json.write ('doc_back', r.docback);           -- CLOB
                ELSE
                    apex_json.write ('doc_back', l_value);
                END IF;

                apex_json.close_object;
            END LOOP;

            -- end NOMINEES array ]
            apex_json.close_array;

            -- end root object }
            apex_json.close_object;

            -- Get the complete JSON as CLOB
            vJson := apex_json.get_clob_output;

            -- Free internal buffer
            apex_json.free_output;
        -- Debug (optional, only a slice so no buffer error)
        -- DBMS_OUTPUT.PUT_LINE('JSON length = ' || DBMS_LOB.GETLENGTH(vJson));
        --  DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(vJson, 4000, 1));

        -- Now vJson is your big CLOB JSON:
        -- {
        --   "NOMINEES": [ { ... }, { ... }, ... ]
        -- }
        END;

        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_open/PRC_DPS_ACCOUNT_CREATION';

        /*  vRequest :=
                 '{
     "pmoduledate":"'
              || pModuleDate
              || '",
     "pbranchcode":"'
              || pBranchCode
              || '",
     "pactypeid":"'
              || pAcTypeId
              || '",
     "pactitle":"'
              || pAcTitle
              || '",
     "pcustno":"'
              || pCustno
              || '",
      "pguarmembercode":"'
              || pGuarMemberCode
              || '",
      "poprins":"'
              || pOprIns
              || '",
     "psector":"'
              || pSector
              || '",
     "pinstallamt":"'
              || pInstallAmt
              || '",
     "pinsfrq":"'
              || pInsFrq
              || '",
     "pinterestrate":"'
              || pInterestRate
              || '",
     "ptermperiod":"'
              || pTermPeriod
              || '",
     "ptimefrq":"'
              || pTimeFrq
              || '",
     "pmaturitydate":"'
              || pMaturityDate
              || '",
     "pmaturityamt":"'
              || pMaturityAmt
              || '",
     "peffectfrom":"'
              || pEffectFrom
              || '",
      "peffectdate":"'
              || peffectDate
              || '",
     "plinkacdr":"'
              || pLinkAcDr
              || '",
     "pintrotype":"'
              || pIntroType
              || '",
     "pintroacno":"'
              || pIntroAcNo
              || '",
     "pintroname":"'
              || pIntroName
              || '",
     "pintroaddress":"'
              || pIntroAddress
              || '",
     "pintromobile":"'
              || pIntroMobile
              || '",
     "pintrorelation":"'
              || pIntroRelation
              || '",
     "pintroposition":"'
              || pIntroPosition
              || '",
     "pintroothers":"'
              || pIntroOthers
              || '",
     "paiuserid":"'
              || pAiUserId
              || '",
      "pacid":"'
              || pAcId
              || '",
       "pacno":"'
              || pAcNo
              || '"
  }';*/
        BEGIN
            apex_json.initialize_clob_output;
            apex_json.open_object;

            apex_json.write ('pmoduledate', pModuleDate);
            apex_json.write ('pbranchcode', pBranchCode);
            apex_json.write ('pactypeid', pAcTypeId);
            apex_json.write ('pactitle', pAcTitle);
            apex_json.write ('pcustno', pCustno);
            apex_json.write ('pguarmembercode', pGuarMemberCode);
            apex_json.write ('poprins', pOprIns);
            apex_json.write ('psector', pSector);
            apex_json.write ('pinstallamt', pInstallAmt);
            apex_json.write ('pinsfrq', pInsFrq);
            apex_json.write ('pinterestrate', pInterestRate);
            apex_json.write ('ptermperiod', pTermPeriod);
            apex_json.write ('ptimefrq', pTimeFrq);
            apex_json.write ('pmaturitydate', pMaturityDate);
            apex_json.write ('pmaturityamt', pMaturityAmt);
            apex_json.write ('peffectfrom', pEffectFrom);
            apex_json.write ('peffectdate', pEffectDate);
            apex_json.write ('plinkacdr', pLinkAcDr);

            -- Intro / introducer info
            apex_json.write ('pintrotype', pIntroType);
            apex_json.write ('pintroacno', pIntroAcNo);
            apex_json.write ('pintroname', pIntroName);
            apex_json.write ('pintroaddress', pIntroAddress);
            apex_json.write ('pintromobile', pIntroMobile);
            apex_json.write ('pintrorelation', pIntroRelation);
            apex_json.write ('pintroposition', pIntroPosition);
            apex_json.write ('pintroothers', pIntroOthers);

            -- User / account ids
            apex_json.write ('paiuserid', pAiUserId);
            apex_json.write ('pnomineejson', vJson);
            apex_json.write ('pacid', pAcId);
            apex_json.write ('pacno', pAcNo);
            apex_json.close_object;

            vRequest := apex_json.get_clob_output;
            apex_json.free_output;
        -- use vRequest (CLOB with full JSON)

        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Json Build Problem.' || SQLERRM;
                RAISE vMyException;
        END;


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('perrormessage');
        pacid := apex_json.get_varchar2 ('pacid');
        pacno := apex_json.get_varchar2 ('pacno');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            pErrorMessage := pErrorMessage;
            RAISE vMyException;
        END IF;
    /*
            FOR i IN (SELECT DISTINCT a.c001 AS member_code,
                                      a.c003 AS nominee_name,
                                      a.c004 AS fathers_name,
                                      a.c005 AS mother_name,
                                      a.c006 AS relation,
                                      a.c007 AS document_type,
                                      a.c008 AS document_no,
                                      a.d001 AS dob,
                                      a.n001 AS nomi_percent
                        FROM apex_collections a
                       WHERE collection_name = 'NOMINEE' AND a.c001 = pCustno)
            LOOP
                BEGIN
                    POST_DPS_ACCOUNT_NOMINEE_CREATION_API (
                        pCustno             => pCustno,
                        pAcId               => pacid,
                        pNomineeName        => i.nominee_name,
                        pNomiFatherName     => i.fathers_name,
                        pNomiMotherName     => i.mother_name,
                        pNomiDob            => i.dob,
                        pNomiRelation       => i.relation,
                        pNominomPercent     => i.nomi_percent,
                        pNomiDocumentType   => i.document_type,
                        pNomiDocmentNo      => i.document_no,
                        pNomiType           => NULL,
                        pAiUserId           => pAiUserId,
                        pNomineeid          => vnomineeid,
                        pErrorFlag          => pErrorFlag,
                        pErrorMessage       => pErrorMessage);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                            'GUMS.CORE_BANK_API_CONSUME.POST_DPS_ACCOUNT_NOMINEE_CREATION_API Process Calling Problem';
                        RAISE vMyException;
                END;

                apex_json.parse (vResponse);
                pErrorFlag := apex_json.get_varchar2 ('perrorflag');
                pErrorMessage := apex_json.get_varchar2 ('perrormessage');

                FOR k
                    IN (  SELECT c001,
                                 c003,
                                 (SELECT clob001
                                    FROM apex_collections a
                                   WHERE     collection_name = 'NOMINEE'
                                         AND c002 = 'NOMIMG'
                                         AND c003 = x.c003)
                                     AS NOMIMG,
                                 (SELECT clob001
                                    FROM apex_collections a
                                   WHERE     collection_name = 'NOMINEE'
                                         AND c002 = 'DOCFRNT'
                                         AND c003 = x.c003)
                                     AS DOCFRNT,
                                 (SELECT clob001
                                    FROM apex_collections a
                                   WHERE     collection_name = 'NOMINEE'
                                         AND c002 = 'DOCBACK'
                                         AND c003 = x.c003)
                                     AS DOCBACK
                            FROM apex_collections x
                           WHERE     collection_name = 'NOMINEE'
                                 AND x.c002 IN ('NOMIMG', 'DOCFRNT', 'DOCBACK')
                                 AND x.c001 = i.member_code
                                 AND x.c003 = i.nominee_name
                        GROUP BY x.c001, x.c003)
                LOOP
                    BEGIN
                        POST_DPS_ACCOUNT_NOMINEE_IMG_API (
                            pNomineeId      => vnomineeid,
                            pNomImg         => k.NOMIMG,
                            pDocFrontImg    => k.DOCFRNT,
                            pDocBackImg     => k.DOCBACK,
                            pcreateby       => pAiUserId,
                            pErrorFlag      => pErrorFlag,
                            pErrorMessage   => pErrorMessage);
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            pErrorMessage :=
                                'GUMS.CORE_BANK_API_CONSUME.POST_DPS_ACCOUNT_NOMINEE_IMG_API Process Calling Problem';
                            RAISE vMyException;
                    END;
                END LOOP;

            END LOOP;*/



    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            ROLLBACK;
    END;

    PROCEDURE PRC_DPS_RESULT_INFO (pAcId                IN     NUMBER,
                                   pExamName            IN     VARCHAR2,
                                   pBoardName           IN     VARCHAR2,
                                   pRegNo               IN     VARCHAR2,
                                   pRollNo              IN     VARCHAR2,
                                   pDefaultIntRate      IN     NUMBER,
                                   pAfterGPAIntRate     IN     NUMBER,
                                   pResultPublishDate   IN     VARCHAR2,
                                   pGpa                 IN     NUMBER,
                                   pAiUserId            IN     VARCHAR2,
                                   pErrorFlag              OUT VARCHAR2,
                                   pErrorMessage           OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_open/PRC_DPS_RESULT_INFO';

        vRequest :=
               '{   
   "pacid":"'
            || pAcId
            || '",
   "pexamname":"'
            || pExamName
            || '",
   "pboardname":"'
            || pBoardName
            || '",
   "pregno":"'
            || pRegNo
            || '",
   "prollno":"'
            || pRollNo
            || '",
   "pdefaultintrate":"'
            || pDefaultIntRate
            || '",
   "paftergpaintrate":"'
            || pAfterGPAIntRate
            || '",
   "presultpublishdate":"'
            || pResultPublishDate
            || '",
   "pgpa":"'
            || pGpa
            || '", 
   "paiuserid":"'
            || pAiUserId
            || '"
}';


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('perrormessage');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE POST_DPS_ACCOUNT_NOMINEE_CREATION_API (
        pCustno             IN     NUMBER,
        pAcId               IN     NUMBER,
        pNomineeName        IN     VARCHAR2,
        pNomiFatherName     IN     VARCHAR2,
        pNomiMotherName     IN     VARCHAR2,
        pNomiDob            IN     VARCHAR2,
        pNomiRelation       IN     VARCHAR2,
        pNominomPercent     IN     NUMBER,
        pNomiDocumentType   IN     VARCHAR2,
        pNomiDocmentNo      IN     VARCHAR2,
        pNomiType           IN     VARCHAR2,
        pAiUserId           IN     VARCHAR2,
        pNomineeId             OUT NUMBER,
        pErrorFlag             OUT VARCHAR2,
        pErrorMessage          OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_open/PRC_DPS_NOMINEE_CREATION';

        vRequest :=
               '{
   "pcustno":"'
            || pCustno
            || '",
   "pacid":"'
            || pAcId
            || '",
   "pnomineename":"'
            || pNomineeName
            || '",
   "pnomifathername":"'
            || pNomiFatherName
            || '",
   "pnomimothername":"'
            || pNomiMotherName
            || '",
   "pnomidob":"'
            || pNomiDob
            || '",
   "pnomirelation":"'
            || pNomiRelation
            || '",
   "pnominompercent":"'
            || pNominomPercent
            || '",
   "pnomidocumenttype":"'
            || pNomiDocumentType
            || '",
   "pnomidocmentno":"'
            || pNomiDocmentNo
            || '",
   "pnomitype":"'
            || pNomiType
            || '",  
   "paiuserid":"'
            || pAiUserId
            || '",
   "pnomineeid":"'
            || pNomineeId
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('perrormessage');
        pnomineeid := apex_json.get_varchar2 ('pnomineeid');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE POST_DPS_ACCOUNT_NOMINEE_IMG_API (
        pNomineeId      IN     NUMBER,
        pNomImg         IN     CLOB,
        pDocFrontImg    IN     CLOB,
        pDocBackImg     IN     CLOB,
        pcreateby       IN     VARCHAR2,
        pErrorFlag         OUT VARCHAR2,
        pErrorMessage      OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        NULL;
    /*
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl :=
                   vUrl
                || '/psb/psbcore/coresrc/pkg_account_open/PRC_INSERT_NOMINEE_IMG_API';

            vRequest :=
                   '{
       "pnomineeid":"'
                || pNomineeId
                || '",
       "pnomimg":"'
                || pNomImg
                || '",
       "pdocfrontimg":"'
                || pDocFrontImg
                || '",
       "pdocbackimg":"'
                || pDocBackImg
                || '",
       "pcreateby":"'
                || pcreateby
                || '"
    }';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    pErrorFlag := 'Core API Calling Problem';
                    RAISE vMyException;
            END;


            apex_json.parse (vResponse);
            pErrorFlag := apex_json.get_varchar2 ('perrorflag');
            pErrorMessage := apex_json.get_varchar2 ('perrormessage');
            */



    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE GET_DPS_SERVICE_INFO_API (pModuleDate        IN     VARCHAR2,
                                        pEffectDate        IN     VARCHAR2,
                                        pAcTypeId          IN     NUMBER,
                                        pInstallAmt        IN     NUMBER,
                                        pTermPeriod        IN     NUMBER,
                                        pDepositInterval      OUT VARCHAR2,
                                        pIntRate              OUT NUMBER,
                                        pMaturityDate         OUT DATE,
                                        pMaturityAmount       OUT NUMBER,
                                        pErrorFlag            OUT VARCHAR2,
                                        pErrorMessage         OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_open/PRC_DPS_PRODUCT_DETAIL';

        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",
    "peffectdate": "'
            || pEffectDate
            || '",
    "pactypeid": "'
            || pAcTypeId
            || '",
"pinstallamt": "'
            || pInstallAmt
            || '",
"ptermperiod": "'
            || pTermPeriod
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('pErrorFlag');
        pErrorMessage := apex_json.get_varchar2 ('pErrorMessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pDepositInterval := apex_json.get_varchar2 ('pdepositinterval');
        pIntRate := apex_json.get_varchar2 ('pintrate');
        pMaturityDate := apex_json.get_varchar2 ('pmaturitydate');
        pMaturityAmount := apex_json.get_varchar2 ('pmaturityamount');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE DPS_CLOSE_CALCULATION (pModuleDate      IN     DATE,
                                     pBranchCode      IN     VARCHAR2,
                                     pAcNo            IN     VARCHAR2,
                                     pAcId               OUT NUMBER,
                                     pAcTypeId           OUT NUMBER,
                                     pAccountTitle       OUT VARCHAR2,
                                     pOpenDate           OUT DATE,
                                     pLinkAcNo           OUT NUMBER,
                                     pMobileNo           OUT VARCHAR2,
                                     pMatureRate         OUT NUMBER,
                                     pMaturityDate       OUT DATE,
                                     pDpsBalance         OUT NUMBER,
                                     pInstAmt            OUT NUMBER,
                                     pTotalInstNo        OUT NUMBER,
                                     pPaidInstNo         OUT NUMBER,
                                     pPrematureRate      OUT NUMBER,
                                     pIntProfit          OUT NUMBER,
                                     pClosingChg         OUT NUMBER,
                                     pIncomeTax          OUT NUMBER,
                                     pExciseDuty         OUT NUMBER,
                                     pPostedIntAmt       OUT NUMBER,
                                     pProvIntAmt         OUT NUMBER,
                                     pProvRevAmt         OUT NUMBER,
                                     pProvAdjAmt         OUT NUMBER,
                                     pPostIntAmt         OUT NUMBER,
                                     pPostRevAmt         OUT NUMBER,
                                     pTotalPayable       OUT NUMBER,
                                     pErrorFlag          OUT VARCHAR2,
                                     pErrorMessage       OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_close_dps/DPS_CLOSE_CALCULATION';


        vRequest := '{
    "pmoduledate": "' || pModuleDate || '",
    "pbranchcode": "' || pBranchCode || '",
    "pacno": "' || pAcNo || '"  
                }';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;



        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pAcId := apex_json.get_number ('pacid');
        pAcTypeId := apex_json.get_number ('pactypeid');
        pAccountTitle := apex_json.get_varchar2 ('paccounttitle');
        pOpenDate := apex_json.get_date ('popendate');
        pLinkAcNo := apex_json.get_number ('plinkacno');
        pMobileNo := apex_json.get_varchar2 ('pmobileno');
        pMatureRate := apex_json.get_number ('pmaturerate');
        pMaturityDate := apex_json.get_date ('pmaturitydate');
        pDpsBalance := apex_json.get_number ('pdpsbalance');
        pInstAmt := apex_json.get_number ('pinstamt');
        pTotalInstNo := apex_json.get_number ('ptotalinstno');
        pPaidInstNo := apex_json.get_number ('ppaidinstno');
        pPrematureRate := apex_json.get_number ('pprematurerate');
        pIntProfit := apex_json.get_number ('pintprofit');
        pClosingChg := apex_json.get_number ('pclosingchg');
        pIncomeTax := apex_json.get_number ('pincometax');
        pExciseDuty := apex_json.get_number ('pexciseduty');
        pPostedIntAmt := apex_json.get_number ('ppostedintamt');
        pProvIntAmt := apex_json.get_number ('pprovintamt');
        pProvRevAmt := apex_json.get_number ('pprovrevamt');
        pProvAdjAmt := apex_json.get_number ('pprovadjamt');
        pPostIntAmt := apex_json.get_number ('ppostintamt');
        pPostRevAmt := apex_json.get_number ('ppostrevamt');
        pTotalPayable := apex_json.get_number ('ptotalpayable');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE CASA_CLOSE_CALCULATION (pModuleDate     IN     DATE,
                                      pBranchCode     IN     VARCHAR2,
                                      pAcNo           IN     VARCHAR2,
                                      pAcId              OUT NUMBER,
                                      pCustNo            OUT NUMBER,
                                      pAcTypeId          OUT NUMBER,
                                      pAccountTitle      OUT VARCHAR2,
                                      pAcStatus          OUT VARCHAR2,
                                      pOpenDate          OUT DATE,
                                      pMemberCode        OUT VARCHAR2,
                                      pMemberName        OUT VARCHAR2,
                                      pMobileNo          OUT VARCHAR2,
                                      pCurrBalance       OUT NUMBER,
                                      pBlockAmt          OUT NUMBER,
                                      pIntProfit         OUT NUMBER,
                                      pClosingChg        OUT NUMBER,
                                      pIncomeTax         OUT NUMBER,
                                      pExciseDuty        OUT NUMBER,
                                      pPostedIntAmt      OUT NUMBER,
                                      pProvIntAmt        OUT NUMBER,
                                      pProvRevAmt        OUT NUMBER,
                                      pPostIntAmt        OUT NUMBER,
                                      pPostRevAmt        OUT NUMBER,
                                      pTotalPayable      OUT NUMBER,
                                      pGovGrant          OUT NUMBER,
                                      pErrorFlag         OUT VARCHAR2,
                                      pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_close_casa/CASA_CLOSE_CALCULATION';


        vRequest := '{
    "pmoduledate": "' || pModuleDate || '",
    "pbranchcode": "' || pBranchCode || '",
    "pacno": "' || pAcNo || '"  
                }';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pAcId := apex_json.get_number ('pacid');
        pCustNo := apex_json.get_number ('pcustno');
        pAcTypeId := apex_json.get_number ('pactypeid');
        pAccountTitle := apex_json.get_varchar2 ('paccounttitle');
        pAcStatus := apex_json.get_varchar2 ('pacstatus');
        pOpenDate := apex_json.get_date ('popendate');
        pMemberCode := apex_json.get_varchar2 ('pmembercode');
        pMemberName := apex_json.get_varchar2 ('pmembername');
        pMobileNo := apex_json.get_varchar2 ('pmobileno');
        pCurrBalance := apex_json.get_number ('pcurrbalance');
        pBlockAmt := apex_json.get_number ('pblockamt');
        pIntProfit := apex_json.get_number ('pintprofit');
        pClosingChg := apex_json.get_number ('pclosingchg');
        pIncomeTax := apex_json.get_number ('pincometax');
        pExciseDuty := apex_json.get_number ('pexciseduty');
        pPostedIntAmt := apex_json.get_number ('ppostedintamt');
        pProvIntAmt := apex_json.get_number ('pprovintamt');
        pProvRevAmt := apex_json.get_number ('pprovrevamt');
        pPostIntAmt := apex_json.get_number ('ppostintamt');
        pPostRevAmt := apex_json.get_number ('ppostrevamt');
        pTotalPayable := apex_json.get_number ('ptotalpayable');
        pGovGrant := apex_json.get_number ('pgovgrant');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE DPS_CLOSE_REQUEST (pModuleDate      IN     DATE,
                                 pBranchCode      IN     VARCHAR2,
                                 pAcTypeId        IN     NUMBER,
                                 pAcId            IN     NUMBER,
                                 pClosingReason   IN     VARCHAR2,
                                 pAiUserId        IN     VARCHAR2,
                                 pAccountTitle    IN     VARCHAR2,
                                 pOpenDate        IN     DATE,
                                 pLinkAcNo        IN     NUMBER,
                                 pMobileNo        IN     VARCHAR2,
                                 pMatureRate      IN     NUMBER,
                                 pMaturityDate    IN     DATE,
                                 pDpsBalance      IN     NUMBER,
                                 pInstAmt         IN     NUMBER,
                                 pTotalInstNo     IN     NUMBER,
                                 pPaidInstNo      IN     NUMBER,
                                 pPrematureRate   IN     NUMBER,
                                 pIntProfit       IN     NUMBER,
                                 pClosingChg      IN     NUMBER,
                                 pIncomeTax       IN     NUMBER,
                                 pExciseDuty      IN     NUMBER,
                                 pPostedIntAmt    IN     NUMBER,
                                 pProvIntAmt      IN     NUMBER,
                                 pProvRevAmt      IN     NUMBER,
                                 pProvAdjAmt      IN     NUMBER,
                                 pPostIntAmt      IN     NUMBER,
                                 pPostRevAmt      IN     NUMBER,
                                 pTotalPayable    IN     NUMBER,
                                 pErrorFlag          OUT VARCHAR2,
                                 pErrorMessage       OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_close_dps/DPS_CLOSE_REQUEST';


        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",
    "pbranchcode": "'
            || pBranchCode
            || '",
    "pactypeid": "'
            || pAcTypeId
            || '",
    "pacid": "'
            || pAcId
            || '",
    "pclosingreason": "'
            || pClosingReason
            || '",
    "paiuserid": "'
            || pAiUserId
            || '",
    "paccounttitle": "'
            || pAccountTitle
            || '",
    "popendate": "'
            || pOpenDate
            || '",
    "plinkacno": "'
            || pLinkAcNo
            || '",
    "pmobileno": "'
            || pMobileNo
            || '",
    "pmaturerate": "'
            || pMatureRate
            || '",
    "pmaturitydate": "'
            || pMaturityDate
            || '",
    "pdpsbalance": "'
            || pDpsBalance
            || '",
    "pinstamt": "'
            || pInstAmt
            || '",
    "ptotalinstno": "'
            || pTotalInstNo
            || '",
    "ppaidinstno": "'
            || pPaidInstNo
            || '",
    "pprematurerate": "'
            || pPrematureRate
            || '",
    "pintprofit": "'
            || pIntProfit
            || '",
    "pclosingchg": "'
            || pClosingChg
            || '",
    "pincometax": "'
            || pIncomeTax
            || '",
    "pexciseduty": "'
            || pExciseDuty
            || '",
    "ppostedintamt": "'
            || pPostedIntAmt
            || '",
    "pprovintamt": "'
            || pProvIntAmt
            || '",
    "pprovrevamt": "'
            || pProvRevAmt
            || '",
     "pprovadjamt": "'
            || pProvAdjAmt
            || '",  
    "ppostintamt": "'
            || pPostIntAmt
            || '",
    "ppostrevamt": "'
            || pPostRevAmt
            || '",
    "ptotalpayable": "'
            || pTotalPayable
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE POST_DEAD_REQUEST (pBranchCode     IN     VARCHAR2,
                                 pSamiteeCode    IN     VARCHAR2,
                                 pCustNo         IN     NUMBER,
                                 pDeathDate      IN     DATE,
                                 pDeathDecDate   IN     DATE,
                                 pOverDue        IN     NUMBER,
                                 pDocDeadImage   IN     CLOB,
                                 pAiUserId       IN     VARCHAR2,
                                 pErrorFlag         OUT VARCHAR2,
                                 pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
            vUrl || '/psb/psbcore/coresrc/pkg_dead_member/PRC_DEAD_REQUEST';

        vRequest :=
               '{
    "pbranchcode": "'
            || pBranchCode
            || '",
    "psamiteecode": "'
            || pSamiteeCode
            || '",
    "pcustno": "'
            || pCustNo
            || '",
    "pdeathdate": "'
            || pDeathDate
            || '",  
     "pdeathdecdate": "'
            || pDeathDecDate
            || '",     
        "poverdue": "'
            || pOverDue
            || '",
    "pdocdeadimage": "'
            || pDocDeadImage
            || '",
     "paiuserid": "'
            || pAiUserId
            || '"  
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE PRC_INSERT_DEAD_CERTIFICATE (pCustNo         IN     NUMBER,
                                           pDocDeadImage   IN     CLOB,
                                           pAiUserId       IN     VARCHAR2,
                                           pErrorFlag         OUT VARCHAR2,
                                           pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_dead_member/PRC_INSERT_DEAD_CERTIFICATE';

        vRequest :=
               '{   
                "pcustno": "'
            || pCustNo
            || '",
                "pdocdeadimage": "'
            || pdocdeadimage
            || '",
                "paiuserid": "'
            || pAiUserId
            || '"  
             }';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;


    PROCEDURE PRC_INSERT_BANK_LOGO (pBankCode       IN     VARCHAR2,
                                    pBankLogo       IN     CLOB,
                                    pErrorFlag         OUT VARCHAR2,
                                    pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
        ddddd           BLOB;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;


        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_dead_member/PRC_INSERT_BANK_LOGO';
        vRequest := '{   
                "pbankcode": "' || pBankCode || '",
                "pbanklogo": "' || pBankLogo || '"
             }';


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE DPS_CLOSE_APPROVAL (pModuleDate     IN     DATE,
                                  pBranchCode     IN     VARCHAR2,
                                  pAcId           IN     NUMBER,
                                  pAiUserId       IN     VARCHAR2,
                                  pAiLogId        IN     VARCHAR2,
                                  pApprovReject   IN     VARCHAR2,
                                  pDocNum            OUT VARCHAR2,
                                  pErrorFlag         OUT VARCHAR2,
                                  pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_close_dps/DPS_CLOSE_APPROVAL';



        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",
    "pbranchcode": "'
            || pBranchCode
            || '",    
    "pacid": "'
            || pAcId
            || '",   
    "paiuserid": "'
            || pAiUserId
            || '",
    "pailogid": "'
            || pAiLogId
            || '",
    "papprovreject": "'
            || pApprovReject
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');
        pDocNum := apex_json.get_varchar2 ('pdocnum');


        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE CASA_CLOSE_APPROVAL (pModuleDate     IN     DATE,
                                   pBranchCode     IN     VARCHAR2,
                                   pAcId           IN     NUMBER,
                                   pAiUserId       IN     VARCHAR2,
                                   pAiLogId        IN     VARCHAR2,
                                   pApprovReject   IN     VARCHAR2,
                                   pDocNum            OUT VARCHAR2,
                                   pErrorFlag         OUT VARCHAR2,
                                   pErrorMessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_close_casa/CASA_CLOSE_APPROVAL';



        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",
    "pbranchcode": "'
            || pBranchCode
            || '",    
    "pacid": "'
            || pAcId
            || '",   
    "paiuserid": "'
            || pAiUserId
            || '",
    "pailogid": "'
            || pAiLogId
            || '",
    "papprovreject": "'
            || pApprovReject
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');
        pDocNum := apex_json.get_varchar2 ('pdocnum');



        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE GET_DPS_AGE_INFO_API (pModuleDate     IN     VARCHAR2,
                                    pMemberCode     IN     VARCHAR2,
                                    pAcTypeId       IN     NUMBER,
                                    pErrorFlag         OUT VARCHAR2,
                                    pErrorMessage      OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_account_open/PRC_DPS_CUSTOMER_AGE';

        vRequest :=
               '{
    "pmoduledate": "'
            || pModuleDate
            || '",
    "pmembercode": "'
            || pMemberCode
            || '",
    "pactypeid": "'
            || pAcTypeId
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('perrormessage');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE REQUEST_CHANGE_LOG (pInJson              CLOB,
                                  pRecIdentifier   OUT NUMBER,
                                  pOutData         OUT CLOB,
                                  pErrorFlag       OUT VARCHAR2,
                                  pErrorMsg        OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;


        vUrl := vUrl || '/psb/psbcore/coresrc/change_auth/REQUEST_CHANGE_LOG';


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => pInJson,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMsg := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMsg := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pRecIdentifier := apex_json.get_varchar2 ('precidentifier');
        pOutData := apex_json.get_varchar2 ('pretdata');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE SEND_CUSTOMER_DOC_API (pRequestID         PLS_INTEGER,
                                     pDocType           VARCHAR2,
                                     pDocNo             VARCHAR2,
                                     pIssueDate         DATE,
                                     pExpireDate        DATE,
                                     pIssuePlace        VARCHAR2,
                                     pDocFrontImg       CLOB,
                                     pDocBackImg        CLOB,
                                     pSuccessMsg    OUT VARCHAR2,
                                     pErrorFlag     OUT VARCHAR2,
                                     pErrorMsg      OUT VARCHAR2)
    IS
        vUrl             VARCHAR2 (4000);
        l_request_body   CLOB;
        l_response       CLOB;
        vMyException     EXCEPTION;
    BEGIN
        IF pDocNo IS NULL
        THEN
            pErrorMsg := 'Document No. Required.';
            RAISE vMyException;
        ELSIF pDocFrontImg IS NULL
        THEN
            pErrorMsg := 'Document Front-image Required.';
            RAISE vMyException;
        ELSIF pDocBackImg IS NULL
        THEN
            pErrorMsg := 'Document Back-img Required.';
            RAISE vMyException;
        END IF;

        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        BEGIN
            -- Set the URL
            vUrl :=
                vUrl || '/psb/psbcore/coresrc/CustomerCreation/PRC_CUST_DOC';

            l_request_body :=
                   '{
    "prequestid":"'
                || pRequestID
                || '",
    "pdoctype": "'
                || pDocType
                || '",
    "pdocno": "'
                || pDocNo
                || '",           
    "pissuedate": "'
                || TO_DATE (pIssueDate)
                || '",
    "pexpiredate": "'
                || TO_DATE (pExpireDate)
                || '",
    "pissueplace": "'
                || pIssuePlace
                || '",
    "pdocfront": "'
                || pDocFrontImg
                || '",
    "pdocback": "'
                || pDocBackImg
                || '"
}';
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            l_response :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => l_request_body,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMsg := 'Document sending request failed';
                RAISE vMyException;
        END;


        apex_json.parse (l_response);
        pSuccessMsg := apex_json.get_varchar2 ('psuccessmessage');

        IF l_response IS NULL
        THEN
            pErrorMsg := 'API Responded without data';
            RAISE vMyException;
        END IF;

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END SEND_CUSTOMER_DOC_API;

    PROCEDURE SEND_GUARANTOR_DOC_API (pCustNo               NUMBER,
                                      pDocType              VARCHAR2,
                                      pDocNo                VARCHAR2,
                                      pDocStatus            VARCHAR2,
                                      pIssueDate            DATE,
                                      pExpireDate           DATE,
                                      pIssuePlace           VARCHAR2,
                                      pDocFront             CLOB,
                                      pDocBack              CLOB,
                                      pErrorMessage     OUT VARCHAR2,
                                      pErrorFlag        OUT VARCHAR2,
                                      pSuccessMessage   OUT VARCHAR2)
    IS
        vUrl             VARCHAR2 (4000);
        l_request_body   CLOB;
        l_response       CLOB;
        vMyException     EXCEPTION;
    BEGIN
        IF pDocNo IS NULL
        THEN
            pErrorMessage := 'Document No. Required.';
            RAISE vMyException;
        ELSIF pDocFront IS NULL
        THEN
            pErrorMessage := 'Document Front-image Required.';
            RAISE vMyException;
        ELSIF pDocBack IS NULL
        THEN
            pErrorMessage := 'Document Back-img Required.';
            RAISE vMyException;
        END IF;

        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        BEGIN
            -- Set the URL
            vUrl :=
                   vUrl
                || '/psb/psbcore/coresrc/pkg_guarantor_doc/PRC_GURANTOR_DOC';

            l_request_body :=
                   '{
    "pcustno":"'
                || pCustNo
                || '",
    "pdoctype": "'
                || pDocType
                || '",
    "pdocno": "'
                || pDocNo
                || '",
   "pdocstatus": "'
                || pDocStatus
                || '",
    "pissuedate": "'
                || TO_DATE (pIssueDate)
                || '",
    "pexpiredate": "'
                || TO_DATE (pExpireDate)
                || '",
    "pissueplace": "'
                || pIssuePlace
                || '",
    "pdocfront": "'
                || pDocFront
                || '",
    "pdocback": "'
                || pDocBack
                || '"
}';
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            l_response :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => l_request_body,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Document sending request failed';
                RAISE vMyException;
        END;

        apex_json.parse (l_response);
        pSuccessMessage := apex_json.get_varchar2 ('psuccessmessage');

        IF l_response IS NULL
        THEN
            pErrorMessage := 'API Responded without data';
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END SEND_GUARANTOR_DOC_API;

    PROCEDURE SEND_TM_CUST_IMG_API (pRequestID        PLS_INTEGER,
                                    pCustImage        CLOB,
                                    pErrorflag    OUT VARCHAR2,
                                    pErrorMsg     OUT VARCHAR2,
                                    pSuccessMsg   OUT VARCHAR2)
    IS
        vUrl             VARCHAR2 (1024);
        l_request_body   CLOB;
        l_response       CLOB;
        vMyException     EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        IF pCustImage IS NULL
        THEN
            pErrorMsg := 'Customer image not found.';
            RAISE vMyException;
        END IF;

        vUrl :=
            vUrl || '/psb/psbcore/coresrc/CustomerCreation/PRC_ADD_CUST_IMG';

        BEGIN
            -- Set the request body with your parameter values
            l_request_body := '{
    "prequestid":"' || pRequestID || '",
    "pcustimage": "' || pCustImage || '"}';

            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            l_response :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => l_request_body,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMsg := 'Image sending request failed';
                RAISE vMyException;
        END;

        apex_json.parse (l_response);
        pSuccessMsg := apex_json.get_varchar2 ('psuccessmessage');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END SEND_TM_CUST_IMG_API;

    PROCEDURE REQUEST_CHANGE_APPROVAL (pRecordIdentifier       NUMBER,
                                       pRunUser                VARCHAR2,
                                       pErrorFlag          OUT VARCHAR2,
                                       pErrorMessage       OUT VARCHAR2)
    IS
        vUrl                VARCHAR2 (1024);
        vResponse           CLOB;
        vRequest            CLOB;
        vCheckImgReq        NUMBER;
        l_response_status   NUMBER;
        vSuccessMsg         VARCHAR2 (1024);
        vErrMsg             VARCHAR2 (1024);
        vErrFlag            VARCHAR2 (10);
        vCustNo             VARCHAR2 (100);
        vTaskId             VARCHAR2 (1024);
        vParamValue         CLOB;                          --VARCHAR2 (32000);
        vMyException        EXCEPTION;
    BEGIN
        pErrorFlag := 'N';

        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        SELECT TO_CHAR (TASK_ID)
          INTO vTaskId
          FROM APEX_TASK_PARAMETERS
         WHERE     PARAM_STATIC_ID = 'RECORD_IDENTIFIER'
               AND PARAM_VALUE = pRecordIdentifier;                   ----8468

        SELECT PARAM_VALUE
          INTO vParamValue
          FROM APEX_TASK_PARAMETERS
         WHERE     TASK_ID = vTaskId
               AND PARAM_STATIC_ID IN ('UPDATE_INFO', 'INCLUDE_INFO');



        IF vParamValue IS NULL
        THEN
            BEGIN
                SELECT OUTPUT
                  INTO vParamValue
                  FROM GUMS.TASK_OUTPUT_INFO
                 WHERE TASK_ID = pRecordIdentifier;
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;
        END IF;

        -- pErrorMessage := 'Check --' || vParamValue || pRecordIdentifier;
        -- RAISE vMyException;

        --
        IF vParamValue IS NOT NULL
        THEN
            vUrl :=
                   vUrl
                || '/psb/psbcore/coresrc/change_auth/APPROVE_CHANGE_REQUEST';

            vRequest :=
                   '{"precordidentifier":"'
                || pRecordIdentifier
                || '","prunuser":"'
                || pRunUser
                || '"}';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    pErrorMessage := 'Core API Calling Problem';
                    RAISE vMyException;
            END;


            apex_json.parse (vResponse);
            pErrorFlag := apex_json.get_varchar2 ('perrorflag');
            pErrorMessage := apex_json.get_varchar2 ('perrormessage');

            IF NVL (pErrorFlag, 'N') = 'Y'
            THEN
                RAISE vMyException;
            END IF;
        END IF;


        SELECT COUNT (LOG_ID)
          INTO vCheckImgReq
          FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
         WHERE RECORD_IDENTIFIER = pRecordIdentifier;


        --------
        IF vCheckImgReq > 0
        THEN
            FOR req_log
                IN (SELECT r1.RECORD_IDENTIFIER,
                           r1.TABLE_NAME,
                           CASE
                               WHEN r1.KEY_COL_NAME = 'CUST_NO' -- PK for CUST_DOC table
                               THEN
                                   KEY_COL_VALUE
                               ELSE
                                   NULL
                           END
                               CUST_NO,
                           CASE
                               WHEN r1.KEY_COL_NAME = 'NOMINEE_ID' --PK for NOMINEE_IMG table
                               THEN
                                   KEY_COL_VALUE
                               ELSE
                                   NULL
                           END
                               NOMINEE_ID,
                           CASE
                               WHEN r1.KEY_COL_NAME2 = 'DOCUMENT_ID' --PK for CUST_DOC table
                               THEN
                                   KEY_COL_VALUE2
                               ELSE
                                   NULL
                           END
                               DOCUMENT_ID,
                           CASE
                               WHEN r1.KEY_COL_NAME = 'AC_ID' --PK for ACCOUNT_SIGNATURE_CARD table
                               THEN
                                   KEY_COL_VALUE
                               ELSE
                                   NULL
                           END
                               AC_ID,
                           b.DOC_FRONT,
                           f.DOC_BACK,
                           i.CUST_IMAGE,
                           r1.CREATE_BY,
                           UPDATE_FLAG
                      FROM (SELECT DISTINCT RECORD_IDENTIFIER,
                                            TABLE_NAME,
                                            KEY_COL_NAME,
                                            KEY_COL_VALUE,
                                            KEY_COL_NAME2,
                                            KEY_COL_VALUE2,
                                            CREATE_BY,
                                            UPDATE_FLAG
                              FROM MB_IMG_REQUEST_CHANGE_LOG
                             WHERE RECORD_IDENTIFIER = pRecordIdentifier) r1
                           LEFT JOIN
                           (SELECT RECORD_IDENTIFIER,
                                   TABLE_NAME,
                                   KEY_COL_NAME,
                                   NEW_VAL_BLOB AS DOC_FRONT
                              FROM MB_IMG_REQUEST_CHANGE_LOG
                             WHERE COL_NAME IN
                                       ('DOC_FRONT_IMAGE', 'DOC_FRONT_IMG')) -- 1 for cust_doc, 2 for nominee_img
                           b
                               ON     r1.RECORD_IDENTIFIER =
                                      b.RECORD_IDENTIFIER
                                  AND r1.TABLE_NAME = b.TABLE_NAME
                                  AND r1.KEY_COL_NAME = b.KEY_COL_NAME
                           LEFT JOIN
                           (SELECT RECORD_IDENTIFIER,
                                   TABLE_NAME,
                                   KEY_COL_NAME,
                                   NEW_VAL_BLOB AS DOC_BACK
                              FROM MB_IMG_REQUEST_CHANGE_LOG
                             WHERE COL_NAME IN
                                       ('DOC_BACK_IMAGE', 'DOC_BACK_IMG')) f -- 1 for cust_doc, 2 for nominee_img
                               ON     r1.RECORD_IDENTIFIER =
                                      f.RECORD_IDENTIFIER
                                  AND r1.TABLE_NAME = f.TABLE_NAME
                                  AND r1.KEY_COL_NAME = f.KEY_COL_NAME
                           LEFT JOIN
                           (SELECT RECORD_IDENTIFIER,
                                   TABLE_NAME,
                                   KEY_COL_NAME,
                                   NEW_VAL_BLOB AS CUST_IMAGE
                              FROM MB_IMG_REQUEST_CHANGE_LOG
                             WHERE COL_NAME IN
                                       ('CUST_IMAGE',
                                        'NOMINEE_IMG',
                                        'CARD_IMG')) -- 1 for cust_doc, 2 for nominee_img, 3 for ACCOUNT_SIGNATURE_CARD
                                                     i
                               ON     r1.RECORD_IDENTIFIER =
                                      i.RECORD_IDENTIFIER
                                  AND r1.TABLE_NAME = i.TABLE_NAME
                                  AND r1.KEY_COL_NAME = i.KEY_COL_NAME)
            LOOP
                IF req_log.TABLE_NAME = 'CUST_DOC'
                THEN
                    BEGIN
                        SELECT APP_LINK_LOCAL INTO vURL FROM GUMS.MB_GLOBAL_RULE;

                        vURL := vURL || '/psb/psbimg/imgsrc/insCustomerdoc/';
                        vRequest :=
                               '{
                 "pdocumentid": "'
                            || req_log.DOCUMENT_ID
                            || '",
                 "pdmltype":"U",
                 "pcreateby": "'
                            || req_log.CREATE_BY
                            || '",
                 "pcustno": "'
                            || req_log.CUST_NO
                            || '",
                 "pdocfrontimage": "'
                            || CASE
                                   WHEN req_log.DOC_FRONT IS NOT NULL
                                   THEN
                                       apex_web_service.blob2clobbase64 (
                                           p_blob       => req_log.DOC_FRONT,
                                           p_newlines   => 'N')
                                   ELSE
                                       NULL
                               END
                            || '",
                 "pdocbackimage": "'
                            || CASE
                                   WHEN req_log.DOC_BACK IS NOT NULL
                                   THEN
                                       apex_web_service.blob2clobbase64 (
                                           p_blob       => req_log.DOC_BACK,
                                           p_newlines   => 'N')
                                   ELSE
                                       NULL
                               END
                            || '"
              }';

                        BEGIN
                            APEX_WEB_SERVICE.g_request_headers (1).name :=
                                'Content-Type';
                            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                                'application/json';
                            vResponse :=
                                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                                    p_url                => vUrl,
                                    p_http_method        => 'POST',
                                    p_body               => vRequest,
                                    p_transfer_timeout   => 30);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                perrormessage :=
                                    'Memimage Api Calling Problem';
                                RAISE vMyException;
                        END;

                        --  perrormessage :=vResponse;
                        -- RAISE vMyException;

                        -- Process the response
                        BEGIN
                            l_response_status :=
                                APEX_WEB_SERVICE.g_status_code;

                            SELECT psuccessmessage, perrormessage, perrorflag
                              INTO vSuccessMsg, vErrMsg, vErrFlag
                              FROM JSON_TABLE (
                                       vResponse, '$'
                                       COLUMNS (psuccessmessage VARCHAR2 (1024)
                                                    PATH '$.psuccessmessage',
                                                perrormessage VARCHAR2 (1024)
                                                    PATH '$.perrormessage',
                                                perrorflag VARCHAR2 (10)
                                                    PATH '$.perrorflag'));

                            IF NVL (vErrFlag, 'N') = 'Y'
                            THEN
                                perrormessage :=
                                       'HTTP Request Failed with status code: '
                                    || l_response_status
                                    || vErrMsg;
                                RAISE vMyException;
                            END IF;
                        END;

                        IF l_response_status = 200
                        THEN
                            DELETE FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                                  WHERE RECORD_IDENTIFIER = pRecordIdentifier;
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            pErrorMessage :=
                                   'Member Documents Sending Problem'
                                || pErrorMessage
                                || vCustNo;
                            RAISE vMyException;
                    END;
                END IF;

                -----Send member image----
                IF req_log.TABLE_NAME = 'MEMBER_IMAGE'
                THEN
                    SELECT APP_LINK_LOCAL INTO vURL FROM GUMS.MB_GLOBAL_RULE;

                    vURL := vURL || '/psb/psbimg/imgsrc/insCustomerImg/';

                    BEGIN
                        vRequest :=
                               '{
                 "pcustno": "'
                            || req_log.CUST_NO
                            || '",
                 "pcreateby": "'
                            || req_log.CREATE_BY
                            || '",
                 "pcreatedate": "'
                            || TO_CHAR (SYSDATE, 'DD-MON-YYYY')
                            || '",
                 "pimgname": "'
                            || req_log.CUST_NO
                            || '",
                 "pcusimg": "'
                            || apex_web_service.blob2clobbase64 (
                                   p_blob       => req_log.CUST_IMAGE,
                                   p_newlines   => 'N')
                            || '",
                 "pdmltype": "U"
              }';

                        BEGIN
                            APEX_WEB_SERVICE.g_request_headers (1).name :=
                                'Content-Type';
                            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                                'application/json';
                            vResponse :=
                                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                                    p_url                => vUrl,
                                    p_http_method        => 'POST',
                                    p_body               => vRequest,
                                    p_transfer_timeout   => 30);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                pErrorFlag := 'Memimage Api Calling Problem';
                                RAISE vMyException;
                        END;

                        -- Process the response
                        BEGIN
                            l_response_status :=
                                APEX_WEB_SERVICE.g_status_code;

                            SELECT psuccessmessage, perrormessage, perrorflag
                              INTO vSuccessMsg, vErrMsg, vErrFlag
                              FROM JSON_TABLE (
                                       vResponse, '$'
                                       COLUMNS (psuccessmessage VARCHAR2 (1024)
                                                    PATH '$.psuccessmessage',
                                                perrormessage VARCHAR2 (1024)
                                                    PATH '$.perrormessage',
                                                perrorflag VARCHAR2 (10)
                                                    PATH '$.perrorflag'));

                            IF NVL (vErrFlag, 'N') = 'Y'
                            THEN
                                perrormessage :=
                                       'HTTP Request Failed with status code: '
                                    || l_response_status
                                    || vErrMsg;
                                RAISE vMyException;
                            END IF;
                        END block_of_Parsing_response;

                        IF l_response_status = 200
                        THEN
                            DELETE FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                                  WHERE RECORD_IDENTIFIER = pRecordIdentifier;
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            pErrorMessage :=
                                   'Member Image Sending Problem'
                                || pErrorMessage
                                || vCustNo;
                            RAISE vMyException;
                    END request_customer_image_api;
                END IF;

                ---------------- Update npminee image, document of NOMINEE_IMAGE , added by Foisal Mahmud
                IF req_log.TABLE_NAME = 'NOMINEE_IMAGE'
                THEN
                    BEGIN
                        GUMS.PRC_CASA_NOMINEE_ADD (
                            pNomineeId =>
                                req_log.NOMINEE_ID,
                            pNomImg =>
                                apex_web_service.blob2clobbase64 (
                                    p_blob       => req_log.CUST_IMAGE,
                                    p_newlines   => 'N'),
                            pDocFrontImg =>
                                apex_web_service.blob2clobbase64 (
                                    p_blob       => req_log.DOC_FRONT,
                                    p_newlines   => 'N'),
                            pDocBackImg =>
                                apex_web_service.blob2clobbase64 (
                                    p_blob       => req_log.DOC_BACK,
                                    p_newlines   => 'N'),
                            pDmlType =>
                                'U',
                            pCreateBy =>
                                req_log.CREATE_BY,
                            pErrorFlag =>
                                vErrFlag,
                            pErrorMessage =>
                                vErrMsg);
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            perrormessage :=
                                'Nominee Image Updating Problem.' || SQLERRM;
                            RAISE vMyException;
                    END Nominee;

                    IF NVL (vErrFlag, 'N') != 'Y'
                    THEN
                        DELETE FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                              WHERE RECORD_IDENTIFIER = pRecordIdentifier;
                    ELSIF NVL (vErrFlag, 'N') = 'Y'
                    THEN
                        perrormessage := vErrMsg;
                        RAISE vMyException;
                    END IF;
                END IF;

                ------------Update signature card of ACCOUNT_SIGNATURE_CARD, added by Foisal Mahmud
                IF req_log.TABLE_NAME = 'ACCOUNT_SIGNATURE_CARD'
                THEN
                    SELECT APP_LINK_LOCAL INTO vURL FROM GUMS.MB_GLOBAL_RULE;

                    vURL := vURL || '/psb/psbimg/imgsrc/sign_card/';

                    BEGIN
                        vRequest :=
                               '{
                 "pacid": "'
                            || req_log.AC_ID
                            || '",
                 "pcreateby": "'
                            || req_log.CREATE_BY
                            || '",
                 "pcreatedate": "'
                            || TO_CHAR (SYSDATE, 'DD-MON-YYYY')
                            || '",
                 "pcardimg": "'
                            || apex_web_service.blob2clobbase64 (
                                   p_blob       => req_log.CUST_IMAGE,
                                   p_newlines   => 'N')
                            || '",
                 "pdmltype": "U"
              }';

                        BEGIN
                            APEX_WEB_SERVICE.g_request_headers (1).name :=
                                'Content-Type';
                            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                                'application/json';
                            vResponse :=
                                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                                    p_url                => vUrl,
                                    p_http_method        => 'POST',
                                    p_body               => vRequest,
                                    p_transfer_timeout   => 30);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                pErrorFlag :=
                                    'Sign-Card Api Calling Problem for Update.';
                                RAISE vMyException;
                        END;

                        -- Process the response
                        BEGIN
                            l_response_status :=
                                APEX_WEB_SERVICE.g_status_code;

                            SELECT psuccessmessage, perrormessage, perrorflag
                              INTO vSuccessMsg, vErrMsg, vErrFlag
                              FROM JSON_TABLE (
                                       vResponse, '$'
                                       COLUMNS (psuccessmessage VARCHAR2 (1024)
                                                    PATH '$.psuccessmessage',
                                                perrormessage VARCHAR2 (1024)
                                                    PATH '$.perrormessage',
                                                perrorflag VARCHAR2 (10)
                                                    PATH '$.perrorflag'));

                            IF NVL (vErrFlag, 'N') = 'Y'
                            THEN
                                perrormessage :=
                                       'HTTP Request Failed with status code: '
                                    || l_response_status
                                    || vErrMsg;
                                RAISE vMyException;
                            END IF;
                        END block_parsing_of_response;

                        IF l_response_status = 200
                        THEN
                            DELETE FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                                  WHERE RECORD_IDENTIFIER = pRecordIdentifier;
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            pErrorMessage :=
                                   'Signature Card Sending Problem for update.'
                                || pErrorMessage;
                            RAISE vMyException;
                    END request_update_signature_card_image_api;
                END IF;
            END LOOP req_log;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE REQUEST_REJECT (pRecordIdentifier       NUMBER,
                              pRunUser                VARCHAR2,
                              pErrorFlag          OUT VARCHAR2,
                              pErrorMessage       OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;


        vUrl := vUrl || '/psb/psbcore/coresrc/change_auth/REQUEST_REJECT';

        vRequest :=
               '{"precidentifier":"'
            || pRecordIdentifier
            || '","prunuser":"'
            || pRunUser
            || '"}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE INCLUDE_REQUEST_APPROVAL (pRecordIdentifier       NUMBER,
                                        pRunUser                VARCHAR2,
                                        pErrorFlag          OUT VARCHAR2,
                                        pErrorMessage       OUT VARCHAR2)
    IS
        vUrl                VARCHAR2 (1024);
        vResponse           CLOB;
        vRequest            CLOB;
        vCheckImgReq        NUMBER;
        l_response_status   NUMBER;
        vSuccessMsg         VARCHAR2 (1024);
        vErrMsg             VARCHAR2 (1024);
        vErrFlag            VARCHAR2 (10);
        vCustNo             VARCHAR2 (100);
        vParamValue         VARCHAR2 (32000);
        vTaskId             VARCHAR2 (1000);
        vMyException        EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        SELECT COUNT (LOG_ID)
          INTO vCheckImgReq
          FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
         WHERE RECORD_IDENTIFIER = pRecordIdentifier;

        BEGIN
            SELECT TO_CHAR (TASK_ID)
              INTO vTaskId
              FROM APEX_TASK_PARAMETERS
             WHERE     PARAM_STATIC_ID = 'RECORD_IDENTIFIER'
                   AND PARAM_VALUE = pRecordIdentifier;               ----8468

            SELECT PARAM_VALUE
              INTO vParamValue
              FROM APEX_TASK_PARAMETERS
             WHERE     TASK_ID = vTaskId
                   AND PARAM_STATIC_ID IN ('UPDATE_INFO', 'INCLUDE_INFO');
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                vParamValue := NULL;
            WHEN OTHERS
            THEN
                vParamValue := NULL;
        END;

        IF vParamValue IS NOT NULL
        THEN
            vUrl :=
                   vUrl
                || '/psb/psbcore/coresrc/change_auth/REQUEST_INCLUDE_APPROVAL';
            vRequest :=
                   '{"precidentifier":"'
                || pRecordIdentifier
                || '","prunuser":"'
                || pRunUser
                || '"}';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    pErrorFlag := 'Core API Calling Problem';
                    RAISE vMyException;
            END;


            apex_json.parse (vResponse);
            pErrorFlag := apex_json.get_varchar2 ('perrorflag');
            pErrorMessage := apex_json.get_varchar2 ('perrormessage');

            IF NVL (pErrorFlag, 'N') = 'Y'
            THEN
                RAISE vMyException;
            END IF;
        END IF;

        -----------------------
        IF vCheckImgReq > 0
        THEN
            FOR req_log
                IN (SELECT r1.RECORD_IDENTIFIER,
                           r1.TABLE_NAME,
                           CASE
                               WHEN r1.KEY_COL_NAME = 'CUST_NO' --PK of CUST_DOC
                               THEN
                                   KEY_COL_VALUE
                               ELSE
                                   NULL
                           END
                               CUST_NO,
                           CASE
                               WHEN r1.KEY_COL_NAME = 'NOMINEE_ID' --PK of NOMINEE_IMG
                               THEN
                                   KEY_COL_VALUE
                               ELSE
                                   NULL
                           END
                               NOMINEE_ID,
                           CASE
                               WHEN r1.KEY_COL_NAME2 = 'DOCUMENT_ID' -- PK of CUST_DOC
                               THEN
                                   KEY_COL_VALUE2
                               ELSE
                                   NULL
                           END
                               DOCUMENT_ID,
                           CASE
                               WHEN r1.KEY_COL_NAME = 'AC_ID' --PK of ACCOUNT_SIGNATURE_CARD
                               THEN
                                   KEY_COL_VALUE
                               ELSE
                                   NULL
                           END
                               AC_ID,
                           b.DOC_FRONT,
                           f.DOC_BACK,
                           i.CUST_IMAGE,
                           r1.CREATE_BY,
                           UPDATE_FLAG
                      FROM (SELECT DISTINCT RECORD_IDENTIFIER,
                                            TABLE_NAME,
                                            KEY_COL_NAME,
                                            KEY_COL_VALUE,
                                            KEY_COL_NAME2,
                                            KEY_COL_VALUE2,
                                            CREATE_BY,
                                            UPDATE_FLAG
                              FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                             WHERE RECORD_IDENTIFIER = pRecordIdentifier) r1
                           LEFT JOIN
                           (SELECT RECORD_IDENTIFIER,
                                   TABLE_NAME,
                                   KEY_COL_NAME,
                                   NEW_VAL_BLOB AS DOC_FRONT
                              FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                             WHERE COL_NAME IN
                                       ('DOC_FRONT_IMAGE', 'DOC_FRONT_IMG')) --1 for customer document, 2 for nominee document
                           b
                               ON     r1.RECORD_IDENTIFIER =
                                      b.RECORD_IDENTIFIER
                                  AND r1.TABLE_NAME = b.TABLE_NAME
                                  AND r1.KEY_COL_NAME = b.KEY_COL_NAME
                           LEFT JOIN
                           (SELECT RECORD_IDENTIFIER,
                                   TABLE_NAME,
                                   KEY_COL_NAME,
                                   NEW_VAL_BLOB AS DOC_BACK
                              FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                             WHERE COL_NAME IN
                                       ('DOC_BACK_IMAGE', 'DOC_BACK_IMG')) f --1 for customer document, 2 for nominee document
                               ON     r1.RECORD_IDENTIFIER =
                                      f.RECORD_IDENTIFIER
                                  AND r1.TABLE_NAME = f.TABLE_NAME
                                  AND r1.KEY_COL_NAME = f.KEY_COL_NAME
                           LEFT JOIN
                           (SELECT RECORD_IDENTIFIER,
                                   TABLE_NAME,
                                   KEY_COL_NAME,
                                   NEW_VAL_BLOB AS CUST_IMAGE
                              FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                             WHERE COL_NAME IN
                                       ('CUST_IMAGE',
                                        'NOMINEE_IMG',
                                        'CARD_IMG')) --1 for customer image, 2 for nominee image,3 for CASA ac signature
                                                     i
                               ON     r1.RECORD_IDENTIFIER =
                                      i.RECORD_IDENTIFIER
                                  AND r1.TABLE_NAME = i.TABLE_NAME
                                  AND r1.KEY_COL_NAME = i.KEY_COL_NAME)
            LOOP
                IF req_log.TABLE_NAME = 'CUST_DOC'
                THEN
                    BEGIN
                        SELECT APP_LINK_LOCAL INTO vURL FROM GUMS.MB_GLOBAL_RULE;

                        vURL := vURL || '/psb/psbimg/imgsrc/insCustomerdoc/';
                        vRequest :=
                               '{
                 "pdocumentid": "'
                            || req_log.DOCUMENT_ID
                            || '",
                 "pdmltype":"I",
                 "pcreateby": "'
                            || req_log.CREATE_BY
                            || '",
                 "pcustno": "'
                            || req_log.CUST_NO
                            || '",
                 "pdocfrontimage": "'
                            || apex_web_service.blob2clobbase64 (
                                   p_blob       => req_log.DOC_FRONT,
                                   p_newlines   => 'N')
                            || '",
                 "pdocbackimage": "'
                            || apex_web_service.blob2clobbase64 (
                                   p_blob       => req_log.DOC_BACK,
                                   p_newlines   => 'N')
                            || '"
              }';

                        BEGIN
                            APEX_WEB_SERVICE.g_request_headers (1).name :=
                                'Content-Type';
                            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                                'application/json';
                            vResponse :=
                                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                                    p_url                => vUrl,
                                    p_http_method        => 'POST',
                                    p_body               => vRequest,
                                    p_transfer_timeout   => 30);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                pErrorFlag := 'Memimage Api Calling Problem';
                                RAISE vMyException;
                        END;


                        -- Process the response
                        BEGIN
                            l_response_status :=
                                APEX_WEB_SERVICE.g_status_code;

                            SELECT psuccessmessage, perrormessage, perrorflag
                              INTO vSuccessMsg, vErrMsg, vErrFlag
                              FROM JSON_TABLE (
                                       vResponse, '$'
                                       COLUMNS (psuccessmessage VARCHAR2 (1024)
                                                    PATH '$.psuccessmessage',
                                                perrormessage VARCHAR2 (1024)
                                                    PATH '$.perrormessage',
                                                perrorflag VARCHAR2 (10)
                                                    PATH '$.perrorflag'));

                            IF NVL (vErrFlag, 'N') = 'Y'
                            THEN
                                perrormessage :=
                                       'HTTP Request Failed with status code: '
                                    || l_response_status
                                    || vErrMsg;
                                RAISE vMyException;
                            END IF;
                        END;

                        IF l_response_status = 200
                        THEN
                            DELETE FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                                  WHERE RECORD_IDENTIFIER = pRecordIdentifier;
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            pErrorMessage :=
                                   'Customer Documents Sending Problem'
                                || pErrorMessage
                                || vCustNo;
                            RAISE vMyException;
                    END customer_document_api_request_end;
                END IF;

                ---Send Member image api---
                IF req_log.TABLE_NAME = 'MEMBER_IMAGE'
                THEN
                    SELECT APP_LINK_LOCAL INTO vURL FROM GUMS.MB_GLOBAL_RULE;

                    vURL := vURL || '/psb/psbimg/imgsrc/insCustomerImg/';

                    BEGIN
                        vRequest :=
                               '{
                 "pcustno": "'
                            || req_log.CUST_NO
                            || '",
                 "pcreateby": "'
                            || req_log.CREATE_BY
                            || '",
                 "pcreatedate": "'
                            || TO_CHAR (SYSDATE, 'DD-MON-YYYY')
                            || '",
                 "pimgname": "'
                            || req_log.CUST_NO
                            || '",
                 "pcusimg": "'
                            || apex_web_service.blob2clobbase64 (
                                   p_blob       => req_log.CUST_IMAGE,
                                   p_newlines   => 'N')
                            || '",
                 "pdmltype": "I"
              }';

                        BEGIN
                            APEX_WEB_SERVICE.g_request_headers (1).name :=
                                'Content-Type';
                            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                                'application/json';
                            vResponse :=
                                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                                    p_url                => vUrl,
                                    p_http_method        => 'POST',
                                    p_body               => vRequest,
                                    p_transfer_timeout   => 30);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                pErrorFlag := 'Memimage Api Calling Problem';
                                RAISE vMyException;
                        END;

                        -- Process the response
                        BEGIN
                            l_response_status :=
                                APEX_WEB_SERVICE.g_status_code;

                            SELECT psuccessmessage, perrormessage, perrorflag
                              INTO vSuccessMsg, vErrMsg, vErrFlag
                              FROM JSON_TABLE (
                                       vResponse, '$'
                                       COLUMNS (psuccessmessage VARCHAR2 (1024)
                                                    PATH '$.psuccessmessage',
                                                perrormessage VARCHAR2 (1024)
                                                    PATH '$.perrormessage',
                                                perrorflag VARCHAR2 (10)
                                                    PATH '$.perrorflag'));

                            IF NVL (vErrFlag, 'N') = 'Y'
                            THEN
                                perrormessage :=
                                       'HTTP Request Failed with status code: '
                                    || l_response_status
                                    || vErrMsg;
                                RAISE vMyException;
                            END IF;
                        END block_parsing_of_response;

                        IF l_response_status = 200
                        THEN
                            DELETE FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                                  WHERE RECORD_IDENTIFIER = pRecordIdentifier;
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            pErrorMessage :=
                                   'Customer Documents Sending Problem'
                                || pErrorMessage
                                || vCustNo;
                            RAISE vMyException;
                    END request_customer_image_api;
                END IF;

                --Nominee Image Add Request , Added by Foisal
                IF req_log.TABLE_NAME = 'NOMINEE_IMAGE'
                THEN
                    BEGIN
                        GUMS.PRC_CASA_NOMINEE_ADD (
                            pNomineeId =>
                                req_log.NOMINEE_ID,
                            pNomImg =>
                                apex_web_service.blob2clobbase64 (
                                    p_blob       => req_log.CUST_IMAGE,
                                    p_newlines   => 'N'),
                            pDocFrontImg =>
                                apex_web_service.blob2clobbase64 (
                                    p_blob       => req_log.DOC_FRONT,
                                    p_newlines   => 'N'),
                            pDocBackImg =>
                                apex_web_service.blob2clobbase64 (
                                    p_blob       => req_log.DOC_BACK,
                                    p_newlines   => 'N'),
                            pCreateBy =>
                                req_log.CREATE_BY,
                            pErrorFlag =>
                                vErrFlag,
                            pErrorMessage =>
                                vErrMsg);
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            perrormessage :=
                                'Nominee Image Sending Problem.' || SQLERRM;
                            RAISE vMyException;
                    END Nominee;

                    IF NVL (vErrFlag, 'N') != 'Y'
                    THEN
                        DELETE FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                              WHERE RECORD_IDENTIFIER = pRecordIdentifier;
                    ELSIF NVL (vErrFlag, 'N') = 'Y'
                    THEN
                        perrormessage := vErrMsg;
                        RAISE vMyException;
                    END IF;
                END IF;

                ------------------Singnature image add request, added by Foisal Mahmud
                IF req_log.TABLE_NAME = 'ACCOUNT_SIGNATURE_CARD'
                THEN
                    SELECT APP_LINK_LOCAL INTO vURL FROM GUMS.MB_GLOBAL_RULE;

                    vURL := vURL || '/psb/psbimg/imgsrc/sign_card/';

                    BEGIN
                        vRequest :=
                               '{
                 "pacid": "'
                            || req_log.AC_ID
                            || '",
                 "pcreateby": "'
                            || req_log.CREATE_BY
                            || '",
                 "pcreatedate": "'
                            || TO_CHAR (SYSDATE, 'DD-MON-YYYY')
                            || '",
                 "pcardimg": "'
                            || apex_web_service.blob2clobbase64 (
                                   p_blob       => req_log.CUST_IMAGE, ---singnature card , get from req loop
                                   p_newlines   => 'N')
                            || '",
                 "pdmltype": "I"
              }';

                        BEGIN
                            APEX_WEB_SERVICE.g_request_headers (1).name :=
                                'Content-Type';
                            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                                'application/json';
                            vResponse :=
                                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                                    p_url                => vUrl,
                                    p_http_method        => 'POST',
                                    p_body               => vRequest,
                                    p_transfer_timeout   => 30);
                        EXCEPTION
                            WHEN OTHERS
                            THEN
                                pErrorFlag := 'Sign-Card Api Calling Problem';
                                RAISE vMyException;
                        END;

                        -- Process the response
                        BEGIN
                            l_response_status :=
                                APEX_WEB_SERVICE.g_status_code;

                            SELECT psuccessmessage, perrormessage, perrorflag
                              INTO vSuccessMsg, vErrMsg, vErrFlag
                              FROM JSON_TABLE (
                                       vResponse, '$'
                                       COLUMNS (psuccessmessage VARCHAR2 (1024)
                                                    PATH '$.psuccessmessage',
                                                perrormessage VARCHAR2 (1024)
                                                    PATH '$.perrormessage',
                                                perrorflag VARCHAR2 (10)
                                                    PATH '$.perrorflag'));

                            IF NVL (vErrFlag, 'N') = 'Y'
                            THEN
                                perrormessage :=
                                       'HTTP Request Failed with status code: '
                                    || l_response_status
                                    || vErrMsg;
                                RAISE vMyException;
                            END IF;
                        END block_parsing_of_response;

                        IF l_response_status = 200
                        THEN
                            DELETE FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                                  WHERE RECORD_IDENTIFIER = pRecordIdentifier;
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            pErrorMessage :=
                                   'Signature Card Sending Problem.'
                                || pErrorMessage;
                            RAISE vMyException;
                    END request_signature_card_image_api;
                END IF;
            END LOOP req_log;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE GET_GLAC_CODE (pParentId           NUMBER,
                             pParentChild        VARCHAR2,
                             pParentGlCode       VARCHAR2,
                             pDisplaySl      OUT NUMBER,
                             pLevelCode      OUT NUMBER,
                             pGlAcCode       OUT VARCHAR2,
                             pErrorFlag      OUT VARCHAR2,
                             pErrorMessage   OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl := vUrl || '/psb/psbcore/coresrc/pkg_gl_ac_setup/PRC_GL_AC_SET';

        vRequest :=
               '{
    "pparentid": "'
            || pParentId
            || '",
    "pparentchild": "'
            || pParentChild
            || '",
    "pparentglaccode": "'
            || pParentGlCode
            || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pDisplaySl := apex_json.get_varchar2 ('pdisplaysl');
        pLevelCode := apex_json.get_varchar2 ('plevel');
        pGlAcCode := apex_json.get_varchar2 ('pglaccode');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE GET_HOLIDAY_ID (pBranchCode         NUMBER,
                              pDate               DATE,
                              pHolidayDesc    OUT NUMBER,
                              pHolidayId      OUT NUMBER,
                              pActiveFlag     OUT VARCHAR2,
                              pErrorFlag      OUT VARCHAR2,
                              pErrorMessage   OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
            vUrl || '/psb/psbcore/coresrc/pkg_holiday_id/PRC_HOLIDAY_ID_SET';

        vRequest := '{
    "pbranchcode": "' || pBranchCode || '",
    "pdate": "' || pDate || '"
}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Core API Calling Problem';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pHolidayDesc := apex_json.get_varchar2 ('pholidaydesc');
        pHolidayId := apex_json.get_varchar2 ('pholidayid');
        pActiveFlag := apex_json.get_varchar2 ('pactiveflag');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE CUSTOMER_REVIEW_REQUEST_API (pRequestID           PLS_INTEGER,
                                           pReviewStatius       VARCHAR2,
                                           pAppUser             VARCHAR2,
                                           pRemarks             VARCHAR2,
                                           pMemberCode      OUT VARCHAR2, --add by nasir
                                           pErrorflag       OUT VARCHAR2,
                                           pErrorMsg        OUT VARCHAR2,
                                           pSuccessMsg      OUT VARCHAR2)
    IS
        vUrl             VARCHAR2 (1024);
        l_request_body   CLOB;
        l_response       CLOB;
        vMyException     EXCEPTION;
        vErrorFlag       VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        IF pRequestID IS NULL
        THEN
            pErrorMsg := 'Customer Request ID not found.';
            RAISE vMyException;
        END IF;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/CustomerCreation/PRC_CUSTOMER_REVIEW';



        BEGIN
            -- Set the request body with your parameter values
            l_request_body :=
                   '{
    "prequestid":"'
                || pRequestID
                || '",
    "previewstatus":"'
                || pReviewStatius
                || '",
    "premarks":"'
                || pRemarks
                || '",
    "pappuser":"'
                || pAppUser
                || '"}';

            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            l_response :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => l_request_body,
                    p_transfer_timeout   => 180);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMsg := 'Image sending request failed';
                RAISE vMyException;
        END;

        apex_json.parse (l_response);
        vErrorMessage := apex_json.get_varchar2 ('perrormsg');
        vErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pSuccessMsg := apex_json.get_varchar2 ('psuccessmsg');
        pMemberCode := apex_json.get_varchar2 ('pmembercode');

        IF NVL (vErrorFlag, 'N') = 'Y'
        THEN
            pErrorMsg := vErrorMessage;
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END CUSTOMER_REVIEW_REQUEST_API;

    PROCEDURE REQUEST_INCLUDE_LOG (pInJson              CLOB,
                                   pRecIdentifier   OUT NUMBER,
                                   pOutData         OUT CLOB,
                                   pErrorFlag       OUT VARCHAR2,
                                   pErrorMsg        OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
            vUrl || '/psb/psbcore/coresrc/change_auth/REQUEST_INCLUDE_LOG';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => pInJson,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMsg := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMsg := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pRecIdentifier := apex_json.get_varchar2 ('precidentifier');
        pOutData := apex_json.get_varchar2 ('pretdata');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE PRODUCT_APPROVAL (pRequestId            NUMBER,
                                pApprovalStatus       VARCHAR2,
                                pRunUser              VARCHAR2,
                                pErrorMsg         OUT VARCHAR2,
                                pErrorFlag        OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/config_product/PRC_PRODUCT_CREATION_APPROVAL';

        vRequest :=
            '{
    "prequestid":' || pRequestId || ',
    "prequesttype": "' || pApprovalStatus || '",
    "prunuser": "' || pRunUser || '"
}';


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMsg := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMsg := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE CASA_NOMINEE_ADD (pNomineeId      IN     NUMBER,
                                pNomImg         IN     CLOB,
                                pDocFrontImg    IN     CLOB,
                                pDocBackImg     IN     CLOB,
                                pcreateby       IN     VARCHAR2,
                                pErrorFlag         OUT VARCHAR2,
                                pErrorMessage      OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || 'http://10.11.204.213:8080/psb/psbimg/imgsrc/add_nominee/';

        vRequest :=
               '{
   "pnomineeid":"'
            || pNomineeId
            || '",
   "pnomimg":"'
            || pNomImg
            || '",
   "pdocfrontimg":"'
            || pDocFrontImg
            || '",
   "pdocbackimg":"'
            || pDocBackImg
            || '",
   "pcreateby":"'
            || pcreateby
            || '"  
}';



        COMMIT;

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Nominee Send API Calling Problem -';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('pErrorMessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE PRC_TAX_RETURN_REQUEST (pBranchCode          VARCHAR2,
                                      pAcNo                VARCHAR2,
                                      pCustNo              NUMBER,
                                      pACId                NUMBER,
                                      pDocfrontimage       CLOB,
                                      pDocbackimage        CLOB,
                                      pAssesyear           VARCHAR2,
                                      pTin                 VARCHAR2,
                                      pCircle              VARCHAR2,
                                      pTaxzone             VARCHAR2,
                                      pSerialno            VARCHAR2,
                                      pSubmitdate          DATE,
                                      pStatus              VARCHAR2,
                                      pAiUserId            VARCHAR2,
                                      pErrorFlag       OUT VARCHAR2,
                                      pErrorMessage    OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/pkg_tax_return/PRC_TAX_RETURN_REQUEST';

        SELECT json_object ('pbranchcode' VALUE pBranchCode,
                            'pacno' VALUE pAcNo,
                            'pcustno' VALUE pCustNo,
                            'pacid' VALUE pACId,
                            'pdocfrontimage' VALUE pDocfrontimage,
                            'pdocbackimage' VALUE pDocbackimage,
                            'passesyear' VALUE pAssesyear,
                            'ptin' VALUE pTin,
                            'pcircle' VALUE pCircle,
                            'ptaxzone' VALUE pTaxzone,
                            'pserialno' VALUE pSerialno,
                            'psubmitdate' VALUE pSubmitdate,
                            'pstatus' VALUE pStatus,
                            'paiuserid' VALUE pAiUserId RETURNING CLOB)
          INTO vRequest
          FROM DUAL;

        /* vRequest :=
             '{"pbranchcode":"'||pBranchCode||'","pacno":"'||pAcNo||'","pcustno":"'||pCustNo||'","pacid":"'||pACId||'","pdocfrontimage":"'||pDocfrontimage||'","pdocbackimage":"'||pDocbackimage||'","passesyear":"'||pAssesyear||'","ptin":"'||pTin||'","pcircle":"'||pCircle||'","ptaxzone":"'||pTaxzone||'","pserialno":"'||pSerialno||'","psubmitdate":"'||TO_DATE(pSubmitdate)||'","pstatus":"'||pStatus||'","paiuserid":"'||pAiUserId||'"}';*/


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Nominee Send API Calling Problem -';
                RAISE vMyException;
        END;


        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;
END;
/


DROP PACKAGE BODY GUMS.CORE_BANK_API_CONSUME_IMG;

CREATE OR REPLACE PACKAGE BODY GUMS.CORE_BANK_API_CONSUME_IMG
IS
    PROCEDURE REQUEST_CHANGE_LOG (pInJson               CLOB,
                                  pColList              DB_OLD_BLOB,
                                  pRunUser              VARCHAR2,
                                  pTableName            VARCHAR2,
                                  pKeyCol               VARCHAR2,
                                  pSchemaName           VARCHAR2,
                                  pKeyColvalue          VARCHAR2,
                                  pSessionId            VARCHAR2,
                                  pPageId               NUMBER,
                                  pBranchCode           VARCHAR2,
                                  pRequestPurpose       VARCHAR2,
                                  pRequestStatus        VARCHAR2,
                                  pKeyCol2              VARCHAR2,
                                  pKeyColValue2         VARCHAR2,
                                  pRecIdentifier    OUT NUMBER,
                                  pOutData          OUT CLOB,
                                  pErrorFlag        OUT VARCHAR2,
                                  pErrorMsg         OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;


        vUrl := vUrl || '/psb/psbcore/coresrc/change_auth/REQUEST_CHANGE_LOG';



        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => pInJson,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMsg := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMsg := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pRecIdentifier := apex_json.get_varchar2 ('precidentifier');
        pOutData := apex_json.get_varchar2 ('pretdata');

        -----
        FOR i IN 1 .. pColList.COUNT
        LOOP
            IF pColList (i).DB_COL_VALUE IS NOT NULL
            THEN
                BEGIN
                    INSERT INTO GUMS.MB_IMG_REQUEST_CHANGE_LOG (
                                    LOG_ID,
                                    TABLE_NAME,
                                    COL_NAME,
                                    NEW_VAL_blob,
                                    OLD_VAL_blob,
                                    STATUS,
                                    REQUEST_PURPOSE,
                                    REQUEST_PAGE_ID,
                                    REQUEST_FOR,
                                    SESSION_ID,
                                    RECORD_IDENTIFIER,
                                    SCHEMA_NAME,
                                    APP_ID,
                                    KEY_COL_NAME,
                                    KEY_COL_VALUE,
                                    CREATE_BY,
                                    CREATE_DATE,
                                    branch_code,
                                    KEY_COL_NAME2,
                                    KEY_COL_VALUE2)
                         VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                                 pTableName,
                                 pColList (i).DB_COL_NAME,
                                 pColList (i).DB_COL_VALUE,
                                 NULL,
                                 pRequestStatus,
                                 pRequestPurpose,
                                 pPageId,
                                 'U',
                                 pSessionId,
                                 pRecIdentifier,
                                 pSchemaName,
                                 102,
                                 pKeyCol,
                                 pKeyColValue,
                                 pRunUser,
                                 SYSDATE,
                                 pBranchCode,
                                 pKeyCol2,
                                 pKeyColValue2);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMsg :=
                            'MB_Request_Change_LOG insert problem' || SQLERRM;
                        RAISE vMyException;
                END INSERT_REQUEST_CHANGE_LOG;
            END IF;
        END LOOP BLOB_IMAGE_LOOP;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;



    PROCEDURE REQUEST_INCLUDE_LOG (pInJson               CLOB,
                                   pColList              DB_OLD_BLOB,
                                   pRunUser              VARCHAR2,
                                   pTableName            VARCHAR2,
                                   pKeyCol               VARCHAR2,
                                   pSchemaName           VARCHAR2,
                                   pKeyColvalue          VARCHAR2,
                                   pSessionId            VARCHAR2,
                                   pPageId               NUMBER,
                                   pBranchCode           VARCHAR2,
                                   pRequestPurpose       VARCHAR2,
                                   pRequestStatus        VARCHAR2,
                                   pKeyCol2              VARCHAR2,
                                   pKeyColValue2         VARCHAR2,
                                   pRecIdentifier    OUT NUMBER,
                                   pOutData          OUT CLOB,
                                   pErrorFlag        OUT VARCHAR2,
                                   pErrorMsg         OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
            vUrl || '/psb/psbcore/coresrc/change_auth/REQUEST_INCLUDE_LOG';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => pInJson,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMsg := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        pErrorMsg := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pRecIdentifier := apex_json.get_varchar2 ('precidentifier');
        pOutData := apex_json.get_varchar2 ('pretdata');

        ------------------Image insert in Request Log---------
        FOR i IN 1 .. pColList.COUNT
        LOOP
            IF pColList (i).DB_COL_VALUE IS NOT NULL
            THEN
                BEGIN
                    INSERT INTO GUMS.MB_IMG_REQUEST_CHANGE_LOG (
                                    LOG_ID,
                                    TABLE_NAME,
                                    COL_NAME,
                                    NEW_VAL_blob,
                                    OLD_VAL_blob,
                                    STATUS,
                                    REQUEST_PURPOSE,
                                    REQUEST_PAGE_ID,
                                    REQUEST_FOR,
                                    SESSION_ID,
                                    RECORD_IDENTIFIER,
                                    SCHEMA_NAME,
                                    APP_ID,
                                    KEY_COL_NAME,
                                    KEY_COL_VALUE,
                                    CREATE_BY,
                                    CREATE_DATE,
                                    branch_code,
                                    KEY_COL_NAME2,
                                    KEY_COL_VALUE2)
                         VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                                 pTableName,
                                 pColList (i).DB_COL_NAME,
                                 pColList (i).DB_COL_VALUE,
                                 NULL,
                                 pRequestStatus,
                                 pRequestPurpose,
                                 pPageId,
                                 'I',
                                 pSessionId,
                                 pRecIdentifier,
                                 pSchemaName,
                                 102,
                                 pKeyCol,
                                 pKeyColValue,
                                 pRunUser,
                                 SYSDATE,
                                 pBranchCode,
                                 pKeyCol2,
                                 pKeyColValue2);
                EXCEPTION
                    WHEN VALUE_ERROR
                    THEN
                        pErrorMsg :=
                               'Check value Which are null or not found-'
                            || pRecIdentifier;
                        RAISE vMyException;
                    WHEN OTHERS
                    THEN
                        pErrorMsg := 'MB_REQUEST_CHANGE_LOG insert problem';
                        RAISE vMyException;
                END INSERT_REQUEST_CHANGE_LOG;
            END IF;
        END LOOP;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;
END;
/


DROP PACKAGE BODY GUMS.CORE_TRANSACTION;

CREATE OR REPLACE PACKAGE BODY GUMS.CORE_TRANSACTION
IS
    PROCEDURE GET_AC_INFO_DEPOSIT (pAcNo                   VARCHAR2,
                                   pBranchCode             VARCHAR2,
                                   pAcId               OUT NUMBER,
                                   pAcTypeId           OUT NUMBER,
                                   pCustNo             OUT NUMBER,
                                   pCustCode           OUT VARCHAR2,
                                   pAcTitle            OUT VARCHAR2,
                                   pAcBranch           OUT VARCHAR2,
                                   pAvailableBalance   OUT NUMBER,
                                   pBlockAmount        OUT NUMBER,
                                   pMobileNo           OUT VARCHAR2,
                                   pAcType             OUT VARCHAR2,
                                   pDepNature          OUT VARCHAR2,
                                   pAcStatus           OUT VARCHAR2,
                                   pErrorFlag          OUT VARCHAR2,
                                   pErrorMessage       OUT VARCHAR2)
    IS
        vMyException    EXCEPTION;
        vAcStatus       VARCHAR2 (30);
        vOnlyEmployee   VARCHAR2 (10);
        vHoBranch       VARCHAR2 (50);
        vCustBranch     VARCHAR2 (50);
    BEGIN
        pErrorFlag := 'N';

        BEGIN
            SELECT BRANCH_CODE,
                   AC_ID,
                   AC_TITLE,
                   AC_STATUS,
                   CUST_NO,
                   MEMBER_CODE,
                   MOBILE_NO,
                   AC_TYPE_ID,
                   FULL_DESC,
                   DEP_NATURE,
                   ONLY_EMPLOYEE,
                   BALANCE,
                   BLOCK_AMT,
                   CUST_BRANCH
              INTO pAcBranch,
                   pAcId,
                   pAcTitle,
                   vAcStatus,
                   pCustNo,
                   pCustCode,
                   pMobileNo,
                   pAcTypeId,
                   pAcType,
                   pDepNature,
                   vOnlyEmployee,
                   pAvailableBalance,
                   pBlockAmount,
                   vCustBranch
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                              'SELECT a.BRANCH_CODE,a.AC_ID, a.AC_TITLE, a.AC_STATUS, b.CUST_NO,''Member - ''||b.MEMBER_CODE||'' - Samitee - ''||b.SAMITEE_CODE MEMBER_CODE, b.MOBILE_NO, b.BRANCH_CODE CUST_BRANCH,c.AC_TYPE_ID, c.FULL_DESC,c.DEP_NATURE, c.ONLY_EMPLOYEE, (d.CUR_BAL + d.SHADOW_CR) - (d.BLOCK_AMT + d.SHADOW_DR) BALANCE, d.BLOCK_AMT
FROM EMOB.MB_ACCOUNT_MST a, EMOB.MB_CUSTOMER_MST b, EMOB.MB_PRODUCT_MST c, EMOB.MB_ACCOUNT_BALANCE d WHERE a.AC_NO = '''
                           || pAcNo
                           || ''' AND c.DEP_NATURE IN (''R'',''C'') AND a.CUST_NO = b.CUST_NO AND a.AC_TYPE_ID = c.AC_TYPE_ID AND a.AC_ID = d.AC_ID'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (
                           BRANCH_CODE VARCHAR2 PATH '$.branch_code',
                           AC_ID VARCHAR2 PATH '$.ac_id',
                           AC_TITLE VARCHAR2 PATH '$.ac_title',
                           AC_STATUS VARCHAR2 PATH '$.ac_status',
                           CUST_NO NUMBER PATH '$.cust_no',
                           MEMBER_CODE VARCHAR2 PATH '$.member_code',
                           MOBILE_NO VARCHAR2 PATH '$.mobile_no',
                           CUST_BRANCH VARCHAR2 PATH '$.cust_branch',
                           AC_TYPE_ID NUMBER PATH '$.ac_type_id',
                           FULL_DESC VARCHAR2 PATH '$.full_desc',
                           DEP_NATURE VARCHAR2 PATH '$.dep_nature',
                           ONLY_EMPLOYEE VARCHAR2 PATH '$.only_employee',
                           BALANCE NUMBER PATH '$.balance',
                           BLOCK_AMT NUMBER PATH '$.block_amt'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Invalid Deposit Account.Please check the account number and try again.' || SQLERRM;
                RAISE vMyException;
        END;

        BEGIN
            SELECT BRANCH_CODE
              INTO vHoBranch
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT BRANCH_CODE
            FROM EMOB.MB_BRANCH_MST
            WHERE LAYER_ID = 1'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (BRANCH_CODE VARCHAR2 PATH '$.branch_code'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Head Office Branch Not Found.';
                RAISE vMyException;
        END;

        IF vCustBranch <> vHoBranch           --NVL (vOnlyEmployee, 'N') = 'N'
        THEN
            IF pAcBranch != pBranchCode
            THEN
                pErrorMessage := 'This account does not belong to this branch. Please enter a valid account number.';
                RAISE vMyException;
            END IF;
        END IF;


        IF vAcStatus NOT IN ('ACT','INO','DEC','DEF','GAR')   --ADD BY NASIR REF BY FAYSAL VAI  (INO,DEC)
        THEN
            pErrorMessage :=
                'Request is not Allowed, Due to Current Account Status : ' || vAcStatus;
            RAISE vMyException;
        END IF;

        pAcStatus := vAcStatus;
    EXCEPTION
        WHEN vMyException
        THEN
            pAcBranch := NULL;
            pAcId := NULL;
            pAcTypeId := NULL;
            pAcTitle := NULL;
            vAcStatus := NULL;
            pCustNo := NULL;
            pCustCode := NULL;
            pMobileNo := NULL;
            pAcType := NULL;
            pDepNature := NULL;
            pAcStatus := NULL;
            vOnlyEmployee := NULL;
            pAvailableBalance := NULL;
            pBlockAmount := NULL;
            pErrorFlag := 'Y';
    END;

    /*PROCEDURE GET_AC_INFO_WITHDRAW (pAcNo                   VARCHAR2,
                                    pBranchCode             VARCHAR2,
                                    pCustNo             OUT NUMBER,
                                    pCustCode           OUT VARCHAR2,
                                    pAcTitle            OUT VARCHAR2,
                                    pAcBranch           OUT VARCHAR2,
                                    pAvailableBalance   OUT NUMBER,
                                    pBlockAmount        OUT NUMBER,
                                    pMobileNo           OUT VARCHAR2,
                                    pAcType             OUT VARCHAR2,
                                    pErrorFlag          OUT VARCHAR2,
                                    pErrorMessage       OUT VARCHAR2)
    IS
        vMyException    EXCEPTION;
        vAcStatus       VARCHAR2 (3);
        vAcTypeId       PLS_INTEGER;
        vOnlyEmployee   VARCHAR2 (1);
        vHoBranch       VARCHAR2 (5);
        vCustBranch     VARCHAR2 (5);
    BEGIN
        pErrorFlag := 'N';

        BEGIN
            SELECT BRANCH_CODE,
                   AC_TITLE,
                   AC_STATUS,
                   CUST_NO,
                   MEMBER_CODE,
                   MOBILE_NO,
                   CUST_BRANCH,
                   AC_TYPE_ID,
                   FULL_DESC,
                   ONLY_EMPLOYEE,
                   BALANCE,
                   BLOCK_AMT
              INTO pAcBranch,
                   pAcTitle,
                   vAcStatus,
                   pCustNo,
                   pCustCode,
                   pMobileNo,
                   vCustBranch,
                   vAcTypeId,
                   pAcType,
                   vOnlyEmployee,
                   pAvailableBalance,
                   pBlockAmount
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                              'SELECT a.BRANCH_CODE, a.AC_TITLE, a.AC_STATUS, b.CUST_NO, b.MEMBER_CODE, b.MOBILE_NO, b.BRANCH_CODE AS CUST_BRANCH, c.AC_TYPE_ID, c.FULL_DESC, c.ONLY_EMPLOYEE, (d.CUR_BAL + d.SHADOW_CR) - (d.BLOCK_AMT + d.SHADOW_DR) - NVL(l.lien_amount, 0) AS BALANCE, d.BLOCK_AMT
    FROM EMOB.MB_ACCOUNT_MST a
    JOIN EMOB.MB_CUSTOMER_MST b ON a.CUST_NO = b.CUST_NO
    JOIN EMOB.MB_PRODUCT_MST c ON a.AC_TYPE_ID = c.AC_TYPE_ID
    JOIN EMOB.MB_ACCOUNT_BALANCE d ON a.AC_ID = d.AC_ID
    LEFT JOIN EMOB.MB_LOAN_LIEN l ON l.dep_ac_id = a.ac_id AND l.status = ''A'' AND l.lien_status = ''L''
    WHERE a.AC_NO = '
                           || pAcNo
                           || ' AND a.ac_status = ''ACT'' AND c.DEP_NATURE = ''R'''),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (BRANCH_CODE VARCHAR2 (5) PATH '$.branch_code',
                                AC_TITLE VARCHAR2 (100) PATH '$.ac_title',
                                AC_STATUS VARCHAR2 (1) PATH '$.ac_status',
                                CUST_NO NUMBER PATH '$.cust_no',
                                MEMBER_CODE VARCHAR2 (20) PATH '$.member_code',
                                MOBILE_NO VARCHAR2 (11) PATH '$.mobile_no',
                                CUST_BRANCH VARCHAR2 (5) PATH '$.cust_branch',
                                AC_TYPE_ID NUMBER PATH '$.ac_type_id',
                                FULL_DESC VARCHAR2 (200) PATH '$.full_desc',
                                ONLY_EMPLOYEE VARCHAR2 (1) PATH '$.only_employee',
                                BALANCE NUMBER PATH '$.balance',
                                BLOCK_AMT NUMBER PATH '$.block_amt'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Invalid Regular Account Number.';
                RAISE vMyException;
        END;

        BEGIN
            SELECT BRANCH_CODE
              INTO vHoBranch
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT BRANCH_CODE
                FROM EMOB.MB_BRANCH_MST
                WHERE LAYER_ID = 1'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (BRANCH_CODE VARCHAR2 (5) PATH '$.branch_code'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Head Office Branch Not Found.';
                RAISE vMyException;
        END;

        IF vCustBranch <> vHoBranch               --NVL (vOnlyEmployee, 'N') = 'N'
        THEN
            IF pAcBranch != pBranchCode
            THEN
                pErrorMessage := 'Access Deny For This Account.';
                RAISE vMyException;
            END IF;
        END IF;

        IF vAcStatus NOT IN ('ACT', 'INO')
        THEN
            pErrorMessage :=
                'Account Is Not Active. Current Status: ' || vAcStatus;
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pAcBranch := NULL;
            pAcTitle := NULL;
            vAcStatus := NULL;
            pCustNo := NULL;
            pCustCode := NULL;
            pMobileNo := NULL;
            vAcTypeId := NULL;
            pAcType := NULL;
            vOnlyEmployee := NULL;
            pAvailableBalance := NULL;
            pBlockAmount := NULL;
            pErrorFlag := 'Y';
    END;
    */
    PROCEDURE GET_AC_INFO_WITHDRAW (pAcNo                   VARCHAR2,
                                    pBranchCode             VARCHAR2,
                                    pCustNo             OUT NUMBER,
                                    pCustCode           OUT VARCHAR2,
                                    pAcTitle            OUT VARCHAR2,
                                    pAcBranch           OUT VARCHAR2,
                                    pAvailableBalance   OUT NUMBER,
                                    pBlockAmount        OUT NUMBER,
                                    pMobileNo           OUT VARCHAR2,
                                    pAcType             OUT VARCHAR2,
                                    pErrorFlag          OUT VARCHAR2,
                                    pErrorMessage       OUT VARCHAR2)
    IS
        vMyException    EXCEPTION;
        vAcStatus       VARCHAR2 (3);
        vAcTypeId       PLS_INTEGER;
        vOnlyEmployee   VARCHAR2 (1);
        vHoBranch       VARCHAR2 (5);
        vCustBranch     VARCHAR2 (5);
        vSamiteeCat     NUMBER := 0;
    BEGIN
        pErrorFlag := 'N';

        BEGIN
            SELECT NVL (SUM (CNT), 0)
              INTO vSamiteeCat
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT COUNT(*) CNT
                      FROM EMOB.MB_ACCOUNT_MST a
                           JOIN EMOB.MB_CUSTOMER_MST b
                               ON a.CUST_NO = b.CUST_NO
                           JOIN EMOB.MB_SAMITEE_INFO e
                               ON b.SAMITEE_CODE = e.SAMITEE_CODE
                     WHERE a.AC_NO = ' || pAcNo || '
                       AND e.SAMITEE_CATEGORY = ''U'''),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (CNT NUMBER PATH '$.cnt'));
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                vSamiteeCat := 0;
            WHEN OTHERS
            THEN
                pErrorMessage := 'Unexpected Error: ' || SQLERRM;
                RAISE vMyException;
        END;


        IF vSamiteeCat > 0
        THEN
            pErrorMessage :=
                'Unassigned Samitee account - withdrawal not allowed.';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT BRANCH_CODE,
                   AC_TITLE,
                   AC_STATUS,
                   CUST_NO,
                   MEMBER_CODE,
                   MOBILE_NO,
                   CUST_BRANCH,
                   AC_TYPE_ID,
                   FULL_DESC,
                   ONLY_EMPLOYEE,
                   BALANCE,
                   BLOCK_AMT
              INTO pAcBranch,
                   pAcTitle,
                   vAcStatus,
                   pCustNo,
                   pCustCode,
                   pMobileNo,
                   vCustBranch,
                   vAcTypeId,
                   pAcType,
                   vOnlyEmployee,
                   pAvailableBalance,
                   pBlockAmount
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                              'SELECT a.BRANCH_CODE, a.AC_TITLE, a.AC_STATUS, b.CUST_NO, ''Member - ''||b.MEMBER_CODE||'' - Samitee - ''||b.SAMITEE_CODE MEMBER_CODE, b.MOBILE_NO,b.BRANCH_CODE CUST_BRANCH, c.AC_TYPE_ID, c.FULL_DESC, c.ONLY_EMPLOYEE, (d.CUR_BAL + d.SHADOW_CR) - (d.BLOCK_AMT + d.SHADOW_DR) BALANCE, d.BLOCK_AMT
FROM EMOB.MB_ACCOUNT_MST a, EMOB.MB_CUSTOMER_MST b, EMOB.MB_PRODUCT_MST c, EMOB.MB_ACCOUNT_BALANCE d,emob.MB_SAMITEE_INFO e WHERE a.AC_NO = '
                           || pAcNo
                           || ' AND c.DEP_NATURE = ''R'' AND a.CUST_NO = b.CUST_NO AND b.SAMITEE_CODE = e.SAMITEE_CODE  AND e.SAMITEE_CATEGORY != ''U'' AND a.AC_TYPE_ID = c.AC_TYPE_ID AND a.AC_ID = d.AC_ID'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (
                           BRANCH_CODE VARCHAR2 (4) PATH '$.branch_code',
                           AC_TITLE VARCHAR2 (200) PATH '$.ac_title',
                           AC_STATUS VARCHAR2 (3) PATH '$.ac_status',
                           CUST_NO NUMBER PATH '$.cust_no',
                           MEMBER_CODE VARCHAR2 (100) PATH '$.member_code',
                           MOBILE_NO VARCHAR2 (11) PATH '$.mobile_no',
                           CUST_BRANCH VARCHAR2 (4) PATH '$.cust_branch',
                           AC_TYPE_ID NUMBER PATH '$.ac_type_id',
                           FULL_DESC VARCHAR2 (200) PATH '$.full_desc',
                           ONLY_EMPLOYEE VARCHAR2 (3) PATH '$.only_employee',
                           BALANCE NUMBER PATH '$.balance',
                           BLOCK_AMT NUMBER PATH '$.block_amt'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Invalid Regular Account Number.';
                RAISE vMyException;
        END;

        BEGIN
            SELECT BRANCH_CODE
              INTO vHoBranch
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT BRANCH_CODE
            FROM EMOB.MB_BRANCH_MST
            WHERE LAYER_ID = 1'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (BRANCH_CODE VARCHAR2 PATH '$.branch_code'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Head Office Branch Not Found.';
                RAISE vMyException;
        END;

        IF vCustBranch <> vHoBranch           --NVL (vOnlyEmployee, 'N') = 'N'
        THEN
            IF pAcBranch != pBranchCode
            THEN
                pErrorMessage := 'Access Deny For This Account.';
                RAISE vMyException;
            END IF;
        END IF;

        IF vAcStatus NOT IN ('ACT','INO','DEF')
        THEN
            pErrorMessage :=
                'Cash Withdraw is not Allowed, Due to Current Account Status: ' || vAcStatus;
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pAcBranch := NULL;
            pAcTitle := NULL;
            vAcStatus := NULL;
            pCustNo := NULL;
            pCustCode := NULL;
            pMobileNo := NULL;
            vAcTypeId := NULL;
            pAcType := NULL;
            vOnlyEmployee := NULL;
            pAvailableBalance := NULL;
            pBlockAmount := NULL;
            pErrorFlag := 'Y';
    END;


    PROCEDURE GET_AC_INFO_DEPOSIT_ALL (pAcNo                   VARCHAR2,
                                       pBranchCode             VARCHAR2,
                                       pAcId               OUT NUMBER,
                                       pAcTypeId           OUT NUMBER,
                                       pCustNo             OUT NUMBER,
                                       PCustName           OUT VARCHAR2,
                                       pCustCode           OUT VARCHAR2,
                                       pAcTitle            OUT VARCHAR2,
                                       pAcBranch           OUT VARCHAR2,
                                       pAvailableBalance   OUT NUMBER,
                                       pBlockAmount        OUT NUMBER,
                                       pMobileNo           OUT VARCHAR2,
                                       pAcType             OUT VARCHAR2,
                                       pDepNature          OUT VARCHAR2,
                                       pAcStatus           OUT VARCHAR2,
                                       pErrorFlag          OUT VARCHAR2,
                                       pErrorMessage       OUT VARCHAR2)
    IS
        vMyException    EXCEPTION;
        vAcStatus       VARCHAR2 (3);
        vOnlyEmployee   VARCHAR2 (1);
    BEGIN
        pErrorFlag := 'N';

        BEGIN
            SELECT BRANCH_CODE,
                   AC_ID,
                   AC_TITLE,
                   AC_STATUS,
                   CUST_NO,
                   CUST_NAME,
                   MEMBER_CODE,
                   MOBILE_NO,
                   AC_TYPE_ID,
                   FULL_DESC,
                   DEP_NATURE,
                   ONLY_EMPLOYEE,
                   BALANCE,
                   BLOCK_AMT
              INTO pAcBranch,
                   pAcId,
                   pAcTitle,
                   vAcStatus,
                   pCustNo,
                   PCustName,
                   pCustCode,
                   pMobileNo,
                   pAcTypeId,
                   pAcType,
                   pDepNature,
                   vOnlyEmployee,
                   pAvailableBalance,
                   pBlockAmount
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                              'SELECT a.BRANCH_CODE,a.AC_ID, a.AC_TITLE, a.AC_STATUS, b.CUST_NO, (b.FIRST_NAME||'' ''||b.LAST_NAME) CUST_NAME, b.MEMBER_CODE, b.MOBILE_NO, c.AC_TYPE_ID, c.FULL_DESC,c.DEP_NATURE, c.ONLY_EMPLOYEE, (d.CUR_BAL + d.SHADOW_CR) - (d.BLOCK_AMT + d.SHADOW_DR) BALANCE, d.BLOCK_AMT
FROM EMOB.MB_ACCOUNT_MST a, EMOB.MB_CUSTOMER_MST b, EMOB.MB_PRODUCT_MST c, EMOB.MB_ACCOUNT_BALANCE d WHERE a.AC_NO = '
                           || pAcNo
                           || ' AND a.CUST_NO = b.CUST_NO AND a.AC_TYPE_ID = c.AC_TYPE_ID AND a.AC_ID = d.AC_ID AND a.ac_type_id = d.ac_type_id'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (
                           BRANCH_CODE VARCHAR2 PATH '$.branch_code',
                           AC_ID VARCHAR2 PATH '$.ac_id',
                           AC_TITLE VARCHAR2 PATH '$.ac_title',
                           AC_STATUS VARCHAR2 PATH '$.ac_status',
                           CUST_NO NUMBER PATH '$.cust_no',
                           CUST_NAME VARCHAR2 PATH '$.cust_name',
                           MEMBER_CODE VARCHAR2 PATH '$.member_code',
                           MOBILE_NO VARCHAR2 PATH '$.mobile_no',
                           AC_TYPE_ID NUMBER PATH '$.ac_type_id',
                           FULL_DESC VARCHAR2 PATH '$.full_desc',
                           DEP_NATURE VARCHAR2 PATH '$.dep_nature',
                           ONLY_EMPLOYEE VARCHAR2 PATH '$.only_employee',
                           BALANCE NUMBER PATH '$.balance',
                           BLOCK_AMT NUMBER PATH '$.block_amt'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'Having problem to found data with this account number.';
                RAISE vMyException;
        END;

        IF NVL (vOnlyEmployee, 'N') = 'N'
        THEN
            IF pAcBranch != pBranchCode
            THEN
                pErrorMessage := 'Access Deny For This Account.';
                RAISE vMyException;
            END IF;
        END IF;

        IF vAcStatus NOT IN ('ACT',
                             'INO',
                             'DMT',
                             'MAT')
        THEN
            pErrorMessage :=
                'Account Is Not Active. Current Status: ' || vAcStatus;
            RAISE vMyException;
        END IF;

        pAcStatus := vAcStatus;
    EXCEPTION
        WHEN vMyException
        THEN
            pAcBranch := NULL;
            pAcId := NULL;
            pAcTypeId := NULL;
            pAcTitle := NULL;
            vAcStatus := NULL;
            pCustNo := NULL;
            PCustName := NULL;
            pCustCode := NULL;
            pMobileNo := NULL;
            pAcType := NULL;
            pDepNature := NULL;
            pAcStatus := NULL;
            vOnlyEmployee := NULL;
            pAvailableBalance := NULL;
            pBlockAmount := NULL;
            pErrorFlag := 'Y';
    END;


    PROCEDURE GET_AC_INFO_CASA (pAcNo                   VARCHAR2,
                                pBranchCode             VARCHAR2,
                                pAcId               OUT NUMBER,
                                pAcTypeId           OUT NUMBER,
                                pCustNo             OUT NUMBER,
                                pCustCode           OUT VARCHAR2,
                                pAcTitle            OUT VARCHAR2,
                                pAcBranch           OUT VARCHAR2,
                                pAvailableBalance   OUT NUMBER,
                                pBlockAmount        OUT NUMBER,
                                pMobileNo           OUT VARCHAR2,
                                pAcType             OUT VARCHAR2,
                                pDepNature          OUT VARCHAR2,
                                pAcStatus           OUT VARCHAR2,
                                pErrorFlag          OUT VARCHAR2,
                                pErrorMessage       OUT VARCHAR2)
    IS
        vMyException    EXCEPTION;
        vAcStatus       VARCHAR2 (3);
        vOnlyEmployee   VARCHAR2 (1);
    BEGIN
        pErrorFlag := 'N';

        BEGIN
            SELECT BRANCH_CODE,
                   AC_ID,
                   AC_TITLE,
                   AC_STATUS,
                   CUST_NO,
                   MEMBER_CODE,
                   MOBILE_NO,
                   AC_TYPE_ID,
                   FULL_DESC,
                   DEP_NATURE,
                   ONLY_EMPLOYEE,
                   BALANCE,
                   BLOCK_AMT
              INTO pAcBranch,
                   pAcId,
                   pAcTitle,
                   vAcStatus,
                   pCustNo,
                   pCustCode,
                   pMobileNo,
                   pAcTypeId,
                   pAcType,
                   pDepNature,
                   vOnlyEmployee,
                   pAvailableBalance,
                   pBlockAmount
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                              'SELECT a.BRANCH_CODE,a.AC_ID, a.AC_TITLE, a.AC_STATUS, b.CUST_NO, b.MEMBER_CODE, b.MOBILE_NO, c.AC_TYPE_ID, c.FULL_DESC,c.DEP_NATURE, c.ONLY_EMPLOYEE, (d.CUR_BAL + d.SHADOW_CR) - (d.BLOCK_AMT + d.SHADOW_DR) BALANCE, d.BLOCK_AMT
FROM EMOB.MB_ACCOUNT_MST a, EMOB.MB_CUSTOMER_MST b, EMOB.MB_PRODUCT_MST c, EMOB.MB_ACCOUNT_BALANCE d WHERE a.AC_NO = '
                           || pAcNo
                           || ' AND c.DEP_NATURE IN (''R'') AND a.CUST_NO = b.CUST_NO AND nvl(b.IS_DEAD,''N'')=''N'' AND a.AC_TYPE_ID = c.AC_TYPE_ID AND a.AC_ID = d.AC_ID AND a.ac_type_id = d.ac_type_id'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (
                           BRANCH_CODE VARCHAR2 PATH '$.branch_code',
                           AC_ID VARCHAR2 PATH '$.ac_id',
                           AC_TITLE VARCHAR2 PATH '$.ac_title',
                           AC_STATUS VARCHAR2 PATH '$.ac_status',
                           CUST_NO NUMBER PATH '$.cust_no',
                           MEMBER_CODE VARCHAR2 PATH '$.member_code',
                           MOBILE_NO VARCHAR2 PATH '$.mobile_no',
                           AC_TYPE_ID NUMBER PATH '$.ac_type_id',
                           FULL_DESC VARCHAR2 PATH '$.full_desc',
                           DEP_NATURE VARCHAR2 PATH '$.dep_nature',
                           ONLY_EMPLOYEE VARCHAR2 PATH '$.only_employee',
                           BALANCE NUMBER PATH '$.balance',
                           BLOCK_AMT NUMBER PATH '$.block_amt'));
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                pErrorMessage := 'Only Regular Accounts are allowed. Deceased Customers are not permitted here.';
                RAISE vMyException;
            WHEN OTHERS
            THEN
                pErrorMessage :=
                       'Having problem to found data with this account number.'
                    || SQLERRM;
                RAISE vMyException;
        END;

        IF NVL (vOnlyEmployee, 'N') = 'N'
        THEN
            IF pAcBranch != pBranchCode
            THEN
                pErrorMessage := 'Access Deny For This Account.';
                RAISE vMyException;
            END IF;
        END IF;

        IF vAcStatus NOT IN ('ACT', --FRZ AND BLK ADD BY NASIR UDDIN REF BY FAYSAL AND ASLAM
                             'INO',
                             'DMT',
                             'MAT',
                             'FRZ',
                             'BLK',
                             'CLS',
                             'GAR')
        THEN
            pErrorMessage :=
                'Account Is Not Active. Current Status: ' || vAcStatus;
            RAISE vMyException;
        END IF;

        pAcStatus := vAcStatus;
    EXCEPTION
        WHEN vMyException
        THEN
            pAcBranch := NULL;
            pAcId := NULL;
            pAcTypeId := NULL;
            pAcTitle := NULL;
            vAcStatus := NULL;
            pCustNo := NULL;
            pCustCode := NULL;
            pMobileNo := NULL;
            pAcType := NULL;
            pDepNature := NULL;
            pAcStatus := NULL;
            vOnlyEmployee := NULL;
            pAvailableBalance := NULL;
            pBlockAmount := NULL;
            pErrorFlag := 'Y';
    END;

    PROCEDURE GET_LINK_AC_INFO (pAcNo                   VARCHAR2,
                                pBranchCode             VARCHAR2,
                                pAcId               OUT NUMBER,
                                pAcTypeId           OUT NUMBER,
                                pCustNo             OUT NUMBER,
                                PCustName           OUT VARCHAR2,
                                pFatherName         OUT VARCHAR2,
                                pMotherName         OUT VARCHAR2,
                                pCustDob            OUT DATE,
                                pGender             OUT VARCHAR2,
                                pMemberCode         OUT VARCHAR2,
                                pAcTitle            OUT VARCHAR2,
                                pAcBranch           OUT VARCHAR2,
                                pAvailableBalance   OUT NUMBER,
                                pBlockAmount        OUT NUMBER,
                                pMobileNo           OUT VARCHAR2,
                                pAcType             OUT VARCHAR2,
                                pDepNature          OUT VARCHAR2,
                                pAcStatus           OUT VARCHAR2,
                                pLinkDbAc           OUT NUMBER,
                                pLinkCrAc           OUT NUMBER,
                                pErrorFlag          OUT VARCHAR2,
                                pErrorMessage       OUT VARCHAR2)
    IS
        vMyException    EXCEPTION;
        vAcStatus       VARCHAR2 (3);
        vOnlyEmployee   VARCHAR2 (1);
    BEGIN
        pErrorFlag := 'N';

        BEGIN
            SELECT BRANCH_CODE,                                            --1
                   AC_ID,                                                  --2
                   AC_TITLE,                                               --3
                   AC_STATUS,                                              --4
                   CUST_NO,                                                --5
                   CUST_NAME,                                              --6
                   MEMBER_CODE,                                            --7
                   MOBILE_NO,                                              --8
                   FATHER_NAME,                                            --9
                   MOTHER_NAME,                                           --10
                   CUST_DOB,                                              --11
                   GENDER,                                                --12
                   AC_TYPE_ID,                                            --13
                   FULL_DESC,                                             --14
                   DEP_NATURE,                                            --15
                   ONLY_EMPLOYEE,                                         --16
                   BALANCE,                                               --17
                   BLOCK_AMT,                                             --18
                   LNDR_ACCOUNT,                                          --19
                   LNCR_ACCOUNT                                           --20
              INTO pAcBranch,                                              --1
                   pAcId,                                                  --2
                   pAcTitle,                                               --3
                   vAcStatus,                                              --4
                   pCustNo,                                                --5
                   PCustName,                                              --6
                   pMemberCode,                                            --7
                   pMobileNo,                                              --8
                   pFatherName,                                            --9
                   pMotherName,                                           --10
                   pCustDob,                                              --11
                   pGender,                                               --12
                   pAcTypeId,                                             --13
                   pAcType,                                               --14
                   pDepNature,                                            --15
                   vOnlyEmployee,                                         --16
                   pAvailableBalance,                                     --17
                   pBlockAmount,                                          --18
                   pLinkDbAc,                                             --19
                   pLinkCrAc                                              --20
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                              'SELECT a.BRANCH_CODE,a.AC_ID, a.AC_TITLE, a.AC_STATUS, b.CUST_NO, (b.FIRST_NAME||'' ''||b.LAST_NAME) CUST_NAME, b.MEMBER_CODE, b.MOBILE_NO,b.FATHER_NAME,b.MOTHER_NAME,b.CUST_DOB,b.GENDER,c.AC_TYPE_ID, c.FULL_DESC,c.DEP_NATURE, c.ONLY_EMPLOYEE, (d.CUR_BAL + d.SHADOW_CR) - (d.BLOCK_AMT + d.SHADOW_DR) BALANCE, d.BLOCK_AMT, e.LNDR_ACCOUNT, e.LNCR_ACCOUNT
FROM EMOB.MB_ACCOUNT_MST a, EMOB.MB_CUSTOMER_MST b, EMOB.MB_PRODUCT_MST c, EMOB.MB_ACCOUNT_BALANCE d, EMOB.MB_LINKAC_MST e WHERE a.AC_NO = '
                           || pAcNo
                           || ' AND a.CUST_NO = b.CUST_NO AND a.AC_TYPE_ID = c.AC_TYPE_ID AND a.AC_ID = d.AC_ID AND a.ac_type_id = d.ac_type_id AND a.BRANCH_CODE = e.BRANCH_CODE AND a.AC_ID = e.AC_ID AND d.AC_ID = e.AC_ID AND b.BRANCH_CODE = e.BRANCH_CODE'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (
                           BRANCH_CODE VARCHAR2 PATH '$.branch_code',
                           AC_ID VARCHAR2 PATH '$.ac_id',
                           AC_TITLE VARCHAR2 PATH '$.ac_title',
                           AC_STATUS VARCHAR2 PATH '$.ac_status',
                           CUST_NO NUMBER PATH '$.cust_no',
                           CUST_NAME VARCHAR2 PATH '$.cust_name',
                           MEMBER_CODE VARCHAR2 PATH '$.member_code',
                           MOBILE_NO VARCHAR2 PATH '$.mobile_no',
                           FATHER_NAME VARCHAR2 PATH '$.father_name',
                           MOTHER_NAME VARCHAR2 PATH '$.mother_name',
                           CUST_DOB DATE PATH '$.cust_dob',
                           GENDER VARCHAR2 PATH '$.gender',
                           AC_TYPE_ID NUMBER PATH '$.ac_type_id',
                           FULL_DESC VARCHAR2 PATH '$.full_desc',
                           DEP_NATURE VARCHAR2 PATH '$.dep_nature',
                           ONLY_EMPLOYEE VARCHAR2 PATH '$.only_employee',
                           BALANCE NUMBER PATH '$.balance',
                           BLOCK_AMT NUMBER PATH '$.block_amt',
                           LNDR_ACCOUNT NUMBER PATH '$.lndr_account',
                           LNCR_ACCOUNT NUMBER PATH '$.lncr_account'));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'Having problem to found data with this account number.';
                RAISE vMyException;
        END;

        IF NVL (vOnlyEmployee, 'N') = 'N'
        THEN
            IF pAcBranch != pBranchCode
            THEN
                pErrorMessage := 'Access Deny For This Account.';
                RAISE vMyException;
            END IF;
        END IF;

        IF vAcStatus NOT IN ('ACT',
                             'INO',
                             'DMT',
                             'MAT')
        THEN
            pErrorMessage :=
                'Account Is Not Active. Current Status: ' || vAcStatus;
            RAISE vMyException;
        END IF;

        pAcStatus := vAcStatus;
    EXCEPTION
        WHEN vMyException
        THEN
            pAcBranch := NULL;
            pAcId := NULL;
            pAcTypeId := NULL;
            pAcTitle := NULL;
            vAcStatus := NULL;
            pCustNo := NULL;
            PCustName := NULL;
            pMemberCode := NULL;
            pMobileNo := NULL;
            pFatherName := NULL;
            pMotherName := NULL;
            pCustDob := NULL;
            pGender := NULL;
            pAcType := NULL;
            pDepNature := NULL;
            pAcStatus := NULL;
            vOnlyEmployee := NULL;
            pAvailableBalance := NULL;
            pBlockAmount := NULL;
            pLinkDbAc := NULL;
            pLinkCrAc := NULL;
            pErrorFlag := 'Y';
    END;
END;
/


DROP PACKAGE BODY GUMS.DPK_SECURITY;

CREATE OR REPLACE PACKAGE BODY GUMS.DPK_SECURITY
IS
    FUNCTION DFN_CREATE_PASSWORD_ENCRYPTED (userid   IN VARCHAR2,
                                            passwd   IN VARCHAR2)
        RETURN VARCHAR2
    IS
        var1      NUMBER;
        var2      NUMBER;
        mul1      NUMBER;
        mulfin    VARCHAR2 (1024);
        mullen    NUMBER;
        loopfor   NUMBER;
        stores    VARCHAR2 (1024);
        ctr       NUMBER;
        i         NUMBER;
        subs      NUMBER;
    BEGIN
        var1 := 1;
        var2 := 1;

        FOR j IN 1 .. LENGTH (userid)
        LOOP
            var1 := ASCII (SUBSTR (userid, j, 1));
            var2 := ASCII (SUBSTR (passwd, LENGTH (passwd) - j + 1, 1));
            mul1 := var1 * var2;
            mulfin := mulfin || TO_CHAR (mul1);
        END LOOP;

        mullen := NVL (LENGTH (mulfin), 0);

        IF MOD (mullen, 3) != 0
        THEN
            loopfor := (FLOOR (mullen / 3)) + 1;
        ELSE
            loopfor := (mullen / 2);
        END IF;

        ctr := 1;
        i := 1;

        LOOP
            subs := SUBSTR (mulfin, i, 2);

            IF subs NOT BETWEEN 48 AND 57
            THEN
                IF subs > 90
                THEN
                    LOOP
                        subs := subs - 26;
                        EXIT WHEN subs < 91;
                    END LOOP;
                END IF;

                IF subs < 65
                THEN
                    LOOP
                        subs := subs + 26;
                        EXIT WHEN subs > 64;
                    END LOOP;
                END IF;
            END IF;

            stores := stores || CHR (subs);
            EXIT WHEN ctr >= loopfor;
            ctr := ctr + 1;
            i := i + 3;
        END LOOP;

        RETURN (stores);
    END;

    FUNCTION DFN_PASSWORD_POLICY
        RETURN VARCHAR2
    IS
        vPassLength            NUMBER := 0;
        vPassDifference        NUMBER := 0;
        vAlphabeticChar        VARCHAR2 (1);
        vNumericChar           VARCHAR2 (1);
        vPunctuationChar       VARCHAR2 (1);
        vUpperCaseChar         VARCHAR2 (1);
        vLowerCaseChar         VARCHAR2 (1);
        vUserName              VARCHAR2 (1);
        vPunctuationCharList   VARCHAR2 (100);
        vDefaultPwExpDay       NUMBER := 0;
        vPasswordPolicy        VARCHAR2 (3000);
    BEGIN
        BEGIN
            SELECT PASS_LENGTH,
                   PASS_DIFFERENCE,
                   ALPHABETIC_CHAR,
                   NUMERIC_CHAR,
                   PUNCTUATION_CHAR,
                   UPPER_CASE_CHAR,
                   LOWER_CASE_CHAR,
                   USER_NAME,
                   PUNCTUATION_CHAR_LIST,
                   DEFAULT_PW_EXP_DAY
              INTO vPassLength,
                   vPassDifference,
                   vAlphabeticChar,
                   vNumericChar,
                   vPunctuationChar,
                   vUpperCaseChar,
                   vLowerCaseChar,
                   vUserName,
                   vPunctuationCharList,
                   vDefaultPwExpDay
              FROM GUMS.ST_PASSWORD_POLICY;
        EXCEPTION
            WHEN OTHERS
            THEN
                RETURN 'Password Policy Finding Problem';
        END;

        vPasswordPolicy :=
               '1. A strong password is one that difficult for others to determine by guessing or by using automated programs. A strong password is an important first step in protecting your personal information. '
            || 'A strong password should uses at least one upper letter(A-Z), lower letter (a-z), numeral (0 - 9) and special character (~`!@#$%[{()}]\|,;_:+*/-). ';

        IF vPassDifference > 0
        THEN
            vPasswordPolicy :=
                   vPasswordPolicy
                || CHR (10)
                || CHR (10)
                || '2. Your new password can not blank space, same as old password. It Must be Different from Previous '
                || vPassDifference
                || ' Passwords. ';
        END IF;

        IF vPassLength > 0
        THEN
            vPasswordPolicy :=
                   vPasswordPolicy
                || 'It should contain '
                || vPassLength
                || ' or more character(s). ';
        END IF;

        IF NVL (vUserName, 'N') = 'Y'
        THEN
            vPasswordPolicy := vPasswordPolicy || 'Can not same as your ID. ';
        END IF;

        IF NVL (vAlphabeticChar, 'N') = 'Y'
        THEN
            vPasswordPolicy :=
                   vPasswordPolicy
                || 'At least One Alphabetic letter (A-Z,a-z), ';
        END IF;

        IF NVL (vNumericChar, 'N') = 'Y'
        THEN
            vPasswordPolicy := vPasswordPolicy || 'numeral (0 - 9), ';
        END IF;

        IF NVL (vUpperCaseChar, 'N') = 'Y'
        THEN
            vPasswordPolicy := vPasswordPolicy || 'upper letter(A-Z), ';
        END IF;

        IF NVL (vLowerCaseChar, 'N') = 'Y'
        THEN
            vPasswordPolicy := vPasswordPolicy || 'lower letter (a-z), ';
        END IF;

        IF NVL (vPunctuationChar, 'N') = 'Y'
        THEN
            vPasswordPolicy :=
                   vPasswordPolicy
                || 'special character ('
                || vPunctuationCharList
                || '). ';
        END IF;

        vPasswordPolicy :=
               vPasswordPolicy
            || CHR (10)
            || CHR (10)
            || '3. Please keep in mind that password is case sensitive. ';

        IF vDefaultPwExpDay > 0
        THEN
            vPasswordPolicy :=
                   vPasswordPolicy
                || CHR (10)
                || CHR (10)
                || '4. Maximum Password Expire Day(s) is '
                || vDefaultPwExpDay
                || '.';
        END IF;

        RETURN vPasswordPolicy;
    END;

    PROCEDURE DPR_PASSWORD_CHANGE (in_userid        IN     VARCHAR2,
                                   in_oldpassword   IN     VARCHAR2,
                                   in_newpassword   IN     VARCHAR2,
                                   in_repassword    IN     VARCHAR2,
                                   out_message         OUT VARCHAR2,
                                   out_code            OUT INTEGER)
    IS
        CURSOR c_psw_verify (in_maxpsw IN INTEGER)
        IS
            SELECT USER_ID, SERIAL_NO, USER_PWD
              FROM (  SELECT USER_ID, SERIAL_NO, USER_PWD
                        FROM GUMS.MB_USER_PWD
                       WHERE USER_ID = in_userid
                    ORDER BY SERIAL_NO DESC) a
             WHERE ROWNUM <= in_maxpsw + 1;

        out_password          VARCHAR2 (50);
        m                     INTEGER;
        isdigit               BOOLEAN;
        ischar                BOOLEAN;
        ispunct               BOOLEAN;
        isalphachar           BOOLEAN;
        digitarray            VARCHAR2 (10) := '0123456789';
        vPunctuationArray     VARCHAR2 (50);  -- := '~`!@#$%[{()}]\|,;_:+*/-';
        vPunctuationFlag      VARCHAR2 (1);
        lowerchararray        VARCHAR2 (26) := 'abcdefghijklmnopqrstuvwxyz';
        vLowerCaseFlag        VARCHAR2 (1);
        upperchararray        VARCHAR2 (26) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        vAlphabeticChar       VARCHAR2 (100)
            := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        vUpperCaseFlag        VARCHAR2 (1);
        out_usercode          VARCHAR2 (50);
        out_serialno          INTEGER := 0;
        out_userpawd          VARCHAR2 (50);
        vPasswordLength       NUMBER := 0;
        vPasswordRemeber      NUMBER := 0;
        vWordList             VARCHAR2 (500);
        vUserNameFlag         VARCHAR2 (1);
        vOneAlphaCharFlag     VARCHAR2 (1);
        vOneNumericCharFlag   VARCHAR2 (1);
    BEGIN
        IF in_userid NOT IN (2741, 1, 8)
        THEN
            BEGIN
                SELECT pass_length,
                       pass_difference,
                       alphabetic_char,
                       numeric_char,
                       punctuation_char,
                       upper_case_char,
                       lower_case_char,
                       user_name,
                       word_list,
                       punctuation_char_list
                  INTO vPasswordLength,
                       vPasswordRemeber,
                       vOneAlphaCharFlag,
                       vOneNumericCharFlag,
                       vPunctuationFlag,
                       vUpperCaseFlag,
                       vLowerCaseFlag,
                       vUserNameFlag,
                       vWordList,
                       vPunctuationArray
                  FROM GUMS.ST_PASSWORD_POLICY;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    out_code := 1;
                    out_message :=
                        'No Password Policy Found, Contact Administrator. ';
                WHEN TOO_MANY_ROWS
                THEN
                    out_code := 1;
                    out_message :=
                        'More Than One Password Policy Found, Contact Administrator. ';
                WHEN OTHERS
                THEN
                    out_code := 1;
                    out_message :=
                        'Password Policy Finding Problem, Contact Administrator. ';
            END;
        END IF;


        IF in_oldpassword IS NULL
        THEN
            out_code := 1;
            out_message := 'Old Password Required.';
            GOTO stop_level;
        END IF;

        IF in_newpassword IS NULL
        THEN
            out_code := 1;
            out_message := 'New Password Required.';
            GOTO stop_level;
        END IF;

        IF in_newpassword <> in_repassword
        THEN
            out_code := 1;
            out_message := 'Confirm Password Not Matched.';
            GOTO stop_level;
        END IF;

        IF in_newpassword = in_oldpassword
        THEN
            out_code := 1;
            out_message :=
                'New Password should not same as Old Password. Try to use different one.';
            GOTO stop_level;
        END IF;

        IF LENGTH (in_newpassword) < vPasswordLength
        THEN
            out_code := 1;
            out_message :=
                   'New Password Length Cannot be Less Than '
                || vPasswordLength
                || '  Character.';
            GOTO stop_level;
        END IF;

        m := LENGTH (in_newpassword);

        -- Check for One Alphabetic Char


        IF vOneAlphaCharFlag = 'Y'
        THEN
            isalphachar := FALSE;

            FOR i IN 1 .. LENGTH (vAlphabeticChar)
            LOOP
                IF isalphachar = FALSE
                THEN
                    FOR j IN 1 .. m
                    LOOP
                        IF SUBSTR (in_newpassword, j, 1) =
                           SUBSTR (vAlphabeticChar, i, 1)
                        THEN
                            isalphachar := TRUE;
                            EXIT;
                        END IF;
                    END LOOP;
                ELSE
                    EXIT;
                END IF;
            END LOOP;

            IF isalphachar = FALSE
            THEN
                out_code := 1;
                out_message :=
                       'At Least One Alphabetic Character Require.Like '
                    || vAlphabeticChar;
                GOTO stop_level;
            END IF;
        END IF;

        -- Check for One Numeric Char
        --

        IF vOneNumericCharFlag = 'Y'
        THEN
            isdigit := FALSE;

            FOR i IN 1 .. 10
            LOOP
                IF isdigit = FALSE
                THEN
                    FOR j IN 1 .. m
                    LOOP
                        IF SUBSTR (in_newpassword, j, 1) =
                           SUBSTR (digitarray, i, 1)
                        THEN
                            isdigit := TRUE;
                            EXIT;
                        END IF;
                    END LOOP;
                ELSE
                    EXIT;
                END IF;
            END LOOP;

            IF isdigit = FALSE
            THEN
                out_code := 1;
                out_message :=
                       'At Least One Numeric Character Require.Like '
                    || digitarray;
                GOTO stop_level;
            END IF;
        END IF;


        -- Check for the Punctuation  character
        IF vPunctuationFlag = 'Y'
        THEN
            ispunct := FALSE;

            FOR i IN 1 .. LENGTH (vPunctuationArray)
            LOOP
                IF ispunct = FALSE
                THEN
                    FOR j IN 1 .. m
                    LOOP
                        IF SUBSTR (in_newpassword, j, 1) =
                           SUBSTR (vPunctuationArray, i, 1)
                        THEN
                            ispunct := TRUE;
                            EXIT;
                        END IF;
                    END LOOP;
                ELSE
                    EXIT;
                END IF;
            END LOOP;

            IF ispunct = FALSE
            THEN
                out_code := 1;
                out_message :=
                       'At Least One Punctuation Character Require.Like '
                    || vPunctuationArray;
                GOTO stop_level;
            END IF;
        END IF;


        --- Check for the Lower character


        IF vLowerCaseFlag = 'Y'
        THEN
            ischar := FALSE;

            FOR i IN 1 .. LENGTH (lowerchararray)
            LOOP
                IF ischar = FALSE
                THEN
                    FOR j IN 1 .. m
                    LOOP
                        IF SUBSTR (in_newpassword, j, 1) =
                           SUBSTR (lowerchararray, i, 1)
                        THEN
                            ischar := TRUE;
                            EXIT;
                        END IF;
                    END LOOP;
                ELSE
                    EXIT;
                END IF;
            END LOOP;

            IF ischar = FALSE
            THEN
                out_code := 1;
                out_message :=
                       'At Least One Lowercase Character Require.Like '
                    || lowerchararray;
                GOTO stop_level;
            END IF;
        END IF;


        --Check for the upper character


        IF vUpperCaseFlag = 'Y'
        THEN
            ischar := FALSE;

            FOR i IN 1 .. LENGTH (upperchararray)
            LOOP
                IF ischar = FALSE
                THEN
                    FOR j IN 1 .. m
                    LOOP
                        IF SUBSTR (in_newpassword, j, 1) =
                           SUBSTR (upperchararray, i, 1)
                        THEN
                            ischar := TRUE;
                            EXIT;
                        END IF;
                    END LOOP;
                ELSE
                    EXIT;
                END IF;
            END LOOP;

            IF ischar = FALSE
            THEN
                out_code := 1;
                out_message :=
                       'At Least One Uppercase Character Require. Like'
                    || upperchararray;
                GOTO stop_level;
            END IF;
        END IF;

        BEGIN
                SELECT USER_PWD, USER_CODE
                  INTO out_password, out_usercode
                  FROM GUMS.MB_USER_MST
                 WHERE USER_ID = in_userid
            FOR UPDATE OF USER_PWD NOWAIT;

            IF vUserNameFlag = 'Y'
            THEN
                IF LOWER (in_newpassword) LIKE
                       '%' || LOWER (out_usercode) || '%'
                THEN
                    out_code := 1;
                    out_message :=
                        'Password cannot contain your user code. Try a different one.';
                    GOTO stop_level;
                END IF;
            END IF;


            IF out_password <>
               DFN_CREATE_PASSWORD_ENCRYPTED (out_usercode || in_userid,
                                              in_oldpassword)
            THEN
                out_code := 1;
                out_message := 'Old Password Not matched.';
                GOTO stop_level;
            END IF;

            IF in_newpassword = in_repassword
            THEN
                out_userpawd :=
                    DFN_CREATE_PASSWORD_ENCRYPTED (out_usercode || in_userid,
                                                   in_newpassword);

                BEGIN
                    FOR i IN c_psw_verify (vPasswordRemeber)
                    LOOP
                        IF out_userpawd = i.USER_PWD
                        THEN
                            out_code := 1;
                            out_message :=
                                   'Cannot Repeat Previous '
                                || vPasswordRemeber
                                || ' Passwords. Please Choose Different Password.';
                            GOTO stop_level;
                        END IF;
                    END LOOP;

                    BEGIN
                        SELECT NVL (MAX (serial_no), 0) + 1
                          INTO out_serialno
                          FROM GUMS.MB_USER_PWD
                         WHERE user_id = in_userid;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            out_code := 1;
                            out_message :=
                                'Password can not changed. Please Contact System Administrator.';
                            GOTO stop_level;
                    END;


                    BEGIN
                        UPDATE GUMS.MB_USER_MST
                           SET USER_PWD = out_userpawd,
                               LOGON_PASS_CHANGE = 'Y'
                         WHERE USER_ID = in_userid;

                        IF SQL%FOUND
                        THEN
                            BEGIN
                                INSERT INTO GUMS.MB_USER_PWD (USER_ID,
                                                              SERIAL_NO,
                                                              USER_PWD,
                                                              CREATE_BY)
                                     VALUES (in_userid,
                                             out_serialno,
                                             out_userpawd,
                                             in_userid);

                                COMMIT;
                                out_code := 0;
                                out_message :=
                                    'Password Changed Successfully.';
                                GOTO stop_level;
                            EXCEPTION
                                WHEN OTHERS
                                THEN
                                    ROLLBACK;
                                    out_code := 1;
                                    out_message :=
                                           SQLERRM
                                        || 'Password can not changed1.';
                                    GOTO stop_level;
                            END;
                        END IF;

                        IF SQL%NOTFOUND
                        THEN
                            ROLLBACK;
                            out_code := 1;
                            out_message :=
                                SQLERRM || 'Password can not changed2.';
                            GOTO stop_level;
                        END IF;
                    END;
                END;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                out_code := 1;
                out_message :=
                       SQLERRM
                    || 'ID- '
                    || in_userid
                    || 'Password can not changed3.';
                GOTO stop_level;
            WHEN TOO_MANY_ROWS
            THEN
                out_code := 1;
                out_message := SQLERRM || 'Password can not changed4.';
                GOTO stop_level;
        END;

       <<stop_level>>
        out_code := out_code;
        out_message := out_message;
    EXCEPTION
        WHEN OTHERS
        THEN
            out_code := SQLCODE;
            out_message :=
                INITCAP (TRIM (SUBSTR (SQLERRM,
                                       11,
                                         INSTR (INITCAP (TRIM (SQLERRM)),
                                                'Ora-',
                                                1,
                                                2)
                                       - 12)));
    END;

    PROCEDURE PRC_UPDATE_LOGOUT_INFORMATION (pLogId VARCHAR2 DEFAULT NULL)
    IS
    BEGIN
        UPDATE GUMS.MB_USER_LOG_WEB
           SET OUT_TIME = SYSDATE
         WHERE LOG_ID = NVL (V ('AI_LOG_ID'), pLogId);
    EXCEPTION
        WHEN OTHERS
        THEN
            RAISE_APPLICATION_ERROR (
                -20001,
                'Logout Information Update Problem. - ' || SQLERRM);
    END;

    PROCEDURE DPR_PASSWORD_FORGOT (pUserCode           VARCHAR2,
                                   pUserDOB            DATE,
                                   pMobileNo           VARCHAR2,
                                   pErrorFlag      OUT VARCHAR2,
                                   pErrorMessage   OUT VARCHAR2)
    IS
        vNextSlNo          NUMBER;
        vRndmPass          VARCHAR2 (10);
        vEncryptPass       VARCHAR2 (200);
        vUserId            NUMBER;
        vMailNo            VARCHAR2 (200);
        v_result           NUMBER;
        vMyException       EXCEPTION;
        l_sql_parameters   apex_exec.t_parameters;
        l_plsql_code       CLOB;
    BEGIN
        pErrorFlag := 'N';


        IF pUserCode IS NULL
        THEN
            pErrorMessage := 'Requested User Code Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pUserDOB IS NULL
        THEN
            pErrorMessage := 'Date Of Birth Not Be Blank.';
            RAISE vMyException;
        END IF;


        IF pMobileNo IS NULL
        THEN
            pErrorMessage := 'Mobile No. Not Be Blank.';
            RAISE vMyException;
        END IF;


        BEGIN
            SELECT USER_ID, EMAIL_ID
              INTO vUserId, vMailNo
              FROM GUMS.MB_USER_MST
             WHERE     USER_CODE = UPPER (pUserCode)
                   AND USER_DOB = pUserDOB
                   AND MOBILE_NO = pMobileNo;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                pErrorMessage := 'Credential Not Valid.';
                RAISE vMyException;
            WHEN TOO_MANY_ROWS
            THEN
                pErrorMessage := 'More User Found, Contact Administrator';
                RAISE vMyException;
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'User Information Finding Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        IF NVL (vUserId, 0) < 1
        THEN
            pErrorMessage := 'User ID Not Be Blank.';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT LPAD (TRUNC (DBMS_RANDOM.VALUE ('000001', '999999')),
                         6,
                         0)
              INTO vRndmPass
              FROM DUAL;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'Random Password Generation Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        v_result :=                                   ---OTP Sent to User Mail
            GUMS.PKG_GLOBAL_EMAIL.SEND_EMAIL_OTP (
                vMailNo,
                'User Password Reset Notification',
                   'Dear User, Your password reset OTP is '
                || vRndmPass
                || '. Please use this OTP to reset your password. Do not share it with anyone.');


        IF v_result = 0
        THEN
            pErrorMessage := 'OTP Mail not sent. - ' || SQLERRM;
            RAISE vMyException;
        END IF;

        BEGIN
            vEncryptPass :=
                DFN_CREATE_PASSWORD_ENCRYPTED (UPPER (pUserCode) || vUserid,
                                               vRndmPass);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                       'Password can not Reset. Please Contact System Administrator. - '
                    || SQLERRM;
                RAISE vMyException;
        END;

        BEGIN
            SELECT NVL (MAX (SERIAL_NO), 0) + 1
              INTO vNextSlNo
              FROM GUMS.MB_USER_PWD
             WHERE USER_ID = vUserid;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                       'Password can not Reset. Please Contact System Administrator. - '
                    || SQLERRM;
                RAISE vMyException;
        END;


        BEGIN
            UPDATE GUMS.MB_USER_MST
               SET USER_PWD = vEncryptPass, LOGON_PASS_CHANGE = 'Y'
             WHERE USER_ID = vUserid;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'User Information Update Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        IF SQL%ROWCOUNT <> 1
        THEN
            pErrorMessage := 'Update Problem Contact System Administrator.';
            RAISE vMyException;
        END IF;


        BEGIN
            INSERT INTO GUMS.MB_USER_PWD (USER_ID,
                                          SERIAL_NO,
                                          USER_PWD,
                                          CREATE_BY)
                 VALUES (vUserid,
                         vNextSlNo,
                         vEncryptPass,
                         'SYSTEM');
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Password can not changed. - ' || SQLERRM;
                RAISE vMyException;
        END;

        /*BEGIN
           EMOB.ALL_SMS_GENERATION.SMS_GENERATION_DYNAMIC (
              pCustomerCode   => NULL,
              pAccountNo      => NULL,
              pMobileNo       => pMobileNo,
              pMessageType    => 'FRGTPASS',
              pRunUser        => 'SYSTEM',
              P1              => vRndmPass,
              pErrorFlag      => pErrorFlag,
              pErrorMessage   => pErrorMessage);
        EXCEPTION
           WHEN OTHERS
           THEN
              pErrorMessage := 'SMS Generation Problem. - ' || SQLERRM;
              RAISE vMyException;
        END;

        IF pErrorFlag = 'Y'
        THEN
           RAISE vMyException;
        END IF;*/



        l_plsql_code :=
            q'#
DECLARE
   vErrorFlag      VARCHAR2 (1);
   vErrorMessage   VARCHAR2 (1024);
BEGIN
   BEGIN
         EMOB.ALL_SMS_GENERATION.SMS_GENERATION_DYNAMIC (
            pCustomerCode   => NULL,
            pAccountNo      => NULL,
            pMobileNo       => :MOBILE,
            pMessageType    => 'FRGTPASS',
            pRunUser        => 'SYSTEM',
            P1              => :PASS,
            pErrorFlag      => vErrorFlag,
            pErrorMessage   => vErrorMessage);
      EXCEPTION
         WHEN OTHERS
         THEN
         RAISE_APPLICATION_ERROR (-20001, 'SMS Generation Problem. - ' || SQLERRM);
      END;

      IF vErrorFlag = 'Y'
      THEN
         RAISE_APPLICATION_ERROR (-20001, vErrorMessage);
      END IF;
END;#';

        BEGIN
            APEX_EXEC.ADD_PARAMETER (l_sql_parameters, 'MOBILE', pMobileNo);
            APEX_EXEC.ADD_PARAMETER (l_sql_parameters, 'PASS', vRndmPass);
            APEX_SESSION.CREATE_SESSION (p_app_id     => 111,
                                         p_page_id    => 1,
                                         p_username   => 'SYSTEM');
            APEX_EXEC.EXECUTE_REMOTE_PLSQL (
                p_server_static_id   => 'psbcore',
                p_plsql_code         => l_plsql_code,
                p_auto_bind_items    => FALSE,
                p_sql_parameters     => l_sql_parameters);
        --APEX_SESSION.DELETE_SESSION;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Remote SMS Sending Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;
    --Mail Generation Off
    /*BEGIN
       GUMS.PKG_GLOBAL_EMAIL.EMAIL_GENERATE_SEND (
          pMailType       => 'RESPASS',
          pMailTo         => 'UESR',
          pMailRefNo      => vUserId,
          p1              => TO_CHAR (SYSDATE, 'DD-MON-YY HH:MI AM'),
          p2              => NULL,
          p3              => vRndmPass,
          p4              => NULL,
          p5              => NULL,
          pSendTo         => vMailNo,
          pSendCc         => NULL,
          pSendBcc        => NULL,
          pRunUser        => 'SYSTEM',
          pErrorFlag      => pErrorFlag,
          pErrorMessage   => pErrorMessage);
    EXCEPTION
       WHEN OTHERS
       THEN
          pErrorMessage := 'User Email Sending Problem. - ' || SQLERRM;
          RAISE vMyException;
    END;

    IF pErrorFlag = 'Y'
    THEN
       RAISE vMyException;
    END IF;*/
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
    END;

    PROCEDURE DPR_PASSWORD_RESET (pUserid         IN     VARCHAR2,
                                  pRunUser        IN     VARCHAR2,
                                  pErrorMessage      OUT VARCHAR2,
                                  pErrorFlag         OUT VARCHAR2)
    IS
        vUserCode          VARCHAR2 (20);
        vNextSlNo          NUMBER;
        vMobileNo          VARCHAR2 (11);
        vMailNo            VARCHAR2 (200);
        vRndmPass          VARCHAR2 (10);
        v_result           NUMBER;
        vEncryptPass       VARCHAR2 (1024);
        vMyException       EXCEPTION;
        l_sql_parameters   apex_exec.t_parameters;
        l_plsql_code       CLOB;
    BEGIN
        pErrorFlag := 'N';

        BEGIN
                SELECT user_code, mobile_no, email_id
                  INTO vUserCode, vMobileNo, vMailNo
                  FROM GUMS.MB_USER_MST
                 WHERE USER_ID = pUserid
            FOR UPDATE OF USER_PWD NOWAIT;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'User Information Finding Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        BEGIN
            SELECT LPAD (TRUNC (DBMS_RANDOM.VALUE ('000001', '999999')),
                         6,
                         0)
              INTO vRndmPass
              FROM DUAL;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Random Password Generation Problem.';
                RAISE vMyException;
        END;

        v_result :=                                   ---OTP Sent to User Mail
            GUMS.PKG_GLOBAL_EMAIL.SEND_EMAIL_OTP (
                vMailNo,
                'User Password Reset Notification',
                   'Dear User, Your password reset OTP is '
                || vRndmPass
                || '. Please use this OTP to reset your password. Do not share it with anyone.');

        IF v_result = 0
        THEN
            pErrorMessage := 'OTP Mail not sent. - ' || SQLERRM;
            RAISE vMyException;
        END IF;

        vEncryptPass :=
            DFN_CREATE_PASSWORD_ENCRYPTED (vUserCode || pUserid, vRndmPass);


        BEGIN
            SELECT NVL (MAX (serial_no), 0) + 1
              INTO vNextSlNo
              FROM GUMS.MB_USER_PWD
             WHERE USER_ID = pUserid;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'Password can not Reset. Please Contact System Administrator.';
        END;


        BEGIN
            UPDATE GUMS.MB_USER_MST
               SET USER_PWD = vEncryptPass, logon_pass_change = 'Y' -- pwd_date = SYSDATE
             WHERE USER_ID = pUserid;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'User Information Update Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF SQL%ROWCOUNT > 1
        THEN
            pErrorMessage := 'Multiple User Found.';
            RAISE vMyException;
        END IF;

        IF SQL%ROWCOUNT < 1
        THEN
            pErrorMessage := 'User Not Found.';
            RAISE vMyException;
        END IF;


        BEGIN
            INSERT INTO GUMS.MB_USER_PWD (USER_ID,
                                          SERIAL_NO,
                                          USER_PWD,
                                          --PWD_DATE,
                                          CREATE_BY)
                 VALUES (pUserid,
                         vNextSlNo,
                         vEncryptPass,
                         -- SYSDATE,
                         pUserid);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := SQLERRM || 'Password can not changed.';
                RAISE vMyException;
        END;

        l_plsql_code :=
            q'#
DECLARE
   vErrorFlag      VARCHAR2 (1);
   vErrorMessage   VARCHAR2 (1024);
BEGIN
   BEGIN
         EMOB.ALL_SMS_GENERATION.SMS_GENERATION_DYNAMIC (
            pCustomerCode   => NULL,
            pAccountNo      => NULL,
            pMobileNo       => :MOBILE,
            pMessageType    => 'RESPASS',
            pRunUser        => 'SYSTEM',
            p1              => :USER_CODE,
            P2              => :PASS,
            pErrorFlag      => vErrorFlag,
            pErrorMessage   => vErrorMessage);
      EXCEPTION
         WHEN OTHERS
         THEN
         RAISE_APPLICATION_ERROR (-20001, 'SMS Generation Problem. - ' || SQLERRM);
      END;

      IF vErrorFlag = 'Y'
      THEN
         RAISE_APPLICATION_ERROR (-20001, vErrorMessage);
      END IF;
END;#';

        BEGIN
            apex_exec.ADD_PARAMETER (l_sql_parameters,
                                     'USER_CODE',
                                     vUserCode);
            APEX_EXEC.ADD_PARAMETER (l_sql_parameters, 'MOBILE', vMobileNo);
            APEX_EXEC.ADD_PARAMETER (l_sql_parameters, 'PASS', vRndmPass);
            APEX_EXEC.EXECUTE_REMOTE_PLSQL (
                p_server_static_id   => 'psbcore',
                p_plsql_code         => l_plsql_code,
                p_auto_bind_items    => FALSE,
                p_sql_parameters     => l_sql_parameters);
        --APEX_SESSION.DELETE_SESSION;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Remote SMS Sending Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        /* BEGIN
             EMOB.ALL_SMS_GENERATION.SMS_GENERATION_DYNAMIC (
                 pCustomerCode   => NULL,
                 pAccountNo      => NULL,
                 pMobileNo       => vMobileNo,
                 pMessageType    => 'RESPASS',
                 pRunUser        => pRunUser,
                 p1              => vUserCode,
                 p2              => vRndmPass,
                 pErrorFlag      => pErrorFlag,
                 pErrorMessage   => pErrorMessage);

             NULL;
         EXCEPTION
             WHEN OTHERS
             THEN
                 pErrorMessage := 'SMS Generation Problem.' || SQLERRM;
         END;

           BEGIN
              EMOB.PKG_GLOBAL_EMAIL.EMAIL_GENERATE_SEND (
                 pMailType       => 'RESPASS',
                 pMailTo         => 'UESR',
                 pMailRefNo      => pUserid,
                 p1              => TO_CHAR (SYSDATE, 'DD-MON-YY HH:MI AM'),
                 p2              => NULL,
                 p3              => vRndmPass,
                 p4              => NULL,
                 p5              => NULL,
                 pSendTo         => vMailNo,
                 pSendCc         => NULL,
                 pSendBcc        => NULL,
                 pRunUser        => pRunUser,
                 pErrorFlag      => pErrorFlag,
                 pErrorMessage   => pErrorMessage);
           EXCEPTION
              WHEN OTHERS
              THEN
                 pErrorMessage := ' User Email Sending Problem' || SQLERRM;
           END;*/

        NULL;
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
    END;
END;
/


DROP PACKAGE BODY GUMS.GET_LOAN_REPAYMENT_CLOSING;

CREATE OR REPLACE PACKAGE BODY GUMS.GET_LOAN_REPAYMENT_CLOSING
IS
    PROCEDURE LOAN_REPAYMENT_AC_DETAILS (pLoanAcNo       IN     VARCHAR2,
                                         pPayAmount      IN     NUMBER,
                                         pPaymentType    IN     VARCHAR2,
                                         pBranchCode     IN     VARCHAR2,
                                         pAcTittle          OUT VARCHAR2,
                                         pLinkAcNo          OUT VARCHAR2,
                                         pLinkAcTittle      OUT VARCHAR2,
                                         pLinkAcBal         OUT NUMBER,
                                         pProduct           OUT VARCHAR2,
                                         pLoanAmt           OUT NUMBER,
                                         pDisburseDate      OUT DATE,
                                         pIntRate           OUT NUMBER,
                                         pExpIntRate        OUT NUMBER,
                                         pTerm              OUT NUMBER,
                                         pDuePrincipal      OUT NUMBER,
                                         pDueInt            OUT NUMBER,
                                         pDueInstallNo      OUT NUMBER,
                                         pInstallNo         OUT NUMBER,
                                         pLoanType          OUT VARCHAR2,
                                         pOnlyEmp           OUT VARCHAR2,
                                         pLinkAcBranch      OUT VARCHAR2,
                                         pLoanAcBranch      OUT VARCHAR2,
                                         pErrorFlag         OUT VARCHAR2,
                                         pErrorMessage      OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
            'http://10.11.204.213:8080/psb/psbcore/coresrc/Loan_Rep_Cls/GET_LOAN_REPAYMENT_AC_DETAILS';

        vRequest :=
               '{
    "ploanacno": "'
            || pLoanAcNo
            || '",
    "ppayamount": '
            || pPayAmount
            || ',
    "ppaymenttype": "'
            || pPaymentType
            || '",
    "pbranchcode": "'
            || pBranchCode
            || '"
}';


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 60);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Loan A/C Details API Calling Problem';
                RAISE vMyException;
        END;


        COMMIT;
        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorfalg');
        pErrorMessage := apex_json.get_varchar2 ('perrormsg');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pAcTittle := apex_json.get_varchar2 ('pactittle');
        pLinkAcNo := apex_json.get_varchar2 ('plinkacno');
        pLinkAcTittle := apex_json.get_varchar2 ('plinkactittle');
        pLinkAcBal := apex_json.get_number ('plinkacbal');
        pProduct := apex_json.get_varchar2 ('pproduct');
        pLoanAmt := apex_json.get_number ('ploanamt');
        pDisburseDate := apex_json.get_date ('pdisbursedate');
        pIntRate := apex_json.get_number ('pintrate');
        pExpIntRate := apex_json.get_number ('pexpintrate');
        pTerm := apex_json.get_number ('pterm');
        pDuePrincipal := apex_json.get_number ('pdueprincipal');
        pDueInt := apex_json.get_number ('pdueint');
        pDueInstallNo := apex_json.get_number ('pdueinstallno');
        pLoanType := apex_json.get_varchar2 ('ploantype');
        pOnlyEmp := apex_json.get_varchar2 ('ponlyemp');
        pInstallNo := apex_json.get_number ('pinstallno');
        pLinkAcBranch := apex_json.get_varchar2 ('plinkacbranch');
        pLoanAcBranch := apex_json.get_varchar2 ('ploanacbranch');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE LOAN_CLOSE_AC_DETAILS (pLoanAcNo        IN     VARCHAR2,
                                     pPaymentType     IN     VARCHAR2,
                                     pBranchCode      IN     VARCHAR2,
                                     pRunUser         IN     VARCHAR2,
                                     pLogId           IN     VARCHAR2,
                                     pModuleDate      IN     DATE,
                                     pSettlementAmt      OUT NUMBER,
                                     pAcTittle           OUT VARCHAR2,
                                     pLinkAcNo           OUT VARCHAR2,
                                     pLinkAcTittle       OUT VARCHAR2,
                                     pLinkAcBal          OUT NUMBER,
                                     pProduct            OUT VARCHAR2,
                                     pLoanAmt            OUT NUMBER,
                                     pDisburseDate       OUT DATE,
                                     pIntRate            OUT NUMBER,
                                     pExpIntRate         OUT NUMBER,
                                     pTerm               OUT NUMBER,
                                     pDuePrincipal       OUT NUMBER,
                                     pDueInt             OUT NUMBER,
                                     pDueInstallNo       OUT NUMBER,
                                     pInstallNo          OUT NUMBER,
                                     pLoanType           OUT VARCHAR2,
                                     pOnlyEmp            OUT VARCHAR2,
                                     pLinkAcBranch       OUT VARCHAR2,
                                     pLoanAcBranch       OUT VARCHAR2,
                                     pErrorFlag          OUT VARCHAR2,
                                     pErrorMessage       OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vMyException   EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
            'http://10.11.204.213:8888/psb/psbcore/coresrc/Loan_Rep_Cls/GET_LOAN_CLOSE_AC_DETAILS';

        vRequest :=
               '{
    "ploanacno": "'
            || pLoanAcNo
            || '",
    "ppaymenttype": "'
            || pPaymentType
            || '",
    "prunuser": "'
            || pRunUser
            || '",
    "plogid": "'
            || pLogId
            || '",
    "pmoduledate": "'
            || pModuleDate
            || '",
    "pbranchcode": "'
            || pBranchCode
            || '"
}';


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 60);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Loan A/C Closing API Calling Problem';
                RAISE vMyException;
        END;

        COMMIT;
        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorfalg');
        pErrorMessage := apex_json.get_varchar2 ('perrormsg');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pSettlementAmt := apex_json.get_number ('psettlementamt');
        pAcTittle := apex_json.get_varchar2 ('pactittle');
        pLinkAcNo := apex_json.get_varchar2 ('plinkacno');
        pLinkAcTittle := apex_json.get_varchar2 ('plinkactittle');
        pLinkAcBal := apex_json.get_number ('plinkacbal');
        pProduct := apex_json.get_varchar2 ('pproduct');
        pLoanAmt := apex_json.get_number ('ploanamt');
        pDisburseDate := apex_json.get_date ('pdisbursedate');
        pIntRate := apex_json.get_number ('pintrate');
        pExpIntRate := apex_json.get_number ('pexpintrate');
        pTerm := apex_json.get_number ('pterm');
        pDuePrincipal := apex_json.get_number ('pdueprincipal');
        pDueInt := apex_json.get_number ('pdueint');
        pDueInstallNo := apex_json.get_number ('pdueinstallno');
        pInstallNo := apex_json.get_number ('pinstallno');
        pLoanType := apex_json.get_varchar2 ('ploantype');
        pOnlyEmp := apex_json.get_varchar2 ('ponlyemp');
        pLinkAcBranch := apex_json.get_varchar2 ('plinkacbranch');
        pLoanAcBranch := apex_json.get_varchar2 ('ploanacbranch');
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;
END;
/


DROP PACKAGE BODY GUMS.JWT_UTIL;

CREATE OR REPLACE PACKAGE BODY GUMS.jwt_util
AS
    FUNCTION generate_token (p_username         IN VARCHAR2,
                             p_expiry_minutes   IN NUMBER)
        RETURN VARCHAR2
    IS
        l_header            VARCHAR2 (1000);
        l_payload           VARCHAR2 (1000);
        l_signature         VARCHAR2 (1000);
        l_token             VARCHAR2 (4000);
        l_secret            VARCHAR2 (100) := 'your_secret_key';
        l_input_timestamp   TIMESTAMP
            := TO_TIMESTAMP (TO_CHAR (SYSDATE, 'YYYY-MM-DD HH24:MI:SS'),
                             'YYYY-MM-DD HH24:MI:SS');
        l_unix_timestamp    NUMBER;
    BEGIN
        -- Header
        l_header := '{"alg":"HS256","typ":"JWT"}';

        -- Payload
        l_unix_timestamp :=
            FLOOR (
                    (  CAST (l_input_timestamp AS DATE)
                     - TO_DATE ('1970-01-01', 'YYYY-MM-DD'))
                  * 86400
                + (p_expiry_minutes / (24 * 60)));
        l_payload :=
               '{"username":"'
            || p_username
            || '","exp":'
            || l_unix_timestamp   --(SYSDATE + (p_expiry_minutes / (24 * 60)))
            || '}';

        -- Signature
        l_signature :=
            DBMS_CRYPTO.mac (
                UTL_I18N.string_to_raw (l_header || '.' || l_payload,
                                        'AL32UTF8'),
                DBMS_CRYPTO.hmac_sh256,
                UTL_I18N.string_to_raw (l_secret, 'AL32UTF8'));

        -- Token
        l_token :=
            l_header || '.' || l_payload || '.' || RAWTOHEX (l_signature);
        --DBMS_OUTPUT.PUTLINE (l_token||'-'|| l_header || '.' || l_payload || '.' || RAWTOHEX (l_signature));

        RETURN l_token;
    END generate_token;

    FUNCTION verify_token (p_token IN VARCHAR2)
        RETURN BOOLEAN
    IS
        l_secret      VARCHAR2 (100) := 'your_secret_key';
        l_header      VARCHAR2 (1000);
        l_payload     VARCHAR2 (1000);
        l_signature   VARCHAR2 (1000);
    BEGIN
        -- Split token
        l_header := SUBSTR (p_token, 1, INSTR (p_token, '.') - 1);
        l_payload :=
            SUBSTR (
                p_token,
                INSTR (p_token, '.') + 1,
                INSTR (SUBSTR (p_token, INSTR (p_token, '.') + 1), '.') - 1);
        l_signature :=
            RAWTOHEX (HEXTORAW (SUBSTR (p_token,
                                          INSTR (p_token,
                                                 '.',
                                                 1,
                                                 2)
                                        + 1)));

        -- Verify signature
        IF DBMS_CRYPTO.mac (
               UTL_I18N.string_to_raw (l_header || '.' || l_payload,
                                       'AL32UTF8'),
               DBMS_CRYPTO.hmac_sh256,
               UTL_I18N.string_to_raw (l_secret, 'AL32UTF8')) =
           l_signature
        THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END verify_token;
END jwt_util;
/


DROP PACKAGE BODY GUMS.PKG_CHANGE_REQUEST_APP;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_CHANGE_REQUEST_APP
IS
   FUNCTION IS_NUMBER (p_string IN VARCHAR2)
      RETURN INT
   IS
      v_new_num   NUMBER;
   BEGIN
      v_new_num := TO_NUMBER (p_string);
      RETURN 1;
   EXCEPTION
      WHEN VALUE_ERROR
      THEN
         RETURN 0;
   END IS_NUMBER;

   FUNCTION BLOB_COMPARE (pBLOB1 BLOB, pBLOB2 BLOB)
      RETURN INT
   IS
      Amount   INTEGER := 32767;
      Retval   INTEGER;
      vBLOB1   BLOB;
      vBLOB2   BLOB;
   BEGIN
      vBLOB1 := pBLOB1;
      vBLOB2 := pBLOB2;

      retval :=
         DBMS_LOB.COMPARE (vBLOB1,
                           vBLOB2,
                           Amount,
                           1,
                           1);

      IF NVL (retval, 1) = 0
      THEN
         RETURN 0;
      ELSE
         RETURN 1;
      END IF;
   END;

   PROCEDURE REQUEST_CHANGE_LOG (
      pTableName            VARCHAR2,
      pKeyCol               VARCHAR2,
      pKeyColValue          VARCHAR2,
      pNewData              CLOB,
      pOldData              CLOB DEFAULT NULL,
      pRequestPurpose       VARCHAR2,
      pPageId               NUMBER,
      pPageName             VARCHAR2,
      pRunUser              VARCHAR2,
      pSessionId            VARCHAR2,
      pBranchCode           VARCHAR2 DEFAULT NULL,
      pRecIdentifier    OUT NUMBER,
      pSchemaName           VARCHAR2 DEFAULT 'GUMS',
      pRequestStatus        VARCHAR2 DEFAULT 'R',
      pRetData          OUT CLOB,
      pErrorFlag        OUT VARCHAR2,
      pErrorMessage     OUT VARCHAR2)
   IS
      vCount           NUMBER;
      l_count          NUMBER;
      vOldValue        VARCHAR2 (1024);
      vDbColumn        VARCHAR2 (1024);
      vNewValue        VARCHAR2 (1024);
      vItemName        VARCHAR2 (1024);
      vDbDataType      VARCHAR2 (1024);
      vSame            VARCHAR2 (1);
      vErrorFlag       VARCHAR2 (1);
      vErrorMessage    VARCHAR2 (1024);
      vVisible         VARCHAR2 (1024);
      vAltDisplay      VARCHAR2 (1024);
      vRecIdenKey      NUMBER;
      vDbOldData       GUMS.PKG_CHANGE_REQUEST_APP.DB_OLD;
      vAppId           NUMBER;
      vMyException     EXCEPTION;
      vMenuCount       NUMBER;
      vDmlType         VARCHAR2 (2) := 'Y';
      l_new_data_arr   JSON_ARRAY_T;
      vBreak           VARCHAR2 (1024);

      CURSOR t1
      IS
         SELECT COLUMN_NAME
           FROM SYS.USER_TAB_COLUMNS
          WHERE UPPER (TABLE_NAME) = UPPER (pTableName);
   BEGIN
      pErrorFlag := 'N';

      BEGIN
         SELECT COUNT (*)
           INTO vCount
           FROM GUMS.MB_REQUEST_CHANGE_LOG
          WHERE     UPPER (TABLE_NAME) = UPPER (pTableName)
                AND STATUS = 'R'
                AND REQUEST_FOR = 'U'
                AND REQUEST_PAGE_ID = pPageId
                AND KEY_COL_VALUE = pKeyColValue;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage :=
                  'Old Request Finding Problem in Change Request Log.'
               || REPLACE (SQLERRM, 'ORA-', 'Error:');
            RAISE vMyException;
      END;


      IF vCount > 0
      THEN
         pErrorMessage :=
            'Already Have an Active Request. Plz Authorized this First 1..';
         RAISE vMyException;
      END IF;



      vRecIdenKey := GUMS.REQ_RECORD_IDENTIFIER.NEXTVAL;
      pRecIdentifier := vRecIdenKey;


      --  raise_application_error(-20001,'test');
      IF pTableName IN ('SYRIGHTS', 'SYRIGHTS_USER')
      THEN
         /*  APEX_JSON.parse (pNewData);
           l_count := APEX_JSON.get_count (p_path => '.');

           FOR i IN 1 .. l_count
           LOOP
              SELECT COUNT (*)
                INTO vMenuCount
                FROM SYRIGHTS A, SYMENTRE B
               WHERE     A.GROUPCODE = pKeyColValue
                     AND A.PROGCODE =
                            APEX_JSON.get_number (
                               p_path   => '[' || i || '].PROGCODE')
                     AND B.PROGCODE = A.PROGCODE
                     AND B.APP_CODE =
                            APEX_JSON.get_varchar2 (
                               p_path   => '[' || i || '].APP_CODE');

              IF vMenuCount = 0
              THEN*/

            


         BEGIN
            INSERT INTO GUMS.MB_REQUEST_CHANGE_LOG_RIGHTS (LOG_ID,
                                                           TABLE_NAME,
                                                           NEW_VAL,
                                                           OLD_VALUE,
                                                           KEY_COL_NAME,
                                                           KEY_COL_VALUE,
                                                           SCHEMA_NAME,
                                                           STATUS,
                                                           REQUEST_PURPOSE,
                                                           REQUEST_PAGE_ID,
                                                           REQUEST_PAGE_NAME,
                                                           REQUEST_FOR,
                                                           SESSION_ID,
                                                           RECORD_IDENTIFIER,
                                                           APP_ID,
                                                           CREATE_BY,
                                                           branch_code)
                 VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                         pTableName,
                         pNewData,
                         pOldData,
                         pKeyCol,
                         pKeyColValue,
                         pSchemaName,
                         pRequestStatus,
                         pRequestPurpose,
                         pPageId,
                         pPageName,
                         'U',
                         pSessionId,
                         vRecIdenKey,
                         vAppId,
                         pRunUser,
                         pBranchCode);
         EXCEPTION
            WHEN OTHERS
            THEN
               pErrorMessage :=
                     'change request log insert problem in change request log.'
                  || REPLACE (SQLERRM, 'ORA-', 'Error:');
               RAISE vMyException;
         END;
      ELSE
         apex_json.parse (pNewData);

         -- Get the number of array elements in PAYLOAD
         l_count := apex_json.get_count (p_path => 'PAYLOAD');

         FOR i IN 1 .. l_count
         LOOP
            vDbColumn :=
               apex_json.get_varchar2 (p_path   => 'PAYLOAD[%d].DB_COLUMN',
                                       p0       => i);
            vNewValue :=
               apex_json.get_varchar2 (p_path   => 'PAYLOAD[%d].NEW_VALUE',
                                       p0       => i);
            vItemName :=
               apex_json.get_varchar2 (p_path   => 'PAYLOAD[%d].ITEM_NAME',
                                       p0       => i);
            vDbDataType :=
               apex_json.get_varchar2 (p_path   => 'PAYLOAD[%d].DB_DATA_TYPE',
                                       p0       => i);
            vVisible :=
               apex_json.get_varchar2 (p_path   => 'PAYLOAD[%d].DISPLAY',
                                       p0       => i);
            vDmlType :=
               apex_json.get_varchar2 (p_path   => 'PAYLOAD[%d].DML_TYPE',
                                       p0       => i);

            IF NVL (vDmlType, 'Y') != 'N'
            THEN
               IF vDbColumn IS NOT NULL
               THEN
                  BEGIN
                     GUMS.PKG_CHANGE_REQUEST_APP.DB_OLD_VALUE_RETRIVE (
                        pColName        => vDbColumn,
                        pTableName      => pTableName,
                        pKeyCol         => pKeyCol,
                        pKeyColValue    => pKeyColValue,
                        pSchemaName     => pSchemaName,
                        PDBOLDDATA      => vDbOldData,
                        pErrorFlag      => vErrorFlag,
                        pErrorMessage   => vErrorMessage);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        pErrorMessage :=
                              'DB Value Retriving Problem in change request log.'
                           || pKeyCol
                           || REPLACE (SQLERRM, 'ORA-', 'Error:');
                        RAISE vMyException;
                  END;

                  IF NVL (vErrorFlag, 'N') = 'Y'
                  THEN
                     pErrorMessage := vErrorMessage;
                     RAISE vMyException;
                  END IF;
               END IF;

               BEGIN
                  FOR j IN 1 .. vDbOldData.COUNT
                  LOOP
                     IF     vDbOldData (j).DB_col_value IS NOT NULL
                        AND vNewValue IS NOT NULL
                        AND vDbOldData (j).DB_col_value = vNewValue
                     THEN
                        vSame := 'Y';
                     ELSIF     vDbOldData (j).DB_col_value IS NULL
                           AND vNewValue IS NULL
                     THEN
                        vSame := 'Y';
                     ELSE
                        vOldValue := vDbOldData (j).DB_col_value;


                        vSame := 'N';
                     END IF;
                  END LOOP;
               END;

               IF NVL (vSame, 'N') = 'N'
               THEN
                  IF pRetData IS NOT NULL
                  THEN
                     vBreak := '<br>';
                  END IF;

                  IF NVL (vVisible, 'Y') != 'N'
                  THEN
                     pRetData :=
                           pRetData
                        || vBreak
                        || vItemName
                        || ' -&nbsp &nbsp Old Value: '
                        || CASE
                              WHEN vAltDisplay IS NULL THEN vOldValue
                              ELSE NULL
                           END
                        || '&nbsp &nbsp New Value: '
                        || '<span style="color:red" >'
                        || CASE
                              WHEN vAltDisplay IS NULL THEN vNewValue
                              ELSE vAltDisplay
                           END
                        || '</span>';
                  END IF;
               END IF;

               IF     NVL (vSame, 'N') = 'N'
                  AND pTableName != 'MB_HOLIDAY_LIST'
                  AND vDbColumn IS NOT NULL
               THEN
                  BEGIN
                     INSERT
                       INTO GUMS.MB_REQUEST_CHANGE_LOG (LOG_ID,
                                                        TABLE_NAME,
                                                        COL_NAME,
                                                        NEW_VAL,
                                                        OLD_VALUE,
                                                        APEX_LEVEL,
                                                        DB_DATA_TYPE,
                                                        KEY_COL_NAME,
                                                        KEY_COL_VALUE,
                                                        SCHEMA_NAME,
                                                        STATUS,
                                                        REQUEST_PURPOSE,
                                                        REQUEST_PAGE_ID,
                                                        REQUEST_PAGE_NAME,
                                                        REQUEST_FOR,
                                                        SESSION_ID,
                                                        RECORD_IDENTIFIER,
                                                        MASTER_RECORD,
                                                        APP_ID,
                                                        CREATE_BY,
                                                        branch_code)
                     VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                             pTableName,
                             vDbColumn,
                             vNewValue,
                             vOldValue,
                             vItemName,
                             vDbDataType,
                             pKeyCol,
                             pKeyColValue,
                             pSchemaName,
                             pRequestStatus,
                             pRequestPurpose,
                             pPageId,
                             pPageName,
                             'U',
                             pSessionId,
                             vRecIdenKey,
                             'M',
                             vAppId,
                             pRunUser,
                             pBranchCode);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        pErrorMessage :=
                              'change request log insert problem in change request log.'
                           || REPLACE (SQLERRM, 'ORA-', 'Error:');
                        RAISE vMyException;
                  END;
               END IF;

               IF NVL (vSame, 'N') = 'N' AND pTableName = 'MB_HOLIDAY_LIST'
               THEN
                  BEGIN
                     INSERT
                       INTO GUMS.MB_REQUEST_CHANGE_LOG (LOG_ID,
                                                        TABLE_NAME,
                                                        COL_NAME,
                                                        NEW_VAL,
                                                        OLD_VALUE,
                                                        APEX_LEVEL,
                                                        DB_DATA_TYPE,
                                                        KEY_COL_NAME,
                                                        KEY_COL_VALUE,
                                                        SCHEMA_NAME,
                                                        STATUS,
                                                        REQUEST_PURPOSE,
                                                        REQUEST_PAGE_ID,
                                                        REQUEST_PAGE_NAME,
                                                        REQUEST_FOR,
                                                        SESSION_ID,
                                                        RECORD_IDENTIFIER,
                                                        MASTER_RECORD,
                                                        APP_ID,
                                                        CREATE_BY,
                                                        branch_code)
                     VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                             pTableName,
                             vDbColumn,
                             vNewValue,
                             vOldValue,
                             vItemName,
                             vDbDataType,
                             pKeyCol,
                             pKeyColValue,
                             pSchemaName,
                             pRequestStatus,
                             pRequestPurpose,
                             pPageId,
                             pPageName,
                             'U',
                             pSessionId,
                             vRecIdenKey,
                             'M',
                             vAppId,
                             pRunUser,
                             pBranchCode);
                  EXCEPTION
                     WHEN OTHERS
                     THEN
                        pErrorMessage :=
                              'change request log insert problem in change request log.'
                           || REPLACE (SQLERRM, 'ORA-', 'Error:');
                        RAISE vMyException;
                  END;

                  IF pRetData IS NOT NULL
                  THEN
                     vBreak := '<br><br>';
                  END IF;

                  IF NVL (vVisible, 'Y') != 'N'
                  THEN
                     pRetData :=
                           pRetData
                        || vBreak
                        || 'Entity Name: '
                        || vItemName
                        || '<br>Old Value: '
                        || vOldValue
                        || '<br>New Value: '
                        || vNewValue;
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END IF;

      COMMIT;
   EXCEPTION
      WHEN vMyException
      THEN
         ROLLBACK;
         pErrorFlag := 'Y';
   END;

   PROCEDURE DB_OLD_VALUE_RETRIVE (
      pColName            VARCHAR2,
      pTableName          VARCHAR2,
      pKeyCol             VARCHAR2,
      pKeyColValue        VARCHAR2,
      pSchemaName         VARCHAR2 DEFAULT 'GUMS',
      pDbOldData      OUT GUMS.PKG_CHANGE_REQUEST_APP.DB_OLD,
      pErrorFlag      OUT VARCHAR2,
      pErrorMessage   OUT VARCHAR2)
   IS
      TYPE vCurType IS REF CURSOR;

      vCursor        vCurType;
      v_stmt_str     VARCHAR2 (2048) := NULL;
      vMyException   EXCEPTION;
   BEGIN
      BEGIN
         SELECT    'SELECT'
                || ' '''
                || pColName
                || ''' '
                || '"col_name"'
                || ' , '
                || pColName
                || ' '
                || '"col_value"'
                || ' '
                || 'FROM'
                || ' '
                || pSchemaName
                || '.'
                || pTableName
                || ' WHERE '
                || pKeyCol
                || ' = '
                || pKeyColValue
           INTO v_stmt_str
           FROM DUAL;
      END;


      COMMIT;

      OPEN vCursor FOR v_stmt_str;

      BEGIN
         FETCH vCursor BULK COLLECT INTO pDbOldData;
      EXCEPTION
         WHEN INVALID_NUMBER
         THEN
            BEGIN
               SELECT    'SELECT'
                      || ' '''
                      || pColName
                      || ''' '
                      || '"col_name"'
                      || ' , '
                      || pColName
                      || ' '
                      || '"col_value"'
                      || ' '
                      || 'FROM'
                      || ' '
                      || pSchemaName
                      || '.'
                      || pTableName
                      || ' WHERE '
                      || pKeyCol
                      || ' = '
                      || ''''
                      || pKeyColValue
                      || ''''
                 INTO v_stmt_str
                 FROM DUAL;
            END;


            OPEN vCursor FOR v_stmt_str;

            BEGIN
               FETCH vCursor BULK COLLECT INTO pDbOldData;
            EXCEPTION
               WHEN OTHERS
               THEN
                  pErrorMessage :=
                        'bulk assign problem '
                     || REPLACE (SQLERRM, 'ORA-', 'Error:');
                  RAISE vMyException;
            END;
         WHEN OTHERS
         THEN
            pErrorMessage :=
               'bulk assign problem ' || REPLACE (SQLERRM, 'ORA-', 'Error:');
            RAISE vMyException;
      END;


      CLOSE vCursor;
   EXCEPTION
      WHEN vMyException
      THEN
         ROLLBACK;
         pErrorFlag := 'Y';
   END;

   PROCEDURE REQUEST_CHANGE_APPROVAL (
      pRecordIdentifier       VARCHAR2,
      pKeyColumn              VARCHAR2,
      pKeyColValue            VARCHAR2,
      pTableName              VARCHAR2,
      pRunUser                VARCHAR2,
      pTaskID                 NUMBER DEFAULT NULL,
      pErrorFlag          OUT VARCHAR2,
      pErrorMessage       OUT VARCHAR2)
   IS
      vUpdateCol       VARCHAR2 (2048);
      vStatStr         VARCHAR2 (2048);
      vTableName       VARCHAR2 (1048);
      vKeyColumn       VARCHAR2 (1048);
      vKeyCoumnValue   VARCHAR2 (1048);
      vBranchCode      VARCHAR2 (1024);
      vHolidayDate     DATE;
      vNoticeInfo      CLOB;
      vFileName        VARCHAR2 (1024);
      vFileType        VARCHAR2 (1024);
      vBlobContent     BLOB;
      vKeyvalueImg     NUMBER;
      vMyException     EXCEPTION;


      CURSOR c1
      IS
         SELECT col_name,
                new_val,
                old_value,
                DB_DATA_TYPE
           FROM GUMS.MB_REQUEST_CHANGE_LOG x
          WHERE RECORD_IDENTIFIER = pRecordIdentifier;
   BEGIN
      BEGIN
         SELECT DISTINCT TABLE_NAME,
                         KEY_COL_NAME,
                         KEY_COL_VALUE,
                         BRANCH_CODE
           INTO vTableName,
                vKeyColumn,
                vKeyCoumnValue,
                vBranchCode
           FROM GUMS.MB_REQUEST_CHANGE_LOG
          WHERE RECORD_IDENTIFIER = pRecordIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage :=
                  'Unique Identifier Finding Problem '
               || REPLACE (SQLERRM, 'ORA-', 'Error:')
               || pRecordIdentifier;
            RAISE vMyException;
      END;


      FOR i IN c1
      LOOP
         IF vUpdateCol IS NOT NULL AND i.col_name IS NOT NULL
         THEN
            vUpdateCol := vUpdateCol || ',';
         END IF;

         IF i.DB_DATA_TYPE = 'NATIVE_NUMBER_FIELD'
         THEN
            vUpdateCol := vUpdateCol || i.col_name || ' = ' || i.new_val;
         ELSE
            vUpdateCol :=
               vUpdateCol || i.col_name || ' = ' || '''' || i.new_val || '''';
         END IF;
      END LOOP;

      ----Added for Auth Remarks and Auth user---
      FOR r
         IN (SELECT COLUMN_NAME
               FROM ALL_TAB_COLUMNS
              WHERE     TABLE_NAME = UPPER (vTableName)
                    AND COLUMN_NAME LIKE '%REMARKS%')
      LOOP
         IF INSTR (',' || vUpdateCol || ',', ',' || r.COLUMN_NAME || '=') = 0
         THEN
            vUpdateCol :=
                  vUpdateCol
               || ','
               || r.COLUMN_NAME
               || ' = (SELECT LISTAGG(text, '','') '
               || 'FROM apex_task_comments WHERE task_id = '
               || NVL (TO_CHAR (pTaskID), 'NULL')
               || ')';
         END IF;
      END LOOP;

      DECLARE
         vHasUpdateBy   NUMBER;
         vHasAuthBy     NUMBER;
      BEGIN
         SELECT COUNT (*)
           INTO vHasUpdateBy
           FROM ALL_TAB_COLUMNS
          WHERE TABLE_NAME = UPPER (vTableName) AND COLUMN_NAME = 'UPDATE_BY';

         SELECT COUNT (*)
           INTO vHasAuthBy
           FROM ALL_TAB_COLUMNS
          WHERE TABLE_NAME = UPPER (vTableName) AND COLUMN_NAME = 'AUTH_BY';

         IF vHasUpdateBy > 0
         THEN
            IF INSTR (vUpdateCol, 'UPDATE_BY') = 0
            THEN
               vUpdateCol :=
                  vUpdateCol || ',UPDATE_BY = ''' || pRunUser || '''';
            END IF;
         END IF;

         IF vHasAuthBy > 0
         THEN
            IF INSTR (vUpdateCol, 'AUTH_BY') = 0
            THEN
               vUpdateCol := vUpdateCol || ',AUTH_BY = ''' || pRunUser || '''';
            END IF;
         END IF;
      END;


      BEGIN
         SELECT    'UPDATE '
                || pTableName
                || ' SET '
                || vUpdateCol
                || ' WHERE '
                || pKeyColumn
                || ' = '
                || pKeyColValue
           INTO vStatStr
           FROM DUAL;
      END;

      BEGIN
         EXECUTE IMMEDIATE (vStatStr);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX
         THEN
            pErrorMessage := 'Duplicate Entry Not Allowed';
            RAISE vMyException;
         WHEN OTHERS
         THEN
            pErrorMessage :=
                  'Update Execute Problem (change):'
               || REPLACE (SQLERRM, 'ORA-', 'Error:')
               || vStatStr;
            RAISE vMyException;
      END;

      ----IF image are available---
      BEGIN
         SELECT DISTINCT KEY_COL_VALUE
           INTO vKeyvalueImg
           FROM GUMS.MB_APP_IMG_REQUEST_CHANGE_LOG
          WHERE RECORD_IDENTIFIER = pRecordIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      IF pTableName = 'ST_NOTICE_INFO'
      THEN
         BEGIN
            -- Fetch the latest NOTICE_INFO value if present
            SELECT NEW_VAL_CLOB
              INTO vNoticeInfo
              FROM GUMS.MB_APP_IMG_REQUEST_CHANGE_LOG
             WHERE     RECORD_IDENTIFIER = pRecordIdentifier
                   AND KEY_COL_VALUE = vKeyvalueImg
                   AND TRIM (COL_NAME) = 'NOTICE_INFO'
                   AND NEW_VAL_CLOB IS NOT NULL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               vNoticeInfo := NULL;
         END;

         BEGIN
            -- Fetch the latest BLOB_CONTENT if present
            SELECT NEW_VAL_BLOB, FILE_NAME, MIME_TYPE
              INTO vBlobContent, vFileName, vFileType
              FROM GUMS.MB_APP_IMG_REQUEST_CHANGE_LOG
             WHERE     RECORD_IDENTIFIER = pRecordIdentifier
                   AND KEY_COL_VALUE = vKeyvalueImg
                   AND TRIM (COL_NAME) = 'BLOB_CONTENT'
                   AND NEW_VAL_BLOB IS NOT NULL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               vBlobContent := NULL;
         END;

         UPDATE GUMS.ST_NOTICE_INFO
            SET NOTICE_INFO = COALESCE (vNoticeInfo, NOTICE_INFO),
                BLOB_CONTENT = COALESCE (vBlobContent, BLOB_CONTENT),
                FILE_TYPE = COALESCE (vFileType, FILE_TYPE),
                FILE_NAME = COALESCE (vFileName, FILE_NAME),
                AUTH_BY = pRunUser,
                AUTH_DATE = SYSDATE,
                UPDATE_BY = pRunUser,
                UPDATE_DATE = SYSDATE
          WHERE NOTICE_ID = vKeyvalueImg;
      END IF;


      BEGIN
         UPDATE GUMS.MB_REQUEST_CHANGE_LOG
            SET status = 'A', APPROVE_BY = pRunUser, APPROVE_DATE = SYSDATE
          WHERE RECORD_IDENTIFIER = pRecordIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage :=
                  ' MB_REQUEST_CHANGE_LOG Update Problem:'
               || REPLACE (SQLERRM, 'ORA-', 'Error:');
            RAISE vMyException;
      END;
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorFlag := 'Y';

         ROLLBACK;
   END;

   PROCEDURE APPROVE_CHANGE_REQUEST (
      pRecordIdentifier       NUMBER,
      pRunUser                VARCHAR2,
      pTaskID                 NUMBER DEFAULT NULL,
      pErrorFlag          OUT VARCHAR2,
      pErrorMessage       OUT VARCHAR2)
   IS
      vTableName       CLOB;                               --VARCHAR2 (32000);
      vKeyColumn       CLOB;                               --VARCHAR2 (32000);
      vNewValue        CLOB;                               --VARCHAR2 (32000);
      vOldValue        CLOB;                              -- VARCHAR2 (32000);
      vKeyCoumnValue   VARCHAR2 (32000);
      vMyException     EXCEPTION;
   BEGIN
      BEGIN
         SELECT DISTINCT TABLE_NAME, KEY_COL_NAME, KEY_COL_VALUE
           INTO vTableName, vKeyColumn, vKeyCoumnValue
           FROM GUMS.MB_REQUEST_CHANGE_LOG
          WHERE RECORD_IDENTIFIER = pRecordIdentifier;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            BEGIN
               SELECT                                   --DISTINCT TABLE_NAME,
                     TABLE_NAME,
                      KEY_COL_NAME,
                      KEY_COL_VALUE,
                      NEW_VAL,
                      OLD_VALUE
                 INTO vTableName,
                      vKeyColumn,
                      vKeyCoumnValue,
                      vNewValue,
                      vOldValue
                 FROM MB_REQUEST_CHANGE_LOG_RIGHTS
                WHERE RECORD_IDENTIFIER = pRecordIdentifier;
            EXCEPTION
               WHEN OTHERS
               THEN
                  pErrorMessage :=
                        'Unique Identifier Finding Problem.'
                     || REPLACE (SQLERRM, 'ORA-', 'Error:')
                     || pRecordIdentifier;
                  RAISE vMyException;
            END;
         WHEN OTHERS
         THEN
            pErrorMessage :=
                  'Unique Identifier Finding Problem.'
               || REPLACE (SQLERRM, 'ORA-', 'Error:')
               || pRecordIdentifier;
            RAISE vMyException;
      END;


      IF vTableName = 'MB_USER_MST'
      THEN
         DECLARE
            vRequestJson   CLOB;
            vCreateBy      VARCHAR2 (1024);
            vCreateDate    DATE;
            VappLink       VARCHAR2 (1024);
         BEGIN
            SELECT REQUEST_CLOB, CREATE_BY, CREATE_DATE
              INTO vRequestJson, vCreateBy, vCreateDate
              FROM MB_REQUEST_CHANGE_LOG
             WHERE RECORD_IDENTIFIER = pRecordIdentifier;

            SELECT APP_LINK_LOCAL
              INTO VappLink
              FROM MB_GLOBAL_RULE
             WHERE ROWNUM = 1;

            apex_json.parse (vRequestJson);

            BEGIN
               PRC_USER_INFO_CHANGE (
                  -- User identity & basic info
                  p_user_id               => vKeyCoumnValue,
                  p_user_name             => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.user_name'),
                  p_user_name_h           => NULL,
                  p_dob                   => TO_DATE (
                                               APEX_JSON.GET_VARCHAR2 (
                                                  p_path   => 'UserInfo.dob'),
                                               'YYYY-MM-DD'),
                  p_dob_h                 => TO_DATE (
                                               APEX_JSON.GET_VARCHAR2 (
                                                  p_path   => 'UserInfo.dob_h'),
                                               'YYYY-MM-DD'),
                  p_mobile_no             => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.mobile_no'),
                  p_mobile_no_h           => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.mobile_no_h'),
                  p_email                 => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.email'),
                  p_email_h               => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.email_h'),
                  p_branch                => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.branch'),
                  p_branch_h              => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.branch_h'),
                  p_status                => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.status'),
                  p_status_h              => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'UserInfo.status_h'),
                  -- Role change JSON & old role snapshot
                  p_role_old              => APEX_JSON.GET_CLOB (
                                               p_path   => 'RoleInfo.role_old_json'),
                  p_role_change           => APEX_JSON.GET_CLOB (
                                               p_path   => 'RoleInfo.role_change_json'),
                  -- Image flag (equivalent of :IMAGE item; value unused except NULL check)
                  p_image_flag            => NULL,
                  -- APEX approval/task context
                  p_apex_task_id          => pTaskID,
                  p_apex_task_subject     => APEX_JSON.GET_VARCHAR2 (
                                               p_path   => 'TaskInfo.Subject'),
                  p_apex_task_initiator   => NULL,
                  -- Application context
                  p_app_user              => pRunUser,
                  p_ai_user_id            => 1,
                  p_ai_app_link           => VappLink, --'http://10.20.26.11:8888',
                  pErrorFlag              => pErrorFlag,
                  pErrorMsg               => pErrorMessage);
            EXCEPTION
               WHEN OTHERS
               THEN
                  pErrorMessage :=
                        'User Information Change Process Calling Problem'
                     || SQLERRM
                     || APEX_JSON.GET_VARCHAR2 (
                           p_path   => 'UserInfo.mobile_no');
                  RAISE vMyException;
            END;
            
            

            IF NVL (pErrorFlag, 'N') = 'Y'
            THEN
               RAISE vMyException;
            END IF;
            BEGIN
         UPDATE GUMS.MB_REQUEST_CHANGE_LOG
            SET status = 'A', APPROVE_BY = pRunUser, APPROVE_DATE = SYSDATE
          WHERE RECORD_IDENTIFIER = pRecordIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage :=
                  ' MB_REQUEST_CHANGE_LOG_RIGHTS Update Problem:'
               || REPLACE (SQLERRM, 'ORA-', 'Error:');
            RAISE vMyException;
            END; 
            
            
         END;
      ELSE
         IF vTableName = 'SYRIGHTS'
         THEN
            DECLARE
               vCount       PLS_INTEGER;
               vGrpcode     PLS_INTEGER;
               vProgCode    PLS_INTEGER;
               vAppCode     VARCHAR2 (100);
               vProgCount   NUMBER;
               vCount2      PLS_INTEGER;
            BEGIN
               SELECT PARAM_VALUE
                 INTO vAppCode
                 FROM APEX_TASK_PARAMETERS
                WHERE TASK_ID = pTaskID AND PARAM_STATIC_ID = 'APP_CODE';

               DELETE FROM GUMS.SYRIGHTS
                     WHERE     GROUPCODE = vKeyCoumnValue
                           AND PROGCODE IN
                                  (SELECT PROGCODE
                                     FROM GUMS.SYMENTRE
                                    WHERE     APP_CODE = vAppCode
                                          AND IS_VISIBLE = 'Y');


               IF vNewValue IS NOT NULL
               THEN
                  vNewValue := '{"data" : ' || vNewValue || '}';
                  APEX_JSON.PARSE (vNewValue);
                  vCount := APEX_JSON.GET_COUNT ('data');

                  IF vCount != 0
                  THEN
                     FOR i IN 1 .. vCount
                     LOOP
                        vGrpcode :=
                           APEX_JSON.GET_VARCHAR2 (
                              p_path   => 'data[' || i || '].GROUPCODE');
                        vProgCode :=
                           APEX_JSON.GET_VARCHAR2 (
                              p_path   => 'data[' || i || '].PROGCODE');

                        BEGIN
                           SELECT COUNT (1)
                             INTO vProgCount
                             FROM GUMS.SYRIGHTS
                            WHERE     GROUPCODE = vGrpcode
                                  AND PROGCODE = vProgCode;
                        END;

                        IF vProgCount = 0
                        THEN
                           BEGIN
                              INSERT
                                INTO GUMS.SYRIGHTS (GROUPCODE,
                                                    PROGCODE,
                                                    CREATE_BY)
                                 VALUES (
                                           vKeyCoumnValue,
                                           vProgCode,
                                           GUMS.PKG_GLOBAL_OBJECTS.GET_USER_ID_BY_CODE (
                                              pRunUser));
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 RAISE;
                           END;
                        END IF;

                        FOR j IN 1 .. 5
                        LOOP
                           IF vProgCode IS NOT NULL
                           THEN
                              SELECT PARENTCODE
                                INTO vProgCode
                                FROM GUMS.SYMENTRE
                               WHERE PROGCODE = vProgCode;

                              IF vProgCode IS NOT NULL
                              THEN
                                 SELECT COUNT (1)
                                   INTO vCount2
                                   FROM GUMS.SYRIGHTS
                                  WHERE     GROUPCODE = vKeyCoumnValue
                                        AND PROGCODE = vProgCode;

                                 IF vCount2 = 0
                                 THEN
                                    BEGIN
                                       INSERT
                                         INTO GUMS.SYRIGHTS (GROUPCODE,
                                                             PROGCODE,
                                                             CREATE_BY)
                                          VALUES (
                                                    vKeyCoumnValue,
                                                    vProgCode,
                                                    GUMS.PKG_GLOBAL_OBJECTS.GET_USER_ID_BY_CODE (
                                                       pRunUser));
                                    EXCEPTION
                                       WHEN OTHERS
                                       THEN
                                          RAISE;
                                    END;
                                 END IF;
                              END IF;
                           END IF;
                        END LOOP;
                     END LOOP;
                  END IF;
               END IF;
            END;
         ELSIF vTableName = 'SYRIGHTS_USER' ----UESR RIGHTS-------------------------------------
         THEN
            BEGIN
               DECLARE
                  vCount      PLS_INTEGER;
                  vGrpcode    PLS_INTEGER;
                  vProgCode   PLS_INTEGER;
                  vAppCode    VARCHAR2 (100);
                  vCount2     PLS_INTEGER;
               BEGIN
                  SELECT PARAM_VALUE
                    INTO vAppCode
                    FROM APEX_TASK_PARAMETERS
                   WHERE TASK_ID = pTaskID AND PARAM_STATIC_ID = 'APP_CODE';



                  DELETE FROM GUMS.SYRIGHTS_USER
                        WHERE     USER_ID = vKeyCoumnValue
                              AND PROGCODE IN
                                     (SELECT PROGCODE
                                        FROM GUMS.SYMENTRE
                                       WHERE     APP_CODE = vAppCode
                                             AND IS_VISIBLE = 'Y');



                  IF vNewValue IS NOT NULL
                  THEN
                     vNewValue := '{"data" : ' || vNewValue || '}';
                     APEX_JSON.PARSE (vNewValue);
                     vCount := APEX_JSON.GET_COUNT ('data');

                     IF vCount != 0
                     THEN
                        FOR i IN 1 .. vCount
                        LOOP
                           vGrpcode :=
                              APEX_JSON.GET_VARCHAR2 (
                                 p_path   => 'data[' || i || '].USER_ID');
                           vProgCode :=
                              APEX_JSON.GET_VARCHAR2 (
                                 p_path   => 'data[' || i || '].PROGCODE');

                           BEGIN
                              INSERT
                                INTO GUMS.SYRIGHTS_USER (USER_ID,
                                                         PROGCODE,
                                                         CREATE_BY)
                                 VALUES (
                                           vKeyCoumnValue,
                                           vProgCode,
                                           GUMS.PKG_GLOBAL_OBJECTS.GET_USER_ID_BY_CODE (
                                              pRunUser));
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 RAISE;
                           END;

                           FOR j IN 1 .. 5
                           LOOP
                              IF vProgCode IS NOT NULL
                              THEN
                                 SELECT PARENTCODE
                                   INTO vProgCode
                                   FROM GUMS.SYMENTRE
                                  WHERE PROGCODE = vProgCode;

                                 IF vProgCode IS NOT NULL
                                 THEN
                                    SELECT COUNT (1)
                                      INTO vCount2
                                      FROM GUMS.SYRIGHTS_USER
                                     WHERE     USER_ID = vKeyCoumnValue
                                           AND PROGCODE = vProgCode;

                                    IF vCount2 = 0
                                    THEN
                                       BEGIN
                                          INSERT
                                            INTO GUMS.SYRIGHTS_USER (
                                                    USER_ID,
                                                    PROGCODE,
                                                    CREATE_BY)
                                             VALUES (
                                                       vKeyCoumnValue,
                                                       vProgCode,
                                                       GUMS.PKG_GLOBAL_OBJECTS.GET_USER_ID_BY_CODE (
                                                          pRunUser));
                                       EXCEPTION
                                          WHEN OTHERS
                                          THEN
                                             RAISE;
                                       END;
                                    END IF;
                                 END IF;
                              END IF;
                           END LOOP;
                        END LOOP;
                     END IF;
                  END IF;
               END;
            END;
         ELSE
            BEGIN
               REQUEST_CHANGE_APPROVAL (
                  pRecordIdentifier   => pRecordIdentifier,
                  pKeyColumn          => vKeyColumn,
                  pKeyColValue        => vKeyCoumnValue,
                  pTableName          => vTableName,
                  pRunUser            => pRunUser,
                  pTaskID             => pTaskID,
                  pErrorFlag          => pErrorFlag,
                  pErrorMessage       => pErrorMessage);
            EXCEPTION
               WHEN OTHERS
               THEN
                  pErrorMessage :=
                        'Record Update Process Calling Problem'
                     || REPLACE (SQLERRM, 'ORA-', 'Error:');
                  RAISE vMyException;
            END;

            IF NVL (pErrorFlag, 'N') = 'Y'
            THEN
               RAISE vMyException;
            END IF;
         END IF;
      END IF;

      BEGIN
         UPDATE GUMS.MB_REQUEST_CHANGE_LOG_RIGHTS
            SET status = 'A', APPROVE_BY = pRunUser, APPROVE_DATE = SYSDATE
          WHERE RECORD_IDENTIFIER = pRecordIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage :=
                  ' MB_REQUEST_CHANGE_LOG_RIGHTS Update Problem:'
               || REPLACE (SQLERRM, 'ORA-', 'Error:');
            RAISE vMyException;
      END;
   EXCEPTION
      WHEN vMyException
      THEN
         ROLLBACK;
         pErrorFlag := 'Y';
   END;

   PROCEDURE REQUEST_INCLUDE_LOG (
      pTableName            VARCHAR2,
      pRequestPurpose       VARCHAR2,
      pPageId               NUMBER,
      pPageName             VARCHAR2,
      pRunUser              VARCHAR2,
      pSessionId            VARCHAR,
      pBranchCode           VARCHAR2 DEFAULT NULL,
      pDetailInfo           VARCHAR2 DEFAULT NULL,
      pRecIdentifier    OUT NUMBER,
      pSchemaName           VARCHAR2 DEFAULT 'GUMS',
      pRequestStatus        VARCHAR2 DEFAULT 'R',
      pNewData              CLOB,
      pRetData          OUT CLOB,
      pErrorFlag        OUT VARCHAR2,
      pErrorMessage     OUT VARCHAR2)
   IS
      vCount           NUMBER;
      vOldValue        VARCHAR2 (1024);
      vRecIdenKey      NUMBER;
      vMyException     EXCEPTION;
      vDbColumn        VARCHAR2 (1024);
      vNewValue        VARCHAR2 (1024);
      vItemName        VARCHAR2 (1024);
      vDbDataType      VARCHAR2 (1024);
      l_count          NUMBER;
      l_json_obj       JSON_OBJECT_T;
      l_new_data_arr   JSON_ARRAY_T;
      vVisible         VARCHAR2 (10);
      vBreak           VARCHAR2 (1024);
      vDmlType         VARCHAR2 (10) := 'Y';
   BEGIN
      pErrorFlag := 'N';

      --INSERT INTO GUMS.A (DATA_CLOB) VALUES (pNewData);
      BEGIN
         SELECT COUNT (*)
           INTO vCount
           FROM GUMS.MB_REQUEST_CHANGE_LOG
          WHERE     UPPER (TABLE_NAME) = UPPER (pTableName)
                AND STATUS = 'R'
                AND REQUEST_FOR = 'I'
                AND REQUEST_PAGE_ID = pPageId;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage :=
               'Old Request Finding Problem in Change Request Log.';
            RAISE vMyException;
      END;


      IF vCount > 0
      THEN
         pErrorMessage :=
            'Already Have an Active Request. Plz Authorized this First ..';
         RAISE vMyException;
      END IF;


      vRecIdenKey := GUMS.REQ_RECORD_IDENTIFIER.NEXTVAL;
      pRecIdentifier := vRecIdenKey;

      /* l_json_obj := JSON_OBJECT_T (pNewData);
      l_new_data_arr := l_json_obj.get_array ('PAYLOAD');


      FOR i IN 0 .. l_new_data_arr.get_size - 1
      LOOP
          l_json_obj := TREAT (l_new_data_arr.get (i) AS JSON_OBJECT_T);
          vDbColumn := l_json_obj.get_string ('DB_COLUMN');
          vNewValue := l_json_obj.get_string ('NEW_VALUE');
          vItemName := l_json_obj.get_string ('ITEM_NAME');
          vDbDataType := l_json_obj.get_string ('DB_DATA_TYPE');
          vVisible := l_json_obj.get_string ('DISPLAY');
          vDmlType := l_json_obj.get_string ('DML_TYPE');*/



      apex_json.parse (pNewData);

      -- Get the number of array elements in PAYLOAD
      l_count := apex_json.get_count (p_path => 'PAYLOAD');

      FOR i IN 1 .. l_count
      LOOP
         vDbColumn :=
            apex_json.get_varchar2 (p_path => 'PAYLOAD[%d].DB_COLUMN', p0 => i);
         vNewValue :=
            apex_json.get_varchar2 (p_path => 'PAYLOAD[%d].NEW_VALUE', p0 => i);
         vItemName :=
            apex_json.get_varchar2 (p_path => 'PAYLOAD[%d].ITEM_NAME', p0 => i);
         vDbDataType :=
            apex_json.get_varchar2 (p_path   => 'PAYLOAD[%d].DB_DATA_TYPE',
                                    p0       => i);
         vVisible :=
            apex_json.get_varchar2 (p_path => 'PAYLOAD[%d].DISPLAY', p0 => i);
         vDmlType :=
            apex_json.get_varchar2 (p_path => 'PAYLOAD[%d].DML_TYPE', p0 => i);


         IF NVL (vDmlType, 'Y') != 'N'
         THEN
            BEGIN
               INSERT INTO GUMS.MB_REQUEST_CHANGE_LOG (LOG_ID,
                                                       TABLE_NAME,
                                                       COL_NAME,
                                                       NEW_VAL,
                                                       OLD_VALUE,
                                                       APEX_LEVEL,
                                                       DB_DATA_TYPE,
                                                       STATUS,
                                                       REQUEST_PURPOSE,
                                                       REQUEST_PAGE_ID,
                                                       REQUEST_PAGE_NAME,
                                                       REQUEST_FOR,
                                                       SESSION_ID,
                                                       RECORD_IDENTIFIER,
                                                       MASTER_RECORD,
                                                       SCHEMA_NAME,
                                                       APP_ID,
                                                       CREATE_BY,
                                                       branch_code)
                    VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                            pTableName,
                            vDbColumn,
                            vNewValue,
                            vOldValue,
                            vItemName,
                            vDbDataType,
                            pRequestStatus,
                            pRequestPurpose,
                            pPageId,
                            pPageName,
                            'I',
                            pSessionId,
                            vRecIdenKey,
                            'M',
                            pSchemaName,
                            102,
                            pRunUser,
                            pBranchCode);
            EXCEPTION
               WHEN OTHERS
               THEN
                  pErrorMessage :=
                        'change request log insert problem in include log.'
                     || REPLACE (SQLERRM, 'ORA-', 'Error:');
                  RAISE vMyException;
            END;

            IF pRetData IS NOT NULL
            THEN
               vBreak := '<br><br>';
            END IF;

            IF vVisible = 'Y'
            THEN
               pRetData :=
                     pRetData
                  || vBreak
                  || 'Entity Name: '
                  || vItemName
                  || '<br>New Value: '
                  || vNewValue;
            END IF;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorFlag := 'Y';
         ROLLBACK;
   END;

   PROCEDURE REQUEST_INCLUDE_APPROVAL (
      pRecIdentifier       NUMBER,
      pRunUser             VARCHAR2,
      pTaskID              NUMBER DEFAULT NULL,
      pErrorFlag       OUT VARCHAR2,
      pErrorMessage    OUT VARCHAR2)
   IS
      vColList         VARCHAR2 (2048);
      vValueList       VARCHAR2 (2048);
      vStatStr         VARCHAR2 (2048);
      vSchemaName      VARCHAR2 (1024);
      vMyException     EXCEPTION;
      vTableName       VARCHAR2 (1048);
      vKeyColumn       VARCHAR2 (1048);
      vKeyCoumnValue   VARCHAR2 (1048);
      vNoticeInfo      CLOB;
      vFileName        VARCHAR2 (1024);
      vFileType        VARCHAR2 (1024);
      vBlobContent     BLOB;
      vKeyvalueImg     NUMBER;
      vCountExs        NUMBER;
      v_sql            VARCHAR2(3000);

      CURSOR c1
      IS
         SELECT col_name, new_val, db_data_type
           FROM GUMS.MB_Request_Change_LOG x
          WHERE     UPPER (table_name) = UPPER (vTableName)
                AND status = 'R'
                AND request_for = 'I'
                AND record_identifier = pRecIdentifier;
   BEGIN
      BEGIN
         SELECT DISTINCT TABLE_NAME,
                         KEY_COL_NAME,
                         KEY_COL_VALUE,
                         SCHEMA_NAME
           INTO vTableName,
                vKeyColumn,
                vKeyCoumnValue,
                vSchemaName
           FROM GUMS.MB_REQUEST_CHANGE_LOG
          WHERE RECORD_IDENTIFIER = pRecIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage := 'Uniquie Identifier Finding Problem';
            RAISE vMyException;
      END;

      IF vTableName = 'MB_USER_MST'
      THEN
         DECLARE
            vRequestJson   CLOB;
            vCreateBy      VARCHAR2 (1024);
            vCreateDate    DATE;
            VappLink       VARCHAR2 (1024);
         BEGIN
            SELECT REQUEST_CLOB, CREATE_BY, CREATE_DATE
              INTO vRequestJson, vCreateBy, vCreateDate
              FROM MB_REQUEST_CHANGE_LOG
             WHERE RECORD_IDENTIFIER = pRecIdentifier;

            SELECT APP_LINK_LOCAL
              INTO VappLink
              FROM MB_GLOBAL_RULE
             WHERE ROWNUM = 1;

            apex_json.parse (vRequestJson);


            BEGIN
               PRC_CREATE_USER (
                  p_user_login_id   => apex_json.get_varchar2 ('LogInId'),
                  p_user_name       => apex_json.get_varchar2 ('UserName'),
                  p_user_dob        => TO_DATE (
                                         apex_json.get_varchar2 ('UserDob'),
                                         'YYYY-MM-DD'),
                  p_mobile_no       => apex_json.get_varchar2 ('MobileNo'),
                  p_email_id        => apex_json.get_varchar2 ('Email'),
                  p_branch          => apex_json.get_varchar2 ('BranchCode'),
                  pCreateBy         => vCreateBy,
                  pCreateDate       => vCreateDate,
                  pTaskId           => pTaskID,
                  p_ai_user_id      => pRunUser,                -- :AI_USER_ID
                  p_role_json       => vRequestJson, -- :ROLE (JSON with Roles array)
                  p_ai_app_link     => VappLink,  --'http://10.20.26.11:8888',
                  pErrorFlag        => pErrorFlag,
                  pErrorMsg         => pErrorMessage);
            EXCEPTION
               WHEN OTHERS
               THEN
                  pErrorMessage :=
                     'User Creation Process Calling Problem' || SQLERRM;
                  RAISE vMyException;
            END;

            IF NVL (pErrorFlag, 'N') = 'Y'
            THEN
               RAISE vMyException;
            END IF;
         END;
      ELSE
         FOR i IN c1
         LOOP
            IF vColList IS NOT NULL AND i.col_name IS NOT NULL
            THEN
               vColList := vColList || ',';
               vValueList := vValueList || ',';
            END IF;


            IF i.DB_DATA_TYPE = 'NUMBER'
            THEN
               vColList := vColList || i.col_name;
               vValueList := vValueList || i.new_val;
            ELSE
               vColList := vColList || i.col_name;
               vValueList := vValueList || '''' || i.new_val || '''';
            END IF;
         END LOOP;

         FOR r
            IN (SELECT COLUMN_NAME
                  FROM ALL_TAB_COLUMNS
                 WHERE     TABLE_NAME = UPPER (vTableName)
                       AND COLUMN_NAME LIKE '%REMARKS%')
         LOOP
            IF INSTR (',' || vColList || ',', ',' || r.COLUMN_NAME || ',') =
                  0
            THEN
               vColList := vColList || ',' || r.COLUMN_NAME;
               vValueList :=
                     vValueList
                  || ',('
                  || 'SELECT LISTAGG(text, '','') '
                  || 'FROM apex_task_comments '
                  || 'WHERE task_id = '
                  || NVL (TO_CHAR (pTaskID), 'NULL')
                  || ')';
            END IF;
         END LOOP;

         DECLARE
            vHasUpdateBy   NUMBER;
            vHasAuthBy     NUMBER;
         BEGIN
            SELECT COUNT (*)
              INTO vHasUpdateBy
              FROM ALL_TAB_COLUMNS
             WHERE     TABLE_NAME = UPPER (vTableName)
                   AND COLUMN_NAME = 'UPDATE_BY';

            SELECT COUNT (*)
              INTO vHasAuthBy
              FROM ALL_TAB_COLUMNS
             WHERE     TABLE_NAME = UPPER (vTableName)
                   AND COLUMN_NAME = 'AUTH_BY';

            IF     vHasUpdateBy > 0
               AND INSTR (',' || vColList || ',', ',UPDATE_BY,') = 0
            THEN
               vColList := vColList || ',UPDATE_BY';
               vValueList := vValueList || ',''' || pRunUser || '''';
            END IF;

            IF     vHasAuthBy > 0
               AND INSTR (',' || vColList || ',', ',AUTH_BY,') = 0
            THEN
               vColList := vColList || ',AUTH_BY';
               vValueList := vValueList || ',''' || pRunUser || '''';
            END IF;
         END;


         BEGIN
            SELECT    'Insert into '
                   || ' '
                   || vSchemaName
                   || '.'
                   || vTableName
                   || ' '
                   || '('
                   || ' '
                   || vColList
                   || ' '
                   || ')'
                   || ' values'
                   || ' '
                   || '('
                   || ' '
                   || vValueList
                   || ' '
                   || ')'
              INTO vStatStr
              FROM DUAL;
         END;

         BEGIN
            EXECUTE IMMEDIATE (vStatStr);
         EXCEPTION
            WHEN OTHERS
            THEN
               pErrorMessage :=
                     'Insert problem in Table-'
                  || pRecIdentifier
                  || REPLACE (SQLERRM, 'ORA-', 'Error:');

               RAISE vMyException;
         END;

         ----IF image are available---
         IF vTableName = 'ST_NOTICE_INFO'
         THEN
            BEGIN
               SELECT DISTINCT KEY_COL_VALUE
                 INTO vKeyvalueImg
                 FROM GUMS.MB_APP_IMG_REQUEST_CHANGE_LOG
                WHERE RECORD_IDENTIFIER = pRecIdentifier;
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
            

            BEGIN
               -- Fetch the latest NOTICE_INFO value if present
               SELECT NEW_VAL_CLOB
                 INTO vNoticeInfo
                 FROM GUMS.MB_APP_IMG_REQUEST_CHANGE_LOG
                WHERE     RECORD_IDENTIFIER = pRecIdentifier
                      AND KEY_COL_VALUE = vKeyvalueImg
                      AND TRIM (COL_NAME) = 'NOTICE_INFO'
                      AND NEW_VAL_CLOB IS NOT NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  vNoticeInfo := NULL;
            END;

            BEGIN
               -- Fetch the latest BLOB_CONTENT if present
               SELECT NEW_VAL_BLOB, FILE_NAME, MIME_TYPE
                 INTO vBlobContent, vFileName, vFileType
                 FROM GUMS.MB_APP_IMG_REQUEST_CHANGE_LOG
                WHERE     RECORD_IDENTIFIER = pRecIdentifier
                      AND KEY_COL_VALUE = vKeyvalueImg
                      AND TRIM (COL_NAME) = 'BLOB_CONTENT'
                      AND NEW_VAL_BLOB IS NOT NULL;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  vBlobContent := NULL;
            END;

            UPDATE GUMS.ST_NOTICE_INFO
               SET NOTICE_INFO = COALESCE (vNoticeInfo, NOTICE_INFO),
                   BLOB_CONTENT = COALESCE (vBlobContent, BLOB_CONTENT),
                   FILE_TYPE = COALESCE (vFileType, FILE_TYPE),
                   FILE_NAME = COALESCE (vFileName, FILE_NAME),
                   AUTH_BY = pRunUser,
                   AUTH_DATE = SYSDATE,
                   UPDATE_BY = pRunUser,
                   UPDATE_DATE = SYSDATE
             WHERE NOTICE_ID = vKeyvalueImg;
         END IF;
      END IF;

      BEGIN
         UPDATE GUMS.MB_REQUEST_CHANGE_LOG
            SET status = 'A', APPROVE_BY = pRunUser, APPROVE_DATE = SYSDATE
          WHERE     status = 'R'
                AND REQUEST_FOR = 'I'
                AND RECORD_IDENTIFIER = pRecIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage :=
                  'Upate problem  in MB_REQUEST_CHANGE_LOG Table:'
               || ':'
               || REPLACE (SQLERRM, 'ORA-', 'Error:');
            RAISE vMyException;
      END;
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorFlag := 'Y';
         ROLLBACK;
   END;

   PROCEDURE REQUEST_REJECT (pRecIdentifier       NUMBER,
                             pRunUser             VARCHAR2,
                             pTaskID              NUMBER DEFAULT NULL,
                             pErrorFlag       OUT VARCHAR2,
                             pErrorMessage    OUT VARCHAR2)
   IS
      vMyException   EXCEPTION;
      vCommntCount   NUMBER;
      vCommentText   VARCHAR2 (500);
   BEGIN
      SELECT COUNT (*)
        INTO vCommntCount
        FROM apex_task_comments
       WHERE task_id = pTaskID;

      BEGIN
         SELECT SUBSTR (LISTAGG (text, ', '), 1, 499)
           INTO vCommentText
           FROM apex_task_comments
          WHERE task_id = pTaskID;
      EXCEPTION
         WHEN OTHERS
         THEN
            NULL;
      END;

      IF vCommntCount <= 0
      THEN
         pErrorMessage := 'Remarks needed for Rejection';
         RAISE vMyException;
      END IF;


      BEGIN
         UPDATE GUMS.MB_REQUEST_CHANGE_LOG
            SET status = 'D',
                APPROVE_BY = pRunUser,
                APPROVE_DATE = SYSDATE,
                REMARKS = vCommentText
          WHERE RECORD_IDENTIFIER = pRecIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage := 'Reject Status Update Problem.';
            RAISE vMyException;
      END;

      BEGIN
         UPDATE GUMS.MB_REQUEST_CHANGE_LOG_RIGHTS
            SET status = 'D',
                APPROVE_BY = pRunUser,
                APPROVE_DATE = SYSDATE,
                REMARKS = vCommentText
          WHERE RECORD_IDENTIFIER = pRecIdentifier;
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage := 'Reject Status Update Problem.';
            RAISE vMyException;
      END;
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorFlag := 'Y';
         ROLLBACK;
   END;

   PROCEDURE PRC_CREATE_USER (p_user_login_id   IN     VARCHAR2,
                              p_user_name       IN     VARCHAR2,
                              p_user_dob        IN     DATE,
                              p_mobile_no       IN     VARCHAR2,
                              p_email_id        IN     VARCHAR2,
                              p_branch          IN     VARCHAR2,
                              pCreateBy         IN     VARCHAR2,
                              pCreateDate       IN     DATE,
                              pTaskId           IN     NUMBER,
                              p_ai_user_id      IN     NUMBER,  -- :AI_USER_ID
                              p_role_json       IN     CLOB, -- :ROLE (JSON with Roles array)
                              p_ai_app_link     IN     VARCHAR2, -- :AI_APP_LINK (base URL)
                              pErrorFlag           OUT VARCHAR2,
                              pErrorMsg            OUT VARCHAR2)
   AS
      vUserId                PLS_INTEGER;
      vPass                  VARCHAR2 (50);
      vPassword              VARCHAR2 (20);
      l_count                NUMBER;
      vUserLoginId           VARCHAR2 (50) := p_user_login_id;
      vMobileNo              VARCHAR2 (20) := p_mobile_no;
      vUser                  PLS_INTEGER := p_ai_user_id;
      vMyException           EXCEPTION;
      l_plsql_code_sms       CLOB := q'#
DECLARE
   vErrorFlag      VARCHAR2 (1);
   vErrorMessage   VARCHAR2 (1024);
BEGIN
   BEGIN
      EMOB.ALL_SMS_GENERATION.SMS_GENERATION_DYNAMIC (
         pCustomerCode   => NULL,
         pAccountNo      => NULL,
         pMobileNo       => :MOBILE,
         pMessageType    => 'USERAPP',
         pRunUser        => :USER_ID,
         p1              => UPPER ( :USER_LOGIN),
         p2              => :PASS,
         pErrorFlag      => vErrorFlag,
         pErrorMessage   => vErrorMessage);
   EXCEPTION
      WHEN OTHERS
      THEN
         RAISE;
   END;

   IF vErrorFlag = 'Y'
   THEN
      RAISE_APPLICATION_ERROR (-20001, vErrorMessage);
   END IF;
END;#';

      l_response_body        CLOB;
      vError                 VARCHAR2 (1024);
      vImage                 CLOB;
      vInputBody             CLOB;
      vMsg                   VARCHAR2 (50);
      l_sql_parameters_sms   apex_exec.t_parameters;
   BEGIN
      ------------------------------------------------------------------
      -- Generate new USER_ID
      ------------------------------------------------------------------
      SELECT MAX (USER_ID) + 1
        INTO vUserId
        FROM GUMS.MB_USER_MST;

      ------------------------------------------------------------------
      -- Generate random password (6 digits)
      ------------------------------------------------------------------
      SELECT LPAD (TRUNC (DBMS_RANDOM.VALUE ('000001', '999999')), 6, 0)
        INTO vPassword
        FROM DUAL;

      ------------------------------------------------------------------
      -- Encrypt password
      ------------------------------------------------------------------
      vPass :=
         GUMS.DPK_SECURITY.DFN_CREATE_PASSWORD_ENCRYPTED (
            UPPER (p_user_login_id) || vUserId,
            vPassword);

      ------------------------------------------------------------------
      -- Get temporary image (CLOB) from TEMPORARY_IMAGE table
      ------------------------------------------------------------------
      BEGIN
         SELECT IMAGE
           INTO vImage
           FROM GUMS.TEMPORARY_IMAGE
          WHERE     KEY_COLUMN_VALUE = UPPER (p_user_login_id)
                AND KEY_COLUMN_NAME = 'USER_CODE'
                AND SERVICE_TYPE = 'USER_CREATE';
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMsg := 'Temporary Image Finding Problem';
            RAISE vMyException;
      END;


      ------------------------------------------------------------------
      -- Insert into MB_USER_MST
      ------------------------------------------------------------------
      BEGIN
         INSERT INTO GUMS.MB_USER_MST (USER_ID,
                                       USER_CODE,
                                       USER_NAME,
                                       USER_PWD,
                                       USER_DOB,
                                       MOBILE_NO,
                                       EMAIL_ID,
                                       INV_LOGIN_CNT,
                                       LOGON_PASS_CHANGE,
                                       BRANCH_CODE,
                                       CREATE_BY,
                                       CREATE_DATE,
                                       AUTH_BY,
                                       AUTH_REMARKS)
                 VALUES (
                           vUserId,
                           UPPER (p_user_login_id),
                           p_user_name,
                           vPass,
                           p_user_dob,
                           p_mobile_no,
                           p_email_id,
                           0,
                           'Y',
                           p_branch,
                           GUMS.PKG_GLOBAL_OBJECTS.GET_USER_ID_BY_CODE (
                              pCreateBy),
                           pCreateDate,
                           p_ai_user_id,
                           (SELECT LISTAGG (text, ', ')
                              FROM apex_task_comments
                             WHERE task_id = pTaskId));
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMsg := 'User Creation Problem';
            RAISE vMyException;
      END;

      ------------------------------------------------------------------
      -- Insert Roles into MB_USER_GRP from JSON p_role_json
      -- JSON format: { "Roles": [ { "Role_Code": "...", "Role_Name": "..." }, ... ] }
      ------------------------------------------------------------------
      apex_json.parse (p_role_json);
      l_count := apex_json.get_count ('Role.Roles');

      FOR i IN 1 .. l_count
      LOOP
         INSERT INTO GUMS.MB_USER_GRP (USER_ID,
                                       GROUP_CODE,
                                       CREATE_BY,
                                       CREATE_DATE)
                 VALUES (
                           vUserId,
                           apex_json.get_varchar2 (
                              p_path   => 'Role.Roles[%d].Role_Code',
                              p0       => i),
                           GUMS.PKG_GLOBAL_OBJECTS.GET_USER_ID_BY_CODE (
                              pCreateBy),
                           pCreateDate);
      END LOOP;

      ------------------------------------------------------------------
      -- Prepare JSON body for image service
      ------------------------------------------------------------------
      vInputBody :=
         '{"USER_ID":"' || vUserId || '",' || '"IMAGE":"' || vImage || '"}';

      ------------------------------------------------------------------
      -- Call REST service to push user image
      ------------------------------------------------------------------
      apex_web_service.g_request_headers (1).name := 'content-type';
      apex_web_service.g_request_headers (1).VALUE := 'application/json';

      l_response_body :=
         apex_web_service.make_rest_request (
            p_url                =>    p_ai_app_link
                                    || '/psb/psbimg/imgsrc/user-image/insert/user-image',
            p_http_method        => 'POST',
            p_transfer_timeout   => 60,
            p_body               => vInputBody);

      ------------------------------------------------------------------
      -- Parse REST response
      ------------------------------------------------------------------
      apex_json.parse (l_response_body);
      vMsg := apex_json.get_varchar2 (p_path => 'MESSAGE');

      IF vMsg != 'SUCCESS'
      THEN
         RAISE_APPLICATION_ERROR (-20001, vMsg);
      END IF;

      ------------------------------------------------------------------
      -- Send SMS via remote PL/SQL
      ------------------------------------------------------------------
      apex_exec.ADD_PARAMETER (l_sql_parameters_sms,
                               'USER_LOGIN',
                               vUserLoginId);
      apex_exec.ADD_PARAMETER (l_sql_parameters_sms, 'MOBILE', vMobileNo);
      apex_exec.ADD_PARAMETER (l_sql_parameters_sms, 'USER_ID', vUser);
      apex_exec.ADD_PARAMETER (l_sql_parameters_sms, 'PASS', vPassword);

      apex_exec.execute_remote_plsql (
         p_server_static_id   => 'psbcore',
         p_plsql_code         => l_plsql_code_sms,
         p_auto_bind_items    => FALSE,
         p_sql_parameters     => l_sql_parameters_sms);

      ------------------------------------------------------------------
      -- Cleanup TEMPORARY_IMAGE
      ------------------------------------------------------------------
      DELETE FROM GUMS.TEMPORARY_IMAGE
            WHERE     KEY_COLUMN_VALUE = UPPER (p_user_login_id)
                  AND KEY_COLUMN_NAME = 'USER_CODE'
                  AND SERVICE_TYPE = 'USER_CREATE';
   EXCEPTION
      WHEN vMyException
      THEN
         -- Optional: you can log here if you have a logging table/package
         pErrorFlag := 'Y';
   END;

   PROCEDURE PRC_USER_INFO_CHANGE (
      -- User identity & basic info
      p_user_id               IN     VARCHAR2,
      p_user_name             IN     GUMS.MB_USER_MST.USER_NAME%TYPE,
      p_user_name_h           IN     GUMS.MB_USER_MST.USER_NAME%TYPE,
      p_dob                   IN     DATE,
      p_dob_h                 IN     DATE,
      p_mobile_no             IN     VARCHAR2,
      p_mobile_no_h           IN     VARCHAR2,
      p_email                 IN     GUMS.MB_USER_MST.EMAIL_ID%TYPE,
      p_email_h               IN     GUMS.MB_USER_MST.EMAIL_ID%TYPE,
      p_branch                IN     GUMS.MB_USER_MST.BRANCH_CODE%TYPE,
      p_branch_h              IN     GUMS.MB_USER_MST.BRANCH_CODE%TYPE,
      p_status                IN     GUMS.MB_USER_MST.USER_STS%TYPE,
      p_status_h              IN     GUMS.MB_USER_MST.USER_STS%TYPE,
      -- Role change JSON & old role snapshot
      p_role_old              IN     CLOB,
      p_role_change           IN     CLOB,
      -- Image flag (equivalent of :IMAGE item; value unused except NULL check)
      p_image_flag            IN     CLOB,
      -- APEX approval/task context
      p_apex_task_id          IN     NUMBER,
      p_apex_task_subject     IN     VARCHAR2,
      p_apex_task_initiator   IN     VARCHAR2,
      -- Application context
      p_app_user              IN     VARCHAR2,
      p_ai_user_id            IN     NUMBER,
      p_ai_app_link           IN     VARCHAR2,
      pErrorFlag                 OUT VARCHAR2,
      pErrorMsg                  OUT VARCHAR2)
   IS
      vOldValue         CLOB;
      vNewValue         CLOB;
      vCount            PLS_INTEGER;
      vCount2           PLS_INTEGER;
      vInputBody        CLOB;
      vImage            CLOB;
      l_response_body   CLOB;
      vOldImage         CLOB;
      vMsg              VARCHAR2 (200);
      vCountMst         PLS_INTEGER;
      vMyException      EXCEPTION;
   BEGIN
      -------------------------------------------------------------------------
      -- 1. Update MB_USER_MST when core fields changed + log to UPDATE_LOG
      -------------------------------------------------------------------------



      IF    p_user_name != p_user_name_h
         OR TO_DATE (p_dob, 'DD-MON-RRRR') <>
               TO_DATE (p_dob_h, 'DD-MON-RRRR')
         OR p_mobile_no != p_mobile_no_h
         OR p_email != p_email_h
         OR p_branch != p_branch_h
         OR p_status != p_status_h
      THEN
         vOldValue :=
            GUMS.GET_JSON (pSchemaName       => 'GUMS',
                           pTableName        => 'MB_USER_MST',
                           pKeyColumnName    => 'USER_ID',
                           pKeyColumnValue   => p_user_id);


         UPDATE GUMS.MB_USER_MST
            SET USER_NAME = p_user_name,
                USER_DOB = TO_DATE (p_dob, 'DD-MON-RRRR'),
                MOBILE_NO = p_mobile_no,
                EMAIL_ID = p_email,
                BRANCH_CODE = p_branch,
                USER_STS = p_status,
                AUTH_REMARKS =
                   (SELECT LISTAGG (text, ', ')
                      FROM apex_task_comments
                     WHERE task_id = p_apex_task_id),
                UPDATE_BY = p_ai_user_id,
                UPDATE_DATE = SYSDATE
          WHERE USER_ID = p_user_id;

         vNewValue :=
            GUMS.GET_JSON (pSchemaName       => 'GUMS',
                           pTableName        => 'MB_USER_MST',
                           pKeyColumnName    => 'USER_ID',
                           pKeyColumnValue   => p_user_id);
      END IF;


      -------------------------------------------------------------------------
      -- 2. Role changes: update MB_USER_GRP + log to UPDATE_LOG
      -------------------------------------------------------------------------
      IF p_role_old != p_role_change
      THEN
         -- Delete groups not present in new role JSON
         BEGIN
            DELETE FROM GUMS.MB_USER_GRP
                  WHERE     USER_ID = p_user_id
                        AND GROUP_CODE NOT IN
                               (SELECT Role_Code AS GROUP_CODE
                                  FROM (WITH json_data
                                             AS (SELECT p_role_change
                                                           AS json_str
                                                   FROM DUAL)
                                        SELECT jt.*
                                          FROM json_data,
                                               JSON_TABLE (
                                                  json_str, '$.Roles[*]'
                                                  COLUMNS (Role_Code NUMBER
                                                              PATH '$.Role_Code',
                                                           Role_Name VARCHAR2 (50)
                                                              PATH '$.Role_Name'))
                                               jt));
         EXCEPTION
            WHEN OTHERS
            THEN
               pErrorMsg := 'Role Update Problem';
               RAISE vMyException;
         END;


         -- Insert new groups if not already present
         FOR i
            IN (SELECT Role_Code AS GROUP_CODE
                  FROM (WITH json_data
                             AS (SELECT p_role_change AS json_str FROM DUAL)
                        SELECT jt.*
                          FROM json_data,
                               JSON_TABLE (
                                  json_str, '$.Roles[*]'
                                  COLUMNS (Role_Code NUMBER
                                              PATH '$.Role_Code',
                                           Role_Name VARCHAR2 (50)
                                              PATH '$.Role_Name')) jt))
         LOOP
            SELECT COUNT (1)
              INTO vCountMst
              FROM GUMS.MB_USER_GRP
             WHERE USER_ID = p_user_id AND GROUP_CODE = i.GROUP_CODE;

            IF vCountMst = 0
            THEN
               BEGIN
                  INSERT INTO GUMS.MB_USER_GRP (USER_ID,
                                                GROUP_CODE,
                                                CREATE_BY,
                                                CREATE_DATE,
                                                UPDATE_BY,
                                                UPDATE_DATE)
                          VALUES (
                                    p_user_id,
                                    i.GROUP_CODE,
                                    GUMS.PKG_GLOBAL_OBJECTS.GET_USER_ID_BY_CODE (
                                       p_apex_task_initiator),
                                    (SELECT created_on
                                       FROM TABLE (
                                               apex_approval.get_tasks (
                                                  p_context   => 'SINGLE_TASK',
                                                  p_task_id   => p_apex_task_id))),
                                    p_ai_user_id,
                                    SYSDATE);
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     RAISE;
               END;
            END IF;
         END LOOP;
      END IF;


      -------------------------------------------------------------------------
      -- 3. Image update via REST service + log to UPDATE_LOG
      -------------------------------------------------------------------------
      IF p_image_flag IS NOT NULL
      THEN
         -- Get image from TEMPORARY_IMAGE
         BEGIN
            SELECT IMAGE
              INTO vImage
              FROM GUMS.TEMPORARY_IMAGE
             WHERE     KEY_COLUMN_VALUE = p_user_id
                   AND KEY_COLUMN_NAME = 'USER_ID'
                   AND SERVICE_TYPE = 'USER_CHANGE';
         EXCEPTION
            WHEN OTHERS
            THEN
               RAISE;
         END;

         -- Check if an image already exists in MEMIMG.USER_IMAGE
         BEGIN
            SELECT COUNT (1)
              INTO vCount2
              FROM JSON_TABLE (
                      GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_MEMIMG_REST_ENABLED_SQL (
                            'SELECT USER_IMAGE FROM MEMIMG.USER_IMAGE WHERE USER_ID = '
                         || p_user_id),
                      '$.items[0].resultSet.items[*]'
                      COLUMNS (USER_IMAGE CLOB PATH '$.user_image'));
            EXCEPTION
                WHEN OTHERS
                THEN
                    RAISE;
            END;

            IF vCount2 != 0
            THEN
                -- Existing image: get old image and send TYPE:"UPDATE"
                BEGIN
                    SELECT USER_IMAGE
                      INTO vOldImage
                      FROM JSON_TABLE (
                               GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_MEMIMG_REST_ENABLED_SQL (
                                      'SELECT USER_IMAGE FROM MEMIMG.USER_IMAGE WHERE USER_ID = '
                                   || p_user_id),
                               '$.items[0].resultSet.items[*]'
                               COLUMNS (USER_IMAGE CLOB PATH '$.user_image'));
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        RAISE;
                END;

                vInputBody :=
                       '{"TYPE":"UPDATE","USER_ID":"'
                    || p_user_id
                    || '",'
                    || '"IMAGE":"'
                    || vImage
                    || '"'
                    || '}';
            ELSE
                -- No existing image: simple insert JSON
                vInputBody :=
                       '{"USER_ID":"'
                    || p_user_id
                    || '",'
                    || '"IMAGE":"'
                    || vImage
                    || '"'
                    || '}';
            END IF;

            -- Call REST service
            BEGIN
                apex_web_service.g_request_headers (1).name := 'content-type';
                apex_web_service.g_request_headers (1).VALUE :=
                    'application/json';

                l_response_body :=
                    apex_web_service.make_rest_request (
                        p_url                =>
                               p_ai_app_link
                            || '/psb/psbimg/imgsrc/user-image/insert/user-image',
                        p_http_method        => 'POST',
                        p_transfer_timeout   => 60,
                        p_body               => vInputBody);
            EXCEPTION
                WHEN OTHERS
                THEN
                    RAISE;
            END;

            -- Parse response
            APEX_JSON.PARSE (l_response_body);
            vMsg := APEX_JSON.GET_VARCHAR2 (p_path => 'MESSAGE');

            IF vMsg != 'SUCCESS'
            THEN
                RAISE_APPLICATION_ERROR (-20001, vMsg);
            END IF;


            -- Clean temp image
            BEGIN
                DELETE FROM
                    GUMS.TEMPORARY_IMAGE
                      WHERE     KEY_COLUMN_VALUE = p_user_id
                            AND KEY_COLUMN_NAME = 'USER_ID'
                            AND SERVICE_TYPE = 'USER_CHANGE';
            EXCEPTION
                WHEN OTHERS
                THEN
                    RAISE;
            END;
        END IF;
   EXCEPTION WHEN vMyException
   THEN
   pErrorFlag:='Y';
   END;
END;
/


DROP PACKAGE BODY GUMS.PKG_DPS_AC_CASH_TRANSACTION;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_DPS_AC_CASH_TRANSACTION
IS
    PROCEDURE PRC_DPS_CASH_INFO (pAcTypeId             NUMBER,
                                pAcId                 NUMBER,
                                pOprBranch            VARCHAR2,
                                pTimePeriod       OUT NUMBER,
                                pDueIns           OUT NUMBER,
                                pPaidIns          OUT NUMBER,
                                pInsAmount        OUT NUMBER,
                                pDpsTotalInsAmt   OUT NUMBER,
                                pDpsInsPenal      OUT NUMBER,
                                pTotalAmt         OUT NUMBER,
                                pChargeCrGlAc     OUT VARCHAR2,
                                pEffDate          OUT VARCHAR2,
                                pErrorFlag        OUT VARCHAR2,
                                pErrorMessage     OUT VARCHAR2)
   IS
      vUrl           VARCHAR2 (1024);
      vResponse      CLOB;
      vRequest       CLOB;
      vMyException   EXCEPTION;
   BEGIN
      SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

      vUrl :=
            vUrl
         || '/psb/psbcore/coresrc/pkg_dps_ac_cash_transaction/PRC_DPS_CASH_INFO';

      vRequest := '{
    "pactypeid": '  || pAcTypeId || ',
    "pacid": '      || pAcId || ',
    "poprbranch": "' || pOprBranch || '"
}'     ;

      BEGIN
         APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
         APEX_WEB_SERVICE.g_request_headers (1).VALUE := 'application/json';
         vResponse :=
            APEX_WEB_SERVICE.MAKE_REST_REQUEST (p_url                => vUrl,
                                                p_http_method        => 'POST',
                                                p_body               => vRequest,
                                                p_transfer_timeout   => 30);
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage := 'Core API Calling Problem.';
            RAISE vMyException;
      END;

      apex_json.parse (vResponse);
      pTimePeriod := apex_json.get_varchar2 ('ptimeperiod');
      pDueIns := apex_json.get_varchar2 ('pdueins');
      pPaidIns := apex_json.get_varchar2 ('ppaidins');
      pInsAmount := apex_json.get_varchar2 ('pinsamount');
      pDpsTotalInsAmt := apex_json.get_varchar2 ('pdpstotalinsamt');
      pDpsInsPenal := apex_json.get_varchar2 ('pdpsinspenal');
      pTotalAmt := apex_json.get_varchar2 ('ptotalamt');
      pChargeCrGlAc := apex_json.get_varchar2 ('pchargecrglac');
      pEffDate := apex_json.get_varchar2 ('peffdate');
      pErrorFlag := apex_json.get_varchar2 ('perrorflag');
      pErrorMessage := apex_json.get_varchar2 ('perrormessage');
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorFlag := 'Y';
   END;
END;
/


DROP PACKAGE BODY GUMS.PKG_FDR_PRODUCT;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_FDR_PRODUCT
IS
    PROCEDURE GET_FDR_SERVICE_INFO_API (pModuleDate       IN     VARCHAR2,
                                        pAcTypeId         IN     NUMBER,
                                        pInstallAmt       IN     NUMBER,
                                        pTermPeriod       IN     NUMBER,
                                        pIntRate             OUT NUMBER,
                                        pMaturityDate        OUT VARCHAR2,
                                        pMaturityAmount      OUT NUMBER,
                                        pErrorFlag           OUT VARCHAR2,
                                        pErrorMessage        OUT VARCHAR2)
    IS
        vUrl        VARCHAR2 (1024);
        vResponse   CLOB;
        vRequest    CLOB;
    BEGIN
        -- Initialize
        pErrorFlag := 'N';
        pErrorMessage := NULL;
        pIntRate := NULL;
        pMaturityDate := NULL;
        pMaturityAmount := NULL;

        -- Get API URL
        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl :=
                   vUrl
                || '/psb/psbcore/coresrc/fdr_process/PRC_FDR_PRODUCT_DETAIL';
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Y';
                pErrorMessage := 'API URL Finding Problem: ' || SQLERRM;
                RETURN;
        END;

        -- Prepare JSON Request
        vRequest :=
               '{'
            || '"pmoduledate": "'
            || pModuleDate
            || '",'
            || '"pactypeid": '
            || TO_CHAR (pAcTypeId)
            || ','
            || '"pinstallamt": '
            || TO_CHAR (pInstallAmt)
            || ','
            || '"ptermperiod": '
            || TO_CHAR (pTermPeriod)
            || '}';

        -- Call Core API
        BEGIN
            APEX_WEB_SERVICE.g_request_headers.DELETE;

            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';

            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';

            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Y';
                pErrorMessage := 'Core API Calling Problem: ' || SQLERRM;
                RETURN;
        END;

        -- Parse API Response
        BEGIN
            APEX_JSON.parse (vResponse);

            pErrorFlag := NVL (APEX_JSON.get_varchar2 ('perrorflag'), 'N');

            pErrorMessage := APEX_JSON.get_varchar2 ('perrormessage');

            IF pErrorFlag = 'Y'
            THEN
                RETURN;
            END IF;

            -- Read successful response
            pIntRate := APEX_JSON.get_number ('pintrate');

            pMaturityDate := APEX_JSON.get_varchar2 ('pmaturitydate');

            pMaturityAmount := APEX_JSON.get_number ('pmaturityamount');
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Y';
                pErrorMessage := 'API Response Parsing Problem: ' || SQLERRM;
                RETURN;
        END;
    EXCEPTION
        WHEN OTHERS
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := 'FDR Service API Problem: ' || SQLERRM;
    END GET_FDR_SERVICE_INFO_API;



    PROCEDURE POST_FDR_ACCOUNT_CREATION_API (pModuleDate     IN     VARCHAR2,
                                             pBranchCode     IN     VARCHAR2,
                                             pAcTypeId       IN     NUMBER,
                                             pAcTitle        IN     VARCHAR2,
                                             pCustno         IN     NUMBER,
                                             pMaturityIns    IN     VARCHAR2,
                                             pInstallAmt     IN     NUMBER,
                                             pInsFrq         IN     VARCHAR2,
                                             pInterestRate   IN     NUMBER,
                                             pTermPeriod     IN     NUMBER,
                                             pTimeFrq        IN     VARCHAR2,
                                             pMaturityDate   IN     VARCHAR2,
                                             pMaturityAmt    IN     NUMBER,
                                             pLinkAcDr       IN     VARCHAR2,
                                             pAiUserId       IN     VARCHAR2,
                                             pAcId              OUT NUMBER,
                                             pAcNo              OUT VARCHAR2,
                                             pErrorFlag         OUT VARCHAR2,
                                             pErrorMessage      OUT VARCHAR2)
    IS
        vUrl           VARCHAR2 (1024);
        vResponse      CLOB;
        vRequest       CLOB;
        vJson          CLOB;
        vMyException   EXCEPTION;
    BEGIN
        pErrorFlag := 'N';
        pErrorMessage := NULL;
        pAcId := NULL;
        pAcNo := NULL;


        BEGIN
            APEX_JSON.initialize_clob_output;

            APEX_JSON.open_object;

            APEX_JSON.open_array ('NOMINEES');

            FOR r
                IN (  SELECT a.c001                    AS member_code,
                             a.c003                    AS nominee_name,
                             a.c004                    AS fathers_name,
                             a.c005                    AS mother_name,
                             a.c006                    AS relation,
                             a.c007                    AS document_type,
                             a.c008                    AS document_no,
                             a.d001                    AS dob,
                             a.n001                    AS nomi_percent,
                             (SELECT clob001
                               FROM apex_collections i
                              WHERE     i.collection_name = 'NOMINEE'
                                    AND i.c002 = 'NOMIMG'
                                    AND i.c003 = a.c003
                                    AND i.c001 = a.c001
                                    AND ROWNUM = 1)    AS nomimg,
                             (SELECT clob001
                               FROM apex_collections i
                              WHERE     i.collection_name = 'NOMINEE'
                                    AND i.c002 = 'DOCFRNT'
                                    AND i.c003 = a.c003
                                    AND i.c001 = a.c001
                                    AND ROWNUM = 1)    AS docfrnt,
                             (SELECT clob001
                               FROM apex_collections i
                              WHERE     i.collection_name = 'NOMINEE'
                                    AND i.c002 = 'DOCBACK'
                                    AND i.c003 = a.c003
                                    AND i.c001 = a.c001
                                    AND ROWNUM = 1)    AS docback
                        FROM apex_collections a
                       WHERE a.collection_name = 'NOMINEE' AND a.c001 = pCustno
                    GROUP BY a.c001,
                             a.c003,
                             a.c004,
                             a.c005,
                             a.c006,
                             a.c007,
                             a.c008,
                             a.d001,
                             a.n001)
            LOOP
                APEX_JSON.open_object;

                APEX_JSON.write ('member_code', r.member_code);
                APEX_JSON.write ('nominee_name', r.nominee_name);
                APEX_JSON.write ('fathers_name', r.fathers_name);
                APEX_JSON.write ('mother_name', r.mother_name);
                APEX_JSON.write ('relation', r.relation);
                APEX_JSON.write ('document_type', r.document_type);
                APEX_JSON.write ('document_no', r.document_no);

                APEX_JSON.write ('dob', TO_CHAR (r.dob, 'YYYY-MM-DD'));

                APEX_JSON.write ('nomi_percent', r.nomi_percent);

                IF r.nomimg IS NOT NULL
                THEN
                    APEX_JSON.write ('nominee_image', r.nomimg);
                ELSE
                    APEX_JSON.write ('nominee_image', '');
                END IF;

                IF r.docfrnt IS NOT NULL
                THEN
                    APEX_JSON.write ('doc_front', r.docfrnt);
                ELSE
                    APEX_JSON.write ('doc_front', '');
                END IF;

                IF r.docback IS NOT NULL
                THEN
                    APEX_JSON.write ('doc_back', r.docback);
                ELSE
                    APEX_JSON.write ('doc_back', '');
                END IF;

                APEX_JSON.close_object;
            END LOOP;

            APEX_JSON.close_array;

            APEX_JSON.close_object;

            vJson := APEX_JSON.get_clob_output;

            APEX_JSON.free_output;
        EXCEPTION
            WHEN OTHERS
            THEN
                APEX_JSON.free_output;

                pErrorFlag := 'Y';

                pErrorMessage := 'Nominee JSON Build Problem. ' || SQLERRM;

                RAISE vMyException;
        END;


        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/fdr_process/PRC_FDR_ACCOUNT_CREATION';

        BEGIN
            APEX_JSON.initialize_clob_output;

            APEX_JSON.open_object;
            APEX_JSON.write ('pmoduledate', pModuleDate);
            APEX_JSON.write ('pbranchcode', pBranchCode);
            APEX_JSON.write ('pactypeid', pAcTypeId);
            APEX_JSON.write ('pactitle', pAcTitle);
            APEX_JSON.write ('pcustno', pCustno);
            APEX_JSON.write ('pmaturityins', pMaturityIns);
            APEX_JSON.write ('pinstallamt', pInstallAmt);
            APEX_JSON.write ('pinsfrq', pInsFrq);
            APEX_JSON.write ('pinterestrate', pInterestRate);
            APEX_JSON.write ('ptermperiod', pTermPeriod);
            APEX_JSON.write ('ptimefrq', pTimeFrq);
            APEX_JSON.write ('pmaturitydate', pMaturityDate);
            APEX_JSON.write ('pmaturityamt', pMaturityAmt);
            APEX_JSON.write ('plinkacdr', pLinkAcDr);
            APEX_JSON.write ('paiuserid', pAiUserId);
            APEX_JSON.write ('pnomineejson', vJson);
            APEX_JSON.close_object;

            vRequest := apex_json.get_clob_output;

            APEX_JSON.free_output;
        EXCEPTION
            WHEN OTHERS
            THEN
                APEX_JSON.free_output;

                pErrorFlag := 'Y';

                pErrorMessage := 'Json Build Problem. ' || SQLERRM;

                RAISE vMyException;
        END;



        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';

            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';


            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        --
        --      RAISE_APPLICATION_ERROR (
        --                -20001,
        --                   'HTTP STATUS: '
        --                || APEX_WEB_SERVICE.g_status_code
        --                || CHR (10)
        --                || 'RESPONSE: '
        --                || DBMS_LOB.SUBSTR (vResponse, 2000, 1));

        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorFlag := 'Y';

                pErrorMessage := 'Core API Calling Problem. ' || SQLERRM;

                RAISE vMyException;
        END;


        BEGIN
            APEX_JSON.parse (vResponse);

            pErrorFlag := APEX_JSON.get_varchar2 ('perrorflag');

            pErrorMessage := APEX_JSON.get_varchar2 ('perrormessage');

            pAcId := APEX_JSON.get_number ('pacid');

            pAcNo := APEX_JSON.get_varchar2 ('pacno');


            IF NVL (pErrorFlag, 'N') = 'Y'
            THEN
                RAISE vMyException;
            END IF;
        EXCEPTION
            WHEN vMyException
            THEN
                RAISE;
            WHEN OTHERS
            THEN
                pErrorFlag := 'Y';

                pErrorMessage := 'Response Parsing Problem. ' || SQLERRM;

                RAISE vMyException;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
        WHEN OTHERS
        THEN
            pErrorFlag := 'Y';

            pErrorMessage := SQLERRM;
    END POST_FDR_ACCOUNT_CREATION_API;



    PROCEDURE FDR_CLOSE_CALCULATION_API (pmoduledate         IN     DATE,
                                         pbranchcode         IN     VARCHAR2,
                                         pacno               IN     VARCHAR2,
                                         pacid                  OUT NUMBER,
                                         pactypeid              OUT NUMBER,
                                         paccounttitle          OUT VARCHAR2,
                                         popendate              OUT VARCHAR2,
                                         plinkacno              OUT NUMBER,
                                         pmobileno              OUT VARCHAR2,
                                         pfdrtermmonths         OUT VARCHAR2,
                                         pmaturerate            OUT NUMBER,
                                         pmaturitydate          OUT VARCHAR2,
                                         pdpsbalance            OUT NUMBER,
                                         pincometax             OUT NUMBER,
                                         pexciseduty            OUT NUMBER,
                                         pprovision             OUT NUMBER,
                                         pneedprovision         OUT NUMBER,
                                         preverseprovision      OUT NUMBER,
                                         pprofitpayable         OUT NUMBER,
                                         ptotalpayable          OUT NUMBER,
                                         perrorflag             OUT VARCHAR2,
                                         perrormessage          OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
               vUrl
            || '/psb/psbcore/coresrc/fdr_process/PRC_FDR_CLOSE_CALCULATION';

        vRequest :=
               '{'
            || '"pmoduledate": "'
            || TO_CHAR (pmoduledate, 'DD-MON-YYYY')
            || '",'
            || '"pbranchcode": "'
            || pbranchcode
            || '",'
            || '"pacno": "'
            || pacno
            || '"'
            || '}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';

            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem. ' || SQLERRM;
                RAISE vMyException;
        END;

        APEX_JSON.PARSE (vResponse);
        perrorflag := APEX_JSON.GET_VARCHAR2 ('perrorflag');
        vErrorMessage := APEX_JSON.GET_VARCHAR2 ('perrormessage');

        IF NVL (perrorflag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pacid := APEX_JSON.GET_NUMBER ('pacid');
        pactypeid := APEX_JSON.GET_NUMBER ('pactypeid');
        paccounttitle := APEX_JSON.GET_VARCHAR2 ('paccounttitle');
        popendate := APEX_JSON.GET_VARCHAR2 ('popendate');
        plinkacno := APEX_JSON.GET_NUMBER ('plinkacno');
        pfdrtermmonths := APEX_JSON.GET_VARCHAR2 ('pfdrtermmonths');
        pmobileno := APEX_JSON.GET_VARCHAR2 ('pmobileno');
        pmaturerate := APEX_JSON.GET_NUMBER ('pmaturerate');
        pmaturitydate := APEX_JSON.GET_VARCHAR2 ('pmaturitydate');
        pdpsbalance := APEX_JSON.GET_NUMBER ('pdpsbalance');
        pincometax := APEX_JSON.GET_NUMBER ('pincometax');
        pexciseduty := APEX_JSON.GET_NUMBER ('pexciseduty');
        pprovision := APEX_JSON.GET_NUMBER ('pprovision');
        pneedprovision := APEX_JSON.GET_NUMBER ('pneedprovision');
        preverseprovision := APEX_JSON.GET_NUMBER ('preverseprovision');
        pprofitpayable := APEX_JSON.GET_NUMBER ('pprofitpayable');
        ptotalpayable := APEX_JSON.GET_NUMBER ('ptotalpayable');
    EXCEPTION
        WHEN vMyException
        THEN
            perrorflag := 'Y';
            perrormessage := vErrorMessage;
        WHEN OTHERS
        THEN
            perrorflag := 'Y';
            perrormessage := SQLERRM;
    END;


    PROCEDURE FDR_CLOSE_REQUEST_API (pModuleDate         IN     DATE,
                                     pBranchCode         IN     VARCHAR2,
                                     pAcNo               IN     VARCHAR2,
                                     pAcTypeId           IN     NUMBER,
                                     pAcId               IN     NUMBER,
                                     pClosingReason      IN     VARCHAR2,
                                     pAiUserId           IN     VARCHAR2,
                                     pAccountTitle       IN     VARCHAR2,
                                     pOpenDate           IN     DATE,
                                     pLinkAcNo           IN     NUMBER,
                                     pMobileNo           IN     VARCHAR2,
                                     pMatureRate         IN     NUMBER,
                                     pMaturityDate       IN     DATE,
                                     pDpsBalance         IN     NUMBER,
                                     pIncomeTax          IN     NUMBER,
                                     pExciseDuty         IN     NUMBER,
                                     pProvision          IN     NUMBER,
                                     pNeedProvision      IN     NUMBER,
                                     pReverseProvision   IN     NUMBER,
                                     pProfitpayable      IN     NUMBER,
                                     pTotalPayable       IN     NUMBER,
                                     pErrorFlag             OUT VARCHAR2,
                                     pErrorMessage          OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
            vUrl || '/psb/psbcore/coresrc/fdr_process/PRC_FDR_CLOSE_REQUEST';
        vRequest :=
               '{'
            || '"pmoduledate": "'
            || pModuleDate
            || '",'
            || '"pbranchcode": "'
            || pBranchCode
            || '",'
            || '"pacno": "'
            || pAcNo
            || '",'
            || '"pactypeid": "'
            || pAcTypeId
            || '",'
            || '"pacid": "'
            || pAcId
            || '",'
            || '"pclosingreason": "'
            || pClosingReason
            || '",'
            || '"paiuserid": "'
            || pAiUserId
            || '",'
            || '"paccounttitle": "'
            || pAccountTitle
            || '",'
            || '"popendate": "'
            || pOpenDate
            || '",'
            || '"plinkacno": "'
            || pLinkAcNo
            || '",'
            || '"pmobileno": "'
            || pMobileNo
            || '",'
            || '"pmaturerate": "'
            || pMatureRate
            || '",'
            || '"pmaturitydate": "'
            || pMaturityDate
            || '",'
            || '"pdpsbalance": "'
            || pDpsBalance
            || '",'
            || '"pincometax": "'
            || pIncomeTax
            || '",'
            || '"pexciseduty": "'
            || pExciseDuty
            || '",'
            || '"pprovision": "'
            || pProvision
            || '",'
            || '"pneedprovision": "'
            || pNeedProvision
            || '",'
            || '"preverseprovision": "'
            || pReverseProvision
            || '",'
            || '"pprofitpayable": "'
            || pProfitpayable
            || '",'
            || '"ptotalpayable": "'
            || pTotalPayable
            || '"'
            || '}';


        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';

            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem';
                RAISE vMyException;
        END;

        apex_json.parse (vResponse);
        pErrorFlag := apex_json.get_varchar2 ('perrorflag');
        vErrorMessage := apex_json.get_varchar2 ('perrormessage');

        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
        WHEN OTHERS
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := SQLERRM;
    END;

    PROCEDURE FDR_CLOSE_APPROVAL_API (pmoduledate     IN     DATE,
                                      pbranchcode     IN     VARCHAR2,
                                      pacid           IN     NUMBER,
                                      paiuserid       IN     VARCHAR2,
                                      pailogid        IN     VARCHAR2,
                                      papprovreject   IN     VARCHAR2,
                                      pDocNum            OUT VARCHAR2,
                                      perrorflag         OUT VARCHAR2,
                                      perrormessage      OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl :=
            vUrl || '/psb/psbcore/coresrc/fdr_process/PRC_FDR_CLOSE_APPROVAL';

        vRequest :=
               '{'
            || '"pmoduledate": "'
            || pmoduledate
            || '",'
            || '"pbranchcode": "'
            || pbranchcode
            || '",'
            || '"pacid": "'
            || pacid
            || '",'
            || '"paiuserid": "'
            || paiuserid
            || '",'
            || '"pailogid": "'
            || pailogid
            || '",'
            || '"papprovreject": "'
            || papprovreject
            || '"'
            || '}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';

            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem. ' || SQLERRM;
                RAISE vMyException;
        END;

        APEX_JSON.PARSE (vResponse);
        pdocnum := APEX_JSON.GET_VARCHAR2 ('pdocnum');
        perrorflag := APEX_JSON.GET_VARCHAR2 ('perrorflag');
        verrormessage := APEX_JSON.GET_VARCHAR2 ('perrormessage');

        IF NVL (perrorflag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            perrorflag := 'Y';
            perrormessage := vErrorMessage;
        WHEN OTHERS
        THEN
            perrorflag := 'Y';
            perrormessage := SQLERRM;
    END;



    PROCEDURE GET_FDR_ACC_INFO_API (
        pmoduledate               IN     DATE,
        pbranchcode               IN     VARCHAR2,
        pacno                     IN     VARCHAR2,
        pacid                        OUT NUMBER,
        pactypeid                    OUT NUMBER,
        paccounttitle                OUT VARCHAR2,
        pfulldesc                    OUT VARCHAR2,
        paccountstatus               OUT VARCHAR2,
        pmobileno                    OUT VARCHAR2,
        pcustno                      OUT NUMBER,
        psamiteecode                 OUT VARCHAR2,
        pmembercode                  OUT VARCHAR2,
        pmaturerate                  OUT NUMBER,
        pmaturitydate                OUT VARCHAR2,
        pmaturityamount              OUT NUMBER,
        pdepositamount               OUT NUMBER,
        pfdrtermmonths               OUT VARCHAR2,
        pfdrtermmonthsdis            OUT VARCHAR2,
        popendate                    OUT VARCHAR2,
        pmaturityinstructiondsc      OUT VARCHAR2,
        pmaturityinstruction         OUT VARCHAR2,
        perrorflag                   OUT VARCHAR2,
        perrormessage                OUT VARCHAR2)
    IS
        vUrl            VARCHAR2 (1024);
        vResponse       CLOB;
        vRequest        CLOB;
        vErrorMessage   VARCHAR2 (4000);
        vMyException    EXCEPTION;
    BEGIN
        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        vUrl := vUrl || '/psb/psbcore/coresrc/fdr_process/GET_FDR_ACC_INFO';

        vRequest :=
               '{'
            || '"pmoduledate": "'
            || TO_CHAR (pmoduledate, 'DD-MON-YYYY')
            || '",'
            || '"pbranchcode": "'
            || pbranchcode
            || '",'
            || '"pacno": "'
            || pacno
            || '"'
            || '}';

        BEGIN
            APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
            APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                'application/json';
            vResponse :=
                APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                    p_url                => vUrl,
                    p_http_method        => 'POST',
                    p_body               => vRequest,
                    p_transfer_timeout   => 30);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Core API Calling Problem. ' || SQLERRM;
                RAISE vMyException;
        END;

        APEX_JSON.PARSE (vResponse);
        perrorflag := APEX_JSON.GET_VARCHAR2 ('perrorflag');
        vErrorMessage := APEX_JSON.GET_VARCHAR2 ('perrormessage');

        IF NVL (perrorflag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;

        pacid := APEX_JSON.GET_NUMBER ('pacid');
        pactypeid := APEX_JSON.GET_NUMBER ('pactypeid');
        paccounttitle := APEX_JSON.GET_VARCHAR2 ('paccounttitle');
        pfulldesc := APEX_JSON.GET_VARCHAR2 ('pfulldesc');
        paccountstatus := APEX_JSON.GET_VARCHAR2 ('paccountstatus');
        pmobileno := APEX_JSON.GET_VARCHAR2 ('pmobileno');
        pcustno := APEX_JSON.GET_NUMBER ('pcustno');
        psamiteecode := APEX_JSON.GET_VARCHAR2 ('psamiteecode');
        pmembercode := APEX_JSON.GET_VARCHAR2 ('pmembercode');
        pmaturerate := APEX_JSON.GET_NUMBER ('pmaturerate');
        pmaturitydate := APEX_JSON.GET_VARCHAR2 ('pmaturitydate');
        pmaturityamount := APEX_JSON.GET_NUMBER ('pmaturityamount');
        pdepositamount := APEX_JSON.GET_NUMBER ('pdepositamount');
        pfdrtermmonths := APEX_JSON.GET_VARCHAR2 ('pfdrtermmonths');
        pfdrtermmonthsdis := APEX_JSON.GET_VARCHAR2 ('pfdrtermmonthsdis');
        popendate := APEX_JSON.GET_VARCHAR2 ('popendate');
        pmaturityinstructiondsc :=
            APEX_JSON.GET_VARCHAR2 ('pmaturityinstructiondsc');
        pmaturityinstruction :=
            APEX_JSON.GET_VARCHAR2 ('pmaturityinstruction');
    EXCEPTION
        WHEN vMyException
        THEN
            perrorflag := 'Y';
            perrormessage := vErrorMessage;
        WHEN OTHERS
        THEN
            perrorflag := 'Y';
            perrormessage := 'Api Calling Error: ' || SQLERRM;
    END GET_FDR_ACC_INFO_API;
END PKG_FDR_PRODUCT;
/


DROP PACKAGE BODY GUMS.PKG_FETCH_FROM_REST;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_FETCH_FROM_REST
IS
    FUNCTION PRC_API_CALL_EMOB_REST_ENABLED_SQL (pSqltextclob CLOB)
        RETURN CLOB
    AS
        l_response   CLOB;
        vAppLink     VARCHAR2 (50);
    BEGIN
        SELECT APP_LINK_LOCAL INTO vAppLink FROM GUMS.MB_GLOBAL_RULE;

        --APEX_WEB_SERVICE.g_request_headers (1).name := 'Authorization';
        --APEX_WEB_SERVICE.g_request_headers (1).VALUE := 'Basic ZW1vYjplbW9i';
        APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
        APEX_WEB_SERVICE.g_request_headers (1).VALUE := 'application/sql';

        l_response :=
            APEX_WEB_SERVICE.make_rest_request (
                p_url           => vAppLink || '/psb/psbcore/coresrc/_/sql',
                p_http_method   => 'POST',
                p_username      => 'EMOB',
                p_password      => 'PsbEmob#321',
                p_body          => pSqltextclob);
        RETURN l_response;
    END;

    FUNCTION PRC_API_CALL_MEMIMG_REST_ENABLED_SQL (pSqltextclob CLOB)
        RETURN CLOB
    AS
        l_response   CLOB;
        vAppLink     VARCHAR2 (50);
    BEGIN
        SELECT APP_LINK_LOCAL INTO vAppLink FROM GUMS.MB_GLOBAL_RULE;

        APEX_WEB_SERVICE.g_request_headers (1).name := 'Authorization';
        APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
            'Basic bWVtaW1nOm1lbWltZw==';
        APEX_WEB_SERVICE.g_request_headers (2).name := 'Content-Type';
        APEX_WEB_SERVICE.g_request_headers (2).VALUE := 'application/sql';

        l_response :=
            APEX_WEB_SERVICE.make_rest_request (
                p_url           => vAppLink || '/psb/psbimg/imgsrc/_/sql',
                p_http_method   => 'POST',
                p_body          => pSqltextclob);
        RETURN l_response;
    END;

    FUNCTION GET_ACCOUNT_INFO
        RETURN ACCOUNT_INFO_TB
        PIPELINED
    IS
        vResponse    CLOB
            := PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                   'SELECT * FROM EMOB.MB_ACCOUNT_MST;');
        RETURN_REC   ACCOUNT_INFO_TB
                         := ACCOUNT_INFO_TB (NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL);
        IDX          NUMBER := 0;
    BEGIN
        FOR X
            IN (SELECT branch_code,
                       ac_type_id,
                       ac_id,
                       ac_no,
                       ac_title,
                       cust_no,
                       open_date,
                       close_date,
                       ac_status,
                       create_by,
                       create_date,
                       update_by,
                       update_date,
                       sector_code,
                       security_code,
                       economy_code,
                       final_check,
                       final_check_by,
                       final_check_date,
                       final_remarks,
                       ac_nature,
                       opr_ins,
                       last_provision_date,
                       asst_lib,
                       cl_status,
                       is_prov_allow,
                       old_ac_no,
                       loan_amount
                 FROM JSON_TABLE (
                          vResponse,
                          '$.items[0].resultSet.items[*]'
                          COLUMNS (
                              branch_code
                                  VARCHAR2 (4 BYTE)
                                  PATH '$.branch_code',
                              ac_type_id NUMBER PATH '$.ac_type_id',
                              ac_id NUMBER PATH '$.ac_id',
                              ac_no VARCHAR2 (16 BYTE) PATH '$.ac_no',
                              ac_title VARCHAR2 (200 BYTE) PATH '$.ac_title',
                              cust_no NUMBER PATH '$.cust_no',
                              open_date DATE PATH '$.open_date',
                              close_date DATE PATH '$.close_date',
                              ac_status VARCHAR2 (3 BYTE) PATH '$.ac_status',
                              create_by VARCHAR2 (50 BYTE) PATH '$.create_by',
                              create_date DATE PATH '$.create_date',
                              update_by VARCHAR2 (50 BYTE) PATH '$.update_by',
                              update_date DATE PATH '$.update_date',
                              sector_code
                                  VARCHAR2 (10 BYTE)
                                  PATH '$.sector_code',
                              security_code
                                  VARCHAR2 (5 BYTE)
                                  PATH '$.security_code',
                              economy_code
                                  VARCHAR2 (5 BYTE)
                                  PATH '$.economy_code',
                              final_check
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.final_check',
                              final_check_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.final_check_by',
                              final_check_date DATE PATH '$.final_check_date',
                              final_remarks
                                  VARCHAR2 (200 BYTE)
                                  PATH '$.final_remarks',
                              ac_nature VARCHAR2 (1 BYTE) PATH '$.ac_nature',
                              opr_ins VARCHAR2 (3 BYTE) PATH '$.opr_ins',
                              last_provision_date
                                  DATE
                                  PATH '$.last_provision_date',
                              asst_lib VARCHAR2 (1 BYTE) PATH '$.asst_lib',
                              cl_status VARCHAR2 (3 BYTE) PATH '$.cl_status',
                              is_prov_allow
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.is_prov_allow',
                              old_ac_no VARCHAR2 (16 BYTE) PATH '$.old_ac_no',
                              loan_amount NUMBER PATH '$.loan_amount'))
                      AccountInfo)
        LOOP
            IDX := IDX + 1;
            RETURN_REC.EXTEND (1);
            RETURN_REC (IDX).SL_NO := IDX;
            RETURN_REC (IDX).branch_code := X.branch_code;
            RETURN_REC (IDX).ac_type_id := X.ac_type_id;
            RETURN_REC (IDX).ac_id := X.ac_id;
            RETURN_REC (IDX).ac_no := X.ac_no;
            RETURN_REC (IDX).ac_title := X.ac_title;
            RETURN_REC (IDX).cust_no := X.cust_no;
            RETURN_REC (IDX).open_date := X.open_date;
            RETURN_REC (IDX).close_date := X.close_date;
            RETURN_REC (IDX).ac_status := X.ac_status;
            RETURN_REC (IDX).create_by := X.create_by;
            RETURN_REC (IDX).create_date := X.create_date;
            RETURN_REC (IDX).update_by := X.update_by;
            RETURN_REC (IDX).update_date := X.update_date;
            RETURN_REC (IDX).sector_code := X.sector_code;
            RETURN_REC (IDX).security_code := X.security_code;
            RETURN_REC (IDX).economy_code := X.economy_code;
            RETURN_REC (IDX).final_check := X.final_check;
            RETURN_REC (IDX).final_check_by := X.final_check_by;
            RETURN_REC (IDX).final_check_date := X.final_check_date;
            RETURN_REC (IDX).final_remarks := X.final_remarks;
            RETURN_REC (IDX).ac_nature := X.ac_nature;
            RETURN_REC (IDX).opr_ins := X.opr_ins;
            RETURN_REC (IDX).last_provision_date := X.last_provision_date;
            RETURN_REC (IDX).asst_lib := X.asst_lib;
            RETURN_REC (IDX).cl_status := X.cl_status;
            RETURN_REC (IDX).is_prov_allow := X.is_prov_allow;
            RETURN_REC (IDX).old_ac_no := X.old_ac_no;
            RETURN_REC (IDX).loan_amount := X.loan_amount;
        END LOOP;

        BEGIN
            FOR J IN 1 .. IDX
            LOOP
                PIPE ROW (RETURN_REC (J));
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN;
    END;

    FUNCTION GET_CUSTOMER_INFO
        RETURN CUSTOMER_INFO_TB
        PIPELINED
    IS
        vResponse    CLOB
            := PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                   'SELECT * FROM EMOB.MB_CUSTOMER_MST;');
        RETURN_REC   CUSTOMER_INFO_TB
                         := CUSTOMER_INFO_TB (NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL);
        IDX          NUMBER := 0;
    BEGIN
        FOR X
            IN (SELECT BRANCH_CODE,
                       SAMITEE_CODE,
                       CUST_NO,
                       MEMBER_CODE,
                       MEMBER_TYPE,
                       PARENT_MEMBER,
                       FIRST_NAME,
                       LAST_NAME,
                       FATHER_NAME,
                       MOTHER_NAME,
                       CUST_DOB,
                       GENDER,
                       MARITUAL_STATUS,
                       SPOUSE_NAME,
                       NATIONALITY,
                       NO_OF_CHILDREN,
                       SON,
                       DAUGHTER,
                       NO_OF_DEPENDANT,
                       RELIGIOUS_CODE,
                       LAST_EDUCATION,
                       CUST_STATUS,
                       OCCUPATION_CODE,
                       SECTOR_CODE,
                       EMPLOYEE_ID,
                       ANNUAL_INCOME,
                       SOURCE_OF_FUND,
                       IS_VERIFIED_SOF,
                       FUND_SOURCE,
                       RESIDENT_STATUS,
                       POLITICAL_EXPOSED,
                       INCOME_PERSON,
                       INCOME_MALE,
                       INCOME_FEMALE,
                       MEDIA,
                       LIVE_PERIOD,
                       HOME_DESC,
                       FAMILY_GUARDIAN,
                       FATHER_LAND,
                       REMARK,
                       CREATE_BY,
                       CREATE_DATE,
                       UPDATE_BY,
                       UPDATE_DATE,
                       CHECK_BY,
                       CHECK_DATE,
                       REVIEW_STATUS,
                       CLOSE_BY,
                       CLOSE_DATE,
                       MOBILE_NO,
                       MAIL_ID,
                       MOBILE_NO2,
                       IS_NID_VERIFIED,
                       NID_APPROVE_DATE,
                       NID_APPROVE_USER,
                       IS_DEAD,
                       DEATH_DATE,
                       DEATH_APPROVE_DATE,
                       DEATH_APPROVE_USER
                 FROM JSON_TABLE (
                          vResponse,
                          '$.items[0].resultSet.items[*]'
                          COLUMNS (
                              branch_code
                                  VARCHAR2 (7 BYTE)
                                  PATH '$.branch_code       ',
                              samitee_code
                                  VARCHAR2 (12 BYTE)
                                  PATH '$.samitee_code      ',
                              cust_no NUMBER PATH '$.cust_no           ',
                              member_code
                                  VARCHAR2 (11 BYTE)
                                  PATH '$.member_code       ',
                              member_type
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.member_type       ',
                              parent_member
                                  NUMBER
                                  PATH '$.parent_member     ',
                              first_name
                                  VARCHAR2 (100 BYTE)
                                  PATH '$.first_name        ',
                              last_name
                                  VARCHAR2 (60 BYTE)
                                  PATH '$.last_name         ',
                              father_name
                                  VARCHAR2 (60 BYTE)
                                  PATH '$.father_name       ',
                              mother_name
                                  VARCHAR2 (60 BYTE)
                                  PATH '$.mother_name       ',
                              cust_dob DATE PATH '$.cust_dob          ',
                              gender
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.gender            ',
                              maritual_status
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.maritual_status   ',
                              spouse_name
                                  VARCHAR2 (60 BYTE)
                                  PATH '$.spouse_name       ',
                              nationality
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.nationality       ',
                              no_of_children
                                  NUMBER
                                  PATH '$.no_of_children    ',
                              son NUMBER PATH '$.son               ',
                              daughter NUMBER PATH '$.daughter          ',
                              no_of_dependant
                                  NUMBER (3)
                                  PATH '$.no_of_dependant   ',
                              religious_code
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.religious_code    ',
                              last_education
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.last_education    ',
                              cust_status
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.cust_status       ',
                              occupation_code
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.occupation_code   ',
                              sector_code
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.sector_code       ',
                              employee_id
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.employee_id       ',
                              annual_income
                                  NUMBER
                                  PATH '$.annual_income     ',
                              source_of_fund
                                  NUMBER
                                  PATH '$.source_of_fund    ',
                              is_verified_sof
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.is_verified_sof   ',
                              fund_source
                                  VARCHAR2 (10 BYTE)
                                  PATH '$.fund_source       ',
                              resident_status
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.resident_status   ',
                              political_exposed
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.political_exposed ',
                              income_person
                                  NUMBER
                                  PATH '$.income_person     ',
                              income_male NUMBER PATH '$.income_male       ',
                              income_female
                                  NUMBER
                                  PATH '$.income_female     ',
                              media
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.media             ',
                              live_period NUMBER PATH '$.live_period       ',
                              home_desc
                                  VARCHAR2 (100 BYTE)
                                  PATH '$.home_desc         ',
                              family_guardian
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.family_guardian   ',
                              father_land
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.father_land       ',
                              REMARK
                                  VARCHAR2 (150 BYTE)
                                  PATH '$.remark            ',
                              create_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.create_by         ',
                              create_date DATE PATH '$.create_date       ',
                              update_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.update_by         ',
                              update_date DATE PATH '$.update_date       ',
                              check_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.check_by          ',
                              check_date DATE PATH '$.check_date        ',
                              review_status
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.review_status     ',
                              close_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.close_by          ',
                              close_date DATE PATH '$.close_date        ',
                              mobile_no
                                  VARCHAR2 (200 BYTE)
                                  PATH '$.mobile_no         ',
                              mail_id
                                  VARCHAR2 (200 BYTE)
                                  PATH '$.mail_id           ',
                              mobile_no2
                                  VARCHAR2 (30 BYTE)
                                  PATH '$.mobile_no2        ',
                              is_nid_verified
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.is_nid_verified   ',
                              nid_approve_date
                                  DATE
                                  PATH '$.nid_approve_date  ',
                              nid_approve_user
                                  VARCHAR2 (5 BYTE)
                                  PATH '$.nid_approve_user  ',
                              is_dead
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.is_dead           ',
                              death_date DATE PATH '$.death_date        ',
                              death_approve_date
                                  DATE
                                  PATH '$.death_approve_date',
                              death_approve_user
                                  VARCHAR2 (20 BYTE)
                                  PATH '$.death_approve_user')) CustInfo)
        LOOP
            IDX := IDX + 1;
            RETURN_REC.EXTEND (1);
            RETURN_REC (IDX).SL_NO := IDX;
            RETURN_REC (IDX).branch_code := X.branch_code;
            RETURN_REC (IDX).SAMITEE_CODE := X.SAMITEE_CODE;
            RETURN_REC (IDX).CUST_NO := X.CUST_NO;
            RETURN_REC (IDX).MEMBER_CODE := X.MEMBER_CODE;
            RETURN_REC (IDX).MEMBER_TYPE := X.MEMBER_TYPE;
            RETURN_REC (IDX).PARENT_MEMBER := X.PARENT_MEMBER;
            RETURN_REC (IDX).FIRST_NAME := X.FIRST_NAME;
            RETURN_REC (IDX).LAST_NAME := X.LAST_NAME;
            RETURN_REC (IDX).FATHER_NAME := X.FATHER_NAME;
            RETURN_REC (IDX).MOTHER_NAME := X.MOTHER_NAME;
            RETURN_REC (IDX).CUST_DOB := X.CUST_DOB;
            RETURN_REC (IDX).GENDER := X.GENDER;
            RETURN_REC (IDX).MARITUAL_STATUS := X.MARITUAL_STATUS;
            RETURN_REC (IDX).SPOUSE_NAME := X.SPOUSE_NAME;
            RETURN_REC (IDX).NATIONALITY := X.NATIONALITY;
            RETURN_REC (IDX).NO_OF_CHILDREN := X.NO_OF_CHILDREN;
            RETURN_REC (IDX).SON := X.SON;
            RETURN_REC (IDX).DAUGHTER := X.DAUGHTER;
            RETURN_REC (IDX).NO_OF_DEPENDANT := X.NO_OF_DEPENDANT;
            RETURN_REC (IDX).RELIGIOUS_CODE := X.RELIGIOUS_CODE;
            RETURN_REC (IDX).LAST_EDUCATION := X.LAST_EDUCATION;
            RETURN_REC (IDX).CUST_STATUS := X.CUST_STATUS;
            RETURN_REC (IDX).OCCUPATION_CODE := X.OCCUPATION_CODE;
            RETURN_REC (IDX).SECTOR_CODE := X.SECTOR_CODE;
            RETURN_REC (IDX).EMPLOYEE_ID := X.EMPLOYEE_ID;
            RETURN_REC (IDX).ANNUAL_INCOME := X.ANNUAL_INCOME;
            RETURN_REC (IDX).SOURCE_OF_FUND := X.SOURCE_OF_FUND;
            RETURN_REC (IDX).IS_VERIFIED_SOF := X.IS_VERIFIED_SOF;
            RETURN_REC (IDX).FUND_SOURCE := X.FUND_SOURCE;
            RETURN_REC (IDX).RESIDENT_STATUS := X.RESIDENT_STATUS;
            RETURN_REC (IDX).POLITICAL_EXPOSED := X.POLITICAL_EXPOSED;
            RETURN_REC (IDX).INCOME_PERSON := X.INCOME_PERSON;
            RETURN_REC (IDX).INCOME_MALE := X.INCOME_MALE;
            RETURN_REC (IDX).INCOME_FEMALE := X.INCOME_FEMALE;
            RETURN_REC (IDX).MEDIA := X.MEDIA;
            RETURN_REC (IDX).LIVE_PERIOD := X.LIVE_PERIOD;
            RETURN_REC (IDX).HOME_DESC := X.HOME_DESC;
            RETURN_REC (IDX).FAMILY_GUARDIAN := X.FAMILY_GUARDIAN;
            RETURN_REC (IDX).FATHER_LAND := X.FATHER_LAND;
            RETURN_REC (IDX).REMARK := X.REMARK;
            RETURN_REC (IDX).CREATE_BY := X.CREATE_BY;
            RETURN_REC (IDX).CREATE_DATE := X.CREATE_DATE;
            RETURN_REC (IDX).UPDATE_BY := X.UPDATE_BY;
            RETURN_REC (IDX).UPDATE_DATE := X.UPDATE_DATE;
            RETURN_REC (IDX).CHECK_BY := X.CHECK_BY;
            RETURN_REC (IDX).CHECK_DATE := X.CHECK_DATE;
            RETURN_REC (IDX).REVIEW_STATUS := X.REVIEW_STATUS;
            RETURN_REC (IDX).CLOSE_BY := X.CLOSE_BY;
            RETURN_REC (IDX).CLOSE_DATE := X.CLOSE_DATE;
            RETURN_REC (IDX).MOBILE_NO := X.MOBILE_NO;
            RETURN_REC (IDX).MAIL_ID := X.MAIL_ID;
            RETURN_REC (IDX).MOBILE_NO2 := X.MOBILE_NO2;
            RETURN_REC (IDX).IS_NID_VERIFIED := X.IS_NID_VERIFIED;
            RETURN_REC (IDX).NID_APPROVE_DATE := X.NID_APPROVE_DATE;
            RETURN_REC (IDX).NID_APPROVE_USER := X.NID_APPROVE_USER;
            RETURN_REC (IDX).IS_DEAD := X.IS_DEAD;
            RETURN_REC (IDX).DEATH_DATE := X.DEATH_DATE;
            RETURN_REC (IDX).DEATH_APPROVE_DATE := X.DEATH_APPROVE_DATE;
            RETURN_REC (IDX).DEATH_APPROVE_USER := X.DEATH_APPROVE_USER;
        END LOOP;

        BEGIN
            FOR J IN 1 .. IDX
            LOOP
                PIPE ROW (RETURN_REC (J));
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN;
    END;

    FUNCTION GET_CUSTOMER_INFO_BY_FILTER (pBranchCode    VARCHAR2,
                                          pSamiteeCode   VARCHAR2)
        RETURN CUSTOMER_INFO_TB
        PIPELINED
    IS

        vResponse    CLOB
            := PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                      ' SELECT * FROM EMOB.MB_CUSTOMER_MST WHERE BRANCH_CODE='''
                   || pBranchCode
                   || '''AND SAMITEE_CODE='''
                   || pSamiteeCode
                   || ''';');
        RETURN_REC   CUSTOMER_INFO_TB
                         := CUSTOMER_INFO_TB (NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL,
                                              NULL);
        IDX          NUMBER := 0;
    BEGIN
        FOR X
            IN (SELECT BRANCH_CODE,
                       SAMITEE_CODE,
                       CUST_NO,
                       MEMBER_CODE,
                       MEMBER_TYPE,
                       PARENT_MEMBER,
                       FIRST_NAME,
                       LAST_NAME,
                       FATHER_NAME,
                       MOTHER_NAME,
                       CUST_DOB,
                       GENDER,
                       MARITUAL_STATUS,
                       SPOUSE_NAME,
                       NATIONALITY,
                       NO_OF_CHILDREN,
                       SON,
                       DAUGHTER,
                       NO_OF_DEPENDANT,
                       RELIGIOUS_CODE,
                       LAST_EDUCATION,
                       CUST_STATUS,
                       OCCUPATION_CODE,
                       SECTOR_CODE,
                       EMPLOYEE_ID,
                       ANNUAL_INCOME,
                       SOURCE_OF_FUND,
                       IS_VERIFIED_SOF,
                       FUND_SOURCE,
                       RESIDENT_STATUS,
                       POLITICAL_EXPOSED,
                       INCOME_PERSON,
                       INCOME_MALE,
                       INCOME_FEMALE,
                       MEDIA,
                       LIVE_PERIOD,
                       HOME_DESC,
                       FAMILY_GUARDIAN,
                       FATHER_LAND,
                       REMARK,
                       CREATE_BY,
                       CREATE_DATE,
                       UPDATE_BY,
                       UPDATE_DATE,
                       CHECK_BY,
                       CHECK_DATE,
                       REVIEW_STATUS,
                       CLOSE_BY,
                       CLOSE_DATE,
                       MOBILE_NO,
                       MAIL_ID,
                       MOBILE_NO2,
                       IS_NID_VERIFIED,
                       NID_APPROVE_DATE,
                       NID_APPROVE_USER,
                       IS_DEAD,
                       DEATH_DATE,
                       DEATH_APPROVE_DATE,
                       DEATH_APPROVE_USER
                 FROM JSON_TABLE (
                          vResponse,
                          '$.items[0].resultSet.items[*]'
                          COLUMNS (
                              branch_code
                                  VARCHAR2 (7 BYTE)
                                  PATH '$.branch_code       ',
                              samitee_code
                                  VARCHAR2 (12 BYTE)
                                  PATH '$.samitee_code      ',
                              cust_no NUMBER PATH '$.cust_no           ',
                              member_code
                                  VARCHAR2 (11 BYTE)
                                  PATH '$.member_code       ',
                              member_type
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.member_type       ',
                              parent_member
                                  NUMBER
                                  PATH '$.parent_member     ',
                              first_name
                                  VARCHAR2 (100 BYTE)
                                  PATH '$.first_name        ',
                              last_name
                                  VARCHAR2 (60 BYTE)
                                  PATH '$.last_name         ',
                              father_name
                                  VARCHAR2 (60 BYTE)
                                  PATH '$.father_name       ',
                              mother_name
                                  VARCHAR2 (60 BYTE)
                                  PATH '$.mother_name       ',
                              cust_dob
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.cust_dob          ',
                              gender
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.gender            ',
                              maritual_status
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.maritual_status   ',
                              spouse_name
                                  VARCHAR2 (60 BYTE)
                                  PATH '$.spouse_name       ',
                              nationality
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.nationality       ',
                              no_of_children
                                  NUMBER
                                  PATH '$.no_of_children    ',
                              son NUMBER PATH '$.son               ',
                              daughter NUMBER PATH '$.daughter          ',
                              no_of_dependant
                                  NUMBER (3)
                                  PATH '$.no_of_dependant   ',
                              religious_code
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.religious_code    ',
                              last_education
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.last_education    ',
                              cust_status
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.cust_status       ',
                              occupation_code
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.occupation_code   ',
                              sector_code
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.sector_code       ',
                              employee_id
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.employee_id       ',
                              annual_income
                                  NUMBER
                                  PATH '$.annual_income     ',
                              source_of_fund
                                  NUMBER
                                  PATH '$.source_of_fund    ',
                              is_verified_sof
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.is_verified_sof   ',
                              fund_source
                                  VARCHAR2 (10 BYTE)
                                  PATH '$.fund_source       ',
                              resident_status
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.resident_status   ',
                              political_exposed
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.political_exposed ',
                              income_person
                                  NUMBER
                                  PATH '$.income_person     ',
                              income_male NUMBER PATH '$.income_male       ',
                              income_female
                                  NUMBER
                                  PATH '$.income_female     ',
                              media
                                  VARCHAR2 (3 BYTE)
                                  PATH '$.media             ',
                              live_period NUMBER PATH '$.live_period       ',
                              home_desc
                                  VARCHAR2 (100 BYTE)
                                  PATH '$.home_desc         ',
                              family_guardian
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.family_guardian   ',
                              father_land
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.father_land       ',
                              REMARK
                                  VARCHAR2 (150 BYTE)
                                  PATH '$.remark            ',
                              create_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.create_by         ',
                              create_date DATE PATH '$.create_date       ',
                              update_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.update_by         ',
                              update_date DATE PATH '$.update_date       ',
                              check_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.check_by          ',
                              check_date DATE PATH '$.check_date        ',
                              review_status
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.review_status     ',
                              close_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.close_by          ',
                              close_date DATE PATH '$.close_date        ',
                              mobile_no
                                  VARCHAR2 (200 BYTE)
                                  PATH '$.mobile_no         ',
                              mail_id
                                  VARCHAR2 (200 BYTE)
                                  PATH '$.mail_id           ',
                              mobile_no2
                                  VARCHAR2 (30 BYTE)
                                  PATH '$.mobile_no2        ',
                              is_nid_verified
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.is_nid_verified   ',
                              nid_approve_date
                                  DATE
                                  PATH '$.nid_approve_date  ',
                              nid_approve_user
                                  VARCHAR2 (5 BYTE)
                                  PATH '$.nid_approve_user  ',
                              is_dead
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.is_dead           ',
                              death_date DATE PATH '$.death_date        ',
                              death_approve_date
                                  DATE
                                  PATH '$.death_approve_date',
                              death_approve_user
                                  VARCHAR2 (20 BYTE)
                                  PATH '$.death_approve_user')) CustInfo)
        LOOP
            IDX := IDX + 1;
            RETURN_REC.EXTEND (1);
            RETURN_REC (IDX).SL_NO := IDX;
            RETURN_REC (IDX).branch_code := X.branch_code;
            RETURN_REC (IDX).SAMITEE_CODE := X.SAMITEE_CODE;
            RETURN_REC (IDX).CUST_NO := X.CUST_NO;
            RETURN_REC (IDX).MEMBER_CODE := X.MEMBER_CODE;
            RETURN_REC (IDX).MEMBER_TYPE := X.MEMBER_TYPE;
            RETURN_REC (IDX).PARENT_MEMBER := X.PARENT_MEMBER;
            RETURN_REC (IDX).FIRST_NAME := X.FIRST_NAME;
            RETURN_REC (IDX).LAST_NAME := X.LAST_NAME;
            RETURN_REC (IDX).FATHER_NAME := X.FATHER_NAME;
            RETURN_REC (IDX).MOTHER_NAME := X.MOTHER_NAME;
            RETURN_REC (IDX).CUST_DOB := X.CUST_DOB;
            RETURN_REC (IDX).GENDER := X.GENDER;
            RETURN_REC (IDX).MARITUAL_STATUS := X.MARITUAL_STATUS;
            RETURN_REC (IDX).SPOUSE_NAME := X.SPOUSE_NAME;
            RETURN_REC (IDX).NATIONALITY := X.NATIONALITY;
            RETURN_REC (IDX).NO_OF_CHILDREN := X.NO_OF_CHILDREN;
            RETURN_REC (IDX).SON := X.SON;
            RETURN_REC (IDX).DAUGHTER := X.DAUGHTER;
            RETURN_REC (IDX).NO_OF_DEPENDANT := X.NO_OF_DEPENDANT;
            RETURN_REC (IDX).RELIGIOUS_CODE := X.RELIGIOUS_CODE;
            RETURN_REC (IDX).LAST_EDUCATION := X.LAST_EDUCATION;
            RETURN_REC (IDX).CUST_STATUS := X.CUST_STATUS;
            RETURN_REC (IDX).OCCUPATION_CODE := X.OCCUPATION_CODE;
            RETURN_REC (IDX).SECTOR_CODE := X.SECTOR_CODE;
            RETURN_REC (IDX).EMPLOYEE_ID := X.EMPLOYEE_ID;
            RETURN_REC (IDX).ANNUAL_INCOME := X.ANNUAL_INCOME;
            RETURN_REC (IDX).SOURCE_OF_FUND := X.SOURCE_OF_FUND;
            RETURN_REC (IDX).IS_VERIFIED_SOF := X.IS_VERIFIED_SOF;
            RETURN_REC (IDX).FUND_SOURCE := X.FUND_SOURCE;
            RETURN_REC (IDX).RESIDENT_STATUS := X.RESIDENT_STATUS;
            RETURN_REC (IDX).POLITICAL_EXPOSED := X.POLITICAL_EXPOSED;
            RETURN_REC (IDX).INCOME_PERSON := X.INCOME_PERSON;
            RETURN_REC (IDX).INCOME_MALE := X.INCOME_MALE;
            RETURN_REC (IDX).INCOME_FEMALE := X.INCOME_FEMALE;
            RETURN_REC (IDX).MEDIA := X.MEDIA;
            RETURN_REC (IDX).LIVE_PERIOD := X.LIVE_PERIOD;
            RETURN_REC (IDX).HOME_DESC := X.HOME_DESC;
            RETURN_REC (IDX).FAMILY_GUARDIAN := X.FAMILY_GUARDIAN;
            RETURN_REC (IDX).FATHER_LAND := X.FATHER_LAND;
            RETURN_REC (IDX).REMARK := X.REMARK;
            RETURN_REC (IDX).CREATE_BY := X.CREATE_BY;
            RETURN_REC (IDX).CREATE_DATE := X.CREATE_DATE;
            RETURN_REC (IDX).UPDATE_BY := X.UPDATE_BY;
            RETURN_REC (IDX).UPDATE_DATE := X.UPDATE_DATE;
            RETURN_REC (IDX).CHECK_BY := X.CHECK_BY;
            RETURN_REC (IDX).CHECK_DATE := X.CHECK_DATE;
            RETURN_REC (IDX).REVIEW_STATUS := X.REVIEW_STATUS;
            RETURN_REC (IDX).CLOSE_BY := X.CLOSE_BY;
            RETURN_REC (IDX).CLOSE_DATE := X.CLOSE_DATE;
            RETURN_REC (IDX).MOBILE_NO := X.MOBILE_NO;
            RETURN_REC (IDX).MAIL_ID := X.MAIL_ID;
            RETURN_REC (IDX).MOBILE_NO2 := X.MOBILE_NO2;
            RETURN_REC (IDX).IS_NID_VERIFIED := X.IS_NID_VERIFIED;
            RETURN_REC (IDX).NID_APPROVE_DATE := X.NID_APPROVE_DATE;
            RETURN_REC (IDX).NID_APPROVE_USER := X.NID_APPROVE_USER;
            RETURN_REC (IDX).IS_DEAD := X.IS_DEAD;
            RETURN_REC (IDX).DEATH_DATE := X.DEATH_DATE;
            RETURN_REC (IDX).DEATH_APPROVE_DATE := X.DEATH_APPROVE_DATE;
            RETURN_REC (IDX).DEATH_APPROVE_USER := X.DEATH_APPROVE_USER;
        END LOOP;

        BEGIN
            FOR J IN 1 .. IDX
            LOOP
                PIPE ROW (RETURN_REC (J));
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN;
    END;

    FUNCTION GET_PRODUCT_INFO
        RETURN PRODUCT_INFO_TB
        PIPELINED
    IS
        vResponse    CLOB
            := PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                   'SELECT * FROM EMOB.MB_PRODUCT_MST;');
        RETURN_REC   PRODUCT_INFO_TB
                         := PRODUCT_INFO_TB (NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL);
        IDX          NUMBER := 0;
    BEGIN
        FOR X
            IN (SELECT AC_TYPE_ID,
                       ASST_LIB,
                       OPENING_DATE,
                       PRODUCT_CLASS,
                       AC_TYPE,
                       FULL_DESC,
                       SHORT_DESC,
                       CL_CAT_NO,
                       CL_SUB_CAT,
                       OVER_DUE_EXTEND,
                       MIN_SANC_AMT,
                       MAX_SANC_AMT,
                       TERM,
                       IS_VISIBLE,
                       GRACE_PERIOD_ALLOWED,
                       GRACE_PERIOD_MONTH,
                       IDGP,
                       ONLY_EMPLOYEE,
                       PRODUCT_GLAC_ID,
                       INCOME_GL_ACC,
                       PRV_DEBIT_GLAC_ID,
                       PRV_CREDIT_GLAC_ID,
                       ALLOW_DEBIT_BAL,
                       CHEQUE_ALLOW,
                       CREATE_BY,
                       CREATE_DATE,
                       CHECK_STATUS,
                       CHECK_BY,
                       CHECK_DATE,
                       DEP_NATURE,
                       REALIZATION_SEQ_PRINCIPLE,
                       REALIZATION_SEQ_INT,
                       REALIZATION_SEQ_CHARGE,
                       INT_POST_PERIOD,
                       INT_CAL_METHOD,
                       REALIZATION_SEQ_IOO,
                       REALIZATION_SEQ_PENAL_INT,
                       ALLOW_INT_PROVISION,
                       MIN_BAL,
                       TP_ALLOW,
                       INS_FREQUENCY,
                       MAX_DEFAULT_INS_ALLOW,
                       FINE_ALLOW,
                       INS_START_DAY,
                       INS_END_DAY,
                       INS_HOLIDAY_ALLOW,
                       DEFAULT_INS_MATURITY_ALLLOW,
                       GRACE_PERIOD_DAYS,
                       UPDATE_BY,
                       UPDATE_DATE,
                       DEATH_RISK_ALLOW,
                       LINK_AC_MANDATORY,
                       NID_VERIFY_REQ,
                       IS_MINOR
                 FROM JSON_TABLE (
                          vResponse,
                          '$.items[0].resultSet.items[*]'
                          COLUMNS (
                              ac_type_id NUMBER PATH '$.ac_type_id',
                              asst_lib VARCHAR2 (1) PATH '$.asst_lib',
                              opening_date DATE PATH '$.opening_date',
                              product_class
                                  VARCHAR2 (3)
                                  PATH '$.product_class',
                              ac_type VARCHAR2 (3) PATH '$.ac_type',
                              full_desc VARCHAR2 (100) PATH '$.full_desc',
                              short_desc VARCHAR2 (10) PATH '$.short_desc',
                              cl_cat_no VARCHAR2 (5) PATH '$.cl_cat_no',
                              cl_sub_cat VARCHAR2 (5) PATH '$.cl_sub_cat',
                              over_due_extend NUMBER PATH '$.over_due_extend',
                              min_sanc_amt NUMBER PATH '$.min_sanc_amt',
                              max_sanc_amt NUMBER PATH '$.max_sanc_amt',
                              term NUMBER PATH '$.term',
                              is_visible VARCHAR2 (1) PATH '$.is_visible',
                              grace_period_allowed
                                  VARCHAR2 (2)
                                  PATH '$.grace_period_allowed',
                              grace_period_month
                                  NUMBER
                                  PATH '$.grace_period_month',
                              idgp VARCHAR2 (2) PATH '$.idgp',
                              only_employee
                                  VARCHAR2 (10 BYTE)
                                  PATH '$.only_employee',
                              product_glac_id NUMBER PATH '$.product_glac_id',
                              income_gl_acc NUMBER PATH '$.income_gl_acc',
                              prv_debit_glac_id
                                  NUMBER
                                  PATH '$.prv_debit_glac_id',
                              prv_credit_glac_id
                                  NUMBER
                                  PATH '$.prv_credit_glac_id',
                              allow_debit_bal
                                  VARCHAR2 (1)
                                  PATH '$.allow_debit_bal',
                              cheque_allow VARCHAR2 (1) PATH '$.cheque_allow',
                              create_by VARCHAR2 (50) PATH '$.create_by',
                              create_date DATE PATH '$.create_date',
                              check_status VARCHAR2 (1) PATH '$.check_status',
                              check_by VARCHAR2 (50) PATH '$.check_by',
                              check_date DATE PATH '$.check_date',
                              dep_nature VARCHAR2 (1) PATH '$.dep_nature',
                              realization_seq_principle
                                  NUMBER (1)
                                  PATH '$.realization_seq_principle',
                              realization_seq_int
                                  NUMBER (1)
                                  PATH '$.realization_seq_int',
                              realization_seq_charge
                                  NUMBER (1)
                                  PATH '$.realization_seq_charge',
                              int_post_period
                                  VARCHAR2 (3)
                                  PATH '$.int_post_period',
                              int_cal_method
                                  VARCHAR2 (1)
                                  PATH '$.int_cal_method',
                              realization_seq_ioo
                                  NUMBER
                                  PATH '$.realization_seq_ioo',
                              realization_seq_penal_int
                                  NUMBER
                                  PATH '$.realization_seq_penal_int',
                              allow_int_provision
                                  VARCHAR2 (1)
                                  PATH '$.allow_int_provision',
                              min_bal NUMBER PATH '$.min_bal',
                              tp_allow VARCHAR2 (1) PATH '$.TP_ALLOW',
                              ins_frequency
                                  VARCHAR2 (1)
                                  PATH '$.ins_frequency',
                              max_default_ins_allow
                                  NUMBER (22)
                                  PATH '$.max_default_ins_allow',
                              fine_allow VARCHAR2 (1) PATH '$.fine_allow',
                              ins_start_day
                                  NUMBER (22)
                                  PATH '$.ins_start_day',
                              ins_end_day NUMBER (22) PATH '$.ins_end_day',
                              ins_holiday_allow
                                  VARCHAR2 (1)
                                  PATH '$.ins_holiday_allow',
                              default_ins_maturity_alllow
                                  VARCHAR2 (1)
                                  PATH '$.default_ins_maturity_alllow',
                              grace_period_days
                                  NUMBER (3)
                                  PATH '$.grace_period_days',
                              update_by VARCHAR2 (50) PATH '$.update_by',
                              update_date DATE PATH '$.update_date',
                              death_risk_allow
                                  VARCHAR2 (1)
                                  PATH '$.death_risk_allow',
                              link_ac_mandatory
                                  VARCHAR2 (1)
                                  PATH '$.link_ac_mandatory',
                              nid_verify_req
                                  VARCHAR2 (1)
                                  PATH '$.nid_verify_req',
                              is_minor VARCHAR2 (1) PATH '$.is_minor'))
                      ProductInfo)
        LOOP
            IDX := IDX + 1;
            RETURN_REC.EXTEND (1);
            RETURN_REC (IDX).SL_NO := IDX;
            RETURN_REC (IDX).ac_type_id := X.ac_type_id;
            RETURN_REC (IDX).asst_lib := X.asst_lib;
            RETURN_REC (IDX).opening_date := X.opening_date;
            RETURN_REC (IDX).product_class := X.product_class;
            RETURN_REC (IDX).ac_type := X.ac_type;
            RETURN_REC (IDX).full_desc := X.full_desc;
            RETURN_REC (IDX).short_desc := X.short_desc;
            RETURN_REC (IDX).cl_cat_no := X.cl_cat_no;
            RETURN_REC (IDX).cl_sub_cat := X.cl_sub_cat;
            RETURN_REC (IDX).over_due_extend := X.over_due_extend;
            RETURN_REC (IDX).min_sanc_amt := X.min_sanc_amt;
            RETURN_REC (IDX).max_sanc_amt := X.max_sanc_amt;
            RETURN_REC (IDX).term := X.term;
            RETURN_REC (IDX).is_visible := X.is_visible;
            RETURN_REC (IDX).grace_period_allowed := X.grace_period_allowed;
            RETURN_REC (IDX).grace_period_month := X.grace_period_month;
            RETURN_REC (IDX).idgp := X.idgp;
            RETURN_REC (IDX).only_employee := X.only_employee;
            RETURN_REC (IDX).product_glac_id := X.product_glac_id;
            RETURN_REC (IDX).income_gl_acc := X.income_gl_acc;
            RETURN_REC (IDX).prv_debit_glac_id := X.prv_debit_glac_id;
            RETURN_REC (IDX).prv_credit_glac_id := X.prv_credit_glac_id;
            RETURN_REC (IDX).allow_debit_bal := X.allow_debit_bal;
            RETURN_REC (IDX).cheque_allow := X.cheque_allow;
            RETURN_REC (IDX).create_by := X.create_by;
            RETURN_REC (IDX).create_date := X.create_date;
            RETURN_REC (IDX).check_status := X.check_status;
            RETURN_REC (IDX).check_by := X.check_by;
            RETURN_REC (IDX).check_date := X.check_date;
            RETURN_REC (IDX).dep_nature := X.dep_nature;
            RETURN_REC (IDX).realization_seq_principle :=
                X.realization_seq_principle;
            RETURN_REC (IDX).realization_seq_int := X.realization_seq_int;
            RETURN_REC (IDX).realization_seq_charge :=
                X.realization_seq_charge;
            RETURN_REC (IDX).int_post_period := X.int_post_period;
            RETURN_REC (IDX).int_cal_method := X.int_cal_method;
            RETURN_REC (IDX).realization_seq_ioo := X.realization_seq_ioo;
            RETURN_REC (IDX).realization_seq_penal_int :=
                X.realization_seq_penal_int;
            RETURN_REC (IDX).allow_int_provision := X.allow_int_provision;
            RETURN_REC (IDX).min_bal := X.min_bal;
            RETURN_REC (IDX).tp_allow := X.tp_allow;
            RETURN_REC (IDX).ins_frequency := X.ins_frequency;
            RETURN_REC (IDX).max_default_ins_allow := X.max_default_ins_allow;
            RETURN_REC (IDX).fine_allow := X.fine_allow;
            RETURN_REC (IDX).ins_start_day := X.ins_start_day;
            RETURN_REC (IDX).ins_end_day := X.ins_end_day;
            RETURN_REC (IDX).ins_holiday_allow := X.ins_holiday_allow;
            RETURN_REC (IDX).default_ins_maturity_alllow :=
                X.default_ins_maturity_alllow;
            RETURN_REC (IDX).grace_period_days := X.grace_period_days;
            RETURN_REC (IDX).update_by := X.update_by;
            RETURN_REC (IDX).update_date := X.update_date;
            RETURN_REC (IDX).death_risk_allow := X.death_risk_allow;
            RETURN_REC (IDX).link_ac_mandatory := X.link_ac_mandatory;
            RETURN_REC (IDX).nid_verify_req := X.nid_verify_req;
            RETURN_REC (IDX).is_minor := X.is_minor;
        END LOOP;

        BEGIN
            FOR J IN 1 .. IDX
            LOOP
                PIPE ROW (RETURN_REC (J));
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN;
    END;

    FUNCTION GET_NOMINEE_INFO
        RETURN NOMINEE_INFO_TB
        PIPELINED
    IS
        vResponse    CLOB
            := PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                   'SELECT * FROM EMOB.NOMINEE_MST;');
        RETURN_REC   NOMINEE_INFO_TB
                         := NOMINEE_INFO_TB (NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL);
        IDX          NUMBER := 0;
    BEGIN
        FOR X
            IN (SELECT NOMINEE_ID,
                       AC_ID,
                       NOMINEE_NAME,
                       FATHER_NAME,
                       MOTHER_NAME,
                       DOB,
                       RELATION,
                       NOM_PERCENT,
                       CREATE_BY,
                       CREATE_DATE,
                       UPDATE_BY,
                       UPDATE_DATE,
                       CUST_NO,
                       DOCUMENT_TYPE,
                       DOCMENT_NO
                 FROM JSON_TABLE (
                          vResponse,
                          '$.items[0].resultSet.items[*]'
                          COLUMNS (
                              nominee_id NUMBER PATH '$.nominee_id',
                              ac_id NUMBER PATH '$.ac_id',
                              nominee_name
                                  VARCHAR2 (200)
                                  PATH '$.nominee_name',
                              father_name VARCHAR2 (200) PATH '$.father_name',
                              mother_name VARCHAR2 (200) PATH '$.mother_name',
                              dob DATE PATH '$.dob',
                              relation VARCHAR2 (3) PATH '$.relation',
                              nom_percent NUMBER PATH '$.nom_percent',
                              create_by VARCHAR2 (50) PATH '$.create_by',
                              create_date DATE PATH '$.create_date',
                              update_by VARCHAR2 (50) PATH '$.update_by',
                              update_date DATE PATH '$.update_date',
                              cust_no NUMBER PATH '$.cust_no',
                              document_type
                                  VARCHAR2 (3)
                                  PATH '$.document_type',
                              docment_no VARCHAR2 (100) PATH '$.docment_no'))
                      NomineeInfo)
        LOOP
            IDX := IDX + 1;
            RETURN_REC.EXTEND (1);
            RETURN_REC (IDX).SL_NO := IDX;
            RETURN_REC (IDX).NOMINEE_ID := X.NOMINEE_ID;
            RETURN_REC (IDX).AC_ID := X.AC_ID;
            RETURN_REC (IDX).NOMINEE_NAME := X.NOMINEE_NAME;
            RETURN_REC (IDX).FATHER_NAME := X.FATHER_NAME;
            RETURN_REC (IDX).MOTHER_NAME := X.MOTHER_NAME;
            RETURN_REC (IDX).DOB := X.DOB;
            RETURN_REC (IDX).RELATION := X.RELATION;
            RETURN_REC (IDX).NOM_PERCENT := X.NOM_PERCENT;
            RETURN_REC (IDX).CREATE_BY := X.CREATE_BY;
            RETURN_REC (IDX).CREATE_DATE := X.CREATE_DATE;
            RETURN_REC (IDX).UPDATE_BY := X.UPDATE_BY;
            RETURN_REC (IDX).UPDATE_DATE := X.UPDATE_DATE;
            RETURN_REC (IDX).CUST_NO := X.CUST_NO;
            RETURN_REC (IDX).DOCUMENT_TYPE := X.DOCUMENT_TYPE;
            RETURN_REC (IDX).DOCMENT_NO := X.DOCMENT_NO;
        END LOOP;

        BEGIN
            FOR J IN 1 .. IDX
            LOOP
                PIPE ROW (RETURN_REC (J));
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN;
    END;

    FUNCTION GET_ACCOUNT_INFO_FILTER_BY_BRANCH (
        pBranchCode   VARCHAR2,
        pCustNo       NUMBER DEFAULT NULL,
        pAcTypeId     NUMBER DEFAULT NULL)
        RETURN ACCOUNT_INFO_TB
        PIPELINED
    IS
        vResponse    CLOB
            := PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                      'SELECT * FROM EMOB.MB_ACCOUNT_MST WHERE BRANCH_CODE='
                   || pBranchCode
                   || ' and cust_no=case when '
                   || pCustNo
                   || ' is null then cust_no else '
                   || pCustNo
                   || ' END
                   and AC_TYPE_ID = case when '
                   || pAcTypeId
                   || ' is null then AC_TYPE_ID else '
                   || pAcTypeId
                   || ' END;');
        RETURN_REC   ACCOUNT_INFO_TB
                         := ACCOUNT_INFO_TB (NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL,
                                             NULL);
        IDX          NUMBER := 0;
    BEGIN
        FOR X
            IN (SELECT branch_code,
                       ac_type_id,
                       ac_id,
                       ac_no,
                       ac_title,
                       cust_no,
                       open_date,
                       close_date,
                       ac_status,
                       create_by,
                       create_date,
                       update_by,
                       update_date,
                       sector_code,
                       security_code,
                       economy_code,
                       final_check,
                       final_check_by,
                       final_check_date,
                       final_remarks,
                       ac_nature,
                       opr_ins,
                       last_provision_date,
                       asst_lib,
                       cl_status,
                       is_prov_allow,
                       old_ac_no,
                       loan_amount
                 FROM JSON_TABLE (
                          vResponse,
                          '$.items[0].resultSet.items[*]'
                          COLUMNS (
                              branch_code
                                  VARCHAR2 (4 BYTE)
                                  PATH '$.branch_code',
                              ac_type_id NUMBER PATH '$.ac_type_id',
                              ac_id NUMBER PATH '$.ac_id',
                              ac_no VARCHAR2 (16 BYTE) PATH '$.ac_no',
                              ac_title VARCHAR2 (200 BYTE) PATH '$.ac_title',
                              cust_no NUMBER PATH '$.cust_no',
                              open_date DATE PATH '$.open_date',
                              close_date DATE PATH '$.close_date',
                              ac_status VARCHAR2 (3 BYTE) PATH '$.ac_status',
                              create_by VARCHAR2 (50 BYTE) PATH '$.create_by',
                              create_date DATE PATH '$.create_date',
                              update_by VARCHAR2 (50 BYTE) PATH '$.update_by',
                              update_date DATE PATH '$.update_date',
                              sector_code
                                  VARCHAR2 (10 BYTE)
                                  PATH '$.sector_code',
                              security_code
                                  VARCHAR2 (5 BYTE)
                                  PATH '$.security_code',
                              economy_code
                                  VARCHAR2 (5 BYTE)
                                  PATH '$.economy_code',
                              final_check
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.final_check',
                              final_check_by
                                  VARCHAR2 (50 BYTE)
                                  PATH '$.final_check_by',
                              final_check_date DATE PATH '$.final_check_date',
                              final_remarks
                                  VARCHAR2 (200 BYTE)
                                  PATH '$.final_remarks',
                              ac_nature VARCHAR2 (1 BYTE) PATH '$.ac_nature',
                              opr_ins VARCHAR2 (3 BYTE) PATH '$.opr_ins',
                              last_provision_date
                                  DATE
                                  PATH '$.last_provision_date',
                              asst_lib VARCHAR2 (1 BYTE) PATH '$.asst_lib',
                              cl_status VARCHAR2 (3 BYTE) PATH '$.cl_status',
                              is_prov_allow
                                  VARCHAR2 (1 BYTE)
                                  PATH '$.is_prov_allow',
                              old_ac_no VARCHAR2 (16 BYTE) PATH '$.old_ac_no',
                              loan_amount NUMBER PATH '$.loan_amount'))
                      AccountInfo)
        LOOP
            IDX := IDX + 1;
            RETURN_REC.EXTEND (1);
            RETURN_REC (IDX).SL_NO := IDX;
            RETURN_REC (IDX).branch_code := X.branch_code;
            RETURN_REC (IDX).ac_type_id := X.ac_type_id;
            RETURN_REC (IDX).ac_id := X.ac_id;
            RETURN_REC (IDX).ac_no := X.ac_no;
            RETURN_REC (IDX).ac_title := X.ac_title;
            RETURN_REC (IDX).cust_no := X.cust_no;
            RETURN_REC (IDX).open_date := X.open_date;
            RETURN_REC (IDX).close_date := X.close_date;
            RETURN_REC (IDX).ac_status := X.ac_status;
            RETURN_REC (IDX).create_by := X.create_by;
            RETURN_REC (IDX).create_date := X.create_date;
            RETURN_REC (IDX).update_by := X.update_by;
            RETURN_REC (IDX).update_date := X.update_date;
            RETURN_REC (IDX).sector_code := X.sector_code;
            RETURN_REC (IDX).security_code := X.security_code;
            RETURN_REC (IDX).economy_code := X.economy_code;
            RETURN_REC (IDX).final_check := X.final_check;
            RETURN_REC (IDX).final_check_by := X.final_check_by;
            RETURN_REC (IDX).final_check_date := X.final_check_date;
            RETURN_REC (IDX).final_remarks := X.final_remarks;
            RETURN_REC (IDX).ac_nature := X.ac_nature;
            RETURN_REC (IDX).opr_ins := X.opr_ins;
            RETURN_REC (IDX).last_provision_date := X.last_provision_date;
            RETURN_REC (IDX).asst_lib := X.asst_lib;
            RETURN_REC (IDX).cl_status := X.cl_status;
            RETURN_REC (IDX).is_prov_allow := X.is_prov_allow;
            RETURN_REC (IDX).old_ac_no := X.old_ac_no;
            RETURN_REC (IDX).loan_amount := X.loan_amount;
        END LOOP;

        BEGIN
            FOR J IN 1 .. IDX
            LOOP
                PIPE ROW (RETURN_REC (J));
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        RETURN;
    END;
END PKG_FETCH_FROM_REST;
/


DROP PACKAGE BODY GUMS.PKG_GLOBAL_EMAIL;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_GLOBAL_EMAIL
IS
    PROCEDURE EMAIL_GENERATE_SEND (pMailType              VARCHAR2, -- Not nulll EMOB.MAIL_TYPE_INFO.MAIL_TYPE
                                   pMailTo                VARCHAR2, -- NOT null,   UESR/CUSTOMER/ACCHolder
                                   pMailRefNo             VARCHAR2, -- NOT null if USER then user_id, if Customer then cust_nn so on,
                                   p1                     VARCHAR2 DEFAULT NULL,
                                   p2                     VARCHAR2 DEFAULT NULL,
                                   p3                     VARCHAR2 DEFAULT NULL,
                                   p4                     VARCHAR2 DEFAULT NULL,
                                   p5                     VARCHAR2 DEFAULT NULL,
                                   pSendTo         IN     VARCHAR2,
                                   pSendCc         IN     VARCHAR2 DEFAULT NULL,
                                   pSendBcc        IN     VARCHAR2 DEFAULT NULL,
                                   pRunUser        IN     VARCHAR2,
                                   pErrorFlag         OUT VARCHAR2,
                                   pErrorMessage      OUT VARCHAR2)
    IS
        vSubject       VARCHAR2 (500);
        vMessage       VARCHAR2 (1024);

        vMyException   EXCEPTION;
    BEGIN
        pErrorFlag := 'N';

        IF pMailTo IS NULL
        THEN
            pErrorMessage := 'pMailTo Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pMailType IS NULL
        THEN
            pErrorMessage := 'Message Type Not Be Blank.';
            RAISE vMyException;
        END IF;


        FOR I IN (  SELECT MAIL_PART,
                           MAIL_TYPE,
                           PARAMETER_VALUE,
                           REMARKS,
                           SL_NO,
                           TEXT_OR_PARAMETER,
                           TEXT_VALUE
                      FROM GUMS.MAIL_GENERATOR
                     WHERE MAIL_TYPE = pMailType AND MAIL_PART = 'S'
                  ORDER BY MAIL_PART, SL_NO)
        LOOP
            IF i.TEXT_OR_PARAMETER = 'T'
            THEN
                IF vSubject IS NULL
                THEN
                    vSubject := TRIM (I.TEXT_VALUE);
                ELSE
                    vSubject := vSubject || ' ' || TRIM (I.TEXT_VALUE);
                END IF;
            ELSIF i.TEXT_OR_PARAMETER = 'P'
            THEN
                IF i.PARAMETER_VALUE = 'P1'
                THEN
                    vSubject := vSubject || ' ' || p1;
                ELSIF i.PARAMETER_VALUE = 'P2'
                THEN
                    vSubject := vSubject || ' ' || p2;
                ELSIF i.PARAMETER_VALUE = 'P3'
                THEN
                    vSubject := vSubject || ' ' || p3;
                ELSIF i.PARAMETER_VALUE = 'P4'
                THEN
                    vSubject := vSubject || ' ' || p4;
                ELSIF i.PARAMETER_VALUE = 'P5'
                THEN
                    vSubject := vSubject || ' ' || p5;
                END IF;
            END IF;
        END LOOP;


        FOR I IN (  SELECT MAIL_PART,
                           MAIL_TYPE,
                           PARAMETER_VALUE,
                           REMARKS,
                           SL_NO,
                           TEXT_OR_PARAMETER,
                           TEXT_VALUE
                      FROM GUMS.MAIL_GENERATOR
                     WHERE MAIL_TYPE = pMailType AND MAIL_PART = 'B'
                  ORDER BY MAIL_PART, SL_NO)
        LOOP
            IF i.TEXT_OR_PARAMETER = 'T'
            THEN
                IF vMessage IS NULL
                THEN
                    vMessage := TRIM (I.TEXT_VALUE);
                ELSE
                    vMessage := vMessage || ' ' || TRIM (I.TEXT_VALUE);
                END IF;
            ELSIF i.TEXT_OR_PARAMETER = 'P'
            THEN
                IF i.PARAMETER_VALUE = 'P1'
                THEN
                    vMessage := vMessage || ' ' || p1;
                ELSIF i.PARAMETER_VALUE = 'P2'
                THEN
                    vMessage := vMessage || ' ' || p2;
                ELSIF i.PARAMETER_VALUE = 'P3'
                THEN
                    vMessage := vMessage || ' ' || p3;
                ELSIF i.PARAMETER_VALUE = 'P4'
                THEN
                    vMessage := vMessage || ' ' || p4;
                ELSIF i.PARAMETER_VALUE = 'P5'
                THEN
                    vMessage := vMessage || ' ' || p5;
                END IF;
            END IF;
        END LOOP;


        BEGIN
            SEND_EMAIL (pSendTo    => pSendTo,
                        pSendCc    => pSendCc,
                        pSendBcc   => pSendBcc,
                        pSubject   => vSubject,
                        pMessage   => vMessage);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'SEND_EMAIL Process Calling Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        BEGIN
            GUMS.PKG_STORE_LOG.STORE_MAIL_TEXT_LOG (
                pMailId         => pSendTo,
                pCC             => pSendCc,
                pBCC            => pSendBcc,
                pSubject        => vSubject,
                pMailText       => vMessage,
                pLoginId        => pRunUser,
                pRunUser        => pRunUser,
                pSessionId      => v ('APP_SESSION'),
                pErrorFlag      => pErrorFlag,
                pErrorMessage   => pErrorMessage);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                       'Mail Text Store problem for Success login. - '
                    || SQLERRM;

                RAISE vMyException;
        END;



        IF NVL (pErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            ROLLBACK;
    END;

    PROCEDURE EMIAL_NOTIFY_ERROR_LOG (pErrorCode          VARCHAR2,
                                      pUserCode           VARCHAR2,
                                      pError              VARCHAR2,
                                      pRunUser            VARCHAR2,
                                      pErrorFlag      OUT VARCHAR2,
                                      pErrorMessage   OUT VARCHAR2)
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        vMyException   EXCEPTION;
    BEGIN
        /*BEGIN
           INSERT INTO GUMS.MB_MAIL_ERROR_LOG (trace_no,
                                               ERROR_CODE,
                                               USER_CODE,
                                               ERROR_MESSAGE,
                                               CREATE_BY,
                                               create_date)
                VALUES (EMOB.MAIL_ERR_LOG_SEQ.NEXTVAL,
                        pErrorCode,
                        pUserCode,
                        pError,
                        pRunUser,
                        SYSDATE);
        EXCEPTION
           WHEN OTHERS
           THEN
              pErrorMessage := 'Email Error Log Creation Problem -' || SQLERRM;
              RAISE vMyException;
        END;*/

        NULL;
        COMMIT;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            ROLLBACK;
    END;

    FUNCTION EMAIL_CHECK (pMailId IN VARCHAR2)
        RETURN INT
    IS
        vDotPos      NUMBER;
        vAtPos       NUMBER;
        vStrLength   NUMBER;
        vAtOcc       NUMBER;
        vDotOcc      NUMBER;
        vLstPos      VARCHAR2 (1);
    BEGIN
        vDotPos := INSTR (pMailId, '.');
        vAtPos := INSTR (pMailId, '@');
        vStrLength := LENGTH (pMailId);
        vAtOcc := REGEXP_COUNT (pMailId, '@');
        vDotOcc := REGEXP_COUNT (pMailId, '.');
        vLstPos := SUBSTR (pMailId, LENGTH (pMailId), 1);



        IF vAtOcc <> 1
        THEN
            RETURN 1;
        END IF;



        IF vDotOcc < 1
        THEN
            RETURN 1;
        END IF;



        IF vLstPos IN ('@', '.')
        THEN
            RETURN 1;
        END IF;



        IF (   (vDotPos = 0)
            OR (vAtPos = 0)
            OR (vDotPos = vAtPos + 1)
            OR (vAtPos = 1)
            OR (vAtPos = vStrLength)
            OR (vDotPos = vStrLength))
        THEN
            RETURN 1;
        END IF;



        IF INSTR (SUBSTR (pMailId, vAtPos), '.') = 0
        THEN
            RETURN 1;
        END IF;



        RETURN 0;
    END;



    FUNCTION SPLIT_TEXT (pText IN CLOB, pDelimeter IN VARCHAR2 DEFAULT ',')
        RETURN GUMS.PKG_GLOBAL_EMAIL.t_split_array
    IS
        l_array   GUMS.PKG_GLOBAL_EMAIL.t_split_array := t_split_array ();

        l_text    CLOB := pText;

        l_idx     NUMBER;
    BEGIN
        l_array.delete;



        IF l_text IS NULL
        THEN
            RAISE_APPLICATION_ERROR (-20000,
                                     'pText parameter cannot be NULL');
        END IF;



        WHILE l_text IS NOT NULL
        LOOP
            l_idx := INSTR (l_text, pDelimeter);

            l_array.EXTEND;



            IF l_idx > 0
            THEN
                l_array (l_array.LAST) := SUBSTR (l_text, 1, l_idx - 1);

                l_text := SUBSTR (l_text, l_idx + 1);
            ELSE
                l_array (l_array.LAST) := l_text;

                l_text := NULL;
            END IF;
        END LOOP;



        RETURN l_array;
    END;



    PROCEDURE PROCESS_RECIPIENTS (pMailConn   IN OUT SYS.UTL_SMTP.connection,
                                  pList       IN     VARCHAR2)
    AS
        l_tab   t_split_array;
    BEGIN
        IF TRIM (pList) IS NOT NULL
        THEN
            l_tab := GUMS.PKG_GLOBAL_EMAIL.split_text (pList);



            FOR i IN 1 .. l_tab.COUNT
            LOOP
                UTL_SMTP.rcpt (pMailConn, TRIM (l_tab (i)));
            END LOOP;
        END IF;
    END;


    PROCEDURE HTML_EMAIL (p_to             IN VARCHAR2,
                          p_from           IN VARCHAR2,
                          p_subject        IN VARCHAR2,
                          p_text           IN VARCHAR2 DEFAULT NULL,
                          p_html           IN VARCHAR2 DEFAULT NULL,
                          p_smtp_portnum   IN VARCHAR2)
    IS
        l_boundary     VARCHAR2 (255) DEFAULT 'a1b2c3d4e3f2g1';
        l_connection   UTL_SMTP.connection;
        l_body_html    CLOB := EMPTY_CLOB; --This LOB will be the email message
        l_offset       NUMBER;
        l_ammount      NUMBER;
        l_temp         VARCHAR2 (32767) DEFAULT NULL;
        vSmtpHost      VARCHAR2 (100);
    BEGIN
        BEGIN
            SELECT SMTP_HOST
              INTO vSmtpHost
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT SMTP_HOST FROM EMOB.MB_BANK_INFO'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (SMTP_HOST VARCHAR2 (100) PATH '$.smtp_host'));
        EXCEPTION
            WHEN OTHERS
            THEN
                vSmtpHost := NULL;
        END;

        l_connection :=
            UTL_SMTP.open_connection (vSmtpHost, p_smtp_portnum, 5);
        UTL_SMTP.helo (l_connection, vSmtpHost);
        UTL_SMTP.mail (l_connection, p_from);
        UTL_SMTP.rcpt (l_connection, p_to);

        l_temp := l_temp || 'MIME-Version: 1.0' || CHR (13) || CHR (10);
        l_temp := l_temp || 'To: ' || p_to || CHR (13) || CHR (10);
        l_temp := l_temp || 'From: ' || p_from || CHR (13) || CHR (10);
        l_temp := l_temp || 'Subject: ' || p_subject || CHR (13) || CHR (10);
        l_temp := l_temp || 'Reply-To: ' || p_from || CHR (13) || CHR (10);
        l_temp :=
               l_temp
            || 'Content-Type: multipart/alternative; boundary='
            || CHR (34)
            || l_boundary
            || CHR (34)
            || CHR (13)
            || CHR (10);

        ----------------------------------------------------
        -- Write the headers
        DBMS_LOB.createtemporary (l_body_html, FALSE, 10);
        DBMS_LOB.write (l_body_html,
                        LENGTH (l_temp),
                        1,
                        l_temp);


        ----------------------------------------------------
        -- Write the text boundary
        l_offset := DBMS_LOB.getlength (l_body_html) + 1;
        l_temp := '--' || l_boundary || CHR (13) || CHR (10);
        l_temp :=
               l_temp
            || 'content-type: text/plain; charset=us-ascii'
            || CHR (13)
            || CHR (10)
            || CHR (13)
            || CHR (10);
        DBMS_LOB.write (l_body_html,
                        LENGTH (l_temp),
                        l_offset,
                        l_temp);

        ----------------------------------------------------
        -- Write the plain text portion of the email
        l_offset := DBMS_LOB.getlength (l_body_html) + 1;

        DBMS_LOB.write (l_body_html,
                        LENGTH (p_text),
                        l_offset,
                        p_text);

        /*
              DBMS_LOB.write (l_body_html,
                              LENGTH (p_html),
                              l_offset,
                              p_html);
                              */

        ----------------------------------------------------
        -- Write the HTML boundary
        l_temp :=
               CHR (13)
            || CHR (10)
            || CHR (13)
            || CHR (10)
            || '--'
            || l_boundary
            || CHR (13)
            || CHR (10);
        l_temp :=
               l_temp
            || 'content-type: text/html;'
            || CHR (13)
            || CHR (10)
            || CHR (13)
            || CHR (10);
        l_offset := DBMS_LOB.getlength (l_body_html) + 1;
        DBMS_LOB.write (l_body_html,
                        LENGTH (l_temp),
                        l_offset,
                        l_temp);

        ----------------------------------------------------
        -- Write the HTML portion of the message
        l_offset := DBMS_LOB.getlength (l_body_html) + 1;
        DBMS_LOB.write (l_body_html,
                        LENGTH (p_html),
                        l_offset,
                        p_html);

        ----------------------------------------------------
        -- Write the final html boundary
        l_temp :=
            CHR (13) || CHR (10) || '--' || l_boundary || '--' || CHR (13);
        l_offset := DBMS_LOB.getlength (l_body_html) + 1;
        DBMS_LOB.write (l_body_html,
                        LENGTH (l_temp),
                        l_offset,
                        l_temp);


        ----------------------------------------------------
        -- Send the email in 1900 byte chunks to UTL_SMTP
        l_offset := 1;
        l_ammount := 1900;
        UTL_SMTP.open_data (l_connection);

        WHILE l_offset < DBMS_LOB.getlength (l_body_html)
        LOOP
            UTL_SMTP.write_data (
                l_connection,
                DBMS_LOB.SUBSTR (l_body_html, l_ammount, l_offset));
            l_offset := l_offset + l_ammount;
            l_ammount :=
                LEAST (1900, DBMS_LOB.getlength (l_body_html) - l_ammount);
        END LOOP;

        UTL_SMTP.close_data (l_connection);
        UTL_SMTP.quit (l_connection);
        DBMS_LOB.freetemporary (l_body_html);
    EXCEPTION
        WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR
        THEN
            BEGIN
                UTL_SMTP.QUIT (l_connection);
            EXCEPTION
                WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR
                THEN
                    NULL; -- When the SMTP server is down or unavailable, we don't have
            -- a connection to the server. The QUIT call raises an
                                              -- exception that we can ignore.
            END;

            RAISE_APPLICATION_ERROR (
                -20000,
                'Failed to send mail due to the following error: ' || SQLERRM);
    END;

    PROCEDURE SEND_EMAIL (pSendTo    IN VARCHAR2,
                          pSendCc    IN VARCHAR2 DEFAULT NULL,
                          pSendBcc   IN VARCHAR2 DEFAULT NULL,
                          pSubject   IN VARCHAR2,
                          pMessage   IN VARCHAR2)
    AS
        vMailConn   UTL_SMTP.connection;
        vSmtpHost   VARCHAR2 (100);
        vSendFrom   VARCHAR2 (100);
        vSmtpPort   NUMBER := 25;
    BEGIN
        BEGIN
            SELECT SMTP_HOST, SEND_EMAIL_FROM
              INTO vSmtpHost, vSendFrom
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT SMTP_HOST,SEND_EMAIL_FROM FROM EMOB.MB_BANK_INFO'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (SMTP_HOST VARCHAR2 (200) PATH '$.smtp_host',
                                SEND_EMAIL_FROM VARCHAR2 (200)
                                    PATH '$.send_email_from'));
        EXCEPTION
            WHEN OTHERS
            THEN
                vSmtpHost := NULL;
        END;

        vMailConn := UTL_SMTP.open_connection (vSmtpHost, vSmtpPort, 5);

        UTL_SMTP.helo (vMailConn, vSmtpHost);

        UTL_SMTP.mail (vMailConn, vSendFrom);

        process_recipients (vMailConn, pSendTo);

        process_recipients (vMailConn, pSendCc);

        process_recipients (vMailConn, pSendBcc);



        UTL_SMTP.open_data (vMailConn);



        UTL_SMTP.write_data (
            vMailConn,
               'Date: '
            || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS')
            || UTL_TCP.crlf);

        UTL_SMTP.write_data (vMailConn, 'To: ' || pSendTo || UTL_TCP.crlf);



        IF TRIM (pSendCc) IS NOT NULL
        THEN
            UTL_SMTP.write_data (
                vMailConn,
                'CC: ' || REPLACE (pSendCc, ',', ';') || UTL_TCP.crlf);
        END IF;



        IF TRIM (pSendBcc) IS NOT NULL
        THEN
            UTL_SMTP.write_data (
                vMailConn,
                'BCC: ' || REPLACE (pSendBcc, ',', ';') || UTL_TCP.crlf);
        END IF;



        UTL_SMTP.write_data (vMailConn,
                             'From: ' || vSendFrom || UTL_TCP.crlf);

        UTL_SMTP.write_data (vMailConn,
                             'Subject: ' || pSubject || UTL_TCP.crlf);

        UTL_SMTP.write_data (
            vMailConn,
            'Reply-To: ' || vSendFrom || UTL_TCP.crlf || UTL_TCP.crlf);



        UTL_SMTP.write_data (vMailConn,
                             pMessage || UTL_TCP.crlf || UTL_TCP.crlf);

        UTL_SMTP.close_data (vMailConn);
        UTL_SMTP.quit (vMailConn);
    EXCEPTION
        WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR
        THEN
            BEGIN
                UTL_SMTP.QUIT (vMailConn);
            EXCEPTION
                WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR
                THEN
                    NULL; -- When the SMTP server is down or unavailable, we don't have
            -- a connection to the server. The QUIT call raises an
                                              -- exception that we can ignore.
            END;

            RAISE_APPLICATION_ERROR (
                -20000,
                'Failed to send mail due to the following error: ' || SQLERRM);
    END;

    FUNCTION SEND_EMAIL_OTP (P_E_ADDRESS    VARCHAR2,
                             P_SUBJECT      VARCHAR2,
                             P_BODY         VARCHAR2)
        RETURN INTEGER
    IS
        req         UTL_HTTP.req;
        res         UTL_HTTP.resp;
        MESSAGE     VARCHAR2 (10000);
        l_obj       JSON_OBJECT_T;
        buffer      VARCHAR2 (4000);

        v_url       VARCHAR2 (4000);
        v_api_key   VARCHAR2 (4000);
        content     VARCHAR2 (4000);
    BEGIN
        SELECT MAIL_API, MAIL_API_KEY
          INTO v_url, v_api_key
          FROM GUMS.MB_GLOBAL_RULE;

        content :=
               '{"API_KEY":"'
            || v_api_key
            || '","method":"send_mail","to":"'
            || P_E_ADDRESS
            || '","body":"'
            || P_BODY
            || '","subject":"'
            || P_SUBJECT
            || '"}';

        req := UTL_HTTP.begin_request (v_url, 'POST', 'HTTP/1.1');

        UTL_HTTP.set_header (req, 'user-agent', 'mozilla/4.0');
        UTL_HTTP.set_header (req, 'content-type', 'application/json');
        UTL_HTTP.set_header (req, 'Content-Length', LENGTH (content));

        UTL_HTTP.write_text (req, content);

        res := UTL_HTTP.get_response (req);

        IF res.status_code = UTL_HTTP.HTTP_OK
        THEN
            BEGIN
                LOOP
                    UTL_HTTP.read_line (res, buffer);
                    MESSAGE := MESSAGE || buffer;
                END LOOP;
            EXCEPTION
                WHEN UTL_HTTP.end_of_body
                THEN
                    UTL_HTTP.end_response (res);

                    l_obj := JSON_OBJECT_T.parse (MESSAGE);

                    IF l_obj.get_string ('status') = 'SUCCESS'
                    THEN
                        RETURN 1;
                    ELSE
                        RETURN 0;
                    END IF;
            END;
        ELSE
            UTL_HTTP.end_response (res);
            RETURN 0;
        END IF;
    EXCEPTION
        WHEN OTHERS
        THEN
            BEGIN
                UTL_HTTP.end_response (res);
            EXCEPTION
                WHEN OTHERS
                THEN
                    NULL;
            END;

            RETURN 0;
    END;
END;
/


DROP PACKAGE BODY GUMS.PKG_GLOBAL_OBJECTS;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_GLOBAL_OBJECTS
IS
    PROCEDURE VALIDATE_MOBILE_NO (pMobileNo           VARCHAR2,
                                  pErrorFlag      OUT VARCHAR2,
                                  pErrorMessage   OUT VARCHAR2)
    IS
    BEGIN
        IF LENGTH (pMobileNo) != 11
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := 'Mobile No. Should be 11 Digit.';
        END IF;

        IF SUBSTR (pMobileNo, 1, 3) NOT IN ('013',
                                            '014',
                                            '015',
                                            '016',
                                            '017',
                                            '018',
                                            '019')
        THEN
            pErrorFlag := 'Y';
            pErrorMessage :=
                'First Three Digit of Mobile No. Should be one of them 013,014,015,016,017,018,019';
        END IF;

        IF NOT REGEXP_LIKE (pMobileNo, '^[0-9]+$')
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := 'Characters Not Allowed in Mobile No.';
        END IF;
    END;

    FUNCTION GET_USER_CODE_BY_ID (pUserId VARCHAR2)
        RETURN VARCHAR2
    IS
        vUserCode   VARCHAR2 (50);
    BEGIN
        SELECT USER_CODE
          INTO vUserCode
          FROM GUMS.MB_USER_MST
         WHERE USER_ID = pUserId;

        RETURN vUserCode;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN vUserCode;
    END;
    FUNCTION GET_USER_NAME_BY_ID (pUserId VARCHAR2)
        RETURN VARCHAR2
    IS
        vUserName   VARCHAR2 (200);
    BEGIN
        SELECT USER_CODE||' -- '||USER_NAME
          INTO vUserName
          FROM GUMS.MB_USER_MST
         WHERE USER_ID = pUserId;

        RETURN vUserName;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN vUserName;
    END;

    FUNCTION GET_USER_ID_BY_CODE (pUserCode VARCHAR2)
        RETURN PLS_INTEGER
    IS
        vUserId   PLS_INTEGER;
    BEGIN
        SELECT USER_ID
          INTO vUserId
          FROM GUMS.MB_USER_MST
         WHERE USER_CODE = pUserCode;

        RETURN vUserId;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN vUserId;
    END;

    PROCEDURE VALIDATE_EMAIL (pEmail          IN     VARCHAR2,
                              pErrorFlag         OUT VARCHAR2,
                              pErrorMessage      OUT VARCHAR2)
    IS
        vAtSignPos   PLS_INTEGER;
        vDotPos      PLS_INTEGER;
    BEGIN
        -- Check for @ symbol
        vAtSignPos := INSTR (pEmail, '@');

        IF vAtSignPos = 0
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := 'Email address must contain "@" symbol.';
            RETURN;
        END IF;

        -- Check for multiple @ symbols
        IF REGEXP_COUNT (pEmail, '@') > 1
        THEN
            pErrorFlag := 'Y';
            pErrorMessage :=
                'Email address cannot contain multiple "@" symbols.';
            RETURN;
        END IF;

        -- Check for dot after @ symbol
        vDotPos := INSTR (pEmail, '.', vAtSignPos);

        IF vDotPos = 0
        THEN
            pErrorFlag := 'Y';
            pErrorMessage :=
                'Email address must contain a dot (.) after "@" symbol.';
        END IF;

        -- Check if dot is at the end
        IF vDotPos = LENGTH (pEmail)
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := 'Email address cannot end with a dot (.)';
        END IF;

        -- Check if dot is immediately after @
        IF vDotPos = vAtSignPos + 1
        THEN
            pErrorFlag := 'Y';
            pErrorMessage :=
                'Email address cannot have dot (.) immediately after "@" symbol.';
        END IF;

        -- Check if dot is immediately before @
        IF vDotPos = vAtSignPos - 1
        THEN
            pErrorFlag := 'Y';
            pErrorMessage :=
                'Email address cannot have dot (.) immediately before "@" symbol.';
        END IF;

        -- Check if dot is the last character before the @
        IF INSTR (SUBSTR (pEmail, vAtSignPos), '.', -1) = 0
        THEN
            pErrorFlag := 'Y';
            pErrorMessage :=
                'Email address must have a domain name after dot (.)';
        END IF;

        -- Check if there are characters between @ and dot
        IF vDotPos - vAtSignPos = 1
        THEN
            pErrorFlag := 'Y';
            pErrorMessage :=
                'Email address must have characters between "@" and dot (.)';
        END IF;

        -- Check if there are characters after dot
        IF LENGTH (SUBSTR (pEmail, vDotPos + 1)) = 0
        THEN
            pErrorFlag := 'Y';
            pErrorMessage :=
                'Email address must have characters after dot (.)';
        END IF;
    END;
END;
/


DROP PACKAGE BODY GUMS.PKG_IMG_CHANGE_REQUEST_APP;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_IMG_CHANGE_REQUEST_APP
IS
    FUNCTION BLOB_COMPARE (pBLOB1 BLOB, pBLOB2 BLOB)
        RETURN INT
    IS
        Amount   INTEGER := 32767;
        Retval   INTEGER;
        vBLOB1   BLOB;
        vBLOB2   BLOB;
    BEGIN
        vBLOB1 := pBLOB1;
        vBLOB2 := pBLOB2;
        retval :=
            DBMS_LOB.COMPARE (vBLOB1,
                              vBLOB2,
                              Amount,
                              1,
                              1);

        IF NVL (retval, 1) = 0
        THEN
            RETURN 0;
        ELSE
            RETURN 1;
        END IF;
    END;

    PROCEDURE REQUEST_INCLUDE_LOG_BLOB (
        pTableName            VARCHAR2,
        pRequestPurpose       VARCHAR2,
        pKeyCol               VARCHAR2 DEFAULT NULL,
        pKeyColValue          VARCHAR2 DEFAULT NULL,
        pKeyCol2               VARCHAR2 DEFAULT NULL,
        pKeyColValue2          VARCHAR2 DEFAULT NULL,
        pPageId               NUMBER,
        pRunUser              VARCHAR2,
        pSessionId            VARCHAR,
        pBranchCode           VARCHAR2 DEFAULT NULL,
        pColList              GUMS.PKG_IMG_CHANGE_REQUEST_APP.DB_OLD_BLOB,
        pRecIdentifier        NUMBER,
        pSchemaName           VARCHAR2 DEFAULT 'MEMMIMG',
        pRequestStatus        VARCHAR2 DEFAULT 'R',
        pErrorFlag        OUT VARCHAR2,
        pErrorMessage     OUT VARCHAR2)
    IS
        vBranchCode       VARCHAR2 (10);
        vOldValue         VARCHAR2 (1024);
        vCount            NUMBER;
        vMyException      EXCEPTION;
    BEGIN
        
     ---   vRecIdenKey := GUMS.REQ_RECORD_IDENTIFIER.NEXTVAL;
      --  pRecIdentifier := vRecIdenKey;
        

         BEGIN
                SELECT COUNT (*)
                  INTO vCount
                  FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                 WHERE     UPPER (TABLE_NAME) = UPPER (pTableName)
                       AND status = 'R'
                       AND REQUEST_PAGE_ID = pPageId
                       AND UPPER (KEY_COL_NAME) = UPPER (pKeyCol)
                       AND KEY_COL_VALUE = pKeyColValue;
            END;

        IF vCount > 0
        THEN
            pErrorMessage :=
                'An Unauthorized Request Exist . Please First Authorized This Request ..';
            RAISE vMyException;
        END IF;


        FOR i IN 1 .. pColList.COUNT
        LOOP

            IF     pColList (i).DB_col_value IS NOT NULL
            THEN
                BEGIN
                    INSERT INTO GUMS.MB_IMG_REQUEST_CHANGE_LOG (
                                    LOG_ID,
                                    TABLE_NAME,
                                    COL_NAME,
                                    NEW_VAL_blob,
                                    OLD_VAL_blob,
                                    STATUS,
                                    REQUEST_PURPOSE,
                                    REQUEST_PAGE_ID,
                                    REQUEST_FOR,
                                    SESSION_ID,
                                    RECORD_IDENTIFIER,
                                    SCHEMA_NAME,
                                    APP_ID,
                                    KEY_COL_NAME,
                                    KEY_COL_VALUE,
                                    CREATE_BY,
                                    CREATE_DATE,
                                    branch_code)
                         VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                                 pTableName,
                                 pColList (i).DB_col_name,
                                 pColList (i).DB_col_value,
                                 vOldValue,
                                 pRequestStatus,
                                 pRequestPurpose,
                                 pPageId,
                                 'I',
                                 pSessionId,
                                 pRecIdentifier,
                                 pSchemaName,
                                 102,
                                 pKeyCol,
                                 pKeyColValue,
                                 pRunUser,
                                 SYSDATE,
                                 vbranchcode);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                            'MB_Request_Change_LOG insert problem' || SQLERRM;
                        RAISE vMyException;
                END;
            END IF;

            END LOOP;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            ROLLBACK;
    END;

    PROCEDURE DB_OLD_VALUE_RETRIVE_BLOB (
        pColName            VARCHAR2,
        pTableName          VARCHAR2,
        pKeyCol             VARCHAR2,
        pKeyColValue        VARCHAR2,
        pSchemaName         VARCHAR2 DEFAULT 'EMOB',
        pDbOldData      OUT DB_OLD_BLOB,
        pErrorFlag      OUT VARCHAR2,
        pErrorMessage   OUT VARCHAR2)
    IS
        TYPE vCurType IS REF CURSOR;

        vCursor        vCurType;
        v_stmt_str     VARCHAR2 (2048);
        vMyException   EXCEPTION;
    BEGIN
    
     
        BEGIN
            SELECT    'SELECT'
                   || ' '''
                   || pColName
                   || ''' '
                   || '"col_name"'
                   || ' , '
                   || pColName
                   || ' '
                   || '"col_value"'
                   || ' ,'
                   || '''Y'''
                   || ' '
                   || '"Image_flag"'
                   || ' , '
                   || 'NULL'
                   || '"coll_value_VC2"'
                   || ' '
                   || 'FROM'
                   || ' '
                   || pSchemaName
                   || '.'
                   || pTableName
                   || ' WHERE '
                   || pKeyCol
                   || ' = '
                   || pKeyColValue
              INTO v_stmt_str
              FROM DUAL;
        END;


 
         -- TEST_INSERT (v_stmt_str);


        OPEN vCursor FOR v_stmt_str;

        BEGIN
            FETCH vCursor BULK COLLECT INTO pDbOldData;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'bulk assign problem clob' || SQLERRM;
                RAISE vMyException;
        END;



        CLOSE vCursor;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';

            ROLLBACK;
    END;

    PROCEDURE REQUEST_CHANGE_LOG_BLOB (
        pTableName            VARCHAR2,
        pKeyCol               VARCHAR2,
        pKeyColValue          VARCHAR2,
        pRequestPurpose       VARCHAR2,
        pPageId               NUMBER,
        pPageName             VARCHAR2,
        pRunUser              VARCHAR2,
        pSessionId            VARCHAR,
        pColList              GUMS.PKG_IMG_CHANGE_REQUEST_APP.DB_OLD_BLOB,
        pRecIdenKey           NUMBER,
        pBranchCode           VARCHAR2 DEFAULT NULL,
        pSchemaName           VARCHAR2 DEFAULT 'MEMIMG',
        pRequestStatus        VARCHAR2 DEFAULT 'R',
        pErrorFlag        OUT VARCHAR2,
        pErrorMessage     OUT VARCHAR2)
    IS
        vBranchCode       VARCHAR2 (10);
        vDbOldDataClob    GUMS.PKG_IMG_CHANGE_REQUEST_APP.DB_OLD_BLOB;
        vErrorFlag        VARCHAR2 (1);
        vErrorMessage     VARCHAR2 (1024);
        vOldValue         BLOB;
        vSame             VARCHAR2 (1);
        vCount            NUMBER;
        vRecIdenKey       NUMBER;
        vMyException      EXCEPTION;
    BEGIN
        
   
        
        
         BEGIN
                SELECT COUNT (*)
                  INTO vCount
                  FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG
                 WHERE     UPPER (TABLE_NAME) = UPPER (pTableName)
                       AND status = 'R'
                       AND REQUEST_PAGE_ID = pPageId
                       AND UPPER (KEY_COL_NAME) = UPPER (pKeyCol)
                       AND KEY_COL_VALUE = pKeyColValue;
            END;

        IF vCount > 0
        THEN
            pErrorMessage :=
                'An Unauthorized Request Exist . Please First Authorized This Request ..';
            RAISE vMyException;
        END IF;

        
        FOR i IN 1 .. pColList.COUNT
        LOOP
            IF pColList (i).DB_col_value IS NOT NULL
            THEN
           
                BEGIN
                    GUMS.PKG_IMG_CHANGE_REQUEST_APP.DB_OLD_VALUE_RETRIVE_BLOB (
                        pColName        => pColList (i).DB_col_name,
                        pTableName      => pTableName,
                        pKeyCol         => pKeyCol,
                        pKeyColValue    => pKeyColValue,
                        pSchemaName     => pSchemaName,
                        PDBOLDDATA      => vDbOldDataClob,
                        pErrorFlag      => vErrorFlag,
                        pErrorMessage   => vErrorMessage);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage := SQLERRM;
                END;


                IF vErrorFlag = 'Y'
                THEN
                    pErrorMessage := vErrorMessage;
                END IF;


                BEGIN
                    FOR j IN 1 .. vDbOldDataClob.COUNT
                    LOOP
                    
                        IF     vDbOldDataClob (j).DB_col_value IS NOT NULL
                           AND LENGTH (vDbOldDataClob (j).DB_col_value) =
                               LENGTH (pColList (i).DB_col_value)
                           AND BLOB_COMPARE (vDbOldDataClob (j).DB_col_value,
                                             pColList (i).DB_col_value) =
                               0
                        THEN
                            vSame := 'Y';
                        ELSIF     vDbOldDataClob (j).DB_col_value IS NULL
                              AND pColList (i).DB_col_value IS NULL
                        THEN
                            vSame := 'Y';
                        ELSE
                            vOldValue := vDbOldDataClob (j).DB_col_value;
                            vSame := 'N';
                        END IF;
                    END LOOP;
                END;
               
 
                IF NVL(vSame,'N') = 'N'
                THEN
               
                    BEGIN
                        INSERT INTO GUMS.MB_IMG_REQUEST_CHANGE_LOG (
                                        LOG_ID,
                                        TABLE_NAME,
                                        COL_NAME,
                                        NEW_VAL_BLOB,
                                        OLD_VAL_BLOB,
                                        KEY_COL_NAME,
                                        KEY_COL_VALUE,
                                        STATUS,
                                        REQUEST_PURPOSE,
                                        REQUEST_PAGE_ID,
                                        REQUEST_FOR,
                                        SESSION_ID,
                                        RECORD_IDENTIFIER,
                                        SCHEMA_NAME,
                                        APP_ID,
                                        CREATE_BY,
                                        CREATE_DATE,
                                        branch_code)
                             VALUES (GUMS.CHANGE_REQUEST_LOG_ID.NEXTVAL,
                                     pTableName,
                                     pColList (i).DB_col_name,
                                     pColList (i).DB_col_value,
                                     vOldValue,
                                     pKeyCol,
                                     pKeyColValue,
                                     pRequestStatus,
                                     pRequestPurpose,
                                     pPageId,
                                     'U',
                                     pSessionId,
                                     vRecIdenKey,
                                     pSchemaName,
                                     '102',
                                     pRunUser,
                                     SYSDATE,
                                     vbranchcode);
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            pErrorMessage :=
                                   'mb_product_update_log insert problem'
                                || SQLERRM;
                            RAISE vMyException;
                    END;
                END IF;
            END IF;
        END LOOP;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';

            ROLLBACK;
    END;

    PROCEDURE REQUEST_INCLUDE_APPROVAL (
        pTableName            VARCHAR2,
        pSchemaName           VARCHAR2 DEFAULT 'MEMIMG',
        pKeyColumn            VARCHAR2 DEFAULT NULL,
        pKeyColValue          VARCHAR2 DEFAULT NULL,
        pRunUser              VARCHAR2,
        pRequestSession       VARCHAR2,
        pRecIdentifier        NUMBER,
        pErrorFlag        OUT VARCHAR2,
        pErrorMessage     OUT VARCHAR2)
    IS
        vColList          VARCHAR2 (2048);
        vValueList        VARCHAR2 (2048);
        vColListClob      VARCHAR2 (2048);
        vStatStr          VARCHAR2 (2048);
        vStatStrClob      VARCHAR2 (2048);
        j                 NUMBER := 1;
        vValListClobNew   VARCHAR2 (2048);
        vClobArrary       GUMS.PKG_IMG_CHANGE_REQUEST_APP.DB_OLD_BLOB;
        vMyException      EXCEPTION;

        CURSOR c1
        IS
            SELECT col_name,
                   new_val,
                   db_data_type,
                   new_val_blob
              FROM GUMS.MB_IMG_REQUEST_CHANGE_LOG x
             WHERE   status = 'R'
                   AND request_for = 'I'
                   AND record_identifier = pRecIdentifier;
    BEGIN
        
        /*FOR i IN c1
        LOOP
            IF i.image_flag = 'N'
            THEN
                IF vColList IS NOT NULL AND i.col_name IS NOT NULL
                THEN
                    vColList := vColList || ',';
                    vValueList := vValueList || ',';
                END IF;


                IF i.DB_DATA_TYPE = 'NUMBER'
                THEN
                    vColList := vColList || i.col_name;
                    vValueList := vValueList || i.new_val;
                ELSE
                    vColList := vColList || i.col_name;
                    vValueList := vValueList || '''' || i.new_val || '''';
                END IF;
            ELSE
                IF vColListClob IS NOT NULL AND i.col_name IS NOT NULL
                THEN
                    vColListClob := vColListClob || ',';
                    vValListClobNew := vValListClobNew || ',';
                END IF;

                vColListClob := vColListClob || i.col_name;
                vValListClobNew := vValListClobNew || ':X' || j;

                vClobArrary (j).DB_col_name := i.col_name;
                vClobArrary (j).DB_col_value := i.new_val_blob;
                vClobArrary (j).DB_Img_flag := 'Y';
                vClobArrary (j).db_col_value_vc2 := NULL;
                j := j + 1;
            END IF;
        END LOOP;

        IF vColListClob IS NULL AND vColList IS NOT NULL
        THEN
            BEGIN
                SELECT    'Insert into '
                       || ' '
                       || pSchemaName
                       || '.'
                       || pTableName
                       || ' '
                       || '('
                       || ' '
                       || vColList
                       || ' '
                       || ')'
                       || ' values'
                       || ' '
                       || '('
                       || ' '
                       || vValueList
                       || ' '
                       || ')'
                  INTO vStatStr
                  FROM DUAL;
            END;


            BEGIN
                EXECUTE IMMEDIATE (vStatStr);
            EXCEPTION
                WHEN OTHERS
                THEN
                    pErrorMessage :=
                           'Insert problem in Table:'
                        || pTableName
                        || vStatStr
                        || ':'
                        || SQLERRM;
                    RAISE vMyException;
            END;
        END IF;


        IF vColListClob IS NOT NULL AND vColList IS NOT NULL
        THEN
            BEGIN
                vStatStrClob :=
                       'Insert into '
                    || ' '
                    || pSchemaName
                    || '.'
                    || TRIM (pTableName)
                    || ' '
                    || '('
                    || ' '
                    || vColList
                    || ' '
                    || ' ,'
                    || vColListClob
                    || ' '
                    || ')'
                    || ' values'
                    || ' '
                    || '('
                    || ' '
                    || vValueList
                    || ' '
                    || ','
                    || vValListClobNew
                    || ')';
            END;


            IF j = 2
            THEN
                BEGIN
                    EXECUTE IMMEDIATE (vStatStrClob)
                        USING vClobArrary (1).DB_col_value;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                               'Insert problem in Table:'
                            || pTableName
                            || ':'
                            || SQLERRM;
                        RAISE vMyException;
                END;
            ELSIF j = 3
            THEN
                BEGIN
                    EXECUTE IMMEDIATE
                        (vStatStrClob)
                        USING vClobArrary (1).DB_col_value,
                              vClobArrary (2).DB_col_value;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                               'Insert problem in Table:'
                            || pTableName
                            || ':'
                            || SQLERRM;
                        RAISE vMyException;
                END;
            ELSIF j = 4
            THEN
                BEGIN
                    EXECUTE IMMEDIATE
                        (vStatStrClob)
                        USING vClobArrary (1).DB_col_value,
                              vClobArrary (2).DB_col_value,
                              vClobArrary (3).DB_col_value;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                               'Insert problem in Table:'
                            || pTableName
                            || ':'
                            || SQLERRM;
                        RAISE vMyException;
                END;
            ELSIF j = 5
            THEN
                BEGIN
                    EXECUTE IMMEDIATE (vStatStrClob)
                        USING vClobArrary (1).DB_col_value,
                              vClobArrary (2).DB_col_value,
                              vClobArrary (3).DB_col_value,
                              vClobArrary (4).DB_col_value;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                               'Insert problem in Table:'
                            || pTableName
                            || ':'
                            || SQLERRM;
                        RAISE vMyException;
                END;
            ELSIF j = 6
            THEN
                BEGIN
                    EXECUTE IMMEDIATE (vStatStrClob)
                        USING vClobArrary (1).DB_col_value,
                              vClobArrary (2).DB_col_value,
                              vClobArrary (3).DB_col_value,
                              vClobArrary (4).DB_col_value,
                              vClobArrary (5).DB_col_value;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                               'Insert problem in Table:'
                            || pTableName
                            || ':'
                            || SQLERRM;
                        RAISE vMyException;
                END;
            END IF;
        END IF;



        BEGIN
            UPDATE AUDIT_LOG.MB_REQUEST_CHANGE_LOG
               SET status = 'A',
                   APPROVE_BY = pRunUser,
                   APPROVE_DATE = SYSDATE
             WHERE     UPPER (TABLE_NAME) = UPPER (pTableName)
                   AND UPPER (SCHEMA_NAME) = UPPER (pSchemaName)
                   AND SESSION_ID = pRequestSession
                   AND status = 'R'
                   AND REQUEST_FOR = 'I'
                   AND RECORD_IDENTIFIER = pRecIdentifier
                   AND DECODE (KEY_COL_NAME, NULL, 'X', UPPER (KEY_COL_NAME)) =
                       DECODE (pKeyColumn,
                               NULL, 'X',
                               'NULL', 'X',
                               UPPER (pKeyColumn))
                   AND DECODE (KEY_COL_VALUE,
                               NULL, 'X',
                               UPPER (KEY_COL_VALUE)) =
                       DECODE (pKeyColValue,
                               NULL, 'X',
                               'NULL', 'X',
                               UPPER (pKeyColValue))
                   AND DECODE (KEY_COL_NAME1,
                               NULL, 'X',
                               UPPER (KEY_COL_NAME1)) =
                       DECODE (pKeyColumn1,
                               NULL, 'X',
                               'NULL', 'X',
                               UPPER (pKeyColumn1))
                   AND DECODE (KEY_COL_VALUE1,
                               NULL, 'X',
                               UPPER (KEY_COL_VALUE1)) =
                       DECODE (pKeyColValue1,
                               NULL, 'X',
                               'NULL', 'X',
                               UPPER (pKeyColValue1))
                   AND DECODE (KEY_COL_NAME2,
                               NULL, 'X',
                               UPPER (KEY_COL_NAME2)) =
                       DECODE (pKeyColumn2,
                               NULL, 'X',
                               'NULL', 'X',
                               UPPER (pKeyColumn2))
                   AND DECODE (KEY_COL_VALUE2,
                               NULL, 'X',
                               UPPER (KEY_COL_VALUE2)) =
                       DECODE (pKeyColValue2,
                               NULL, 'X',
                               'NULL', 'X',
                               UPPER (pKeyColValue2));
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                       'Upate problem  in MB_REQUEST_CHANGE_LOG Table:'
                    || ':'
                    || SQLERRM;
                RAISE vMyException;
        END;*/
        NULL;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';

            ROLLBACK;
    END;

    PROCEDURE REQUEST_REJECT (pTableName            VARCHAR2,
                              pPageId               NUMBER,
                              pRequestSession       VARCHAR2,
                              pRecIdentifier        NUMBER,
                              pRunUser              VARCHAR2,
                              pErrorFlag        OUT VARCHAR2,
                              pErrorMessage     OUT VARCHAR2)
    IS
        vMyException   EXCEPTION;
    BEGIN
        BEGIN
            UPDATE GUMS.MB_IMG_REQUEST_CHANGE_LOG
               SET status = 'D',
                   APPROVE_BY = pRunUser,
                   APPROVE_DATE = SYSDATE
             WHERE     RECORD_IDENTIFIER = pRecIdentifier;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                       ' MB_Request_Change_LOG Update Problem for reject :'
                    || SQLERRM;
                RAISE vMyException;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';

            ROLLBACK;
    END;
END;
/


DROP PACKAGE BODY GUMS.PKG_LOAN_REPAYMENT_CLOSING;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_LOAN_REPAYMENT_CLOSING
IS
   PROCEDURE LOAN_REPAYMENT_AC_DETAILS (pLoanAcNo          IN     VARCHAR2,
                                        pPaymentType       IN     VARCHAR2,
                                        pBranchCode        IN     VARCHAR2,
                                        pAcTittle             OUT VARCHAR2,
                                        pLinkAcNo             OUT VARCHAR2,
                                        pLinkAcTittle         OUT VARCHAR2,
                                        pLinkAcBal            OUT NUMBER,
                                        pProduct              OUT VARCHAR2,
                                        pLoanAmt              OUT NUMBER,
                                        pDisburseDate         OUT DATE,
                                        pIntRate              OUT NUMBER,
                                        pExpIntRate           OUT NUMBER,
                                        pTerm                 OUT NUMBER,
                                        pDuePrincipal         OUT NUMBER,
                                        pDueInt               OUT NUMBER,
                                        pDueExpInt            OUT NUMBER,
                                        pDueInstallNo         OUT NUMBER,
                                        pInstallNo            OUT NUMBER,
                                        pLoanType             OUT VARCHAR2,
                                        pOnlyEmp              OUT VARCHAR2,
                                        pLinkAcBranch         OUT VARCHAR2,
                                        pLoanAcBranch         OUT VARCHAR2,
                                        pLoanExpDate          OUT DATE,
                                        pLoanGrantDate        OUT DATE,
                                        pLoanOutStanding      OUT NUMBER,
                                        pChargeAmount         OUT NUMBER,
                                        pLastRepayDate        OUT VARCHAR2,
                                        pLastRepayAmt         OUT NUMBER,
                                        pTotalPaid            OUT NUMBER,
                                        pErrorFlag            OUT VARCHAR2,
                                        pErrorMessage         OUT VARCHAR2)
   IS
      vUrl           VARCHAR2 (1024);
      vResponse      CLOB;
      vRequest       CLOB;
      vMyException   EXCEPTION;
   BEGIN
      SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

      vUrl :=
            vUrl
         || '/psb/psbcore/coresrc/Loan_Rep_Cls/GET_LOAN_REPAYMENT_AC_DETAILS';

      vRequest := '{
    "ploanacno": "' || pLoanAcNo || '",
    "ppaymenttype": "' || pPaymentType || '",
    "pbranchcode": "' || pBranchCode || '"
}'     ;


      BEGIN
         APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
         APEX_WEB_SERVICE.g_request_headers (1).VALUE := 'application/json';
         vResponse :=
            APEX_WEB_SERVICE.MAKE_REST_REQUEST (p_url                => vUrl,
                                                p_http_method        => 'POST',
                                                p_body               => vRequest,
                                                p_transfer_timeout   => 60);
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage := 'Loan A/C Details API Calling Problem';
            RAISE vMyException;
      END;

      apex_json.parse (vResponse);
      pErrorFlag := apex_json.get_varchar2 ('perrorfalg');
      pErrorMessage := apex_json.get_varchar2 ('perrormsg');

      IF NVL (pErrorFlag, 'N') = 'Y'
      THEN
         RAISE vMyException;
      END IF;

      pAcTittle := apex_json.get_varchar2 ('pactittle');
      pLinkAcNo := apex_json.get_varchar2 ('plinkacno');
      pLinkAcTittle := apex_json.get_varchar2 ('plinkactittle');
      pLinkAcBal := apex_json.get_number ('plinkacbal');
      pProduct := apex_json.get_varchar2 ('pproduct');
      pLoanAmt := apex_json.get_number ('ploanamt');
      pDisburseDate :=  to_date(apex_json.get_varchar2 ('pdisbursedate'),'DD-MON-RRRR'); --apex_json.get_date ('pdisbursedate');
      pIntRate := apex_json.get_number ('pintrate');
      pExpIntRate := apex_json.get_number ('pexpintrate');
      pTerm := apex_json.get_number ('pterm');
      pDuePrincipal := apex_json.get_number ('pdueprincipal');
      pDueInt := apex_json.get_number ('pdueint');
      pDueExpInt := apex_json.get_number ('pdueexpint');
      pDueInstallNo := apex_json.get_number ('pdueinstallno');
      pLoanType := apex_json.get_varchar2 ('ploantype');
      pOnlyEmp := apex_json.get_varchar2 ('ponlyemp');
      pInstallNo := apex_json.get_number ('pinstallno');
      pLinkAcBranch := apex_json.get_varchar2 ('plinkacbranch');
      pLoanAcBranch := apex_json.get_varchar2 ('ploanacbranch');
      pLoanExpDate :=  to_date(apex_json.get_varchar2 ('ploanexpdate'),'DD-MON-RRRR'); --apex_json.get_date ('ploanexpdate');
      pLoanGrantDate := to_date(apex_json.get_varchar2 ('ploangrantdate'),'DD-MON-RRRR');  -- apex_json.get_date ('ploangrantdate');
      pLoanOutStanding := apex_json.get_varchar2 ('ploanoutstanding');
      pChargeAmount := apex_json.get_varchar2 ('pchargeamount');
      pLastRepayDate :=to_date(apex_json.get_varchar2 ('plastrepaydate'),'DD-MON-RRRR');
      pLastRepayAmt  :=apex_json.get_number ('plastrepayamt');
      pTotalPaid     :=apex_json.get_number ('ptotalpaid');
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorFlag := 'Y';
   END;

   PROCEDURE LOAN_CLOSE_AC_DETAILS (pLoanAcNo             IN     VARCHAR2,
                                    pPaymentType          IN     VARCHAR2,
                                    pBranchCode           IN     VARCHAR2,
                                    pRunUser              IN     VARCHAR2,
                                    pLogId                IN     VARCHAR2,
                                    pModuleDate           IN     DATE,
                                    pSuspenseAmt             OUT NUMBER,
                                    pSettlementAmt           OUT NUMBER,
                                    pAcTittle                OUT VARCHAR2,
                                    pAcOutstanding           OUT NUMBER,
                                    pExpDate                 OUT DATE,
                                    pBlIntAmt                OUT NUMBER,
                                    pDueAccural              OUT NUMBER,
                                    pLastProvDate            OUT DATE,
                                    pProvStopDate            OUT DATE,
                                    pDueExpChg               OUT NUMBER,
                                    pRepayStatus             OUT VARCHAR2,
                                    pLastRescheduleDate      OUT DATE,
                                    pClStatus                OUT VARCHAR2,
                                    pRebateAmt               OUT NUMBER,
                                    pLinkAcNo                OUT VARCHAR2,
                                    pLinkAcTittle            OUT VARCHAR2,
                                    pLinkAcBal               OUT NUMBER,
                                    pProduct                 OUT VARCHAR2,
                                    pLoanAmt                 OUT NUMBER,
                                    pDisburseDate            OUT DATE,
                                    pIntRate                 OUT NUMBER,
                                    pExpIntRate              OUT NUMBER,
                                    pTerm                    OUT NUMBER,
                                    pDuePrincipal            OUT NUMBER,
                                    pDueInt                  OUT NUMBER,
                                    pDueInstallNo            OUT NUMBER,
                                    pInstallNo               OUT NUMBER,
                                    pEarlyClosingChg         OUT NUMBER,
                                    pEarlyClosureGl          OUT NUMBER,
                                    pOtherCharge             OUT NUMBER,
                                    pExciseDuty              OUT NUMBER,
                                    pLoanType                OUT VARCHAR2,
                                    pOnlyEmp                 OUT VARCHAR2,
                                    pLinkAcBranch            OUT VARCHAR2,
                                    pLoanAcBranch            OUT VARCHAR2,
                                    pErrorFlag               OUT VARCHAR2,
                                    pErrorMessage            OUT VARCHAR2)
   IS
      vUrl           VARCHAR2 (1024);
      vResponse      CLOB;
      vRequest       CLOB;
      vMyException   EXCEPTION;
   BEGIN
      SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

      vUrl :=
            vUrl
         || '/psb/psbcore/coresrc/Loan_Rep_Cls/GET_LOAN_CLOSE_AC_DETAILS';

      vRequest := '{
    "ploanacno": "' || pLoanAcNo || '",
    "ppaymenttype": "' || pPaymentType || '",
    "prunuser": "'  || pRunUser || '",
    "plogid": "'    || pLogId || '",
    "pmoduledate": "' || pModuleDate || '",
    "pbranchcode": "' || pBranchCode || '"
}'     ;


      BEGIN
         APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
         APEX_WEB_SERVICE.g_request_headers (1).VALUE := 'application/json';
         vResponse :=
            APEX_WEB_SERVICE.MAKE_REST_REQUEST (p_url                => vUrl,
                                                p_http_method        => 'POST',
                                                p_body               => vRequest,
                                                p_transfer_timeout   => 60);
      EXCEPTION
         WHEN OTHERS
         THEN
            pErrorMessage :=
               'Loan A/C Closing Detail Data API Calling Problem' || SQLERRM;
            RAISE vMyException;
      END;

      apex_json.parse (vResponse);
      pErrorFlag := apex_json.get_varchar2 ('perrorfalg');
      pErrorMessage := apex_json.get_varchar2 ('perrormsg');

      IF NVL (pErrorFlag, 'N') = 'Y'
      THEN
         RAISE vMyException;
      END IF;

      pSettlementAmt := apex_json.get_number ('psettlementamt');
      pAcTittle := apex_json.get_varchar2 ('pactittle');
      pLinkAcNo := apex_json.get_varchar2 ('plinkacno');

      pLastProvDate := to_date(apex_json.get_varchar2 ('plastprovdate'),'DD-MON-RRRR'); -- apex_json.get_date ('plastprovdate');
      pProvStopDate := to_date(apex_json.get_varchar2 ('pprovstopdate'),'DD-MON-RRRR');  -- apex_json.get_date ('pprovstopdate');
      pDueExpChg := apex_json.get_varchar2 ('pdueexpchg');
      pRepayStatus := apex_json.get_varchar2 ('prepaystatus');
      pLastRescheduleDate := to_date(apex_json.get_varchar2 ('plastrescheduledate'),'DD-MON-RRRR'); -- apex_json.get_date ('plastrescheduledate');
      pClStatus := apex_json.get_varchar2 ('pclstatus');
      pRebateAmt := apex_json.get_number ('prebateamt');
      pExciseDuty := apex_json.get_number ('pexciseduty');


      pExpDate := to_date(apex_json.get_varchar2 ('pexpdate'),'DD-MON-RRRR');
      pBlIntAmt := apex_json.get_number ('pblintamt');
      pDueAccural := apex_json.get_number ('pdueaccural');
      pAcOutstanding :=apex_json.get_number ('pacoutstanding');

      pLinkAcTittle := apex_json.get_varchar2 ('plinkactittle');
      pLinkAcBal := apex_json.get_number ('plinkacbal');
      pProduct := apex_json.get_varchar2 ('pproduct');
      pLoanAmt := apex_json.get_number ('ploanamt');
      pDisburseDate := to_date(apex_json.get_varchar2 ('pdisbursedate'),'DD-MON-RRRR'); -- apex_json.get_date ('pdisbursedate');
      pIntRate := apex_json.get_number ('pintrate');
      pExpIntRate := apex_json.get_number ('pexpintrate');
      pTerm := apex_json.get_number ('pterm');
      pDuePrincipal := apex_json.get_number ('pdueprincipal');
      pDueInt := apex_json.get_number ('pdueint');
      pDueInstallNo := apex_json.get_number ('pdueinstallno');
      pInstallNo := apex_json.get_number ('pinstallno');
      pLoanType := apex_json.get_varchar2 ('ploantype');
      pOnlyEmp := apex_json.get_varchar2 ('ponlyemp');
      pLinkAcBranch := apex_json.get_varchar2 ('plinkacbranch');
      pLoanAcBranch := apex_json.get_varchar2 ('ploanacbranch');
      pSuspenseAmt := apex_json.get_varchar2 ('psuspenseamt');
      pEarlyClosingChg := apex_json.get_varchar2 ('pearlyclosingchg');
      pEarlyClosureGl := apex_json.get_varchar2 ('pearlyclosuregl');
      pOtherCharge := apex_json.get_varchar2 ('pothercharge');
   EXCEPTION
      WHEN vMyException
      THEN
         pErrorFlag := 'Y';
   END;
END;
/


DROP PACKAGE BODY GUMS.PKG_MOBILE_APPS;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_MOBILE_APPS
IS
    PROCEDURE PRC_DEVICE_REGISTRATION (pUserType       VARCHAR2,
                                       pUserId         VARCHAR2,
                                       pDeviceId       VARCHAR2,
                                       pStatus     OUT VARCHAR2,
                                       pMessage    OUT VARCHAR2)
    IS
        vUserId         VARCHAR2 (50);
        vOTP            NUMBER;
        vMobileNo       VARCHAR2 (20);
        vErrorFlag      VARCHAR2 (1);
        vErrorMessage   VARCHAR2 (1024);
        vUserStatus     VARCHAR2 (10);
        vCustomerCode   VARCHAR2 (10);
        vMyException    EXCEPTION;
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pUserType IS NULL
        THEN
            vErrorMessage := 'User Type Required.';
            RAISE vMyException;
        END IF;

        IF pUserId IS NULL
        THEN
            vErrorMessage := 'User Id Required.';
            RAISE vMyException;
        END IF;

        IF pDeviceId IS NULL
        THEN
            vErrorMessage := 'Device Id Required.';
            RAISE vMyException;
        END IF;

        IF pUserType = 'FO'
        THEN
        
            BEGIN
                SELECT a.USER_ID, a.USER_STS, a.MOBILE_NO
                  INTO vUserId, vUserStatus, vMobileNo
                  FROM GUMS.MB_USER_MST a
                 WHERE UPPER (a.USER_CODE) = UPPER (pUserId);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Invalid User.';
                    RAISE vMyException;
            END;

            IF vUserStatus != 'A'
            THEN
                vErrorMessage := 'User Not Active.';
                RAISE vMyException;
            END IF;

            vCustomerCode := NULL;
            
        ELSIF pUserType = 'BN'
        THEN
            BEGIN
                SELECT MEMBER_CODE, CUST_STATUS, MOBILE_NO
                  INTO vUserId, vUserStatus, vMobileNo
                  FROM JSON_TABLE (
                           GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                                  ' SELECT a.MEMBER_CODE, a.CUST_STATUS, a.MOBILE_NO
                  FROM EMOB.MB_CUSTOMER_MST a
                 WHERE a.MEMBER_CODE = '''
                               || pUserId
                               || ''''),
                           '$.items[0].resultSet.items[*]'
                           COLUMNS (
                               MEMBER_CODE VARCHAR2 PATH '$.member_code',
                               CUST_STATUS VARCHAR2 PATH '$.cust_status',
                               MOBILE_NO VARCHAR2 PATH '$.mobile_no'));
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Invalid User.';
                    RAISE vMyException;
            END;

            IF vUserStatus != 'ACT'
            THEN
                vErrorMessage := 'User Not Active.';
                RAISE vMyException;
            END IF;

            vCustomerCode := pUserId;
        END IF;

        BEGIN
            SELECT TO_CHAR (TRUNC (DBMS_RANDOM.VALUE (1000, 9999)))
              INTO vOTP
              FROM DUAL;
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'OTP Creation Problem.';
                RAISE vMyException;
        END;

        BEGIN
            INSERT INTO GUMS.APPS_OTP (OTP_ID,
                                       USER_CODE,
                                       MOBILE_NO,
                                       DEVICE_ID,
                                       OTP,
                                       CREATE_BY,
                                       USER_TYPE)
                 VALUES (GUMS.APPS_OTP_ID_SEQ.NEXTVAL,
                         UPPER (pUserId),
                         vMobileNo,
                         pDeviceId,
                         vOTP,
                         UPPER (pUserId),
                         pUserType);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'OTP Generation Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        BEGIN
            GUMS.PRC_SMS_GENERATION (
                pCustomerCode    => vCustomerCode,
                pAccountNo       => NULL,
                pAccountTypeId   => NULL,
                pMobileNo        => vMobileNo,
                pAmount          => NULL,
                pMessageType     => 'OTP',
                pMessage         => 'Your Current OTP is :' || vOTP,
                pRunUser         => UPPER (pUserId),
                pErrorFlag       => vErrorFlag,
                pErrorMessage    => vErrorMessage);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'OTP Insert Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF NVL (vErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
        
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pStatus := 'F';
            pMessage := vErrorMessage;
    END;

    PROCEDURE PRC_OTP_VERIFICATION (pUserType       VARCHAR2,
                                    pUserId         VARCHAR2,
                                    pPassword       VARCHAR2,
                                    pDeviceId       VARCHAR2,
                                    pOTP            VARCHAR2,
                                    pStatus     OUT VARCHAR2,
                                    pMessage    OUT VARCHAR2)
    IS
        vUserId         VARCHAR2 (50);
        vOTP            NUMBER;
        vMobileNo       VARCHAR2 (20);
        vCount          NUMBER;
        vErrorMessage   VARCHAR2 (1024);
        vUserPwd        VARCHAR2 (50) := NULL;
        vUserStatus     VARCHAR2 (10);
        vOutPassword    VARCHAR2 (50);
        vMyException    EXCEPTION;
        vCustName       VARCHAR2 (500);
        vBranchCode     VARCHAR2 (5);
        vMail           VARCHAR2 (150);
        vDob            VARCHAR2 (50);
        vCountUser      NUMBER;
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pUserId IS NULL
        THEN
            vErrorMessage := 'User Id Required.';
            RAISE vMyException;
        END IF;

        IF pDeviceId IS NULL
        THEN
            vErrorMessage := 'Device Id Required.';
            RAISE vMyException;
        END IF;

        IF pOTP IS NULL
        THEN
            vErrorMessage := 'OTP Required.';
            RAISE vMyException;
        END IF;

        IF pUserType IS NULL
        THEN
            vErrorMessage := 'User Type Required.';
            RAISE vMyException;
        END IF;

        IF pPassword IS NULL
        THEN
            vErrorMessage := 'Password Required.';
            RAISE vMyException;
        END IF;

        IF pUserType = 'FO'
        THEN
            BEGIN
                SELECT a.USER_ID,
                       a.USER_STS,
                       a.USER_PWD,
                       a.Mobile_no
                  INTO vUserId,
                       vUserStatus,
                       vUserPwd,
                       vMobileNo
                  FROM GUMS.MB_USER_MST a
                 WHERE UPPER (a.USER_CODE) = UPPER (pUserId);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Invalid User..';
                    RAISE vMyException;
            END;

            IF vUserStatus != 'A'
            THEN
                vErrorMessage := 'User Not Active.';
                RAISE vMyException;
            END IF;

            BEGIN
                SELECT GUMS.DPK_SECURITY.DFN_CREATE_PASSWORD_ENCRYPTED (
                           UPPER (pUserId) || vUserId,
                           pPassword)
                  INTO vOutPassword
                  FROM DUAL;
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Password Encryption Problem.';
                    RAISE vMyException;
            END;

            IF vOutPassword != vUserPwd
            THEN
                vErrorMessage := 'Password Not Valid.';
                RAISE vMyException;
            END IF;
        ELSIF pUserType = 'BN'
        THEN
            BEGIN
                SELECT MEMBER_CODE,
                       CUST_STATUS,
                       MOBILE_NO,
                       CUST_NAME,
                       BRANCH_CODE,
                       MAIL_ID,
                       CUST_DOB
                  INTO vUserId,
                       vUserStatus,
                       vMobileNo,
                       vCustName,
                       vBranchCode,
                       vMail,
                       vDob
                  FROM JSON_TABLE (
                           GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                                  ' SELECT a.MEMBER_CODE, a.CUST_STATUS, a.MOBILE_NO ,FIRST_NAME||'' ''||LAST_NAME   CUST_NAME ,BRANCH_CODE,MAIL_ID,CUST_DOB
                  FROM EMOB.MB_CUSTOMER_MST a
                 WHERE a.MEMBER_CODE = '''
                               || pUserId
                               || ''''),
                           '$.items[0].resultSet.items[*]'
                           COLUMNS (
                               MEMBER_CODE VARCHAR2 PATH '$.member_code',
                               CUST_STATUS VARCHAR2 PATH '$.cust_status',
                               MOBILE_NO VARCHAR2 PATH '$.mobile_no',
                               CUST_NAME VARCHAR2 PATH '$.cust_name',
                               BRANCH_CODE VARCHAR2 PATH '$.branch_code',
                               MAIL_ID VARCHAR2 PATH '$.mail_id',
                               CUST_DOB VARCHAR2 PATH '$.cust_dob'));
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Invalid User.';
                    RAISE vMyException;
            END;

            IF vUserStatus != 'ACT'
            THEN
                vErrorMessage := 'User Not Active.';
                RAISE vMyException;
            END IF;
        END IF;

        BEGIN
              SELECT OTP
                INTO vOtp
                FROM GUMS.APPS_OTP
               WHERE     UPPER (USER_CODE) = UPPER (pUserId)
                     AND MOBILE_NO = vMobileNo
                     AND DEVICE_ID = pDeviceId
                     AND USER_TYPE = pUserType
            ORDER BY OTP_ID DESC
               FETCH FIRST 1 ROW ONLY;
        /*AND OTP_ID =
            (SELECT MAX (OTP_ID)
               FROM GUMS.APPS_OTP
              WHERE     UPPER (USER_CODE) = UPPER (pUserId)
                    AND MOBILE_NO = vMobileNo
                    AND DEVICE_ID = pDeviceId
                    AND USER_TYPE = pUserType);*/
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Invalid OTP.';
                RAISE vMyException;
        END;

        IF pOTP != vOtp
        THEN
            vErrorMessage := 'OTP Not Matched.';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT COUNT (1)
              INTO vCount
              FROM GUMS.APPS_DEVICE_ACTIVATION
             WHERE                                     --DEVICE_ID = pDeviceId
                   --  AND
                    UPPER (USER_CODE) = UPPER (pUserId);
        END;

        IF vCount != 0
        THEN
            BEGIN
                UPDATE GUMS.APPS_DEVICE_ACTIVATION
                   SET STATUS = 'I', INACTIVE_DATE = SYSDATE
                 WHERE                                 --DEVICE_ID = pDeviceId
                       -- AND
                        UPPER (USER_CODE) = UPPER (pUserId);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage :=
                        'Device Info. Update Problem.' || SQLERRM;
                    RAISE vMyException;
            END;
        END IF;

        BEGIN
            INSERT INTO GUMS.APPS_DEVICE_ACTIVATION (DEVICE_ID,
                                                     USER_CODE,
                                                     STATUS,
                                                     INACTIVE_DATE,
                                                     CREATE_BY,
                                                     CREATE_DATE)
                 VALUES (pDeviceId,
                         UPPER (pUserId),
                         'A',
                         NULL,
                         UPPER (pUserId),
                         SYSDATE);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Device Info. Table Insert Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF pUserType = 'BN'
        THEN
            SELECT CAST (
                       FROM_TZ (
                           TO_TIMESTAMP (
                               TO_CHAR (
                                   TO_TIMESTAMP_TZ (
                                       vDob,
                                       'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
                                   'YYYY-MM-DD HH24:MI:SS'),
                               'YYYY-MM-DD HH24:MI:SS'),
                           'UTC')
                           AT TIME ZONE 'Asia/Dhaka'
                           AS DATE)
              INTO vDOB
              FROM DUAL;


            BEGIN
                SELECT GUMS.DPK_SECURITY.DFN_CREATE_PASSWORD_ENCRYPTED (
                           UPPER (pUserId),
                           pPassword)
                  INTO vOutPassword
                  FROM DUAL;
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Password Encryption Problem.';
                    RAISE vMyException;
            END;

            BEGIN
                SELECT COUNT (1)
                  INTO vCountUser
                  FROM GUMS.APPS_USER_MST
                 WHERE USER_ID = pUserId;
            END;

            IF vCountUser = 0
            THEN
                BEGIN
                    INSERT INTO GUMS.APPS_USER_MST (USER_ID,
                                                    USER_CODE,
                                                    USER_NAME,
                                                    USER_PWD,
                                                    USER_STS,
                                                    USER_DOB,
                                                    MOBILE_NO,
                                                    EMAIL_ID,
                                                    INV_LOGIN_CNT,
                                                    LOGON_PASS_CHANGE,
                                                    BRANCH_CODE,
                                                    CREATE_BY,
                                                    CREATE_DATE,
                                                    UPDATE_BY,
                                                    UPDATE_DATE,
                                                    AUTH_BY,
                                                    AUTH_DATE,
                                                    AUTH_REMARKS)
                         VALUES (pUserId,
                                 pUserId,
                                 vCustName,
                                 vOutPassword,
                                 'A',
                                 vDob,
                                 vMobileNo,
                                 vMail,
                                 0,
                                 NULL,
                                 vBranchCode,
                                 pUserId,
                                 SYSDATE,
                                 NULL,
                                 NULL,
                                 NULL,
                                 NULL,
                                 NULL);
                END;
            ELSE
                BEGIN
                    SELECT USER_PWD
                      INTO vUserPwd
                      FROM GUMS.APPS_USER_MST
                     WHERE USER_CODE = pUserId;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        vErrorMessage := 'Password Findind Problem.';
                        RAISE vMyException;
                END;

                IF vOutPassword != vUserPwd
                THEN
                    vErrorMessage := 'Password Not Valid.';
                    RAISE vMyException;
                END IF;
            END IF;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pStatus := 'F';
            pMessage := vErrorMessage;
    END;

    PROCEDURE PRC_LOGIN (pUserType           VARCHAR2,
                         pUserId             VARCHAR2,
                         pPassword           VARCHAR2,
                         pDeviceId           VARCHAR2,
                         pToken          OUT VARCHAR2,
                         pUserName       OUT VARCHAR2,
                         pUserMobileNo   OUT VARCHAR2,
                         pUserMail       OUT VARCHAR2,
                         pStatus         OUT VARCHAR2,
                         pMessage        OUT VARCHAR2)
    IS
        vErrorMessage       VARCHAR2 (1024);
        vUserID             NUMBER;
        VInvLoginCnt        NUMBER;
        vMaxInvLoginAllow   NUMBER;
        vErrorFlag          VARCHAR2 (1);
        vDeviceCount        NUMBER;
        vLogId              NUMBER;
        vUserStatus         VARCHAR2 (5);
        vUserPwd            VARCHAR2 (100);
        vOutPassword        VARCHAR2 (100);
        vMobileNo           VARCHAR2 (20);
        vUserName           VARCHAR2 (200);
        vDob                DATE;
        vEmail              VARCHAR2 (100);
        vBranch             VARCHAR2 (5);
        l_token             VARCHAR2 (4000);
        vMyException        EXCEPTION;
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pUserType IS NULL
        THEN
            vErrorMessage := 'User Type Required.';
            RAISE vMyException;
        END IF;

        IF pUserId IS NULL
        THEN
            vErrorMessage := 'Please Enter Your User ID.';
            RAISE vMyException;
        END IF;

        IF pPassword IS NULL
        THEN
            vErrorMessage := 'Please Enter Your Password.';
            RAISE vMyException;
        END IF;

        IF pDeviceId IS NULL
        THEN
            vErrorMessage := 'Device Id Required.';
            RAISE vMyException;
        END IF;

        IF pUserType = 'FO'
        THEN
            BEGIN
                SELECT a.USER_ID,
                       a.USER_STS,
                       a.USER_PWD,
                       a.USER_NAME,
                       a.USER_DOB,
                       a.EMAIL_ID,
                       a.MOBILE_NO,
                       a.BRANCH_CODE,
                       a.INV_LOGIN_CNT
                  INTO vUserId,
                       vUserStatus,
                       vUserPwd,
                       vUserName,
                       vDob,
                       vEmail,
                       vMobileNo,
                       vBranch,
                       vInvLoginCnt
                  FROM GUMS.MB_USER_MST a
                 WHERE UPPER (a.USER_CODE) = UPPER (pUserId);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Invalid User.';
                    RAISE vMyException;
            END;

            IF vUserStatus != 'A'
            THEN
                IF vUserStatus = 'L'
                THEN
                    vErrorMessage := 'User is Locked.';
                    RAISE vMyException;
                ELSIF vUserStatus = 'I'
                THEN
                    vErrorMessage := 'Invalid Login Credentials.';
                    RAISE vMyException;
                ELSIF vUserStatus = 'H'
                THEN
                    vErrorMessage := 'User Temporarily Hold.';
                    RAISE vMyException;
                END IF;
            END IF;
        ELSIF pUserType = 'BN'
        THEN
            BEGIN
                SELECT a.USER_ID,
                       a.USER_STS,
                       a.USER_PWD,
                       a.USER_NAME,
                       a.USER_DOB,
                       a.EMAIL_ID,
                       a.MOBILE_NO,
                       a.BRANCH_CODE,
                       a.INV_LOGIN_CNT
                  INTO vUserId,
                       vUserStatus,
                       vUserPwd,
                       vUserName,
                       vDob,
                       vEmail,
                       vMobileNo,
                       vBranch,
                       vInvLoginCnt
                  FROM GUMS.APPS_USER_MST a
                 WHERE UPPER (a.USER_CODE) = UPPER (pUserId);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Invalid User.' || SQLERRM;
                    RAISE vMyException;
            END;

            IF vUserStatus != 'A'
            THEN
                vErrorMessage := 'Invalid User.';
                RAISE vMyException;
            END IF;
        END IF;

        BEGIN
            SELECT COUNT (1)
              INTO vDeviceCount
              FROM GUMS.APPS_DEVICE_ACTIVATION
             WHERE     DEVICE_ID = pDeviceId
                   AND UPPER (USER_CODE) = UPPER (pUserId)
                   AND STATUS = 'A';
        END;

        IF vDeviceCount = 0
        THEN
            vErrorMessage := 'Device Not Registrated.';
            RAISE vMyException;
        END IF;

        IF vUserStatus = 'A'
        THEN
            BEGIN
                SELECT MAX_INV_LOGIN
                  INTO vMaxInvLoginAllow
                  FROM GUMS.MB_GLOBAL_RULE;
            END;

            IF pUserType = 'FO'
            THEN
                BEGIN
                    SELECT GUMS.DPK_SECURITY.DFN_CREATE_PASSWORD_ENCRYPTED (
                               UPPER (pUserId) || vUserId,
                               pPassword)
                      INTO vOutPassword
                      FROM DUAL;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        vErrorMessage := 'Password Encryption Problem.';
                        RAISE vMyException;
                END;
            ELSIF pUserType = 'BN'
            THEN
                BEGIN
                    SELECT GUMS.DPK_SECURITY.DFN_CREATE_PASSWORD_ENCRYPTED (
                               UPPER (pUserId),
                               pPassword)
                      INTO vOutPassword
                      FROM DUAL;
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        vErrorMessage := 'Password Encryption Problem.';
                        RAISE vMyException;
                END;
            END IF;
        END IF;

        IF vOutPassword != vUserPwd
        THEN
            IF vInvLoginCnt + 1 = vMaxInvLoginAllow
            THEN
                IF pUserType = 'FO'
                THEN
                    BEGIN
                        UPDATE GUMS.MB_USER_MST
                           SET USER_STS = 'L'
                         WHERE UPPER (USER_CODE) = UPPER (pUserId);
                    END;

                    COMMIT;
                    vErrorMessage :=
                        'Login Denied, Maximum Invalid Try Exceeded.';
                    RAISE vMyException;

                    BEGIN
                        UPDATE GUMS.MB_USER_MST
                           SET INV_LOGIN_CNT = INV_LOGIN_CNT + 1
                         WHERE UPPER (USER_CODE) = UPPER (pUserId);
                    END;
                ELSIF pUserType = 'BN'
                THEN
                    BEGIN
                        UPDATE GUMS.APPS_USER_MST
                           SET USER_STS = 'L'
                         WHERE UPPER (USER_CODE) = UPPER (pUserId);
                    END;

                    COMMIT;
                    vErrorMessage :=
                        'Login Denied, Maximum Invalid Try Exceeded.';
                    RAISE vMyException;

                    BEGIN
                        UPDATE GUMS.APPS_USER_MST
                           SET INV_LOGIN_CNT = INV_LOGIN_CNT + 1
                         WHERE UPPER (USER_CODE) = UPPER (pUserId);
                    END;
                END IF;
            END IF;

            BEGIN
                GUMS.PKG_STORE_LOG.PRC_FAILED_LOGIN (
                    pUserId         => vUserID,
                    pUserCode       => UPPER (pUserId),
                    pSessionId      => NULL,
                    pErrorFlag      => vErrorFlag,
                    pErrorMessage   => vErrorMessage);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage :=
                        'Application Temporarily Not Responding. Please Contact With Head Office.';
                    RAISE vMyException;
            END;

            IF vErrorFlag = 'Y'
            THEN
                RAISE vMyException;
            END IF;

            COMMIT;
            vErrorMessage := 'Invalid Login Credentials.';
            RAISE vMyException;
        ELSE
            IF vInvLoginCnt > 0
            THEN
                IF pUserType = 'FO'
                THEN
                    BEGIN
                        UPDATE GUMS.MB_USER_MST
                           SET INV_LOGIN_CNT = 0
                         WHERE UPPER (USER_CODE) = UPPER (pUserId);
                    END;
                ELSIF pUserType = 'BN'
                THEN
                    BEGIN
                        UPDATE GUMS.APPS_USER_MST
                           SET INV_LOGIN_CNT = 0
                         WHERE UPPER (USER_CODE) = UPPER (pUserId);
                    END;
                END IF;
            END IF;

            BEGIN
                GUMS.PKG_STORE_LOG.PRC_SUCCESS_LOGIN (
                    pUserId         => vUserId,
                    pUserCode       => UPPER (pUserId),
                    pSessionId      => NULL,
                    pBranchCode     => vBranch,
                    pReqFrom        => 'APP',
                    pDeviceId       => pDeviceId,
                    pLogId          => vLogId,
                    pErrorFlag      => vErrorFlag,
                    pErrorMessage   => vErrorMessage);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Success Log Insert Problem.' || SQLERRM;
                    RAISE vMyException;
            END;

            IF NVL (vErrorFlag, 'N') = 'Y'
            THEN
                RAISE vMyException;
            END IF;

            /***
            use the apex_jwt package to generate the jwt token
            @param p_iss the issuer of the token
            @param p_sub the "sub" (subject) claim identifies the principal that is the
                   subject of the JWT
            @param p_aud the "aud" (audience) claim identifies the recipients
                   that the JWT is intended for
            @param p_iat_ts the "iat" (issued at) claim identifies the time at
                   which the JWT was issued
            @param p_exp_sec token expiration in seconds
            @param p_signature_key signature key used to encrypt the token
            ***/
            BEGIN
                l_token :=
                    apex_jwt.encode (
                        p_iss       => 'PSB',
                        p_sub       => pUserId,
                        -- p_aud             => pUserPass, --'Admins',              --l_user_role,
                        p_iat_ts    => SYSDATE,
                        p_exp_sec   => 3600 * 24,
                        -- p_jti             => vMobileNo,
                        p_other_claims   =>
                               '"user_id": '
                            || apex_json.stringify (vUserId)
                            || ',"user_code":'
                            || apex_json.stringify (pUserId)
                            || ',"mobile_no": '
                            || apex_json.stringify (vMobileNo)
                            || ',"user_name": '
                            || apex_json.stringify (vUserName)
                            || ',"log_id": '
                            || apex_json.stringify (vLogId)
                            || ',"email": '
                            || apex_json.stringify (vEmail)
                            || ',"branch_code": '
                            || apex_json.stringify (vBranch),
                        p_signature_key   =>
                            sys.UTL_RAW.cast_to_raw ('PSBfoMobileApPS2024'));
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Token Encoding Problem.' || SQLERRM;
                    RAISE vMyException;
            --return the token with success message in json format
            END;

            ptoken := l_token;
            pUserName := vUserName;
            pUserMobileNo := vMobileNo;
            pUserMail := vEmail;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pStatus := 'F';
            pMessage := vErrorMessage;
    END;

    PROCEDURE GET_API_TOKEN (Client_Id       IN VARCHAR2,
                             Client_Secret   IN VARCHAR2)
    IS
        vOutputInfo      VARCHAR2 (1024);
        vClient_Id       VARCHAR2 (1024);
        vClient_Secret   VARCHAR2 (1024);
        vUrl             VARCHAR2 (500);
        vMyException     EXCEPTION;
    BEGIN
        /*  SELECT CLIENT_ID, CLIENT_SECRET
            INTO Client_Id, Client_Secret
            FROM user_ords_clients
           WHERE name LIKE 'Mobile Apps';*/


        IF Client_Id IS NULL
        THEN
            vOutputInfo := 'Client ID Found Null. ';
            RAISE vMyException;
        END IF;

        IF Client_Secret IS NULL
        THEN
            vOutputInfo := 'Client Secrate Found Null. ';
            RAISE vMyException;
        END IF;

        SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

        apex_web_service.oauth_authenticate (
            p_token_url       => vUrl || '/psb/api/oauth/token',
            p_client_id       => Client_Id,
            p_client_secret   => Client_Secret);

        vOutputInfo := apex_web_service.oauth_get_last_token;

        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE ('status_code', 'Y');
        APEX_JSON.WRITE ('status_msg', 'Success');
        APEX_JSON.WRITE ('token', vOutputInfo);
        APEX_JSON.CLOSE_OBJECT;

        vOutputInfo := APEX_JSON.get_clob_output;
        HTP.PRINT (vOutputInfo);
        DBMS_OUTPUT.put_line (vOutputInfo);
    EXCEPTION
        WHEN vMyException
        THEN
            APEX_JSON.INITIALIZE_CLOB_OUTPUT;
            APEX_JSON.OPEN_OBJECT;
            APEX_JSON.WRITE ('status_code', 'N');
            APEX_JSON.WRITE ('status_msg', vOutputInfo);
            APEX_JSON.CLOSE_OBJECT;
            vOutputInfo := APEX_JSON.get_clob_output;
            APEX_JSON.FREE_OUTPUT;

            HTP.PRINT (vOutputInfo);
            DBMS_OUTPUT.put_line (vOutputInfo);
    END;

    FUNCTION PRC_MEMBER_LIST (pToken CLOB, pSamitiCode VARCHAR2)
        RETURN CLOB
    AS
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vUrl             VARCHAR2 (1024);
        vResponse        CLOB;
        vRequest         CLOB;
        vMyException     EXCEPTION;
        json_result      CLOB;
        vMemberList      CLOB;
        pStatus          VARCHAR2 (5);
        pMessage         VARCHAR2 (1024);
        vErrorMessage1   VARCHAR2 (1024);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;


        IF pSamitiCode IS NULL
        THEN
            vErrorMessage := 'Samiti Code Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_memeber_list/';

            vRequest := '{
    "samiti_code": "' || pSamitiCode || '"
}';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vMemberList := apex_json.get_varchar2 ('member_list');
            json_result :=
                   '{"STATUS":"'
                || pStatus
                || '","MESSAGE":"'
                || pMessage
                || '","MEMBER_LIST":'
                || vMemberList
                || '}';

            RETURN json_result;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;

    FUNCTION PRC_SAMITI_LIST (pToken CLOB)
        RETURN CLOB
    AS
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vUrl             VARCHAR2 (1024);
        vResponse        CLOB;
        vRequest         CLOB;
        vMyException     EXCEPTION;
        json_result      CLOB;
        vsamitiList      CLOB;
        pStatus          VARCHAR2 (5);
        pMessage         VARCHAR2 (1024);
        vErrorMessage1   VARCHAR2 (1024);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_samitee/';

            vRequest := '{
    "pbranchcode": "' || vBranchCode || '"
}';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vSamitiList := apex_json.get_varchar2 ('samiti_list');
            json_result :=
                   '{"STATUS":"'
                || pStatus
                || '","MESSAGE":"'
                || pMessage
                || '","SAMITI_LIST":'
                || vSamitiList
                || '}';

            RETURN json_result;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;

    FUNCTION PRC_AC_LIST (pToken CLOB, pMemberCode VARCHAR2)
        RETURN CLOB
    AS
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vUrl             VARCHAR2 (1024);
        vResponse        CLOB;
        vRequest         CLOB;
        vMyException     EXCEPTION;
        json_result      CLOB;
        vAcList          CLOB;
        pStatus          VARCHAR2 (5);
        pMessage         VARCHAR2 (1024);
        vErrorMessage1   VARCHAR2 (1024);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;


        IF pMemberCode IS NULL
        THEN
            vErrorMessage := 'Member Code Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token.';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_ac_list/';

            vRequest := '{
    "pmembercode": "' || pMemberCode || '"
                    }';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vAcList := apex_json.get_varchar2 ('ac_list');
            json_result :=
                   '{"STATUS":"'
                || pStatus
                || '","MESSAGE":"'
                || pMessage
                || '","AC_LIST":'
                || vAcList
                || '}';

            RETURN json_result;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;

    FUNCTION PRC_LOAN_AC_LIST (pToken        CLOB,
                               pMemberCode   VARCHAR2,
                               pAmount       NUMBER)
        RETURN CLOB
    AS
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vUrl             VARCHAR2 (1024);
        vResponse        CLOB;
        vRequest         CLOB;
        vMyException     EXCEPTION;
        json_result      CLOB;
        vAcList          CLOB;
        pStatus          VARCHAR2 (5);
        pMessage         VARCHAR2 (1024);
        vErrorMessage1   VARCHAR2 (1024);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;


        IF pMemberCode IS NULL
        THEN
            vErrorMessage := 'Member Code Required.';
            RAISE vMyException;
        END IF;

        IF pAmount IS NULL
        THEN
            vErrorMessage := 'Amount Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token.';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_loan_ac_list/';

            vRequest := '{
    "pmembercode": "' || pMemberCode || '",
     "pamount": "' || pAmount || '"
                    }';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vAcList := apex_json.get_varchar2 ('ac_list');
            json_result :=
                   '{"STATUS":"'
                || pStatus
                || '","MESSAGE":"'
                || pMessage
                || '","AC_LIST":'
                || vAcList
                || '}';

            RETURN json_result;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;

    FUNCTION PRC_LOAN_AC_INFO (pToken CLOB, pAcNo VARCHAR2, pAmount NUMBER)
        RETURN CLOB
    AS
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vUrl             VARCHAR2 (1024);
        vResponse        CLOB;
        vRequest         CLOB;
        vMyException     EXCEPTION;
        json_result      CLOB;
        vAcList          CLOB;
        pStatus          VARCHAR2 (5);
        pMessage         VARCHAR2 (1024);
        vErrorMessage1   VARCHAR2 (1024);
        vFlag            VARCHAR2 (5);
        vMessage         VARCHAR2 (1024);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;


        IF pAcNo IS NULL
        THEN
            vErrorMessage := 'A/C No. Required.';
            RAISE vMyException;
        END IF;

        IF pAmount IS NULL
        THEN
            vErrorMessage := 'Amount Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token.';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_loan_ac_info/';

            vRequest := '{
    "pacno": "' || pAcNo || '",
     "pamount": "' || pAmount || '"
                    }';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vAcList := apex_json.get_varchar2 ('ac_list');
            vFlag := apex_json.get_varchar2 ('perrorflag');
            vMessage := apex_json.get_varchar2 ('perrormessage');

            IF vFlag = 'F'
            THEN
                json_result :=
                       '{"STATUS":"'
                    || vFlag
                    || '","MESSAGE":"'
                    || vMessage
                    || '"}';

                RETURN json_result;
            ELSE
                json_result :=
                       '{"STATUS":"'
                    || pStatus
                    || '","MESSAGE":"'
                    || pMessage
                    || '","AC_LIST":'
                    || vAcList
                    || '}';
                RETURN json_result;
            END IF;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;

    PROCEDURE GET_DEPOSIT_AC_INFO (pToken                   CLOB,
                                   pAcNo                    VARCHAR2,
                                   pAcId                OUT NUMBER,
                                   pAcTypeId            OUT NUMBER,
                                   pCustNo              OUT NUMBER,
                                   pCustCode            OUT VARCHAR2,
                                   pAcTitle             OUT VARCHAR2,
                                   pAcBranch            OUT VARCHAR2,
                                   pAvailableBalance    OUT NUMBER,
                                   pBlockAmount         OUT NUMBER,
                                   pMobileNo            OUT VARCHAR2,
                                   pAcType              OUT VARCHAR2,
                                   pDepNature           OUT VARCHAR2,
                                   pAcStatus            OUT VARCHAR2,
                                   pTimePeriod          OUT NUMBER,
                                   pDueIns              OUT NUMBER,
                                   pPaidIns             OUT NUMBER,
                                   pInsAmount           OUT NUMBER,
                                   pDpsTotalInsAmt      OUT NUMBER,
                                   pDpsInsPenal         OUT NUMBER,
                                   pTotalAmt            OUT NUMBER,
                                   pChargeCrGlAc        OUT VARCHAR2,
                                   pEffDate             OUT VARCHAR2,
                                   pTotalAmtwithPenal   OUT VARCHAR2,
                                   pErrorFlag           OUT VARCHAR2,
                                   pErrorMessage        OUT VARCHAR2)
    IS
        vMyException     EXCEPTION;
        vErrorFlag       VARCHAR2 (1);
        vErrorMessage    VARCHAR2 (1024);
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage1   VARCHAR2 (1024);
    BEGIN
        pErrorFlag := 'S';
        pErrorMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Token Required.';
            RAISE vMyException;
        END IF;

        IF pAcNo IS NULL
        THEN
            vErrorMessage := 'Account No. Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;

        IF vBranchCode IS NOT NULL
        THEN
            BEGIN
                GUMS.CORE_TRANSACTION.GET_AC_INFO_DEPOSIT (
                    pAcNo               => pAcNo,
                    pBranchCode         => vBranchCode,
                    pAcId               => pAcId,
                    pAcTypeId           => pAcTypeId,
                    pCustNo             => pCustNo,
                    pCustCode           => pCustCode,
                    pAcTitle            => pAcTitle,
                    pAcBranch           => pAcBranch,
                    pAvailableBalance   => pAvailableBalance,
                    pBlockAmount        => pBlockAmount,
                    pMobileNo           => pMobileNo,
                    pAcType             => pAcType,
                    pDepNature          => pDepNature,
                    pAcStatus           => pAcStatus,
                    pErrorFlag          => vErrorFlag,
                    pErrorMessage       => vErrorMessage);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage :=
                        'Core API Not Working. Please Contact With Head Office.';
                    RAISE vMyException;
            END;

            IF vErrorFlag = 'Y'
            THEN
                vErrorMessage := vErrorMessage;
                RAISE vMyException;
            END IF;


            IF pDepNature = 'C'
            THEN
                BEGIN
                    GUMS.PKG_DPS_AC_CASH_TRANSACTION.PRC_DPS_CASH_INFO (
                        pAcTypeId         => pAcTypeId,
                        pAcId             => pAcId,
                        pOprBranch        => vBranchCode,
                        pTimePeriod       => pTimePeriod,
                        pDueIns           => pDueIns,
                        pPaidIns          => pPaidIns,
                        pInsAmount        => pInsAmount,
                        pDpsTotalInsAmt   => pDpsTotalInsAmt,
                        pDpsInsPenal      => pDpsInsPenal,
                        pTotalAmt         => pTotalAmt,
                        pChargeCrGlAc     => pChargeCrGlAc,
                        pEffDate          => pEffDate,
                        pErrorFlag        => vErrorFlag,
                        pErrorMessage     => vErrorMessage);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        vErrorMessage :=
                            'Core API (DPS) Not Working. Please Contact With Head Office.';
                        RAISE vMyException;
                END;

                IF NVL (vErrorFlag, 'N') = 'Y'
                THEN
                    vErrorMessage := vErrorMessage;
                    RAISE vMyException;
                END IF;

                pTotalAmtwithPenal :=
                    NVL (pDpsTotalInsAmt, 0) + NVL (pDpsInsPenal, 0);
            END IF;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'F';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE PRC_TRANSACTION_DEPOSIT_AC (pToken              CLOB,
                                          pInputBody          BLOB,
                                          pDocNum         OUT CLOB,
                                          pErrorFlag      OUT VARCHAR2,
                                          pErrorMessage   OUT VARCHAR2)
    IS
        vMyException     EXCEPTION;
        vErrorFlag       VARCHAR2 (1);
        vErrorMessage    VARCHAR2 (1024);
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage1   VARCHAR2 (1024);
        vUrl             VARCHAR2 (500);
        vRequest         CLOB;
        vResponse        CLOB;
        vClob            CLOB;
        vdocnum          VARCHAR2 (20);
        l_CLOB           CLOB;
        vErrorMessage2   VARCHAR2 (200);
    BEGIN
        pErrorFlag := 'S';
        pErrorMessage := 'SUCCESS';

        IF pInputBody IS NULL
        THEN
            vErrorMessage := 'Input Body Required.';
            RAISE vMyException;
        END IF;

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Token Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;

        /*SELECT TO_CLOB (UTL_RAW.CAST_TO_VARCHAR2 (pInputBody))
          INTO vClob
          FROM DUAL;*/

        l_CLOB := apex_web_service.blob2clobbase64 (pInputBody);

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/apps_deposit_transaction/';
            vRequest :=
                   '
  {     "pbranchcode": "'
                || vBranchCode
                || '",
        "puserid": "'
                || vuserid
                || '",
        "plogid": "'
                || vlogid
                || '",
        "pinput": "'
                || l_CLOB
                || '"
}}
';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.' || SQLERRM;
                    RAISE vMyException;
            END;

            BEGIN
                apex_json.parse (vResponse);
                vDocNum := apex_json.get_varchar2 ('pdocnum');
                vErrorFlag := apex_json.get_varchar2 ('perrorflag');
                vErrorMessage2 := apex_json.get_varchar2 ('perrormessage');
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Parsing Problem.' || SQLERRM;
                    RAISE vMyException;
            END;

            IF NVL (vErrorFlag, 'N') = 'Y' OR vDocNum IS NULL
            THEN
                vErrorMessage := vErrorMessage2;
                RAISE vMyException;
            END IF;
        END;

        pDocNum := vDocNum;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'F';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE PRC_LOGOUT (pToken              CLOB,
                          pErrorFlag      OUT VARCHAR2,
                          pErrorMessage   OUT VARCHAR2)
    IS
        vMyException     EXCEPTION;
        vErrorMessage    VARCHAR2 (1024);
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage1   VARCHAR2 (1024);
    BEGIN
        pErrorFlag := 'S';
        pErrorMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Token Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.DPK_SECURITY.PRC_UPDATE_LOGOUT_INFORMATION (vLogId);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'LogId Update Problem.' || SQLERRM;
                RAISE vMyException;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'F';
            pErrorMessage := vErrorMessage;
    END;

    FUNCTION PRC_AC_STATEMENT_LIST (pToken      CLOB,
                                    pAcNo       VARCHAR2,
                                    pFromDate   VARCHAR2,
                                    pToDate     VARCHAR2)
        RETURN CLOB
    AS
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vUrl             VARCHAR2 (1024);
        vResponse        CLOB;
        vRequest         CLOB;
        vMyException     EXCEPTION;
        json_result      CLOB;
        vTranList        CLOB;
        pStatus          VARCHAR2 (5);
        pMessage         VARCHAR2 (1024);
        vErrorMessage1   VARCHAR2 (1024);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;


        IF pAcNo IS NULL
        THEN
            vErrorMessage := 'A/C No Required.';
            RAISE vMyException;
        END IF;

        IF pFromDate IS NULL
        THEN
            vErrorMessage := 'From Date Required.';
            RAISE vMyException;
        END IF;

        IF pToDate IS NULL
        THEN
            vErrorMessage := 'To Date Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_ac_statement_apps/';


            vRequest := '{
    "pacno": "' || pAcNo || '",
    "pfromdate": "' || pfromDate || '",
    "ptodate": "' || pTodate || '"
}';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vTranList := apex_json.get_varchar2 ('ptranlist');
            json_result :=
                   '{"STATUS":"'
                || pStatus
                || '","MESSAGE":"'
                || pMessage
                || '","TRAN_LIST":'
                || vTranList
                || '}';

            RETURN json_result;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;

    PROCEDURE GET_UNSETTLE_AMOUNT (pToken              CLOB,
                                   pAmount         OUT NUMBER,
                                   pErrorFlag      OUT VARCHAR2,
                                   pErrorMessage   OUT VARCHAR2)
    IS
        vMyException     EXCEPTION;
        vErrorMessage    VARCHAR2 (1024);
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage1   VARCHAR2 (1024);
        vAmount          NUMBER;
    BEGIN
        pErrorFlag := 'S';
        pErrorMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Token Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;


        BEGIN
            SELECT NVL (NET_AMOUNT, 0)
              INTO vAmount
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT  (
             (SELECT NVL(SUM (AMOUNT),0)
                FROM EMOB.APPS_TRANSACTION_MST
               WHERE     TRAN_CODE = ''53''
                     AND OPR_TYPE = ''DEPOSIT''
                     AND FO_USER_ID = ''' || vUserId || '''
                     AND STATUS = ''A'')
           - (SELECT NVL(SUM (AMOUNT),0)
                FROM EMOB.APPS_TRANSACTION_MST
               WHERE     TRAN_CODE = ''54''
                     AND OPR_TYPE = ''SETTLE''
                     AND FO_USER_ID = ''' || vUserId || '''
                     AND STATUS = ''A''))    AS NET_AMOUNT
  FROM DUAL'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (NET_AMOUNT VARCHAR2 PATH '$.net_amount'));
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Amount Finding Problem.';
                RAISE vMyException;
        END;

        pAmount := vAmount;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'F';
            pErrorMessage := vErrorMessage;
    END;

    FUNCTION PRC_DEPOSIT_HISTORY_LIST (pToken      CLOB,
                                       pFromDate   VARCHAR2,
                                       pToDate     VARCHAR2)
        RETURN CLOB
    AS
        vUserId            VARCHAR2 (50);
        vMobileNo          VARCHAR2 (20);
        vUserCode          VARCHAR2 (200);
        vUserName          VARCHAR2 (200);
        vEmail             VARCHAR2 (200);
        vBranchCode        VARCHAR2 (10);
        vStatus            VARCHAR2 (5);
        vLogId             VARCHAR2 (10);
        vErrorMessage      VARCHAR2 (1024);
        vUrl               VARCHAR2 (1024);
        vResponse          CLOB;
        vRequest           CLOB;
        vMyException       EXCEPTION;
        json_result        CLOB;
        vTranHistoryList   CLOB;
        pStatus            VARCHAR2 (5);
        pMessage           VARCHAR2 (1024);
        vErrorMessage1     VARCHAR2 (1024);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_deposit_history/';

            vRequest := '{
    "puserid": "' || vUserId || '",
    "pfromdate": "' || pFromDate || '",
    "ptodate": "' || pToDate || '"
}';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vTranHistoryList := apex_json.get_varchar2 ('poutput');
            json_result :=
                   '{"STATUS":"'
                || pStatus
                || '","MESSAGE":"'
                || pMessage
                || '","DEPOSIT_LIST":'
                || vTranHistoryList
                || '}';

            RETURN json_result;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;

    PROCEDURE PRC_PASSWORD_FORGOT (pUserType           VARCHAR2,
                                   pUserCode           VARCHAR2,
                                   pUserDOB            VARCHAR2,
                                   pDeviceId           VARCHAR2,
                                   pErrorFlag      OUT VARCHAR2,
                                   pErrorMessage   OUT VARCHAR2)
    IS
        vUserId         NUMBER;
        vMailNo         VARCHAR2 (200);
        vMyException    EXCEPTION;
        vMobileNo       VARCHAR2 (20);
        vCustomerCode   VARCHAR2 (10);
        vOTP            NUMBER;
        vCount          NUMBER;
        vErrorFlag      VARCHAR2 (1);
        vErrorMessage   VARCHAR2 (1024);
    BEGIN
        pErrorFlag := 'S';
        pErrorMessage := 'SUCCESS';

        IF pUserType IS NULL
        THEN
            vErrorMessage := 'User Type Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pUserCode IS NULL
        THEN
            vErrorMessage := 'Requested User Code Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pUserDOB IS NULL
        THEN
            vErrorMessage := 'Date Of Birth Not Be Blank.';
            RAISE vMyException;
        END IF;


        IF pDeviceId IS NULL
        THEN
            vErrorMessage := 'Device Id Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pUserType = 'FO'
        THEN
            BEGIN
                SELECT COUNT (1)
                  INTO vCount
                  FROM GUMS.APPS_DEVICE_ACTIVATION
                 WHERE     UPPER (USER_CODE) = UPPER (pUserCode)
                       AND DEVICE_ID = pDeviceId
                       AND STATUS = 'A';
            END;

            IF vCount = 0
            THEN
                vErrorMessage := 'Device Not Registrated Yet.';
                RAISE vMyException;
            END IF;

            BEGIN
                SELECT USER_ID, EMAIL_ID, MOBILE_NO
                  INTO vUserId, vMailNo, vMobileNo
                  FROM GUMS.MB_USER_MST
                 WHERE USER_CODE = UPPER (pUserCode) AND USER_DOB = pUserDOB;
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Credential Not Valid.';
                    RAISE vMyException;
            END;

            vCustomerCode := NULL;
        ELSIF pUserType = 'BN'
        THEN
            BEGIN
                SELECT USER_ID,
                       EMAIL_ID,
                       MOBILE_NO,
                       USER_CODE
                  INTO vUserId,
                       vMailNo,
                       vMobileNo,
                       vCustomerCode
                  FROM GUMS.APPS_USER_MST
                 WHERE USER_CODE = UPPER (pUserCode) AND USER_DOB = pUserDOB;
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Credential Not Valid.';
                    RAISE vMyException;
            END;
        END IF;

        BEGIN
            SELECT TO_CHAR (TRUNC (DBMS_RANDOM.VALUE (1000, 9999)))
              INTO vOTP
              FROM DUAL;
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'OTP Creation Problem.';
                RAISE vMyException;
        END;

        BEGIN
            INSERT INTO GUMS.APPS_OTP (OTP_ID,
                                       USER_CODE,
                                       MOBILE_NO,
                                       DEVICE_ID,
                                       OTP,
                                       CREATE_BY,
                                       USER_TYPE)
                 VALUES (GUMS.APPS_OTP_ID_SEQ.NEXTVAL,
                         UPPER (pUserCode),
                         vMobileNo,
                         pDeviceId,
                         vOTP,
                         UPPER (pUserCode),
                         pUserType);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'OTP Generation Problem.';
                RAISE vMyException;
        END;

        BEGIN
            GUMS.PRC_SMS_GENERATION (
                pCustomerCode    => vCustomerCode,
                pAccountNo       => NULL,
                pAccountTypeId   => NULL,
                pMobileNo        => vMobileNo,
                pAmount          => NULL,
                pMessageType     => 'OTP',
                pMessage         => 'Your Current OTP is :' || vOTP,
                pRunUser         => UPPER (pUserCode),
                pErrorFlag       => vErrorFlag,
                pErrorMessage    => vErrorMessage);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'OTP Insert Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF NVL (vErrorFlag, 'N') = 'Y'
        THEN
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pErrorFlag := 'F';
            pErrorMessage := vErrorMessage;
    END;

    PROCEDURE PRC_PASSWORD_FORGOT_OTP_VERIFICATION (
        pUserType           VARCHAR2,
        pUserCode           VARCHAR2,
        pPassword           VARCHAR2,
        pDeviceId           VARCHAR2,
        pOTP                VARCHAR2,
        pErrorFlag      OUT VARCHAR2,
        pErrorMessage   OUT VARCHAR2)
    IS
        vNextSlNo       NUMBER;
        vEncryptPass    VARCHAR2 (200);
        vUserId         NUMBER;
        vMailNo         VARCHAR2 (200);
        vMyException    EXCEPTION;
        vMobileNo       VARCHAR2 (20);
        vCustomerCode   VARCHAR2 (10);
        vOTP            NUMBER;
        vErrorFlag      VARCHAR2 (1);
        vErrorMessage   VARCHAR2 (1024);
    BEGIN
        pErrorFlag := 'S';
        pErrorMessage := 'SUCCESS';

        IF pUserType IS NULL
        THEN
            vErrorMessage := 'User Type Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pPassword IS NULL
        THEN
            vErrorMessage := 'Password Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pOTP IS NULL
        THEN
            vErrorMessage := 'OTP Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pDeviceId IS NULL
        THEN
            vErrorMessage := 'Device Id Not Be Blank.';
            RAISE vMyException;
        END IF;

        IF pUserType = 'FO'
        THEN
            BEGIN
                SELECT USER_ID, EMAIL_ID, MOBILE_NO
                  INTO vUserId, vMailNo, vMobileNo
                  FROM GUMS.MB_USER_MST
                 WHERE USER_CODE = UPPER (pUserCode);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Credential Not Valid.';
                    RAISE vMyException;
            END;

            BEGIN
                vEncryptPass :=
                    GUMS.DPK_SECURITY.DFN_CREATE_PASSWORD_ENCRYPTED (
                        UPPER (pUserCode) || vUserid,
                        pPassword);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage :=
                        'Password can not Reset. Please Contact System Administrator. ';
                    RAISE vMyException;
            END;

            BEGIN
                SELECT NVL (MAX (SERIAL_NO), 0) + 1
                  INTO vNextSlNo
                  FROM GUMS.MB_USER_PWD
                 WHERE USER_ID = vUserid;
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage :=
                        'Password can not Reset. Please Contact System Administrator. ';
                    RAISE vMyException;
            END;

            BEGIN
                UPDATE GUMS.MB_USER_MST
                   SET USER_PWD = vEncryptPass, LOGON_PASS_CHANGE = 'Y'
                 WHERE USER_ID = vUserid;
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'User Information Update Problem. ';
                    RAISE vMyException;
            END;

            IF SQL%ROWCOUNT <> 1
            THEN
                vErrorMessage :=
                    'Update Problem Contact System Administrator.';
                RAISE vMyException;
            END IF;

            BEGIN
                INSERT INTO GUMS.MB_USER_PWD (USER_ID,
                                              SERIAL_NO,
                                              USER_PWD,
                                              CREATE_BY)
                     VALUES (vUserid,
                             vNextSlNo,
                             vEncryptPass,
                             'SYSTEM');
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Password can not changed.';
                    RAISE vMyException;
            END;

            vCustomerCode := NULL;
        ELSIF pUserType = 'BN'
        THEN
            BEGIN
                SELECT USER_ID,
                       EMAIL_ID,
                       MOBILE_NO,
                       USER_CODE
                  INTO vUserId,
                       vMailNo,
                       vMobileNo,
                       vCustomerCode
                  FROM GUMS.APPS_USER_MST
                 WHERE USER_CODE = UPPER (pUserCode);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Credential Not Valid.';
                    RAISE vMyException;
            END;

            BEGIN
                vEncryptPass :=
                    GUMS.DPK_SECURITY.DFN_CREATE_PASSWORD_ENCRYPTED (
                        UPPER (pUserCode),
                        pPassword);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage :=
                        'Password can not Reset. Please Contact System Administrator.';
                    RAISE vMyException;
            END;

            BEGIN
                SELECT NVL (MAX (SERIAL_NO), 0) + 1
                  INTO vNextSlNo
                  FROM GUMS.APPS_USER_PWD
                 WHERE USER_ID = vUserid;
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage :=
                        'Password can not Reset. Please Contact System Administrator. ';
                    RAISE vMyException;
            END;

            BEGIN
                UPDATE GUMS.APPS_USER_MST
                   SET USER_PWD = vEncryptPass, LOGON_PASS_CHANGE = 'Y'
                 WHERE USER_ID = vUserid;
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'User Information Update Problem. ';
                    RAISE vMyException;
            END;

            IF SQL%ROWCOUNT <> 1
            THEN
                vErrorMessage :=
                    'Update Problem Contact System Administrator.';
                RAISE vMyException;
            END IF;

            BEGIN
                INSERT INTO GUMS.APPS_USER_PWD (USER_ID,
                                                SERIAL_NO,
                                                USER_PWD,
                                                CREATE_BY)
                     VALUES (vUserid,
                             vNextSlNo,
                             vEncryptPass,
                             'SYSTEM');
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Password can not changed. ';
                    RAISE vMyException;
            END;
        END IF;

        BEGIN
              SELECT OTP
                INTO vOtp
                FROM GUMS.APPS_OTP
               WHERE     UPPER (USER_CODE) = UPPER (pUserCode)
                     AND MOBILE_NO = vMobileNo
                     AND DEVICE_ID = pDeviceId
                     AND USER_TYPE = pUserType
            ORDER BY OTP_ID DESC
               FETCH FIRST 1 ROW ONLY;
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Invalid OTP.';
                RAISE vMyException;
        END;

        IF pOTP != vOtp
        THEN
            vErrorMessage := 'OTP Not Matched.';
            RAISE vMyException;
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pErrorFlag := 'F';
            pErrorMessage := vErrorMessage;
    END;

    FUNCTION PRC_AC_LIST_BN (pToken CLOB)
        RETURN CLOB
    AS
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vUrl             VARCHAR2 (1024);
        vResponse        CLOB;
        vRequest         CLOB;
        vMyException     EXCEPTION;
        json_result      CLOB;
        vAcList          CLOB;
        pStatus          VARCHAR2 (5);
        pMessage         VARCHAR2 (1024);
        vErrorMessage1   VARCHAR2 (1024);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token.';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_ac_list/';

            vRequest := '{
    "pmembercode": "' || vUserCode || '"
}';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vAcList := apex_json.get_varchar2 ('ac_list');
            json_result :=
                   '{"STATUS":"'
                || pStatus
                || '","MESSAGE":"'
                || pMessage
                || '","AC_LIST":'
                || vAcList
                || '}';

            RETURN json_result;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;

    FUNCTION PRC_AC_STATEMENT_LIST_BN (pToken      CLOB,
                                       pAcNo       VARCHAR2,
                                       pFromDate   VARCHAR2,
                                       pToDate     VARCHAR2)
        RETURN CLOB
    AS
        vUserId          VARCHAR2 (50);
        vMobileNo        VARCHAR2 (20);
        vUserCode        VARCHAR2 (200);
        vUserName        VARCHAR2 (200);
        vEmail           VARCHAR2 (200);
        vBranchCode      VARCHAR2 (10);
        vStatus          VARCHAR2 (5);
        vLogId           VARCHAR2 (10);
        vErrorMessage    VARCHAR2 (1024);
        vUrl             VARCHAR2 (1024);
        vResponse        CLOB;
        vRequest         CLOB;
        vMyException     EXCEPTION;
        json_result      CLOB;
        vTranList        CLOB;
        pStatus          VARCHAR2 (5);
        pMessage         VARCHAR2 (1024);
        vErrorMessage1   VARCHAR2 (1024);
        vMemberCode      VARCHAR2 (20);
    BEGIN
        pStatus := 'S';
        pMessage := 'SUCCESS';

        IF pToken IS NULL
        THEN
            vErrorMessage := 'Bearer Token Required.';
            RAISE vMyException;
        END IF;


        IF pAcNo IS NULL
        THEN
            vErrorMessage := 'A/C No Required.';
            RAISE vMyException;
        END IF;

        IF pFromDate IS NULL
        THEN
            vErrorMessage := 'From Date Required.';
            RAISE vMyException;
        END IF;

        IF pToDate IS NULL
        THEN
            vErrorMessage := 'To Date Required.';
            RAISE vMyException;
        END IF;

        BEGIN
            GUMS.APEX_JWT_TOKEN.TOKEN_VALIDATION (
                pAuthorization   => pToken,
                pUserId          => vUserId,
                pUserCode        => vUserCode,
                pUserName        => vUserName,
                pMobileNo        => vMobileNo,
                pEmail           => vEmail,
                pBranchCode      => vBranchCode,
                pLogId           => vLogId,
                pStatus          => vStatus,
                pMsg             => vErrorMessage1);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                    'Token Validation Process Calling Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        IF vStatus != '200'
        THEN
            vErrorMessage := 'Invalid Token';
            RAISE vMyException;
        END IF;

        BEGIN
            SELECT MEMBER_CODE
              INTO vMemberCode
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                              ' SELECT MEMBER_CODE
                  FROM EMOB.MB_CUSTOMER_MST a,EMOB.MB_ACCOUNT_MST b
                 WHERE b.Ac_NO = '''
                           || pAcNo
                           || ''' AND a.CUST_NO = b.CUST_NO'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (MEMBER_CODE VARCHAR2 PATH '$.member_code'));
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Invalid Account.';
                RAISE vMyException;
        END;

        IF vUserCode != vMemberCode
        THEN
            vErrorMessage := 'Invalid Account. ';
            RAISE vMyException;
        END IF;


        BEGIN
            SELECT APP_LINK_LOCAL INTO vUrl FROM GUMS.MB_GLOBAL_RULE;

            vUrl := vUrl || '/psb/psbcore/coresrc/get_ac_statement_apps/';


            vRequest := '{
    "pacno": "' || pAcNo || '",
    "pfromdate": "' || pfromDate || '",
    "ptodate": "' || pTodate || '"
}';

            BEGIN
                APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
                APEX_WEB_SERVICE.g_request_headers (1).VALUE :=
                    'application/json';
                vResponse :=
                    APEX_WEB_SERVICE.MAKE_REST_REQUEST (
                        p_url                => vUrl,
                        p_http_method        => 'POST',
                        p_body               => vRequest,
                        p_transfer_timeout   => 30);
            EXCEPTION
                WHEN OTHERS
                THEN
                    vErrorMessage := 'Core API Calling Problem.';
                    RAISE vMyException;
            END;

            apex_json.parse (vResponse);
            vTranList := apex_json.get_varchar2 ('ptranlist');
            json_result :=
                   '{"STATUS":"'
                || pStatus
                || '","MESSAGE":"'
                || pMessage
                || '","TRAN_LIST":'
                || vTranList
                || '}';

            RETURN json_result;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            json_result := '{
    "STATUS": "F",
    "MESSAGE": "' || vErrorMessage || '"}';
            RETURN json_result;
    END;
END;
/


DROP PACKAGE BODY GUMS.PKG_NID_VERIFICATION;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_NID_VERIFICATION
IS
    PROCEDURE EC_API_CALL_NEW (pToken      IN     VARCHAR2,
                               pNid               VARCHAR2,
                               pName              VARCHAR2,
                               pDob               VARCHAR2,
                               pResponse      OUT CLOB,
                               pErrFlag       OUT VARCHAR2,
                               pErrMsg        OUT VARCHAR2)
    IS
        v_body               VARCHAR2 (1024);
        req                  UTL_HTTP.req;
        res                  UTL_HTTP.resp;
        buffer               VARCHAR2 (4000);
        v_response           CLOB;
        vEcUser              VARCHAR2 (200);
        vEcPassword          VARCHAR2 (200);
        vEcApiToken          VARCHAR2 (500);
        vEcApiVerification   VARCHAR2 (500);
        vMyException         EXCEPTION;
    BEGIN
        BEGIN
            SELECT ec_user,
                   ec_password,
                   ec_api_token,
                   ec_api_verification
              INTO vEcUser,
                   vEcPassword,
                   vEcApiToken,
                   vEcApiVerification
              FROM gums.mb_global_rule;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrMsg := 'API Information Finding Problem' || SQLERRM;
                RAISE vMyException;
        END;


        v_body :=
               '{ "nid": "'
            || pNid
            || '", "name": "", "nameEn": "'
            || pName
            || '", "dateOfBirth": "'
            || pDob
            || '", "gender": "", "bloodGroup": "", "father": " "}';
        --  v_body := '{ "nid": "8229654507", "name": "", "nameEn": "Md. Kamrul Fardaus", "dateOfBirth": "1986-01-01", "gender": "", "bloodGroup": "", "father": " "}';

        UTL_HTTP.set_wallet ('file:' || '/u04/wallet', 'Psb#123456');


        req := UTL_HTTP.begin_request (vEcApiToken, 'POST', ' HTTP/1.1');
        UTL_HTTP.set_header (req, 'content-type', 'application/json');
        UTL_HTTP.set_header (req, 'Authorization', 'Bearer ' || pToken);
        UTL_HTTP.set_header (req, 'Content-Length', LENGTH (v_body));
        UTL_HTTP.write_text (req, v_body);

        res := UTL_HTTP.get_response (req);

        -- process the response from the HTTP call
        BEGIN
            LOOP
                UTL_HTTP.read_line (res, buffer, TRUE);
                --  DBMS_OUTPUT.put_line (buffer);
                v_response := v_response || buffer;
            END LOOP;

            UTL_HTTP.end_response (res);
        EXCEPTION
            WHEN UTL_HTTP.end_of_body
            THEN
                UTL_HTTP.end_response (res);
                RAISE vMyException;
        END;


        pResponse := v_response;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrMsg := 'API Information Finding Problem' || pResponse;
            RAISE vMyException;
        WHEN OTHERS
        THEN
            pErrMsg := 'API Information Finding Problem' || SQLERRM;
            RAISE vMyException;
    END;

    PROCEDURE PROC_GET_TOKEN_NID_VERIFY (pAccessToken    OUT VARCHAR2,
                                         pErrorFlag      OUT VARCHAR2,
                                         pErrorMessage   OUT VARCHAR2)
    IS
        vClobResponse   CLOB;
        vResponse       VARCHAR2 (32767);
        vUrl            VARCHAR2 (32767);
        vAccessToken    VARCHAR2 (32767);
        vErrorMessage   VARCHAR2 (32767);
        vData           VARCHAR2 (32767);
        vUserName       VARCHAR2 (50);
        vUserPassword   VARCHAR2 (1024);
        vMyException    EXCEPTION;
    BEGIN
        vUrl := 'http://10.20.22.38:8724/PsbNID/TokenServlet';

        BEGIN
            SELECT USER_NAME, USER_PASSWORD
              INTO vUserName, vUserPassword
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT *
          FROM EMOB.WBS_USER_INFO
         '),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (user_name VARCHAR2 (100) PATH '$.user_name',
                                user_password VARCHAR2 (200)
                                    PATH '$.user_password',
                                user_id VARCHAR2 (100) PATH '$.user_id',
                                effect_date DATE PATH '$.effect_date',
                                expire_date DATE PATH '$.expire_date',
                                STATUS VARCHAR2 (10) PATH '$.status'))
             WHERE     UPPER (USER_ID) = UPPER ('WBSNIDOSBUSR01')
                   AND STATUS = 'A'
                   AND TRUNC (SYSDATE) BETWEEN EFFECT_DATE
                                           AND NVL (EXPIRE_DATE, SYSDATE);
        EXCEPTION
            WHEN TOO_MANY_ROWS
            THEN
                vErrorMessage := 'WBS-user multiple row found';
                RAISE vMyException;
            WHEN NO_DATA_FOUND
            THEN
                vErrorMessage := 'WBS-user info Not found';
                RAISE vMyException;
            WHEN OTHERS
            THEN
                vErrorMessage := 'WBS-user Finding Problem';
                RAISE vMyException;
        END;

        vData := '{
        "password": "' || vUserPassword || '",
        "username": "' || vUserName || '"
            }';

        -- API Calling...
        BEGIN
            apex_web_service.g_request_headers (1).name := 'Content-Type';
            apex_web_service.g_request_headers (1).VALUE :=
                'application/json';


            vClobResponse :=
                APEX_WEB_SERVICE.make_rest_request (p_url           => vUrl,
                                                    p_http_method   => 'POST',
                                                    p_body          => vData);


            vResponse := TO_CHAR (vClobResponse);
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := 'Token API calling problem.' || SQLERRM;
                RAISE vMyException;
        END;

        -- Parse Json Response
        BEGIN
            APEX_JSON.PARSE (vResponse);
            vAccessToken :=
                APEX_JSON.GET_VARCHAR2 (p_path => 'success.data.access_token');
            pAccessToken := vAccessToken;
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage :=
                       'Token Response Data Parsing Problem.'
                    || SQLERRM
                    || vData;
                RAISE vMyException;
        END;

        IF vAccessToken IS NOT NULL
        THEN
            DELETE GUMS.MB_NID_TOKEN;

            INSERT INTO GUMS.MB_NID_TOKEN (TOKEN_NO,
                                           ERROR_MESSAGE,
                                           TOKEN_DATE)
                 VALUES (vAccessToken, pErrorMessage, SYSDATE);
        END IF;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            pErrorMessage := vErrorMessage;
    END;


    PROCEDURE PROC_NID_VERIFICATION (
        pBranchCode     IN     VARCHAR2,
        pNid10          IN     VARCHAR2 DEFAULT NULL,
        pNid17          IN     VARCHAR2 DEFAULT NULL,
        pDob            IN     VARCHAR2,
        pCustNo         IN     NUMBER,
        pRunUserID      IN     VARCHAR2,
        pErrorFlag         OUT VARCHAR2,
        pErrorMessage      OUT VARCHAR2)
    IS
        vClobResponse    CLOB;
        vResponse        VARCHAR2 (32767);
        vUrl             VARCHAR2 (32767);
        vToken           VARCHAR2 (32767);

        vData            VARCHAR2 (32767);
        V_RESPONE_TYPE   VARCHAR2 (20);
        vAccessToken     VARCHAR2 (1024);
        vMyException     EXCEPTION;
    BEGIN
        BEGIN
            SELECT TOKEN_NO
              INTO vToken
              FROM GUMS.MB_NID_TOKEN
             WHERE TO_CHAR (TOKEN_DATE, 'DDMMRRRR') =
                   TO_CHAR (SYSDATE, 'DDMMRRRR');
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                GUMS.PKG_NID_VERIFICATION.PROC_GET_TOKEN_NID_VERIFY (
                    pAccessToken    => vAccessToken,
                    pErrorFlag      => pErrorFlag,
                    pErrorMessage   => pErrorMessage);

                BEGIN
                    SELECT TOKEN_NO
                      INTO vToken
                      FROM GUMS.MB_NID_TOKEN
                     WHERE TO_CHAR (TOKEN_DATE, 'DDMMRRRR') =
                           TO_CHAR (SYSDATE, 'DDMMRRRR');
                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        pErrorMessage := 'Token no Finding Problem.';
                        RAISE vMyException;
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                            'Token no Finding Problem.' || SQLERRM;
                        RAISE vMyException;
                END;

                IF NVL (pErrorFlag, 'N') = 'Y'
                THEN
                    pErrorMessage :=
                        'Token no Can not Generated.' || pErrorMessage;
                    RAISE vMyException;
                END IF;
            WHEN OTHERS
            THEN
                pErrorMessage := 'Token no Finding Problem.' || SQLERRM;
                RAISE vMyException;
        END;

        BEGIN
            SELECT    'http://'
                   || API_IP
                   || ':'
                   || API_PORT
                   || '/PsbNID/SendInfoServlet'
                       URL
              INTO vUrl
              FROM JSON_TABLE (
                       GUMS.PKG_FETCH_FROM_REST.PRC_API_CALL_EMOB_REST_ENABLED_SQL (
                           'SELECT api_ip ,api_port
                           FROM EMOB.MB_NID_IPTABLE_PORT'),
                       '$.items[0].resultSet.items[*]'
                       COLUMNS (api_ip VARCHAR2 (100) PATH '$.api_ip',
                                api_port VARCHAR2 (200) PATH '$.api_port'));

            IF pNid10 IS NOT NULL
            THEN
                vData := '{
    "dateOfBirth": "' || pDob || '",
    "nid10Digit": "' || pNid10 || '"
                   }';
            ELSIF pNid17 IS NOT NULL
            THEN
                vData := '{
    "dateOfBirth": "' || pDob || '",
    "nid17Digit": "' || pNid17 || '"
                   }';
            END IF;

            -- API Calling...
            BEGIN
                apex_web_service.g_request_headers (1).name := 'Content-Type';
                apex_web_service.g_request_headers (1).VALUE :=
                    'application/json';

                apex_web_service.g_request_headers (2).name := 'token';
                apex_web_service.g_request_headers (2).VALUE := vToken;


                vClobResponse :=
                    APEX_WEB_SERVICE.make_rest_request (
                        p_url           => vUrl,
                        p_http_method   => 'POST',
                        p_body          => vData);


                vResponse := TO_CHAR (vClobResponse);
            EXCEPTION
                WHEN OTHERS
                THEN
                    pErrorMessage :=
                        'EC API Connection issue. Please Contact Head Office';
                    RAISE vMyException;
            END;
        END;


        FOR j
            IN (SELECT JSON_VALUE (vResponse, '$.status') AS status_code
                  FROM DUAL)
        LOOP
            BEGIN
                IF UPPER (j.status_code) = 'OK'
                THEN
                    V_RESPONE_TYPE := 'SUCCESS';
                ELSE
                    V_RESPONE_TYPE := j.status_code;
                END IF;

                BEGIN
                    INSERT INTO GUMS.MB_NID_VERIFICATION_RESPONSE (
                                    SL_NO,
                                    NID,
                                    RESPONSE_TEXT,
                                    RESPONSE_TYPE,
                                    BRANCH_CODE,
                                    CUST_NO,
                                    CREATE_BY)
                         VALUES (GUMS.SEQ_VERIFICATION_RESPONSE.NEXTVAL,
                                 NVL (pNid10, pNid17),
                                 vResponse,
                                 V_RESPONE_TYPE,
                                 pBranchCode,
                                 pCustNo,
                                 pRunUserID);
                EXCEPTION
                    WHEN OTHERS
                    THEN
                        pErrorMessage :=
                               ' Insert to MB_NID_VERIFICATION_RESPONSE Problem 1 - '
                            || SQLERRM;
                        RAISE vMyException;
                END;
            EXCEPTION
                WHEN OTHERS
                THEN
                    pErrorMessage :=
                           ' Insert to MB_NID_VERIFICATION_RESPONSE Problem 1 - '
                        || SQLERRM;
                    RAISE vMyException;
            END;

            COMMIT;
        END LOOP;
    ----------------

    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    PROCEDURE PROC_GET_NID_RESPONSE (
        pBranchCode         IN     VARCHAR2,
        pNid10              IN     VARCHAR2 DEFAULT NULL,
        pNid17              IN     VARCHAR2 DEFAULT NULL,
        pDob                IN     VARCHAR2,
        pCustNo             IN     NUMBER,
        pRunUserID          IN     VARCHAR2,
        pNAME                  OUT VARCHAR2,
        pMother                OUT VARCHAR2,
        pFather                OUT VARCHAR2,
        pDobOut                OUT DATE,
        pPermanentAddress      OUT VARCHAR2,
        pPresentAddress        OUT VARCHAR2,
        pPhotoURL              OUT VARCHAR2,
        pImageFlag             OUT VARCHAR2,
        pErrorFlag             OUT VARCHAR2,
        pErrorMessage          OUT VARCHAR2)
    IS
        vNid10         VARCHAR2 (20);
        vNid17         VARCHAR2 (20);
        vDob           VARCHAR2 (20);


        vMyException   EXCEPTION;
    BEGIN
        vNid10 := pNid10;
        vNid17 := pNid17;
        vDob := pDob;

        -----------------------

        BEGIN
            SELECT NID.NAME_EN,
                   TO_DATE (NID.DOB, 'RRRR-MM-DD')
                       DOB,
                   NID.MOTHER_NAME,
                   NID.FATHER_NAME,
                      NID.PER_homeOrHoldingNo
                   || CASE
                          WHEN NID.PER_additionalVillageOrRoad IS NOT NULL
                          THEN
                              ', ' || NID.PER_additionalVillageOrRoad
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PER_additionalMouzaOrMoholla IS NOT NULL
                          THEN
                              ', ' || NID.PER_additionalMouzaOrMoholla
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PER_postOffice IS NOT NULL
                          THEN
                              ', ' || NID.PER_postOffice
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PER_postalCode IS NOT NULL
                          THEN
                              '- ' || NID.PER_postalCode
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PER_upozila IS NOT NULL
                          THEN
                              ', ' || NID.PER_upozila
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PER_district IS NOT NULL
                          THEN
                              ', ' || NID.PER_district
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PER_division IS NOT NULL
                          THEN
                              ', ' || NID.PER_division
                          ELSE
                              NULL
                      END
                       PER_ADDRESS,
                      NID.PRS_homeOrHoldingNo
                   || CASE
                          WHEN NID.PRS_additionalVillageOrRoad IS NOT NULL
                          THEN
                              ', ' || NID.PRS_additionalVillageOrRoad
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PRS_additionalMouzaOrMoholla IS NOT NULL
                          THEN
                              ', ' || NID.PRS_additionalMouzaOrMoholla
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PRS_postOffice IS NOT NULL
                          THEN
                              ', ' || NID.PRS_postOffice
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PRS_postalCode IS NOT NULL
                          THEN
                              '- ' || NID.PRS_postalCode
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PRS_upozila IS NOT NULL
                          THEN
                              ', ' || NID.PRS_upozila
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PRS_district IS NOT NULL
                          THEN
                              ', ' || NID.PRS_district
                          ELSE
                              NULL
                      END
                   || CASE
                          WHEN NID.PRS_division IS NOT NULL
                          THEN
                              ', ' || NID.PRS_division
                          ELSE
                              NULL
                      END
                       PRS_ADDRESS,
                   photo_url,
                   image_flag
              INTO pNAME,
                   pDobOut,
                   pMother,
                   pFather,
                   pPermanentAddress,
                   pPresentAddress,
                   pPhotoURL,
                   pImageFlag
              FROM (SELECT JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.nationalId')
                               AS ID,
                           JSON_VALUE (RESPONSE_TEXT, '$.success.data.name')
                               AS NAME_BL,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.nameEn')
                               AS NAME_EN,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.dateOfBirth')
                               AS DOB,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.mother')
                               AS MOTHER_NAME,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.father')
                               AS FATHER_NAME,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.homeOrHoldingNo')
                               PER_homeOrHoldingNo,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.additionalVillageOrRoad')
                               PER_additionalVillageOrRoad,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.additionalMouzaOrMoholla')
                               PER_additionalMouzaOrMoholla,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.postOffice')
                               PER_postOffice,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.postalCode')
                               PER_postalCode,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.upozila')
                               PER_upozila,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.district')
                               PER_district,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.division')
                               PER_division,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.homeOrHoldingNo')
                               PRS_homeOrHoldingNo,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.additionalVillageOrRoad')
                               PRS_additionalVillageOrRoad,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.additionalMouzaOrMoholla')
                               PRS_additionalMouzaOrMoholla,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.postOffice')
                               PRS_postOffice,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.postalCode')
                               PRS_postalCode,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.upozila')
                               PRS_upozila,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.district')
                               PRS_district,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.division')
                               PRS_division,
                           JSON_VALUE (RESPONSE_TEXT, '$.success.data.photo')
                               AS photo_url,
                           IMAGE_FLAG
                      FROM GUMS.MB_NID_VERIFICATION_RESPONSE
                     WHERE     NID = NVL2 (pNid10, pNid10, pNid17)
                           AND RESPONSE_TYPE = 'SUCCESS') NID;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                --Need To Fetch NID Data From EC Server Then Try Again
                BEGIN
                    GUMS.PKG_NID_VERIFICATION.PROC_NID_VERIFICATION (
                        pBranchCode     => pBranchCode,
                        pNid10          => vNid10,
                        pNid17          => vNid17,
                        pDob            => vDob,
                        pCustNo         => pCustNo,
                        pRunUserID      => pRunUserID,
                        pErrorFlag      => pErrorFlag,
                        pErrorMessage   => pErrorMessage);

                    IF NVL (pErrorFlag, 'N') = 'Y'
                    THEN
                        RAISE vMyException;
                    ELSE
                        BEGIN
                            SELECT NID.NAME_EN,
                                   TO_DATE (NID.DOB, 'RRRR-MM-DD')
                                       DOB,
                                   NID.MOTHER_NAME,
                                   NID.FATHER_NAME,
                                      NID.PER_homeOrHoldingNo
                                   || CASE
                                          WHEN NID.PER_additionalVillageOrRoad
                                                   IS NOT NULL
                                          THEN
                                                 ', '
                                              || NID.PER_additionalVillageOrRoad
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PER_additionalMouzaOrMoholla
                                                   IS NOT NULL
                                          THEN
                                                 ', '
                                              || NID.PER_additionalMouzaOrMoholla
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PER_postOffice IS NOT NULL
                                          THEN
                                              ', ' || NID.PER_postOffice
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PER_postalCode IS NOT NULL
                                          THEN
                                              '- ' || NID.PER_postalCode
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PER_upozila IS NOT NULL
                                          THEN
                                              ', ' || NID.PER_upozila
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PER_district IS NOT NULL
                                          THEN
                                              ', ' || NID.PER_district
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PER_division IS NOT NULL
                                          THEN
                                              ', ' || NID.PER_division
                                          ELSE
                                              NULL
                                      END
                                       PER_ADDRESS,
                                      NID.PRS_homeOrHoldingNo
                                   || CASE
                                          WHEN NID.PRS_additionalVillageOrRoad
                                                   IS NOT NULL
                                          THEN
                                                 ', '
                                              || NID.PRS_additionalVillageOrRoad
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PRS_additionalMouzaOrMoholla
                                                   IS NOT NULL
                                          THEN
                                                 ', '
                                              || NID.PRS_additionalMouzaOrMoholla
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PRS_postOffice IS NOT NULL
                                          THEN
                                              ', ' || NID.PRS_postOffice
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PRS_postalCode IS NOT NULL
                                          THEN
                                              '- ' || NID.PRS_postalCode
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PRS_upozila IS NOT NULL
                                          THEN
                                              ', ' || NID.PRS_upozila
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PRS_district IS NOT NULL
                                          THEN
                                              ', ' || NID.PRS_district
                                          ELSE
                                              NULL
                                      END
                                   || CASE
                                          WHEN NID.PRS_division IS NOT NULL
                                          THEN
                                              ', ' || NID.PRS_division
                                          ELSE
                                              NULL
                                      END
                                       PRS_ADDRESS,
                                   photo_url,
                                   image_flag
                              INTO pNAME,
                                   pDobOut,
                                   pMother,
                                   pFather,
                                   pPermanentAddress,
                                   pPresentAddress,
                                   pPhotoURL,
                                   pImageFlag
                              FROM (SELECT JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.nationalId')
                                               AS ID,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.name')
                                               AS NAME_BL,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.nameEn')
                                               AS NAME_EN,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.dateOfBirth')
                                               AS DOB,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.mother')
                                               AS MOTHER_NAME,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.father')
                                               AS FATHER_NAME,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.permanentAddress.homeOrHoldingNo')
                                               PER_homeOrHoldingNo,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.permanentAddress.additionalVillageOrRoad')
                                               PER_additionalVillageOrRoad,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.permanentAddress.additionalMouzaOrMoholla')
                                               PER_additionalMouzaOrMoholla,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.permanentAddress.postOffice')
                                               PER_postOffice,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.permanentAddress.postalCode')
                                               PER_postalCode,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.permanentAddress.upozila')
                                               PER_upozila,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.permanentAddress.district')
                                               PER_district,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.permanentAddress.division')
                                               PER_division,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.presentAddress.homeOrHoldingNo')
                                               PRS_homeOrHoldingNo,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.presentAddress.additionalVillageOrRoad')
                                               PRS_additionalVillageOrRoad,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.presentAddress.additionalMouzaOrMoholla')
                                               PRS_additionalMouzaOrMoholla,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.presentAddress.postOffice')
                                               PRS_postOffice,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.presentAddress.postalCode')
                                               PRS_postalCode,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.presentAddress.upozila')
                                               PRS_upozila,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.presentAddress.district')
                                               PRS_district,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.presentAddress.division')
                                               PRS_division,
                                           JSON_VALUE (RESPONSE_TEXT,
                                                     '$.success.data.photo')
                                               photo_url,
                                           image_flag
                                      FROM GUMS.MB_NID_VERIFICATION_RESPONSE
                                     WHERE     NID =
                                               NVL2 (pNid10, pNid10, pNid17)
                                           AND RESPONSE_TYPE = 'SUCCESS') NID;
                        EXCEPTION
                            WHEN NO_DATA_FOUND
                            THEN
                                pErrorMessage :=
                                    'BAD_REQUEST: Invalid NID or Date Of Birth. No success Request Data Found. ';
                                RAISE vMyException;
                            WHEN OTHERS
                            THEN
                                pErrorMessage :=
                                       'BAD_REQUEST: Invalid NID or Date Of Birth. No success Request Data Found. '
                                    || SQLERRM;
                                RAISE vMyException;
                        END;
                    END IF;
                END;
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'EC data Can not find. ' || pErrorMessage || SQLERRM;
                RAISE vMyException;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
    END;

    /*PROCEDURE PROC_NID_REQUEST_AUTHENTICATE (pRequestID      IN     VARCHAR2,
                                             pRequestUser    IN     VARCHAR2,
                                             pErrorFlag         OUT VARCHAR2,
                                             pErrorMessage      OUT VARCHAR2)
    IS
        VCustNo           NUMBER;
        vCustNid          VARCHAR2 (20);
        vCreate_user_id   VARCHAR2 (50);
        vMyException      EXCEPTION;
    BEGIN
        BEGIN
            SELECT cust_no, EC_NID, create_by
              INTO VCustNo, vCustNid, vCreate_user_id
              FROM EMOB.CUST_NID_VERIFY
             WHERE REQUEST_ID = pRequestID AND VERIFICATION_STATUS = 'P';
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                pErrorMessage := 'No information Found with this request.';
                RAISE vMyException;
            WHEN OTHERS
            THEN
                pErrorMessage :=
                       'InformationFinding Problem in Verifiy request '
                    || SQLERRM;
                RAISE vMyException;
        END;

        IF vCreate_user_id = pRequestUser
        THEN
            pErrorMessage :=
                   'Requested User and approval User Can not Be same. '
                || SQLERRM;
            RAISE vMyException;
        END IF;

        BEGIN
            UPDATE EMOB.CUST_NID_VERIFY
               SET VERIFICATION_STATUS = 'A',
                   update_by = pRequestUser,
                   update_date = SYSDATE
             WHERE REQUEST_ID = pRequestID AND VERIFICATION_STATUS = 'P';
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'Update Problem in Verifiy request ' || SQLERRM;
                RAISE vMyException;
        END;

        IF SQL%ROWCOUNT != 1
        THEN
            pErrorMessage := 'Verifiy request Not Updated.' || SQL%ROWCOUNT;
            RAISE vMyException;
        END IF;

        BEGIN
            UPDATE EMOB.MB_CUSTOMER_MST
               SET IS_NID_VERIFIED = 'Y'
             WHERE CUST_NO = VCustNo;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'Update Problem in Verifiy request ' || SQLERRM;
                RAISE vMyException;
        END;

        IF SQL%ROWCOUNT != 1
        THEN
            pErrorMessage := 'Customer Verification Flag Not Updated ';
            RAISE vMyException;
        END IF;

        BEGIN
            UPDATE EMOB.NID_CUST_IMAGE
               SET IS_IMAGE_DELETE = 'Y',
                   DATA_BLOB = NULL,
                   update_by = pRequestUser,
                   update_date = SYSDATE
             WHERE NID = vCustNid;
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'Update Problem in Verifiy request ' || SQLERRM;
                RAISE vMyException;
        END;
    /*--17-Jul-2023
            IF SQL%ROWCOUNT != 1
            THEN
                pErrorMessage :=
                       'Image Remove Problem'
                    || vCustNid
                    || ' count : '
                    || SQL%ROWCOUNT;
                RAISE vMyException;
            END IF;

    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
    END;*/

    PROCEDURE GET_NID_EC_DATA (
        pCustNo                          IN     NUMBER,
        pNAME_EN                            OUT VARCHAR2,
        pDOB                                OUT VARCHAR2,
        pMOTHER_NAME                        OUT VARCHAR2,
        pFATHER_NAME                        OUT VARCHAR2,
        pspouse                             OUT VARCHAR2,
        poccupation                         OUT VARCHAR2,
        pDivision                           OUT VARCHAR2,
        pDistrict                           OUT VARCHAR2,
        pUpozila                            OUT VARCHAR2,
        pcityCorporationOrMunicipality      OUT VARCHAR2,
        punionOrWard                        OUT VARCHAR2,
        PostOffice                          OUT VARCHAR2,
        Postal_Code                         OUT VARCHAR2,
        RMO                                 OUT VARCHAR2,
        Mouza_Moholla                       OUT VARCHAR2,
        Village_Road                        OUT VARCHAR2,
        Home_Holding_No                     OUT VARCHAR2,
        Region                              OUT VARCHAR2,
        pre_Division                        OUT VARCHAR2,
        pre_District                        OUT VARCHAR2,
        pre_Upozila                         OUT VARCHAR2,
        pre_cityCorOrMunici                 OUT VARCHAR2,
        pre_unionOrWard                     OUT VARCHAR2,
        pre_PostOffice                      OUT VARCHAR2,
        pre_Postal_Code                     OUT VARCHAR2,
        pre_RMO                             OUT VARCHAR2,
        pre_Mouza_Moholla                   OUT VARCHAR2,
        pre_Village_Road                    OUT VARCHAR2,
        pre_Home_Holding_No                 OUT VARCHAR2,
        pre_Region                          OUT VARCHAR2,
        pErrorFlag                          OUT VARCHAR2,
        pErrorMessage                       OUT VARCHAR2)
    IS
        vMyException   EXCEPTION;
    BEGIN
        BEGIN
            SELECT NID.NAME_EN,
                   TO_DATE (NID.DOB, 'RRRR-MM-DD') DOB,
                   NID.MOTHER_NAME,
                   NID.FATHER_NAME,
                   spouse,
                   occupation,
                   Division,
                   District,
                   Upozila,
                   cityCorporationOrMunicipality,
                   unionOrWard,
                   PostOffice,
                   Postal_Code,
                   RMO,
                   Mouza_Moholla,
                   Village_Road,
                   Home_Holding_No,
                   Region,
                   pre_Division,
                   pre_District,
                   pre_Upozila,
                   pre_cityCorOrMunici,
                   pre_unionOrWard,
                   pre_PostOffice,
                   pre_Postal_Code,
                   pre_RMO,
                   pre_Mouza_Moholla,
                   pre_Village_Road,
                   pre_Home_Holding_No,
                   pre_Region
              INTO pNAME_EN,
                   pDOB,
                   pMOTHER_NAME,
                   pFATHER_NAME,
                   pspouse,
                   poccupation,
                   pDivision,
                   pDistrict,
                   pUpozila,
                   pcityCorporationOrMunicipality,
                   punionOrWard,
                   PostOffice,
                   Postal_Code,
                   RMO,
                   Mouza_Moholla,
                   Village_Road,
                   Home_Holding_No,
                   Region,
                   pre_Division,
                   pre_District,
                   pre_Upozila,
                   pre_cityCorOrMunici,
                   pre_unionOrWard,
                   pre_PostOffice,
                   pre_Postal_Code,
                   pre_RMO,
                   pre_Mouza_Moholla,
                   pre_Village_Road,
                   pre_Home_Holding_No,
                   pre_Region
              FROM (SELECT JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.nationalId')
                               AS ID,
                           JSON_VALUE (RESPONSE_TEXT, '$.success.data.name')
                               AS NAME_BL,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.nameEn')
                               AS NAME_EN,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.bloodGroup')
                               AS bloodGroup,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.dateOfBirth')
                               AS DOB,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.mother')
                               AS MOTHER_NAME,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.father')
                               AS FATHER_NAME,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.spouse')
                               AS spouse,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.occupation')
                               AS occupation,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.division')
                               AS Division,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.district')
                               AS District,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.upozila')
                               AS Upozila,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.cityCorporationOrMunicipality')
                               AS cityCorporationOrMunicipality,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.unionOrWard')
                               AS unionOrWard,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.postOffice')
                               AS PostOffice,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.postalCode')
                               AS Postal_Code,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.rmo')
                               AS RMO,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.additionalMouzaOrMoholla')
                               AS Mouza_Moholla,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.additionalVillageOrRoad')
                               AS Village_Road,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.homeOrHoldingNo')
                               AS Home_Holding_No,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.permanentAddress.region')
                               AS Region                                 --pre
                                        ,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.division')
                               AS pre_Division,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.district')
                               AS pre_District,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.upozila')
                               AS pre_Upozila,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.cityCorporationOrMunicipality')
                               AS pre_cityCorOrMunici,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.unionOrWard')
                               AS pre_unionOrWard,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.postOffice')
                               AS pre_PostOffice,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.postalCode')
                               AS pre_Postal_Code,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.rmo')
                               AS pre_RMO,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.additionalMouzaOrMoholla')
                               AS pre_Mouza_Moholla,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.additionalVillageOrRoad')
                               AS pre_Village_Road,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.homeOrHoldingNo')
                               AS pre_Home_Holding_No,
                           JSON_VALUE (RESPONSE_TEXT,
                                     '$.success.data.presentAddress.region')
                               AS pre_Region
                      --ok
                      FROM GUMS.MB_NID_VERIFICATION_RESPONSE
                     WHERE cust_no = pCustNo AND RESPONSE_TYPE = 'SUCCESS')
                   NID;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                pNAME_EN := ' ';
                pDOB := ' ';
                pMOTHER_NAME := ' ';
                pFATHER_NAME := ' ';
                pspouse := ' ';
                poccupation := ' ';
                pDivision := ' ';
                pDistrict := ' ';
                pUpozila := ' ';
                pcityCorporationOrMunicipality := ' ';
                punionOrWard := ' ';
                PostOffice := ' ';
                Postal_Code := ' ';
                RMO := ' ';
                Mouza_Moholla := ' ';
                Village_Road := ' ';
                Home_Holding_No := ' ';
                Region := ' ';
                pre_Division := ' ';
                pre_District := ' ';
                pre_Upozila := ' ';
                pre_cityCorOrMunici := ' ';
                pre_unionOrWard := ' ';
                pre_PostOffice := ' ';
                pre_Postal_Code := ' ';
                pre_RMO := ' ';
                pre_Mouza_Moholla := ' ';
                pre_Village_Road := ' ';
                pre_Home_Holding_No := ' ';
                pre_Region := ' ';
            WHEN OTHERS
            THEN
                pErrorMessage := 'Data collection problem .' || SQLERRM;
                RAISE vMyException;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            ROLLBACK;
            pErrorFlag := 'Y';
    END;
END;
/


DROP PACKAGE BODY GUMS.PKG_STORE_LOG;

CREATE OR REPLACE PACKAGE BODY GUMS.PKG_STORE_LOG
IS
    PROCEDURE PRC_SUCCESS_LOGIN (pUserId             NUMBER,
                                 pUserCode           VARCHAR2,
                                 pSessionId          VARCHAR2,
                                 pBranchCode         VARCHAR2,
                                 pReqFrom            VARCHAR2 DEFAULT NULL,
                                 pDeviceId           VARCHAR2 DEFAULT NULL,
                                 pLogId          OUT NUMBER,
                                 pErrorFlag      OUT VARCHAR2,
                                 pErrorMessage   OUT VARCHAR2)
    AS
        vRemoteAddress     VARCHAR2 (1024);
        vRemoteUser        VARCHAR2 (1024);
        vHttpUserAgent     VARCHAR2 (1024);
        vHttpHost          VARCHAR2 (1024);
        vHttpCookie        VARCHAR2 (1024);
        vServerProtocol    VARCHAR2 (1024);
        vServerPort        VARCHAR2 (1024);
        vServerName        VARCHAR2 (1024);
        vRequestProtocol   VARCHAR2 (1024);
        vRequestMethod     VARCHAR2 (1024);
        vHttpReferer       VARCHAR2 (1024);
        vBrowserVersion    VARCHAR2 (1024);
        vMyException       EXCEPTION;
    BEGIN
        pErrorFlag := 'N';

        BEGIN
            vRemoteAddress := OWA_UTIL.get_cgi_env ('REMOTE_ADDR');
            vRemoteUser := OWA_UTIL.get_cgi_env ('REMOTE_USER');
            vHttpUserAgent :=
                SUBSTR (OWA_UTIL.get_cgi_env ('HTTP_USER_AGENT'), 1, 100);
            vHttpHost := OWA_UTIL.get_cgi_env ('HTTP_HOST');
            vHttpReferer := OWA_UTIL.get_cgi_env ('HTTP_REFERER');
            vRequestMethod := OWA_UTIL.get_cgi_env ('REQUEST_METHOD');
            vRequestProtocol := OWA_UTIL.get_cgi_env ('REQUEST_PROTOCOL');
            vServerName := OWA_UTIL.get_cgi_env ('SERVER_NAME');
            vServerPort := OWA_UTIL.get_cgi_env ('SERVER_PORT');
            vServerProtocol := OWA_UTIL.get_cgi_env ('SERVER_PROTOCOL');
            vHttpCookie :=
                SUBSTR (OWA_UTIL.get_cgi_env ('HTTP_COOKIE'), 1, 50);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'System Value Finding Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        BEGIN
            IF vHttpUserAgent LIKE '%MSIE%'
            THEN
                vBrowserVersion :=
                       'MSIE '
                    || SUBSTR (
                           vHttpUserAgent,
                           INSTR (vHttpUserAgent, 'MSIE') + 5,
                             INSTR (vHttpUserAgent,
                                    ';',
                                    INSTR (vHttpUserAgent, 'MSIE'))
                           - (INSTR (vHttpUserAgent, 'MSIE') + 5));
            ELSIF vHttpUserAgent LIKE '%Trident/%'
            THEN
                SELECT DECODE (
                           SUBSTR (
                               vHttpUserAgent,
                               INSTR (vHttpUserAgent, 'Trident/') + 8,
                                 INSTR (vHttpUserAgent,
                                        '.',
                                        INSTR (vHttpUserAgent, 'Trident/'))
                               - (INSTR (vHttpUserAgent, 'Trident/') + 8)),
                           4, 'MSIE 8',
                           5, 'MSIE 9',
                           6, 'MSIE 10',
                           7, 'MSIE 11')
                  INTO vBrowserVersion
                  FROM DUAL;
            ELSIF vHttpUserAgent LIKE '%Firefox/%'
            THEN
                vBrowserVersion :=
                       'Firefox '
                    || SUBSTR (
                           vHttpUserAgent,
                           INSTR (vHttpUserAgent, 'Firefox/') + 8,
                             INSTR (vHttpUserAgent,
                                    '.',
                                    INSTR (vHttpUserAgent, 'Firefox/'))
                           - (INSTR (vHttpUserAgent, 'Firefox/') + 8));
            ELSIF vHttpUserAgent LIKE '%Chrome/%'
            THEN
                vBrowserVersion :=
                       'Google Chrome '
                    || SUBSTR (
                           vHttpUserAgent,
                           INSTR (vHttpUserAgent, 'Chrome/') + 7,
                             INSTR (vHttpUserAgent,
                                    '.',
                                    INSTR (vHttpUserAgent, 'Chrome/'))
                           - (INSTR (vHttpUserAgent, 'Chrome/') + 7));
            ELSIF vHttpUserAgent LIKE '%Safari/%'
            THEN
                vBrowserVersion :=
                       'Safari '
                    || SUBSTR (
                           vHttpUserAgent,
                           INSTR (vHttpUserAgent, 'Safari/') + 7,
                             INSTR (vHttpUserAgent,
                                    '.',
                                    INSTR (vHttpUserAgent, 'Safari/'))
                           - (INSTR (vHttpUserAgent, 'Safari/') + 7));
            END IF;
        END;


        BEGIN
            pLogId := GUMS.LOG_ID.NEXTVAL;

            INSERT INTO GUMS.MB_USER_LOG_WEB (LOG_ID,
                                              USER_ID,
                                              USER_CODE,
                                              SESSION_ID,
                                              REMOTE_ADDR,
                                              HTTP_HOST,
                                              REMOTE_USER,
                                              HTTP_USER_AGENT,
                                              HTTP_COOKIE,
                                              HTTP_REFERER,
                                              REQUEST_METHOD,
                                              REQUEST_PROTOCOL,
                                              SERVER_NAME,
                                              SERVER_PORT,
                                              SERVER_PROTOCOL,
                                              BROWSER_VERSION,
                                              BRANCH_CODE,
                                              REQUEST_FROM,
                                              DEVICE_ID)
                 VALUES (pLogId,
                         pUserId,
                         pUserCode,
                         pSessionId,
                         vRemoteAddress,
                         vHttpHost,
                         vRemoteUser,
                         vHttpUserAgent,
                         vHttpCookie,
                         vHttpReferer,
                         vRequestMethod,
                         vRequestProtocol,
                         vServerName,
                         vServerPort,
                         vServerProtocol,
                         vBrowserVersion,
                         pBranchCode,
                         pReqFrom,
                         pDeviceId);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := 'Log Insertion Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            ROLLBACK;
    END;

    PROCEDURE PRC_FAILED_LOGIN (pUserId             NUMBER,
                                pUserCode           VARCHAR2,
                                pSessionId          VARCHAR2,
                                pErrorFlag      OUT VARCHAR2,
                                pErrorMessage   OUT VARCHAR2)
    AS
        vRemoteAddress     VARCHAR2 (1024);
        vRemoteUser        VARCHAR2 (1024);
        vHttpUserAgent     VARCHAR2 (1024);
        vHttpHost          VARCHAR2 (1024);
        vHttpCookie        VARCHAR2 (1024);
        vServerProtocol    VARCHAR2 (1024);
        vServerPort        VARCHAR2 (1024);
        vServerName        VARCHAR2 (1024);
        vRequestProtocol   VARCHAR2 (1024);
        vRequestMethod     VARCHAR2 (1024);
        vHttpReferer       VARCHAR2 (1024);
        vBrowserVersion    VARCHAR2 (1024);
        vMyException       EXCEPTION;
    BEGIN
        pErrorFlag := 'N';

        BEGIN
            vRemoteAddress := OWA_UTIL.get_cgi_env ('REMOTE_ADDR');
            vRemoteUser := OWA_UTIL.get_cgi_env ('REMOTE_USER');
            vHttpUserAgent :=
                SUBSTR (OWA_UTIL.get_cgi_env ('HTTP_USER_AGENT'), 1, 100);
            vHttpHost := OWA_UTIL.get_cgi_env ('HTTP_HOST');
            vHttpReferer := OWA_UTIL.get_cgi_env ('HTTP_REFERER');
            vRequestMethod := OWA_UTIL.get_cgi_env ('REQUEST_METHOD');
            vRequestProtocol := OWA_UTIL.get_cgi_env ('REQUEST_PROTOCOL');
            vServerName := OWA_UTIL.get_cgi_env ('SERVER_NAME');
            vServerPort := OWA_UTIL.get_cgi_env ('SERVER_PORT');
            vServerProtocol := OWA_UTIL.get_cgi_env ('SERVER_PROTOCOL');
            vHttpCookie :=
                SUBSTR (OWA_UTIL.get_cgi_env ('HTTP_COOKIE'), 1, 50);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'System Value Finding Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;

        BEGIN
            IF vHttpUserAgent LIKE '%MSIE%'
            THEN
                vBrowserVersion :=
                       'MSIE '
                    || SUBSTR (
                           vHttpUserAgent,
                           INSTR (vHttpUserAgent, 'MSIE') + 5,
                             INSTR (vHttpUserAgent,
                                    ';',
                                    INSTR (vHttpUserAgent, 'MSIE'))
                           - (INSTR (vHttpUserAgent, 'MSIE') + 5));
            ELSIF vHttpUserAgent LIKE '%Trident/%'
            THEN
                SELECT DECODE (
                           SUBSTR (
                               vHttpUserAgent,
                               INSTR (vHttpUserAgent, 'Trident/') + 8,
                                 INSTR (vHttpUserAgent,
                                        '.',
                                        INSTR (vHttpUserAgent, 'Trident/'))
                               - (INSTR (vHttpUserAgent, 'Trident/') + 8)),
                           4, 'MSIE 8',
                           5, 'MSIE 9',
                           6, 'MSIE 10',
                           7, 'MSIE 11')
                  INTO vBrowserVersion
                  FROM DUAL;
            ELSIF vHttpUserAgent LIKE '%Firefox/%'
            THEN
                vBrowserVersion :=
                       'Firefox '
                    || SUBSTR (
                           vHttpUserAgent,
                           INSTR (vHttpUserAgent, 'Firefox/') + 8,
                             INSTR (vHttpUserAgent,
                                    '.',
                                    INSTR (vHttpUserAgent, 'Firefox/'))
                           - (INSTR (vHttpUserAgent, 'Firefox/') + 8));
            ELSIF vHttpUserAgent LIKE '%Chrome/%'
            THEN
                vBrowserVersion :=
                       'Google Chrome '
                    || SUBSTR (
                           vHttpUserAgent,
                           INSTR (vHttpUserAgent, 'Chrome/') + 7,
                             INSTR (vHttpUserAgent,
                                    '.',
                                    INSTR (vHttpUserAgent, 'Chrome/'))
                           - (INSTR (vHttpUserAgent, 'Chrome/') + 7));
            ELSIF vHttpUserAgent LIKE '%Safari/%'
            THEN
                vBrowserVersion :=
                       'Safari '
                    || SUBSTR (
                           vHttpUserAgent,
                           INSTR (vHttpUserAgent, 'Safari/') + 7,
                             INSTR (vHttpUserAgent,
                                    '.',
                                    INSTR (vHttpUserAgent, 'Safari/'))
                           - (INSTR (vHttpUserAgent, 'Safari/') + 7));
            END IF;
        END;

        BEGIN
            INSERT INTO GUMS.FAILED_LOGIN_LOG (LOG_ID,
                                               USER_ID,
                                               USER_CODE,
                                               SESSION_ID,
                                               REMOTE_ADDR,
                                               HTTP_HOST,
                                               REMOTE_USER,
                                               HTTP_USER_AGENT,
                                               HTTP_COOKIE,
                                               HTTP_REFERER,
                                               REQUEST_METHOD,
                                               REQUEST_PROTOCOL,
                                               SERVER_NAME,
                                               SERVER_PORT,
                                               SERVER_PROTOCOL,
                                               BROWSER_VERSION)
                 VALUES (GUMS.LOG_ID.NEXTVAL,
                         pUserId,
                         pUserCode,
                         pSessionId,
                         vRemoteAddress,
                         vHttpHost,
                         vRemoteUser,
                         vHttpUserAgent,
                         vHttpCookie,
                         vHttpReferer,
                         vRequestMethod,
                         vRequestProtocol,
                         vServerName,
                         vServerPort,
                         vServerProtocol,
                         vBrowserVersion);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage :=
                    'Failed Log Insertion Problem. - ' || SQLERRM;
                RAISE vMyException;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            ROLLBACK;
    END;

    PROCEDURE STORE_MAIL_TEXT_LOG (pMailId             VARCHAR2,
                                   pCC                 VARCHAR2,
                                   pBCC                VARCHAR2,
                                   pSubject            VARCHAR2,
                                   pMailText           VARCHAR2,
                                   pLoginId            VARCHAR2,
                                   pRunUser            VARCHAR2,
                                   pSessionId          NUMBER,
                                   pErrorFlag      OUT VARCHAR2,
                                   pErrorMessage   OUT VARCHAR2)
    IS
        vMyException   EXCEPTION;
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        BEGIN
            INSERT INTO GUMS.MB_MAIL_SEND_LOG (LOG_ID,
                                               EMAIL_ID,
                                               CC,
                                               BCC,
                                               SUBJECT,
                                               EMAIL_TEXT,
                                               USER_ID,
                                               SESSION_ID,
                                               CREATE_BY,
                                               CREATE_DATE)
                 VALUES (GUMS.MAIL_TEXT_LOG.NEXTVAL,
                         pMailId,
                         pCC,
                         pBCC,
                         pSubject,
                         pMailText,
                         pLoginId,
                         pSessionId,
                         pRunUser,
                         SYSDATE);
        EXCEPTION
            WHEN OTHERS
            THEN
                pErrorMessage := ' Email Text Insert Problem. - ' || SQLERRM;

                RAISE vMyException;
        END;

        COMMIT;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorFlag := 'Y';
            ROLLBACK;
    END;
END;
/
