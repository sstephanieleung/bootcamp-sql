show databases;

create database db_bc2311;

use db_bc2311;

CREATE USER 'stephanieleung'@'localhost' IDENTIFIED BY 'admin';

ALTER USER 'stephanieleung'@'localhost' IDENTIFIED BY 'admin1234';

SELECT USER FROM mysql. user;

DROP USER 'stephanie'@'localhost';

SHOW VARIABLES LIKE 'validate_password%';

GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'stephanieleung'@'localhost' WITH GRANT OPTION;

CREATE TABLE customer (
	id integer not null,
	cust_name varchar(50) not null,
	cust_email_addr varchar(30),
	cust_phone varchar(50)
);

-- delete all data (without where)
DELETE FROM customer WHERE id = 1;

-- Insert some more records...
INSERT into customer (id, cust_name, cust_email_addr,cust_phone) values (1, 'John Lau', 'johnlau@gmail.com','23456578');
INSERT into customer (id, cust_name, cust_email_addr,cust_phone) values (2, 'Mary Wong', 'marywong@gmail.com','29585730');
INSERT into customer (id, cust_name, cust_email_addr,cust_phone) values (3, 'Sunny Chan', 'sunnychan@gmail.com','98746294');
INSERT into customer (id, cust_name, cust_email_addr,cust_phone) values (4, 'Christy Cheung', 'christycheung@gmail.com','92658165');
INSERT into customer (id, cust_name, cust_email_addr,cust_phone) values (5, 'Sunny Chan', 'sunnyc@gmail.com','92228165');

-- where
SELECT * FROM customer;

SELECT * FROM customer WHERE id = 1;
SELECT * FROM customer WHERE cust_name = 'John Lau' and cust_phone = '23456578';
SELECT * FROM customer WHERE (cust_name = 'John Lau' or cust_phone = '29585730') and cust_name = 'Mary Wong';

-- where + order by
SELECT * FROM CUSTOMER WHERE CUST_NAME = 'John Lau' OR CUST_EMAIL_ADDR = 'sunnychan@gmail.com' ORDER BY CUST_NAME; -- ascending by default
SELECT * FROM CUSTOMER WHERE CUST_NAME = 'John Lau' OR CUST_EMAIL_ADDR = 'sunnychan@gmail.com' ORDER BY CUST_NAME DESC;
SELECT * FROM CUSTOMER WHERE CUST_NAME = 'John Lau' OR CUST_NAME = 'Sunny Chan' ORDER BY CUST_NAME, CUST_PHONE;
SELECT * FROM CUSTOMER WHERE CUST_NAME IN ('John Lau','Sunny Wong') ORDER BY CUST_NAME, CUST_PHONE;

-- where -> like
SELECT * FROM customer WHERE cust_name LIKE '%Lau';
SELECT * FROM customer WHERE cust_email_addr LIKE '%@%' and cust_email_addr is null;

-- alter table add/modify/drop
ALTER TABLE CUSTOMER ADD JOIN_DATE DATE;

-- udpate
UPDATE CUSTOMER SET JOIN_DATE = '1990-01-01';
UPDATE CUSTOMER SET JOIN_DATE = STR_TO_DATE('1990-01-01','%Y-%m-%d'); 
UPDATE CUSTOMER SET JOIN_DATE = STR_TO_DATE('1990 01 01','%Y %m %d'); 
UPDATE CUSTOMER SET JOIN_DATE = STR_TO_DATE('2024-01-10','%Y-%m-%d') WHERE ID = 2;

-- varchar, integer, date, decimal, datetime
ALTER TABLE CUSTOMER ADD score decimal(5,2); -- 3 digit for integer, 2 digit for dicimal place, max value = 999.99, min value = -999.99

INSERT INTO CUSTOMER (ID, CUST_NAME, CUST_EMAIL_ADDR, CUST_PHONE, JOIN_DATE, SCORE) VALUES (6, 'Tom Chan', 'tomchan@gmail.com','91282375',str_to_date('2024-01-10','%Y-%m-%d'), 120.56);
UPDATE CUSTOMER SET SCORE = -999.99 WHERE ID = 6;

