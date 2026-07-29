DECLARE
    TYPE employee_rec IS RECORD (
        employee_id   NUMBER,
        employee_name VARCHAR2(50),
        salary        NUMBER,
        new_salary    NUMBER
    );

    TYPE employee_table IS TABLE OF employee_rec INDEX BY PLS_INTEGER;

    employees employee_table;

    CURSOR c_employees IS
        SELECT employee_id, employee_name, salary FROM employees;
BEGIN
    FOR rec IN c_employees LOOP
        employees(rec.employee_id).employee_id := rec.employee_id;
        employees(rec.employee_id).employee_name := rec.employee_name;
        employees(rec.employee_id).salary := rec.salary;
        employees(rec.employee_id).new_salary := rec.salary * 1.10; -- Adding 10% incentive
    END LOOP;

    FORALL i IN INDICES OF employees
        INSERT INTO employees_with_incentive (employee_id, employee_name, salary, new_salary)
        VALUES (employees(i).employee_id, employees(i).employee_name, employees(i).salary, employees(i).new_salary);

    COMMIT;
END;
