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