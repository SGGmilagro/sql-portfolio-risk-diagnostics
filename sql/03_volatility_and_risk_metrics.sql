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

risk_metrics AS (
    SELECT
        ticker,
        STDDEV(daily_log_return) AS sigma_12M,
        AVG(daily_log_return) AS avg_daily_return,
        AVG(daily_log_return) / STDDEV(daily_log_return) AS risk_adjusted_return
    FROM daily_returns
    GROUP BY ticker
)

SELECT * FROM risk_metrics
ORDER BY risk_adjusted_return DESC;


-- Purpose: Compute volatility (sigma), average daily return,
-- and risk-adjusted performance per security
