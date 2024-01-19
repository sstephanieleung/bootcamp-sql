CREATE TABLE nationality(
	id serial primary key, -- auto-incrementing integer
	nat_code VARCHAR(2) UNIQUE,
	nat_desc VARCHAR(50) NOT NULL
);
INSERT INTO nationality (nat_code, nat_desc) VALUES 
	('HK','Hong Kong'), 
	('SG', 'Singapore');
SELECT * FROM nationality;

-- 1-to-N Example: An author wrote many books
CREATE TABLE author(
	id serial primary key, -- auto-incrementing integer
	author_name VARCHAR(50) NOT NULL,
	nat_code VARCHAR(2),
	CONSTRAINT fk_author_nat_code FOREIGN KEY (nat_code) REFERENCES nationality (nat_code)
);
INSERT INTO author (author_name, nat_code) VALUES 
	('Vincent Lau', 'HK'), 
	('Oscar Lo', 'SG');
SELECT * FROM author;

CREATE TABLE book(
	id serial primary key, -- auto-incrementing integer
	author_id integer,
	book_name VARCHAR(100) NOT NULL,
	CONSTRAINT fk_book_author_id FOREIGN KEY (author_id) REFERENCES AUTHOR (id)
);
INSERT INTO book(author_id, book_name) VALUES 
	(1, 'What is Java'), 
	(2, 'Happy SQL');
INSERT INTO book(author_id, book_name) VALUES (1, 'PostgreSQL is funny');
SELECT * FROM book;

CREATE TABLE users(
	id serial primary key, -- auto-incrementing integer
	user_name VARCHAR(50) NOT NULL
);
INSERT INTO users (user_name) VALUES 
	('Vincent Lau'), 
	('Oscar Lo'), 
	('Chloe Poon'), 
	('Stephanie Leung');
	('')
SELECT * FROM users;

CREATE TABLE user_contact(
	id serial primary key, -- auto-incrementing integer
	user_id integer unique, -- fk -> one to one
	user_phone VARCHAR(50) UNIQUE,
	user_email VARCHAR(50) NOT NULL,
	CONSTRAINT fk_user_contact_user_id FOREIGN KEY (user_id) REFERENCES users(id) 
);
INSERT INTO user_contact (user_id, user_phone, user_email) VALUES
	(1,'98765432','vincentlau@gmail.com'),
	(2,'98766543','oscarlo@gmail.com'),
	(3,'98876665','chloepoon@gmail.com'),
	(4,'98776544','stephanieleung@gmail.com');
SELECT * FROM user_contact;
 
-- N-to-N Example: User can borrow multiple books, books can be borrowed by multiple person
CREATE TABLE borrow_history( -- book return history is recommended to use new table instead of merge with borrow table
	id serial primary key, -- auto-incrementing integer
	user_id integer NOT NULL,
	book_id integer NOT NULL,
	borrow_date TIMESTAMP NOT NULL,
	CONSTRAINT fk_borrow_history_user_id FOREIGN KEY (user_id) REFERENCES users(id),
	CONSTRAINT fk_borrow_history_book_id FOREIGN KEY (book_id) REFERENCES book(id)
);
INSERT INTO borrow_history (user_id, book_id, borrow_date) VALUES
	(3,1,TO_TIMESTAMP('2024-01-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS')),
	(3,2,TO_TIMESTAMP('2024-01-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS')),
	(4,1,TO_TIMESTAMP('2024-01-14 14:30:00', 'YYYY-MM-DD HH24:MI:SS')),
	(1,2,TO_TIMESTAMP('2024-01-15 14:30:00', 'YYYY-MM-DD HH24:MI:SS'));
SELECT * FROM borrow_history;

SELECT bh.borrow_date
, u.user_name
, b.book_name
, a.author_name
, n.nat_code as author_nat_code
, n.nat_desc as author_nat_desc
FROM borrow_history bh, users u, book b, author a, nationality n
WHERE bh.book_id = b.id
AND bh.user_id = u.id
AND b.author_id = a.id
AND a.nat_code = n.nat_code
ORDER BY bh.borrow_date desc;

-- One to Many
CREATE TABLE return_history(
	id serial primary key,
	borrow_id integer UNIQUE NOT null,
	return_date TIMESTAMP NOT NULL,
	CONSTRAINT fk_return_history_borrow_id FOREIGN KEY (borrow_id) REFERENCES borrow_history (id)
);

