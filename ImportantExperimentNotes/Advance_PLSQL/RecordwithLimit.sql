CREATE OR REPLACE PROCEDURE prc_salary_update_and_insert IS
   -- Define a custom record type for the source data
   TYPE EmployeeRecord IS RECORD (
      first_name   VARCHAR2(50),
      age          NUMBER(3),
      birth_date   DATE,
      salary       NUMBER(7,2)
   );

   -- Define a table type for the source data
   TYPE EmployeeRecordTable IS TABLE OF EmployeeRecord;

   -- Another record type for the destination table
   TYPE ArchiveRecord IS RECORD (
      first_name   VARCHAR2(50),
      age          NUMBER(3),
      birth_date   DATE,
      new_salary   NUMBER(7,2)  -- This will hold the updated salary
   );

   -- Define a table type for the destination records
   TYPE ArchiveRecordTable IS TABLE OF ArchiveRecord;

   -- Declare variables
   l_employees   EmployeeRecordTable;  -- Holds fetched employee records
   l_archive     ArchiveRecordTable;   -- Holds processed employee records with updated salary
   l_limit       CONSTANT PLS_INTEGER := 10000;  -- Batch size for processing
   l_total_rows  PLS_INTEGER := 30000;  -- Total number of rows to fetch and process
   l_offset      PLS_INTEGER := 0;      -- Offset for batch processing

   -- Cursor declaration
   CURSOR c_employees IS
      SELECT first_name, age, birth_date, salary
      FROM employees;  -- Example table

BEGIN
   -- Open the cursor
   OPEN c_employees;

   -- Loop to process records in batches until we reach 30,000 rows
   LOOP
      -- Fetch the cursor results into l_employees variable with a limit of 10,000 rows
      FETCH c_employees BULK COLLECT INTO l_employees LIMIT l_limit;

      -- Exit the loop if no more rows are fetched or we have processed 30,000 rows
      EXIT WHEN l_employees.COUNT = 0 OR l_offset >= l_total_rows;

      -- Initialize the l_archive table for each batch
      l_archive := ArchiveRecordTable();

      -- Process the fetched records, calculate new salary, and assign to the new record type
      FOR i IN l_employees.FIRST .. l_employees.LAST LOOP
         l_archive.EXTEND;
         l_archive(l_archive.LAST).first_name := l_employees(i).first_name;
         l_archive(l_archive.LAST).age := l_employees(i).age;
         l_archive(l_archive.LAST).birth_date := l_employees(i).birth_date;
         -- Calculate salary increase (13%)
         l_archive(l_archive.LAST).new_salary := l_employees(i).salary * 1.13;
      END LOOP;

      -- Use FORALL to perform bulk insert into the archive table
      BEGIN
         FORALL i IN l_archive.FIRST .. l_archive.LAST SAVE EXCEPTIONS
            INSERT INTO employee_archive (first_name, age, birth_date, new_salary)
            VALUES (l_archive(i).first_name, 
                    l_archive(i).age, 
                    l_archive(i).birth_date, 
                    l_archive(i).new_salary);

      EXCEPTION
         WHEN OTHERS THEN
            -- Handle any bulk exceptions
            FOR j IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
               DBMS_OUTPUT.PUT_LINE('Error in record ' || SQL%BULK_EXCEPTIONS(j).ERROR_INDEX ||
                                    ' with error code ' || SQL%BULK_EXCEPTIONS(j).ERROR_CODE);
            END LOOP;
      END;

      -- Increment the offset for the next batch
      l_offset := l_offset + l_limit;

      -- Exit if we have processed 30,000 rows
      EXIT WHEN l_offset >= l_total_rows;
   END LOOP;

   -- Close the cursor
   CLOSE c_employees;

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/
