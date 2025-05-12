/* Formatted on 1/28/2025 6:47:36 PM (QP5 v5.388) */
CREATE OR REPLACE PROCEDURE SMS_MIAZE (pMessage    IN VARCHAR2,
                                       pReceiver   IN VARCHAR2)
AS
    vLink       VARCHAR2 (32000);
    vMessage    VARCHAR2 (32000);
    req         UTL_HTTP.REQ;
    resp        UTL_HTTP.RESP;
    vResponse   VARCHAR2 (30000);
BEGIN
    -- Prepare the message
    vMessage := pMessage;

    SELECT UPPER (
               REPLACE (
                   SUBSTR (DUMP (vMessage, 16),
                           INSTR (DUMP (vMessage, 16), ': ') + 2),
                   ',',
                   '%'))    AS hex_string
      INTO vMessage
      FROM DUAL;


    vMessage := '%' || vMessage;
    vLink :=
           'https://api.smsq.global/api/v2/SendSMS?ApiKey=nvFmb2SW5aHM4rJQRe7ukjqzbnXuEE1k+ijPAvq/3wA=&ClientId=b1a9a16e-2bbe-4939-8a27-8fec496b1925&SenderId=8809617601212&Message='
        || vMessage
        || CHR (38)
        || 'MobileNumbers=+88'
        || pReceiver
        || CHR (38)
        || 'Is_Unicode=true&Is_Flash=longsms';


    UTL_HTTP.SET_TRANSFER_TIMEOUT (60);
    UTL_HTTP.SET_WALLET (
        'file:/home/oracle/oracledb19/wallet/wallet23012025',
        'Rangs@2025@');

    vResponse := UTL_HTTP.REQUEST (vLink);
EXCEPTION
    WHEN OTHERS
    THEN
        UTL_HTTP.END_RESPONSE (resp);

        RAISE;
END;
/
