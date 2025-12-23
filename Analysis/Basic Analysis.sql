USE supplychaindatabase;

/* =========================================================
   SQL ANALYSIS – SUPPLY CHAIN ANOMALY DETECTION
   View Used: v_order_delivery_flags
   Grain: One row per order item
   Objective:
   - Measure delivery performance
   - Identify financial and operational risks
   - Detect discount-related loss anomalies
========================================================= */

-- ---------------------------------------------------------
-- 1. Total Orders Analyzed
-- ---------------------------------------------------------
SELECT 
    COUNT(*) AS total_orders
FROM v_order_delivery_flags;
-- Result: 180,519 orders analyzed


-- ---------------------------------------------------------
-- 2. Late Delivery Percentage
-- ---------------------------------------------------------
SELECT
    ROUND(
        SUM(is_late_delivery) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_pct
FROM v_order_delivery_flags;
-- Insight: ~60.09% of orders are delivered late,
-- indicating significant delivery performance issues.


-- ---------------------------------------------------------
-- 3. Average Delay for Late Deliveries
-- ---------------------------------------------------------
SELECT
    ROUND(AVG(late_days), 2) AS avg_late_days
FROM v_order_delivery_flags
WHERE is_late_delivery = 1;
-- Insight: Late deliveries are delayed by an average of 1.54 days.


-- ---------------------------------------------------------
-- 4. Shipping Cancellation Percentage
-- ---------------------------------------------------------
SELECT
    ROUND(
        SUM(is_shipping_cancelled) * 100.0 / COUNT(*),
        2
    ) AS shipping_cancelled_pct
FROM v_order_delivery_flags;
-- Insight: ~4.3% of orders are cancelled during shipping,
-- pointing to fulfillment or inventory issues.


-- ---------------------------------------------------------
-- 5. Loss-Making Orders Percentage
-- ---------------------------------------------------------
SELECT
    ROUND(
        SUM(is_loss_order) * 100.0 / COUNT(*),
        2
    ) AS loss_order_pct
FROM v_order_delivery_flags;
-- Insight: ~18.7% of orders are loss-making,
-- highlighting profitability concerns.


-- ---------------------------------------------------------
-- 6. High-Risk Orders (Late + Loss-Making)
-- ---------------------------------------------------------
SELECT
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM v_order_delivery_flags),
        2
    ) AS high_risk_orders_pct
FROM v_order_delivery_flags
WHERE
    is_late_delivery = 1
    AND is_loss_order = 1;
-- Insight: ~11.2% of orders are both late and loss-making,
-- representing compounded operational and financial risk.


-- ---------------------------------------------------------
-- 7. Revenue Impact of Late Deliveries
-- ---------------------------------------------------------
SELECT
    ROUND(SUM(Sales), 2) AS revenue_from_late_orders
FROM v_order_delivery_flags
WHERE is_late_delivery = 1;
-- Insight: 22,054,051 in revenue is tied to late deliveries,
-- increasing the risk of refunds, churn, and SLA penalties.


-- ---------------------------------------------------------
-- 8. Discount Rate vs Loss Analysis
--    (Discount rate derived from discount amount and product price)
-- ---------------------------------------------------------
SELECT
    CASE
        WHEN Order_Item_Discount = 0 THEN 'No Discount'
        WHEN (Order_Item_Discount * 100.0 / NULLIF(Sales, 0)) <= 10 THEN '0–10%'
        WHEN (Order_Item_Discount * 100.0 / NULLIF(Sales, 0)) <= 30 THEN '10–30%'
        ELSE '30%+'
    END AS discount_rate_bucket,
    COUNT(*) AS total_orders,
    SUM(is_loss_order) AS loss_orders,
    ROUND(
        SUM(is_loss_order) * 100.0 / COUNT(*),
        2
    ) AS loss_pct
FROM v_order_delivery_flags
GROUP BY discount_rate_bucket
ORDER BY loss_pct DESC;
-- Insight:
-- Loss rates remain consistently high (~18%) across all discount levels,
-- including no-discount orders, indicating that discounts alone are not
-- the primary cause of losses.


/* =========================================================
   KEY BUSINESS INSIGHTS SUMMARY
   ---------------------------------------------------------
   1. Over 60% of orders are delivered late, showing major
      gaps between promised and actual delivery timelines.
   2. Nearly 19% of orders are loss-making, even without
      discounts, indicating structural cost inefficiencies.
   3. Around 11% of orders are both late and loss-making,
      representing the highest operational risk category.
   4. A large share of revenue is exposed to delivery delays,
      increasing the risk of churn and SLA penalties.
   5. Discount rates show weak correlation with losses,
      suggesting operational and logistics factors are the
      dominant drivers of profitability issues.
========================================================= */










