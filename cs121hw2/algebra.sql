-- [Problem 1]
SELECT DISTINCT a
    FROM r;

-- [Problem 2]
SELECT * 
    FROM r
    WHERE B = 17;

-- [Problem 3]
SELECT *
    FROM r, s;

-- [Problem 4]
WITH t AS (SELECT *
    FROM r, s 
    WHERE C = D)
SELECT DISTINCT A, F
    FROM t;

-- t is simply the argument of the project function in the expression

-- [Problem 5]
SELECT * 
    FROM r1 
UNION 
SELECT *
    FROM r2;

-- [Problem 6]
SELECT * 
    FROM r1
INTERSECT
SELECT *
    FROM r2;

-- [Problem 7]
SELECT *
    FROM r1
EXCEPT 
SELECT *
    FROM r2


