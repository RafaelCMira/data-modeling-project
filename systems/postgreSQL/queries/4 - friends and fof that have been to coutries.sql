WITH friends AS (
    SELECT k1.person_id2 as person_id
    FROM knows k1
    WHERE k1.person_id1 = 4398046513221

    UNION

    SELECT k2.person_id2 as person_id
    FROM knows k1
	    JOIN knows k2 ON k1.person_id2 = k2.person_id1
    WHERE k1.person_id1 = 4398046513221
)
,
excluded_friends AS (
	SELECT f.person_id
	FROM friends f
		JOIN person p ON f.person_id = p.person_id 
		JOIN city c ON p.city_id = c.city_id
		JOIN country ct ON c.country_id = ct.country_id
	WHERE ct.name NOT IN ('India', 'China')
),
messages_in_xCountry AS (
    SELECT 
        m.person_id,
        COUNT(m.message_id) AS xCount
    FROM message m
	    JOIN country ct ON m.country_id = ct.country_id
    WHERE 
		ct.name = 'India' 
		AND m.created_at BETWEEN '2012-11-01 00:00:00' AND '2012-11-01 00:00:00'::TIMESTAMP + INTERVAL '15 days'
    GROUP BY m.person_id
),
messages_in_yCountry AS (
    SELECT 
        m.person_id,
        COUNT(m.message_id) AS yCount
    FROM message m
	    JOIN country ct ON m.country_id = ct.country_id
    WHERE 
		ct.name = 'China' 
		AND m.created_at BETWEEN '2012-11-01' AND '2012-11-01 00:00:00'::TIMESTAMP + INTERVAL '15 days'
    GROUP BY m.person_id
)
SELECT
    ef.person_id,
   	p.first_name,
  	p.last_name,
   	mx.xCount,
	my.yCount,
	mx.xCount + my.yCount AS count
FROM excluded_friends ef
	JOIN person p ON ef.person_id = p.person_id
	JOIN messages_in_xCountry mx ON (ef.person_id = mx.person_id AND COALESCE(mx.xCount, 0) > 0)
	JOIN messages_in_yCountry my ON (ef.person_id = my.person_id AND COALESCE(my.yCount, 0) > 0)
ORDER BY count DESC, ef.person_id ASC
LIMIT 20;

