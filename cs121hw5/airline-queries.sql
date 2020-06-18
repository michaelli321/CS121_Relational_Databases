-- [Problem 6a]
/*
* in this query we join the purchase, customer, and ticket relations in 
* order to get the corresponding columns we are looking for. We select 
* from a table of all the purchases made by customer 54321 with all the 
* information of the ticket and the customer
*/
SELECT purchase.purchase_id as purchase_id, ticket_id, price,
    time_date, last_name, first_name
    FROM purchase JOIN customers 
        ON purchase.cust_id = customers.cust_id
        JOIN ticket ON purchase.purchase_id = ticket.purchase_id
    WHERE purchase.cust_id = 54321
    ORDER BY time_date DESC, f_date, last_name, first_name;

-- [Problem 6b]
/* 
* in order to make sure we get the count for all kinds of airplanes, we do a 
* LEFT JOIN on to the database holding the airplane information with 
* the ticket price information
*/ 
SELECT aircraft_code, manufacturer, model, SUM(price) as tot_revenue
    FROM plane_info NATURAL LEFT JOIN ticket
    WHERE f_date 
        BETWEEN CURRENT_DATE - INTERVAL 14 DAY AND CURRENT_DATE
    GROUP BY aircraft_code, manufacturer, model;

-- [Problem 6c]
/* 
* we natural join traveler and ticket to find the flight that each traveler
* is on and then natural join that to flight_info to see if the flight is 
* international or not
*/ 
SELECT cust_id
    FROM traveler NATURAL JOIN ticket NATURAL JOIN flight_info
    WHERE flight_type = 'I' AND 
        passport_no IS NULL AND
        country IS NULL AND 
        emergen_name IS NULL AND 
        emergen_phone IS NULL;
    