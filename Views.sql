
---------- SQL Script 1 ----------

-- Create a view that counts the number of hires for each month.
-- Sort the list by year then by month with its number of hires. 

CREATE VIEW hires_per_month(year, month, hire_count) AS
SELECT YEAR(hiredate), MONTH(hiredate), COUNT(*) AS hire_count
FROM employee
GROUP BY YEAR(hiredate), MONTH(hiredate);

SELECT *
FROM hires_per_month
ORDER BY 1, 2, 3;

---------- SQL Script 2 ----------

-- Formulate a view that counts that number of sales transactions a customer has entered.  
-- You must display the customer number, customer name, and the total number of sales transactions.  
-- Sort the list from highest to lowest count. 


CREATE VIEW customer_sales_transactions(custno, custname, total_sales_transactions) AS
SELECT c.custno, c.custname, COUNT(s.transno) AS transaction_count
FROM customer AS c
LEFT JOIN sales AS s
ON c.custno = s.custno
GROUP BY c.custno, c.custname;

SELECT *
FROM customer_sales_transactions
ORDER BY 3 DESC;

---------- SQL Script 3 ----------

-- What is the average salary of  each job position?
-- Exclude manager, vice president, and president from the generated list.
-- Your view must display the job code, job description, and the average salary of each job.  

CREATE VIEW avg_salary_per_position (jobcode, jobdesc, average_salary) AS
SELECT j.jobcode, j.jobdesc, AVG(jh.salary) AS average_salary
FROM job AS j
LEFT JOIN jobhistory as jh
USING(jobcode)
GROUP BY j.jobcode, j.jobdesc
HAVING j.jobdesc NOT IN ('Manager', 'Vice president', 'President');

SELECT *
FROM avg_salary_per_position;

---------- SQL Script 4 ----------

-- Design a view will determine products that have undergone price changes. 
-- Sort the list from highest to lowest count which also displays the product code and product description.
-- Exclude products that have no price change. 

CREATE VIEW product_price_changes (prodcode, description, price_change_count) AS
SELECT p.prodcode, p.description, COUNT(ph.effdate) AS price_change_count
FROM product AS p
LEFT JOIN pricehist AS ph
USING(prodcode)
GROUP BY p.prodcode, p.description
HAVING COUNT(ph.effdate) > 1;

SELECT *
FROM product_price_changes
ORDER BY 3 DESC;

---------- SQL Script 5 ----------

-- What is the current price of each product?
-- Create a view that displays the product code, product description, unit, and its current price. 

CREATE VIEW latest_product_prices (prodcode, description, unit, current_price) AS
SELECT p.prodcode, p.description, p.unit, COALESCE(ph2.unitprice, 0) AS current_price
FROM product AS p
LEFT JOIN (
	SELECT prodcode, MAX(effdate) AS latest_effdate
	FROM pricehist
	GROUP BY prodcode
) AS ph
ON p.prodcode = ph.prodcode
LEFT JOIN pricehist AS ph2
ON ph.prodcode = ph2.prodcode
	AND ph2.effdate = ph.latest_effdate;

SELECT *
FROM latest_product_prices;

---------- SQL Script 6 ----------

-- Determine the current number of employees per each department.
-- Your view should contain the department code, department name, and the number of employees a department has.
-- Do not include separated (with SEPDATE values) employees.

CREATE VIEW employee_count_per_department (deptcode, deptname, employee_count) AS
SELECT jh1.deptcode, d.deptname, COUNT(jh2.empno) AS employee_count
FROM jobhistory jh1
INNER JOIN (
	-- filter current employee's and the date of their latest job
	SELECT empno, MAX(effdate) AS latest_job_date
	FROM employee AS e
	LEFT JOIN jobhistory AS j
	USING(empno)
	WHERE e.sepdate IS NULL
	GROUP BY empno
) AS jh2
ON jh1.empno = jh2.empno
	AND jh1.effdate = jh2.latest_job_date
LEFT JOIN department AS d
ON jh1.deptcode = d.deptcode
GROUP BY jh1.deptcode, d.deptname;

SELECT *
FROM employee_count_per_department;

---------- SQL Script 7 ----------

