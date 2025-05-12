CREATE OR REPLACE PACKAGE BODY STUTIL.PKG_LOAD_EXCEL
IS
    PROCEDURE prc_upload_xls_with_collection (
        p_upload_file   IN     VARCHAR2,
        pAppID                 VARCHAR2,
        pAppSession            VARCHAR2,
        pErrorMessage      OUT VARCHAR2,
        pErrorFlag         OUT VARCHAR2)
    IS
        vCount          NUMBER;
        vExistFile      NUMBER;
        v_ws_id         VARCHAR2 (100);
        vErrorMessage   VARCHAR2 (3000);
        vMyException    EXCEPTION;
    BEGIN
        BEGIN
            SELECT MAX (workspace_id)
              INTO v_ws_id
              FROM apex_applications
             WHERE application_id = pAppId;
        EXCEPTION
            WHEN OTHERS
            THEN
                vErrorMessage := REPLACE (SQLERRM, 'ORA-', NULL);
                RAISE vMyException;
        END;

        SELECT COUNT (*)
          INTO vExistFile
          FROM STUTIL.STDEPOSITORS
         WHERE REGEXP_REPLACE (file_name, '^[^/]+/', '') =
               REGEXP_REPLACE (p_upload_file, '^[^/]+/', '');

        IF vExistFile > 0
        THEN
            vErrorMessage :=
                'This File Name Already Exists.Please Rename or Check your Upload File.';
            RAISE vMyException;
        END IF;


        wwv_flow_api.set_security_group_id (v_ws_id);
        APEX_APPLICATION.g_flow_id := pAppId;
        APEX_APPLICATION.g_instance := pAppSession;

        BEGIN
            SELECT COUNT (*)
              INTO vCount
              FROM apex_application_temp_files
             WHERE     NAME = p_upload_file
                   AND id = (SELECT MAX (id)
                               FROM apex_application_temp_files
                              WHERE NAME = p_upload_file);

            IF vCount = 0
            THEN
                vErrorMessage := 'Excel Data Not Found:' || p_upload_file;
                RAISE vMyException;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                vErrorMessage := 'File not found: ' || p_upload_file;
                RAISE vMyException;
        END;

        IF APEX_COLLECTION.COLLECTION_EXISTS ('EXCEL_DATA')
        THEN
            APEX_COLLECTION.DELETE_COLLECTION ('EXCEL_DATA');
        END IF;

        APEX_COLLECTION.CREATE_COLLECTION ('EXCEL_DATA');

        FOR rec
            IN (WITH
                    xlsx
                    AS
                        (SELECT ROW_NR,
                                COL_NR,
                                CASE CELL_TYPE
                                    WHEN 'S'
                                    THEN
                                        STRING_VAL
                                    WHEN 'N'
                                    THEN
                                        TO_CHAR (NUMBER_VAL)
                                    WHEN 'D'
                                    THEN
                                        TO_CHAR (DATE_VAL, 'DD-MON-YYYY')
                                    ELSE
                                        FORMULA
                                END    AS CELL_VAL
                           FROM TABLE (
                                    apex_read_xlsx.READ (
                                        (SELECT blob_content
                                          FROM apex_application_temp_files
                                         WHERE     NAME = p_upload_file
                                               AND id =
                                                   (SELECT MAX (id)
                                                     FROM apex_application_temp_files
                                                    WHERE NAME =
                                                          p_upload_file)))))
                SELECT COL_01,
                       COL_02,
                       COL_03,
                       COL_04,
                       COL_05,
                       COL_06,
                       COL_07,
                       COL_08,
                       COL_09,
                       COL_10,
                       COL_11,
                       COL_12,
                       COL_13,
                       COL_14,
                       COL_15,
                       COL_16,
                       COL_17,
                       COL_18,
                       COL_19,
                       COL_20
                  FROM xlsx
                           PIVOT (
                                 MAX (CELL_VAL)
                                 FOR COL_NR
                                 IN (1 AS COL_01,
                                    2 AS COL_02,
                                    3 AS COL_03,
                                    4 AS COL_04,
                                    5 AS COL_05,
                                    6 AS COL_06,
                                    7 AS COL_07,
                                    8 AS COL_08,
                                    9 AS COL_09,
                                    10 AS COL_10,
                                    11 AS COL_11,
                                    12 AS COL_12,
                                    13 AS COL_13,
                                    14 AS COL_14,
                                    15 AS COL_15,
                                    16 AS COL_16,
                                    17 AS COL_17,
                                    18 AS COL_18,
                                    19 AS COL_19,
                                    20 AS COL_20))
                 WHERE ROW_NR >= 1)
        LOOP
            -- Add data to the collection
            IF rec.COL_01 IS NOT NULL
            THEN
                APEX_COLLECTION.ADD_MEMBER (
                    p_collection_name   => 'EXCEL_DATA',
                    p_c001              => rec.COL_01,
                    p_c002              => rec.COL_02,
                    p_c003              => rec.COL_03,
                    p_c004              => rec.COL_04,
                    p_c005              => rec.COL_05,
                    p_c006              => rec.COL_06,
                    p_c007              => rec.COL_07,
                    p_c008              => rec.COL_08,
                    p_c009              => rec.COL_09,
                    p_c010              => rec.COL_10,
                    p_c011              => rec.COL_11,
                    p_c012              => rec.COL_12,
                    p_c013              => rec.COL_13,
                    p_c014              => rec.COL_14,
                    p_c015              => rec.COL_15,
                    p_c016              => rec.COL_16,
                    p_c017              => rec.COL_17,
                    p_c018              => rec.COL_18,
                    p_c019              => rec.COL_19,
                    p_c020              => rec.COL_20,
                    p_c030              => p_upload_file,
                    p_c031              => STUTIL.STDEPOS_SEQ.NEXTVAL);
            END IF;
        END LOOP;



        DELETE FROM apex_application_temp_files
              WHERE NAME = p_upload_file;
    EXCEPTION
        WHEN vMyException
        THEN
            pErrorMessage := vErrorMessage;
            pErrorFlag := 'Y';
    END prc_upload_xls_with_collection;

    FUNCTION generate_xl_as_html_report (pAppId NUMBER, pSessionId NUMBER)
        RETURN CLOB
    IS
        l_html         CLOB;
        l_header_row   APEX_COLLECTIONS%ROWTYPE;
        vCount         NUMBER;
        v_ws_id        VARCHAR2 (100);
    BEGIN
        BEGIN
            BEGIN
                SELECT MAX (workspace_id)
                  INTO v_ws_id
                  FROM apex_applications
                 WHERE application_id = pAppId;
            EXCEPTION
                WHEN OTHERS
                THEN
                    raise_application_error (-20001, SQLERRM);
            END;

            wwv_flow_api.set_security_group_id (v_ws_id);
            APEX_APPLICATION.g_flow_id := pAppId;
            APEX_APPLICATION.g_instance := pSessionId;
        END;

        l_html :=
               '<style>'
            || 'table {border-collapse: collapse; width: 100%;}'
            || 'th, td {border: 1px solid #ddd; padding: 8px; text-align: left;}'
            || 'th {background-color: #f2f2f2; font-weight: bold;}'
            || 'tr:nth-child(even) {background-color: #f9f9f9;}'
            || 'tr:hover {background-color: #f1f1f1;}'
            || '</style>'
            || '<table>';

        -- Fetch the header row (SEQ_ID = 1)
        BEGIN
            SELECT *
              INTO l_header_row
              FROM APEX_COLLECTIONS
             WHERE COLLECTION_NAME = 'EXCEL_DATA' AND SEQ_ID = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                NULL;
        END;

        -- Generate column headers from the header row
        l_html := l_html || '<tr>';

        IF l_header_row.c001 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c001 || '</th>';
        END IF;

        IF l_header_row.c002 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c002 || '</th>';
        END IF;

        IF l_header_row.c003 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c003 || '</th>';
        END IF;

        IF l_header_row.c004 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c004 || '</th>';
        END IF;

        IF l_header_row.c005 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c005 || '</th>';
        END IF;

        IF l_header_row.c006 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c006 || '</th>';
        END IF;

        IF l_header_row.c007 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c007 || '</th>';
        END IF;

        IF l_header_row.c008 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c008 || '</th>';
        END IF;

        IF l_header_row.c009 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c009 || '</th>';
        END IF;

        IF l_header_row.c010 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c010 || '</th>';
        END IF;

        IF l_header_row.c011 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c011 || '</th>';
        END IF;

        IF l_header_row.c012 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c012 || '</th>';
        END IF;

        IF l_header_row.c013 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c013 || '</th>';
        END IF;

        IF l_header_row.c014 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c014 || '</th>';
        END IF;

        IF l_header_row.c015 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c015 || '</th>';
        END IF;

        IF l_header_row.c016 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c016 || '</th>';
        END IF;

        IF l_header_row.c017 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c017 || '</th>';
        END IF;

        IF l_header_row.c018 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c018 || '</th>';
        END IF;

        IF l_header_row.c019 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c019 || '</th>';
        END IF;

        IF l_header_row.c020 IS NOT NULL
        THEN
            l_html := l_html || '<th>' || l_header_row.c020 || '</th>';
        END IF;

        l_html := l_html || '</tr>';

        -- Add data rows
        FOR r
            IN (  SELECT c001     AS col_01,
                         c002     AS col_02,
                         c003     AS col_03,
                         c004     AS col_04,
                         c005     AS col_05,
                         c006     AS col_06,
                         c007     AS col_07,
                         c008     AS col_08,
                         c009     AS col_09,
                         c010     AS col_10,
                         c011     AS col_11,
                         c012     AS col_12,
                         c013     AS col_13,
                         c014     AS col_14,
                         c015     AS col_15,
                         c016     AS col_16,
                         c017     AS col_17,
                         c018     AS col_18,
                         c019     AS col_19,
                         c020     AS col_20
                   FROM APEX_COLLECTIONS
                  WHERE     COLLECTION_NAME = 'EXCEL_DATA'
                        AND SEQ_ID > 1
                        AND SEQ_ID <= 60
               ORDER BY SEQ_ID)
        LOOP
            -- Start the row
            l_html := l_html || '<tr>';

            IF r.col_01 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_01 || '</td>';
            END IF;

            IF r.col_02 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_02 || '</td>';
            END IF;

            IF r.col_03 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_03 || '</td>';
            END IF;

            IF r.col_04 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_04 || '</td>';
            END IF;

            IF r.col_05 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_05 || '</td>';
            END IF;

            IF r.col_06 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_06 || '</td>';
            END IF;

            IF r.col_07 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_07 || '</td>';
            END IF;

            IF r.col_08 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_08 || '</td>';
            END IF;

            IF r.col_09 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_09 || '</td>';
            END IF;

            IF r.col_10 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_10 || '</td>';
            END IF;

            IF r.col_11 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_11 || '</td>';
            END IF;

            IF r.col_12 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_12 || '</td>';
            END IF;

            IF r.col_13 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_13 || '</td>';
            END IF;

            IF r.col_14 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_14 || '</td>';
            END IF;

            IF r.col_15 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_15 || '</td>';
            END IF;

            IF r.col_16 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_16 || '</td>';
            END IF;

            IF r.col_17 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_17 || '</td>';
            END IF;

            IF r.col_18 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_18 || '</td>';
            END IF;

            IF r.col_19 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_19 || '</td>';
            END IF;

            IF r.col_20 IS NOT NULL
            THEN
                l_html := l_html || '<td>' || r.col_20 || '</td>';
            END IF;

            l_html := l_html || '</tr>';
        END LOOP;

        l_html := l_html || '</table>';

        IF l_html IS NULL
        THEN
            l_html := '<b>No Excel Uploaded</b>';
        END IF;

        RETURN l_html;
    END generate_xl_as_html_report;

    PROCEDURE prc_xl_data_submit (pServiceId VARCHAR2)
    IS
        CURSOR col_map_cur IS
              SELECT SRLNUMBR, COLUMNNM
                FROM STUTLPAR
               WHERE SERVICE_ID = pServiceId
            ORDER BY SRLNUMBR ASC;

        TYPE col_map_type IS TABLE OF col_map_cur%ROWTYPE;

        col_map         col_map_type;

        v_sql           VARCHAR2 (4000);
        v_cols          VARCHAR2 (4000);
        v_vals          VARCHAR2 (4000);
        vMyException    EXCEPTION;
        vErrorMessage   VARCHAR2 (3000);
    BEGIN
        OPEN col_map_cur;

        FETCH col_map_cur BULK COLLECT INTO col_map;

        CLOSE col_map_cur;

        IF col_map.COUNT = 0
        THEN
            vErrorMessage := 'Setup Not Found for this Service' || pServiceId;
            RAISE vMyException;
        END IF;

        IF pServiceId IS NULL
        THEN
            vErrorMessage :=
                'Service ID Not Found for this Service' || pServiceId;
            RAISE vMyException;
        END IF;

        FOR i IN col_map.FIRST .. col_map.LAST
        LOOP
            v_cols := v_cols || col_map (i).COLUMNNM || ', ';
            v_vals :=
                v_vals || 'c' || LPAD (col_map (i).SRLNUMBR, 3, '0') || ', ';
        END LOOP;

        v_cols := RTRIM (v_cols, ', ');
        v_vals := RTRIM (v_vals, ', ');

        BEGIN
            v_sql :=
                   'INSERT INTO STUTIL.STDEPOSITORS (SERIAL,SERVICE_ID,FILE_NAME,'
                || v_cols
                || ') '
                || 'SELECT c031,'''
                || pServiceId
                || ''','
                || 'c030,'
                || v_vals
                || ' FROM APEX_COLLECTIONS '
                || 'WHERE COLLECTION_NAME = ''EXCEL_DATA'' AND SEQ_ID>1 ORDER BY SEQ_ID';

            EXECUTE IMMEDIATE v_sql;
        EXCEPTION
            WHEN VALUE_ERROR
            THEN
                vErrorMessage :=
                       'An error occurred (Value Error): '
                    || REPLACE (SQLERRM, 'ORA-', NULL);
                RAISE vMyException;
            WHEN INVALID_NUMBER
            THEN
                vErrorMessage :=
                       'An error occurred (Invalid Number): '
                    || REPLACE (SQLERRM, 'ORA-', NULL);
                RAISE vMyException;
            WHEN DUP_VAL_ON_INDEX
            THEN
                vErrorMessage :=
                       'Unique Data Violation Error Found :'
                    || REPLACE (SQLERRM, 'ORA-', NULL);
                RAISE vMyException;
             WHEN OTHERS 
            THEN
                vErrorMessage :=
                       'Invalid Data Mapping Error Due To :'
                    || REPLACE (SQLERRM, 'ORA-', NULL);
                RAISE vMyException;
        END;
    EXCEPTION
        WHEN vMyException
        THEN
            raise_application_error (-20010,vErrorMessage);
    END prc_xl_data_submit;

    FUNCTION dfn_get_dynamic_xml (p_table_name    IN VARCHAR2,
                                  p_column_list   IN VARCHAR2,
                                  p_where_cls     IN VARCHAR2)
        RETURN CLOB
    IS
        v_xml_output      CLOB;
        v_sql             VARCHAR2 (4000);
        v_column_sql      VARCHAR2 (4000);
        v_final_columns   VARCHAR2 (10000);
    BEGIN
        v_final_columns := ',SERVICE_ID,STATUS,' || p_column_list;

        FOR i IN (    SELECT REGEXP_SUBSTR (v_final_columns,
                                            '[^,]+',
                                            1,
                                            LEVEL)    AS word
                        FROM DUAL
                  CONNECT BY     REGEXP_SUBSTR (v_final_columns,
                                                '[^,]+',
                                                1,
                                                LEVEL)
                                     IS NOT NULL
                             AND PRIOR v_final_columns = v_final_columns
                             AND PRIOR DBMS_RANDOM.VALUE IS NOT NULL)
        LOOP
            v_column_sql :=
                   v_column_sql
                || 'XMLELEMENT("'
                || i.word
                || '", '
                || i.word
                || ') || ';
        END LOOP;

        v_column_sql := RTRIM (v_column_sql, ' || ');
        v_sql :=
               'SELECT XMLAGG(XMLELEMENT (
               "ITEM",'
            || v_column_sql
            || ')).getClobVal () AS xml_output FROM '
            || p_table_name
            || ' WHERE '
            || p_where_cls;

        EXECUTE IMMEDIATE v_sql
            INTO v_xml_output;

        v_xml_output :=
               '<ITEMS>'
            || REPLACE (REPLACE (v_xml_output, '&lt;', '<'), '&gt;', '>')
            || '</ITEMS>';
        RETURN v_xml_output;
    END;

    FUNCTION dfn_parse_xml_to_html (p_xml_input IN CLOB)
        RETURN CLOB
    IS
        v_html_output   CLOB := '';
        v_xml           XMLTYPE;
        v_row_count     INTEGER := 0;
    BEGIN
        v_xml := XMLTYPE (p_xml_input);
        v_html_output := '<table class="custom-table">';
        v_html_output := v_html_output || '<thead><tr>';

        FOR rec
            IN (         SELECT COLUMN_VALUE     AS item
                          FROM XMLTABLE ('/ITEMS/ITEM'
                                         PASSING v_xml
                                         COLUMNS COLUMN_VALUE    XMLTYPE PATH '.'))
        LOOP
            FOR child_rec
                IN (        SELECT column_name
                             FROM XMLTABLE (
                                      '/ITEM/*'
                                      PASSING rec.item
                                      COLUMNS column_name    VARCHAR2 (4000) PATH 'name(.)'))
            LOOP
                v_html_output :=
                       v_html_output
                    || '<th>'
                    || child_rec.column_name
                    || '</th>';
            END LOOP;

            EXIT;
        END LOOP;

        v_html_output := v_html_output || '</tr></thead>';
        v_html_output := v_html_output || '<tbody>';

        FOR rec
            IN (         SELECT COLUMN_VALUE     AS item
                          FROM XMLTABLE ('/ITEMS/ITEM'
                                         PASSING v_xml
                                         COLUMNS COLUMN_VALUE    XMLTYPE PATH '.'))
        LOOP
            v_html_output := v_html_output || '<tr>';
            v_row_count := v_row_count + 1;

            FOR child_rec
                IN (         SELECT COLUMN_VALUE
                              FROM XMLTABLE (
                                       '/ITEM/*'
                                       PASSING rec.item
                                       COLUMNS column_name     VARCHAR2 (4000) PATH 'name(.)',
                                               COLUMN_VALUE    VARCHAR2 (4000) PATH 'text()'))
            LOOP
                v_html_output :=
                       v_html_output
                    || '<td>'
                    || child_rec.COLUMN_VALUE
                    || '</td>';
            END LOOP;

            v_html_output := v_html_output || '</tr>';
        END LOOP;

        v_html_output := v_html_output || '</tbody></table>';
        v_html_output :=
            v_html_output || '<p>Total Rows: ' || v_row_count || '</p>';
        RETURN v_html_output;
    END;
END;
/
