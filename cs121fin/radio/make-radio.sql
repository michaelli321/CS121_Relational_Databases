-- [Problem 1.3]

/* clean up old tables;
   must drop tables with foreign keys first
   due to referential integrity constraints
 */
DROP TABLE IF EXISTS company_emails;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS song_tags;
DROP TABLE IF EXISTS songs;
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS advertisements;
DROP TABLE IF EXISTS playlist;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS audio_files;

/*
* This table contains all basic information
* of audio_files in the database and 
* is a parent to songs, promotions,
* and advertisements
*/
CREATE TABLE audio_files(
    file_id INTEGER AUTO_INCREMENT PRIMARY KEY, -- each file's unique ID
    path VARCHAR(255) UNIQUE NOT NULL, -- path/filename of up to 1024 bytes
    length NUMERIC(6, 1) NOT NULL -- length of file in seconds, can be 
                                                            -- up to 86400s
);

/* 
* This table holds each company name and assigns it a specific id
*/
CREATE TABLE companies(
    comp_id INTEGER AUTO_INCREMENT PRIMARY KEY, -- each company's unique ID
    comp_name VARCHAR(50) NOT NULL UNIQUE -- company's name
);

/*
* This table holds each company's email contacts. Each company
* can have multiple email contacts, thus we have a primary key
* on both comp_id and email_address
*/
CREATE TABLE company_emails(
    comp_id INTEGER, -- each company's unique ID
    email_address VARCHAR(50) NOT NULL, -- email address of company
    PRIMARY KEY (comp_id, email_address),
    FOREIGN KEY (comp_id) REFERENCES companies(comp_id)
);

/*
* This table holds the 'master playlist'. Each row 
* contains an audio_file and its start time
*/
CREATE TABLE playlist(
    file_id INTEGER, -- each file's unique ID
    start_time DATETIME UNIQUE, -- the unique starting time and date
    is_request BOOLEAN NOT NULL, -- records whether or not file was a request
    PRIMARY KEY(file_id, start_time),
    FOREIGN KEY (file_id) REFERENCES audio_files(file_id)
);

/*
* This table contains information about the advertisement
* audio files
*/
CREATE TABLE advertisements(
    file_id INTEGER PRIMARY KEY, -- each file's unique ID
    schedule_start DATETIME NOT NULL, -- date/time specifying when start air
    schedule_end DATETIME NOT NULL, -- date/time specifying when stop
    price NUMERIC(6, 2) NOT NULL, -- price of the ad, limit $1000
    comp_id INTEGER, -- the comapany that is associated with the ad
    FOREIGN KEY (file_id) REFERENCES audio_files(file_id),
    FOREIGN KEY (comp_id) REFERENCES companies(comp_id)
);

/*
* This table contains information about the promotional
* audio files
*/
CREATE TABLE promotions(
    file_id INTEGER PRIMARY KEY, -- each file's unique ID 
    promo_type VARCHAR(30) NOT NULL, -- the promo type
    url VARCHAR(1000), -- optional URL associated with the promotion
    FOREIGN KEY (file_id) REFERENCES audio_files(file_id)
);

/*
* This table contains information of all the songs in
* the radio's database
*/
CREATE TABLE songs(
    file_id INTEGER PRIMARY KEY, -- each file's unique ID
    intro_length NUMERIC(100, 1) NOT NULL, -- time before lyrics begin in s
    is_explicit BOOLEAN NOT NULL, -- flag saying if the song is explicit or not
    FOREIGN KEY (file_id) REFERENCES audio_files(file_id)
);

/*
* This table contains information of the artists of the songs
* in the radio's database
*/
CREATE TABLE artists(
    file_id INTEGER, -- each file's unique ID
    artist_name VARCHAR(100) NOT NULL UNIQUE, -- the name of the artist
    PRIMARY KEY(file_id, artist_name),
    FOREIGN KEY (file_id) REFERENCES songs(file_id)
);

/*
* This table contains information of the tags of each songs.
* each song can have multiple tags describing the 
* characteristic of the song.
*/
CREATE TABLE song_tags(
    file_id INTEGER, -- each file's unique ID
    tag VARCHAR(30), -- the tag itself for the song
    PRIMARY KEY (file_id, tag),
    FOREIGN KEY (file_id) REFERENCES songs(file_id)
);
