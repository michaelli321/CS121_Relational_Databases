-- [Problem 1a]
SELECT loan_number, amount
    FROM loan
    WHERE amount >= 1000 AND amount <= 2000;

-- [Problem 1b]
-- natural join borrower and loan to find all loans with their customer name
SELECT loan_number, amount
    FROM loan NATURAL JOIN borrower
    WHERE customer_name = 'Smith'
    ORDER BY loan_number;

-- [Problem 1c]
SELECT branch_city
    FROM account NATURAL JOIN branch
    WHERE account_number = 'A-446';

-- [Problem 1d]
/*
* locate returns the first place where the substring occurs in the string
* so if the customer name begins with J, then locate should return 1
*/
SELECT customer_name, account_number, branch_name, balance
    FROM customer natural join depositor natural join account
    WHERE locate('J', customer_name) = 1
    ORDER BY customer_name;

-- [Problem 1e]
SELECT customer_name
    FROM customer NATURAL JOIN depositor NATURAL JOIN account
    GROUP BY customer_name
    HAVING COUNT(account_number) > 5;

-- [Problem 2a]
CREATE VIEW pownal_customers AS
    SELECT account_number, customer_name
    FROM customer NATURAL JOIN depositor NATURAL JOIN account
    WHERE branch_name = 'Pownal';

-- [Problem 2b]
/*
* made sure this was a editable view by making sure 
* we selected from a singular relation and meeting 
* all the othe requirements on the lecture slide
*/
CREATE VIEW onlyacct_customers AS
    SELECT customer_name, customer_street, customer_city
    FROM customer 
    WHERE customer_name IN (SELECT customer_name
        FROM depositor) AND customer_name NOT IN 
            (SELECT customer_name
                FROM borrower);


-- [Problem 2c]
/* 
* IFNULL will return 0 if the sum of balance is NULL
*/
CREATE VIEW branch_deposits AS
    SELECT branch.branch_name, 
        IFNULL(sum(balance), 0) as total_bal, avg(balance) as avg_balance
    FROM branch LEFT JOIN account ON branch.branch_name = account.branch_name
    GROUP BY branch.branch_name;

-- [Problem 3a]
SELECT DISTINCT customer_city
    FROM customer LEFT JOIN branch
        ON customer.customer_city = branch.branch_city
    WHERE branch_city IS NULL
    ORDER BY customer_city;

-- [Problem 3b]
/* 
* we left Join to customer in order to make sure no customers disappear
* in a join, thus we can check which customers have NULL for 
* acct number and loan number 
*/
SELECT customer.customer_name
    FROM customer LEFT JOIN borrower
        ON customer.customer_name = borrower.customer_name
    LEFT JOIN depositor ON customer.customer_name = depositor.customer_name
    WHERE loan_number IS NULL AND account_number IS NULL;

-- [Problem 3c]
UPDATE account
    SET balance = balance + 50
    WHERE branch_name IN (SELECT branch_name
        FROM branch
        WHERE branch_city = 'Horseneck');

-- [Problem 3d]
UPDATE account, branch
    SET account.balance = balance + 50
    WHERE branch.branch_city = 'Horseneck'
        AND account.branch_name = branch.branch_name;

-- [Problem 3e]
/* 
* t is the derived relation of branch names and their largest account 
* balance. it is being joined in the from clause of the entire select 
* query
*/
WITH t as (SELECT branch_name, max(balance) as max_bal
    FROM account
    GROUP BY branch_name)
SELECT account_number, branch_name, balance
    FROM account NATURAL JOIN t
    WHERE balance = max_bal;

-- [Problem 3f]
-- same thing as problem f, however used an IN statement
SELECT account_number, branch_name, balance
    FROM account
    WHERE (branch_name, balance)
        IN (SELECT branch_name, max(balance) as max_bal
        FROM account
        GROUP BY branch_name);

-- [Problem 4]
/*
* cross join branch with itself on the condition that assets of one are
* larger than the other in order to count the number of assets in one that are 
* larger than the other and then we union this with the set of the branch of
* rank 1
*/
WITH t as (SELECT b2.branch_name, count(b1.assets) + 1 as rank
    FROM branch as b1 JOIN branch as b2
    WHERE b1.assets >= b2.assets and b1.branch_name != b2.branch_name
    GROUP BY b2.branch_name)
SELECT branch_name, assets, rank
    FROM branch NATURAL JOIN t
    UNION 
SELECT branch_name, assets, 1 as rank
    FROM branch
    WHERE assets = (SELECT max(assets) FROM branch)
    ORDER BY rank DESC, branch_name;
    


