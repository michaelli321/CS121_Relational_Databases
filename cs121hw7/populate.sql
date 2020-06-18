-- PLEASE DO NOT INCLUDE date-udfs HERE!!!

-- [Problem 4a]
/*
* populating resource_dim is rather trivial as we just take 
* all the corresponding columns from raw_web_log and
* put them into resource_dim, allowing it to create its own 
* resource_id for each row.
*/
INSERT INTO resource_dim (resource, method, protocol, response)
    SELECT DISTINCT resource, method, protocol, response
    FROM raw_web_log;

-- [Problem 4b]
/*
* populating visitor_dim is the same as resource_dim. We just
* take all the corresponding columns from raw_web_log and 
* put them into visitor_dim, allowing it to create its own 
* visitor_id
*/
INSERT INTO visitor_dim(ip_addr, visit_val)
    SELECT DISTINCT ip_addr, visit_val
    FROM raw_web_log;

-- [Problem 4c]
DROP PROCEDURE IF EXISTS populate_dates;

DELIMITER !

/*
* This procedure is used to populate the datetime_dim 
* dimension table. We need it in order to do so. Given a 
* start date and end date, the procedure calculates 
* every possible date and hour pair, whether or not 
* it's a weekend, and whether or not it's a holiday and stores 
* it as a row in datetime_dim.
*/ 
CREATE PROCEDURE populate_dates(
    IN d_start DATE,
    IN d_end DATE)

BEGIN 
    
    DECLARE d DATE;
    DECLARE h INTEGER;
    
    DELETE FROM datetime_dim
        WHERE date_val BETWEEN d_start AND d_end;
    
    SET d = d_start;
    WHILE d <= d_end DO
        SET h = 0;
        
        WHILE h <= 23 DO
            INSERT INTO datetime_dim (date_val, hour_val, weekend, holiday)
                VALUES (d, h, is_weekend(d), is_holiday(d));
            SET h = h + 1;
        END WHILE;
        SET d = d + INTERVAL 1 DAY;
    
    END WHILE;

END !

DELIMITER ;

CALL populate_dates('1995-01-01', '1995-12-31');

-- [Problem 5a]
/*
* In order to populate resource_fact, we take the info from
* the tables that we have foreign keys to joined with raw_web_log
* and compute our facts grouped by those keys. We use <=> in order to 
* treat NULL as 'just another value'
*/
INSERT INTO resource_fact (
    date_id, resource_id,
    num_requests, total_bytes
)
SELECT date_id, resource_id, 
    COUNT(*) AS num_requests, SUM(bytes_sent) AS total_bytes
FROM raw_web_log JOIN datetime_dim 
    ON HOUR(raw_web_log.logtime) <=> datetime_dim.hour_val
    AND DATE(raw_web_log.logtime) <=> datetime_dim.date_val
JOIN resource_dim 
    ON raw_web_log.resource <=> resource_dim.resource 
    AND raw_web_log.method <=> resource_dim.method
    AND raw_web_log.protocol <=> resource_dim.protocol
    AND raw_web_log.response <=> resource_dim.response
GROUP BY date_id, resource_id;

-- [Problem 5b]
/*
* Same thing as populating resource_fact,
* in order to popualte visitor_fact, we take the info
* from the tables that we have foriegn keys to joined with
* raw_web_log and compute our facts 
* grouped by those keys. We use <=> in order to 
* treat NULL as 'just another value'
*/

INSERT INTO visitor_fact(
    date_id, visitor_id,
    num_requests, total_bytes
)
SELECT date_id, visitor_id,
    COUNT(*) AS num_requests, SUM(bytes_sent) AS total_bytes
FROM raw_web_log JOIN datetime_dim
    ON HOUR(raw_web_log.logtime) <=> datetime_dim.hour_val
    AND DATE(raw_web_log.logtime) <=> datetime_dim.date_val
JOIN visitor_dim
    ON raw_web_log.ip_addr <=> visitor_dim.ip_addr 
    AND raw_web_log.visit_val <=> visitor_dim.visit_val
GROUP BY date_id, visitor_id;