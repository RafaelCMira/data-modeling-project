// How to find comments with more than X comments before reaching the post
// Replace X with the number of comments
MATCH path = (c:Comment)-[:REPLY_OF*X]->(p:Post)
RETURN c, nodes(path) AS pathNodes, p
LIMIT 5;



// 8 comments to get to a post: message_id: 1168231108163

MATCH (message:Message {message_id: 1168231108163})
OPTIONAL MATCH path = (message)-[:REPLY_OF*]->(post:Post)
WITH 
    message, 
    post, 
    CASE 
        WHEN post IS NOT NULL 
        THEN post 
        ELSE message 
    END AS targetPost
MATCH (targetPost:Post)-[:POSTED_IN]->(forum:Forum)
OPTIONAL MATCH (moderator:Person)-[:MODERATOR_OF]->(forum:Forum)
RETURN 
    forum.forum_id,
    forum.forum_title,
    moderator.person_id,
    moderator.person_first_name,
    moderator.person_last_name
;