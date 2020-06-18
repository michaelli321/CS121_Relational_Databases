-- [Problem 1]
DROP FUNCTION IF EXISTS total_salaries_adjlist;
DROP TABLE IF EXISTS subtree;
    
/*     
* We use a temporary table in order to store
* all the nodes and their salaries that are in
* the particular subtree of the hierarchy. Thus
* at the end of the function we can sum the salary
* column.
*/
-- side note, I didn't put this in the function
-- because I kept getting an error
CREATE TEMPORARY TABLE subtree(
        emp_id INTEGER PRIMARY KEY,
        salary INTEGER NOT NULL
);

DELIMITER !

/*
* This function returns an integer value representing
* the total salary of all employees within the subtree
* of the given emp_id. We use this function to find the 
* sum of all the salaries of the employees below the 
* given emp_id. We do this by first entering the given emp_id
* into the temporary table. We then countinue to add new 
* nodes whose manager is in the table because that means 
* they are below them. We do this until no more rows are added.
* We then sum the salary column and return that value.
*/
CREATE FUNCTION total_salaries_adjlist(
    emp_id INTEGER
) RETURNS INTEGER

BEGIN 

    DECLARE total_salary INTEGER;
    
    -- we first insert the given emp_id
    INSERT INTO subtree 
        SELECT emp_id, salary 
        FROM employee_adjlist
        WHERE employee_adjlist.emp_id = emp_id;
    
    -- if no insert was made, then the given emp_id was incorrect
    IF ROW_COUNT() = 0 THEN
        RETURN 0;
    END IF;
    
    -- we keep adding children of the nodes already in our table
    -- until we end up at a leaf
    label1: WHILE ROW_COUNT() <> 0 DO
        INSERT INTO subtree
            SELECT employee_adjlist.emp_id, salary
                FROM employee_adjlist
                WHERE manager_id IN (SELECT subtree.emp_id FROM subtree)
                    AND employee_adjlist.emp_id NOT IN 
                        (SELECT subtree.emp_id FROM subtree);
    END WHILE label1;
    
    -- sum the salary column from our subtree
    SELECT SUM(salary) FROM subtree INTO total_salary;
    
    DELETE FROM subtree;

    RETURN total_salary;

END !

DELIMITER ;

-- [Problem 2]
DROP FUNCTION IF EXISTS total_salaries_nestset;

DELIMITER !

/*
* This function does the same thing as total_salaries_adjlist. Given
* an emp_id, it returns the total salary of all employees within the subtree.
* However, it does this using the employee_nestset table. We simply
* just check the high and low values of every employee in 
* employee_nestset to make sure they are within the bounds
* of the given emp_id's high and low value. We can then simply
* sum the salaries of those employees and return the value.
*/
CREATE FUNCTION total_salaries_nestset(
    emp_id INTEGER
) RETURNS INTEGER

BEGIN 
    
    -- variable declarations
    DECLARE total_salary INTEGER;
    DECLARE emp_low INTEGER;
    DECLARE emp_high INTEGER;
    
    -- find the low value for the given emp_id
    SELECT low 
        FROM employee_nestset
        WHERE employee_nestset.emp_id = emp_id
        INTO emp_low;
        
    -- find the high value for the given emp_id
    SELECT high
        FROM employee_nestset
        WHERE employee_nestset.emp_id = emp_id
        INTO emp_high;
    
    -- if either does not have a value, then the given emp_id
    -- is not a valid one
    IF emp_low IS NULL or emp_high IS NULL THEN
        RETURN 0;
    END IF;
    
    -- sum the salaries of everyone within the range
    -- of our given emp_id
    SELECT SUM(employee_nestset.salary) 
        FROM employee_nestset
        WHERE low >= emp_low AND high <= emp_high
        INTO total_salary;
        
    RETURN total_salary;

END !

DELIMITER ;

-- [Problem 3]
/*
* In order to find all employees that are leaves in the hierarchy, 
* we find the employees in employee_adjlist, who are not 
* managers. 
*/
SELECT emp_id, name, salary
    FROM employee_adjlist AS e1
    WHERE emp_id NOT IN (SELECT manager_id
        FROM employee_adjlist AS e2
        WHERE e1.emp_id = e2.manager_id);

-- [Problem 4]
/*
* In order to find the leaves in the hierarchy, we
* find the employees in employee_nestset with a high
* and low that encompasses no one
*/
SELECT emp_id, name, salary
    FROM employee_nestset AS e1
    WHERE NOT EXISTS (SELECT emp_id
        FROM employee_nestset AS e2
        WHERE e2.low > e1.low AND e2.high < e1.high);
    
