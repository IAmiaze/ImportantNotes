DECLARE
   vResponseJson   CLOB;
   vRowNum         NUMBER;
   vType           VARCHAR2 (100);
   vPhoneNum       VARCHAR2 (100);
BEGIN
   vResponseJson :=
      '{"PONumber"              : 1600,
      "Reference"             : "ABULL-20140421",
       "Requestor"            : "Alexis Bull",
       "User"                 : "ABULL",
       "CostCenter"           : "A50",
       "ShippingInstructions" : {"name"   : "Alexis Bull",
                                 "Address": {"street"   : "200 Sporting Green",
                                              "city"    : "South San Francisco",
                                              "state"   : "CA",
                                              "zipCode" : 99236,
                                              "country" : "United States of America"},
                                 "Phone" : [{"type" : "Office", "number" : "909-555-7307"},
                                            {"type" : "Mobile", "number" : "415-555-1234"}]},
       "Special Instructions" : null,
       "AllowPartialShipment" : true,
       "LineItems" : [{"ItemNumber" : 1,
                       "Part" : {"Description" : "One Magic Christmas",
                                 "UnitPrice"   : 19.95,
                                 "UPCCode"     : 13131092899},
                       "Quantity" : 9.0},
                      {"ItemNumber" : 2,
                       "Part" : {"Description" : "Lethal Weapon",
                                 "UnitPrice"   : 19.95,
                                 "UPCCode"     : 85391628927},
                       "Quantity" : 5.0}]}';

SELECT jarep_parse.ROW_NUMBER,jarep_parse.phone_type,jarep_parse.phone_num
INTO vRowNum,vType,vPhoneNum
FROM JSON_TABLE(vResponseJson, '$.ShippingInstructions.Phone[*]'
COLUMNS (ROW_NUMBER FOR ORDINALITY,
         phone_type VARCHAR2(10) PATH '$.type',
         phone_num VARCHAR2(20) PATH '$.number'))AS jarep_parse
   WHERE phone_type='Mobile';

   /*[{"type":"Office","number":"909-555-7307"},
   {"type":"Mobile","number":"415-555-1234"}]'*/
   
	/*SELECT jt.*
	FROM j_purchaseorder,
	JSON_TABLE(po_document, '$'
	COLUMNS
	(requestor VARCHAR2(32) PATH '$.Requestor',
	NESTED PATH '$.ShippingInstructions.Phone[*]'
		COLUMNS (phone_type VARCHAR2(32) PATH '$.type',
				phone_num VARCHAR2(20) PATH '$.number')))
	AS jt;*/
	
   DBMS_OUTPUT.PUT_LINE (vRowNum || '-' || vType || '-' || vPhoneNum);
END;