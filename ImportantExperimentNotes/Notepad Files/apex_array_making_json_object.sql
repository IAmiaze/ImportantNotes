DECLARE
  l_clob     CLOB;
  l_error_no NUMBER := 0;
BEGIN
  APEX_JSON.initialize_clob_output;

  APEX_JSON.open_object; -- {

  APEX_JSON.open_array('Response'); -- "Response": [

  -- Simulated loop
  FOR i IN 1 .. 2 LOOP
    l_error_no := l_error_no + 1;

    APEX_JSON.open_object;
    APEX_JSON.write('error_no', l_error_no);

    IF i = 1 THEN
      APEX_JSON.write('message', 'OTP Send Successfully');
      APEX_JSON.write('status', 'success');
    ELSE
      APEX_JSON.write('message', 'Another message');
      APEX_JSON.write('status', 'info');
    END IF;

    APEX_JSON.close_object;
  END LOOP;

  APEX_JSON.close_array; -- ]
  APEX_JSON.close_object; -- }

  l_clob := APEX_JSON.get_clob_output;
  DBMS_OUTPUT.put_line(l_clob);

  APEX_JSON.free_output;
END;


-------Manual-----------
DECLARE
  l_json    CLOB := '';
  l_first   BOOLEAN := TRUE;
  l_error_no NUMBER := 0;
BEGIN
  -- Start of JSON object and array
  l_json := '{ "Response": [';

  -- Simulated loop
  FOR i IN 1 .. 2 LOOP
    l_error_no := l_error_no + 1;

    -- Add comma between objects (but not before the first)
    IF NOT l_first THEN
      l_json := l_json || ',';
    ELSE
      l_first := FALSE;
    END IF;

    -- Append each object
    IF i = 1 THEN
      l_json := l_json || '{
        "error_no": ' || l_error_no || ',
        "message": "OTP Send Successfully",
        "status": "success"
      }';
    ELSE
      l_json := l_json || '{
        "error_no": ' || l_error_no || ',
        "message": "Another message",
        "status": "info"
      }';
    END IF;
  END LOOP;

  -- End of array and object
  l_json := l_json || ']}';

  -- Output
  DBMS_OUTPUT.put_line(l_json);
END;

-----------------Query------------------
DECLARE
    l_clob      CLOB;
    l_cust_no   NUMBER := 0;
BEGIN
    APEX_JSON.initialize_clob_output;

    APEX_JSON.open_object;

    APEX_JSON.open_array ('Response');

    FOR i
        IN (SELECT *
             FROM (SELECT CUST_CODE,
                          FIRST_NAME,
                          LAST_NAME,
                          ROWNUM     r
                     FROM EMOB.MB_CUSTOMER_MST)
            WHERE r <= 10)
    LOOP
        l_cust_no := l_cust_no + 1;

        APEX_JSON.open_object;
        APEX_JSON.write ('customer_no', l_cust_no);
        APEX_JSON.write ('firstName', i.FIRST_NAME);
        APEX_JSON.write ('lastName', i.LAST_NAME);
        APEX_JSON.close_object;
    END LOOP;

    APEX_JSON.close_array;
    APEX_JSON.close_object;

    l_clob := APEX_JSON.get_clob_output;
    DBMS_OUTPUT.put_line (l_clob);

    APEX_JSON.free_output;
END;