
---------- SQL Script 1 ----------

--  List employee number, last name, first name, middle initial  where middle initial of employee's name  is null.  

SELECT empNo, lastName, firstNme, midInit
FROM emp
WHERE midINIT IS NULL;

---------- SQL Script 2 ----------

--  List  lastname, first name and birthdate sorted by last name.  
-- Concatenate last name with comma-space and first name, respectively.
-- Use alias name "Name" as the column name of the concatenated names.

SELECT lastname || ', ' || firstnme AS Name, birthdate
FROM emp
ORDER BY birthdate;

---------- SQL Script 3 ----------

--  Display employee number, last name, first name, hire date of all employees which were hired between 1990 and 2000.
-- Sort results  by hiredate 

SELECT empno, lastname, firstnme, hiredate
FROM emp
WHERE YEAR(hiredate) BETWEEN 1990 AND 2000
ORDER BY hiredate;

---------- SQL Script 4 ----------

-- Display work dept, last name, first name, salary
-- sorted by work dept and last name
-- filtered with salary ranging from 30,000 and 50,000. 

SELECT workdept, lastname, firstnme, salary
FROM emp
WHERE salary BETWEEN 30000 AND 50000
ORDER BY workdept, lastname;

---------- SQL Script 5 ----------

-- Display work dept, employee number,  name( concatenated by last name, first name), salary, salary with 10% increase.
-- Label the salary with 10% increase as "New Salary".  
-- Only salaries ranging from 35000 and 40000 are entitled for the increase.
-- Sort according to workdept and lastname. 

SELECT workdept, empno, lastname || ', ' || firstnme AS name, salary, salary*1.10 AS new_salary
FROM emp
WHERE salary BETWEEN 35000 AND 40000
ORDER BY workdept, lastname;
