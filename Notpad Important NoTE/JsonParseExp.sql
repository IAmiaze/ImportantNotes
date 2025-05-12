CREATE OR REPLACE PACKAGE pkg_json_parser AS 

    -- Define a record type for JSON key-value pairs
    TYPE json_parsed_rec IS RECORD (
        tag_name   VARCHAR2(200),
        tag_value  VARCHAR2(4000)
    );
    TYPE json_parsed_table IS TABLE OF json_parsed_rec;
    FUNCTION parse_json_pipeline (
        p_json CLOB
    ) RETURN json_parsed_table PIPELINED;

END pkg_json_parser;
/
CREATE OR REPLACE PACKAGE BODY pkg_json_parser AS 

    FUNCTION parse_json_pipeline (
        p_json CLOB
    ) RETURN json_parsed_table PIPELINED
    IS
        v_json_obj  JSON_OBJECT_T;
        v_keys      JSON_KEY_LIST;
        v_value     VARCHAR2(4000);
    BEGIN
        -- Parse JSON input into an object
        v_json_obj := JSON_OBJECT_T.PARSE(p_json);

        -- Retrieve all keys from JSON object
        v_keys := v_json_obj.GET_KEYS();

        -- Loop through keys and retrieve values
        FOR i IN 1 .. v_keys.COUNT LOOP
            v_value := v_json_obj.GET_STRING(v_keys(i)); -- Extract value as string

            -- Pipe the result as key-value pair
            PIPE ROW (json_parsed_rec(v_keys(i), v_value));
        END LOOP;

        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            -- Handle errors
            PIPE ROW (json_parsed_rec('ERROR', SQLERRM));
    END parse_json_pipeline;

END pkg_json_parser;
/
