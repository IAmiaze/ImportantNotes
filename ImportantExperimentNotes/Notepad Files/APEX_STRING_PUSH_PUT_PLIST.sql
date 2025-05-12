/* Formatted on 12/6/2023 1:19:56 PM (QP5 v5.360) */
DECLARE
    CURSOR ck_reqst IS
        SELECT request_id, ac_id, account_no FROM emob.cheque_request;

    ck_request_table   apex_t_varchar2;
    l_chk_count        NUMBER;
BEGIN
    -- Loop through all tasks.
    FOR chk_rec IN ck_reqst
    LOOP
        BEGIN
            -- Attempt to get the task count for the owner of the current task in the loop.
            l_chk_count :=
                apex_string.plist_get (p_table   => ck_request_table,
                                       p_key     => chk_rec.account_no);
            -- If we don't get a NO_DATA_FOUND exception, then we can increment the count.
            -- apex_string.plist_put looks up the value in p_key and updates the associated value using p_value
            apex_string.plist_put (p_table   => ck_request_table,
                                   p_key     => chk_rec.account_no,
                                   p_value   => l_chk_count + 1);
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                -- Create an initial record in the array for the new Task Owner.
                apex_string.plist_put (p_table   => ck_request_table,
                                       p_key     => chk_rec.account_no,
                                       p_value   => 1);
        END;
    END LOOP;

    apex_string.plist_push (p_table   => ck_request_table,
                            p_key     => 'CNDEMO',
                            p_value   => 0);

    apex_string.plist_put (p_table   => ck_request_table,
                           p_key     => 'CNDEMO',
                           p_value   => 99);

    -- Show the Owners and Task Counts.
    DBMS_OUTPUT.put_line (
        'Before Delete: ' || apex_string.join (ck_request_table, ':'));

    -- Delete the record for CNDEMO
    apex_string.plist_delete (ck_request_table, 'CNDEMO');

    -- Show the Owners and Task Counts again.
    DBMS_OUTPUT.put_line (
        'After Delete : ' || apex_string.join (ck_request_table, ':'));
END;