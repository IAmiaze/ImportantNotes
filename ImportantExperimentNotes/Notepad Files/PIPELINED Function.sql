/* Formatted on 10/19/2023 5:08:31 PM (QP5 v5.313) */
CREATE TYPE REC_TB AS OBJECT
(
    AC_TYPE_ID NUMBER,
    SHORT_DESC VARCHAR2 (100),
    FULL_DESC VARCHAR2 (200),
    ASST_LIB VARCHAR2 (1)
);
/

CREATE TYPE TABLE_PRODUCT IS TABLE OF REC_TB;
/

CREATE OR REPLACE FUNCTION ANIK_PRODUCT (pBranchCode IN VARCHAR2)
    RETURN TABLE_PRODUCT
    PIPELINED
AS
    IDX   NUMBER := 0;
BEGIN
    FOR i IN (SELECT AC_TYPE_ID,
                     SHORT_DESC,
                     FULL_DESC,
                     ASST_LIB
                FROM emob.mb_product_mst
               WHERE BRANCH_CODE = pBranchCode)
    LOOP
        PIPE ROW (REC_TB (i.AC_TYPE_ID,
                          i.SHORT_DESC,
                          i.FULL_DESC,
                          i.ASST_LIB));
    END LOOP;

    RETURN;
END;

SELECT * FROM TABLE (ANIK_PRODUCT ('01'))