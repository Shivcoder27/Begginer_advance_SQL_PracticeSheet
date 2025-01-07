-----------------------SQL--------------------------

USE 'parks_and_recreation';

select * from 
parks_and_recreation.employee_demographics;

SELECT * from 
parks_and_rectreation.employee_salary;

SELECT first_name,last_name,birth_date,age,(age+10)*10
FROM parks_and_recreation.employee_demographics;

SELECT DISTINCT first_name
FROM parks_and_recreation.employee_demographics;

SELECT DISTINCT gender
FROM parks_and_recreation.employee_demographics;

SELECT *
FROM parks_and_recreation.employee_salary
WHERE salary<40000;
 ---------------------------------- AND OR NOT -- logical operator
 
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date> '1985-01-01' AND gender = 'male';
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date> '1985-01-01' OR gender = 'male';
SELECT *
FROM parks_and_recreation.employee_demographics
WHERE birth_date> '1985-01-01' AND NOT gender = 'male';

----------------------------------- LIKE STATEMENT--

SELECT *
FROM parks_and_recreation.employee_demographics
WHERE first_name LIKE '____'
;

--------------------------------- GROUP BY_---

SELECT gender
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;
SELECT gender, AVG(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

SELECT occupation,salary
FROM parks_and_recreation.employee_salary
GROUP BY occupation,salary
;

SELECT gender, AVG(age),MAX(age),MIN(age),COUNT(age)
FROM parks_and_recreation.employee_demographics
GROUP BY gender
;

--------------------------------------- ORDER BY-----
SELECT *
FROM parks_and_recreation.employee_demographics
ORDER BY gender;

----------------------------------- GROUP BY HAVING --

SELECT first_name,salary
FROM parks_and_recreation.employee_salary
group by first_name,salary HAVING AVG(salary)>40000
;
SELECT first_name,salary
FROM parks_and_recreation.employee_salary
WHERE occupation LIKE '%manager%'
group by first_name,salary HAVING AVG(salary)>40000
;
-------------------------------- ORDER BY LIMIT ---
SELECT first_name,salary
FROM parks_and_recreation.employee_salary
WHERE occupation LIKE '%manager%'
group by first_name,salary HAVING AVG(salary)>40000
LIMIT 2
;
SELECT first_name 
FROM parks_and_recreation.employee_demographics
order by age limit 3;

SELECT * 
FROM parks_and_recreation.employee_demographics
order by age DESC limit 3;

--- Aliasing ---
SELECT gender, AVG(age) as avg_age
FROM parks_and_recreation.employee_demographics
GROUP BY gender
HAVING AVG(age)>40;

-------------------------------------- JOINS ----

SELECT *
FROM parks_and_recreation.employee_demographics;

SELECT *
FROM parks_and_recreation.employee_salary;

--- INNER JOIN ---

SELECT *
FROM parks_and_recreation.employee_demographics as emp_d
INNER JOIN parks_and_recreation.employee_salary as emp_s
ON emp_d.employee_id = emp_s.employee_id;

--- common column are showed two times--

----- OUTER JOINs ---

SELECT *
FROM parks_and_recreation.employee_demographics as emp_d
LEFT JOIN parks_and_recreation.employee_salary as emp_s
ON emp_d.employee_id = emp_s.employee_id;

SELECT *
FROM parks_and_recreation.employee_demographics as emp_d
RIGHT JOIN parks_and_recreation.employee_salary as emp_s
ON emp_d.employee_id = emp_s.employee_id;

---- SELF JOIN ---

SELECT *
FROM parks_and_recreation.employee_salary as emp_s1
JOIN parks_and_recreation.employee_salary as emp_s2
ON emp_s1.employee_id +1 = emp_s2.employee_id;

--- JOINING MULTIPLE TABLES --

SELECT * 
FROM parks_and_recreation.parks_departments ;

SELECT *
FROM parks_and_recreation.employee_demographics as emp_d
INNER JOIN parks_and_recreation.employee_salary as emp_s
ON emp_d.employee_id = emp_s.employee_id
INNER JOIN parks_and_recreation.parks_departments as pd 
ON emp_s.dept_id = pd.department_id;

------------------------------- UNIONS ------------------------

SELECT first_name,last_name
FROM parks_and_recreation.employee_demographics
UNION
SELECT first_name,last_name
FROM parks_and_recreation.employee_salary;

---- to show all with duplicates --

SELECT first_name,last_name
FROM parks_and_recreation.employee_demographics
UNION ALL
SELECT first_name,last_name
FROM parks_and_recreation.employee_salary;

SELECT first_name,last_name,'Old Man' as Label
FROM parks_and_recreation.employee_demographics
WHERE age>40 AND gender ='Male'
UNION
SELECT first_name,last_name,'Old Lady' as Label
FROM parks_and_recreation.employee_demographics
WHERE age>40 AND gender ='Female'
UNION
SELECT first_name,last_name,'Highly Paid Emp' as Label
FROM parks_and_recreation.employee_salary
WHERE salary >70000
ORDER BY first_name,last_name;

------------------------ STRING FUNCTIONS ----------

SELECT first_name,LENGTH(first_name)
FROM parks_and_recreation.employee_demographics
order by 2
;
select upper('sky');
select lower('SKY');

---- trim

select first_name,
LEFT(first_name,4),
RIGHT(first_name,4),
substring(first_name,2,3)
from parks_and_recreation.employee_demographics ;


--- use case of substring by finding birthmonth from DOB --

select first_name,
birth_date,
substring(birth_date,6,2) as Birth_month
from parks_and_recreation.employee_demographics ;

--- replace
select first_name,replace(first_name,'e','z')
from parks_and_recreation.employee_demographics ;

---- concat 
select first_name,last_name,concat(first_name,' ',last_name) as full_name
from parks_and_recreation.employee_demographics ;


------------------------------ CASE STATEMENT -------------------

select first_name ,last_name, age ,
case 
    when age <= 30 then 'fresher'
    when age between 31 and 49 then 'experienced emp'
    when age >=50 then 'highly experienced emp'
    
END as experience  
from parks_and_recreation.employee_demographics ;

-- other usecase suppose i want to hike salary of employees after year

SELECT 
    emps.first_name,
    emps.last_name,
    emps.salary,
    age,
    CASE
        WHEN emps.salary < 40000 THEN emps.salary + (0.05 * emps.salary)
        WHEN emps.salary BETWEEN 40000 AND 55000 THEN emps.salary + (0.07 * emps.salary)
        WHEN emps.salary > 55000 THEN emps.salary + (0.10 * emps.salary)
    END AS hiked_salary,
    CASE 
        WHEN empd.age <= 30 THEN 'fresher'
        WHEN empd.age BETWEEN 31 AND 49 THEN 'experienced emp'
        WHEN empd.age >= 50 THEN 'highly experienced emp'
    END AS experience 
FROM 
    parks_and_recreation.employee_salary AS emps
JOIN 
    parks_and_recreation.employee_demographics AS empd 
    ON emps.employee_id = empd.employee_id
;

---- Subqueries

SELECT *
from parks_and_recreation.employee_demographics
where employee_id IN 
                    (select employee_id
					 from parks_and_recreation.employee_salary
                     where dept_id = 1);

--------------------- WINDOW FUNCTION ---------

SELECT gender , avg(salary)
from parks_and_recreation.employee_demographics dem
join parks_and_recreation.employee_salary sal 
           on dem.employee_id = sal.employee_id
           group by gender;
------ OVER FUNCTION
SELECT gender , avg(salary) over(partition by gender)
from parks_and_recreation.employee_demographics dem
join parks_and_recreation.employee_salary sal 
           on dem.employee_id = sal.employee_id
           ;

SELECT dem.first_name,dem.last_name,gender , avg(salary) over(partition by gender)
from parks_and_recreation.employee_demographics dem
join parks_and_recreation.employee_salary sal 
           on dem.employee_id = sal.employee_id
           ;
 ------ ROW NUMBER() OVER()         
SELECT dem.first_name,dem.last_name,gender , salary,
ROW_NUMBER() OVER()   
from parks_and_recreation.employee_demographics dem
join parks_and_recreation.employee_salary sal 
           on dem.employee_id = sal.employee_id
           ;
  ----------- ROW , RANK , DENSE RANK         
SELECT dem.first_name,dem.last_name,gender , salary,
ROW_NUMBER() OVER(partition by gender order by salary DESC) as row_num,
RANK() OVER(partition by gender order by salary DESC) as rnk_num ,
dense_rank() OVER(partition by gender order by salary DESC) as dense_num 
from parks_and_recreation.employee_demographics dem
join parks_and_recreation.employee_salary sal 
	on dem.employee_id = sal.employee_id;    
    
--- CTE common table expression
-- it is used to reduce the complexity of problem and problems which can't solve in single query
With CTE_ex as 
(
SELECT gender , avg(salary)as avg_sal,max(salary)as max_sal,min(salary) as min_sal
from parks_and_recreation.employee_demographics dem
join parks_and_recreation.employee_salary sal 
           on dem.employee_id = sal.employee_id
           group by gender
)    
select *
from CTE_ex;

------ joining multiple CTE
           
With CTE_ex as 
(
SELECT employee_id,gender,birth_date
from parks_and_recreation.employee_demographics dem
where birth_date> '1985-01-01'
),
CTE_ex2 as
(
SELECT employee_id,salary
from parks_and_recreation.employee_salary
where salary > 40000
)    
select *
from CTE_ex as c1
join CTE_ex2 as c2 on
c1.employee_id = c2.employee_id
;   
           
--------------------- Temporary tables
--- it remains until we remains within session and not closing software


create temporary table temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);  

