-- Find persons linked to person with id 3648 by at most 4 steps with a given first name
WITH target_persons AS (
    -- Precompute the filtered list of persons with the given first_name
    SELECT person_id, first_name
    FROM person
    WHERE first_name = 'Arjun'
),
connections AS (
    -- Step 1: Direct friends (distance = 1)
    SELECT 
        k1.person_id2 AS person_id, 
        1 AS distance
    FROM knows k1
        JOIN target_persons tp ON k1.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Step 2: Friends of friends (distance = 2)
    SELECT 
        k2.person_id2 AS person_id, 
        2 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN target_persons tp ON k2.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Step 3: Friends of friends of friends (distance = 3)
    SELECT 
        k3.person_id2 AS person_id, 
        3 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN target_persons tp ON k3.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    SELECT 
        k4.person_id2 AS person_id,
        4 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN knows k4 ON k3.person_id2 = k4.person_id1
        JOIN target_persons tp ON k4.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648
)
SELECT DISTINCT
    c.person_id,
    p.first_name,
    p.last_name,
    p.birthday,
    p.gender,
    c.distance as distance,
    ci.name AS city,
    company.name AS workplace,
	u.name as university
FROM connections c
    JOIN person p ON c.person_id = p.person_id
    JOIN city ci ON p.city_id = ci.city_id
  	LEFT JOIN works w ON c.person_id = w.person_id
	LEFT JOIN company ON w.company_id = company.company_id
	LEFT JOIN studies s ON c.person_id = s.person_id
	LEFT JOIN university u ON u.university_id = s.university_id
WHERE c.person_id != 3648
ORDER BY c.distance, c.person_id
LIMIT 20
;




-- Find persons linked to person with id 3648 by at most 5 steps with a given first name
WITH target_persons AS (
    -- Precompute the filtered list of persons with the given first_name
    SELECT person_id, first_name
    FROM person
    WHERE first_name = 'Arjun'
),
connections AS (
    -- Step 1: Direct friends (distance = 1)
    SELECT 
        k1.person_id2 AS person_id, 
        1 AS distance
    FROM knows k1
        JOIN target_persons tp ON k1.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Step 2: Friends of friends (distance = 2)
    SELECT 
        k2.person_id2 AS person_id, 
        2 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN target_persons tp ON k2.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Step 3: Friends of friends of friends (distance = 3)
    SELECT 
        k3.person_id2 AS person_id, 
        3 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN target_persons tp ON k3.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    SELECT 
        k4.person_id2 AS person_id,
        4 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN knows k4 ON k3.person_id2 = k4.person_id1
        JOIN target_persons tp ON k4.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    SELECT 
        k5.person_id2 AS person_id,
        5 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN knows k4 ON k3.person_id2 = k4.person_id1
        JOIN knows k5 ON k4.person_id2 = k5.person_id1
        JOIN target_persons tp ON k5.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648
)
SELECT DISTINCT
    c.person_id,
    p.first_name,
    p.last_name,
    p.birthday,
    p.gender,
    c.distance as distance,
    ci.name AS city,
    company.name AS workplace,
	u.name as university
FROM connections c
    JOIN person p ON c.person_id = p.person_id
    JOIN city ci ON p.city_id = ci.city_id
  	LEFT JOIN works w ON c.person_id = w.person_id
	LEFT JOIN company ON w.company_id = company.company_id
	LEFT JOIN studies s ON c.person_id = s.person_id
	LEFT JOIN university u ON u.university_id = s.university_id
WHERE c.person_id != 3648
ORDER BY c.distance, c.person_id
LIMIT 20
;



-- Find persons linked to person with id 3648 by at most 6 steps with a given first name
WITH target_persons AS (
    -- Precompute the filtered list of persons with the given first_name
    SELECT person_id, first_name
    FROM person
    WHERE first_name = 'Arjun'
),
connections AS (
    -- Step 1: Direct friends (distance = 1)
    SELECT 
        k1.person_id2 AS person_id, 
        1 AS distance
    FROM knows k1
        JOIN target_persons tp ON k1.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Step 2: Friends of friends (distance = 2)
    SELECT 
        k2.person_id2 AS person_id, 
        2 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN target_persons tp ON k2.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Step 3: Friends of friends of friends (distance = 3)
    SELECT 
        k3.person_id2 AS person_id, 
        3 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN target_persons tp ON k3.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    SELECT 
        k4.person_id2 AS person_id,
        4 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN knows k4 ON k3.person_id2 = k4.person_id1
        JOIN target_persons tp ON k4.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    SELECT 
        k5.person_id2 AS person_id,
        5 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN knows k4 ON k3.person_id2 = k4.person_id1
        JOIN knows k5 ON k4.person_id2 = k5.person_id1
        JOIN target_persons tp ON k5.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648

    UNION ALL

    SELECT 
        k6.person_id2 AS person_id,
        6 AS distance
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN knows k4 ON k3.person_id2 = k4.person_id1
        JOIN knows k5 ON k4.person_id2 = k5.person_id1
        JOIN knows k6 ON k5.person_id2 = k6.person_id1
        JOIN target_persons tp ON k6.person_id2 = tp.person_id -- Early filtering here
    WHERE k1.person_id1 = 3648
)
SELECT DISTINCT
    c.person_id,
    p.first_name,
    p.last_name,
    p.birthday,
    p.gender,
    c.distance as distance,
    ci.name AS city,
    company.name AS workplace,
	u.name as university
FROM connections c
    JOIN person p ON c.person_id = p.person_id
    JOIN city ci ON p.city_id = ci.city_id
  	LEFT JOIN works w ON c.person_id = w.person_id
	LEFT JOIN company ON w.company_id = company.company_id
	LEFT JOIN studies s ON c.person_id = s.person_id
	LEFT JOIN university u ON u.university_id = s.university_id
WHERE c.person_id != 3648
ORDER BY c.distance, c.person_id
LIMIT 20
;