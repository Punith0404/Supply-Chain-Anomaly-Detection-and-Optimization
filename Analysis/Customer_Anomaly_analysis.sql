USE supplychaindatabase;

-- =====================================================
-- 1. Customer Segment Performance
-- =====================================================

SELECT
    c.customer_segment,
    COUNT(o.order_id) AS total_orders,
    SUM(o.sales) AS total_sales,
    SUM(o.profit_per_order) AS total_profit,
    ROUND(AVG(o.profit_per_order), 2) AS avg_profit_per_order,
    ROUND(100.0 * SUM(o.is_late_delivery) / COUNT(o.order_id), 2) AS late_delivery_pct,
    ROUND(100.0 * SUM(o.is_loss_order) / COUNT(o.order_id), 2) AS loss_order_pct
FROM v_order_delivery_flags o
JOIN v_dim_customer c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_segment;

-- Insight:
-- Consumer segment drives the highest sales and orders,
-- but all segments show similar loss rates (~18–19%)
-- and very high late delivery (~60%), indicating systemic issues.


-- =====================================================
-- 2. City-wise Late Delivery Risk
-- =====================================================

SELECT
    c.customer_city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.is_late_delivery) AS late_orders,
    ROUND(100.0 * SUM(o.is_late_delivery) / COUNT(o.order_id), 2) AS late_delivery_pct
FROM v_order_delivery_flags o
JOIN v_dim_customer c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_city
HAVING COUNT(o.order_id) > 50
ORDER BY late_delivery_pct DESC;

-- Insight:
-- Multiple cities show extremely high late delivery rates
-- (>75%), highlighting last-mile logistics problems
-- concentrated in specific locations.


-- =====================================================
-- 3. Late Delivery Duration vs Loss
-- =====================================================

SELECT
    CASE
        WHEN late_days = 0 THEN 'On Time'
        WHEN late_days BETWEEN 1 AND 3 THEN '1–3 Days Late'
        WHEN late_days BETWEEN 4 AND 7 THEN '4–7 Days Late'
        ELSE '8+ Days Late'
    END AS late_bucket,
    COUNT(order_id) AS total_orders,
    SUM(is_loss_order) AS loss_orders,
    ROUND(100.0 * SUM(is_loss_order) / COUNT(order_id), 2) AS loss_pct
FROM v_order_delivery_flags
GROUP BY late_bucket
ORDER BY late_bucket;

-- Insight:
-- Loss percentage remains nearly constant across
-- on-time and late deliveries, suggesting losses
-- are not driven by delivery delays alone.


-- =====================================================
-- 4. Customers with Repeated Late Deliveries
-- =====================================================

SELECT
    c.customer_id,
    c.customer_full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.is_late_delivery) AS late_orders,
    ROUND(100.0 * SUM(o.is_late_delivery) / COUNT(o.order_id), 2) AS late_pct
FROM v_order_delivery_flags o
JOIN v_dim_customer c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_full_name
HAVING SUM(o.is_late_delivery) >= 3
ORDER BY late_pct DESC;

-- Insight:
-- Customers with repeated late deliveries are
-- at higher risk of dissatisfaction and churn
-- and should be operationally prioritized.


-- =====================================================
-- FINAL SUMMARY
-- =====================================================
-- • Late delivery is a widespread operational issue (~60%).
-- • Loss rates are stable across segments and delivery timing.
-- • Specific cities drive extreme delivery delays.
-- • Optimization should focus on logistics efficiency,
--   not customer segments or delivery speed alone.