select * 
from temp_table       ;  

 create temporary table salary_over50k
 select *
 from parks_and_recreation.employee_salary
 where salary >= 50000;
 
select * 
from salary_over50k;  

------- stored proceures....... it helping storing query

create procedure large_salaries()
select *
from employee_salary
where salary>=50000;
-- correct way to create store procedure is using delimiter --

DELIMITER $$
create procedure large_salaries3()
BEGIN
   select *
   from parks_and_recreation.employee_salary
   where salary>=50000;
   select *
   from parks_and_recreation.employee_salary
   where salary>=10000;
END 
DELIMITER $$;

-- and we can directly create procedure and paste our query there--

----------------------- TRIGGER AND EVENTS---------

Triggers are a type of stored procedure that is invoked automatically in response to events
 like INSERT, UPDATE, or DELETE.
 
 use--Enforcing Business Rules,Preventing Invalid Transactions,Notification Mechanisms
 
CREATE TRIGGER after_update_audit
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO audit_table (employee_id, old_salary, new_salary, updated_at)
    VALUES (OLD.id, OLD.salary, NEW.salary, NOW());
END;

CREATE TRIGGER before_price_update
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Price cannot be negative';
    END IF;
END;

-------------- Events------------------

-- event take place in schedule manner and predefined for event


select *
from parks_and_recreation.employee_demographics;
DELIMITER $$

CREATE EVENT delete_retirees
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    DELETE
    FROM parks_and_recreation.employee_demographics
    WHERE age >= 60;
END $$

DELIMITER ;
 
     
  SHOW variables LIKE 'event%';
 