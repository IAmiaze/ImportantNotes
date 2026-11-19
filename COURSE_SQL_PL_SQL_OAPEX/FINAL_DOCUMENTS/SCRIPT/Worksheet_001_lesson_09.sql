/* Formatted on 10/4/2026 10:29:54 PM (QP5 v5.435) */
SELECT last_name,
       department_id,
       salary,
       SUM (salary) OVER (PARTITION BY department_id)     AS dept_total
  FROM employees;


  SELECT DISTINCT
         ORDER_DATE,                                               --ORDER_ID,
         --ORDER_DATE,
         --TOTAL_AMOUNT,
         SUM (TOTAL_AMOUNT)
             OVER (PARTITION BY ORDER_DATE ORDER BY ORDER_DATE DESC)    AS day_total
    FROM (  SELECT O.ORDER_ID,
                   TRUNC (ORDER_TMS)                 ORDER_DATE,
                   FULL_NAME,
                   COUNT (LINE_ITEM_ID)              TOTAL_ITEM,
                   SUM (QUANTITY)                    TOTAL_QUANTITY,
                   SUM ((UNIT_PRICE * QUANTITY))     TOTAL_AMOUNT
              FROM ORDERS O
                   JOIN CUSTOMERS C ON (O.CUSTOMER_ID = C.CUSTOMER_ID)
                   JOIN ORDER_ITEMS OI ON (O.ORDER_ID = OI.ORDER_ID)
          --WHERE O.ORDER_ID = 792
          GROUP BY O.ORDER_ID, TRUNC (ORDER_TMS), FULL_NAME)
ORDER BY ORDER_DATE DESC;


SELECT txn_month,
       amount,
       amount - LAG (amount) OVER (ORDER BY txn_month)    AS change_from_prior_month
  FROM monthly_totals;

  WITH monthly_sales AS (
    SELECT 
        TRUNC(O.ORDER_TMS, 'MM')                          AS MONTH_START_DATE,
        COUNT(OI.LINE_ITEM_ID)                            AS TOTAL_ITEM,
        SUM(OI.QUANTITY)                                  AS TOTAL_QUANTITY,
        SUM(OI.UNIT_PRICE * OI.QUANTITY)                  AS TOTAL_AMOUNT
    FROM ORDERS O
    JOIN CUSTOMERS C   ON O.CUSTOMER_ID = C.CUSTOMER_ID
    JOIN ORDER_ITEMS OI ON O.ORDER_ID = OI.ORDER_ID
    GROUP BY TRUNC(O.ORDER_TMS, 'MM')
)
SELECT 
    TO_CHAR(MONTH_START_DATE, 'MONTH YYYY')               AS ORDER_MONTH,
    TOTAL_AMOUNT                                         AS CURRENT_MONTH_TOTAL,
    LAG(TOTAL_AMOUNT) OVER (ORDER BY MONTH_START_DATE)  AS LAG_AMOUNT,
    LEAD(TOTAL_AMOUNT) OVER (ORDER BY MONTH_START_DATE) AS LEAD_AMOUNT,
    TOTAL_AMOUNT - LAG(TOTAL_AMOUNT) OVER (ORDER BY MONTH_START_DATE) AS CHANGE_FROM_PRIOR_MONTH
FROM monthly_sales
ORDER BY MONTH_START_DATE ASC;


---Table create
CREATE TABLE daily_branch_sales (
    trx_id       NUMBER PRIMARY KEY,
    branch_id    NUMBER NOT NULL,
    trx_date     DATE NOT NULL,
    sales_amount NUMBER(10,2) NOT NULL
);

--insert sample Data

INSERT INTO daily_branch_sales VALUES (1, 101, TO_DATE('2026-10-01', 'YYYY-MM-DD'), 1000.00);
INSERT INTO daily_branch_sales VALUES (2, 101, TO_DATE('2026-10-02', 'YYYY-MM-DD'), 1500.00);
INSERT INTO daily_branch_sales VALUES (3, 101, TO_DATE('2026-10-03', 'YYYY-MM-DD'), 2000.00);
INSERT INTO daily_branch_sales VALUES (4, 101, TO_DATE('2026-10-04', 'YYYY-MM-DD'), 1200.00);
INSERT INTO daily_branch_sales VALUES (5, 101, TO_DATE('2026-10-05', 'YYYY-MM-DD'), 1800.00);
INSERT INTO daily_branch_sales VALUES (6, 101, TO_DATE('2026-10-06', 'YYYY-MM-DD'), 2500.00);

-- Branch Data
INSERT INTO daily_branch_sales VALUES (7, 102, TO_DATE('2026-10-01', 'YYYY-MM-DD'), 3000.00);
INSERT INTO daily_branch_sales VALUES (8, 102, TO_DATE('2026-10-02', 'YYYY-MM-DD'), 3500.00);
INSERT INTO daily_branch_sales VALUES (9, 102, TO_DATE('2026-10-03', 'YYYY-MM-DD'), 4000.00);

COMMIT;

SELECT 
    trx_id,
    branch_id,
    trx_date,
    sales_amount,
    
    --Running Total
    SUM(sales_amount) OVER (
        PARTITION BY branch_id 
        ORDER BY trx_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,

    -- 3-Day Trailing Moving Average
	
    ROUND(AVG(sales_amount) OVER (
        PARTITION BY branch_id 
        ORDER BY trx_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3day,

    -- Centered Moving Average
	
    ROUND(AVG(sales_amount) OVER (
        PARTITION BY branch_id 
        ORDER BY trx_date 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ), 2) AS centered_avg_3day,

    --Window Count
    COUNT(*) OVER (
        PARTITION BY branch_id 
        ORDER BY trx_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_trx_count

FROM daily_branch_sales
ORDER BY branch_id, trx_date;