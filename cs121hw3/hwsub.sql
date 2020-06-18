-- [Problem 1a]
SELECT SUM(perfectscore) as course_perfectscore
    FROM assignment;

-- [Problem 1b]
SELECT sec_name, COUNT(username) as num_students
    FROM student NATURAL JOIN section
    GROUP BY sec_name;

-- [Problem 1c]
CREATE VIEW totalscores AS 
    SELECT username, SUM(score) as tot_score
    FROM student NATURAL JOIN submission
    WHERE graded = 1
    GROUP BY username;

-- [Problem 1d]
CREATE VIEW passing AS
    SELECT username, tot_score
    FROM totalscores
    WHERE tot_score >= 40;

-- [Problem 1e]
CREATE VIEW failing AS
    SELECT username, tot_score
    FROM totalscores
    WHERE tot_score < 40;

-- [Problem 1f]
/* 
* find all the people that are passing and the assignments and check to see if 
* the submission id is in fileset in order to see if it was actually submitted 
*/ 

SELECT DISTINCT username
    FROM passing NATURAL JOIN assignment NATURAL JOIN submission
    WHERE shortname LIKE 'lab%' AND sub_id NOT IN (SELECT sub_id from fileset);

/*
* harris
* ross
* miller
* turner
* edwards
* murphy
* simmons
* tucker
* coleman
* flores
* gibson
*/

-- [Problem 1g]
/* 
* same thing as 1f except where condition is being compared 
* to midterm and final instead 
*/ 

SELECT DISTINCT username
    FROM passing NATURAL JOIN assignment NATURAL JOIN submission
    WHERE ((shortname LIKE 'midterm' OR shortname LIKE 'final') AND 
        sub_id NOT IN (SELECT sub_id from fileset));

# collins

-- [Problem 2a]
SELECT DISTINCT username
    FROM assignment NATURAL JOIN submission NATURAL JOIN fileset
    WHERE shortname LIKE 'midterm' AND sub_date > due;

-- [Problem 2b]
/*
* we count the number of labs submitted at each hour by 
* grouping by the hour from each submission time
*/ 

SELECT EXTRACT(HOUR FROM sub_date) as hour, COUNT(shortname) as num_submits
    FROM assignment NATURAL JOIN submission NATURAL JOIN fileset
    WHERE shortname LIKE 'lab%' 
    GROUP BY EXTRACT(HOUR FROM sub_date);

-- [Problem 2c]
/*
* counts the number of exams that have been submitted that 
* are finals and between the 30min prior to the due time and actual
* due time. The subtime function finds the time 30min prior
*/ 

SELECT COUNT(shortname) as num_exams
    FROM assignment NATURAL JOIN submission NATURAL JOIN fileset
    WHERE shortname LIKE 'final' AND sub_date 
        BETWEEN SUBTIME(due, '00:30:00') AND due;

-- [Problem 3a]
ALTER TABLE student
    ADD email VARCHAR(200);

UPDATE student
    SET email=CONCAT(username, '@school.edu');

ALTER TABLE student
    CHANGE COLUMN email email VARCHAR(200) NOT NULL;

-- [Problem 3b]
ALTER TABLE assignment
    ADD submit_files BOOLEAN DEFAULT TRUE;
    
UPDATE assignment
    SET submit_files = FALSE
    WHERE shortname LIKE 'dq%';

-- [Problem 3c]
CREATE TABLE gradescheme(
    scheme_id INTEGER   PRIMARY KEY,
    scheme_desc VARCHAR(100)    NOT NULL
);

INSERT INTO gradescheme
    VALUES
        (0, 'Lab assignment with min-grading.'),
        (1, 'Daily quiz.'),
        (2, 'Midterm or final exam.');

ALTER TABLE assignment
    CHANGE COLUMN gradescheme scheme_id INT NOT NULL;

ALTER TABLE assignment
    ADD FOREIGN KEY (scheme_id) REFERENCES gradescheme(scheme_id);

-- [Problem 4a]

-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't cofuse MySQL
DELIMITER !

-- Given a date value, returns TRUE if it is a weekend,
-- or FALSE if it is a weekday
CREATE FUNCTION is_weekend(
    d DATE
) RETURNS BOOLEAN
BEGIN
    if DAYNAME(d) = 'Saturday' OR DAYNAME(d) = 'Sunday' 
        THEN 
            RETURN True;
    ELSE 
        RETURN False;
    END IF;
    
END !
-- Back to the standard SQL delimiter
DELIMITER ;

-- [Problem 4b]

-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't cofuse MySQL
DELIMITER !

-- Given a date value, returns TRUE if it is a weekend,
-- or FALSE if it is a weekday
CREATE FUNCTION is_holiday(
    d DATE
) RETURNS VARCHAR(20)
BEGIN
    -- Declare all needed variables
    DECLARE month INT;
    DECLARE day INT;
    DECLARE dayofWeek VARCHAR(10);
    DECLARE holiday VARCHAR(30) DEFAULT NULL;
    
    -- assign variables their correct assignments
    SET month = EXTRACT(MONTH FROM d);
    SET day = EXTRACT(DAY FROM d);
    SET dayofWeek = DAYNAME(d);
    
    -- check the 5 holiday conditions 
    IF month = 1 AND day = 1 THEN -- if 1/1/xxxx then new year's
        SET holiday = 'New Year\'s Day';
    -- if day is monday and between 25 and 31, must be the last monday in may
    ELSEIF month = 5 AND dayofWeek = 'Monday' AND day BETWEEN 25 AND 31 THEN
        SET holiday = 'Memorial Day';
    -- if 7/4/xxxx then independence day
    ELSEIF month = 7 AND day = 4 THEN
        SET holiday = 'Independence Day';
    -- if day is monday and in [1, 7] then must be first monday of the month
    ELSEIF month = 9 AND dayofWeek = 'Monday' AND day BETWEEN 1 AND 7 THEN
        SET holiday = 'Labor Day';
    # if day is thursday and in [21, 26], then its the fourth thursday 
    # of the month
    ELSEIF month = 11 AND dayofWeek = 'Thursday' AND day BETWEEN 21 AND 26 THEN
        SET holiday = 'Thanksgiving';
    END IF;
        
    RETURN holiday;

END !
-- Back to the standard SQL delimiter
DELIMITER ;

-- [Problem 5a]
/*
* first column should be the holiday names and the second column is
* the count of that holiday, we do count(*) because we want to count 
* the null valueswe don't have a where clause because we 
* want the null holidays to show up, we group by the result of the call
* to our function in order to see the holidays have their own column
*/ 
SELECT is_holiday(DATE(sub_date)) as holiday, 
    COUNT(*) as count
    FROM fileset
    GROUP BY is_holiday(DATE(sub_date));
    
    
-- [Problem 5b]
SELECT CASE WHEN is_weekend(DATE(sub_date)) = 1 THEN 'weekend' 
    ELSE 'weekday' END AS type_of_day, 
        COUNT(is_weekend(DATE(sub_date))) as count
    FROM fileset
    GROUP BY type_of_day;