INSERT INTO return_history (borrow_id, return_date) VALUES
	(1,TO_TIMESTAMP('2024-01-07 14:30:00', 'YYYY-MM-DD HH24:MI:SS')),
	(2,TO_TIMESTAMP('2024-01-07 14:30:00', 'YYYY-MM-DD HH24:MI:SS')),
	(4,TO_TIMESTAMP('2024-01-20 14:30:00', 'YYYY-MM-DD HH24:MI:SS')),
	(3,TO_TIMESTAMP('2024-01-21 14:30:00', 'YYYY-MM-DD HH24:MI:SS'));
SELECT * FROM borrow_history;

--Exercise: Find the user (user_name), who has the longest total book borrowing time (no of day, ignore timestamp)
With borrow_days AS (
	SELECT u.user_name, sum(rh.return_date - bh.borrow_date) AS days_of_borrow
	FROM return_history rh, borrow_history bh, users u
	WHERE rh.borrow_id = bh.id
	AND bh.user_id = u.id
	GROUP BY u.user_name
)
SELECT * FROM borrow_days
WHERE days_of_borrow = (SELECT max(days_of_borrow) FROM borrow_days);

-- Answer:
WITH borrow_day_per_user AS (
	SELECT bh.user_id, sum(Extract(DAY FROM (rh.return_date = bh.borrow_date))) AS horrow_days
	FROM borrow_history bh, return_history rh, users u
	WHERE bh.id = rh.borrow_id
	AND u.id = bh.user_id
	GROUP BY bh.user_id
)
SELECT bd.user_id, u.user_name, bh.borrow_days
FROM borrow_days_per_user bd, users u
WHERE borrow_days in (SELECT max(borrow_days from borrow days_per_user))
AND bd.user_id = u.id;

-- Find the book(s) , which has no borrow history
SELECT b.id, b.book_name FROM book b
WHERE NOT EXISTS (SELECT DISTINCT bh.book_id FROM borrow_history bh WHERE bh.book_id = b.id);

--Answer 1: NOT EXISTS
SELECT * FROM BOOK B WHERE NOT EXISTS (SELECT 1 FROM BORROW_HISTORY BH WHERE);

--Answer 2: LEFT JOIN
SELECT * FROM BOOK B LEFT JOIN BORROW_HISTORY BH ON BH.BOOK_ID = B.ID
WHERE BH.BOOK_ID IS NULL

-- Find all user and books, no matter the user or book has borrow history
SELECT * FROM (
	-- u.user_name, b.book_name EXIST in borrow_history
	SELECT u.user_name, b.book_name
	FROM users u, borrow_history bh, book b 
	WHERE u.id = bh.user_id
	AND b.id = bh.book_id
	UNION
	-- u.user_name NOT EXIST in borrow_history
	SELECT u.user_name, null as book_name
	FROM users u
	WHERE NOT EXISTS (SELECT 1 FROM borrow_history bh WHERE u.id = bh.user_id)
	UNION
	-- b.book_name NOT EXIST in borrow_history
	SELECT null as user_name, b.book_name
	FROM book b
	WHERE NOT EXISTS (SELECT 1 FROM borrow_history bh WHERE b.id = bh.book_id)
)
ORDER BY user_name;

SELECT u.user_name, b.book_name
FROM borrow_history bh
FULL OUTER JOIN users u ON u.id = bh.user_id
FULL OUTER JOIN book b ON b.id = bh.book_id


-- CREATE VIEW
DROP VIEW VUSER_BORROW_HISTORY;

CREATE VIEW VUSER_BORROW_HISTORY
AS
SELECT U.USER_NAME, BH.*
FROM USERS U LEFT JOIN BORROW_HISTORY BH ON U.ID = BH.USER_ID;

-- EXECUTE VIEW
-- 1. YOU CANNOT INSERT/UPDATE IN A VIEW ACCESS THE PHYSICAL TABLE AT REAL TIME.
-- 2. HIDE UNRELATED DATEA TO THE VIEW USER.

SELECT * 
FROM VUSER_BORROW_HISTORY
WHERE USER_NAME LIKE '%Vincent%';

CREATE MATERIALIZED VIEW MV_USERS_BORROW_HISTORY
AS
SELECT U.USER_NAME, BH.BOOK_ID, BH.USER_ID, BH.BORROW_DATE
FROM USERS U LEFT JOIN BORROW_HISTORY BH ON U.ID = BH.USER_ID;

INSERT INTO USERS (USER_NAME) VALUES ('Steven Chan');

--
SELECT * FROM MV_USERS_BORROW_HISTORY; -- Captured virtual table, any updates after table created is not included.
--
SELECT * FROM VUSER_BORROW_HISTORY; -- Real-time Capture virtual table as RUN

