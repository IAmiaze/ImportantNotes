/* Formatted on 4/23/2025 1:03:07 PM (QP5 v5.388) */
DECLARE
    vMyException        EXCEPTION;
    vErrorFlag          VARCHAR2 (1024);
    vErrorMsz           VARCHAR2 (1024);
    l_iso_finger_data   CLOB
        := '{
	"name": "99990000",
	"app_user": "ERA_ADMIN",
	"ai_logid": "",
	"cust_type": "cus",
	"serial": "",
	"lthumb": "asdasadsdsd",
	"lindex": "sdfsfdsf",
	"lmiddle": "sdfgjhfhgjgjgf",
	"lring": "fsdgsdgfdsgfds",
	"llittle": "sdfgsdgfdgdgdgdgdg",
	"rthumb": "ffdffdfsaf",
	"rindex": "sdfsdfdsgdgds",
	"rmiddle": "dsgdfsgsdfgfsdgd",
	"rring": "12156456546",
	"rlittle": "sdfdsgfdsgfdgdg",
	"rindexquality": "",
	"lindexquality": "",
	"rthumbquality": "",
	"lthumbquality": "",
	"rmiddlequality": "",
	"lmiddlequality": "",
	"rringquality": "",
	"lringquality": "",
	"rlittlequality": "",
	"llittlequality": ""
}';
BEGIN
    BEGIN
        GUMS.FINGER_PROCESSING_NEW.FIN_ENROLL_API_PROCESS (
            pData        => l_iso_finger_data,
            pUrl         => 'abc',
            pErrorFlag   => vErrorFlag,
            pErrorMsg    => vErrorMsz);
    EXCEPTION
        WHEN OTHERS
        THEN
            vErrorMsz :=
                   'Finger Enroll Process Calling Problem For Customer ID: '
                || ' - '
                || SQLERRM;
            RAISE vMyException;
    END;

    DBMS_OUTPUT.put_line (vErrorMsz);
EXCEPTION
    WHEN vMyException
    THEN
        DBMS_OUTPUT.put_line (vErrorMsz);
END;

select utl_http.request('http://192.168.157.20:7777') from dual