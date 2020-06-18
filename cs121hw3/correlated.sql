-- [Problem a]
/* 
* This query derives a table of the customer names and the number
* of loans that customer has. It returns it in descending 
* order for number of loans. To fix this we can simply left join
* the borrower relation to customer in order to preserve all the 
* customer names and get a count of 0 for loans.
*/

SELECT c.customer_name, COUNT(loan_number) as num_loans
    FROM (customer c LEFT JOIN borrower b on c.customer_name = b.customer_name)
    GROUP BY customer_name
    ORDER BY num_loans DESC;

-- [Problem b]
/* 
* This query computes the names of the branches that have given
* out a total of loans that is larger than the amount of assets they have. 
* To fix this, we can use a with statement to derive a relation of each branch 
* and their total amounts of loans. We can then natural join this to branch to 
* derive a relation containing branch_name, assets, and amount of loans. 
*/

WITH t as (SELECT branch_name, SUM(amount) as loan_sum FROM loan
    GROUP BY branch_name)
SELECT branch_name 
    FROM branch NATURAL JOIN t
    WHERE assets < loan_sum;

-- [Problem c]
/*
* We must use two correlated subqueries to do this problem.
* We use IFNULL in order to return 0 instead of NULL of 
* that case is needed. 
*/

SELECT branch_name, 
    IFNULL((SELECT COUNT(*) FROM account a
    WHERE a.branch_name = b.branch_name
    GROUP BY branch_name), 0) as num_accts,
    IFNULL((SELECT COUNT(*) FROM loan l 
    WHERE l.branch_name = b.branch_name
    GROUP BY branch_name), 0) as num_loans
FROM branch b ORDER BY branch_name;

-- [Problem d]
/*
* Instead of using two correlated subqueries, we can use 
* two with statements and LEFT JOINs to do the same thing
*/ 

WITH t as (SELECT branch_name, COUNT(account_number) as num_accts
    FROM account
    GROUP BY branch_name),
s as (SELECT branch_name, COUNT(loan_number) as num_loans
    FROM loan
    GROUP BY branch_name)
SELECT branch.branch_name, IFNULL(num_accts, 0) as num_accts, 
    IFNULL(num_loans, 0) as num_loans
    FROM (branch LEFT JOIN t 
        ON branch.branch_name = t.branch_name)
    LEFT JOIN s 
        ON branch.branch_name = s.branch_name
    ORDER BY branch_name;

