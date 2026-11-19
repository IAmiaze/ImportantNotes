/* Formatted on 9/20/2026 9:42:01 PM (QP5 v5.388) */
CREATE TABLE CUSTOMER_INFO
(
    CUSTOMER_ID      NUMBER PRIMARY KEY,
    FIRST_NAME       VARCHAR2 (100),
    LAST_NAME        VARCHAR2 (100) NOT NULL,
    MOBILE_NO        VARCHAR2 (100) UNIQUE,
    AGE              NUMBER CHECK (AGE >= 18),
    DEPARTMENT_ID    NUMBER REFERENCES DEPARTMENTS (DEPARTMENT_ID)
);

CREATE SEQUENCE CUST_ID_SEQ START WITH 100 INCREMENT BY 1;



INSERT INTO CUSTOMER_INFO (CUSTOMER_ID,
                           FIRST_NAME,
                           LAST_NAME,
                           MOBILE_NO,
                           AGE,
                           DEPARTMENT_ID)
     VALUES (CUST_ID_SEQ.NEXTVAL,                              --2time 100,101
             'Kamal',
             'Ahmed',
             '01826315564',
             30,
             20);


ALTER TABLE CUSTOMER_INFO
    ADD (CUST_IMAGE BLOB);


ALTER TABLE CUSTOMER_INFO
    MODIFY (MOBILE_NO VARCHAR2 (11));
    
    
RENAME customer_info TO customer_info_2024;

DELETE customer_info_2024 ;

TRUNCATE table customer_info_2024;

CREATE GLOBAL TEMPORARY TABLE temp_salary_calc (
 employee_id NUMBER, salary NUMBER, calculated_bonus NUMBER(10,2) 
) ON COMMIT DELETE ROWS;

CREATE TABLE bonus_log_main (employee_id NUMBER,tot_salary_bonus NUMBER);

BEGIN
INSERT INTO temp_salary_calc (employee_id,salary,calculated_bonus)
SELECT EMPLOYEE_ID,SALARY, SALARY *.30 FROM EMPLOYEES;

INSERT INTO bonus_log_main (employee_id,tot_salary_bonus)
SELECT EMPLOYEE_ID,(salary+calculated_bonus) FROM temp_salary_calc;

COMMIT;
END;

SELECT * FROM temp_salary_calc;

SELECT * FROM bonus_log_main;

CREATE VIEW high_earners AS
SELECT employee_id, last_name, salary, department_name
FROM employees e JOIN departments d ON (e.department_id = d.department_id)
WHERE salary > 10000;

SELECT * FROM high_earners;


CREATE SYNONYM employee_management FOR employees;

SELECT * FROM employees;

------Composite Primary Key----
CREATE TABLE CUSTOMER_INFO_2
(
    CUSTOMER_ID      NUMBER ,
    FIRST_NAME       VARCHAR2 (100),
    LAST_NAME        VARCHAR2 (100) NOT NULL,
    MOBILE_NO        VARCHAR2 (100) UNIQUE,
    AGE              NUMBER CHECK (AGE >= 18),
    DEPARTMENT_ID    NUMBER REFERENCES DEPARTMENTS (DEPARTMENT_ID)
    
    
);

ALTER TABLE  CUSTOMER_INFO_2 ADD CONSTRAINT pk_emp_proj PRIMARY KEY (CUSTOMER_ID, MOBILE_NO);

-----Virtual Column----





