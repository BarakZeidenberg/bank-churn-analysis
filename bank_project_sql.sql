

CREATE DATABASE bank_project;


ALTER TABLE account_info DROP COLUMN Tenure;



CREATE TABLE bank_churn AS
SELECT 
    customer_info.*,
    account_info.Balance,
    account_info.NumOfProducts,
    account_info.HasCrCard,
    account_info.IsActiveMember,
    account_info.Exited
FROM customer_info
INNER JOIN account_info
ON customer_info.CustomerId = account_info.CustomerId;




SELECT * FROM bank_project.bank_churn;





SELECT count(*) as num_customers,
ROUND(AVG(Exited) * 100, 1) AS churn_rate
FROM bank_churn;

-- 1 in 5 customers churns — 20.4% churn rate overall.






SELECT Geography,
count(*) as num_customers,
ROUND(AVG(Exited) * 100, 1) AS churn_rate_by_geography
FROM bank_churn
GROUP BY Geography
order by churn_rate_by_geography desc;

-- Germany has a significantly higher churn rate (32.5%) compared to France (16.2%) and Spain (16.7%).






select gender,
count(*) as num_customers,
ROUND(AVG(Exited) * 100, 1)  AS churn_rate_by_Gender
FROM bank_churn
group by gender;

-- Female customers have a higher churn rate (25.1%) compared to male customers (16.5%).






select NumOfProducts, 
count(*) as num_customers,
ROUND(AVG(Exited) * 100, 1) as churn_rate_by_NumOfProducts
from bank_churn
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- Customers with 1 product churn the most — likely basic account holders who weren't approved for additional products.
-- Customers with 2 products are the most loyal — they have what they need.
-- Customers with 3-4 products show extremely high churn rates (82.7% and 100%).
   both groups are small — 266 and 60 customers respectively — insufficient to draw firm conclusions.
   matching each customer to the right number of products is critical.
   Overloading customers with unnecessary products appears to drive them away.





select IsActiveMember, 
count(*) as num_customers,
ROUND(AVG(Exited) * 100, 1) as churn_rate_by_IsActiveMember
from bank_churn
GROUP BY IsActiveMember
ORDER BY churn_rate_by_IsActiveMember DESC;

-- Inactive members have a higher churn rate 26.9% compared to active members 14.3%.







SELECT 
    CASE 
        WHEN Tenure BETWEEN 0 AND 2  THEN '0-2y'
        WHEN Tenure BETWEEN 3 AND 5  THEN '3-5y'
        WHEN Tenure BETWEEN 6 AND 8  THEN '6-8y'
        WHEN Tenure BETWEEN 9 AND 10 THEN '9-10y'
    END AS TenureGroup,
    COUNT(*)                                    AS num_Customers,
    SUM(Exited)                                 AS ChurnedCustomers,
    ROUND(AVG(Exited) * 100, 1)                 AS ChurnRate
FROM bank_churn
GROUP BY TenureGroup
ORDER BY MIN(Tenure);


-- --Tenure  shows no significant impact on churn — all groups cluster around 20%. 
-- -- Not a strong predictor of customer retention.





SELECT 
    CASE 
        WHEN EstimatedSalary BETWEEN 0 AND 50000 THEN 'Low (0-50k)'
        WHEN EstimatedSalary BETWEEN 50001 AND 100000 THEN 'Mid (50k-100k)'
        WHEN EstimatedSalary BETWEEN 100001 AND 200000 THEN 'High (100k-200k)'
    END AS SalaryGroup,
    ROUND(AVG(Exited) * 100, 1) AS ChurnRate,
    COUNT(*) AS NumCustomers
FROM bank_churn
GROUP BY SalaryGroup
ORDER BY  MIN(EstimatedSalary);


-- --EstimatedSalary  shows no significant impact on churn — all groups cluster around 20%. 
-- -- Not a strong predictor of customer retention.







SELECT 
    CASE
        WHEN Age BETWEEN 18 AND 35 THEN 'young_customer 18-35'
        WHEN Age BETWEEN 36 AND 60 THEN 'mid_age_customer 36-60'
        WHEN Age BETWEEN 61 AND 100 THEN 'Senior_customer 61-100'
    END AS age_category,
  ROUND(AVG(Exited) * 100, 1) AS churn_rate,
    COUNT(*) AS num_customers
FROM bank_churn
GROUP BY age_category
ORDER BY MIN(Age);

-- Churn rate heavily escalates after age 35, 
-- moving from a low 8.4% for young customers to 29.3% for middle-aged and 24.8% for elderly clients.





select 
case
WHEN Balance BETWEEN 0 AND 1 THEN '0' 
WHEN Balance BETWEEN 1 AND 50000 THEN '1-50k' 
WHEN Balance BETWEEN 50001 AND 150000 THEN '50k-150k' 
WHEN Balance BETWEEN 150001 AND 300000 THEN '150k-300k' 
END AS balance_category,
 ROUND(AVG(Exited) * 100, 1) AS churn_rate,
 COUNT(*) AS num_customers
FROM bank_churn
group by balance_category
order by min(Balance);

-- Customers with zero balance show the lowest churn (13.8%) — likely indifferent to their account.
-- The 50k-150k and 150k-300k groups show similar churn rates (~23-24%)
-- balance alone is not a strong predictor of churn.
-- Note: 1-50k group has only 75 customers — not representative.






select 
case
WHEN CreditScore BETWEEN 350 AND 550 THEN 'Low' 
WHEN CreditScore BETWEEN 551 AND 725 THEN 'mid' 
WHEN CreditScore BETWEEN 726 AND 850 THEN 'high' 
END AS CreditScore_category,
 ROUND(AVG(Exited) * 100, 1) AS churn_rate,
 COUNT(*) AS num_customers
FROM bank_churn
group by CreditScore_category
order by min(CreditScore);


-- CreditScore shows no significant impact on churn — all groups cluster around 20%. 
-- Not a strong predictor of customer retention.






select ROUND(AVG(Exited) * 100, 1) AS churn_rate,
 COUNT(*) AS num_customers
 FROM bank_churn
 where gender = 'Female' and balance > 0 AND Age BETWEEN 36 AND 60;
 
 
-- Female customers aged 36-60 with a non-zero balance (1,629 customers) show a churn rate of 39.3% — 
-- nearly double the overall rate of 20.4%. This segment represents a significant risk for the bank.





select ROUND(AVG(Exited) * 100, 1) AS churn_rate,
COUNT(*) AS num_customers
FROM bank_churn 
where gender = 'Female' AND Age BETWEEN 36 AND 60 AND Geography = 'Germany';


-- Female customers aged 35-60 in Germany 715 customers show a churn rate of 48% — more than double the overall churn rate of 20.4%. 
-- This is the highest-risk segment identified in this analysis.






























