ALTER TABLE CUSTOMER ADD last_transaction_time DATETIME;
INSERT INTO CUSTOMER (ID, CUST_NAME, CUST_EMAIL_ADDR, CUST_PHONE, JOIN_DATE, SCORE, LAST_TRANSACTION_TIME) 
VALUES (7, 'Kay Tse', 'kaytse@gmail.com','91342275',str_to_date('2024-01-10','%Y-%m-%d'), 999.99, str_to_date('1990-01-01 20:20:23','%Y-%m-%d %H:%i:%s'));

UPDATE CUSTOMER SET SCORE = -999.99 WHERE ID = 6;

-- some other approaches to insert data
INSERT INTO CUSTOMER (ID, CUST_NAME, JOIN_DATE, SCORE, LAST_TRANSACTION_TIME) 
VALUES (7, 'Kay Tse', str_to_date('2024-01-10','%Y-%m-%d'), 999.99, str_to_date('1990-01-01 20:20:23','%Y-%m-%d %H:%i:%s'));

-- error, by default you should provide all column value when you skip the column description
-- INSERT INTO CUSTOMER
-- VALUES (7, 'Kay Tse', 'kaytse@gmail.com','91342275',str_to_date('2024-01-10','%Y-%m-%d'), 999.99, str_to_date('1990-01-01 20:20:23','%Y-%m-%d %H:%i:%s'));

INSERT INTO CUSTOMER 
VALUES (7, 'Kay Tse', 'kaytse@gmail.com','91342275',str_to_date('2024-01-10','%Y-%m-%d'), 999.99, str_to_date('1990-01-01 20:20:23','%Y-%m-%d %H:%i:%s'));

-- between and (inclusive)
SELECT * FROM CUSTOMER WHERE JOIN_DATE BETWEEN str_to_date('2023-01-01','%Y-%m-%d') AND str_to_date('2025-01-01','%Y-%m-%d');
SELECT * FROM CUSTOMER WHERE JOIN_DATE >= str_to_date('2023-01-01','%Y-%m-%d') AND JOIN_DATE < str_to_date('2025-01-01','%Y-%m-%d');


-- where : >, <, >=, <=
-- ifnull() function: Treat null value as another specified VALUES
SELECT * FROM CUSTOMER WHERE ifnull(SCORE, 100) > 0 AND ifnull(SCORE,100) < 1000;
TRUNCATE TABLE customer;

-- alter
ALTER TABLE CUSTOMER ADD DUMMY VARCHAR(10);
ALTER TABLE CUSTOMER DROP COLUMN DUMMY;
SELECT * FROM CUSTOMER;

-- alter table modify column
-- extend the length of the column
ALTER TABLE CUSTOMER MODIFY COLUMN CUST_EMAIL_ADDR VARCHAR(50); -- extend length from 30 - 50
-- shorten the length of the column
ALTER TABLE CUSTOMER MODIFY COLUMN CUST_EMAIL_ADDR VARCHAR(10); -- shorten length from 50 - 10, error, because some existing data's length
DROP TABLE customer;

--
SELECT ID, CUST_NAME JOIN_DATE FROM CUSTOMER WHERE SCORE > 100;

-- is null , is not null
SELECT ID, SCORE FROM CUSTOMER WHERE SCORE IS NOT NULL;

SELECT UPPER(CUST_NAME), LOWER(CUST_NAME), CUST_NAME FROM CUSTOMER;
SELECT C.CUST_NAME AS CUSTOMER_NAME_UPPER_CASE, 
LENGTH(C.CUST_NAME) AS CUSTOMER_NAME_LENGTH, 
substring(C.CUST_NAME,1,2) AS CUSTOMER_NAME_FIRST2, 
CONCAT(C.CUST_NAME, ', ',C.CUST_EMAIL_ADDR) AS CUSTOMER_NAME_EMAIL,
REPLACE(C.CUST_NAME, ' ', '') AS NEW_CUST_NAME,
LEFT (C.CUST_NAME, 3),
RIGHT(C.CUST_NAME,2),
TRIM(C.CUST_NAME),
instr(C.CUST_NAME, 'Chan') AS POSITION
FROM CUSTOMER C;

-- MySQL case-insensitive
SELECT * FROM CUSTOMER WHERE CUST_NAME = 'mary wong';  -- still can return, case-insensitive

