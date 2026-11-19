-- Connect as SYS (e.g., sqlplus sys as sysdba)
CREATE OR REPLACE DIRECTORY data_dir_hr AS 'C:\DATA_DIRECTORY';

-- Grant access to the HR user
GRANT READ, WRITE ON DIRECTORY data_dir_hr TO HR;


-- Connect as HR
DROP TABLE sales_load;

CREATE TABLE sales_load (
  sale_id   VARCHAR2(50),
  sale_date VARCHAR2(50),
  amount    VARCHAR2(50)
)
ORGANIZATION EXTERNAL (
  TYPE ORACLE_LOADER
  DEFAULT DIRECTORY data_dir_hr
  ACCESS PARAMETERS (
    RECORDS DELIMITED BY NEWLINE
    SKIP 1 
    BADFILE data_dir_hr:'sales_load_%p.bad'
    LOGFILE data_dir_hr:'sales_load_%p.log'
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    MISSING FIELD VALUES ARE NULL
    (
      sale_id   CHAR(50),
      sale_date CHAR(50),
      amount    CHAR(50)
    )
  )
  LOCATION ('sales_export.csv')
)
REJECT LIMIT UNLIMITED;