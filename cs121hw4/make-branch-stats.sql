-- [Problem 1]
/*
* we create an index on account using branch_name since we need to 
* group by that
*/
CREATE INDEX idx_account ON account(branch_name);

-- [Problem 2]
DROP TABLE IF EXISTS mv_branch_account_stats;

-- we leave out average since it is impossible to keep 
-- track of both old and new in the table
CREATE TABLE mv_branch_account_stats(
    branch_name VARCHAR(15) PRIMARY KEY,
    num_accounts INTEGER NOT NULL,
    total_deposits NUMERIC(12, 2) NOT NULL,
    min_balance NUMERIC(12, 2) NOT NULL,
    max_balance NUMERIC(12, 2) NOT NULL
);

-- [Problem 3]
DROP VIEW IF EXISTS mv_branch_account_stats;

INSERT INTO mv_branch_account_stats
    SELECT branch_name, COUNT(*), SUM(balance),
        MIN(balance), MAX(balance)
    FROM account GROUP BY branch_name;

-- [Problem 4]
DROP VIEW IF EXISTS branch_account_stats; 

-- we include average here
CREATE VIEW branch_account_stats AS
    SELECT branch_name, num_accounts, total_deposits,
        total_deposits/num_accounts AS avg_balance,
        min_balance, max_balance
    FROM mv_branch_account_stats;

-- [Problem 5]
DROP TRIGGER IF EXISTS trg_insert;
DROP PROCEDURE IF EXISTS sp_normal_insert;
DROP PROCEDURE IF EXISTS sp_max_insert;
DROP PROCEDURE IF EXISTS sp_min_insert;

DELIMITER !

CREATE PROCEDURE sp_normal_insert(
    IN insert_branch VARCHAR(15),
    IN insert_balance NUMERIC(12, 2))

BEGIN
    
    -- if the branch is not an established branch then add it
    IF insert_branch NOT IN (SELECT branch_name 
        FROM mv_branch_account_stats) THEN
    INSERT INTO mv_branch_account_stats
        VALUES (insert_branch, 1, insert_balance, insert_balance,
            insert_balance);
    
    -- otherwise, we update 
    ELSE UPDATE mv_branch_account_stats
        SET num_accounts = num_accounts + 1,
            total_deposits = total_deposits + insert_balance
        WHERE mv_branch_account_stats.branch_name = insert_branch;
    
    END IF;
END !

CREATE PROCEDURE sp_max_insert(
    IN insert_branch VARCHAR(15),
    IN insert_balance NUMERIC(12, 2))
    
BEGIN
    -- if the balance we just inserted is larger than the previous
    -- max balance, then we update the max balance
    IF insert_balance > (SELECT max_balance 
        FROM mv_branch_account_stats
        WHERE branch_name = insert_branch) THEN
        UPDATE mv_branch_account_stats
            SET max_balance = insert_balance
            WHERE branch_name = insert_branch;
    
    END IF;
END!

CREATE PROCEDURE sp_min_insert(
    IN insert_branch VARCHAR(15),
    IN insert_balance NUMERIC(12, 2))
    
BEGIN
    -- if the balance we just inserted is smaller than the
    -- previous min balance, then we update the min balance
    IF insert_balance < (SELECT min_balance
        FROM mv_branch_account_stats
        WHERE branch_name = insert_branch) THEN 
        UPDATE mv_branch_account_stats
            SET min_balance = insert_balance
            WHERE branch_name = insert_branch;
    END IF;
END!

CREATE TRIGGER trg_insert AFTER INSERT ON account FOR EACH ROW
BEGIN
    
    CALL sp_normal_insert(NEW.branch_name, NEW.balance);
    CALL sp_max_insert(NEW.branch_name, NEW.balance);
    CALL sp_min_insert(NEW.branch_name, NEW.balance);
    
END!

DELIMITER ;


-- [Problem 6]

DROP TRIGGER IF EXISTS trg_delete;
DROP PROCEDURE IF EXISTS sp_normal_delete;
DROP PROCEDURE IF EXISTS sp_max_delete;
DROP PROCEDURE IF EXISTS sp_min_delete;

DELIMITER !

CREATE PROCEDURE sp_normal_delete(
    IN delete_branch VARCHAR(15),
    IN delete_balance NUMERIC(12, 2))

BEGIN
    -- we first update the table by deleting the account and updating its stats
    UPDATE mv_branch_account_stats
        SET num_accounts = num_accounts - 1,
        total_deposits = total_deposits - delete_balance
    WHERE branch_name = delete_branch;
    
    -- if there are no more accounts, then we remove the entire branch
    IF (SELECT num_accounts FROM mv_branch_account_stats
        WHERE branch_name = delete_branch) = 0 THEN
        DELETE FROM mv_branch_account_stats
            WHERE branch_name = delete_branch;
    END IF;
    
END !

CREATE PROCEDURE sp_max_delete(
    IN delete_branch VARCHAR(15),
    IN delete_balance NUMERIC(12, 2))
    
BEGIN
    -- if the balance was the old maximum balance, then we update to find
    -- the new max
    IF delete_balance = (SELECT max_balance FROM mv_branch_account_stats
        WHERE branch_name = delete_branch) THEN
    UPDATE mv_branch_account_stats
        SET max_balance = (SELECT MAX(balance)
            FROM account
            WHERE branch_name = delete_branch)
        WHERE branch_name = delete_branch;
    
    END IF;
END!

CREATE PROCEDURE sp_min_delete(
    IN delete_branch VARCHAR(15),
    IN delete_balance NUMERIC(12, 2))
    
BEGIN
    -- if the balance was the old minimum balance, then we update to find 
    -- the new min
    IF delete_balance = (SELECT min_balance FROM mv_branch_account_stats
        WHERE branch_name = delete_branch) THEN
    UPDATE mv_branch_account_stats
        SET max_balance = (SELECT MIN(balance) 
            FROM account
            WHERE branch_name = delete_branch)
        WHERE branch_name = delete_branch;
        
    END IF;
END!

CREATE TRIGGER trg_delete AFTER DELETE ON account FOR EACH ROW
BEGIN
    
    CALL sp_normal_delete(OLD.branch_name, OLD.balance);
    CALL sp_max_delete(OLD.branch_name, OLD.balance);
    CALL sp_min_delete(OLD.branch_name, OLD.balance);
    
END!

DELIMITER ;

-- [Problem 7]

DROP TRIGGER IF EXISTS trg_update;

DELIMITER !

CREATE TRIGGER trg_update AFTER UPDATE ON account FOR EACH ROW
BEGIN
    -- if the branch is not the same, then we delete the old one and insert 
    -- the new one
    IF (OLD.branch_name <> NEW.branch_name) THEN
        CALL sp_normal_delete(OLD.branch_name, OLD.balance);
        CALL sp_normal_insert(NEW.branch_name, NEW.balance);
    
    -- otherwise we update the branch
    ELSE 
        UPDATE mv_branch_account_stats
            SET total_deposits = total_deposits - OLD.balance + NEW.balance
            WHERE mv_branch_account_stats.branch_name = NEW.branch_name;
            
    END IF;
    
    -- find the new min/max if necessary
    CALL sp_max_delete(OLD.branch_name, OLD.balance);
    CALL sp_min_delete(OLD.branch_name, OLD.balance);
    CALL sp_max_insert(NEW.branch_name, NEW.balance);
    CALL sp_min_insert(NEW.branch_name, NEW.balance);

END !

DELIMITER ;