SELECT * FROM CUSTOMER WHERE CUST_NAME COLLATE utf8mb4_bin = 'mary wong'; -- case sensitive check in MYSQL

-- %, _
SELECT * FROM CUSTOMER WHERE CUST_NAME LIKE '_hristy%';  -- _ means there must be ONE any character, cannot be ZERO

-- 
SELECT C.*, 1, 'DUMMY VALUE' AS DUMMY_COL FROM CUSTOMER C;

-- MATH
SELECT C.*
, 1 AS ONE
,'DUMMY VALUE' AS DUMMY_VAL
,ROUND(C.SCORE, 1) ROUND_SCORE  -- NUMBER OF DECIMAL IS FILLED
,ceil(C.SCORE) AS CEILING_SCORE
,floor(C.SCORE) AS FLOOR_SCORE
,abs(C.SCORE) AS ABS_SCORE
,JOIN_DATE
FROM CUSTOMER C;

SELECT date_add(JOIN_DATE, INTERVAL 3 MONTH)
,date_add(JOIN_DATE, INTERVAL 3 DAY)
,date_add(JOIN_DATE, INTERVAL 3 YEAR)
,datediff(JOIN_DATE, JOIN_DATE)
FROM CUSTOMER C;

SELECT date_sub(JOIN_DATE, INTERVAL 3 MONTH)
,date_sub(JOIN_DATE, INTERVAL 3 DAY)
,date_sub(JOIN_DATE, INTERVAL 3 YEAR)
,now() AS CURR_TIMESTAMP  -- RETURN DATETIME VALUE
FROM CUSTOMER C;

-- case
SELECT CUST_NAME
,SCORE
,CASE
	WHEN SCORE < 20 THEN 'FAIL'
	WHEN SCORE < 60 THEN 'PASS'
	WHEN SCORE < 100 THEN 'EXCELLENT'
	ELSE 'NA'
END AS GRADE
FROM CUSTOMER;

-- PRIMARY KEY IS ONE OF THE CONSTRAINT: NOT NULL, UNIQUE
CREATE TABLE department(
   id INTEGER PRIMARY KEY
   , dept_name VARCHAR(50)
   , dept_code VARCHAR(10)
);

CREATE TABLE employee(
	id INTEGER PRIMARY KEY
    , staff_id VARCHAR(50)
    , staff_name VARCHAR(50)
    , hkid VARCHAR(10) UNIQUE
    , dept_id INTEGER 
    , FOREIGN KEY (dept_id) REFERENCES department(id)
);

ALTER TABLE EMPLOYEE ADD country_id INTEGER;
ALTER TABLE EMPLOYEE ADD CONSTRAINT fk_count_id FOREIGN KEY (country_id) REFERENCES country (id);

CREATE TABLE country (
	id INTEGER PRIMARY KEY
    , country_code VARCHAR(2) UNIQUE
    , description VARCHAR(50)
);

INSERT INTO DEPARTMENT VALUES (1, 'Human Resources', 'HR');
INSERT INTO DEPARTMENT VALUES (2, 'Information Technology', 'IT');

INSERT INTO EMPLOYEE VALUES (1,'001', 'John Lau', 'A1234567', 2);
INSERT INTO EMPLOYEE VALUES (2,'002', 'Mary Chan', 'A2239482', 1);
INSERT INTO EMPLOYEE VALUES (3,'003', 'John Lau', 'A1234568', 2);

INSERT INTO COUNTRY VALUES(1,'HK','HONG KONG');
INSERT INTO COUNTRY VALUES(2,'CN','CHINA');

UPDATE EMPLOYEE SET COUNTRY_ID = 1;

SELECT * FROM EMPLOYEE;

-- INNER JOIN
SELECT *
FROM EMPLOYEE INNER JOIN DEPARTMENT; -- EMPLOYEE TABLE TIMES DEPARTMENT TABLE (CROSS)

SELECT E.STAFF_ID, E.STAFF_NAME, D.DEPT_NAME, D.DEPT_CODE
FROM EMPLOYEE E INNER JOIN DEPARTMENT D ON E.DEPT_ID = D.ID  -- ONLY RETURN RECORDS THAT FULFILL MATCHING CRITERIA
ORDER BY E.STAFF_ID;

