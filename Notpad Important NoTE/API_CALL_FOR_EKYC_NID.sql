CREATE OR REPLACE PROCEDURE EKYC.PRC_GET_NID_RESPONSE (
   pMobileNo     IN     VARCHAR2,
   pAppSession   IN     VARCHAR2,
   pLogId        IN     VARCHAR2,
   pErrorFlag       OUT VARCHAR2,
   pErrorMsg        OUT VARCHAR2)
IS
   vRequestBody     CLOB;
   vClobResponse    CLOB;
   vClob            CLOB;
   vFingerData_0    VARCHAR2 (32767);
   vFingerData_1    VARCHAR2 (32767);
   vFingerData_2    VARCHAR2 (32767);
   vFingerData_3    VARCHAR2 (32767);
   vOracleMessage   VARCHAR2 (1024);
   vSuccessCode     VARCHAR2 (20);
   vMyException     EXCEPTION;
BEGIN

   SELECT DATA_CLOB INTO vClob FROM EKYC.DEMO_JSON;

   apex_json.parse (vClob);
   vFingerData_0 := apex_json.get_varchar2 (p_path => '0.fingerData');
   vFingerData_1 := apex_json.get_varchar2 (p_path => '1.fingerData');
   vFingerData_2 := apex_json.get_varchar2 (p_path => '2.fingerData');
   vFingerData_3 := apex_json.get_varchar2 (p_path => '3.fingerData');

   vRequestBody := '"password": "U@bs2022",
  "username": "uabs",
  "ecusername":"ABDN01777",
  "ecuserpassword":"123456",
  "nid":"4170615332",
  "dob":"1996-09-13",
  "choosefinger":"LEFT_THUMB",
  "fingerdata":"'    || vFingerData_0 || '"
}'  ;



   BEGIN
      EMOB.GLOBAL_CBS_ALL_API.API_XML_LOG_NEW (pOprType        => 'OCR',
                                               pRefno          => pMobileNo,
                                               pDrAcno         => pMobileNo,
                                               pCrAcno         => NULL,
                                               pFileid         => vFileId,
                                               pINXML          => vRequestBody,
                                               pOUTXML         => NULL,
                                               pDbMessage      => vOracleMessage,
                                               pErrorMessage   => pErrorMsg,
                                               pLogId          => pLogId,
                                               pNotifyFlag     => pErrorFlag,
                                               pNotifymsg      => pErrorMsg);
   EXCEPTION
      WHEN OTHERS
      THEN
         vOracleMessage := SQLERRM;
         pErrorMsg := 'Log Process Calling Problem';
         RAISE vMyException;
   END;

   IF NVL (pErrorFlag, 'N') = 'Y'
   THEN
      RAISE vMyException;
   END IF;

   BEGIN
      APEX_WEB_SERVICE.g_request_headers (1).name := 'Content-Type';
      APEX_WEB_SERVICE.g_request_headers (1).VALUE := 'application/json';


      vClobResponse :=
         APEX_WEB_SERVICE.make_rest_request (
            p_url           => 'http://172.25.47.50:3030/ucb/ocr/ocrverification',
            p_http_method   => 'POST',
            p_body          => vRequestBody);
   EXCEPTION
      WHEN OTHERS
      THEN
         pErrorMsg := 'OCR API Calling Problem -' || SQLERRM;
         RAISE vMyException;
   END;

   BEGIN
      apex_json.parse (vClobResponse);
      vSuccessCode := apex_json.get_varchar2 (p_path => 'data.code');
   END;

   BEGIN
      EMOB.GLOBAL_CBS_ALL_API.API_XML_LOG_NEW (pOprType        => 'OCR',
                                               pRefno          => pMobileNo,
                                               pDrAcno         => pMobileNo,
                                               pCrAcno         => NULL,
                                               pFileid         => vFileId,
                                               pINXML          => vRequestBody,
                                               pOUTXML         => vClobResponse,
                                               pDbMessage      => vOracleMessage,
                                               pErrorMessage   => pErrorMsg,
                                               pLogId          => pLogId,
                                               pNotifyFlag     => pErrorFlag,
                                               pNotifymsg      => pErrorMsg);
   EXCEPTION
      WHEN OTHERS
      THEN
         vOracleMessage := SQLERRM;
         pErrorMsg := 'Log Process Calling Problem';
         RAISE vMyException;
   END;
EXCEPTION
   WHEN vMyException
   THEN
      pErrorFlag := 'Y';
END;