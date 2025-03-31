-- Create Procedure to retrieve products by category
CREATE OR REPLACE PROCEDURE GetProductsByCategory (
    p_category IN VARCHAR2
) IS
BEGIN
    -- Query to retrieve products by category
    FOR product IN (SELECT ProductID, Name, Price, Stock, Category FROM Products WHERE Category = p_category) LOOP
        -- Display each product's details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product.ProductID);
        DBMS_OUTPUT.PUT_LINE('Product Name: ' || product.Name);
        DBMS_OUTPUT.PUT_LINE('Price: ' || product.Price);
        DBMS_OUTPUT.PUT_LINE('Stock: ' || product.Stock);
        DBMS_OUTPUT.PUT_LINE('Category: ' || product.Category);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
END;
/
-- Call the procedure to get products from 'Fruits' category
BEGIN
    GetProductsByCategory('Fruits');
END;
/
--------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE GetAllProducts IS
BEGIN
    -- Query to retrieve all products
    FOR product IN (SELECT ProductID, Name, Price, Stock, Category FROM Products) LOOP
        -- Display each product's details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product.ProductID);
        DBMS_OUTPUT.PUT_LINE('Product Name: ' || product.Name);
        DBMS_OUTPUT.PUT_LINE('Price: ' || product.Price);
        DBMS_OUTPUT.PUT_LINE('Stock: ' || product.Stock);
        DBMS_OUTPUT.PUT_LINE('Category: ' || product.Category);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
END;
/

BEGIN
    GetAllProducts;
END;
/

-----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE GetProductsByCategoryWithStock (
    p_category IN VARCHAR2,          -- IN parameter: Category of the products
    p_total_stock OUT NUMBER         -- OUT parameter: Total stock of products in the category
) IS
BEGIN
    -- Initialize the total stock to 0
    p_total_stock := 0;
    
    -- Loop through the products matching the category
    FOR product IN (SELECT ProductID, Name, Stock FROM Products WHERE Category = p_category) LOOP
        -- Add the stock of each product to the total stock
        p_total_stock := p_total_stock + product.Stock;

        -- Display each product's details
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product.ProductID);
        DBMS_OUTPUT.PUT_LINE('Product Name: ' || product.Name);
        DBMS_OUTPUT.PUT_LINE('Stock: ' || product.Stock);
        DBMS_OUTPUT.PUT_LINE('-------------------------');
    END LOOP;
    
    -- Display the total stock
    DBMS_OUTPUT.PUT_LINE('Total Stock in Category "' || p_category || '" : ' || p_total_stock);
END;
/


DECLARE
    v_total_stock NUMBER;  -- Variable to store the output of the procedure
BEGIN
    -- Call the procedure and pass the category "Fruits" as the input
    GetProductsByCategoryWithStock('Fruits', v_total_stock);

    -- Display the total stock outside the procedure
    DBMS_OUTPUT.PUT_LINE('Total Stock for Fruits: ' || v_total_stock);
END;
/
--------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION GetTotalStock (p_product_id IN NUMBER) 
RETURN NUMBER IS
    v_total_stock NUMBER;
BEGIN
    SELECT Stock INTO v_total_stock
    FROM Products
    WHERE ProductID = p_product_id;
    
    RETURN v_total_stock;
END;
/

DECLARE
    v_stock NUMBER;
BEGIN
    v_stock := GetTotalStock(1); -- Get total stock for product with ProductID = 1
    DBMS_OUTPUT.PUT_LINE('Total stock for Product 1: ' || v_stock);
END;
/

----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION GetNumberOfCustomers 
RETURN NUMBER IS
    v_customer_count NUMBER;
BEGIN
    -- Count the number of customers in the Customers table
    SELECT COUNT(*) INTO v_customer_count
    FROM Customers;
    
    -- Return the number of customers
    RETURN v_customer_count;
END;
/

DECLARE
    v_num_customers NUMBER;
BEGIN
    v_num_customers := GetNumberOfCustomers; -- Get the number of customers
    DBMS_OUTPUT.PUT_LINE('Total number of customers: ' || v_num_customers);
END;
/

