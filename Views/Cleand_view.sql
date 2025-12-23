USE supplychaindatabase;

-- =====================================================
-- DATA VALIDATION (PRE-CLEANING)
-- -----------------------------------------------------
-- Purpose:
-- 1. Understand dataset size & structure
-- 2. Identify redundant columns
-- 3. Validate date completeness & integrity
-- -----------------------------------------------------
-- Note:
-- No data is modified in this step
-- =====================================================

-- Dataset size
SELECT COUNT(*) AS total_rows
FROM supply_chain_data;

-- Table structure
DESCRIBE supply_chain_data;

-- Redundancy check: Benefit vs Order Profit
SELECT COUNT(*) AS mismatch_count
FROM supply_chain_data
WHERE Benefit_per_order <> Order_Profit_Per_Order;
-- Result: 0 (values are identical)

-- Redundancy check: Sales per Customer vs Order Item Total
SELECT COUNT(*) AS mismatch_count
FROM supply_chain_data
WHERE Sales_per_customer <> Order_Item_Total;
-- Result: 0 (values are identical)

-- Date completeness check
SELECT COUNT(*) AS null_date_count
FROM supply_chain_data
WHERE order_date IS NULL
   OR shipping_date IS NULL;
-- Result: 0 (no missing dates)

-- Future date validation
SELECT COUNT(*) AS future_date_count
FROM supply_chain_data
WHERE order_date > NOW()
   OR shipping_date > NOW();
-- Result: 0 (no future dates)

CREATE OR REPLACE VIEW v_clean_orders AS
SELECT
    -- =========================
    -- CORE ORDER IDENTIFIERS
    -- =========================
    Order_Id,
    Order_Item_Id,
    Order_Item_Product_Price,
    Order_Item_Quantity,
    Order_Item_Discount,
    Order_Item_Discount_Rate,
    Order_Item_Profit_Ratio,
    Order_Item_Total,

    -- =========================
    -- DATE NORMALIZATION
    -- =========================
    order_dt,
    shipping_dt,

    -- Date breakdowns
    MONTH(order_dt)   AS order_month,
    YEAR(order_dt)    AS order_year,
    MONTH(shipping_dt) AS shipping_month,
    YEAR(shipping_dt)  AS shipping_year,

    -- =========================
    -- SHIPPING & DELIVERY
    -- =========================
    Type,
    Shipping_Mode,
    Days_for_shipping_real,
    Days_for_shipment_scheduled,
    Delivery_Status,

    -- =========================
    -- FINANCIALS (NON-REDUNDANT)
    -- =========================
    Benefit_per_order,
    Sales,

    -- =========================
    -- CUSTOMER (CLEANED)
    -- =========================
    Customer_Id,
    CONCAT(TRIM(Customer_Fname), ' ', TRIM(Customer_Lname)) AS customer_full_name,
    Customer_Segment,
    Customer_City,
    Customer_State,
    Customer_Country,
    Customer_Street,
    Customer_Zipcode,

    -- =========================
    -- PRODUCT & CATEGORY
    -- =========================
    Product_Card_Id,
    Product_Name,
    Product_Price,
    Category_Id,
    Category_Name,
    Product_Category_Id,

    -- =========================
    -- ORGANIZATION / REGION
    -- =========================
    Department_Id,
    Department_Name,
    Market,
    Order_City,
    Order_State,
    Order_Country,
    Order_Region

FROM (
    SELECT
        *,
        -- Normalize Order Date
        CASE
            WHEN order_date LIKE '__-__-____ %'
                THEN STR_TO_DATE(order_date, '%d-%m-%Y %h.%i.%s %p')
            WHEN order_date LIKE '%/%/% %:%'
                THEN STR_TO_DATE(order_date, '%m/%d/%Y %H:%i')
            ELSE NULL
        END AS order_dt,

        -- Normalize Shipping Date
        CASE
            WHEN shipping_date LIKE '__-__-____ %'
                THEN STR_TO_DATE(shipping_date, '%d-%m-%Y %h.%i.%s %p')
            WHEN shipping_date LIKE '%/%/% %:%'
                THEN STR_TO_DATE(shipping_date, '%m/%d/%Y %H:%i')
            ELSE NULL
        END AS shipping_dt

    FROM supply_chain_data
) base;

-- Row count after cleaning
SELECT Count(*)  AS clean_view_row_count
FROM v_clean_orders;

-- Date integrity check:v_clean_orders
-- Shipping date should not be earlier than order date
SELECT COUNT(*) AS invalid_date_records
FROM v_clean_orders
WHERE shipping_dt < order_dt;




