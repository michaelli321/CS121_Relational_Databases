-- [Problem 6a]
/*
* in order to count the number of requests by protocol,
* we simpy sum num_requests and group by protocol
*/
SELECT DISTINCT protocol, SUM(num_requests) AS total_requests
    FROM resource_dim NATURAL JOIN resource_fact
    GROUP BY protocol
    ORDER BY total_requests 
    DESC LIMIT 10;

-- [Problem 6b]
/*
* in order to count the number of errors for a resource, response pair,
* we only look at the rows where response >= 400 (indicating an error),
* and we sum on the groups of resource, response. 
*/
SELECT resource, response, COUNT(num_requests) as error_count
    FROM resource_dim NATURAL JOIN resource_fact
    WHERE response >= 400
    GROUP BY resource, response
    ORDER BY error_count 
    DESC LIMIT 20;

-- [Problem 6c]
/*
* To find the top 20 highest bytes, we just compute all our
* aggregate functions grouping on ip_addr and limiting the 
* output to 20 in descending order
*/
SELECT ip_addr, 
    COUNT(DISTINCT visit_val) AS num_visits, 
    SUM(num_requests) AS total_requests, 
    SUM(total_bytes) AS total_bytes
FROM visitor_dim NATURAL JOIN visitor_fact
    GROUP BY ip_addr
    ORDER BY total_bytes
    DESC LIMIT 20;

-- [Problem 6d]
/*
* We see that there is a gap in the data during the time frame of
* July 29th 1995 - July 31st 1995 and another gap on August 2nd 1995.
* According to the website, the Web server was shut down due to Hurricane
* Erin from 01/Aug/1995:14:52:01 until 03/Aug/1995:04:36:13. This explains
* the gap of August 2nd 1995 since the server was simply shut down. 
*/

/*
* We keep all our hours by left joining on datetime_dim, since 
* it keeps track of all hours. We then restrict the dates to only 
* the given date range. 
*/
SELECT datetime_dim.date_val, 
    IFNULL(SUM(num_requests), 0) AS total_requests,
    IFNULL(SUM(total_bytes), 0) AS total_bytes
    FROM datetime_dim NATURAL LEFT JOIN resource_fact
    WHERE datetime_dim.date_val BETWEEN '1995-07-23' AND '1995-08-12'
    GROUP BY date_val;

-- [Problem 6e]

/*
* in order to find the maximum total bytes served for a day, 
* we first find the total bytes served per day. We then 
* compute the maximum bytes served per day and then join
* these tables, as their intersection will just be the maximum
* bytes rows and the rest of the info not given during 
* an aggregation computation.
*/
WITH resource_bytes AS (SELECT date_val, resource, 
    SUM(num_requests) AS total_requests,
    SUM(total_bytes) AS total_bytes
    FROM datetime_dim NATURAL JOIN resource_dim NATURAL JOIN resource_fact
    GROUP BY date_val, resource),
max_resource AS (SELECT date_val, MAX(total_bytes) as total_bytes
    FROM resource_bytes
    GROUP BY date_val)
SELECT date_val, resource, total_requests, total_bytes
    FROM resource_bytes NATURAL JOIN max_resource;

-- [Problem 6f]

/*
* We see the largest variation in weekday visit patterns and weekend 
* visits patterns
* occuring between the hours of 7am and 6pm. The weekday visits are
* much higher than 
* the weekend visits. Since this was back in 1995, we know
* most people did not have always-on broadband Internet access at home. 
* We also
* know most people are at work at between the hours of 7am - 6pm on 
* the weekday,
* so these patterns can be explained by people were able to and more 
* likely to 
* use internet at work since big companies would be much more likely to 
* have always-on 
* broadband Internet access. Additionally, another interesting variation in 
* the weekend/weekday 
* pattern occurs during the hours of 4am and 8am. The weekday 
* visits are much higher than 
* the weekend visits. This can also be attributed to people working 
* overtime at work during 
* these hours on the weekday. The weekend visits are so low at 
* this time because people
* are most likely trying to catch up on sleep and rest instead of 
* using the internet at this
* time (if they even had it at home).
*/

/*
* In order to find the average weekday and weekend visits
* per hour, we split the
* the problem up into two. We first compute the total weekday visits by
* counting the distinct visit_val given a date_val, hour_val pair where
* the day is a weekday. We do the same thing to find the weekend visits. 
* We can then use the AVG() function (grouping by hour) on these columns
* when we join the two tables
* and only select the columns we need. 
*/
WITH weekday AS (SELECT date_val, hour_val, 
    COUNT(DISTINCT visit_val) AS weekday_visits
    FROM datetime_dim NATURAL JOIN visitor_fact 
        NATURAL JOIN visitor_dim
    WHERE weekend = FALSE 
    GROUP BY date_val, hour_val),
weekend AS (SELECT date_val, hour_val,
    COUNT(DISTINCT visit_val) AS weekend_visits
    FROM datetime_dim NATURAL JOIN visitor_fact 
        NATURAL JOIN visitor_dim
    WHERE weekend = TRUE
    GROUP BY date_val, hour_val)
SELECT weekday.hour_val AS hour_val, AVG(weekday_visits) 
    AS avg_weekday_visits,
    AVG(weekend_visits) AS avg_weekend_visits
    FROM weekday JOIN weekend ON weekday.hour_val = weekend.hour_val
    GROUP BY hour_val;

