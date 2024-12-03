-- Person with more friends
SELECT person_id1, COUNT(person_id2) as total
from knows
GROUP by person_id1
ORDER BY total desc
LIMIT 1
;

-- Friends (direct + friends of friends until 4th degree) that live in the same city
WITH all_connections AS (
    -- Direct friends (1st degree)
    SELECT 
        k1.person_id2 AS friend_id
    FROM knows k1
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Friends of friends (2nd degree)
    SELECT 
        k2.person_id2 AS friend_id
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Friends of friends of friends (3rd degree)
    SELECT 
        k3.person_id2 AS friend_id
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
    WHERE k1.person_id1 = 3648

    UNION ALL

    -- Friends of friends of friends of friends (4th degree)
    SELECT 
        k4.person_id2 AS friend_id
    FROM knows k1
        JOIN knows k2 ON k1.person_id2 = k2.person_id1
        JOIN knows k3 ON k2.person_id2 = k3.person_id1
        JOIN knows k4 ON k3.person_id2 = k4.person_id1
    WHERE k1.person_id1 = 3648
)
SELECT DISTINCT
	p.person_id,
	p.first_name,
	p.last_name
FROM all_connections ac
    JOIN person p ON ac.friend_id = p.person_id
WHERE p.city_id = (SELECT city_id FROM person WHERE person_id = 3648);


