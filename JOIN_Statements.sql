
---------- SQL Script 1 ----------

-- List the transaction number, sales date, product code, description, unit and quantity from the hope database.
-- Sort according to transaction number and product code.
-- Use LEFT JOIN in your solution. 

SELECT s1.transno, s1.salesdate, s2.prodcode, p.description, p.unit, s2.quantity 
FROM sales AS s1
LEFT JOIN salesdetail AS s2
ON s1.transno = s2.transno
LEFT JOIN product AS p
ON s2.prodcode = p.prodcode
ORDER BY transno, prodcode;

---------- SQL Script 2 ----------

-- Display the employee number, last name, first name, job description, and effectivity date from the job history of the employee.
-- Sort last name and effectivity date (last date first).
-- Use LEFT JOIN. 

SELECT e.empno, e.lastname, e.firstname, j.jobdesc, jh.effdate
FROM employee AS e
LEFT JOIN jobhistory AS jh
ON e.empno = jh.empno
LEFT JOIN job AS j
ON jh.jobcode = j.jobcode
ORDER BY lastname, effdate DESC;

---------- SQL Script 3 ----------

-- Show total quantity sold from salesdetail table.
-- Display product code, description, unit, quantity.
-- Use RIGHT JOIN.
-- Sort according to the most product sold.

SELECT p.prodcode, p.description, p.unit, COALESCE(SUM(quantity), 0) AS total_quantity_sold 
FROM salesdetail AS s
RIGHT JOIN product AS p
USING(prodcode)
GROUP BY p.prodcode, p.description, p.unit
ORDER BY total_quantity_sold DESC;

---------- SQL Script 4 ----------

-- Generate the detailed payments made by customers for specific transactions.
-- Display customer number, customer name, payment date, official receipt no, transaction number and payment amount.
-- Sort according to the customer name.
-- Use LEFT JOIN. 

SELECT c.custno, c.custname, p.paydate, p.orno, s.transno, p.amount
FROM customer AS c
LEFT JOIN sales AS s
ON c.custno = s.custno
LEFT JOIN payment AS p
ON s.transno = p.transno
ORDER BY c.custname;

---------- SQL Script 5 ----------

-- What is the current price of  each product?
-- Display product code, product description, unit, and its current price.
-- Always assume that NOT ALL products HAVE unit price BUT you need to display it even if it has no unit price on it.
-- DO NOT USE INNER JOIN. 
-- HINT:  You will use MAX(). This is a nested join. Your list should consist only of 57 rows.

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


