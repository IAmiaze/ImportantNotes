/* Formatted on 4/2/2026 1:52:44 PM (QP5 v5.388) */
CREATE OR REPLACE PACKAGE EMOB.apex_apps_rest
IS
    --
    -- This is the name of the ORDS REST Module
    --
    c_ords_module_name   CONSTANT VARCHAR2 (16) := 'apex.apps.expimp';

    --=============================================================================
    -- exports an application or application components, as SQL or ZIP file.
    --
    -- Parameters:
    -- * p_application_file   Application ID to be exported; append ".zip" or ".sql"
    --                        to determine the file type.
    -- * p_components         Only export the specified components; use syntax
    --                        of APEX_EXPORT.GET_APPLICATION procedure; components
    --                        separated by comma.
    -- * p_mimetype           mimetype of the expected target file. Supports .sql or .zip
    --                        and .json in the future. Overrides the suffix specified
    --                        in p_application_file.
    --=============================================================================
    PROCEDURE export (p_application_file   IN VARCHAR2,
                      p_components         IN VARCHAR2,
                      p_mimetype           IN VARCHAR2);

    --=============================================================================
    -- imports an application or application components, as SQL or ZIP file.
    --
    -- Parameters:
    -- * p_export_file        Export file
    -- * p_mimetype           Mime Type of the export file, to determine whether
    --                        this is ZIP or SQL
    -- * p_application_id     Import file as this application ID
    -- * p_to_workspace       if provided, import into this workspace
    --=============================================================================
    PROCEDURE import (p_export_file      IN BLOB,
                      p_mimetype         IN VARCHAR2,
                      p_to_workspace     IN VARCHAR2 DEFAULT NULL,
                      p_application_id   IN NUMBER DEFAULT NULL);

    --=============================================================================
    -- deletes an application.
    --
    -- Parameters:
    -- * p_in_workspace       if provided, delete application in this workspace
    -- * p_application_id     Application ID to be deleted; extension will be ignored.
    --=============================================================================
    PROCEDURE delete (p_in_workspace     IN VARCHAR2 DEFAULT NULL,
                      p_application_id   IN NUMBER);

    FUNCTION fn_import_apex_from_clob (p_app_id    NUMBER,
                                       p_file      CLOB DEFAULT NULL,
                                       p_page_id   NUMBER)
        RETURN VARCHAR2;
END apex_apps_rest;
/
