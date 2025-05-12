CREATE OR REPLACE PACKAGE STUTIL.PKG_LOAD_EXCEL
IS
    PROCEDURE prc_upload_xls_with_collection (
        p_upload_file   IN     VARCHAR2,
        pAppID                 VARCHAR2,
        pAppSession            VARCHAR2,
        pErrorMessage      OUT VARCHAR2,
        pErrorFlag         OUT VARCHAR2);

    FUNCTION generate_xl_as_html_report (pAppId NUMBER, pSessionId NUMBER)
        RETURN CLOB;

    PROCEDURE prc_xl_data_submit (pServiceId VARCHAR2);

    FUNCTION dfn_get_dynamic_xml (p_table_name    IN VARCHAR2,
                                  p_column_list   IN VARCHAR2,
                                  p_where_cls     IN VARCHAR2)
        RETURN CLOB;

    FUNCTION dfn_parse_xml_to_html (p_xml_input IN CLOB)
        RETURN CLOB;
END;
/
