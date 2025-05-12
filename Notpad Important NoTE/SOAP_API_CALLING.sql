DECLARE
   l_envelope   CLOB;
   l_xml        XMLTYPE;
   l_result     VARCHAR2 (32767);
BEGIN
   -- Build a SOAP document appropriate for the web service.

   l_envelope := q'!<?xml version='1.0' encoding='UTF-8'?>!';



   l_envelope :=
         l_envelope
      || '<soap:Envelope
	xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
	xmlns:pub="http://xmlns.oracle.com/oxp/service/PublicReportService">
	<soap:Header/>
	<soap:Body>
		<pub:runReport>
			<pub:reportRequest>
				<pub:attributeFormat>xlsx</pub:attributeFormat>
				<!-- Flatten XML should always be false when we have XML type of output to display the XML tags as mentioned in BIP Data Model and display XML structure in as expected format -->
				<pub:flattenXML>false</pub:flattenXML>
				<pub:parameterNameValues>
					<!--1st Parameter of BIP Report-->
					<pub:item>
						<pub:name>p_start_date</pub:name>
						<pub:values>
							<pub:item>01-06-2022</pub:item>
						</pub:values>
					</pub:item>
					<!--2ns Parameter of BIP Report-->
					<pub:item>
						<pub:name>p_end_date</pub:name>
						<pub:values>
							<pub:item>30-06-2022</pub:item>
						</pub:values>
					</pub:item>
					<!--3rd Parameter of BIP Report-->
					<pub:item>
						<pub:name>p_bu_id</pub:name>
						<pub:values>
							<pub:item>300000025937053</pub:item>
						</pub:values>
					</pub:item>
				</pub:parameterNameValues>
				<pub:reportAbsolutePath>/Custom/Finacials/Payables/XX Vendor Outbound Report.xdo</pub:reportAbsolutePath>
				<!-- Setting sizeOfDataChunkDownload to -1 will return the output to the calling client -->
				<pub:sizeOfDataChunkDownload>-1</pub:sizeOfDataChunkDownload>
			</pub:reportRequest>
		</pub:runReport>
	</soap:Body>
</soap:Envelope>';

   l_xml :=
      APEX_WEB_SERVICE.make_request (
         p_url        => 'https://<server>/xmlpserver/services/ExternalReportWSSService?WSDL ',
         p_version    => '1.2',
         p_envelope   => l_envelope,
         p_username   => 'Username',
         p_password   => 'Password');

   l_result :=
      APEX_WEB_SERVICE.parse_xml (
         p_xml     => l_xml,
         p_xpath   => 'env:Envelope/env:Body/ns2:runReportResponse/ns2:runReportReturn/reportBytes',
         p_ns      => 'xmlns:ns2="http://xmlns.oracle.com/oxp/service/PublicReportService"');

   DBMS_OUTPUT.put_line ('l_result=' || l_result);
END;