CREATE DATABASE SQL_EX4;

USE SQL_EX4;

CREATE TABLE PLAYERS (
	PLAYER_ID INTEGER PRIMARY KEY,
	GROUP_ID INTEGER NOT NULL
);

CREATE TABLE matches (
	match_id INTEGER PRIMARY KEY,
	first_player INTEGER NOT NULL,
	second_player INTEGER NOT NULL,
	first_score INTEGER NOT NULL,
	second_score INTEGER NOT NULL
);

INSERT INTO PLAYERS VALUES
	(20,2),
    (30,1),
    (40,3),
    (45,1),
    (50,2),
    (65,1);
    
INSERT INTO MATCHES VALUES
	(1,30,45,10,12),
    (2,20,50,5,5),
    (13,65,45,10,10),
    (5,30,65,3,15),
    (42,45,65,8,4);

WITH PLAYER_SCORE_PER_MATCH AS (
	SELECT P.GROUP_ID, P.PLAYER_ID, M1.FIRST_SCORE AS SCORE
	FROM PLAYERS P LEFT JOIN MATCHES M1 ON P.PLAYER_ID = M1.FIRST_PLAYER
	UNION
	SELECT P.GROUP_ID, P.PLAYER_ID, M2.SECOND_SCORE AS SCORE
	FROM PLAYERS P LEFT JOIN MATCHES M2 ON P.PLAYER_ID = M2.SECOND_PLAYER
),
PLAYER_TOTAL_SCORE AS(
	SELECT GROUP_ID, PLAYER_ID, SUM(SCORE) AS TOTAL_SCORE
    FROM PLAYER_SCORE_PER_MATCH
    GROUP BY GROUP_ID, PLAYER_ID
    ORDER BY GROUP_ID, PLAYER_ID DESC
),
RESULT AS(
SELECT GROUP_ID, PLAYER_ID
FROM PLAYER_TOTAL_SCORE 
WHERE IFNULL(TOTAL_SCORE, 0) IN (SELECT MAX(IFNULL(TOTAL_SCORE,0)) FROM PLAYER_TOTAL_SCORE GROUP BY GROUP_ID)
)
SELECT GROUP_ID, MIN(PLAYER_ID)
FROM RESULT
GROUP BY GROUP_ID;

