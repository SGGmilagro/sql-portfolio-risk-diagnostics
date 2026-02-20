-- 02_multi_horizon_returns.sql
-- Purpose: Compute daily log returns and multi-horizon performance metrics

WITH price_data AS (
    SELECT
        ticker,
        date,
        price,
        LAG(price) OVER (PARTITION BY ticker ORDER BY date) AS prev_price
    FROM client_portfolio_clean
),

daily_returns AS (
    SELECT
        ticker,
        date,
        LOG(price / prev_price) AS daily_log_return
    FROM price_data
    WHERE prev_price IS NOT NULL
),

multi_horizon_returns AS (
    SELECT
        ticker,

        -- 12 Month Return
        SUM(CASE WHEN date >= DATE_SUB(MAX(date), INTERVAL 12 MONTH)
                 THEN daily_log_return ELSE 0 END) AS total_return_12M,

        -- 18 Month Return
        SUM(CASE WHEN date >= DATE_SUB(MAX(date), INTERVAL 18 MONTH)
                 THEN daily_log_return ELSE 0 END) AS total_return_18M,

        -- 24 Month Return
        SUM(CASE WHEN date >= DATE_SUB(MAX(date), INTERVAL 24 MONTH)
                 THEN daily_log_return ELSE 0 END) AS total_return_24M

    FROM daily_returns
    GROUP BY ticker
)

SELECT * FROM multi_horizon_returns;
