-- [Problem 5]

-- DROP TABLE commands:
/* clean up old tables;
   must drop tables with foreign keys first
   due to referential integrity constraints
 */
DROP TABLE IF EXISTS ticket;
DROP TABLE IF EXISTS purchase;
DROP TABLE IF EXISTS purchaser;
DROP TABLE IF EXISTS traveler;
DROP TABLE IF EXISTS customers_numbers;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS flight_info;
DROP TABLE IF EXISTS seat_available;
DROP TABLE IF EXISTS plane_info;

-- CREATE TABLE commands:
/* 
* this table contains all information 
* regarding planes in the database
*/
CREATE TABLE plane_info(
    aircraft_code   CHAR(3) PRIMARY KEY, -- IATA aircraft type code
    manufacturer    VARCHAR(20) NOT NULL,
    model   VARCHAR(20) NOT NULL
);

/*
* this table contains information about all customers and is a 
* parent table to traveler and purchaser
*/
CREATE TABLE customers(
    cust_id     INTEGER AUTO_INCREMENT PRIMARY KEY,
    first_name  VARCHAR(20) NOT NULL,
    last_name   VARCHAR(30) NOT NULL,
    email_address   VARCHAR(50) NOT NULL
);

/* 
* this table contains information regarding 
* the availability of seats of each aircraft 
*/ 
CREATE TABLE seat_available(
    seat_number     VARCHAR(4),
    aircraft_code   CHAR(3), -- IATA aircraft type code
    seat_class  VARCHAR(10) NOT NULL, -- {first, business, or coach}
    seat_type   VARCHAR(10) NOT NULL, -- {aisle, middle, or window}
    is_exit_row BOOLEAN NOT NULL,
    PRIMARY KEY(seat_number, aircraft_code),
    -- if there is no aircraft, there is no seat
    FOREIGN KEY (aircraft_code) references plane_info(aircraft_code)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/*
* this table contains flight information. since a flight number 
* can be repeated, the flight date will also be used as a primary key
*/
CREATE TABLE flight_info(
    flight_number   VARCHAR(7),
    f_date  DATE,
    aircraft_code   CHAR(3) NOT NULL, -- IATA aircraft type code
    f_time  TIME NOT NULL, 
    src_airport  CHAR(3) NOT NULL, -- IATA airport code
    dst_airport   CHAR(3) NOT NULL, -- IATA airport code
    flight_type     CHAR(1) NOT NULL, -- I is international, D is domestic
    PRIMARY KEY(flight_number, f_date),
    -- no plane, no flight, also any changes to plane should be reflected
    FOREIGN KEY (aircraft_code) references plane_info(aircraft_code)
        ON DELETE CASCADE ON UPDATE CASCADE 
);

/*
* this table contains all the phone numbers of each customer
* each customer can have multiple phone number so phone_number
* is the primary key since cust_id can be repeated
*/
CREATE TABLE customers_numbers(
    phone_number CHAR(10) PRIMARY KEY NOT NULL,
    cust_id     INTEGER NOT NULL,
    -- if no customer has the number, then no reason to have it
    FOREIGN KEY (cust_id) references customers(cust_id)
        ON DELETE CASCADE ON UPDATE CASCADE 
);

/*
* this table contains info about travelers
*/
CREATE TABLE traveler(
    cust_id     INTEGER PRIMARY KEY,
    passport_no     VARCHAR(40), -- can be null b/c 72 hr rule
    country     CHAR(2), -- can be null b/c 72 hr rule
    emergen_name    VARCHAR(100), -- can be null b/c 72 hr rule
    emergen_phone   CHAR(10), -- can be null b/c 72 hr rule
    frequent_fly_no     CHAR(7), -- can be null b/c not everyone enrolled
    FOREIGN KEY (cust_id) references customers(cust_id) -- if no customer, then 
        ON DELETE CASCADE ON UPDATE CASCADE -- there's no traveler
);

/*
* this table contains info about the purchaser 
* of tickets
*/
CREATE TABLE purchaser(
    cust_id     INTEGER PRIMARY KEY,
    credit_card_no      CHAR(16), -- can be null if not trusted
    exp_date    CHAR(4), -- can be null if not trusted
    verification_code CHAR(3), -- can be null if not trusted
    FOREIGN KEY (cust_id) references customers(cust_id) -- if no customer, then
        ON DELETE CASCADE ON UPDATE CASCADE -- no purchaser
);

/* 
* this table keeps track of all the purchases
* that are made by a purchaser
*/ 
CREATE TABLE purchase(
    purchase_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    cust_id INTEGER NOT NULL,
    time_date   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    confirmation_no     CHAR(6) NOT NULL UNIQUE,
    -- refers to purchaser since only purchaser makes a purchase
    FOREIGN KEY (cust_id) references purchaser(cust_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/*
* this table keeps track of all tickets and the information 
* involved with them
*/
CREATE TABLE ticket(
    ticket_id   INTEGER PRIMARY KEY AUTO_INCREMENT,
    price   NUMERIC(6, 2) NOT NULL, -- max price is 9999.99
    purchase_id     INTEGER NOT NULL,
    cust_id     INTEGER NOT NULL,
    flight_number   VARCHAR(7),
    f_date  DATE NOT NULL,
    seat_number     VARCHAR(4) NOT NULL,
    aircraft_code   CHAR(3) NOT NULL,
    -- if there was no purchase, then there was no ticket
    FOREIGN KEY (purchase_id) references purchase(purchase_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- if no customer to use ticket, then there is no ticket
    FOREIGN KEY (cust_id) references traveler(cust_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- if the flight is cancelled, the ticket is cancelled
    FOREIGN KEY (flight_number, f_date) references 
        flight_info(flight_number, f_date)
        ON DELETE CASCADE ON UPDATE CASCADE,
    -- if the seat isn't available, then the ticket isn't valid for that 
    -- seat anymore
    FOREIGN KEY (seat_number, aircraft_code) references 
        seat_available(seat_number, aircraft_code)
        ON DELETE CASCADE ON UPDATE CASCADE
);