SELECT E.STAFF_ID, E.STAFF_NAME, D.DEPT_NAME, D.DEPT_CODE
FROM DEPARTMENT D INNER JOIN EMPLOYEE E ON E.DEPT_ID = D.ID  -- ONLY RETURN RECORDS THAT FULFILL MATCHING CRITERIA
ORDER BY E.STAFF_ID;

SELECT E.STAFF_ID, E.STAFF_NAME, D.DEPT_NAME, D.DEPT_CODE, C.DESCRIPTION
FROM EMPLOYEE E 
INNER JOIN DEPARTMENT D ON E.DEPT_ID = D.ID
INNER JOIN COUNTRY C ON E.COUNTRY_ID = C.ID -- ONLY RETURN RECORDS THAT FULFILL MATCHING CRITERIA
ORDER BY E.STAFF_ID;

-- Alternative way to perform Inner join XX ON XX
SELECT E.ID, E.STAFF_ID, E.STAFF_NAME, D.DEPT_NAME, D.DEPT_CODE, C.COUNTRY_CODE
FROM EMPLOYEE E, DEPARTMENT D, COUNTRY C
WHERE E.DEPT_ID = D.ID
AND E.COUNTRY_ID = C.ID;

-- Left join
INSERT INTO DEPARTMENT VALUES (3, 'Marketing', 'HK');

SELECT D.*, E.*
FROM DEPARTMENT D LEFT JOIN EMPLOYEE E ON E.DEPT_ID = D.ID;

-- group by
select * from employee;
insert into employee values(4, '004', 'Peter Chan', 'A1234509', 3, 2,18);
select e.dept_id, count(1) as number_of_employee
from employee e
group by e.dept_id;

-- add column year of exp
alter table employee add year_of_exp integer;
select * from employee;
update employee set year_of_exp = 1 where id=2;
update employee set year_of_exp = 10 where id=1;
update employee set year_of_exp = 5 where id=3;
update employee set year_of_exp = 18 where id=4;

-- group by: max(year_of_exp)
select e.dept_id, e.staff_name
from employee E
group by e.dept_id;

-- group by: max(year_of_exp)
select e.dept_id, min(YEAR_OF_EXP)
from employee E
group by e.dept_id;

-- GROUP BY: AVG(YEAR_OF_EXP)
SELECT AVG(YEAR_OF_EXP), STAFF_NAME FROM EMPLOYEE; -- THIS IS INVALID PROMPT BECAUSE AGGREAGATE FUNCTION ONLY RETURN 1 ROW OF RECORD,
												   -- WHICH CONSIDER ALL RECORDS IN THE WHOLE TABLE
                                          
-- Find staff_name who has the max year of EXPLAIN
-- select max(year_of_exp), staff_name from employee
SELECT *
FROM EMPLOYEE
WHERE YEAR_OF_EXP = (SELECT MAX(YEAR_OF_EXP) FROM EMPLOYEE);

-- CTE
WITH MAX_YEAR_OF_EXP AS (  -- INTEGRATED TABLE NAME
	SELECT MAX(YEAR_OF_EXP) AS MAX_EXP -- COLUMN NAME
    FROM EMPLOYEE 
) 
SELECT * 
FROM EMPLOYEE E, MAX_YEAR_OF_EXP M
WHERE E.YEAR_OF_EXP = M.MAX_EXP;

-- GROUP BY + JOIN
SELECT DEPT_ID, COUNT(1) AS NUMBER_OF_EMPLOYEE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.ID
AND D.DEPT_CODE IN ('IT', 'MK') -- FILTER RECORD BEFORE GROUP BY
GROUP BY E.DEPT_ID HAVING COUNT(1) > 1; -- FILTER RECORD AFTER GROUP BY

SELECT * 
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_ID = D.ID;

SELECT * FROM DEPARTMENT;

-- DISTINCT MORE THAN ONE FIELD (CHECKING IF THE VALUES IN ALL FIELDS ARE DUPLICATED)
SELECT DISTINCT * FROM EMPLOYEE;

SELECT * FROM EMPLOYEE E JOIN DEPARTMENT D
WHERE E.DEPT_ID = D.ID;

UPDATE DEPARTMENT SET DEPT_CODE = 'MK' WHERE ID = 3;

DELETE FROM customer WHERE id= 1;
