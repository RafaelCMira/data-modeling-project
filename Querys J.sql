--Recent messages by your friends
WITH friends AS (
    SELECT
        CASE
            WHEN k.person_id1 = 1931 THEN k.person_id2
            ELSE k.person_id1
        END AS friend_id
    FROM knows k
    WHERE k.person_id1 = 1931 OR k.person_id2 = 1931
),
friend_messages AS (
    SELECT
        m.message_id,
        m.content,
        m.created_at,
        m.person_id
    FROM message m
    INNER JOIN friends f ON f.friend_id = m.person_id
    WHERE m.created_at < '2012-10-16 12:24:36.099'
)
SELECT
    fm.message_id,
    fm.content,
    fm.created_at,
    fm.person_id,
    p.first_name,
    p.last_name
FROM friend_messages fm
JOIN person p ON fm.person_id = p.person_id
ORDER BY fm.created_at DESC;


--Friend recommendation
WITH immediate_friends AS (
    SELECT person_id2 AS friend_id
    FROM knows
    WHERE person_id1 = 1931
    UNION
    SELECT person_id1 AS friend_id
    FROM knows
    WHERE person_id2 = 1931
),
foaf AS (
    SELECT DISTINCT 
        CASE 
            WHEN k.person_id1 = f.friend_id THEN k.person_id2
            ELSE k.person_id1
        END AS foaf_id
    FROM knows k
    JOIN immediate_friends f
        ON k.person_id1 = f.friend_id OR k.person_id2 = f.friend_id
    WHERE k.person_id1 != 1931 AND k.person_id2 != 1931
),
filtered_foaf AS (
    SELECT p.person_id AS foaf_id, p.first_name, p.last_name, p.birthday, p.gender, p.city_id
    FROM person p
    JOIN foaf f ON p.person_id = f.foaf_id
    WHERE (EXTRACT(DAY FROM p.birthday) >= 21 AND EXTRACT(MONTH FROM p.birthday) = 3)
       OR (EXTRACT(DAY FROM p.birthday) < 22 AND EXTRACT(MONTH FROM p.birthday) = 3 + 1)
),
start_person_interests AS (
    SELECT tag_id
    FROM has_interest
    WHERE person_id = 1931
),
foaf_posts AS (
    SELECT m.person_id AS foaf_id, m.message_id, mt.tag_id
    FROM message m
    LEFT JOIN message_tags mt ON m.message_id = mt.message_id
),
tagged_posts AS (
    SELECT fp.foaf_id,
           SUM(CASE WHEN fp.tag_id IS NOT NULL THEN 1 ELSE 0 END) AS common,
           SUM(CASE WHEN fp.tag_id IS NULL THEN 1 ELSE 0 END) AS uncommon
    FROM foaf_posts fp
    LEFT JOIN start_person_interests spi
        ON fp.tag_id = spi.tag_id
    GROUP BY fp.foaf_id
)
SELECT ff.foaf_id, 
       ff.first_name, 
       ff.last_name, 
       ff.birthday, 
       ff.gender, 
       c.name AS city_name, 
       COALESCE(tp.common, 0) - COALESCE(tp.uncommon, 0) AS commonInterestScore
FROM filtered_foaf ff
LEFT JOIN tagged_posts tp
    ON ff.foaf_id = tp.foaf_id
LEFT JOIN city c
    ON ff.city_id = c.city_id
ORDER BY commonInterestScore DESC;

--Recent messages of a person
WITH last_10_messages AS (
    SELECT m.message_id, m.content, m.created_at, p.message_id AS original_post_id
    FROM message m
    LEFT JOIN post p ON m.message_id = p.message_id
    WHERE m.person_id = 1931
    ORDER BY m.created_at DESC
    LIMIT 10
)
SELECT
    m.message_id AS message_id,              
    m.content AS message_content,            
    m.created_at AS message_creation_date,  
    COALESCE(p.message_id, m.message_id) AS post_id, 
    op.person_id AS original_poster_id,   
    op.first_name AS original_poster_first_name, 
    op.last_name AS original_poster_last_name 
FROM last_10_messages l10
JOIN message m ON m.message_id = l10.message_id
LEFT JOIN post p ON p.message_id = l10.original_post_id
LEFT JOIN message post ON post.message_id = COALESCE(p.message_id, m.message_id)
LEFT JOIN person op ON op.person_id = post.person_id;

--Replies of a message
SELECT 
    c.message_id AS comment_id,
    m.content AS comment_content,
    m.created_at AS comment_created_at,
    m.person_id AS reply_author_id,
    p.first_name AS reply_author_first_name,
    p.last_name AS reply_author_last_name,
    CASE 
        WHEN m.person_id = original_message.person_id THEN FALSE
        ELSE EXISTS (
            SELECT 1
            FROM knows k
            WHERE (k.person_id1 = original_message.person_id AND k.person_id2 = m.person_id)
               OR (k.person_id1 = m.person_id AND k.person_id2 = original_message.person_id)
        )
    END AS knows
FROM comment c
JOIN message m ON c.message_id = m.message_id
JOIN message original_message ON c.parent_id = original_message.message_id
JOIN person p ON m.person_id = p.person_id
WHERE c.parent_id = 687194970420; 
