--creating dollar columns

--for fact_visits
ALTER TABLE fact_visits ADD COLUMN spend_dollar REAL;

WITH c AS (
SELECT
rowid AS rid,
REPLACE(REPLACE(REPLACE(REPLACE(UPPER(COALESCE(total_spend_cents,'')),
'USD',''), '$',''), ',', ''), ' ', '') AS cleaned
FROM fact_visits
)
UPDATE fact_visits
SET spend_dollar = (CAST((SELECT cleaned FROM c WHERE c.rid = fact_visits.rowid)
AS REAL))/100
WHERE LENGTH((SELECT cleaned FROM c WHERE c.rid = fact_visits.rowid)) > 0;

--for fact_purchases
ALTER TABLE fact_purchases ADD COLUMN amount_dollar REAL;

WITH c AS (
SELECT
rowid AS rid,
REPLACE(REPLACE(REPLACE(REPLACE(UPPER(COALESCE(amount_cents,'')),
'USD',''), '$',''), ',', ''), ' ', '') AS cleaned
FROM fact_purchases
)
UPDATE fact_purchases
SET amount_dollar = (CAST((SELECT cleaned FROM c WHERE c.rid = fact_purchases.rowid)
AS REAL))/100
WHERE LENGTH((SELECT cleaned FROM c WHERE c.rid = fact_purchases.rowid)) > 0;