/* Create a visualization that provides a breakdown between the male and female employees 
working in the company each year, starting from 1990. */

select emp_no, from_date, to_date from t_dept_emp;
select distinct  emp_no, from_date, to_date from t_dept_emp
order by from_date Asc ;  
use employees_mod;
# syntax that provides info of breakdown between M and F employees woking in comapny each year starting from year 1990 
SELECT 
    YEAR(d.from_date) AS calander_year,
    e.gender,
    COUNT(e.emp_no) AS no_of_employees
FROM
    t_employees e
        JOIN
    t_dept_emp d ON d.emp_no = e.emp_no
GROUP BY calander_year , e.gender
HAVING calander_year >= 1990
ORDER BY calander_year;  


/* Compare the number of male managers to the number of female managers from different
 departments for each year, starting from 1990.*/
 
select * from t_departments;
select * from t_employees;
select * from t_dept_manager;
select * from t_dept_manager
where from_date = '1990-12-30'<'1990' < '1998-12-29';

select d.dept_name,
       ee.gender,
       dm.emp_no,
       dm.from_date,
       dm.to_date,
       e.calender_year,
       case
          when dm.from_date >='1995-12-30' And to_date <= '1998-12-29' then 1 
          else 0
       End as active
from 
 ( select year(hire_date) as calender_year from t_employees) e 
 cross join
 t_dept_manager dm on ee.emp_no = dm.emp_no
 join
 t_departments d on dm.dept_no = d.dept_no
 join
 t_employees ee on d.dept_no= ee.emp_no
 order by emp_no, calender_year ;
 
/*Compare the average salary of female versus male employees in the entire company
 until year 2002, and add a filter allowing you to see that per each department.*/
 
SELECT 
    e.gender,
    d.dept_name,
    ROUND(AVG(s.salary), 2) AS salary,
    YEAR(s.from_date) AS calendar_year
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , calendar_year
HAVING calendar_year <= 2002
ORDER BY d.dept_no;

/* Create an SQL stored procedure that will allow you to obtain the average male and
 female salary per department within a certain salary range. Let this range be
 defined by two values the user can insert when calling the procedure.*/
 
 DROP PROCEDURE IF EXISTS filter_salary;
 
 DELIMITER $$
CREATE PROCEDURE filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
SELECT 
    e.gender, d.dept_name, AVG(s.salary) as avg_salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
    WHERE s.salary BETWEEN p_min_salary AND p_max_salary
GROUP BY d.dept_no, e.gender;
END$$

DELIMITER ;

CALL filter_salary(50000, 90000);
       
