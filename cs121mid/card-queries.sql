-- [Problem 10]
SELECT * FROM card_types
    WHERE card_value > 10 AND total_circulation IS NULL;

-- [Problem 11]
/* 
* this query checks to find the card type ids that are owned
* by ted codd and add 10 to each of their values
*/ 
UPDATE card_types
    SET card_value = card_value + 10
    WHERE card_types.type_id IN (SELECT type_id FROM 
    players NATURAL JOIN player_cards
    WHERE username = 'ted_codd');

-- [Problem 12]
/* 
* We delete with referential integrity. 
* thus we first start with cards_for_sale and then work our way up to 
* player_cards and then finally players
*/ 
DELETE FROM cards_for_sale
    WHERE player_id IN (SELECT player_id
        FROM players WHERE 
        username = 'smith');
        
DELETE FROM player_cards 
    WHERE player_id in (SELECT player_id
        FROM players WHERE 
        username = 'smith');

DELETE FROM players
    WHERE username = 'smith';

-- [Problem 13]
/*
* here we sum the values of all the cards owned by a player and then 
* order them from top to bottom and take the top 5
*/
SELECT player_id, username, email, SUM(card_value) AS deck_value
    FROM (players NATURAL JOIN player_cards NATURAL JOIN card_types)
    GROUP BY player_id, username, email
    ORDER BY deck_value DESC
    LIMIT 5;

-- [Problem 14a]
/* 
* we use a correlated subquery in here to compare total_circulation to 
* the count of player_id for each card
*/
SELECT * 
    FROM card_types ct
    WHERE ct.total_circulation < (SELECT COUNT(player_id) as num
        FROM player_cards pc
        WHERE ct.type_id = pc.type_id);

-- [Problem 14b]
/*
* we decorrelate the previous query by natural joining card_types with 
* the previous correlated subquery
*/
DROP VIEW IF EXISTS overissued_cards;

CREATE VIEW overissued_cards AS
    SELECT type_id, card_name, card_desc, card_value, total_circulation
    FROM card_types NATURAL JOIN (SELECT type_id, COUNT(player_id) as num
        FROM player_cards
        GROUP BY type_id) as r
    WHERE total_circulation < r.num;

-- [Problem 15]
/*
* in this query we first find all the type_ids that have a total_circulation of <= 10
* and then we group by player_id and count the number of distinct <= 10 
* total circulation cards they have and make sure it is equivalent to the total
* count
*/
SELECT player_id
    FROM card_types NATURAL JOIN player_cards
    WHERE type_id IN (SELECT type_id FROM card_types
        WHERE total_circulation <= 10)
    GROUP BY player_id
    HAVING COUNT(DISTINCT type_id) = (SELECT COUNT(*) FROM 
        (SELECT type_id FROM card_types
        WHERE total_circulation <= 10) as r);

-- [Problem 16]
/*
* we create a view and natural join the players player_cards,
* and card_types to return the information of the cards while 
* being able to access the register date of the users to ensure
* it is between a week ago and now.
*/
DROP VIEW IF EXISTS newbie_card_types; 

CREATE VIEW newbie_card_types AS
    SELECT type_id, card_name, card_desc
    FROM players NATURAL JOIN player_cards NATURAL JOIN card_types
    WHERE register_date 
        BETWEEN 
        SUBTIME(CURRENT_TIMESTAMP(), '168:00:00') AND CURRENT_TIMESTAMP();
    
-- [Problem 17]
/*
* in order to create this third column we must 
* create a function that returns whether or not a player is a 
* player or seller.
*/
DROP FUNCTION IF EXISTS player_type;
DROP VIEW IF EXISTS user_types;

-- Set the "end of statement" character to ! so that
-- semicolons in the function body won't cofuse MySQL
DELIMITER !

-- Given a number of total cards and cards for sale
-- this function returns whether or not the person is a
-- player or seller
CREATE FUNCTION player_type(
    tot_cards INT, sell_num INT
) RETURNS VARCHAR(11)
BEGIN
    if sell_num / tot_cards < .3 
        THEN 
            RETURN 'player';
    ELSE 
        RETURN 'seller';
    END IF;
    
END !
-- Back to the standard SQL delimiter
DELIMITER ;

/*
* now that we have the function, we can use two helper queries. r finds the players 
* and all the cards they have in total. t finds all the cards that that player is selling
* finally the actual query we use here joins these two helper queries along with players
* to get all our relevant info and we can run our function on the total cards and sell_num
*/
WITH r AS (SELECT player_id, COUNT(card_id) AS tot_cards
    FROM player_cards
    GROUP BY player_id),
t AS (SELECT player_id, COUNT(card_id) AS sell_num
    FROM cards_for_sale NATURAL JOIN player_cards
    GROUP BY player_id)
SELECT username, email, player_type(tot_cards, IFNULL(sell_num, 0)) 
    AS player_type
    FROM r NATURAL LEFT JOIN t NATURAL JOIN players;
    


