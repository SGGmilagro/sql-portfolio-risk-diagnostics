-- 04_asset_allocation_breakdown.sql
-- Purpose: Compute portfolio allocation by asset class

WITH portfolio_values AS (
    SELECT
        ticker,
        major_asset_class,
        SUM(price * quantity) AS total_value
    FROM client_portfolio_clean
    GROUP BY ticker, major_asset_class
),

allocation AS (
    SELECT
        major_asset_class,
        SUM(total_value) AS class_value
    FROM portfolio_values
    GROUP BY major_asset_class
),

total_portfolio AS (
    SELECT SUM(class_value) AS portfolio_total
    FROM allocation
)

SELECT
    a.major_asset_class,
    a.class_value,
    (a.class_value / t.portfolio_total) * 100 AS allocation_percentage
FROM allocation a
CROSS JOIN total_portfolio t
ORDER BY allocation_percentage DESC;
