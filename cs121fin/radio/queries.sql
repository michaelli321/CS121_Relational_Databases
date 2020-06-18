-- [Problem 1.4a]
/*
* this query first finds each artist and the number of requests
* he/she has. Using that temporary table, we then select the 
* artist(s) that has the maximum number of requests from 
* the table itself
*/

WITH t AS (SELECT artist_name, COUNT(is_request) as num_requests
    FROM artists
        NATURAL JOIN songs 
        NATURAL JOIN audio_files
        NATURAL JOIN playlist
    WHERE is_request = 1 
    GROUP BY artist_name)
SELECT artist_name, num_requests as tot_requests
    FROM t
    WHERE num_requests IN (SELECT MAX(num_requests) FROM t);

-- [Problem 1.4b]
/*
* This query finds the total amount of money each company owes
* the radio station forp laying the company's ad. It does this by 
* constraining both the begin and end date of the ad in between
* the last 30 days. We then natural join advertisement and companies
* to find the price each comapany pays, and we can then sum the price
* column by grouping on the company name
*/
SELECT comp_name, SUM(price) as total_amount 
    FROM advertisements NATURAL JOIN companies
    WHERE ((schedule_start BETWEEN CURRENT_DATE - INTERVAL 30 
        DAY AND CURRENT_DATE)
        AND (schedule_end BETWEEN CURRENT_DATE - INTERVAL 30 DAY 
            AND CURRENT_DATE))
    GROUP BY comp_name
    ORDER BY total_amount DESC;