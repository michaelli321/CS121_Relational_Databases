-- [Problem 1a]
/*
* use DISTINCT to get rid of duplicates. Also LEFT JOIN course in order to 
* keep all courses that the students are taking and to check the department
* that the class if from
*/
SELECT DISTINCT name 
    FROM takes NATURAL JOIN student LEFT JOIN course 
    ON takes.course_id = course.course_id
    WHERE course.dept_name = 'Comp. Sci.';

-- [Problem 1b]
SELECT dept_name, MAX(salary) AS max_salary
    FROM instructor
    GROUP BY dept_name;

-- [Problem 1c]
/* 
* use a select query in the argument of FROM 
* to create a derived relation of max salary instructors
* instead of using a with statement
*/
SELECT MIN(max_salary) AS min_salary
    FROM 
        (SELECT dept_name, MAX(salary) as max_salary
        FROM instructor
        GROUP BY dept_name) AS max_dept_sal;

-- [Problem 1d]
WITH t AS (SELECT dept_name, MAX(salary) AS max_salary 
    FROM instructor GROUP BY dept_name)
SELECT MIN(max_salary) AS min_salary
    FROM t;

-- [Problem 2a]
INSERT INTO course
    VALUES ('CS-001', 'Weekly Seminar', 'Comp. Sci.', 0);
	
-- [Problem 2b]
INSERT INTO section (course_id, sec_id, semester, year)
    VALUES ('CS-001', 1, 'Fall', 2009) ;

-- [Problem 2c]
INSERT INTO takes (ID, course_id, sec_id, semester, year)
    SELECT ID, 'CS-001', 1, 'Fall', 2009
    FROM student
    Where dept_name = 'Comp. Sci.';

-- [Problem 2d]
/* 
* find the id of chavez and use it as a conditional 
* in the where clause for ID in takes to = it. and make 
* sure course_id and sec_id are the ones we want
*/
DELETE FROM takes 
    WHERE (ID = (SELECT ID FROM student WHERE name = 'Chavez') 
    AND course_id = 'CS-001' AND sec_id = 1);

-- [Problem 2e]
DELETE FROM course
    WHERE course_id = 'CS-001';
    
/*  
* If we run this delete statement without first deleting offerings 
* of the course, it is automatically deleted from the section relation. 
* This is because the course_id key is connected with the section course_id 
* since section is a child relation of course so when the course is deleted, 
* then its section is automatically removed 
* as well.
*/ 

-- [Problem 2f]
/* 
* locate returns 0 if the substring is not in the string it is
* comparing with, thus we want to select all the courses
* where locate does not return 0
*/
DELETE FROM takes
    WHERE (course_id = (SELECT course_id
        FROM course
        WHERE locate('database', title) != 0));
        
-- [Problem 3a]
/* 
* use DISTINCT in order to get rid of duplicates
* we natual join to find all the members who have borrowed what books
* and match it to when publisher = 'McGraw-Hill'
*/
SELECT DISTINCT name
    FROM (member NATURAL JOIN book NATURAL JOIN borrowed)
    WHERE publisher = 'McGraw-Hill';

-- [Problem 3b]
/*
* relation t is the relation of all isbn's of books by mcgraw-hill
* relation s is the relation of the total number of books by mcgraw-hill
* relation r is the relation consisting of the count of all mcgraw-hill books
* borrowed by members
* similarly to problem 2.9 from last week, we cross r and s to compare 
* our number of mcgraw-hill books to number of books borrowed
*/
WITH t AS (SELECT isbn 
    FROM book
    WHERE publisher = 'Mcgraw-Hill'),
s AS (SELECT COUNT(title) AS book_count
    FROM book
    WHERE publisher = 'McGraw-Hill'),
r AS (SELECT name, COUNT(name) AS name_count
    FROM (t LEFT JOIN borrowed ON t.isbn = borrowed.isbn NATURAL JOIN member)
    GROUP BY name)
SELECT name
    FROM r, s
    WHERE name_count = book_count;

-- [Problem 3c]
/* 
* natural join book, borrowed, and member in order to find all 
* books that are borrowed by what member. Then we group by 
* publisher and name to get our number of titles per person and publisher
*/
SELECT  publisher, name
    FROM book NATURAL JOIN borrowed NATURAL JOIN member
    GROUP BY publisher, name
    HAVING COUNT(title) > 5;

-- [Problem 3d]
/*
* instead of using with, we use a select query to generate
* a derived relation consisting of the number of books borrowed per member
*/
SELECT AVG(book_count) AS average_borrowed
    FROM (SELECT name, COUNT(distinct isbn) AS book_count
        FROM member LEFT JOIN borrowed ON member.memb_no = borrowed.memb_no
        GROUP BY name) AS member_books;

-- [Problem 3e]
/* 
* used the same select query from part d, but used WITH
*/
WITH member_books AS (SELECT name, COUNT(distinct isbn) as book_count
    FROM member LEFT JOIN borrowed on member.memb_no = borrowed.memb_no
        GROUP BY name)
    SELECT AVG(book_count) AS average_borrowed
    FROM member_books

