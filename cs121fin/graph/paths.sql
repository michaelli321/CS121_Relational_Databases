-- [Problem 2a]
DROP PROCEDURE IF EXISTS sp_compute_shortest_paths;

DELIMITER !
/*
* This procedure ~attempts~ to populate the 
* shortest_paths table. It is used to find the 
* length of the shortest possible path between
* every pair of connected nodes. 
*/
CREATE PROCEDURE sp_compute_shortest_paths()

BEGIN
    
    DECLARE node INTEGER;
    DECLARE node1 INTEGER;
    DECLARE node2 INTEGER;
  
    -- declare variables first
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR
        SELECT node_id FROM nodes;
        
    DECLARE cur1 CURSOR FOR
        SELECT from_node_id FROM node_adjacency;
        
    DECLARE cur2 CURSOR FOR
        SELECT to_node_id FROM node_adjacency;
    
    -- When fetch is complete, handler sets flag
    -- 02000 is MySQL error for "zero rows fetched"
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    
     -- we begin by emptying the table
    DELETE FROM shortest_paths; 
    
    OPEN cur;
    
    -- we insert into the table all the paths of the nodes
    -- to itself of a length of 0
    FETCH cur INTO node;
    WHILE NOT done DO
        INSERT INTO shortest_paths
            VALUES (node, node, 0);
            
    END WHILE;
    
    -- insert all the paths of the nodes 
    -- to the first initial node
    INSERT INTO shortest_paths
        SELECT * FROM node_adjacency;
        
    SET done = 1;
    
    -- find the minimum path of the rest of the nodes 
    -- i have no idea how to do this 

END !

DELIMITER ;

-- [Problem 2b]
DROP FUNCTION IF EXISTS compute_centrality;

DELIMITER !

/*
* This function is used to compute the harmonic centrality
* of a given node in a directed graph. It returns a float that 
* represents the centrality
*/
CREATE FUNCTION compute_centrality(
    node INTEGER 
) RETURNS FLOAT

BEGIN 
    
    -- variable declarations
    DECLARE centrality FLOAT;
    DECLARE total FLOAT DEFAULT 0;
    DECLARE denominator INTEGER;
    DECLARE done INT DEFAULT 0;
    DECLARE testNode INT;
    DECLARE testNode2 INT;
    DECLARE distance INT;
    
    DECLARE cur CURSOR FOR 
        SELECT * FROM shortest_paths;
        
    -- When fetch is complete, handler sets flag
    -- 02000 is MySQL error for "zero rows fetched"
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
        SET done = 1;
    
     OPEN cur;
    
    -- we loop through the rows of shortest_paths
    FETCH cur INTO testNode, testNode2, distance;
    WHILE NOT done DO
        -- if the row we're looking at has a path originating from the given 
        -- node
        IF testNode = node THEN
            -- and it isn't going to itself
            IF testNode2 <> node THEN
                -- then we add 1/distance to our running sum
                SET total = distance + (1 / distance);
            END IF;
        END IF;
    END WHILE;
    
    -- find the total number of nodes minus one for the denominator
    SELECT COUNT(*)-1 FROM nodes 
        INTO denominator;
    
    SET centrality = total / denominator;
    
    RETURN centrality;

END !

DELIMITER ;

-- once the compute_centrality function is written, this query 
-- is quite trivial

SELECT node_id, node_name, compute_centrality(node_id) as centrality
    FROM nodes
    ORDER BY centrality DESC
    LIMIT 5;





