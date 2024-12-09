// How to get the commnent based on the replies count
MATCH(c:Comment)<-[r:REPLY_OF]-(:Comment)
WITH c, count(r) as replies
WHERE replies > 4 AND replies < 6
RETURN c, replies
LIMIT 1;


WITH 1030792170251 AS messageIdParam
MATCH (creator:Person)<-[:POSTED_BY]-(m:Message {message_id: messageIdParam})<-[:REPLY_OF]-(c:Comment)-[:POSTED_BY]->(replyAuthor:Person)
RETURN 
    c.message_id as ReplyId,
    c.message_content as content,
    c.message_created_at,
    replyAuthor.person_id,
    replyAuthor.person_first_name,
    replyAuthor.person_last_name,
    CASE 
        WHEN (creator)-[:KNOWS]->(replyAuthor) THEN true
        ELSE false
    END AS knows
ORDER BY c.created_at DESC, replyAuthor.person_id ASC;