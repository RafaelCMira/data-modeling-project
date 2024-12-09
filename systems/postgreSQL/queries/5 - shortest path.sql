-- Shortest path between two users
WITH path AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT id, source, target, cost FROM edges', 
        17592186047566,  -- Start node
        21990232558093   -- End node
    )
)
SELECT 
    array_agg(p.person_id ORDER BY path.seq) AS path_nodes
FROM path
JOIN person p ON p.person_id = path.node;


-- Find the user with most friends
with friend_count as (
	SELECT person_id1, count(*) as total_friends
	FROM knows
	GROUP by person_id1
)
SELECT 
	p.person_id, 
	p.first_name, 
	p.last_name, 
	fc.total_friends
FROM friend_count fc
	JOIN person p ON p.person_id = fc.person_id1
WHERE fc.total_friends = (
    SELECT MAX(total_friends)
    FROM friend_count
);



-- Gives 2 random users with more than x friends and less than y friends
WITH friend_counts AS (
    SELECT person_id1, count(*) AS total_friends
    FROM knows
    GROUP BY person_id1
)
SELECT 
    p.person_id, 
    p.first_name, 
    p.last_name, 
    fc.total_friends
FROM friend_counts fc
	JOIN person p ON p.person_id = fc.person_id1
WHERE fc.total_friends > 1 AND fc.total_friends < 3
ORDER BY random()
LIMIT 2; 