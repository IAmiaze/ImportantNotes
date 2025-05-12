PL-SQL Tips :

SAVEPOINT in PL-SQL :

In simple word SAVEPOINT is like a Marker or Book mark of your pl-sql Transaction.Mostly use for dependent Transactions.

here is in Example below :

DECLARE
    insufficient_stock EXCEPTION;
    v_error_message VARCHAR2(4000);
BEGIN
    -- Step 1: Insert a new product
    INSERT INTO stock_products (product_id, product_name, stock)
    VALUES (1001, 'Advanced Widget', 50);

    -- Savepoint after inserting the product
    SAVEPOINT after_product_insert;

    -- Step 2: Update the stock
    UPDATE products
    SET stock = stock - 10
    WHERE product_id = 1001;

    -- Check if stock goes negative
    IF (SELECT stock FROM stock_products WHERE product_id = 1001) < 0 THEN
        RAISE insufficient_stock;
    END IF;

    -- Savepoint after updating the stock
    SAVEPOINT after_stock_update;

    -- Step 3: Log the inventory change
    INSERT INTO inventory_log (product_id, change_description)
    VALUES (1001, 'Stock decreased by 10');

    -- Savepoint after logging the inventory change
    SAVEPOINT after_logging;

    -- Simulate an error during logging by manually raising an exception
    RAISE_APPLICATION_ERROR(-20001, 'Simulated logging error');

EXCEPTION
    WHEN insufficient_stock THEN
        v_error_message := 'Error: Insufficient stock.';
        DBMS_OUTPUT.PUT_LINE(v_error_message);
        -- Rollback to the state before the stock update
        ROLLBACK TO after_product_insert;
        
    WHEN OTHERS THEN
        v_error_message := 'General Error: ' || SQLERRM;
        DBMS_OUTPUT.PUT_LINE(v_error_message);
        -- Rollback to the state before the initial product insertion
        ROLLBACK TO after_product_insert;
END;

