USE supplychaindatabase;

-- =====================================================
-- DIMENSION VIEW: Customer
-- =====================================================
CREATE OR REPLACE VIEW v_dim_customer AS
SELECT
    Customer_Id AS customer_id,
    customer_full_name,
    Customer_Segment AS customer_segment,
    Customer_City AS customer_city,
    Customer_State AS customer_state,
    Customer_Country AS customer_country,
    Customer_Street AS customer_street,
    Customer_Zipcode AS customer_zipcode
FROM v_clean_orders
GROUP BY Customer_Id, customer_full_name, customer_segment,
         customer_city, customer_state, customer_country,
         customer_street, customer_zipcode;


-- =====================================================
-- DIMENSION VIEW: Product
-- =====================================================
CREATE OR REPLACE VIEW v_dim_product AS
SELECT
    Product_Card_Id AS product_id,
    Product_Name AS product_name,
    Product_Price AS product_price,
    Category_Id AS category_id,
    Category_Name AS category_name,
    Product_Category_Id AS product_category_id,
    Department_Id AS department_id,
    Department_Name AS department_name
FROM v_clean_orders
GROUP BY Product_Card_Id, Product_Name, Product_Price,
         Category_Id, Category_Name, Product_Category_Id,
         Department_Id, Department_Name;


-- =====================================================
-- DIMENSION VIEW: Shipping / Region
-- =====================================================
CREATE OR REPLACE VIEW v_dim_shipping AS
SELECT
    Order_Id AS order_id,
    Shipping_Mode AS shipping_mode,
    Market AS market,
    Order_City AS order_city,
    Order_State AS order_state,
    Order_Country AS order_country,
    Order_Region AS order_region
FROM v_clean_orders
GROUP BY Order_Id, Shipping_Mode, Market,
         Order_City, Order_State, Order_Country, Order_Region;


-- =====================================================
-- DIMENSION VIEW: Date
-- =====================================================
CREATE OR REPLACE VIEW v_dim_date AS
-- Order Dates
SELECT
    DATE(order_dt) AS date_id,
    DATE(order_dt) AS date_actual,
    DAY(order_dt) AS day,
    MONTH(order_dt) AS month,
    DATE_FORMAT(order_dt, '%M') AS month_name,
    QUARTER(order_dt) AS quarter,
    YEAR(order_dt) AS year,
    DATE_FORMAT(order_dt, '%W') AS weekday
FROM v_clean_orders

UNION

-- Shipping Dates
SELECT
    DATE(shipping_dt) AS date_id,
    DATE(shipping_dt) AS date_actual,
    DAY(shipping_dt) AS day,
    MONTH(shipping_dt) AS month,
    DATE_FORMAT(shipping_dt, '%M') AS month_name,
    QUARTER(shipping_dt) AS quarter,
    YEAR(shipping_dt) AS year,
    DATE_FORMAT(shipping_dt, '%W') AS weekday
FROM v_clean_orders;
