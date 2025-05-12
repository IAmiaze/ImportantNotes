CREATE OR REPLACE PROCEDURE EMOB.PRC_RECONCILE_STANDING_INSTRUCTION
IS
    TYPE TB_DPS_INFO IS RECORD
    (
        ID                NUMBER,
        AC_ID             NUMBER,
        RD_AC             VARCHAR2 (50),
        CUST_CODE         VARCHAR2 (50),
        REMARKS           VARCHAR2 (1024),
        FREQ_TYPE         VARCHAR2 (10),
        TENURE            VARCHAR2 (10),
        INS_AMT           NUMBER,
        INS_START_DATE    DATE,
        MATURITY_DATE     DATE,
        INT_RATE          NUMBER,
        LINK_AC           VARCHAR2 (50)
    );

    TYPE T_DPS_INFO_TABLE IS TABLE OF TB_DPS_INFO;

    v_dps_info     T_DPS_INFO_TABLE;

    TYPE T_ID_ARRAY IS TABLE OF NUMBER;

    TYPE T_REMARK_ARRAY IS TABLE OF VARCHAR2 (1024);

    v_error_ids    T_ID_ARRAY;
    v_error_msgs   T_REMARK_ARRAY;
    vErrorFlag     VARCHAR2 (2);
    vErrorMsg      VARCHAR2 (1024);
    vRecpmId       VARCHAR2 (1024);
BEGIN
    SELECT ID,
           DI.AC_ID,
           ACM.AC_NO                                      AS RD_AC,
           CUST_CODE,
           DI.REMARKS,
           JSON_VALUE (DI.DTL_JSON, '$.TenureType')       AS FREQ_TYPE,
           JSON_VALUE (DI.DTL_JSON, '$.Tenure')           AS TENURE,
           JSON_VALUE (DI.DTL_JSON, '$.InsAmt')           AS INS_AMT,
           JSON_VALUE (DI.DTL_JSON, '$.InsStartDate')     AS INS_START_DATE,
           JSON_VALUE (DI.DTL_JSON, '$.MaturityDate')     AS MATURITY_DATE,
           JSON_VALUE (DI.DTL_JSON, '$.IntRate')          AS INT_RATE,
           JSON_VALUE (DI.DTL_JSON, '$.LinckAc')          AS LINK_AC
      BULK COLLECT INTO v_dps_info
      FROM EMOB.MB_DPS_INFO  DI
           JOIN EMOB.MB_ACCOUNT_MST ACM ON DI.AC_ID = ACM.AC_ID
           JOIN EMOB.MB_PRODUCT_MST PM 
                ON  ACM.AC_TYPE_ID = PM.AC_TYPE_ID 
                AND NVL (PM.PRODUCT_CATEGORY, 'N') = 'D'
           JOIN EMOB.MB_CUSTOMER_MST CM ON CM.CUST_NO = ACM.CUST_NO
     WHERE DI.STAND_INSTRUCTION = 'N'
     AND TRUNC (DI.CREATE_DATE) = TRUNC (SYSDATE);

    v_error_ids := t_id_array ();
    v_error_msgs := t_remark_array ();

    FOR i IN 1 .. v_dps_info.COUNT
    LOOP
        BEGIN
            EMOB.GLOBAL_CBS_ALL_API.DPS_STANDING_INST (
                pInsAmount    => v_dps_info (i).INS_AMT,
                pTenureType   => v_dps_info (i).FREQ_TYPE,
                pTenure       => v_dps_info (i).TENURE,
                pLinkAc       => v_dps_info (i).LINK_AC,
                pCbsAc        => v_dps_info (i).RD_AC,
                pCustCode     => v_dps_info (i).CUST_CODE,
                pRecpmId      => vRecpmId,
                pErrorFlag    => vErrorFlag,
                pErrorMsg     => vErrorMsg);

            IF NVL (vErrorFlag, 'N') = 'Y'
            THEN
                v_error_ids.EXTEND;
                v_error_ids (v_error_ids.COUNT) := v_dps_info (i).ID;

                v_error_msgs.EXTEND;
                v_error_msgs (v_error_msgs.COUNT) :=
                    'DPS Standing Inst. API Process Problem (after executed scheduler):' || vErrorMsg;
            ELSIF TRIM (vRecpmId) IS NULL
            THEN
                v_error_ids.EXTEND;
                v_error_ids (v_error_ids.COUNT) := v_dps_info (i).ID;

                v_error_msgs.EXTEND;
                v_error_msgs (v_error_msgs.COUNT) :=
                    'RecpmId Not Returned by API (after executed scheduler)';
            ELSE
                v_error_ids.EXTEND;
                v_error_ids (v_error_ids.COUNT) := v_dps_info (i).ID;

                v_error_msgs.EXTEND;
                v_error_msgs (v_error_msgs.COUNT) :=
                    'Standing Created (after executed scheduler) with-' || vRecpmId;
            END IF;
        EXCEPTION
            WHEN OTHERS
            THEN
                v_error_ids.EXTEND;
                v_error_ids (v_error_ids.COUNT) := v_dps_info (i).ID;

                v_error_msgs.EXTEND;
                v_error_msgs (v_error_msgs.COUNT) :=
                    'Unhandled Error (after executed scheduler): ' || SQLERRM;
        END;
    END LOOP;

    FORALL i IN 1 .. v_error_ids.COUNT
        UPDATE EMOB.MB_DPS_INFO
           SET REMARKS = v_error_msgs (i),
               STAND_INSTRUCTION =
                   CASE
                       WHEN v_error_msgs (i) LIKE 'Standing Created%'
                       THEN
                           'Y'
                       ELSE
                           'N'
                   END
         WHERE ID = v_error_ids (i);

    COMMIT;
END;
/
