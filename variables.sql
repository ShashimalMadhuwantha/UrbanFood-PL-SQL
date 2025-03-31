SET SERVEROUTPUT ON;

--ANonymous block retrevinf data to variables
DECLARE
    v_product_name Products.Name%TYPE;
    v_product_price Products.Price%TYPE;
BEGIN
    -- Retrieving data from Products table into variables
    SELECT Name, Price
    INTO v_product_name, v_product_price
    FROM Products
    WHERE ProductID = 1;

    -- Displaying the values
    DBMS_OUTPUT.PUT_LINE('Product Name: ' || v_product_name);
    DBMS_OUTPUT.PUT_LINE('Product Price: ' || v_product_price);
END;
/

-------------------------------------------------------------------------------------
-- Declare bind variables
VARIABLE g_product_id NUMBER;
VARIABLE g_product_name VARCHAR2(255);

-- Begin block to assign values to bind variables
BEGIN
    :g_product_id := 10;  -- Example ProductID to search for
    SELECT Name INTO :g_product_name
    FROM Products
    WHERE ProductID = :g_product_id;
END;
/

-- Print the result
PRINT g_product_name;

----------------------------------------------------------------------------

-- retrive multiple rows 

DECLARE
    -- Declare local variables
    v_supplier_id NUMBER;
    v_supplier_name VARCHAR2(255);
BEGIN
    -- Begin block to fetch multiple suppliers
    FOR supplier_record IN (SELECT SupplierID, Name FROM Suppliers) LOOP
        -- Assign values to local variables
        v_supplier_id := supplier_record.SupplierID;
        v_supplier_name := supplier_record.Name;

        -- Print each supplier's details
        DBMS_OUTPUT.PUT_LINE('Supplier ID: ' || v_supplier_id || ', Supplier Name: ' || v_supplier_name);
    END LOOP;

    -- Exception handling
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No suppliers found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

