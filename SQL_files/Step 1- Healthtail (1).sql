--to check nulls
SELECT
  *
FROM
  `nigartest.health_tail.registration_clean`
WHERE
  patient_id IS NULL
  OR owner_id IS NULL
  OR owner_name IS NULL
  OR pet_type IS NULL
  OR breed_cleaned IS NULL
  OR patient_name IS NULL
  OR gender IS NULL
  OR patient_age IS NULL
  OR date_registration IS NULL
  OR owner_phone IS NULL;
    


-- Task 1.1 Data Cleaning 

CREATE OR REPLACE TABLE `nigartest.health_tail.registration_clean` AS
SELECT
   patient_id,
-- 1. Standardise patient_name to UPPER CASE
  INITCAP(patient_name) AS patient_name,
  patient_age,
   owner_id,
   owner_name,
   -- 2. Remove non-numeric characters from owner_phone
  REGEXP_REPLACE(owner_phone, r'[^0-9]', '') AS owner_phone,
   pet_type,
  -- 3. Replace NULL or empty breed with 'Unknown'
  IFNULL(breed,'Unknown') AS breed_cleaned,
  gender,
  date_registration
FROM `nigartest.health_tail.health_tail_reg_cards`;





--Task 1.2 Aggregation
WITH med_spent as (
select visit_datetime as month,med_prescribed as med_name, sum(med_dosage) as total_packs, 
sum(med_cost) as total_value,
"stock_out" as stock_movement 
from `nigartest.health_tail.visits`
GROUP BY month,med_name),

med_received as (
select DATE_TRUNC(month_invoice, MONTH) as month, med_name, sum(packs) as total_packs,
 sum(total_price) as total_value,
"stock_in" as stock_movement 
from `nigartest.health_tail.invoices`
GROUP BY month,med_name)

SELECT * 
FROM med_spent
UNION ALL
SELECT * 
FROM med_received  ;