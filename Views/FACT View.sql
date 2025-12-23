use supplychaindatabase;
-- =====================================================
-- FACT VIEW: v_order_delivery_flags
-- -----------------------------------------------------
-- Grain  : Order Item
-- Purpose:
--   - Central fact table
--   - Contains only keys, metrics, and flags
--   - No descriptive attributes (handled by dimensions)
-- =====================================================

CREATE OR REPLACE VIEW v_order_delivery_flags AS
SELECT
    -- =========================
    -- KEYS
    -- =========================
    Order_Id,
    Customer_Id,
    Product_Card_Id AS product_id,

    -- =========================
    -- DATES
    -- =========================
    Date(order_dt) as order_dt,
    Date(shipping_dt) as shipping_dt,

    -- =========================
    -- METRICS
    -- =========================
    Order_Item_Quantity,
    Order_Item_Product_Price,
    Order_Item_Discount,
    Order_Item_Discount_Rate,
    Order_Item_Total,
    Sales,
    Benefit_per_order AS profit_per_order,

    -- =========================
    -- FLAGS / ANOMALIES
    -- =========================
    CASE 
        WHEN LOWER(Delivery_Status) = 'shipping canceled' THEN 1
        ELSE 0
    END AS is_shipping_cancelled,

    CASE 
        WHEN shipping_dt > order_dt + INTERVAL Days_for_shipment_scheduled DAY THEN 1
        ELSE 0
    END AS is_late_delivery,

    CASE 
        WHEN shipping_dt > order_dt + INTERVAL Days_for_shipment_scheduled DAY
        THEN DATEDIFF(
                shipping_dt,
                order_dt + INTERVAL Days_for_shipment_scheduled DAY
             )
        ELSE 0
    END AS late_days,

    CASE 
        WHEN Benefit_per_order < 0 THEN 1
        ELSE 0
    END AS is_loss_order

FROM v_clean_orders;

select * from v_order_delivery_flags;