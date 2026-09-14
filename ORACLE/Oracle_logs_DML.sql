-- Find online redo log paths
SELECT member FROM v$logfile;

-- Find recent archived log paths
SELECT name FROM v$archived_log WHERE name IS NOT NULL AND status = 'A' ORDER BY first_time DESC;

-- Step 1: Switch to container root (Required for LogMiner on 12c/19c/21c)
ALTER SESSION SET CONTAINER = CDB$ROOT;

-- Step 2: Clear any old LogMiner session and register the first log file
BEGIN
   BEGIN
      DBMS_LOGMNR.END_LOGMNR;
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   DBMS_LOGMNR.ADD_LOGFILE(
       LogFileName => 'C:\APP\USER\PRODUCT\21C\ORADATA\XE\REDO01.LOG', 
       Options     => DBMS_LOGMNR.NEW
   );
END;
/

-- Step 3: Add the remaining online redo log files
BEGIN
   DBMS_LOGMNR.ADD_LOGFILE(
       LogFileName => 'C:\APP\USER\PRODUCT\21C\ORADATA\XE\REDO02.LOG', 
       Options     => DBMS_LOGMNR.ADDFILE
   );

   DBMS_LOGMNR.ADD_LOGFILE(
       LogFileName => 'C:\APP\USER\PRODUCT\21C\ORADATA\XE\REDO03.LOG', 
       Options     => DBMS_LOGMNR.ADDFILE
   );
END;
/

-- Step 4: Start LogMiner session (using online catalog dictionary)
BEGIN
   DBMS_LOGMNR.START_LOGMNR(
       Options => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG
   );
END;
/

-- Step 5: Query DML changes specifically for your PDB (XEPDB1)
SELECT 
    timestamp,
    src_con_name AS pdb_name,
    username,
    session_info,
    seg_owner,
    table_name,
    operation,
    sql_redo,
    sql_undo
FROM v$logmnr_contents
WHERE operation IN ('INSERT', 'UPDATE', 'DELETE','APEX_260100')
  --AND seg_owner NOT IN ('SYS', 'SYSTEM', 'AUDSYS')
  AND seg_owner  IN ('MIAZE')
  AND src_con_name = 'XEPDB1'
ORDER BY timestamp DESC;

-- Step 6: Close the LogMiner session when finished
BEGIN
   DBMS_LOGMNR.END_LOGMNR;
END;
/

