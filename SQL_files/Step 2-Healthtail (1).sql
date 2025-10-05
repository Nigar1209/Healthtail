----Step 2
-- 1. What med did we spend the most money on in total?

SELECT med_name , sum(total_value) as tot_money
 FROM `nigartest.health_tail.med_audit`  
 WHERE stock_movement='stock_in'
 GROUP BY med_name
 ORDER BY tot_money DESC;

-- 2. What med had the highest monthly total_value spent on patients? At what month?  
SELECT med_name , month , sum(total_value) as tot_money
 FROM `nigartest.health_tail.med_audit`  
 GROUP BY med_name,month
ORDER BY tot_money DESC;

-- 3. What month was the highest in packs of meds spent in vet clinic?
SELECT  month ,round(sum(total_packs),2) as tot_packs,
 FROM `nigartest.health_tail.med_audit`  
 WHERE stock_movement='stock_out'
 GROUP BY month
ORDER BY tot_packs DESC;

--4. What’s an average monthly spent in packs of the med that generated the most revenue? 
WITH most_spent AS (
SELECT med_name,
ROUND(SUM(total_value),2) AS total_value FROM `nigartest.health_tail.med_audit`
WHERE stock_movement='stock_in'
GROUP BY med_name
ORDER BY total_value DESC
LIMIT 1
)
SELECT AVG(total_packs) as avg_monthly_spent_in_packs
FROM  `nigartest.health_tail.med_audit` t1
JOIN  most_spent ms
ON t1.med_name = ms.med_name
WHERE stock_movement = 'stock_out'
GROUP BY t1.med_name
;
