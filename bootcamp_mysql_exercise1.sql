CREATE DATABASE BOOTCAMP_EXERCISE1;
USE BOOTCAMP_EXERCISE1;

CREATE TABLE regions (
	region_id INTEGER PRIMARY KEY
    , region_name VARCHAR(25)
);
INSERT INTO regions VALUES (1,'Europe');
INSERT INTO regions VALUES (2,'North America');
INSERT INTO regions VALUES (3,'Asia');
SELECT * FROM regions;

CREATE TABLE countries (
	country_id CHAR(2) PRIMARY KEY
    , country_name VARCHAR(40)
    , region_id INTEGER
    , FOREIGN KEY (region_id) REFERENCES regions (region_id)
);
-- According to ISO-3166-1 alpha2
INSERT INTO countries VALUES ('DE', 'Germany', 1);
INSERT INTO countries VALUES ('IT', 'Italy', 1);
INSERT INTO countries VALUES ('JP','Japan', 3);
INSERT INTO countries VALUES ('US', 'United States', 2);
SELECT * FROM countries ORDER BY country_id;

CREATE TABLE locations (
	location_id INTEGER PRIMARY KEY
    , street_address VARCHAR(25)
    , postal_code VARCHAR(12)
    , city VARCHAR(30)
    , state_province VARCHAR(12)
    , country_id CHAR(2)
    , FOREIGN KEY (country_id) REFERENCES countries (country_id)
);
INSERT INTO locations VALUES (1000,'1297 Via Cola di die', '989', 'Roma', null, 'IT');
INSERT INTO locations VALUES (1100,'93091 Calle della Te', '10934', 'Venice', null, 'IT');
INSERT INTO locations VALUES (1200,'2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo JP', 'JP');
INSERT INTO locations VALUES (1400,'2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
SELECT * FROM locations;

CREATE TABLE departments (
	department_id INTEGER PRIMARY KEY
    , department_name VARCHAR(20)
    , manager_id INTEGER
    , location_id INTEGER
    , FOREIGN KEY (location_id) REFERENCES locations (location_id)
);
INSERT INTO departments VALUES (10,'Administration', 200, 1100);
INSERT INTO departments VALUES (20, 'Marketing', 201, 1200);
INSERT INTO departments VALUES (30, 'Purchasing', 202, 1400);
SELECT * FROM departments;

CREATE TABLE jobs (
	job_id VARCHAR(10) PRIMARY KEY
    , job_title VARCHAR(35)
    , min_salary DECIMAL(8,2)
    , max_salary DECIMAL(8,2)
);
INSERT INTO jobs VALUES('IT_PROG','Programmer', 15000.00, 30000.00);
INSERT INTO jobs VALUES('MK_REP','Marketing Representative', 9000.00, 25000.00);
INSERT INTO jobs VALUES('ST_CLERK','Cleck', 12000.00, 25000.00);
SELECT * FROM jobs;

CREATE TABLE employees (
	employee_id INTEGER PRIMARY KEY
    , first_name VARCHAR(20)
    , last_name VARCHAR(25)
    , email VARCHAR(25) UNIQUE
    , phone_number VARCHAR(20)
    , hire_date DATE
    , job_id VARCHAR(10)
    , salary DECIMAL(8,2)
    , commission_pct DECIMAL(8,2)
    , manager_id INTEGER
    , department_id INTEGER
	, FOREIGN KEY (job_id) REFERENCES jobs (job_id)
    , FOREIGN KEY (department_id) REFERENCES departments (department_id)
);
INSERT INTO employees VALUES(100,'Steven','King','SKING','515-1234567', str_to_date('1987-06-17', '%Y-%m-%d'),'ST_CLERK', 24000.00, 0.00, 109, 10);
INSERT INTO employees VALUES(101,'Neena','Kochhar','NKOCHHAR','515-1234568', str_to_date('1987-06-18', '%Y-%m-%d'),'MK_REP', 17000.00, 0.00, 103, 20);
INSERT INTO employees VALUES(102,'Lex','De Haan','LDEHAAN','515-1234569', str_to_date('1987-06-19', '%Y-%m-%d'),'IT_PROG', 17000.00, 0.00, 108, 30);
INSERT INTO employees VALUES(103,'ALexender','Hunold','AHUNOLD','590-4234567', str_to_date('1987-06-20', '%Y-%m-%d'),'MK_REP', 9000.00, 0.00, 105, 20);
SELECT * FROM employees;

CREATE TABLE job_history (
    employee_id INTEGER,
    start_date DATE,
    end_date DATE,
    job_id VARCHAR(10),
    department_id INTEGER,
    PRIMARY KEY (employee_id , start_date),
    FOREIGN KEY (job_id)
        REFERENCES jobs (job_id),
    FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
);

INSERT INTO job_history VALUES(102, str_to_date('1998-01-13', '%Y-%m-%d'), str_to_date('1998-07-24', '%Y-%m-%d'), 'IT_PROG', 20);
INSERT INTO job_history VALUES(101, str_to_date('1989-09-21', '%Y-%m-%d'), str_to_date('1993-10-27', '%Y-%m-%d'), 'MK_REP', 10);
INSERT INTO job_history VALUES(101, str_to_date('1993-10-28', '%Y-%m-%d'), str_to_date('1997-03-15', '%Y-%m-%d'), 'MK_REP', 30);
INSERT INTO job_history VALUES(100, str_to_date('1996-02-17', '%Y-%m-%d'), str_to_date('1999-12-19', '%Y-%m-%d'), 'ST_CLERK', 30);
INSERT INTO job_history VALUES(103, str_to_date('1998-03-24', '%Y-%m-%d'), str_to_date('1999-12-31', '%Y-%m-%d'), 'MK_REP', 20);
SELECT * FROM job_history;

-- QUEST 3
SELECT location_id, street_address, city, state_province, country_name 
FROM locations l, countries c
WHERE l.country_id = c.country_id;

-- QUEST 4
SELECT first_name, last_name, department_id 
FROM employees;

-- QUEST 5
SELECT e.first_name, e.last_name, e.job_id, e.department_id 
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id
INNER JOIN countries c ON l.country_id = c.country_id
INNER JOIN regions r ON c.region_id = r.region_id
WHERE c.country_name = 'Japan';

-- QUEST 6
SELECT e.employee_id, e.last_name, e.manager_id, m.last_name 
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;

-- QUEST 7
SELECT e.first_name, e.last_name, e.hire_date
FROM employees e
WHERE e.hire_date < (
	SELECT hire_date 
	FROM employees 
    WHERE first_name = 'Lex' 
    AND last_name = 'De Haan'
);

-- QUEST 8
SELECT d.department_name, count(1) AS number_of_employees
FROM  departments d, employees e
WHERE d.department_id = e.department_id
GROUP BY d.department_id;

-- QUEST 9
SELECT e.employee_id, j.job_title, sum(jh.end_date - jh.start_date) AS number_of_days
FROM employees e, jobs j, job_history jh
WHERE e.job_id = j.job_id
AND j.job_id = jh.job_id
AND jh.job_id = 30
GROUP BY e.employee_id;

-- QUEST 10
INSERT INTO jobs VALUES ('MGR','Department Manager', 30000.00, 50000.00);
INSERT INTO employees VALUES(200,'Nacy','Chan','NCHAN','852-98765432', str_to_date('1992-03-20', '%Y-%m-%d'),'MGR', 30000.00, 0.00, NULL, 10);
INSERT INTO employees VALUES(201,'Vincent','Lau','VLAU','852-98887777', str_to_date('1993-08-01', '%Y-%m-%d'),'MGR', 40000.00, 0.00, NULL, 20);
INSERT INTO employees VALUES(202,'Oscar','Lo','OLO','852-98776666', str_to_date('1994-09-28', '%Y-%m-%d'),'MGR', 30000.00, 0.00, NULL, 30);
SELECT d.department_name, concat(e.first_name,' ', e.last_name) as manager_name, l.city, c.country_name
FROM departments d, employees e, locations l, countries c
WHERE d.manager_id = e.employee_id
AND d.location_id = l.location_id
AND l.country_id = c.country_id;

-- QUEST 11
SELECT d.department_name, round(avg(e.salary),2) AS average_salary
FROM employees e, departments d
GROUP BY d.department_id;

-- QUEST 12
-- ANSWER: in the jobs table, it only consist of the job code and the description within the company, without linkage to department information
-- To modify the jobs table, the following commands is required:
ALTER TABLE jobs ADD department_id INTEGER;
ALTER TABLE jobs ADD CONSTRAINT fk_dept_id FOREIGN KEY (department_id) REFERENCES departments (department_id);

-- Besides, with the application of job_grade table
-- it is not necessary to write min, max salary in jobs table as all jobs will belongs to one job grading in the job_grade table
-- Instead, grade_level field will need to be added to the jobs table
CREATE TABLE job_grades (
	grade_level VARCHAR(2) PRIMARY KEY
    , lowest_sal DECIMAL(8,2)
    , highest_sal DECIMAL(8,2)
);
ALTER TABLE jobs DROP COLUMN min_salary;
ALTER TABLE jobs DROP COLUMN max_salary;
ALTER TABLE jobs ADD grade_level VARCHAR(2), ADD CONSTRAINT fk_grade_level FOREIGN KEY (grade_level) REFERENCES job_grades (grade_level);


