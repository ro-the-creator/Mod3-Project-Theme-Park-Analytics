--Q1:

-- Number of Unique Days in visit_date column
WITH unique_days AS (
SELECT DISTINCT visit_date
FROM fact_visits
)
SELECT COUNT(*) AS count_of_distinct_days
FROM unique_days;

--Date Range of visit_date
SELECT CONCAT(MIN(visit_date), ' - ', MAX(visit_date)) AS date_range
FROM fact_visits;

--Top Days with Highest Visit Count
SELECT DISTINCT visit_date, COUNT(*) AS visit_count
FROM fact_visits
GROUP BY visit_date
ORDER BY visit_count DESC;

--Q2: Top Visit Count per Ticket Type, Most to Least
SELECT dt.ticket_type_name AS ticket_type, COUNT(fv.ticket_type_id) AS visit_count
FROM fact_visits fv
INNER JOIN dim_ticket dt ON fv.ticket_type_id = dt.ticket_type_id
GROUP BY ticket_type
ORDER BY visit_count DESC;

--Q3: Distribution of Wait Times
SELECT wait_minutes, COUNT(*) AS frequency_of_wait_time
FROM fact_ride_events
GROUP BY wait_minutes
ORDER BY wait_minutes DESC;
--(note to self: I want to see which rides have high wait times --> JOIN with dim_attraction for attraction_name)

--Q4: Average Satisfaction Rating by Ride Name and Ride Category, Most to Least
SELECT attraction_name, category, ROUND(AVG(satisfaction_rating),2) AS average_rating
FROM dim_attraction da
INNER JOIN fact_ride_events fre ON da.attraction_id = fre.attraction_id
GROUP BY attraction_name, category
ORDER BY average_rating DESC;

--Q5: Checking for Duplicates in fact_ride_events
SELECT ride_event_id, COUNT(*) AS duplicate_row
FROM fact_ride_events
GROUP BY ride_event_id
HAVING duplicate_row >1;
--No duplicate rows

--Q6: 
-- Need to wait to see which columns are important
WITH everything AS (
SELECT *
FROM fact_visits fv
FULL OUTER JOIN fact_purchases fp ON fv.visit_id = fp.visit_id
FULL OUTER JOIN fact_ride_events fre ON fv.visit_id = fre.visit_id
FULL OUTER JOIN dim_date dd ON fv.date_id = dd.date_id
FULL OUTER JOIN dim_attraction da ON fre.attraction_id = da.attraction_id
FULL OUTER JOIN dim_guest dg ON fv.guest_id = dg.guest_id
FULL OUTER JOIN dim_ticket dt ON fv.ticket_type_id = dt.ticket_type_id
),
id_number AS (
SELECT row_number() OVER() AS number, *
FROM everything
)
SELECT number, COUNT(*) AS duplicate_count
FROM id_number
GROUP BY number
HAVING duplicate_count >1;


--Q7: Average Party Size by the Day of Week
SELECT dd.date_id, day_name,  ROUND(AVG(party_size),2) AS average_party_size
FROM fact_visits fv
INNER JOIN dim_date dd ON fv.date_id = dd.date_id
GROUP BY day_name
ORDER BY dd.date_id;

