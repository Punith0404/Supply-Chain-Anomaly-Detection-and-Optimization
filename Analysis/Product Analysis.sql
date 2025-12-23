USE supplychaindatabase;

/* =========================================================
   PRODUCT & CATEGORY RISK ANALYSIS
   Data Sources:
   - v_order_delivery_flags (fact)
   - v_dim_product (dimension)
   Objective:
   - Identify loss-prone categories
   - Detect high-risk products
   - Analyze delivery risk by category
   - Understand pricing impact on losses
========================================================= */

-- ---------------------------------------------------------
-- 1. LOSS PERCENTAGE BY PRODUCT CATEGORY (Top Loss-Prone)
-- ---------------------------------------------------------
SELECT
    p.category_name,
    COUNT(*) AS total_orders,
    SUM(f.is_loss_order) AS loss_orders,
    ROUND(
        SUM(f.is_loss_order) * 100.0 / COUNT(*),
        2
    ) AS loss_pct
FROM v_order_delivery_flags AS f
JOIN v_dim_product AS p
    ON f.product_id = p.product_id
GROUP BY
    p.category_name
ORDER BY
    loss_pct DESC
LIMIT 5;

-- Insight:
-- Categories such as Men's Clothing, Health & Beauty,
-- and Video Games show the highest loss percentages,
-- indicating pricing pressure or higher fulfillment costs.


-- ---------------------------------------------------------
-- 2. TOP HIGH-RISK PRODUCTS (Late + Loss Orders)
-- ---------------------------------------------------------
SELECT
    p.product_name,
    COUNT(*) AS high_risk_orders
FROM v_order_delivery_flags AS f
JOIN v_dim_product AS p
    ON f.product_id = p.product_id
WHERE
    f.is_late_delivery = 1
    AND f.is_loss_order = 1
GROUP BY
    p.product_name
ORDER BY
    high_risk_orders DESC
LIMIT 5;

-- Insight:
-- A small number of SKUs account for a disproportionately
-- high number of late and loss-making orders, making them
-- prime candidates for pricing or supply-chain review.


-- ---------------------------------------------------------
-- 3. LATE DELIVERY RISK BY PRODUCT CATEGORY
-- ---------------------------------------------------------
SELECT
    p.category_name,
    COUNT(*) AS total_orders,
    SUM(f.is_late_delivery) AS late_orders,
    ROUND(
        SUM(f.is_late_delivery) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_pct
FROM v_order_delivery_flags AS f
JOIN v_dim_product AS p
    ON f.product_id = p.product_id
GROUP BY
    p.category_name
ORDER BY
    late_delivery_pct DESC
LIMIT 5;

-- Insight:
-- Categories like Golf Bags & Carts, Pet Supplies, and
-- Cameras show extremely high late delivery rates,
-- suggesting handling complexity or SLA mismatch.


-- ---------------------------------------------------------
-- 4. LOSS ANALYSIS BY DEPARTMENT
-- ---------------------------------------------------------
SELECT
    p.department_name,
    COUNT(*) AS total_orders,
    SUM(f.is_loss_order) AS loss_orders,
    ROUND(
        SUM(f.is_loss_order) * 100.0 / COUNT(*),
        2
    ) AS loss_pct
FROM v_order_delivery_flags AS f
JOIN v_dim_product AS p
    ON f.product_id = p.product_id
GROUP BY
    p.department_name
ORDER BY
    loss_pct DESC;

-- Insight:
-- Loss rates remain fairly consistent (~17–19%) across
-- departments, indicating systemic margin issues rather
-- than department-specific failures.


-- ---------------------------------------------------------
-- 5. PRICE BUCKET VS LOSS ANALYSIS
-- ---------------------------------------------------------
SELECT
    CASE
        WHEN p.product_price < 50 THEN 'Low Price'
        WHEN p.product_price BETWEEN 50 AND 200 THEN 'Mid Price'
        ELSE 'High Price'
    END AS price_bucket,
    COUNT(*) AS total_orders,
    SUM(f.is_loss_order) AS loss_orders,
    ROUND(
        SUM(f.is_loss_order) * 100.0 / COUNT(*),
        2
    ) AS loss_pct
FROM v_order_delivery_flags AS f
JOIN v_dim_product AS p
    ON f.product_id = p.product_id
GROUP BY
    price_bucket
ORDER BY
    loss_pct DESC;

-- Insight:
-- Loss percentages are nearly identical across price tiers,
-- showing that product price alone is not a strong driver
-- of losses; operational costs dominate profitability.
