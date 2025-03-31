DECLARE
    v_order_id NUMBER;
    v_customer_id NUMBER;
    v_order_date VARCHAR2(20);     -- Store the date as a string (converted from DATE)
    v_total_amount VARCHAR2(20);   -- Store the amount as a string (converted from NUMBER)
    v_status VARCHAR2(50);
    v_order_timestamp TIMESTAMP;   -- Store the timestamp (converted from DATE)
BEGIN
    FOR order_record IN (
        SELECT OrderID, CustomerID, OrderDate, TotalAmount, Status
        FROM Orders
    ) LOOP
        -- Convert OrderDate to string using TO_CHAR (Date to String)
        v_order_date := TO_CHAR(order_record.OrderDate, 'DD-MON-YYYY');
        
        -- Convert TotalAmount to string with formatting using TO_CHAR (Number to String)
        v_total_amount := TO_CHAR(order_record.TotalAmount, '9999.99');
        
        -- Convert Status (using TO_CHAR for string values)
        v_status := TO_CHAR(order_record.Status);

        -- Convert OrderDate to Timestamp using TO_TIMESTAMP (Date to Timestamp)
        v_order_timestamp := TO_TIMESTAMP(TO_CHAR(order_record.OrderDate, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');
        
        -- Output the converted values
        DBMS_OUTPUT.PUT_LINE('Order ID: ' || order_record.OrderID || 
                             ', Customer ID: ' || order_record.CustomerID || 
                             ', Order Date: ' || v_order_date || 
                             ', Total Amount: ' || v_total_amount || 
                             ', Status: ' || v_status || 
                             ', Order Timestamp: ' || TO_CHAR(v_order_timestamp, 'DD-MON-YYYY HH24:MI:SS'));
    END LOOP;

    -- Exception handling
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No orders found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-----------------------------------------------------------------------------
DECLARE
    v_order_id NUMBER := 1;                  -- Example OrderID
    v_total_quantity NUMBER := 0;             -- Variable to store total quantity of products ordered
    v_total_price NUMBER(10,2) := 0;          -- Variable to store total price of products ordered
    CURSOR v_order_details IS                -- Cursor to get Order Details for a particular OrderID
        SELECT p.Name, od.Quantity, od.Price
        FROM OrderDetails od
        JOIN Products p ON od.ProductID = p.ProductID
        WHERE od.OrderID = v_order_id;
BEGIN
    -- Loop through the OrderDetails for the given OrderID
    FOR r IN v_order_details LOOP
        v_total_quantity := v_total_quantity + r.Quantity;
        v_total_price := v_total_price + (r.Quantity * r.Price);
    END LOOP;

    -- Implicit conversion: Convert the numeric total price to VARCHAR2 for concatenation with a string
    DBMS_OUTPUT.PUT_LINE('Total quantity for OrderID ' || v_order_id || ' is: ' || v_total_quantity);
    DBMS_OUTPUT.PUT_LINE('Total price for OrderID ' || v_order_id || ' is: ' || TO_CHAR(v_total_price, '9999.99'));

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order found with OrderID ' || v_order_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

------------------------------------------------------------------------------
DECLARE
    v_product_price VARCHAR2(10) := '1.5';  -- VARCHAR2 value for implicit conversion to NUMBER
    v_total_amount NUMBER(10,2);
    v_product_name VARCHAR2(255);
BEGIN
    -- Cursor to select product name and price where price is greater than v_product_price
    FOR product IN (SELECT Name, Price FROM Products WHERE Price > v_product_price) LOOP
        -- Implicit conversion from VARCHAR2 to NUMBER is handled by Oracle
        v_total_amount := product.Price;
        v_product_name := product.Name;
        
        -- Output each product name and price found
        DBMS_OUTPUT.PUT_LINE('Product Name: ' || v_product_name || ', Price: ' || v_total_amount);
    END LOOP;

    -- If no rows are found, display a message
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No products found with price greater than ' || v_product_price);
    END IF;
END;
/

----------------------------------------------------------------------------------

DECLARE
    v_order_id NUMBER := 1;                  -- Example OrderID
    v_total_quantity NUMBER := 0;             -- Variable to store total quantity of products ordered
    v_total_price NUMBER(10,2) := 0;          -- Variable to store total price of products ordered
    CURSOR v_order_details IS                -- Cursor to get Order Details for a particular OrderID
        SELECT p.Name, od.Quantity, od.Price
        FROM OrderDetails od
        JOIN Products p ON od.ProductID = p.ProductID
        WHERE od.OrderID = v_order_id;
BEGIN
    -- Loop through the OrderDetails for the given OrderID
    FOR r IN v_order_details LOOP
        v_total_quantity := v_total_quantity + r.Quantity;
        v_total_price := v_total_price + (r.Quantity * r.Price);
    END LOOP;

    -- Implicit conversion: Convert the numeric total price to VARCHAR2 for concatenation with a string
    DBMS_OUTPUT.PUT_LINE('Total quantity for OrderID ' || v_order_id || ' is: ' || v_total_quantity);
    DBMS_OUTPUT.PUT_LINE('Total price for OrderID ' || v_order_id || ' is: ' || TO_CHAR(v_total_price, '9999.99'));

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No order found with OrderID ' || v_order_id);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

