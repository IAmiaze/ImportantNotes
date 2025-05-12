BEGIN
    DBMS_SCHEDULER.CREATE_JOB(
        job_name        => 'DAILY_RECONCILE_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN EMOB.PRC_RECONCILE_STANDING_INSTRUCTION; END;',
        start_date      => TRUNC(SYSDATE) + INTERVAL '20' HOUR,
        repeat_interval => 'FREQ=DAILY; BYHOUR=20; BYMINUTE=0; BYSECOND=0',
        enabled         => TRUE
    );
END;
/