-- [Problem 5]
/*
* I used employee_adjlist since this function is fairly similar 
* to problem 1, where we have to traverse down a path. The difference
* here is instead of using just one path, we look at multiple ones until
* we cannot go anymore. For example, we first put the Head Manager into
* our temporary table to be able to find all the following nodes. We can get 
* to any other node if we start with the root one. Once 
* we do this, we want to increment a counter. We then use a while loop
* that looks at our current table and adds anybody who's manager is in the 
* temporary table. Everytime it does this we know we have gone down one more
* level in the tree, so we increment our depth counter. We then 
* continue this process
* until there is nothing more to add (ROW_COUNT = 0). Thus, I used 
* employee_adjlist in order to find each employee's manager to add them 
* to the table. 
* It is very easy to retrieve a given node's immediate children using 
* employee_adjlist.
*/
DROP FUNCTION IF EXISTS tree_depth;
DROP TABLE IF EXISTS hierarchy;

/*
* We use a temporary table in order to store 
* all the nodes of the level that we are currently 
* at. We can compare to the table to see
* the next values to add, since all managers
* will be in the table, to find the next level down
* the tree.
*/
CREATE TEMPORARY TABLE hierarchy(
    emp_id INTEGER PRIMARY KEY 
);

DELIMITER !

/*
* This function returns the depth of the employee
* tree. It takes no arguments. See above comment for
* explanation on how this function works.
*/
CREATE FUNCTION tree_depth()
    RETURNS INTEGER
    
BEGIN 
    
    -- variable declarations
    DECLARE depth INTEGER;
    
    -- depth is our counter variable 
    SET depth = 0;
    
    -- find the root node, (the one with no manager)
    INSERT INTO hierarchy 
        SELECT emp_id 
        FROM employee_adjlist
        WHERE manager_id IS NULL;
    
    -- keep adding children until we can't anymore
    label1: WHILE ROW_COUNT() <> 0 DO
        -- increment our counter variable
        SET depth = depth + 1;
        -- find the children of the nodes that 
        -- are already in our hierarchy table
        INSERT INTO hierarchy
            SELECT employee_adjlist.emp_id
                FROM employee_adjlist
                WHERE manager_id IN (SELECT emp_id FROM hierarchy)
                    AND employee_adjlist.emp_id NOT IN 
                        (SELECT hierarchy.emp_id FROM hierarchy);
    END WHILE label1;
    
    DELETE FROM hierarchy;
    
    RETURN depth;


END !

DELIMITER ;


-- [Problem 6]
DROP FUNCTION IF EXISTS emp_reports;
DROP TABLE IF EXISTS children;

-- didn't do CREATE TEMPORARY TABLE 
-- because I got a Locking issue when running 
-- tests. Error Code 1099
/*
* We use a table in order to store
* the specific nodes' low and high'
* in order to find the immediate children.
* We can use the table and compare it to itself
* to ensure we find only immediate children.
*/
CREATE TABLE children(
    emp_id INTEGER PRIMARY KEY,
    low INTEGER,
    high INTEGER
);

DELIMITER !

/*
* This function returns an integer for the number
* of immediate children a given empoyee_id has.
* It does this by first inserting the entire subtree
* of that employee into the temporary table. We then
* use a query to find the number of immediate children.
* We do this by doing a left join of the temporary
* table on itself on the condition that the first table's
* low and high values are within the second's. Since
* we do a left join, the nodes that do not fit this ON 
* condition will be left with null values, so we know 
* they are the immediate children.
*/
CREATE FUNCTION emp_reports(
    emp_id INTEGER
) RETURNS INTEGER

BEGIN 
    
    -- variable declarations
    DECLARE reports INTEGER;
    DECLARE emp_low INTEGER;
    DECLARE emp_high INTEGER;
    
    -- find the low of our given emp_id
    SELECT low 
        FROM employee_nestset
        WHERE employee_nestset.emp_id = emp_id
        INTO emp_low;
    
    -- find the high of our given emp_id
    SELECT high
        FROM employee_nestset
        WHERE employee_nestset.emp_id = emp_id
        INTO emp_high;
    
    -- if either high or low is NULL, then given emp_id
    -- is not valid
    IF emp_low IS NULL or emp_high IS NULL THEN
        RETURN 0;
    END IF;
    
    -- insert the given employee into our children table
    INSERT INTO children
        SELECT employee_nestset.emp_id, low, high
        FROM employee_nestset
        WHERE low > emp_low AND high < emp_high;
    
    -- count the immediate children
    SELECT COUNT(*)
        FROM children AS c1 LEFT JOIN children AS c2
            ON c1.low > c2.low AND c1.high < c2.high
        -- if c2 is null, then that means it is an immediate child
        WHERE c2.emp_id IS NULL
        INTO reports;
    
    DELETE FROM children;
    
    RETURN reports;

END !

DELIMITER ;

