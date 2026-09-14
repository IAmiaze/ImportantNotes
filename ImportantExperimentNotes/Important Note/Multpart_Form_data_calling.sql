DECLARE
    l_multipart          apex_web_service.t_multipart_parts;
    l_blob               BLOB;
    l_body_blob          BLOB;
    l_body_json          CLOB;
    l_xml_file_blob      CLOB;
    l_cert_file_blob     BLOB;
    l_public_file_blob   BLOB;
    l_response           CLOB;
BEGIN
    -- Retrieve BLOB data from the FATCA_ENCRY table
    BEGIN
        SELECT CERTFILE, PUBLICFILE, XMLFILE
          INTO l_cert_file_blob, l_public_file_blob, l_xml_file_blob
          FROM FATCA_ENCRY
         WHERE FATCA_ID = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            RAISE_APPLICATION_ERROR (-20001,
                                     'No data found in FATCA_ENCRY table.');
    END;

    -- Append files as multipart form-data
    apex_web_service.append_to_multipart (
        p_multipart      => l_multipart,
        p_name           => 'certFile',
        p_filename       => 'certFile',
        p_content_type   => 'application/x-pkcs12',
        p_body_blob      => l_cert_file_blob);

    apex_web_service.append_to_multipart (p_multipart      => l_multipart,
                                          p_name           => 'certPassword',
                                          p_content_type   => 'text/plain',
                                          p_body           => '123456');

    apex_web_service.append_to_multipart (
        p_multipart      => l_multipart,
        p_name           => 'publicFile',
        p_filename       => 'publicFile',
        p_content_type   => 'application/x-pkcs12',
        p_body_blob      => l_public_file_blob     --p_body => l_xml_file_blob
                                              );

    apex_web_service.append_to_multipart (
        p_multipart      => l_multipart,
        p_name           => 'xmlFile',
        p_filename       => 'xmlFile',
        p_content_type   => 'application/xml',
        p_body           => l_xml_file_blob);

    -- Generate request body
    l_body_blob :=
        apex_web_service.generate_request_body (p_multipart => l_multipart);

    -- Make REST request
    l_response :=
        apex_web_service.make_rest_request (
            p_url           => 'http://10.11.205.20:85/api/XmlEncription/sign-encrypt',
            p_http_method   => 'POST',
            p_body_blob     => l_body_blob);

    -- Store response instead of request body
    INSERT INTO fatca_api_responses (response,ZIP_BLOB)
         VALUES (l_response,apex_web_service.clobbase642blob (l_response));

    COMMIT;
END;