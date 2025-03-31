CREATE SEQUENCE Products_seq START WITH 21 INCREMENT BY 1;

BEGIN
    -- Insert Sample Product 1
    INSERT INTO Products (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
    VALUES (Products_seq.NEXTVAL, 1, 1, 'Apple', 'Fresh Red Apples', 2.99, 100, 'Fruits', 'http://example.com/apple.jpg', CURRENT_TIMESTAMP);

    -- Insert Sample Product 2
    INSERT INTO Products (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
    VALUES (Products_seq.NEXTVAL, 2, 2, 'Milk', 'Organic Whole Milk', 1.49, 200, 'Dairy', 'http://example.com/milk.jpg', CURRENT_TIMESTAMP);

    -- Insert Sample Product 3
    INSERT INTO Products (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
    VALUES (Products_seq.NEXTVAL, 3, 3, 'Bread', 'Whole Wheat Bread', 3.59, 50, 'Baked Goods', 'http://example.com/bread.jpg', CURRENT_TIMESTAMP);

    -- Insert Sample Product 4
    INSERT INTO Products (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
    VALUES (Products_seq.NEXTVAL, 4, 4, 'Carrot', 'Fresh Carrots', 1.19, 150, 'Vegetables', 'http://example.com/carrot.jpg', CURRENT_TIMESTAMP);

    -- Insert Sample Product 5
    INSERT INTO Products (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
    VALUES (Products_seq.NEXTVAL, 5, 5, 'Handmade Vase', 'Handcrafted Ceramic Vase', 15.99, 20, 'Crafts', 'http://example.com/vase.jpg', CURRENT_TIMESTAMP);

    -- Commit the transaction
    COMMIT;
END;
/

BEGIN

  -- Insert Sample Product 1
    INSERT INTO Products (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
    VALUES (Products_seq.NEXTVAL, 1, 5, 'Burger', 'Hot Burgers', 2.99, 150, 'Baked Goods', 'http://example.com/apple.jpg', CURRENT_TIMESTAMP);


COMMIT;
END;
/



-------------------------------------------------------------

DECLARE
    v_product_id NUMBER := 3;  -- Declare a variable for ProductID
    v_new_price NUMBER := 5.99; -- Declare a variable for the new price
    v_new_stock NUMBER := 50;   -- Declare a variable for the new stock quantity
BEGIN
    -- Check condition before performing the update
    IF v_product_id IS NOT NULL THEN
        UPDATE Products
        SET 
            Price = v_new_price,   -- Update price
            Stock = v_new_stock    -- Update stock quantity
        WHERE 
            ProductID = v_product_id;  -- Use the declared variable for ProductID
        COMMIT;  -- Commit the transaction to make changes permanent
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid ProductID. Update not performed.');
    END IF;
END;
/

-------------------------------------------------------------------------

DECLARE
    v_product_id NUMBER := 25;  -- Declare a variable for ProductID
BEGIN
    -- Check condition before performing the delete
    IF v_product_id IS NOT NULL THEN
        DELETE FROM Products
        WHERE ProductID = v_product_id;  -- Use the declared variable for ProductID
        
        COMMIT;  -- Commit the transaction to make changes permanent
        DBMS_OUTPUT.PUT_LINE('Product with ProductID ' || v_product_id || ' has been deleted.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid ProductID. Deletion not performed.');
    END IF;
END;
/

-----------------------------------------------------------------------------------------

DECLARE
    v_category VARCHAR2(50);
    v_max_price NUMBER;
    v_min_price NUMBER;
    v_total_stock NUMBER;
    v_average_price NUMBER;
    v_product_count NUMBER;
BEGIN
    -- Loop over product categories (example with Fruits and Vegetables)
    FOR v_category IN (SELECT DISTINCT Category FROM Products) LOOP
        -- Find the maximum price for the current category
        SELECT MAX(Price) INTO v_max_price
        FROM Products
        WHERE Category = v_category.Category;

        -- Find the minimum price for the current category
        SELECT MIN(Price) INTO v_min_price
        FROM Products
        WHERE Category = v_category.Category;

        -- Find the total stock for the current category
        SELECT SUM(Stock) INTO v_total_stock
        FROM Products
        WHERE Category = v_category.Category;

        -- Find the average price for the current category
        SELECT AVG(Price) INTO v_average_price
        FROM Products
        WHERE Category = v_category.Category;

        -- Count the number of products in the current category
        SELECT COUNT(*) INTO v_product_count
        FROM Products
        WHERE Category = v_category.Category;

        -- Output the results
        DBMS_OUTPUT.PUT_LINE('Category: ' || v_category.Category);
        DBMS_OUTPUT.PUT_LINE('Max Price: ' || v_max_price);
        DBMS_OUTPUT.PUT_LINE('Min Price: ' || v_min_price);
        DBMS_OUTPUT.PUT_LINE('Total Stock: ' || v_total_stock);
        DBMS_OUTPUT.PUT_LINE('Average Price: ' || v_average_price);
        DBMS_OUTPUT.PUT_LINE('Product Count: ' || v_product_count);
        DBMS_OUTPUT.PUT_LINE('------------------------------');
    END LOOP;
END;
/

--------------------------------------------------------------------------------


DECLARE
    -- Declare variables for SupplierID and Product Count
    v_SupplierID Products.SupplierID%TYPE;
    v_ProductCount NUMBER;
BEGIN
    -- Loop through each supplier's product count and display the results
    FOR supplier_record IN
        (SELECT SupplierID, COUNT(ProductID) AS ProductCount
         FROM Products
         GROUP BY SupplierID
         HAVING COUNT(ProductID) > 3) 
    LOOP
        -- Assign values to variables
        v_SupplierID := supplier_record.SupplierID;
        v_ProductCount := supplier_record.ProductCount;
        
        -- Display the result using DBMS_OUTPUT
        DBMS_OUTPUT.PUT_LINE('SupplierID: ' || v_SupplierID || ', Product Count: ' || v_ProductCount);
    END LOOP;
END;
/


-----------------------------------------------------------------------------------------

DECLARE
    CURSOR supplier_cursor IS
        SELECT p.SupplierID, SUM(p.Stock) AS TotalStock
        FROM Products p
        WHERE p.SupplierID IN 
            (SELECT SupplierID 
             FROM Products 
             GROUP BY SupplierID
             HAVING SUM(Stock) > 100)
        GROUP BY p.SupplierID;
BEGIN
    FOR supplier IN supplier_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Supplier ID: ' || supplier.SupplierID || 
                             ', Total Stock: ' || supplier.TotalStock);
    END LOOP;
END;

-----------------------------------------------------------------------------

DECLARE
    v_avg_price NUMBER;
BEGIN
  
    -- Retrieve products whose price is greater than the average price
    FOR product IN (
        SELECT ProductID, Name, Price
        FROM Products
        WHERE Price > (SELECT AVG(Price) FROM Products)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product.ProductID || 
                             ', Name: ' || product.Name || 
                             ', Price: ' || product.Price);
    END LOOP;
END;

-------------------------------------------------------------

DECLARE
    v_category VARCHAR2(50) := 'Fruits';  -- Category to filter products
    v_price_limit NUMBER := 2.0;  -- Price limit for comparison
BEGIN
    -- Example of ANY: Check if any product in the 'Fruits' category has a price greater than 50
    DBMS_OUTPUT.PUT_LINE('--- Products with price > ANY of the products with price <= ' || v_price_limit || ' ---');
    FOR product IN (
        SELECT ProductID, Name, Price
        FROM Products
        WHERE Category = v_category
        AND Price > ANY (SELECT Price FROM Products WHERE Price <= v_price_limit)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product.ProductID || 
                             ', Name: ' || product.Name || 
                             ', Price: ' || product.Price);
    END LOOP;

    -- Separator Line
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------');

    -- Example of ALL: Check if all products in the 'Fruits' category have a price greater than 50
    DBMS_OUTPUT.PUT_LINE('--- Products with price > ALL of the products with price <= ' || v_price_limit || ' ---');
    FOR product IN (
        SELECT ProductID, Name, Price
        FROM Products
        WHERE Category = v_category
        AND Price > ALL (SELECT Price FROM Products WHERE Price <= v_price_limit)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product.ProductID || 
                             ', Name: ' || product.Name || 
                             ', Price: ' || product.Price);
    END LOOP;
END;

SELECT Price FROM Products WHERE Price <= 2.0

----------------------------------------------------------------------------------
CREATE TABLE Products_Update (
    ProductID NUMBER PRIMARY KEY,
    SupplierID NUMBER NOT NULL,
    RestaurantID NUMBER NOT NULL,
    Name VARCHAR2(255) NOT NULL,
    Description CLOB,
    Price NUMBER(10,2) NOT NULL,
    Stock NUMBER DEFAULT 0 NOT NULL,
    Category VARCHAR2(50) CHECK (Category IN ('Fruits', 'Vegetables', 'Dairy', 'Baked Goods', 'Crafts')),
    ImageURL VARCHAR2(500),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_supplier_update FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE,
    CONSTRAINT fk_product_restaurant_update FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID) ON DELETE CASCADE
);

-- Insert some updates and new entries into the Products_Update table with SupplierID and RestaurantID values between 1 and 5
INSERT INTO Products_Update (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
VALUES (1, 1, 2, 'Fresh Apples', 'Crisp and sweet red apples, perfect for snacks.', 2.70, 110, 'Fruits', 'https://example.com/images/apples_new.jpg', SYSTIMESTAMP);  -- Updated Price and Stock

INSERT INTO Products_Update (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
VALUES (21, 3, 1, 'Fresh Mangoes', 'Delicious and juicy mangoes from tropical regions.', 4.00, 150, 'Fruits', 'https://example.com/images/mangoes.jpg', SYSTIMESTAMP); -- New product

INSERT INTO Products_Update (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
VALUES (2, 2, 4, 'Organic Carrots', 'Farm-fresh organic carrots with a rich taste.', 2.00, 210, 'Vegetables', 'https://example.com/images/carrots_new.jpg', SYSTIMESTAMP); -- Updated Price and Stock

-- Add some entries with RestaurantID and SupplierID between 1 to 5
INSERT INTO Products_Update (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
VALUES (3, 4, 1, 'Italian Pasta', 'Authentic Italian pasta made with the finest ingredients.', 5.50, 100, 'Baked Goods', 'https://example.com/images/pasta.jpg', SYSTIMESTAMP); -- New product for Restaurant

INSERT INTO Products_Update (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
VALUES (4, 5, 2, 'Classic Cheese Pizza', 'Cheese pizza with a perfectly crisp crust and fresh toppings.', 8.00, 85, 'Baked Goods', 'https://example.com/images/pizza.jpg', SYSTIMESTAMP); -- New product for Restaurant

SELECT * FROM Products_Update;

INSERT INTO Products_Update (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
VALUES (1, 1, 2, 'Fresh Apples', 'Crisp and sweet red apples, perfect for snacks.', 2.70, 110, 'Fruits', 'https://example.com/images/apples_new.jpg', SYSTIMESTAMP);


SELECT * FROM RESTURANTS;

-- MERGE operation to update or insert data from Products_Update into Products
MERGE INTO Products_Update p_update
USING Products p
ON (p_update.ProductID = p.ProductID)
WHEN MATCHED THEN
    UPDATE SET 
        p_update.SupplierID = p.SupplierID,
        p_update.RestaurantID = p.RestaurantID,
        p_update.Name = p.Name,
        p_update.Description = p.Description,
        p_update.Price = p.Price,
        p_update.Stock = p.Stock,
        p_update.Category = p.Category,
        p_update.ImageURL = p.ImageURL,
        p_update.CreatedAt = p.CreatedAt
WHEN NOT MATCHED THEN
    INSERT (ProductID, SupplierID, RestaurantID, Name, Description, Price, Stock, Category, ImageURL, CreatedAt)
    VALUES (p.ProductID, p.SupplierID, p.RestaurantID, p.Name, p.Description, p.Price, p.Stock, p.Category, p.ImageURL, p.CreatedAt);

-- Check the final data in Products table
SELECT * FROM Products;

