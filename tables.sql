-- Create Suppliers Table
CREATE TABLE Suppliers (
    SupplierID NUMBER PRIMARY KEY,
    Name VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE NOT NULL,
    Phone VARCHAR2(15),
    Address CLOB,
    JoinDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE NOT NULL,
    Phone VARCHAR2(15),
    Address CLOB,
    RegisterDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create Restaurants Table
CREATE TABLE Restaurants (
    RestaurantID NUMBER PRIMARY KEY,
    Name VARCHAR2(255) NOT NULL,
    Email VARCHAR2(255) UNIQUE NOT NULL,
    Phone VARCHAR2(15),
    Address CLOB,
    RegisterDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Products Table
-- Create Products Table
CREATE TABLE Products (
    ProductID NUMBER PRIMARY KEY,
    SupplierID NUMBER NULL,
    RestaurantID NUMBER NULL,
    Name VARCHAR2(255) NOT NULL,
    Description CLOB,
    Price NUMBER(10,2) NOT NULL,
    Stock NUMBER DEFAULT 0 NOT NULL,
    Category VARCHAR2(50) CHECK (Category IN ('Fruits', 'Vegetables', 'Dairy', 'Baked Goods', 'Crafts')),
    ImageURL VARCHAR2(500),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE,
    CONSTRAINT fk_product_restaurant FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID) ON DELETE CASCADE,
    CONSTRAINT chk_supplier_or_restaurant CHECK (
        (SupplierID IS NOT NULL AND RestaurantID IS NULL) OR
        (RestaurantID IS NOT NULL AND SupplierID IS NULL)
    )
);


-- Create Orders Table
CREATE TABLE Orders (
    OrderID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR2(50) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    TotalAmount NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_order_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);


-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID NUMBER PRIMARY KEY,
    OrderID NUMBER,
    ProductID NUMBER,
    Quantity NUMBER NOT NULL,
    Price NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_order_details_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    CONSTRAINT fk_order_details_product FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- Create Payments Table
CREATE TABLE Payments (
    PaymentID NUMBER PRIMARY KEY,
    OrderID NUMBER,
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Amount NUMBER(10,2) NOT NULL,
    PaymentMethod VARCHAR2(50) CHECK (PaymentMethod IN ('Credit Card', 'Debit Card', 'PayPal', 'Cash on Delivery')),
    Status VARCHAR2(50) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Completed', 'Failed')),
    CONSTRAINT fk_payment_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

-- Create Deliveries Table
CREATE TABLE Deliveries (
    DeliveryID NUMBER PRIMARY KEY,
    OrderID NUMBER,
    DeliveryAddress CLOB NOT NULL,
    DeliveryStatus VARCHAR2(50) DEFAULT 'Pending' CHECK (DeliveryStatus IN ('Pending', 'Out for Delivery', 'Delivered')),
    EstimatedDeliveryDate DATE,
    DeliveredDate DATE NULL,
    CONSTRAINT fk_delivery_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

-- Create Reviews Table
CREATE TABLE Reviews (
    ReviewID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    ProductID NUMBER,
    Rating NUMBER CHECK (Rating BETWEEN 1 AND 5),
    ReviewText CLOB,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE,
    CONSTRAINT fk_review_product FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);


-- Create Feedbacks Table
CREATE TABLE Feedbacks (
    FeedbackID NUMBER PRIMARY KEY,
    OrderID NUMBER UNIQUE,
    CustomerID NUMBER,
    FeedbackText CLOB NOT NULL,
    FeedbackDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_feedback_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);


