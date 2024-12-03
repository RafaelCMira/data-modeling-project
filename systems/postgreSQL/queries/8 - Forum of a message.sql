WITH RECURSIVE original_post AS (
    -- Base case: The input is a post
    SELECT 
        p.message_id AS original_message_id,
        p.forum_id,
        1 AS depth
    FROM post p
    WHERE p.message_id = 1168231123736

    UNION

    -- Base case: The input is a comment
    SELECT 
        p.message_id AS original_message_id,
        p.forum_id,
        1 AS depth
    FROM comment c
    JOIN post p ON c.parent_id = p.message_id
    WHERE c.message_id = 1168231123736

    UNION

    -- Recursive case: Trace comment chain back to the post
    SELECT 
        op.original_message_id,
        p.forum_id,
        op.depth + 1 AS depth -- Increment depth
    FROM comment c
    JOIN original_post op ON c.parent_id = op.original_message_id
    JOIN post p ON op.original_message_id = p.message_id
    WHERE op.depth < 10 -- Limit recursion depth
)
SELECT DISTINCT
    op.original_message_id AS post_id,
    f.forum_id,
    f.title AS forum_title,
    mod.person_id AS moderator_id,
    mod.first_name AS moderator_first_name,
    mod.last_name AS moderator_last_name
FROM original_post op
JOIN forum f ON f.forum_id = op.forum_id
JOIN person mod ON mod.person_id = f.person_id;


select * from comment where message_id = 1168231123736; -- parent_id = 1030792170251
											-- |
											-- V
select * from comment where message_id = 1030792170251; -- parent_id = 687194786570
											-- |
											-- V
select * from comment where message_id = 687194786570;  -- result set empty => it's a post


select * from post where message_id = 687194786570;  -- confirmed it's a post

























-- message: 1168231123736 base comment       result: 562	"Wall of John Chopra"	563	"John"	"Chopra"
--            |
--            V
-- message: 1030792170251 parent comment     result: empty....... FUCKING HELL
--            |
--            V
-- post: 687194786570  parent post           result: 562	"Wall of John Chopra"	563	"John"	"Chopra"
WITH RECURSIVE message_path AS (
    -- Base case: Start with the given message_id (which could be a comment or a post)
    SELECT
        m.message_id,
        c.parent_id,
        p.forum_id
    FROM
        message m
	    LEFT JOIN comment c ON m.message_id = c.message_id
	    LEFT JOIN post p ON m.message_id = p.message_id
    WHERE m.message_id = 1168231123736

    UNION ALL

    -- Recursive case: Traverse upwards if it's a comment, looking for the post
    SELECT
        m.message_id,
        c.parent_id,
        p.forum_id
    FROM
        message_path mp
	    JOIN comment c ON c.message_id = mp.parent_id
	    JOIN message m ON c.parent_id = m.message_id
    	LEFT JOIN post p ON m.message_id = p.message_id  -- Join again to get the post's forum_id
    WHERE p.forum_id IS NOT NULL  -- Stop recursion once we reach a post (with a forum_id)
)
SELECT 
	f.forum_id,
	f.title,
	p.person_id,
	p.first_name,
	p.last_name
FROM 
	message_path m
	JOIN forum f ON m.forum_id = f.forum_id 
	LEFT JOIN person p ON f.person_id = p.person_id
WHERE m.forum_id IS NOT NULL










-- message: 1168231123736 base comment       result: 562	"Wall of John Chopra"	563	"John"	"Chopra"
--            |
--            V
-- message: 1030792170251 parent comment     result: empty....... FUCKING HELL
--            |
--            V
-- post: 687194786570  parent post           result: 562	"Wall of John Chopra"	563	"John"	"Chopra"
WITH RECURSIVE comment_path AS (
    -- Base case: Start with the given comment_id
    SELECT
        c.message_id,
        c.parent_id
    FROM
        comment c
    WHERE c.message_id = 687194786570 -- Replace with the input comment_id

    UNION ALL

    -- Recursive case: Traverse upwards to the parent comments
    SELECT
        c.message_id,
        c.parent_id
    FROM
        comment c
        JOIN comment_path cp ON c.message_id = cp.parent_id
)
SELECT message_id
FROM comment_path

UNION ALL

SELECT parent_id
FROM comment_path
WHERE parent_id NOT IN (SELECT message_id FROM comment);
