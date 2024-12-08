MATCH (p:Person {person_id:1874})-[:KNOWS]->(f:Person)<-[:POSTED_BY]-(m:Message)
WHERE m.message_created_at < datetime("2012-10-01")
RETURN 
    f.person_id,
    f.person_first_name,
    f.person_last_name,
    m.message_id,
    m.message_content,
    m.message_created_at
ORDER BY m.message_created_at DESC, m.message_id ASC
LIMIT 20;