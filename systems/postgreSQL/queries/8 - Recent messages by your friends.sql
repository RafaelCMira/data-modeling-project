SELECT
	p.person_id,
	p.first_name,
	p.last_name,
	m.message_id,
	m.content,
	m.created_at
FROM knows k
	JOIN message m ON m.person_id = k.person_id2
	JOIN person p ON m.person_id = p.person_id
WHERE 
	k.person_id1 = 1874 
	AND
	m.created_at < '2012-10-01'
ORDER BY m.created_at DESC, m.message_id ASC
LIMIT 20;
