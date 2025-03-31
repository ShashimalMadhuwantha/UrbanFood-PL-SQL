--Retrieve orders and their associated customers

SELECT o.OrderID, o.OrderDate, c.Name AS CustomerName, o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID;

--Retrieve all products and their suppliers (even products with no supplier)
SELECT p.ProductID, p.Name AS ProductName, s.Name AS SupplierName
FROM Products p
LEFT OUTER JOIN Suppliers s ON p.SupplierID = s.SupplierID;

--Retrieve all suppliers and the products they supply (even suppliers with no products)
SELECT s.SupplierID, s.Name AS SupplierName, p.Name AS ProductName
FROM Suppliers s
RIGHT OUTER JOIN Products p ON s.SupplierID = p.SupplierID;


--Retrieve all customers and their orders (even if a customer has no orders or an order has no associated customer)
SELECT c.Name AS CustomerName, o.OrderID, o.TotalAmount
FROM Customers c
FULL OUTER JOIN Orders o ON c.CustomerID = o.CustomerID;

---------------------------------------------------------------------------------------

select * from orders where OrderID=10;
UPDATE ORDERS SET status='Pending' where OrderID=10;


DECLARE
    v_order_id Orders.OrderID%TYPE;  -- Variable to hold OrderID
    v_status Orders.Status%TYPE;     -- Variable to hold Order Status
BEGIN
    -- Example: Set a specific order ID to check
    v_order_id := 10;

    -- Retrieve the status of the order
    SELECT Status
    INTO v_status
    FROM Orders
    WHERE OrderID = v_order_id;

    -- Conditional logic based on Order Status
    IF v_status = 'Pending' THEN
        -- Update order status to 'Processing'
        UPDATE Orders
        SET Status = 'Processing'
        WHERE OrderID = v_order_id;

        DBMS_OUTPUT.PUT_LINE('Order status changed to Processing.');
    
    ELSIF v_status = 'Processing' THEN
        -- Update order status to 'Shipped'
        UPDATE Orders
        SET Status = 'Shipped'
        WHERE OrderID = v_order_id;

        DBMS_OUTPUT.PUT_LINE('Order status changed to Shipped.');
    
    ELSIF v_status = 'Shipped' THEN
        -- Update order status to 'Delivered'
        UPDATE Orders
        SET Status = 'Delivered'
        WHERE OrderID = v_order_id;

        DBMS_OUTPUT.PUT_LINE('Order status changed to Delivered.');

    ELSE
        -- If the order is already Delivered or Cancelled, no update
        DBMS_OUTPUT.PUT_LINE('No further action required, order is either Delivered or Cancelled.');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Order not found with the provided OrderID.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
---------------------------------------------------------------------------

DECLARE
    CURSOR product_cursor IS
        SELECT ProductID, Name, Price, Category
        FROM Products;
    
    v_product_id Products.ProductID%TYPE;
    v_name Products.Name%TYPE;
    v_price Products.Price%TYPE;
    v_category Products.Category%TYPE;
BEGIN
    -- Open the cursor
    OPEN product_cursor;
    
    -- Start the loop
    LOOP
        -- Fetch a row from the cursor
        FETCH product_cursor INTO v_product_id, v_name, v_price, v_category;
        
        -- Exit the loop when no more rows are found
        EXIT WHEN product_cursor%NOTFOUND;
        
        -- Print the product details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id);
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
        DBMS_OUTPUT.PUT_LINE('Category: ' || v_category);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
    
    -- Close the cursor
    CLOSE product_cursor;

EXCEPTION
    WHEN OTHERS THEN
        -- Handle the error
        IF product_cursor%ISOPEN THEN
            CLOSE product_cursor;  -- Ensure cursor is closed on error
        END IF;
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

-------------------------------------------------------------------------


DECLARE
    CURSOR product_cursor IS
        SELECT ProductID, Name, Price, Category, Stock
        FROM Products;
    
    v_product_id Products.ProductID%TYPE;
    v_name Products.Name%TYPE;
    v_price Products.Price%TYPE;
    v_category Products.Category%TYPE;
    v_stock Products.Stock%TYPE;
    v_counter INTEGER := 0;
BEGIN
    -- Open the cursor
    OPEN product_cursor;
    
    -- Fetch the first row
    FETCH product_cursor INTO v_product_id, v_name, v_price, v_category, v_stock;
    
    -- While loop to process all rows
    WHILE product_cursor%FOUND LOOP
        -- Print product details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id);
        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
        DBMS_OUTPUT.PUT_LINE('Category: ' || v_category);
        DBMS_OUTPUT.PUT_LINE('Stock: ' || v_stock);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
        
        -- Fetch the next row
        FETCH product_cursor INTO v_product_id, v_name, v_price, v_category, v_stock;
    END LOOP;
    
    -- Close the cursor after processing
    CLOSE product_cursor;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Handle any exceptions and ensure cursor is closed
        IF product_cursor%ISOPEN THEN
            CLOSE product_cursor;
        END IF;
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

----------------------------------------------------------------

BEGIN
    -- FOR loop to iterate through each product
    FOR product_record IN (SELECT ProductID, Name, Price, Category, Stock FROM Products) LOOP
        -- Print product details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product_record.ProductID);
        DBMS_OUTPUT.PUT_LINE('Name: ' || product_record.Name);
        DBMS_OUTPUT.PUT_LINE('Price: ' || product_record.Price);
        DBMS_OUTPUT.PUT_LINE('Category: ' || product_record.Category);
        DBMS_OUTPUT.PUT_LINE('Stock: ' || product_record.Stock);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;
/

------------------------------------------------------------------------------

DECLARE
    CURSOR product_cursor IS
        SELECT ProductID, Name, Price, Category
        FROM Products;
    
    -- Declare variables to store the fetched product details
    v_product Products.ProductID%TYPE;
    v_name Products.Name%TYPE;
    v_price Products.Price%TYPE;
    v_category Products.Category%TYPE;
BEGIN
    -- Open the cursor
    OPEN product_cursor;
    
    -- Loop through the products
    LOOP
        -- Fetch the current product data into variables
        FETCH product_cursor INTO v_product, v_name, v_price, v_category;
        
        -- Exit the loop when no more products are found
        EXIT WHEN product_cursor%NOTFOUND;
        
        -- If the price is greater than 10, jump to the label
        IF v_price > 10 THEN
            GOTO expensive_product;
        END IF;
        
    END LOOP;
    
    -- If no expensive product was found, this part will be executed
    DBMS_OUTPUT.PUT_LINE('No product with a price greater than 10 found.');
    
    -- Label for expensive products
    <<expensive_product>>
    DBMS_OUTPUT.PUT_LINE('Expensive product found: ' || v_name || ' with price: ' || v_price);
    
    -- Close the cursor
    CLOSE product_cursor;
END;
/


