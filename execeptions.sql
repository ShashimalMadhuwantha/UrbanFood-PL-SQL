DECLARE
    -- Declare a variable to store the product price
    v_price Products.Price%TYPE;
    
    -- Declare a variable to store the category of the product
    v_category VARCHAR2(50) := 'Fruitsnew';
    
    -- Declare a cursor to fetch product prices for the specified category
    CURSOR product_cursor IS
        SELECT Price
        FROM Products
        WHERE Category = v_category;
BEGIN
    -- Try to fetch the price of the first product in the 'Fruits' category
    OPEN product_cursor;
    FETCH product_cursor INTO v_price;
    
    -- Handle the case when no data is found
    IF product_cursor%NOTFOUND THEN
        RAISE NO_DATA_FOUND;
    END IF;
    
    -- Process the data (e.g., display product price)
    DBMS_OUTPUT.PUT_LINE('Product Price: ' || v_price);
    
    -- Close the cursor
    CLOSE product_cursor;

EXCEPTION
    -- Handle NO_DATA_FOUND exception
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No products found in the ' || v_category || ' category.');

    -- Handle TOO_MANY_ROWS exception (if the cursor returns more than one row)
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple products found in the ' || v_category || ' category. Please refine your query.');

    -- Handle generic exceptions
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/
----------------------------

DECLARE
    v_price Products.Price%TYPE;
BEGIN
    -- This will raise TOO_MANY_ROWS if there are multiple rows returned
    SELECT Price
    INTO v_price
    FROM Products
    WHERE Category = 'Fruits'; -- Multiple rows returned for the 'Fruits' category

    DBMS_OUTPUT.PUT_LINE('Product Price: ' || v_price);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('More than one row returned.');
END;

-----------------------------------------------------------

-- Non predefined exeception
DECLARE
    -- Declare custom exception for foreign key violation
    fk_violation EXCEPTION;
    
    -- Associate the custom exception with Oracle error code for foreign key violation
    PRAGMA EXCEPTION_INIT(fk_violation, -2291); -- ORA-02291: integrity constraint (constraint name) violated - parent key not found
    
    -- Declare variables to insert a new product
    v_productID NUMBER := 101;
    v_supplierID NUMBER := 999; -- Example of invalid SupplierID
    v_name VARCHAR2(255) := 'Apple';
    v_description CLOB := 'Fresh apples from the farm';
    v_price NUMBER := 2.99;
    v_stock NUMBER := 50;
    v_category VARCHAR2(50) := 'Fruits';
    v_imageURL VARCHAR2(500) := 'http://example.com/apple.jpg';
BEGIN
    -- Attempt to insert a new product
    BEGIN
        INSERT INTO Products (ProductID, SupplierID, Name, Description, Price, Stock, Category, ImageURL)
        VALUES (v_productID, v_supplierID, v_name, v_description, v_price, v_stock, v_category, v_imageURL);
    EXCEPTION
        WHEN fk_violation THEN
            DBMS_OUTPUT.PUT_LINE('Error: The SupplierID does not exist in the Suppliers table.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
    END;
END;

------------------------------------------------------------
DECLARE
    -- Declare a user-defined exception
    price_too_low EXCEPTION;

    -- Declare a variable for the product price
    v_productID NUMBER := 101;
    v_supplierID NUMBER := 10;
    v_name VARCHAR2(255) := 'Apple';
    v_description CLOB := 'Fresh apples from the farm';
    v_price NUMBER := -5.99; -- Invalid price (negative value)
    v_stock NUMBER := 50;
    v_category VARCHAR2(50) := 'Fruits';
    v_imageURL VARCHAR2(500) := 'http://example.com/apple.jpg';
BEGIN
    -- Check if the price is less than or equal to zero
    IF v_price <= 0 THEN
        -- Raise the user-defined exception if the price is invalid
        RAISE price_too_low;
    END IF;

    -- Insert data into the Products table if the price is valid
    INSERT INTO Products (ProductID, SupplierID, Name, Description, Price, Stock, Category, ImageURL)
    VALUES (v_productID, v_supplierID, v_name, v_description, v_price, v_stock, v_category, v_imageURL);

    DBMS_OUTPUT.PUT_LINE('Product added successfully!');

EXCEPTION
    -- Handle the user-defined exception
    WHEN price_too_low THEN
        DBMS_OUTPUT.PUT_LINE('Error: The product price cannot be zero or negative.');
    
    -- Handle any other unforeseen exceptions
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;

-------------------------------------------------------------------