-- Who among the employees received the most number of promotions?
-- The view must contain the employee number, employee name (combined last name and first name).
-- Sort the list with the most number of promotions. 
-- Do not include separated employees. 

CREATE VIEW employee_promotion_counts (empno, name, promotion_count) AS
SELECT e.empno, e.lastname || ', ' || e.firstname AS name, COUNT(effdate)-1 AS promotion_count
FROM employee AS e
LEFT JOIN jobhistory AS j
USING(empno)
WHERE e.sepdate IS NULL
GROUP BY e.empno, e.lastname || ', ' || e.firstname;

SELECT *
FROM employee_promotion_counts
ORDER BY promotion_count DESC;

---------- SQL Script 8 ----------

-- What is the most bought product of the company?
-- Your view must list the highest to lowest including the product code, product description, and unit, total_quantity.

CREATE VIEW products_sold (prodcode, description, unit, total_quantity_sold) AS
SELECT p.prodcode, p.description, p.unit, SUM(s.quantity) AS total_quantity_sold
FROM product AS p
LEFT JOIN salesdetail AS s
USING(prodcode)
GROUP BY p.prodcode, p.description, p.unit;

SELECT *
FROM products_sold;

---------- SQL Script 9 ----------

-- What is the total sales of each product?
-- Your view must contain product code, description, unit, total sales.  
-- To generate the correct result you must consider on how to get the sales of each product (unit price * quantity).
-- But what unit price do you use if the product has more than one unit price? 
-- The answer to this is to get the sales date of the transaction first and compare it with the unit price that is aligned with its effectivity date.
-- Meaning, if the sales date 6/27/2010 you will use the unit price effective date of 5/15/2010 and NOT the 08/01/2010;
-- if sales date is 03/21/2011, then the unit price to be used must be 08/01/2010 but NOT the 05/15/2010. 

CREATE VIEW proper_effdate_per_product_transaction (transno, prodcode, effdate) AS
-- filter the latest effectivity date
SELECT t1.transno, t1.prodcode, MAX(t1.effdate)
FROM (
	-- filter effectivity date that came to effect before the sale
	SELECT s1.transno, s2.prodcode, p.effdate
	FROM sales AS s1
	LEFT JOIN salesdetail AS s2
	ON s1.transno = s2.transno
	LEFT JOIN pricehist AS p
	ON s2.prodcode = p.prodcode
	WHERE s1.salesdate >= p.effdate
) AS t1
GROUP BY transno, prodcode;

CREATE VIEW sales_per_product_transaction (transno, prodcode, description, unit, quantity, unitprice, sales) AS
-- adding quantity, unitprice, and computing for total_sales
SELECT t1.transno, p.prodcode, p.description, p.unit, sd.quantity, ph.unitprice, sd.quantity*ph.unitprice AS sales
FROM product AS p
LEFT JOIN proper_effdate_per_product_transaction as t1
ON p.prodcode = t1.prodcode
LEFT JOIN pricehist as ph
ON t1.prodcode = ph.prodcode
	AND t1.effdate = ph.effdate
LEFT JOIN salesdetail AS sd
ON t1.transno = sd.transno
	AND t1.prodcode = sd.prodcode;

CREATE VIEW total_sales_per_product (prodcode, description, unit, total_sales) AS
SELECT spt.prodcode, spt.description, spt.unit, COALESCE(SUM(spt.sales),0) AS total_sales
FROM sales_per_product_transaction AS spt
GROUP BY spt.prodcode, spt.description, spt.unit;

SELECT *
FROM total_sales_per_product;

---------- SQL Script 10 ----------

-- Who is the customer that contributed the sales of the company?
-- Sort your list from highest to lowest including the customer code, name, and its total sales.

CREATE VIEW total_sales_per_customer (custno, custname, total_sales) AS
SELECT c.custno, c.custname, COALESCE(SUM(spt.sales_per_trans),0) AS total_sales
FROM customer AS c
LEFT JOIN sales AS s
ON c.custno = s.custno
LEFT JOIN (
	SELECT transno, SUM(sales) AS sales_per_trans
	FROM sales_per_product_transaction
	GROUP BY transno
) AS spt
ON s.transno = spt.transno
GROUP BY c.custno, c.custname;

SELECT *
FROM total_sales_per_customer
ORDER BY total_sales DESC;
