/* Formatted on 9/7/2022 2:10:16 PM (QP5 v5.360) */
DECLARE
    vOutXml1   CONSTANT XMLTYPE
        := XMLTYPE (
               '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:getCASAMiniStatementResponse xmlns:ns="http://ws.apache.org/axis2">
         <ns:return xsi:type="ax2119:GetCASAMiniStatementResponse" xmlns:ax2113="http://wallet.city/xsd" xmlns:ax2115="http://kgdcl.city/xsd" xmlns:ax2117="http://card/xsd" xmlns:ax2119="http://city/xsd" xmlns:ax2121="http://fi/xsd" xmlns:ax2123="http://tutionfee.city/xsd" xmlns:ax2125="http://nsu.city/xsd" xmlns:ax2128="http://ababil.city/xsd" xmlns:ax2130="http://movie.city/xsd" xmlns:ax2132="http://mbm.city/xsd" xmlns:ax2134="http://rtgs.city/xsd" xmlns:ax2137="http://sql.java/xsd" xmlns:ax2139="http://qr.city/xsd" xmlns:ax2141="http://nagad.city/xsd" xmlns:ax2143="http://mfs.city/xsd" xmlns:ax2145="http://ivac.city/xsd" xmlns:ax2148="http://veefin.city/xsd" xmlns:ax2150="http://helper/xsd" xmlns:ax2152="http://expedite.city/xsd" xmlns:ax2154="http://dom.w3c.org/xsd" xmlns:ax2156="http://bkash.city/xsd" xmlns:ax2158="http://amberit.city/xsd" xmlns:ax2160="http://akash.city/xsd" xmlns:ax2162="http://io.java/xsd" xmlns:ax2164="http://security.java/xsd" xmlns:ax2166="http://dpdc.city/xsd" xmlns:ax2168="http://ipay.city/xsd" xmlns:ax2170="http://otherbank.city/xsd" xmlns:ax2172="http://gp.city/xsd" xmlns:ax2175="http://fimi_types_xsd._1_0.two.schemas.compassplus.com/xsd" xmlns:ax2177="http://cdm_otp.city/xsd" xmlns:ax2179="http://paywell.city/xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <ax2119:responseCode>100</ax2119:responseCode>
            <ax2119:responseData xsi:type="ax2119:CASAMinistatementResponse">
               <ax2119:accountNumber>2251923125001</ax2119:accountNumber>
               <ax2119:accountStatus>Active</ax2119:accountStatus>
               <ax2119:availableBalance>3.34161867915444E12</ax2119:availableBalance>
               <ax2119:clearBalance>3.34161868010762E12</ax2119:clearBalance>
               <ax2119:currencyCode>BDT</ax2119:currencyCode>
               <ax2119:totalBalance>3.34161868010762E12</ax2119:totalBalance>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>11.0</ax2119:availableBalance>
                  <ax2119:deposit>2.0</ax2119:deposit>
                  <ax2119:description>TRTR/144161447102/18-03-2020 20:14:45/CBL</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>24-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>0.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>10.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>TRTR/001441104341/18-03-2020 20:14:45/CBL</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>24-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>5.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>11.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>5.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>12.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>10.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>13.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>5.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>14.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>10.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>15.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>10.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>16.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>5.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>17.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>5.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>18.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>10.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>19.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>10.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>14.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>5.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>20.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>10.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>22.0</ax2119:availableBalance>
                  <ax2119:deposit>10.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>0.0</ax2119:withdraw>
               </ax2119:transactionList>
               <ax2119:transactionList xsi:type="ax2119:MiniStatementTransationList">
                  <ax2119:availableBalance>12.0</ax2119:availableBalance>
                  <ax2119:deposit>0.0</ax2119:deposit>
                  <ax2119:description>2251923125001</ax2119:description>
                  <ax2119:outstandingBalance>0.0</ax2119:outstandingBalance>
                  <ax2119:refCheque xsi:nil="true"/>
                  <ax2119:transactionDate>23-MAY-2022</ax2119:transactionDate>
                  <ax2119:withdraw>5.0</ax2119:withdraw>
               </ax2119:transactionList>
            </ax2119:responseData>
            <ax2119:responseMessage>Operation Successful.</ax2119:responseMessage>
         </ns:return>
      </ns:getCASAMiniStatementResponse>
   </soapenv:Body>
</soapenv:Envelope>') ;
    vResCode            VARCHAR2 (10);
    vAc_no              VARCHAR2 (100);
    vAvailBalance       VARCHAR2 (100);
    vTrAvailBalance     VARCHAR2 (100);

    vResMsg             VARCHAR2 (1024);
BEGIN
    BEGIN
        FOR I
            IN (SELECT rescode.RES_CODE,
                       resmsg.RES_MSG,
                       accountNumber.AC_NO,
                       availableBalance.AVAIL_BALANCE,
                       travailableBalance.TR_AVAIL_BALANCE,
                       deposit.TR_DEPOSIT
                  FROM XMLTABLE (
                           XMLNAMESPACES (
                               'http://ws.apache.org/axis2' AS "ns",
                               'http://city/xsd' AS "ax2119"),
                           '//ns:getCASAMiniStatementResponse//ax2119:responseCode'
                           PASSING vOutXml1
                           COLUMNS RES_CODE VARCHAR2 (1024)
                                       PATH '/ax2119:responseCode') rescode,
                       XMLTABLE (
                           XMLNAMESPACES (
                               'http://ws.apache.org/axis2' AS "ns",
                               'http://city/xsd' AS "ax2119"),
                           '//ns:getCASAMiniStatementResponse//ax2119:responseMessage'
                           PASSING vOutXml1
                           COLUMNS RES_MSG VARCHAR2 (1024)
                                       PATH '/ax2119:responseMessage') resmsg,
                       XMLTABLE (
                           XMLNAMESPACES (
                               'http://ws.apache.org/axis2' AS "ns",
                               'http://city/xsd' AS "ax2119"),
                           '//ns:getCASAMiniStatementResponse//ax2119:responseData'
                           PASSING vOutXml1
                           COLUMNS AC_NO VARCHAR2 (100)
                                       PATH '/ax2119:responseData/ax2119:accountNumber')
                       accountNumber,
                       XMLTABLE (
                           XMLNAMESPACES (
                               'http://ws.apache.org/axis2' AS "ns",
                               'http://city/xsd' AS "ax2119"),
                           '//ns:getCASAMiniStatementResponse//ax2119:responseData'
                           PASSING vOutXml1
                           COLUMNS AVAIL_BALANCE VARCHAR2 (100)
                                       PATH '/ax2119:responseData/ax2119:availableBalance')
                       availableBalance,
                       XMLTABLE (
                           XMLNAMESPACES (
                               'http://ws.apache.org/axis2' AS "ns",
                               'http://city/xsd' AS "ax2119"),
                           '//ns:getCASAMiniStatementResponse//ax2119:transactionList'
                           PASSING vOutXml1
                           COLUMNS TR_AVAIL_BALANCE VARCHAR2 (100)
                                       PATH '/ax2119:transactionList/ax2119:availableBalance')
                       travailableBalance,
                       XMLTABLE (
                           XMLNAMESPACES (
                               'http://ws.apache.org/axis2' AS "ns",
                               'http://city/xsd' AS "ax2119"),
                           '//ns:getCASAMiniStatementResponse//ax2119:transactionList'
                           PASSING vOutXml1
                           COLUMNS TR_DEPOSIT VARCHAR2 (100)
                                       PATH '/ax2119:transactionList/ax2119:deposit')
                       deposit)
        LOOP
            DBMS_OUTPUT.put_line (
                vAc_no || ' Avail Balance ' || i.TR_AVAIL_BALANCE ||' Deposit '||i.TR_DEPOSIT);
        END LOOP;
    END;
END;