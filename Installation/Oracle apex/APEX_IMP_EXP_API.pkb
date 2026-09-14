/* Formatted on 4/2/2026 1:48:14 PM (QP5 v5.388) */
CREATE OR REPLACE PACKAGE BODY EMOB.apex_apps_rest
IS
    LF   CONSTANT VARCHAR2 (1) := CHR (10);

    --=============================================================================
    -- Helper Function: Convert a CLOB to a BLOB
    --=============================================================================
    FUNCTION clob_to_blob (p_clob IN CLOB)
        RETURN BLOB
    IS
        l_blob     BLOB;
        l_dstoff   PLS_INTEGER := 1;
        l_srcoff   PLS_INTEGER := 1;
        l_lngctx   PLS_INTEGER := 0;
        l_warn     PLS_INTEGER;
    BEGIN
        sys.DBMS_LOB.createtemporary (lob_loc   => l_blob,
                                      cache     => TRUE,
                                      dur       => sys.DBMS_LOB.call);

        sys.DBMS_LOB.converttoblob (
            dest_lob       => l_blob,
            src_clob       => p_clob,
            amount         => sys.DBMS_LOB.lobmaxsize,
            dest_offset    => l_dstoff,
            src_offset     => l_srcoff,
            blob_csid      => NLS_CHARSET_ID ('AL32UTF8'),
            lang_context   => l_lngctx,
            warning        => l_warn);

        RETURN l_blob;
    END clob_to_blob;

    --=============================================================================
    -- Helper Function: Convert a BLOB to a CLOB
    --=============================================================================
    FUNCTION blob_to_clob (p_blob IN BLOB)
        RETURN CLOB
    IS
        l_clob     CLOB;
        l_dstoff   PLS_INTEGER := 1;
        l_srcoff   PLS_INTEGER := 1;
        l_lngctx   PLS_INTEGER := 0;
        l_warn     PLS_INTEGER;
    BEGIN
        sys.DBMS_LOB.createtemporary (lob_loc   => l_clob,
                                      cache     => TRUE,
                                      dur       => sys.DBMS_LOB.call);

        sys.DBMS_LOB.converttoclob (
            dest_lob       => l_clob,
            src_blob       => p_blob,
            amount         => sys.DBMS_LOB.lobmaxsize,
            dest_offset    => l_dstoff,
            src_offset     => l_srcoff,
            blob_csid      => NLS_CHARSET_ID ('AL32UTF8'),
            lang_context   => l_lngctx,
            warning        => l_warn);

        RETURN l_clob;
    END blob_to_clob;

    --=============================================================================
    -- split filename to file name and extension
    --=============================================================================
    PROCEDURE split_filename (p_full_filename   IN     VARCHAR2,
                              p_filename           OUT VARCHAR2,
                              p_extension          OUT VARCHAR2)
    IS
    BEGIN
        IF INSTR (p_full_filename, '.') > 0
        THEN
            p_filename :=
                SUBSTR (p_full_filename, 1, INSTR (p_full_filename, '.') - 1);
            p_extension :=
                LOWER (
                    SUBSTR (p_full_filename,
                            INSTR (p_full_filename, '.') + 1));
        ELSE
            p_filename := p_full_filename;
        END IF;
    END split_filename;

    --=============================================================================
    -- sets workspace to specified workspace, or to first workspace assigned to
    -- current schema
    --=============================================================================
    PROCEDURE set_workspace (p_workspace IN VARCHAR2)
    IS
    BEGIN
        IF p_workspace IS NOT NULL
        THEN
            APEX_UTIL.set_workspace (p_workspace);
        ELSE
            FOR w IN (SELECT workspace
                        FROM apex_workspaces
                       WHERE ROWNUM = 1)
            LOOP
                APEX_UTIL.set_workspace (w.workspace);
            END LOOP;
        END IF;
    END set_workspace;

    --=============================================================================
    -- Public API, see specification
    --=============================================================================
    PROCEDURE delete (p_in_workspace     IN VARCHAR2 DEFAULT NULL,
                      p_application_id   IN NUMBER)
    IS
    BEGIN
        set_workspace (p_workspace => p_in_workspace);
        apex_application_install.remove_application (
            p_application_id   => p_application_id);
    END delete;

    --=============================================================================
    -- Public API, see specification
    --=============================================================================
    PROCEDURE export (p_application_file   IN VARCHAR2,
                      p_components         IN VARCHAR2,
                      p_mimetype           IN VARCHAR2)
    IS
        l_files        apex_t_export_files;
        l_filename     VARCHAR2 (255);
        l_extension    VARCHAR2 (255);

        l_components   apex_t_varchar2;
        l_blob         BLOB;

        l_as_zip       BOOLEAN;
    BEGIN
        split_filename (p_full_filename   => p_application_file,
                        p_filename        => l_filename,
                        p_extension       => l_extension);

        l_as_zip :=
            CASE
                WHEN p_mimetype IS NULL
                THEN
                    COALESCE (l_extension = 'zip', FALSE)
                ELSE
                    COALESCE (LOWER (p_mimetype) = 'application/zip', FALSE)
            END;

        IF p_components IS NOT NULL
        THEN
            l_components :=
                apex_string.split (LTRIM (RTRIM (p_components)), ',');
        END IF;

        l_files :=
            apex_export.get_application (
                p_application_id   => TO_NUMBER (l_filename),
                p_components       => l_components,
                p_split            => l_as_zip);

        sys.DBMS_LOB.createtemporary (lob_loc   => l_blob,
                                      cache     => TRUE,
                                      dur       => sys.DBMS_LOB.call);

        IF l_as_zip
        THEN
            FOR i IN 1 .. l_files.COUNT
            LOOP
                apex_zip.add_file (
                    p_zipped_blob   => l_blob,
                    p_file_name     => l_files (i).name,
                    p_content       => clob_to_blob (l_files (i).contents));
            END LOOP;

            apex_zip.finish (l_blob);
            sys.OWA_UTIL.mime_header ('application/zip', FALSE);
        ELSE
            l_blob := clob_to_blob (l_files (1).contents);
            sys.OWA_UTIL.mime_header ('application/sql', FALSE);
        END IF;

        sys.HTP.p ('Content-Length: ' || sys.DBMS_LOB.getlength (l_blob));
        sys.HTP.p (
               'Content-Disposition: attachment; filename='
            || l_filename
            || '.'
            || CASE WHEN l_as_zip THEN 'zip' ELSE 'sql' END);
        sys.OWA_UTIL.http_header_close;
        sys.WPG_DOCLOAD.download_file (l_blob);
    END export;

    --=============================================================================
    -- Public API, see specification
    --=============================================================================
    PROCEDURE import (p_export_file      IN BLOB,
                      p_mimetype         IN VARCHAR2,
                      p_to_workspace     IN VARCHAR2 DEFAULT NULL,
                      p_application_id   IN NUMBER DEFAULT NULL)
    IS
        l_files       apex_t_export_files := apex_t_export_files ();
        l_zip_files   apex_zip.t_files;
        --
        l_dstoff      PLS_INTEGER := 1;
        l_srcoff      PLS_INTEGER := 1;
        l_lngctx      PLS_INTEGER := 0;
        l_warn        PLS_INTEGER;
    BEGIN
        set_workspace (p_workspace => p_to_workspace);

        IF LOWER (p_mimetype) = 'application/zip'
        THEN
            l_zip_files :=
                apex_zip.get_files (p_zipped_blob   => p_export_file,
                                    p_only_files    => TRUE);

            l_files.EXTEND (l_zip_files.COUNT);

            FOR i IN 1 .. l_zip_files.COUNT
            LOOP
                l_files (i) :=
                    apex_t_export_file (
                        l_zip_files (i),
                        blob_to_clob (
                            apex_zip.get_file_content (
                                p_zipped_blob   => p_export_file,
                                p_file_name     => l_zip_files (i))));
            END LOOP;
        ELSE
            l_files.EXTEND (1);
            l_files (1) :=
                apex_t_export_file ('import-data.sql',
                                    blob_to_clob (p_export_file));
        END IF;

        apex_application_install.set_application_id (
            p_application_id   => p_application_id);

        apex_application_install.install (p_source               => l_files,
                                          p_overwrite_existing   => TRUE);
    END import;

    FUNCTION fn_get_apex_export_clob (p_app_id    IN NUMBER,
                                      p_page_id   IN NUMBER DEFAULT NULL)
        RETURN CLOB
    IS
        v_apex_export_files   apex_t_export_files;
        v_components          apex_t_varchar2 := apex_t_varchar2 ();
        v_clob                CLOB;
    BEGIN
        IF p_page_id IS NULL
        THEN
            v_apex_export_files :=
                apex_export.get_application (p_application_id         => p_app_id,
                                             p_with_acl_assignments   => TRUE);
        ELSE
            v_components.DELETE;
            v_components.EXTEND (1);
            v_components (1) := 'PAGE:' || p_page_id;

            v_apex_export_files :=
                apex_export.get_application (
                    p_application_id   => p_app_id,
                    p_components       => v_components);
        END IF;

        v_clob := v_apex_export_files (1).contents;
        RETURN v_clob;
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN NULL;
    END fn_get_apex_export_clob;

    FUNCTION fn_import_apex_from_clob (p_app_id    NUMBER,
                                       p_file      CLOB DEFAULT NULL,
                                       p_page_id   NUMBER)
        RETURN VARCHAR2
    IS
        v_blob     BLOB;
        v_clob     CLOB;
        v_status   VARCHAR2 (1000);
    BEGIN
        BEGIN
            IF p_file IS NULL
            THEN
                v_clob :=
                    apex_apps_rest.fn_get_apex_export_clob (p_app_id,
                                                            p_page_id);
            ELSE
                v_clob := p_file;
            END IF;

            v_blob := apex_apps_rest.clob_to_blob (v_clob);
        END;

        apex_apps_rest.import (p_export_file => v_blob, p_mimetype => '.sql');

        COMMIT;

        RETURN 'SUCCESS';
    EXCEPTION
        WHEN OTHERS
        THEN
            RETURN 'ERROR : ' || SQLERRM;
    END;
END apex_apps_rest;
/
