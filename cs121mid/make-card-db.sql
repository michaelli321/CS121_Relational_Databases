-- [Problem 9]

/* clean up old tables;
   must drop tables with foreign keys first
   due to referential integrity constraints
 */
 
 DROP TABLE IF EXISTS cards_for_sale;
 DROP TABLE IF EXISTS player_cards;
 DROP TABLE IF EXISTS card_types;
 DROP TABLE IF EXISTS players;
 
 /* 
 * This table represents the individual users that have created
 * an account and that are playing the online collectible card game. 
 */
 CREATE TABLE players(
    player_id INTEGER   AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(30)    UNIQUE NOT NULL,
    email VARCHAR(100)  NOT NULL,
    register_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL,
    player_status CHAR(1) DEFAULT 'A' NOT NULL
);

/*
* This table describes each kind of card that may appear in the game. Each kind 
* of card has a unique ID, a unique name, a description of the card's meaning and effects
* in the game, and an optional limit on how many of this kind of card are actually available
* in the game
*/
CREATE TABLE card_types(
    type_id INTEGER     AUTO_INCREMENT PRIMARY KEY,
    card_name VARCHAR(100) UNIQUE NOT NULL,
    card_desc VARCHAR(4000) NOT NULL,
    card_value NUMERIC(5, 1) NOT NULL,
    total_circulation INT
);

/* 
* This table recrods the details of all cards that are actually in circulation among all
* players of the game. For every card that each player owns, there will be a tuple in this relation,
* specifying the card's type, and the player who owns it. Each individual card also has its own
* unique ID
*/
CREATE TABLE player_cards(
    card_id INTEGER     AUTO_INCREMENT PRIMARY KEY,
    type_id INTEGER     NOT NULL,
    player_id INTEGER   NOT NULL,
    FOREIGN KEY (type_id) references card_types(type_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (player_id) references players(player_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

/* 
* This table records playing cards that are currently for sale. None of the attributes
* are allowed to be null. Both primary keys player_id and card_id are foreign keys
* to ensure that players only sell the cards that they actually own
*/
CREATE TABLE cards_for_sale(
    player_id INTEGER AUTO_INCREMENT, 
    card_id INTEGER,
    offer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP() NOT NULL,
    card_price NUMERIC(7,2) NOT NULL,
    PRIMARY KEY(player_id, card_id),
    FOREIGN KEY (player_id) references players(player_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(card_id) references player_cards(card_id)
        ON DELETE CASCADE ON UPDATE CASCADE

);

