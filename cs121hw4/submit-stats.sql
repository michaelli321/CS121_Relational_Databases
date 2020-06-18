-- [Problem 1]
DROP FUNCTION IF EXISTS min_submit_interval;


-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL
DELIMITER !

-- Given a submission id, this function
-- returns the minimum interval that a resubmission
-- occured

CREATE FUNCTION min_submit_interval(
    sub_id INTEGER
) RETURNS INTEGER

BEGIN

    -- Variables to accumulate into
    DECLARE currentDiff INT DEFAULT NULL;
    DECLARE difference INT;
    DECLARE first_val INT;
    DECLARE second_val INT;
    
    -- Cursor, and flag for when fetching is done
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT UNIX_TIMESTAMP(sub_date) FROM fileset
            WHERE fileset.sub_id = sub_id
            ORDER BY sub_date ASC;
    
    -- When fetch is complete, handler sets flag
    -- 02000 is MySQL error for "zero rows fetched"
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
        
    OPEN cur;

    FETCH cur INTO first_val;
    WHILE NOT done DO
        FETCH cur INTO second_val;
        IF NOT done THEN
            SET difference = second_val - first_val;
            IF currentDiff IS NULL THEN
                SET currentDiff = difference;
                
            -- if the calculated difference is smaller than our current
            -- stored one then replace it
            ELSEIF difference < currentDiff THEN
                SET currentDiff = difference;
            END IF;
            SET first_val = second_val;
        END IF;
    END WHILE;
    
    CLOSE cur;
    RETURN currentDiff;

END !
-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 2]
DROP FUNCTION IF EXISTS max_submit_interval;


-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL
DELIMITER !

-- Given a submission id, this function
-- returns the minimum interval that a resubmission
-- occured

CREATE FUNCTION max_submit_interval(
    sub_id INTEGER
) RETURNS INTEGER

BEGIN

    -- Variables to accumulate into
    DECLARE currentDiff INT DEFAULT NULL;
    DECLARE difference INT;
    DECLARE first_val INT;
    DECLARE second_val INT;
    
    -- Cursor, and flag for when fetching is done
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT UNIX_TIMESTAMP(sub_date) FROM fileset
            WHERE fileset.sub_id = sub_id
            ORDER BY sub_date ASC;
    
    -- When fetch is complete, handler sets flag
    -- 02000 is MySQL error for "zero rows fetched"
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
        
    OPEN cur;

    FETCH cur INTO first_val;
    WHILE NOT done DO
        FETCH cur INTO second_val;
        IF NOT done THEN
            SET difference = second_val - first_val;
            IF currentDiff IS NULL THEN
                SET currentDiff = difference;
                
            -- if the calculated difference is larger than our current
            -- stored one then replace it
            ELSEIF difference > currentDiff THEN
                SET currentDiff = difference;
            END IF;
            SET first_val = second_val;
        END IF;
    END WHILE;
    
    CLOSE cur;
    RETURN currentDiff;

END !
-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 3]
DROP FUNCTION IF EXISTS avg_submit_interval;


-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't confuse MySQL
DELIMITER !

-- Given a submission id, this function
-- returns the average interval that a resubmission
-- occured

CREATE FUNCTION avg_submit_interval(
    sub_id INTEGER
) RETURNS DOUBLE

BEGIN
    -- the sum of all the intervals is equal to the difference between
    -- the minimum and the maximum, thus we can just find the average
    -- by taking the difference and dividing by the number of intervals
    
    DECLARE num INT;
    DECLARE maximum INT DEFAULT NULL;
    DECLARE minimum INT DEFAULT NULL;
    
    SELECT UNIX_TIMESTAMP(MAX(sub_date)) INTO maximum
        FROM fileset
        WHERE fileset.sub_id = sub_id;
        
    SELECT UNIX_TIMESTAMP(MIN(sub_date)) INTO minimum
        FROM fileset
        WHERE fileset.sub_id = sub_id;
        
    SELECT COUNT(sub_date) - 1 INTO num
        FROM fileset
        WHERE fileset.sub_id = sub_id;
        
    RETURN (maximum - minimum) / num;
    

END !
-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 4]
/* 
* we create an index on sub_id for the min interval and max interval 
* functions and we create an index on sub_date for the average function
*/
CREATE INDEX idx_fileset ON fileset(sub_id, sub_date);

