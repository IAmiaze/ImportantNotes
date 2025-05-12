/*1. apex_string.get_initials , This API allows you to extract initials for a given string. 
This can be useful when displaying a shortened username in an avatar icon or a chat window.*/

SELECT C.FIRST_NAME || C.LAST_NAME
           FULL_NAME,
       APEX_STRING.GET_INITIALS (C.FIRST_NAME || C.LAST_NAME, 3)
           CUSTOMER_SHORT_NAME,
       DOCUMENT_TYPE,
       DOCMENT_NO,
       APEX_STRING_UTIL.TO_DISPLAY_FILESIZE (
           P_SIZE_IN_BYTES   => LENGTH (DOC_FRONT_IMAGE))
           DOC_FRONT_SIZE,
       APEX_STRING_UTIL.TO_DISPLAY_FILESIZE (
           P_SIZE_IN_BYTES   => LENGTH (DOC_BACK_IMAGE))
           DOC_BACK_IMAGE_SIZE
  FROM EMOB.MB_DOCUMENT_MST  A
       INNER JOIN MEMIMG.CUST_DOC B ON (A.CUST_NO = B.CUST_NO)
       INNER JOIN EMOB.MB_CUSTOMER_MST C ON (A.CUST_NO = C.CUST_NO);

/*2. apex_string_util.to_display_filesize use to display or query of FileSize of your document.*/

SELECT c.FIRST_NAME || c.LAST_NAME,
       DOCUMENT_TYPE,
       DOCMENT_NO,
       apex_string_util.to_display_filesize (
           p_size_in_bytes   => LENGTH (doc_front_image))   doc_front_size,
       apex_string_util.to_display_filesize (
           p_size_in_bytes   => LENGTH (doc_back_image))    doc_back_image_size
  FROM emob.mb_document_mst  a
       INNER JOIN memimg.cust_doc b ON (a.cust_no = b.cust_no)
       INNER JOIN emob.mb_customer_mst c ON (a.cust_no = c.cust_no);

/*3. Get your URL Domain Name from url list*/

SELECT PATH_DIR URL, apex_string_util.get_domain (PATH_DIR) Domain_name
  FROM GUMS.MB_GLOBAL_PATH;

/*apex_string.format use if your value is complex to concate then use it here are two Examples below
use concate Like a pro*/

/**EXAMPLE

/**/

SELECT apex_string.format (
           'Customer name: %s ,Customer No: [%s] ,Customer Type: |%s|',
           FIRST_NAME,
           CUST_NO,
           CUST_TYPE)
  FROM EMOB.MB_CUSTOMER_MST;

--Result Below
--Customer name: Md Jilloor ,Customer No: [2053] ,Customer Type: |CUS|

/**/
apex_string.format (
        q'!begin
          !    if not valid then
          !        apex_debug.info('validation failed');
          !    end if;
          !end;!',
        p_prefix => '!' ) message_formatting;

/**/

SELECT apex_string.format (
           q'!ORA-04021: timeout occurred while waiting to lock object!',
           p_prefix   => 'ORA-')
  FROM DUAL;

/*apex_string.split if you use multiselect popoup lov but you want to parsed this data seperately then use it
Facts if you use IN member of Like this
split number 1,2,3 used here*/

SELECT *
  FROM MB_TRAN_COMM_DTL
 WHERE NATURE_ID
            MEMBER OF(SELECT apex_string.split_numbers (
                                 p_str   => :P10_NATURE_IDS,
                                 p_sep   => ',')
                        FROM DUAL);

/*apex_string_util.find_links you've a thousand line of code and here some url will initiated
 but need to find-out url from here so don't worry chill*/

SELECT COLUMN_VALUE
  FROM apex_string_util.find_links (p_string => 'Dear Concern,
Please have the below webex link...
https://thecitybank.webex.com/meet/navid.anjum
');

/*if you're tangled to find out Email from a scrawble text then here are Easy way to Organise mail
Lets se my Example*/

SELECT COLUMN_VALUE
  FROM apex_string_util.find_email_addresses (
           p_string   =>
               '"Subrata" <subrata@thecitybank.com>, "Chandan Kumar Nag, 
         Head of Channel Development" <chandan.nag@thecitybank.com>,
          "Sakib" <nazmus.adib@thecitybank.com>, 
          "Md. Kamrul Fardaus" <fardaus@erainfotechbd.com>, 
          "ito" <ito@thecitybank.com>, "Md. Rashed Azad Chowdhury, 
          IT PMO" <rashedazad@thecitybank.com>, 
          "Khaled" <khaled.mahmud@thecitybank.com>, 
          "Saddil" <saddil.hossain@thecitybank.com>, 
          "mokaddes hossain" <mokaddes.hossain@thecitybank.com>, 
          "Shekh Shawon" <shawon@erainfotechbd.com>, 
          "Ayub Miaze" <ayub@erainfotechbd.com>, 
          "Sourav" <sourav.debnath@thecitybank.com>');

/*Find # tag value*/

SELECT COLUMN_VALUE
  FROM apex_string_util.find_tags (
           p_string   => 'We love #orclAPEX# and #orclORDS!',
           p_prefix   => '#');


/*apex_string.push you've a process to run for large time but you need to store data when use it  */

DECLARE
    l_table   apex_t_varchar2;
BEGIN
    FOR I IN (SELECT AC_NO, AC_TITLE FROM EMOB.MB_ACCOUNT_MST)
    LOOP
        apex_string.push (l_table, i.AC_NO);
    END LOOP;

    sys.DBMS_OUTPUT.put_line (apex_string.join (l_table, ':'));
END;
/*for your process*/

DECLARE
    l_Archived_table   apex_t_number;
BEGIN
    FOR I IN (SELECT AC_ID FROM EMOB.CHEQUE_REQUEST)
    LOOP
        apex_string.push (l_Archived_table, i.AC_ID);
        sys.DBMS_OUTPUT.put_line (apex_string.join (l_Archived_table, ':'));


        DELETE FROM EMOB.CHEQUE_REQUEST
              WHERE AC_ID MEMBER OF l_Archived_table;
    END LOOP;
END;


/*apex_string_util.get_slug This API removes spaces, 
punctuation, and special characters from a string. 
It returns a maximum of 255 characters. A Slug is the unique identifying part of a web address, 
typically at the end of the URL. I have also used this API to generate a unique string based on an input string.*/

SELECT apex_string_util.get_slug (p_string => 'Jon Dixon', p_hash_length => 10)  slug
  FROM DUAL
UNION ALL
SELECT apex_string_util.get_slug (p_string => 'Jon Dixon', p_hash_length => 10)  slug
  FROM DUAL
UNION ALL
SELECT apex_string_util.get_slug (
           p_string   =>
               'This is a sentence. Some random characters ~!@#$%^&*()-=')    slug
  FROM DUAL;

/*Replace WhiteSpaces
FUNCTION replace_whitespace (
        p_string                 IN VARCHAR,
        p_original_find          IN VARCHAR2 DEFAULT NULL,
        p_whitespace_character   IN VARCHAR2 DEFAULT '|')
        RETURN VARCHAR2;
*/


SELECT apex_string_util.replace_whitespace (
           p_string                 =>
               'This is a sentence. Some random characters ~!@#$%^&*()-=',
           p_whitespace_character   => '+')
  FROM DUAL;