-- Friends of Friends
WITH foaf AS (
    SELECT DISTINCT k2.person_id2 AS person_id
    FROM knows k1
	    JOIN knows k2 ON k1.person_id2 = k2.person_id1
    WHERE k1.person_id1 = 4398046513970
),
-- Filter foaf by Birthdays
filtered_foaf AS (
    SELECT 
        p.person_id AS foaf_id, 
        p.first_name, 
        p.last_name, 
        p.gender, 
        p.city_id
    FROM person p
    JOIN foaf f ON p.person_id = f.person_id
    WHERE (
        EXTRACT(MONTH FROM p.birthday) = 1 AND EXTRACT(DAY FROM p.birthday) >= 21
    ) OR (
        EXTRACT(MONTH FROM p.birthday) = (1 % 12) + 1 AND EXTRACT(DAY FROM p.birthday) < 22
    )
),
-- Collect Tags of Interest
person_tags AS (
    SELECT t.tag_id
    FROM has_interest t
    WHERE t.person_id = 4398046513970
),
-- Calculate Common Posts
common_posts AS (
    SELECT
        f.foaf_id,
        COUNT(DISTINCT p.message_id) AS common_count
    FROM filtered_foaf f
	    JOIN message m ON f.foaf_id = m.person_id
	    JOIN post p ON p.message_id = m.message_id
	    JOIN message_tags mt ON p.message_id = mt.message_id
    WHERE mt.tag_id IN (SELECT tag_id FROM person_tags)
    GROUP BY f.foaf_id
),
-- Calculate Uncommon Posts
uncommon_posts AS (
    SELECT
        f.foaf_id,
        COUNT(DISTINCT p.message_id) AS uncommon_count
    FROM filtered_foaf f
	    JOIN message m ON f.foaf_id = m.person_id
	    JOIN post p USING(message_id)
    WHERE NOT EXISTS (
        SELECT 1
        FROM message_tags mt
        WHERE mt.message_id = p.message_id
          AND mt.tag_id IN (SELECT tag_id FROM person_tags)
    )
    GROUP BY f.foaf_id
)
-- Combine Results and Return
SELECT
    f.foaf_id,
    COALESCE(cp.common_count, 0) - COALESCE(up.uncommon_count, 0) AS common_interest_score
FROM filtered_foaf f
	JOIN city c USING(city_id)
	LEFT JOIN common_posts cp USING(foaf_id)
	LEFT JOIN uncommon_posts up USING(foaf_id)
ORDER BY common_interest_score DESC, f.foaf_id ASC
LIMIT 10;
