-- [Problem 3]

-- dropping with referential integrity
DROP TABLE IF EXISTS visitor_fact;
DROP TABLE IF EXISTS resource_fact;
DROP TABLE IF EXISTS datetime_dim;
DROP TABLE IF EXISTS visitor_dim;
DROP TABLE IF EXISTS resource_dim;

/*
* This is one of our dimension tables that holds 
* every hour and date between two dates. It also
* tells us if that day is a weekend or holiday. We need this 
* in order to keep track of every single day and hour.
*/
CREATE TABLE datetime_dim(
    date_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    date_val DATE NOT NULL,
    hour_val INTEGER NOT NULL,
    weekend BOOLEAN NOT NULL,
    holiday VARCHAR(20),
    UNIQUE (date_val, hour_val)
);

/*
* This is our second dimension table. It holds all the information
* of visitors. It keeps track of each ip address and a unique visit_val
* that indicates a visit. We need this in order to keep track of each 
* visit and who visited.
*/ 
CREATE TABLE visitor_dim(
    visitor_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ip_addr VARCHAR(200) NOT NULL,
    visit_val INTEGER NOT NULL,
    UNIQUE (visit_val)
);

/*
* This is our third and last dimension table. It holds all the information
* of resources (what is being requested). We keep track of 
* of the resource, the request method, the HTTP protocol
* that is specified for the request, and the response code from
* the server. We need this in order to keep track of all requests and
* what happened during each request.
*/
CREATE TABLE resource_dim(
    resource_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    resource VARCHAR(200) NOT NULL,
    method VARCHAR(15),
    protocol VARCHAR(200),
    response INTEGER NOT NULL,
    UNIQUE (resource, method, protocol, response)
);

/*
* This is our first fact table. It deals with the resources/requests.
* This table holds a foreign key to date_id and resource_id and 
* holds the number of requests and total bytes sent to the client
* for each pair. We need this in order to have these facts already generated
* for us as we use this information quite a bit.
*/
CREATE TABLE resource_fact(
    date_id INTEGER,
    resource_id INTEGER,
    num_requests INTEGER NOT NULL,
    total_bytes BIGINT,
    PRIMARY KEY (date_id, resource_id),
    FOREIGN KEY (date_id) REFERENCES datetime_dim(date_id),
    FOREIGN KEY (resource_id) REFERENCES resource_dim(resource_id)
);

/*
* This is our second fact table. It deals with the visitors.
* This table holds a foreign key to date_id and visitor_id and holds
* the number of requests and total bytes for each pair. We need this 
* in order to have these facts readily available for us as we use 
* this information quite a bit.
*/
CREATE TABLE visitor_fact(
    date_id INTEGER,
    visitor_id INTEGER,
    num_requests INTEGER NOT NULL,
    total_bytes INTEGER,
    PRIMARY KEY (date_id, visitor_id),
    FOREIGN KEY (date_id) REFERENCES datetime_dim(date_id),
    FOREIGN KEY (visitor_id) REFERENCES visitor_dim(visitor_id)
);