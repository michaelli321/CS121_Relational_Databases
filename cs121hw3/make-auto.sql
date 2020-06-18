-- [Problem 1]

/* clean up old tables;
   must drop tables with foreign keys first
   due to referential integrity constraints
 */
 
 DROP TABLE IF EXISTS owns;
 DROP TABLE IF EXISTS participated;
 DROP TABLE IF EXISTS person;
 DROP TABLE IF EXISTS car;
 DROP TABLE IF EXISTS accident;
 
 CREATE TABLE person(
    driver_id CHAR(10)      PRIMARY KEY,
    name VARCHAR(30)    NOT NULL,
    address VARCHAR(50)     NOT NULL
 );
 
 CREATE TABLE car(
    license CHAR(7)        PRIMARY KEY,
    model VARCHAR(30),
    year    YEAR
 );
 
 CREATE TABLE accident(
    report_number INTEGER AUTO_INCREMENT   PRIMARY KEY,
    date_occured TIMESTAMP   NOT NULL,
    location VARCHAR(500)   NOT NULL,
    description BLOB
);

CREATE TABLE owns(
    driver_id CHAR(10),
    license CHAR(7),
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id) references person(driver_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (license) references car(license)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE participated(
    driver_id CHAR(10),
    license CHAR(7),
    report_number INTEGER AUTO_INCREMENT,
    damage_amount NUMERIC(10, 2),
    PRIMARY KEY(driver_id, license, report_number),
    FOREIGN KEY (driver_id) references person(driver_id)
        ON UPDATE CASCADE,
    FOREIGN KEY (license) references car(license)
        ON UPDATE CASCADE,
    FOREIGN KEY (report_number) references accident(report_number)
        ON UPDATE CASCADE
);
    
    
