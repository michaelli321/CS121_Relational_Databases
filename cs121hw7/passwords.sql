-- [Problem 1a]
DROP TABLE IF EXISTS user_info;

/*
* This table stores the data for our password mechanism. 
* It has three string columns. One holds the username,
* one, the salt of the password, and that last, the hash of the password
*/
CREATE TABLE user_info(
    username VARCHAR(20) PRIMARY KEY,
    salt CHAR(10) NOT NULL,
    password_hash CHAR(64) NOT NULL
);

-- [Problem 1b]
DROP PROCEDURE IF EXISTS sp_add_user;

DELIMITER ! 

/*
* This procedure deals with the addition of a new user into our 
* database. We need this procedure to deal with new users. Given
* a new user and password, we generate a new salt for the password and 
* store the new username, salt, and hash.
*/
CREATE PROCEDURE sp_add_user(
    IN new_username VARCHAR(20),
    IN password VARCHAR(20))

BEGIN 
    
    DECLARE salt CHAR(10);
    SELECT make_salt(10) INTO salt;
    INSERT INTO user_info 
        VALUES (new_username, salt, SHA2(CONCAT(salt, password), 256));
    
END !

DELIMITER ;
    
-- [Problem 1c]
DROP PROCEDURE IF EXISTS sp_change_password;

DELIMITER !

/*
* This procedure is deals with changing an existing user's password. We 
* need this procedure to deal with changing passwords. Given an existing
* username and new password, we generate a new salt for the password
* and update the salt and hash of the user.
*/
CREATE PROCEDURE sp_change_password(
    IN username VARCHAR(20),
    IN new_password VARCHAR(20))
    
BEGIN
    
    DECLARE new_salt CHAR(10);
    SELECT make_salt(10) INTO new_salt;
    UPDATE user_info
        SET salt = new_salt, 
            password_hash = SHA2(CONCAT(new_salt, new_password), 256)
        WHERE user_info.username = username;
        
END !

DELIMITER ;

-- [Problem 1d]

DROP FUNCTION IF EXISTS authenticate;

DELIMITER !

/*
* This function returns a boolean value given a username and password.
* We need this function to determine if a user is actually the user by 
* confirming the password given to us. We return 1 if the username password
* bundle is correct, otherwise we return 0.
*/
CREATE FUNCTION authenticate(
    username VARCHAR(20),
    password VARCHAR(20)
) RETURNS BOOLEAN

BEGIN 
    DECLARE uSalt CHAR(10);
    DECLARE pass_hash CHAR(64);
    
    -- we check to see if the username exists
    IF username IN (SELECT username FROM user_info) THEN
        
        SELECT salt, password_hash INTO uSalt, pass_hash FROM user_info
            WHERE user_info.username = username;
        -- if so, then we determine if the given password is the real password
        IF SHA2(CONCAT(uSalt, password), 256) = pass_hash THEN
            RETURN TRUE;
        ELSE 
            RETURN FALSE;
        END IF;
    ELSE 
        RETURN FALSE;
    END IF;
    
    RETURN FALSE;
    
END !

DELIMITER ;






