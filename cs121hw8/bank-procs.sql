-- [Problem 1]
DROP PROCEDURE IF EXISTS sp_deposit;

DELIMITER !

/*
* This procedure deals with deposits in our banking
* database. We need this procedure to handle when 
* an account wants to make a deposit into their account.
* Given an account_number and amount, we add this value
* to the account's balance. If no errors occur, we OUT 0. If
* the amount specified was negative, we OUT -1. If the 
* account does not exist, then we OUT -2.
*/
CREATE PROCEDURE sp_deposit(
    IN account_number VARCHAR(15),
    IN amount NUMERIC(12, 2),
    OUT status INTEGER)

BEGIN
    -- we begin by assuming a successful transaction
    SET status = 0;
    
    -- we make sure that we have a positive amount
    IF amount < 0 THEN
        SET status = -1;
    ELSE 
        START TRANSACTION;
            UPDATE account 
                SET balance = balance + amount
                WHERE account.account_number = account_number;
            -- if no row was updated, then the account doesn't exist
            IF ROW_COUNT() = 0 THEN
                SET status = -2;
            END IF;
        COMMIT;
    END IF;

END !

DELIMITER ;

-- [Problem 2]
DROP PROCEDURE IF EXISTS sp_withdraw;

DELIMITER !

/*
* This procedure deals with withdrawls in our banking
* database. We need this procedure to handle when 
* an account wants to withdraw money from their account.
* Given an account_number and amount, we subtract this value
* from the account's balance. If no errors occur, we OUT 0. If
* the amount specified was negative, we OUT -1. If the account
* doesn't exist, we OUT -2. If the withdrawl will lead to an overdraft
* we OUT -3.
*/
CREATE PROCEDURE sp_withdraw(
    IN account_number VARCHAR(15),
    IN amount NUMERIC(12, 2),
    OUT status INTEGER)

BEGIN
    
    -- we begin by assuming a successful transaction
    SET status = 0;
    
    -- we make sure that we have a positive amount
    IF amount < 0 THEN
        SET status = -1;
    ELSE 
        START TRANSACTION;
            UPDATE account 
                SET balance = balance - amount
                WHERE account.account_number = account_number;
         -- if no row was updated, then the account doesn't exist
        IF ROW_COUNT() = 0 THEN
            SET status = -2;
        ELSE
            -- we make sure that the change wasn't an overdraft
            IF (SELECT balance FROM account
                WHERE account.account_number = account_number) < 0 THEN
                SET status = -3;
                ROLLBACK;
            END IF;
        
        COMMIT;
        END IF;
    END IF;

END !

DELIMITER ;

-- [Problem 3]
DROP PROCEDURE IF EXISTS sp_transfer;

DELIMITER !

/*
* This procedure deals with transfers in our banking
* database. We need this procedure to handle when 
* an account wants to send money from their account 
* to another. Given an account_number, an amount, 
* and another account_number, we subtract this value
* from the first account's balance and add it to the second
* account's balance. If no errors occur, we OUT 0. If
* the amount specified was negative, we OUT -1. If either of the 
* accounts don't exist, we OUT -2. If the withdrawal will lead
* to an overdraft in the first account, we OUT -3.
*/
CREATE PROCEDURE sp_transfer(
    IN account_1_number VARCHAR(15),
    IN amount NUMERIC(12, 2),
    IN account_2_number VARCHAR(15),
    OUT status INTEGER)

BEGIN 
    
    -- we begin by assuming a successful transaction
    SET status = 0;
    
     -- we make sure that we have a positive amount
    IF amount < 0 THEN
        SET status = -1;
    ELSE 
        START TRANSACTION;
            UPDATE account
                SET balance = balance - amount
                WHERE account.account_number = account_1_number;
            -- if no row was updated, then the account doesn't exist
            IF ROW_COUNT() = 0 THEN
                SET status = -2;
            ELSE
                -- we make sure that the change wasn't an overdraft 
                IF (SELECT balance FROM account
                    WHERE account.account_number = account_1_number) < 0 THEN
                    SET status = -3;
                    ROLLBACK;
                ELSE
                    UPDATE account
                        SET balance = balance + amount
                        WHERE account.account_number = account_2_number;
                    -- if no row was updated, then the account doesn't exist
                    IF ROW_COUNT() = 0 THEN
                        SET status = -2;
                    END IF;
                END IF;
            END IF;
            COMMIT;
    END IF;

END !

DELIMITER ;