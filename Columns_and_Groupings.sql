
---------- SQL Script 1 ----------

--  What is the summary count of customers paying cash-on-delivery, 30-day, and 45-day notice in California?
-- Note:  CA is the code for California. 

SELECT payterm, COUNT(*) AS summary_count
FROM customer
WHERE address LIKE '%CA%'
GROUP BY payterm;

---------- SQL Script 2 ----------

-- How many current male and female does the company have?

SELECT gender, COUNT(*) as gender_count
FROM personnel
WHERE sepdate IS NULL
GROUP BY gender;

---------- SQL Script 3 ----------

-- Which transaction has the biggest number of total quantities delivered?
-- Refer to the RECEIPTDETAIL table.
-- Sort from the highest to the lowest quantity. 

SELECT transno, SUM(quantity) AS total_quantity_delivered
FROM receiptdetail
GROUP BY transno
ORDER BY 2 DESC;

---------- SQL Script 4 ----------

-- Generate the total payment made per transaction each year.
-- Exclude a total amount less than 1,000 dollars.
-- List year, transaction number, total Payment.
-- The listing should be grouped by year with the highest amount first on that year.

SELECT YEAR(paydate) AS year, transno, SUM(amount) AS total_payment
FROM payment
GROUP BY YEAR(paydate), transno
HAVING SUM(amount) >= 1000
ORDER BY year, total_payment DESC;

---------- SQL Script 5 ----------

-- Which product code has multiple changes in prices in PRICEHIST table?

SELECT prodcode, COUNT(*) AS change_count
FROM pricehist
GROUP BY prodcode
HAVING COUNT(*) <> 1
ORDER BY change_count DESC;



