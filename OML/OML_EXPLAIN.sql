---------------------------------------------------------
-- ১. আগের অবজেক্টগুলো পরিষ্কার করা (Cleanup)
---------------------------------------------------------
BEGIN
    -- আগের মডেল ড্রপ করা
    BEGIN 
        DBMS_DATA_MINING.DROP_MODEL('MB_TRANSACTION_FRAUD_MODEL'); 
    EXCEPTION WHEN OTHERS THEN NULL; 
    END;

    -- আগের সেটিংস টেবিল ড্রপ করা
    BEGIN 
        EXECUTE IMMEDIATE 'DROP TABLE mb_settings'; 
    EXCEPTION WHEN OTHERS THEN NULL; 
    END;
END;
/

---------------------------------------------------------
-- ২. সেটিংস টেবিল তৈরি ও কনফিগারেশন
---------------------------------------------------------
CREATE TABLE mb_settings (
    setting_name  VARCHAR2(30),
    setting_value VARCHAR2(4000)
);

BEGIN
    -- SVM অ্যালগরিদম সেট করা
    INSERT INTO mb_settings VALUES (DBMS_DATA_MINING.algo_name, DBMS_DATA_MINING.algo_support_vector_machines);
    
    -- অটোমেটিক ডেটা প্রিপারেশন অন করা
    INSERT INTO mb_settings VALUES (DBMS_DATA_MINING.prep_auto, DBMS_DATA_MINING.prep_auto_on);
    
    -- ১০% ডেটা অ্যানোমালি হতে পারে এমন ধারণা করা (Outlier Rate)
    INSERT INTO mb_settings VALUES (DBMS_DATA_MINING.svms_outlier_rate, '0.1');
    
    -- লিনিয়ার কার্নেল ব্যবহার (অল্প ডেটাতেও ভালো কাজ করে)
    INSERT INTO mb_settings VALUES (DBMS_DATA_MINING.svms_kernel_function, DBMS_DATA_MINING.svms_linear);
    
    COMMIT;
END;
/

---------------------------------------------------------
-- ৩. ট্রেইনিং ভিউ তৈরি (Clean Data for Model)
---------------------------------------------------------
-- নোট: সব কলাম না নিয়ে শুধু গুরুত্বপূর্ণ কলামগুলো নেওয়া হয়েছে যাতে ORA-40104 এরর না আসে
CREATE OR REPLACE VIEW VW_FRAUD_TRAIN AS
SELECT TRAN_ID,
       BRANCH_CODE,
       TRAN_TYPE,
       DRCR_CODE,
       TRAN_AMT_LC,
       AC_ID,
       NVL(TRAN_CODE, 'N/A') as TRAN_CODE,
       -- ল্যাটিচিউড ও লঙ্গিচিউড নাম্বার হিসেবে নেওয়া হচ্ছে
       TO_NUMBER(CASE WHEN REGEXP_LIKE(LAT, '^-?[0-9]*\.?[0-9]+$') THEN LAT ELSE '0' END) as LAT_NUM,
       TO_NUMBER(CASE WHEN REGEXP_LIKE(LNG, '^-?[0-9]*\.?[0-9]+$') THEN LNG ELSE '0' END) as LNG_NUM
FROM EMOB.MB_TRANSACTION_DTL
WHERE TRAN_AMT_LC > 0;

---------------------------------------------------------
-- ৪. মেশিন লার্নিং মডেল বিল্ডিং
---------------------------------------------------------
BEGIN
    DBMS_DATA_MINING.CREATE_MODEL (
        model_name            => 'MB_TRANSACTION_FRAUD_MODEL',
        mining_function       => DBMS_DATA_MINING.CLASSIFICATION,
        data_table_name       => 'VW_FRAUD_TRAIN',
        case_id_column_name   => 'TRAN_ID',
        target_column_name    => NULL, -- Anomaly Detection-এ এটি NULL থাকে
        settings_table_name   => 'mb_settings'
    );
END;
/

---------------------------------------------------------
-- ৫. টেস্ট কুয়েরি (APEX রিপোর্টের জন্য)
---------------------------------------------------------
-- এই কুয়েরিটি রান করলে আপনি প্রতিটি লেনদেনের রিস্ক স্কোর দেখতে পাবেন
SELECT TRAN_ID, 
       TRAN_AMT_LC, 
       -- ১ = স্বাভাবিক, ০ = সন্দেহজনক (Anomaly)
       PREDICTION(MB_TRANSACTION_FRAUD_MODEL USING *) as IS_SAFE,
       -- ফ্রড হওয়ার সম্ভাবনা (০ থেকে ১০০ এর স্কেলে)
       ROUND(PREDICTION_PROBABILITY(MB_TRANSACTION_FRAUD_MODEL, 0 USING *), 4) * 100 as FRAUD_RISK_SCORE
FROM VW_FRAUD_TRAIN
ORDER BY FRAUD_RISK_SCORE DESC;