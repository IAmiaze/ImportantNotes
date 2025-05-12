CREATE OR REPLACE PROCEDURE EMOB.COMPANY_SINGLE_AC_OPEN_API (
    pAcId              IN     NUMBER,
    pBranch            IN     VARCHAR,
    pCustNo            IN     NUMBER,
    pReferenceNum      IN     VARCHAR2,
    pCbsReferenceNum      OUT VARCHAR2,
    pCustomerNumber       OUT VARCHAR2,
    pAccountNumber        OUT VARCHAR2,
    pErrFlag              OUT VARCHAR2,
    pErrMsg               OUT VARCHAR2)
IS
    vClobResponse   CLOB;
    vResponse       VARCHAR2 (32767);
    vStatusCode     VARCHAR2 (32767);
    vMessage        VARCHAR2 (1024);
    vUrl            VARCHAR2 (32767);
    vToken          VARCHAR2 (32767);
    vData           VARCHAR2 (32767);
    vMyException    EXCEPTION;
BEGIN
    SELECT PATH_DIR
      INTO vUrl
      FROM GUMS.MB_GLOBAL_PATH
     WHERE PATH_CODE = 'COMP_SIN_AC';

    BEGIN
        SELECT TOKEN
          INTO vToken
          FROM GUMS.MB_API_TOKEN
         WHERE FLAG = 'TOKEN';
    EXCEPTION
        WHEN OTHERS
        THEN
            pErrMsg := 'Token found proble from table.' || SQLERRM;
            RAISE vMyException;
    END;

    FOR I
        IN (SELECT AC_NO,
                   A.BRANCH_CODE,
                   A.AC_TITLE,
                   D.AC_PREFIX,
                   A.AC_TYPE,
                   AC_SUB_TYPE,
                   C.CUST_CODE,
                   C.CUST_NO,
                   A.SECTOR_CODE,
                   C.CUST_SUB_CAT,
                   C.CONS_CODE,
                   C.TOTAL_EMP,
                   c.RESIDENT_STATUS,
                   c.NET_WORTH,
                   c.FIRST_NAME                     COMP_NAME,
                   C.BUSINESS_DTLS,
                   C.TIN_NO,
                   C.VIN_NO,
                   C.YEARLY_TURN_OVER,
                   C.CUST_CAT,
                   A.AC_PURPOSE,
                   A.NAME_OF_CONCERN_AUTH,
                   A.AUTHORIZATION,
                   (SELECT NATURE
                      FROM EMOB.ORGANIZATION_NATURE
                     WHERE ID = A.ORG_TYPE)         ORG_TYPE,
                   (SELECT TYPE     BIZ_TYPE
                      FROM EMOB.ST_BUSINESS_TYPE
                     WHERE ID = C.BUSINESS_TYPE)    BIZ_TYPE
              FROM EMOB.MB_ACCOUNT_MST   A,
                   EMOB.MB_CUSTOMER_MST  C,
                   EMOB.MB_PRODUCT_MST   D
             WHERE     A.CUST_NO = C.CUST_NO
                   AND A.AC_TYPE_ID = D.AC_TYPE_ID
                   AND A.AC_ID = pAcId)
    LOOP
        vData :=
               '{
    "OrgInfo": {
        "CustSectorCode": "'
            || i.SECTOR_CODE
            || '",
        "CustSubCategoryCode": "'
            || i.CUST_SUB_CAT
            || '",
        "ConstitutionCode": "'
            || i.CONS_CODE
            || '",
        "TotEmployees": "'
            || i.TOTAL_EMP
            || '",';

        FOR T
            IN (SELECT DOCMENT_NO                              TRL_NO,
                       TO_CHAR (ISSUE_DATE, 'YYYY-MM-DD')      ISSUE_DATE,
                       TO_CHAR (EXPIRE_DATE, 'YYYY-MM-DD')     EXPIRE_DATE
                  FROM EMOB.MB_DOCUMENT_MST
                 WHERE DOCUMENT_TYPE = 'TRL' AND CUST_NO = pCustNo)
        LOOP
            vData :=
                   vData
                || '"TradeLicense": {
            "licenseNo": "'
                || T.TRL_NO
                || '",
            "ExpiryDate": "'
                || T.EXPIRE_DATE
                || '",
            "IssueDate": "'
                || T.ISSUE_DATE
                || '",
            "IssueAuth": "Trade License Authority"
        },';
        END LOOP;

        vData :=
               vData
            || '"ResidentStatus": "'
            || i.RESIDENT_STATUS
            || '",
        "NetWorth": "'
            || i.NET_WORTH
            || '",
            
            "Addresses": [';

        FOR J
            IN (SELECT B.CBS_VALUE
                           AS ADDR_TYPE,
                       A.COUN
                           COUNTRY,
                       A.DIV
                           DIVISION,
                       A.DISTRICT_CODE
                           DISTRICT,
                       A.UPAZILA_CODE
                           UPAZILA,
                       A.POST_CODE
                           POSTCODE,
                       C.SUB_OFFICE
                           POST_NAME,
                       A.PS_CODE
                           PS_CODE,
                       DECODE (A.ADDRESS_TYPE, 'PRS', 'true', 'false')
                           PRST,
                       DECODE (A.ADDRESS_TYPE, 'PER', 'true', 'false')
                           PRET,
                       A.ADD_LINE1 || ' ' || ADD_LINE2
                           ADD_LINE
                  FROM EMOB.MB_ADDRESS_MST   A,
                       EMOB.ST_ADDRESS_TYPE  B,
                       EMOB.POSTAL_CODE      C
                 WHERE     REF_NO = pCustNo
                       AND A.ADDRESS_TYPE = B.ADDRESS_TYPE
                       AND A.POST_CODE = C.POST_CODE
                       AND A.ADDRESS_TYPE IN ('PRS', 'PER'))
        LOOP
            vData :=
                   vData
                || '
            {
                "PostOfficeName": "'
                || J.POST_NAME
                || '",
                "MobileNumber": "1712006619",
                "Address": "'
                || J.ADD_LINE
                || '",
                "AddrType": "'
                || J.ADDR_TYPE
                || '",
                "CurrAddr": "'
                || J.PRST
                || '",
                "PostOfficeCode": "'
                || J.POSTCODE
                || '",
                "PoliceStationCode": "'
                || J.PS_CODE
                || '",
                "PermAddr": "'
                || J.PRET
                || '",
                "CountryCode": "BD",
                "DivisionCode": "'
                || J.DIVISION
                || '",
                "CommAddr": "true",
                "DistrictCode": "'
                || J.DISTRICT
                || '"
                },';
        END LOOP;

        vData := vData || '],';
        vData :=
               vData
            || '
        "CompanyName": "'
            || i.COMP_NAME
            || '",
        "OrgType": "'||i.ORG_TYPE||'",
        "BizType": "'
            || I.BIZ_TYPE
            || '",
        "BizDtls": "'
            || i.BUSINESS_DTLS
            || '",';

        FOR R IN (SELECT DOCMENT_NO,
                         ISSUE_DATE,
                         ISSUE_PLACE,
                         TO_CHAR (EXPIRE_DATE, 'YYYY-MM-DD')     EXPIRE_DATE
                    FROM EMOB.MB_DOCUMENT_MST
                   WHERE CUST_NO = I.CUST_NO AND DOCUMENT_TYPE = 'REG')
        LOOP
            vData :=
                   vData
                || '"Registration": {
            "ExpiryDate": "'
                || R.EXPIRE_DATE
                || '",
            "Address": "'
                || R.ISSUE_PLACE
                || '",
            "IssueDate":"'
                || R.ISSUE_DATE
                || '",
            "IssueAuth": "Registration Authority",
            "CountryCode": "BD",
            "registrationNo": "'
                || R.DOCMENT_NO
                || '"
        },';
        END LOOP;

        vData :=
               vData
            || '
        "Tin": "'
            || i.TIN_NO
            || '",
        "Vin": "'
            || i.VIN_NO
            || '",
        "YearlyTurnOver": "'
            || i.YEARLY_TURN_OVER
            || '",
        "CustCategoryCode": "'
            || i.CUST_CAT
            || '"
    },
    "ReferenceNo": "'
            || pReferenceNum
            || '", 
    "AccountInfo": {
        "AccountCurrencyCode": "BDT",
        "DebitAllowed": false,
        "ConnRoles": [
            {
                "connRoleType": "4",';

        FOR M
            IN (SELECT v.FIRST_NAME || ' ' || v.LAST_NAME        FULL_NAME,
                       TO_CHAR (v.CUST_DOB, 'YYYY-MM-DD')        DOB,
                       v.FATHER_NAME,
                       v.MOTHER_NAME,
                       v.MOBILE_NO,
                       v.MAIL_ID,
                       v.SOURCE_INCOME,
                       v.MON_INCOME,
                       v.NATIONALITY,
                       b.NAME,
                       v.GENDER,
                       v.OCCUPATION_CODE,
                       v.SPOUSE_NAME,
                       C.ADD_LINE1 || ' ' || ADD_LINE2           ADD_LINE,
                       d.DOCMENT_NO,
                       d.DOCUMENT_TYPE,
                       b.CODE                                    REL_CODE,
                       b.NAME                                    REL_INFO,
                       TO_CHAR (d.ISSUE_DATE, 'YYYY-MM-DD')      ISSUE_DATE,
                       TO_CHAR (d.EXPIRE_DATE, 'YYYY-MM-DD')     EXPIRE_DATE
                  FROM EMOB.MB_ACCOUNT_OPERATOR   a,
                       EMOB.MB_CUSTOMER_MST       v,
                       EMOB.ST_RELATION_WITH_ORG  b,
                       EMOB.MB_ADDRESS_MST        C,
                       EMOB.MB_DOCUMENT_MST       d
                 WHERE     a.CUST_NO = v.CUST_NO
                       AND a.CUST_NO = d.CUST_NO
                       AND c.REF_NO = a.CUST_NO
                       AND a.AC_ID = pAcId
                       AND C.ADDRESS_TYPE = 'PRS'
                       AND b.CODE = a.REL_TYPE)
        LOOP
            vData :=
                   vData
                || '"Email": "'
                || M.MAIL_ID
                || '",
                "RoleType": "4",
                "PidDocs": [
                    {
                        "PidNum": "'
                || M.DOCMENT_NO
                || '",
                        "ExpiryDate": "'
                || M.EXPIRE_DATE
                || '",
                        "IssueDate": "'
                || M.ISSUE_DATE
                || '",
                        "AddrProof": true,
                        "IdentityCheck": true,
                        "PidType": "'
                || M.DOCUMENT_TYPE
                || '"
                    }
                ],
                "Gender": "'
                || M.GENDER
                || '",
                "OccupationCode": "'
                || M.OCCUPATION_CODE
                || '",
                "SpouseName": "'
                || M.SPOUSE_NAME
                || '",
                "Nationality": "'
                || M.NATIONALITY
                || '",
                "MobileNumber": "'
                || M.MOBILE_NO
                || '",
                "RelationshipInfo": "'
                || M.REL_INFO
                || '",
                "MotherName": "'
                || M.MOTHER_NAME
                || '",
                "FullName": "'
                || M.FULL_NAME
                || '",
                "CurrAddress": "'
                || M.ADD_LINE
                || '",
                "IncomeSrc": "'
                || M.SOURCE_INCOME
                || '",
                "Notes": "I soley hold this company account",
                "MonthlyIncome": "'
                || M.MON_INCOME
                || '",
                "BirthDate": "'
                || M.DOB
                || '",
                "FatherName": "'
                || M.FATHER_NAME
                || '",
                "PermAddress": "'||M.ADD_LINE||'"
            },';
        END LOOP;

        vData :=
               vData
            || '],
        "ProdCode": "'
            || i.AC_PREFIX
            || '",
        "AccountType": "'
            || i.AC_TYPE
            || '",
        "BranchCode": "'
            || i.BRANCH_CODE
            || '",
        "CreditAllowed": true
    },
    "OtherInfo": {
        "PurposeOfAccount": "'||I.AC_PURPOSE||'",
        "NameOfConcernAuth": "'||I.NAME_OF_CONCERN_AUTH||'",
        "Authorization": "'||I.AUTHORIZATION||'"
       }
}';
    END LOOP;

    BEGIN
        EMOB.DPK_GLOBAL_CBS_ALL_API.API_XML_LOG (
            pOprType        => 'COMP_SIN_AC',
            pRefNo          => pReferenceNum,
            pDrAcNo         => pAcId,
            pCrAcNo         => pBranch,
            pFileId         => EMOB.API_FILE_ID_SEQ.NEXTVAL,
            pInXMl          => vData,
            pOutXml         => vClobResponse,
            pDbMessage      => NULL,
            pErrorMessage   => pErrMsg,
            pLogId          => NULL,
            pNotifyFlag     => pErrFlag,
            pNotifyMsg      => pErrMsg);
    END;

    IF NVL (pErrFlag, 'S') = 'F'
    THEN
        RAISE vMyException;
    END IF;

    -- API Calling...
    BEGIN
        APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
        APEX_WEB_SERVICE.g_request_headers (1).VALUE := 'application/json';
        apex_web_service.g_request_headers (2).name := 'Authorization';
        apex_web_service.g_request_headers (2).VALUE := 'Bearer ' || vToken;


        vClobResponse := '{
    "ReferenceNo": "BIDA210930000000032",
    "AccountNumber": "0002602005636",
    "AccountName": "The Joy Of Life Technology",
    "CustomerNumber": 23403103,
    "Status": "200",
    "Message": "success",
    "CBSStatusCode": "00",
    "CBSDescription": "Success",
    "CBSFailedReason": null
}
';
        /*APEX_WEB_SERVICE.make_rest_request (p_url           => vUrl,
                                            p_http_method   => 'POST',
                                            p_body          => vData,
                                            p_transfer_timeout   => 10);*/
        vResponse := REPLACE (TO_CHAR (vClobResponse), '\', '');
    EXCEPTION
        WHEN OTHERS
        THEN
            BEGIN
                EMOB.DPK_GLOBAL_CBS_ALL_API.API_XML_LOG (
                    pOprType        => 'COMP_SIN_AC',
                    pRefNo          => pReferenceNum,
                    pDrAcNo         => pAcId,
                    pCrAcNo         => pBranch,
                    pFileId         => EMOB.API_FILE_ID_SEQ.NEXTVAL,
                    pInXMl          => vData,
                    pOutXml         => vClobResponse,
                    pDbMessage      => NULL,
                    pErrorMessage   => pErrMsg,
                    pLogId          => NULL,
                    pNotifyFlag     => pErrFlag,
                    pNotifyMsg      => pErrMsg);
            END;

            IF NVL (pErrFlag, 'S') = 'F'
            THEN
                RAISE vMyException;
            END IF;

            pErrMsg := 'API calling problem.' || SQLERRM;
            RAISE vMyException;
    END;

    IF vResponse IS NULL
    THEN
        pErrMsg := 'API Response Problem';
        RAISE vMyException;
    END IF;



    BEGIN
        EMOB.DPK_GLOBAL_CBS_ALL_API.API_XML_LOG (
            pOprType        => 'COMP_SIN_AC',
            pRefNo          => pReferenceNum,
            pDrAcNo         => pAcId,
            pCrAcNo         => pBranch,
            pFileId         => EMOB.API_FILE_ID_SEQ.NEXTVAL,
            pInXMl          => vData,
            pOutXml         => vClobResponse,
            pDbMessage      => NULL,
            pErrorMessage   => pErrMsg,
            pLogId          => NULL,
            pNotifyFlag     => pErrFlag,
            pNotifyMsg      => pErrMsg);
    END;

    IF NVL (pErrFlag, 'S') = 'F'
    THEN
        RAISE vMyException;
    END IF;


    -- Parse Json Response


    BEGIN
        APEX_JSON.PARSE (vResponse);
        vStatusCode := APEX_JSON.GET_VARCHAR2 (p_path => 'Status');
        vMessage := APEX_JSON.GET_VARCHAR2 (p_path => 'Message');
        pCustomerNumber := APEX_JSON.GET_VARCHAR2 (p_path => 'CustomerNumber');
        pAccountNumber := APEX_JSON.GET_VARCHAR2 (p_path => 'AccountNumber');
    EXCEPTION
        WHEN OTHERS
        THEN
            BEGIN
                EMOB.DPK_GLOBAL_CBS_ALL_API.API_XML_LOG (
                    pOprType        => 'COMP_SIN_AC',
                    pRefNo          => pAcId,
                    pDrAcNo         => pAcId,
                    pCrAcNo         => pBranch,
                    pFileId         => EMOB.API_FILE_ID_SEQ.NEXTVAL,
                    pInXMl          => vData,
                    pOutXml         => vClobResponse,
                    pDbMessage      => NULL,
                    pErrorMessage   => pErrMsg,
                    pLogId          => NULL,
                    pNotifyFlag     => pErrFlag,
                    pNotifyMsg      => pErrMsg);
            END;

            IF NVL (pErrFlag, 'S') = 'F'
            THEN
                RAISE vMyException;
            END IF;

            pErrMsg := 'Response Data Parsing Problem.' || SQLERRM;
            RAISE vMyException;
    END;



    -- Log Insert
    BEGIN
        EMOB.DPK_GLOBAL_CBS_ALL_API.API_XML_LOG (
            pOprType        => 'COMP_SIN_AC',
            pRefNo          => pAcId,
            pDrAcNo         => pAcId,
            pCrAcNo         => pBranch,
            pFileId         => EMOB.API_FILE_ID_SEQ.NEXTVAL,
            pInXMl          => vData,
            pOutXml         => vClobResponse,
            pDbMessage      => NULL,
            pErrorMessage   => pErrMsg,
            pLogId          => NULL,
            pNotifyFlag     => pErrFlag,
            pNotifyMsg      => pErrMsg);
    END;

    IF NVL (pErrFlag, 'S') = 'F'
    THEN
        RAISE vMyException;
    END IF;

    IF vStatusCode != 200 OR vStatusCode = 'null'
    THEN
        pErrMsg := 'Problem from API-' || vMessage;
        RAISE vMyException;
    END IF;
EXCEPTION
    WHEN vMyException
    THEN
        pErrFlag := 'Y';
END;
/