-- Create the main table for exchange rate and inflation data
CREATE TABLE usd_lkr_monthly_rates (
    id SERIAL PRIMARY KEY,
    rate_date DATE NOT NULL,
    usd_lkr_rate NUMERIC(10,2) NOT NULL
);

-- Later, add the inflation column
ALTER TABLE usd_lkr_monthly_rates
ADD COLUMN inflation_yoy_pct NUMERIC(5,2);
