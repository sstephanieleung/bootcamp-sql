CREATE DATABASE BOOTCAMP_EXERCISE1;

USE BOOTCAMP_EXERCISE1;

CREATE TABLE regions (
	region_id INTEGER PRIMARY KEY
    , region_name VARCHAR(25)
);

CREATE TABLE countries (
	country_id CHAR(2) PRIMARY KEY
    , country_name VARCHAR(40)
    , region_id INTEGER
    , FOREIGN KEY (region_id) REFERENCES regions (region_id)
    
);

CREATE TABLE locations (
	location_id INTEGER PRIMARY KEY
    , street_address VARCHAR(25)
    , postal_code VARCHAR(12)
    , city VARCHAR(30)
    , state_province VARCHAR(12)
    , country_id CHAR(2)
    , FOREIGN KEY (country_id) REFERENCES countries (country_id)
);

CREATE TABLE departments (
	department_id INTEGER PRIMARY KEY
    , department_name VARCHAR(20)
    , manager_id INTEGER
    , location_id INTEGER
    , FOREIGN KEY (location_id) REFERENCES locations (location_id)
);

CREATE TABLE jobs (
	job_id VARCHAR(10) PRIMARY KEY
    , job_title VARCHAR(35)
    , min_salary DECIMAL(8,2)
    , max_salary DECIMAL(8,2)
);

CREATE TABLE employees (
	employee_id INTEGER PRIMARY KEY
    , first_name VARCHAR(20)
    , last_name VARCHAR(25)
    , email VARCHAR(25)
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

CREATE TABLE job_history (
	employee_id INTEGER
    , start_date DATE
    , end_datet DATE
    , job_id VARCHAR(10)
    , department_id INTEGER
    , PRIMARY KEY (employee_id, start_date)
    , FOREIGN KEY (job_id) REFERENCES jobs (job_id)
    , FOREIGN KEY (department_id) REFERENCES departments (department_id)
);

CREATE TABLE job_grades (
	grade_level VARCHAR(2) PRIMARY KEY
    , lowest_sal DECIMAL(8,2)
    , highest_sal DECIMAL(8,2)
);

INSERT INTO regions VALUES (1,'Asia');
INSERT INTO regions VALUES (2,'Africa');
INSERT INTO regions VALUES (3,'North America');
INSERT INTO regions VALUES (4,'South America');
INSERT INTO regions VALUES (5,'Europe');
INSERT INTO regions VALUES (6,'Australia');

SELECT * FROM regions;

-- According to ISO-3166-1 alpha2
INSERT INTO countries VALUES ('HK','Hong Kong', 1);
INSERT INTO countries VALUES ('CN','China', 1);
INSERT INTO countries VALUES ('JP','Japan', 1);
INSERT INTO countries VALUES ('KP','Korea, People''s Republic of', 1);
INSERT INTO countries VALUES ('KR','Korea, Republic of ', 1);
INSERT INTO countries VALUES ('CD','Congo, Democratic Republic of the', 2);
INSERT INTO countries VALUES ('CF','Central African Republic', 2);
INSERT INTO countries VALUES ('EG','Egypt', 2);
INSERT INTO countries VALUES ('CG', 'Congo', 2);
INSERT INTO countries VALUES ('CA', 'Canada', 3);
INSERT INTO countries VALUES ('GL', 'Greenland', 3);
INSERT INTO countries VALUES ('US', 'United States of America', 3);
INSERT INTO countries VALUES ('CU', 'Cuba', 4);
INSERT INTO countries VALUES ('DM', 'Dominica', 4);
INSERT INTO countries VALUES ('AT', 'Austria', 5);
INSERT INTO countries VALUES ('BE', 'Belgium', 5);
INSERT INTO countries VALUES ('DK', 'Denmark', 5);
INSERT INTO countries VALUES ('FR', 'France', 5);
INSERT INTO countries VALUES ('DE', 'Germany', 5);
INSERT INTO countries VALUES ('ES', 'Spain', 5);
INSERT INTO countries VALUES ('GB', 'United Kingdom', 5);
INSERT INTO countries VALUES ('AU', 'Australia', 6);
INSERT INTO countries VALUES ('NZ', 'New Zealand', 6);

SELECT * FROM countries
ORDER BY country_id;

INSERT INTO 



	