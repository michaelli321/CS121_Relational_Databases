-- [Problem 2a]
-- we simply count the number of rows by using COUNT(*)
SELECT COUNT(*) FROM raw_web_log;

-- [Problem 2b]
/*
* We simply count the number of requests by  
* counting the number of ip_addr by grouping 
* by the ip_addr
*/

SELECT ip_addr, COUNT(ip_addr) as num_requests
    FROM raw_web_log
    GROUP BY ip_addr
    ORDER BY num_requests
    DESC LIMIT 20;

-- [Problem 2c]
/*
* similar to the last problem, for each resource, we count 
* the number of requests and bytes by grouping by the 
* resource
*/

SELECT resource, COUNT(resource) as num_requests, 
    SUM(bytes_sent) as bytes_served
    FROM raw_web_log
    GROUP BY resource
    ORDER BY bytes_served
    DESC LIMIT 20;

-- [Problem 2d]
/*
* since everything is unique to a given visit_val and
* ip_addr, we calculate the requests, starting_time, 
* and ending_time, by grouping by visit_val, ip_addr
*/

SELECT visit_val, ip_addr, 
    COUNT(resource) as total_requests, MIN(logtime) as starting_time,
        MAX(logtime) as ending_time
    FROM raw_web_log
    GROUP BY visit_val, ip_addr
    ORDER BY total_requests
    DESC LIMIT 20;