-- SAMPLE OF CREATE PROCEDURE
CREATE OR REPLACE FUNCTION CREATE_USER (IN USER_NAME VARCHAR) RETURNS VOID AS $$
BEGIN
	INSERT INTO USERS VALUES (USER_NAME);
	-- YOU CAN DO HUNDREDS OF CODE HERE--
END;
$$ LANGUAGE plpgsql;

-- TASK: CREATE A PROCEDURE / FUNCTION TO AUTOMATE MANAGEMENT REPORT DATA EXTRACTION
DROP TABLE report_management_id_1;

CREATE TABLE report_management_id_1 (
	report_id SERIAL PRIMARY KEY,
	report_date VARCHAR NOT NULL,
	borrow_month VARCHAR NOT NULL,
	user_id INTEGER,
	number_book INTEGER NOT NULL,
	CONSTRAINT fk_report_user_id FOREIGN KEY (user_id) REFERENCES users (id)
);

SELECT CURRENT_DATE

-- in Oracle....
CREATE OR REPLACE FUNCTION INSERT_MANAGEMENT_REPORT (IN BORROW_YEAR VARCHAR) RETURN VOID AS $$
	CURSOR C_BORROW_HISTORY (IN PI_BORROW_YEAR VARCHAR)
	IS
		SELECT TO_CHAR(BH.BORROW_DATE, 'YYYYMM') AS borrow_month, BH.USER_ID, COUNT(1) AS NUMBER_OF_BOOK
		FROM BORROW_HISTORY BH
		WHERE TO_CHAR(BH.BORROW_DATE, 'YYYY') = PI_BORROW_YEAR
		GROUP BY TO_CHAR(BH.BORROW_DATE, 'YYYYMM'), BH.USER_ID;
BEGIN
	FOR RECORD IN C_BORROW_HISTORY LOOP
		INSERT INTO REPORT_MANAGEMENT_ID_1 (REPORT_DATE, BORROW_MONTH, USER_ID, NUMBER_OF_BOOK)
		VALUES (CURRENT_DATE, RECORD.BORROW_MONTH, RECORD.USER_ID, RECORD.NUMBER_OF_BOOK);
	END LOOP;
END;
$$ LANGUAGE PLPGSQL

-- in PostgreSQL...
DROP FUNCTION INSERT_MANAGEMENT_REPORT;
CREATE OR REPLACE FUNCTION INSERT_MANAGEMENT_REPORT (IN PI_BORROW_YEAR VARCHAR) RETURNS VOID AS $$
DECLARE 
	rec record; --record, means follow the returned field from the select statement.
BEGIN
	FOR rec IN
		SELECT to_char(BH.BORROW_DATE, 'YYYYMM') AS borrow_month, 
			BH.USER_ID, 
			COUNT(1) AS NUMBER_OF_BOOK
		FROM BORROW_HISTORY BH
		WHERE TO_CHAR(BH.BORROW_DATE, 'YYYY') = PI_BORROW_YEAR
		GROUP BY TO_CHAR(BH.BORROW_DATE, 'YYYYMM'), BH.USER_ID
	LOOP
		IF rec.NUMBER_OF_BOOK > 1 THEN
			INSERT INTO REPORT_MANAGEMENT_ID_1 (REPORT_DATE, BORROW_MONTH, USER_ID, NUMBER_BOOK)
			VALUES (CURRENT_DATE, rec.BORROW_MONTH, rec.USER_ID, rec.NUMBER_OF_BOOK);
		END IF;
	END LOOP;
END;
$$ LANGUAGE PLPGSQL;

TRUNCATE TABLE REPORT_MANAGEMENT_ID_1;
ALTER SEQUENCE report_management_id_1_report_id_seq RESTART WITH 1;
SELECT INSERT_MANAGEMENT_REPORT('2024');
SELECT * FROM REPORT_MANAGEMENT_ID_1;


-- TABLE TRIGGER
ALTER TABLE USERS ADD BORROW_TIMES INTEGER NOT NULL DEFAULT 0;

-- when someone insert data into borrow_history, users.borrow_times + 1 (update)
CREATE OR REPLACE FUNCTION borrow_times_increment()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE USERS SET BORROW_TIMES = BORROW_TIMES +1
	WHERE ID = NEW.USER_ID;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER my_trigger
AFTER INSERT  -- or BEFORE/AFTER INSERT/UPDATE/DELETE
ON borrow_history
FOR EACH ROW
EXECUTE FUNCTION borrow_times_increment();

-- trigger event(insert into borrow_history)
INSERT INTO borrow_history (user_id, book_id, borrow_date) VALUES
	(5,2,TO_TIMESTAMP('2024-01-17 14:32:00', 'YYYY-MM-DD HH24:MI:SS'));
	
SELECT * FROM USERS;