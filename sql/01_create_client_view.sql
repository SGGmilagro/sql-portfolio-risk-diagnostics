CREATE VIEW client_portfolio_clean AS
SELECT
    hc.ticker,
    sm.security_name,
    LOWER(REPLACE(sm.major_asset_class, ' ', '_')) AS major_asset_class,
    LOWER(REPLACE(sm.minor_asset_class, ' ', '_')) AS minor_asset_class,
    sm.sec_type,
    pd.date,
    pd.value AS price,
    hc.quantity
FROM customer_details cd
JOIN account_dim ad
    ON cd.customer_id = ad.client_id
JOIN holdings_current hc
    ON ad.account_id = hc.account_id
JOIN security_masterlist sm
    ON hc.ticker = sm.ticker
JOIN pricing_daily_new pd
    ON hc.ticker = pd.ticker
WHERE cd.customer_id = 148
AND pd.price_type = 'Adjusted'
ORDER BY pd.date;

-- Purpose: Create cleaned client-level portfolio view
