// Find the shortest path between two people
MATCH p = shortestPath(
    (p1:Person {person_id: 1796})-[:KNOWS*]-(p2:Person {person_id: 135})
)
RETURN [n IN nodes(p) | n.person_id] AS person_ids
