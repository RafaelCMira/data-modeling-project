select * from comment where message_id = 1168231123736; -- parent_id = 1030792170251
											-- |
											-- V
select * from comment where message_id = 1030792170251; -- parent_id = 687194786570
											-- |
											-- V
select * from comment where message_id = 687194786570;  -- result set empty => it's a post


select * from post where message_id = 687194786570;  -- confirmed it's a post









drop function get_forum_and_moderator;
CREATE OR REPLACE FUNCTION get_forum_and_moderator(param_message_id BIGINT)
RETURNS TABLE (
    forum_id BIGINT,
    forum_title VARCHAR(150),
    moderator_id BIGINT,
    moderator_first_name VARCHAR(50),
    moderator_last_name VARCHAR(50)
) 
LANGUAGE plpgsql
AS $$
DECLARE
    is_post BOOLEAN;
    post_id BIGINT;
BEGIN
    -- Step 1: Check if the input is a Post
    SELECT EXISTS (
        SELECT 1 
        FROM post 
        WHERE message_id = param_message_id
    ) INTO is_post;

    IF is_post THEN
        -- Step 2: If the input is a Post, set post_id to message_id
        post_id := param_message_id;
    ELSE
        -- Step 3: If the input is a Comment, find the root Post recursively
        WITH RECURSIVE comment_to_post AS (
            SELECT 
                c.message_id AS comment_id, 
                c.parent_id AS parent_id
            FROM comment c
            WHERE c.message_id = param_message_id

            UNION ALL

            SELECT 
                c.message_id AS comment_id,
                c.parent_id AS parent_id
            FROM comment c
            JOIN comment_to_post ct ON c.message_id = ct.parent_id
        )
        SELECT 
            COALESCE(p.message_id, ct.parent_id) INTO post_id
        FROM comment_to_post ct
        	LEFT JOIN post p ON ct.parent_id = p.message_id
        WHERE p.message_id IS NOT NULL
        LIMIT 1;
    END IF;

    -- Step 4: Return forum and moderator details
    RETURN QUERY
    SELECT 
        f.forum_id,
        f.title AS forum_title,
        pr.person_id AS moderator_id,
        pr.first_name AS moderator_first_name,
        pr.last_name AS moderator_last_name
    FROM post pt
    JOIN forum f ON pt.forum_id = f.forum_id
    LEFT JOIN person pr ON f.person_id = pr.person_id
    WHERE pt.message_id = post_id;
END;
$$;




SELECT * FROM get_forum_and_moderator(1168231123736);



