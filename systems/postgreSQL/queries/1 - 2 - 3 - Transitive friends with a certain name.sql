-- Find persons linked to person with id 3648 by at most 4 steps with a given first name
WITH RECURSIVE knows_path AS (
    -- Base case: direct neighbors
    SELECT
        k1.person_id1 AS start_person_id,
        k1.person_id2 AS connected_person_id,
        1 AS distance
    FROM knows k1
    WHERE k1.person_id1 = 3648
    
    UNION ALL
    
    -- Recursive case: expand the path
    SELECT
        kp.start_person_id,
        k.person_id2 AS connected_person_id,
        kp.distance + 1
    FROM knows_path kp
    	JOIN knows k ON kp.connected_person_id = k.person_id1
    WHERE kp.distance < 4
)
-- Filter to get the shortest path for each connected person
, shortest_path AS (
    SELECT
        connected_person_id,
        MIN(distance) AS distance
    FROM knows_path
    WHERE connected_person_id != 3648
    GROUP BY connected_person_id
)
-- Main query: join with other tables
SELECT
    p.person_id AS id,
    p.last_name,
    sp.distance,
    p.birthday,
    p.created_at,
    p.gender,
    p.browser_used,
    p.location_ip,
    c.name AS city_name,
    ARRAY_AGG(DISTINCT co.name) AS workplaces,
    ARRAY_AGG(DISTINCT u.name) AS places_of_study
FROM shortest_path sp
	JOIN person p ON sp.connected_person_id = p.person_id
	JOIN city c ON p.city_id = c.city_id
	LEFT JOIN works wa ON p.person_id = wa.person_id
	LEFT JOIN company co ON wa.company_id = co.company_id
	LEFT JOIN studies sa ON p.person_id = sa.person_id
	LEFT JOIN university u ON sa.university_id = u.university_id
WHERE p.first_name = 'Arjun'
GROUP BY
    p.person_id,
    p.last_name,
    sp.distance,
    p.birthday,
    p.created_at,
    p.gender,
    p.browser_used,
    p.location_ip,
    c.name
ORDER BY sp.distance, p.last_name, id
LIMIT 20;





-- Find persons linked to person with id 3648 by at most 5 steps with a given first name
WITH RECURSIVE knows_path AS (
    -- Base case: direct neighbors
    SELECT
        k1.person_id1 AS start_person_id,
        k1.person_id2 AS connected_person_id,
        1 AS distance
    FROM knows k1
    WHERE k1.person_id1 = 3648
    
    UNION ALL
    
    -- Recursive case: expand the path
    SELECT
        kp.start_person_id,
        k.person_id2 AS connected_person_id,
        kp.distance + 1
    FROM knows_path kp
    	JOIN knows k ON kp.connected_person_id = k.person_id1
    WHERE kp.distance < 5
)
-- Filter to get the shortest path for each connected person
, shortest_path AS (
    SELECT
        connected_person_id,
        MIN(distance) AS distance
    FROM knows_path
    WHERE connected_person_id != 3648
    GROUP BY connected_person_id
)
-- Main query: join with other tables
SELECT
    p.person_id AS id,
    p.last_name,
    sp.distance,
    p.birthday,
    p.created_at,
    p.gender,
    p.browser_used,
    p.location_ip,
    c.name AS city_name,
    ARRAY_AGG(DISTINCT co.name) AS workplaces,
    ARRAY_AGG(DISTINCT u.name) AS places_of_study
FROM shortest_path sp
JOIN person p ON sp.connected_person_id = p.person_id
JOIN city c ON p.city_id = c.city_id
LEFT JOIN works wa ON p.person_id = wa.person_id
LEFT JOIN company co ON wa.company_id = co.company_id
LEFT JOIN studies sa ON p.person_id = sa.person_id
LEFT JOIN university u ON sa.university_id = u.university_id
WHERE p.first_name = 'Arjun'
GROUP BY
    p.person_id,
    p.last_name,
    sp.distance,
    p.birthday,
    p.created_at,
    p.gender,
    p.browser_used,
    p.location_ip,
    c.name
ORDER BY sp.distance, p.last_name, id
LIMIT 20;




-- Find persons linked to person with id 3648 by at most 6 steps with a given first name
WITH RECURSIVE knows_path AS (
    -- Base case: direct neighbors
    SELECT
        k1.person_id1 AS start_person_id,
        k1.person_id2 AS connected_person_id,
        1 AS distance
    FROM knows k1
    WHERE k1.person_id1 = 3648
    
    UNION ALL
    
    -- Recursive case: expand the path
    SELECT
        kp.start_person_id,
        k.person_id2 AS connected_person_id,
        kp.distance + 1
    FROM knows_path kp
    	JOIN knows k ON kp.connected_person_id = k.person_id1
    WHERE kp.distance < 6
)
-- Filter to get the shortest path for each connected person
, shortest_path AS (
    SELECT
        connected_person_id,
        MIN(distance) AS distance
    FROM knows_path
    WHERE connected_person_id != 3648
    GROUP BY connected_person_id
)
-- Main query: join with other tables
SELECT
    p.person_id AS id,
    p.last_name,
    sp.distance,
    p.birthday,
    p.created_at,
    p.gender,
    p.browser_used,
    p.location_ip,
    c.name AS city_name,
    ARRAY_AGG(DISTINCT co.name) AS workplaces,
    ARRAY_AGG(DISTINCT u.name) AS places_of_study
FROM shortest_path sp
JOIN person p ON sp.connected_person_id = p.person_id
JOIN city c ON p.city_id = c.city_id
LEFT JOIN works wa ON p.person_id = wa.person_id
LEFT JOIN company co ON wa.company_id = co.company_id
LEFT JOIN studies sa ON p.person_id = sa.person_id
LEFT JOIN university u ON sa.university_id = u.university_id
WHERE p.first_name = 'Arjun'
GROUP BY
    p.person_id,
    p.last_name,
    sp.distance,
    p.birthday,
    p.created_at,
    p.gender,
    p.browser_used,
    p.location_ip,
    c.name
ORDER BY sp.distance, p.last_name, id
LIMIT 20;