DECLARE
    -- Declare the cursor to select product details from the Products table
    CURSOR product_cursor IS
        SELECT ProductID, Name, Price, Category
        FROM Products where ProductID=3;
    
    -- Declare variables to store the fetched values
    v_productID Products.ProductID%TYPE;
    v_name Products.Name%TYPE;
    v_price Products.Price%TYPE;
    v_category Products.Category%TYPE;
BEGIN
    -- Open the cursor
    OPEN product_cursor;
    
    -- Fetch the first record into variables
    FETCH product_cursor INTO v_productID, v_name, v_price, v_category;
    
    -- Check if the fetch was successful
    IF product_cursor%FOUND THEN
        -- Output the fetched product details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_productID);
        DBMS_OUTPUT.PUT_LINE('Product Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Product Price: ' || v_price);
        DBMS_OUTPUT.PUT_LINE('Product Category: ' || v_category);
    ELSE
        -- If no rows are found
        DBMS_OUTPUT.PUT_LINE('No products found.');
    END IF;
    
    -- Close the cursor
    CLOSE product_cursor;
END;
/

-------------------------------------------------------------------------------

DECLARE
    -- Declare the cursor to select product details from the Products table
    CURSOR product_cursor IS
        SELECT ProductID, Name, Price, Category
        FROM Products;
    
    -- Declare variables to store the fetched values
    v_productID Products.ProductID%TYPE;
    v_name Products.Name%TYPE;
    v_price Products.Price%TYPE;
    v_category Products.Category%TYPE;
BEGIN
    -- Open the cursor
    OPEN product_cursor;
    
    -- Loop through each row in the cursor
    LOOP
        -- Fetch the next record into variables
        FETCH product_cursor INTO v_productID, v_name, v_price, v_category;
        
        -- Exit the loop if no more rows are found
        EXIT WHEN product_cursor%NOTFOUND;
        
        -- Output the fetched product details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_productID);
        DBMS_OUTPUT.PUT_LINE('Product Name: ' || v_name);
        DBMS_OUTPUT.PUT_LINE('Product Price: ' || v_price);
        DBMS_OUTPUT.PUT_LINE('Product Category: ' || v_category);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
    
    -- Close the cursor
    CLOSE product_cursor;
END;
/

--------------------------------------------------------------------------

-- parameterized cursor to retrieve total for each category
DECLARE
    -- Define a cursor with an IN parameter
    CURSOR product_cursor(p_category IN VARCHAR2) IS
        SELECT Price
        FROM Products
        WHERE Category = p_category;

    -- Declare a variable to hold the total price sum
    v_total_price NUMBER := 0;

    -- Declare a variable to store fetched product price
    v_price Products.Price%TYPE;
BEGIN
    -- Open the cursor with a specific category
    OPEN product_cursor('Fruits');  -- You can change 'Fruits' to any category

    -- Loop through the cursor and accumulate the total price
    LOOP
        -- Fetch the price of each product into v_price
        FETCH product_cursor INTO v_price;
        
        -- Exit the loop when no more rows are found
        EXIT WHEN product_cursor%NOTFOUND;

        -- Accumulate the total price
        v_total_price := v_total_price + v_price;
    END LOOP;

    -- Output the total price of all products in the given category
    DBMS_OUTPUT.PUT_LINE('Total price of products in category "Fruits": ' || v_total_price);

    -- Close the cursor
    CLOSE product_cursor;
END;
/

---------------------------------------------------------------------------------------

DECLARE
    -- Define a cursor to fetch product details
    CURSOR product_cursor IS
        SELECT ProductID, Price
        FROM Products
        WHERE Category = 'Fruits' FOR UPDATE; -- You can change the category as needed

    -- Variables to hold fetched data
    v_product_id Products.ProductID%TYPE;
    v_price Products.Price%TYPE;
BEGIN
    -- Open the cursor
    OPEN product_cursor;

    -- Loop through the cursor to process each product
    LOOP
        -- Fetch the product details into variables
        FETCH product_cursor INTO v_product_id, v_price;

        -- Exit the loop when no more rows are found
        EXIT WHEN product_cursor%NOTFOUND;

        -- Update the price of the current product (example: increasing by 10%)
        v_price := v_price * 1.10;  -- Increase price by 10%

        -- Update the row where the cursor is currently positioned
        UPDATE Products
        SET Price = v_price
        WHERE CURRENT OF product_cursor;  -- Use WHERE CURRENT OF to update the current row

    END LOOP;

    -- Close the cursor
    CLOSE product_cursor;

    -- Output completion message
    DBMS_OUTPUT.PUT_LINE('Product prices updated successfully.');
END;
/

------------------------------------------------------------------

DECLARE
    -- Define a cursor with a subquery to fetch products with price higher than the average price for a category
    CURSOR product_cursor IS
        SELECT ProductID, Name, Price
        FROM Products
        WHERE Price > (
            SELECT AVG(Price)
            FROM Products
            WHERE Category = 'Fruits'
        )
        AND Category = 'Fruits';

    -- Variables to hold the fetched product details
    v_product_id Products.ProductID%TYPE;
    v_name Products.Name%TYPE;
    v_price Products.Price%TYPE;
BEGIN
    -- Open the cursor
    OPEN product_cursor;

    -- Loop through the cursor to fetch each product
    LOOP
        -- Fetch the product details into variables
        FETCH product_cursor INTO v_product_id, v_name, v_price;

        -- Exit the loop when no more rows are found
        EXIT WHEN product_cursor%NOTFOUND;

        -- Output the product details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || v_product_id || 
                             ', Name: ' || v_name || 
                             ', Price: ' || v_price);
    END LOOP;

    -- Close the cursor
    CLOSE product_cursor;
END;
/

