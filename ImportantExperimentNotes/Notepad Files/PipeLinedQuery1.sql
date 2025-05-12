---Create Sample Table---
CREATE TABLE employees
(
    employee_id      NUMBER,
    employee_name    VARCHAR2 (100),
    department_id    NUMBER
);

----Sample value Insert---
INSERT INTO employees
     VALUES (1, 'John Doe', 101);

INSERT INTO employees
     VALUES (2, 'Jane Smith', 102);

INSERT INTO employees
     VALUES (3, 'Bob Johnson', 101);

/*-- Add more sample data as needed
1. We create a custom type employee_record_type to represent 
the structure of each row in the pipeline.

2. We create another custom type employee_table_type as a table of employee_record_type.

3. We define a pipeline function get_employees_by_department 
   that takes a department ID as a parameter. 
   Inside the function, we use a cursor to fetch employees from 
   the specified department and insert them into the pipeline 
   using the PIPE ROW statement.*/

CREATE OR REPLACE TYPE employee_record_type AS OBJECT
(
    employee_id NUMBER,
    employee_name VARCHAR2 (100),
    department_id NUMBER
);

CREATE OR REPLACE TYPE employee_table_type AS TABLE OF employee_record_type;

CREATE OR REPLACE FUNCTION get_employees_by_department (
    p_department_id   NUMBER)
    RETURN employee_table_type
    PIPELINED
AS
BEGIN
    FOR rec IN (SELECT *
                  FROM employees
                 WHERE department_id = p_department_id)
    LOOP
        PIPE ROW (employee_record_type (rec.employee_id,
                                        rec.employee_name,
                                        rec.department_id));
    END LOOP;

    RETURN;
END get_employees_by_department;
/

SELECT * FROM TABLE (get_employees_by_department (101));