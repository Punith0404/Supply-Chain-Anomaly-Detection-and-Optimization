USE supplychaindatabase;

/* =========================================================
   SHIPPING MODE ANALYSIS
   Objective:
   - Evaluate delivery performance by shipping mode
   - Identify cancellation risk
   - Detect high-risk orders (Late + Loss)
   Data Sources:
   - v_order_delivery_flags (fact)
   - v_dim_shipping (dimension)
========================================================= */

-- ---------------------------------------------------------
-- 1. Late Delivery Percentage by Shipping Mode
-- ---------------------------------------------------------
SELECT
    s.shipping_mode,
    COUNT(*) AS total_orders,
    SUM(f.is_late_delivery) AS late_orders,
    ROUND(
        SUM(f.is_late_delivery) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_pct
FROM v_order_delivery_flags AS f
JOIN v_dim_shipping AS s
    ON f.Order_Id = s.order_id
GROUP BY
    s.shipping_mode
ORDER BY
    late_delivery_pct DESC;

-- Insight:
-- First Class and Same Day shipping modes show extremely
-- high late delivery percentages, indicating SLA definition
-- or over-promising issues rather than isolated failures.


-- ---------------------------------------------------------
-- 2. Shipping Cancellation Percentage by Shipping Mode
-- ---------------------------------------------------------
SELECT
    s.shipping_mode,
    COUNT(*) AS total_orders,
    SUM(f.is_shipping_cancelled) AS cancelled_orders,
    ROUND(
        SUM(f.is_shipping_cancelled) * 100.0 / COUNT(*),
        2
    ) AS cancellation_pct
FROM v_order_delivery_flags AS f
JOIN v_dim_shipping AS s
    ON f.Order_Id = s.order_id
GROUP BY
    s.shipping_mode
ORDER BY
    cancellation_pct DESC;

-- Insight:
-- Cancellation rates vary only slightly across shipping modes,
-- suggesting cancellations are driven more by fulfillment or
-- inventory constraints than by shipping speed.


-- ---------------------------------------------------------
-- 3. High-Risk Orders by Shipping Mode
--    (Orders that are both Late and Loss-Making)
-- ---------------------------------------------------------
SELECT
    s.shipping_mode,
    COUNT(*) AS high_risk_orders
FROM v_order_delivery_flags AS f
JOIN v_dim_shipping AS s
    ON f.Order_Id = s.order_id
WHERE
    f.is_late_delivery = 1
    AND f.is_loss_order = 1
GROUP BY
    s.shipping_mode
ORDER BY
    high_risk_orders DESC;

-- Insight:
-- Standard Class has the highest number of high-risk orders
-- due to its large order volume, while fast shipping modes
-- show lower absolute risk despite high late-delivery rates.
