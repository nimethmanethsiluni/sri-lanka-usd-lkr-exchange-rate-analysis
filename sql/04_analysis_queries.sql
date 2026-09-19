-- ============================================
-- Analysis Queries: USD/LKR Exchange Rate & Inflation
-- ============================================

-- 1. Full trend, sorted by date
SELECT rate_date, usd_lkr_rate
FROM usd_lkr_monthly_rates
ORDER BY rate_date;


-- 2. Yearly average exchange rate
SELECT EXTRACT(YEAR FROM rate_date) AS year,
       ROUND(AVG(usd_lkr_rate), 2) AS avg_rate
FROM usd_lkr_monthly_rates
GROUP BY EXTRACT(YEAR FROM rate_date)
ORDER BY year;


-- 3. Month-over-month change (window function)
SELECT rate_date,
       usd_lkr_rate,
       usd_lkr_rate - LAG(usd_lkr_rate) OVER (ORDER BY rate_date) AS change_from_prev_month,
       ROUND(
         ((usd_lkr_rate - LAG(usd_lkr_rate) OVER (ORDER BY rate_date))
          / LAG(usd_lkr_rate) OVER (ORDER BY rate_date)) * 100, 2
       ) AS pct_change
FROM usd_lkr_monthly_rates
ORDER BY rate_date;


-- 4. Find the single biggest month-over-month jump (pinpoints the crisis month)
SELECT rate_date, usd_lkr_rate, pct_change
FROM (
    SELECT rate_date, usd_lkr_rate,
           ROUND(
             ((usd_lkr_rate - LAG(usd_lkr_rate) OVER (ORDER BY rate_date))
              / LAG(usd_lkr_rate) OVER (ORDER BY rate_date)) * 100, 2
           ) AS pct_change
    FROM usd_lkr_monthly_rates
) sub
ORDER BY pct_change DESC NULLS LAST
LIMIT 5;


-- 5. Exchange rate vs inflation during the 2022 crisis year
SELECT rate_date, usd_lkr_rate, inflation_yoy_pct
FROM usd_lkr_monthly_rates
WHERE EXTRACT(YEAR FROM rate_date) = 2022
ORDER BY rate_date;
