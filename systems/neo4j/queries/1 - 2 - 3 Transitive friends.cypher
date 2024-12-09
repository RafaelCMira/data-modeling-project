match(n:Person)-[:LOCATED_IN]->(:City)-[:CITY_OF]->(c:Country{name:'United_States'})
return n
LIMIT 500;


WITH 3648 AS personIdParam, "Arjun" AS personFirstNameParam 
MATCH path = (start:Person {person_id: personIdParam})-[:KNOWS*1..4]->(p:Person)
WHERE p.person_first_name = personFirstNameParam AND p.person_id <> personIdParam
WITH p, min(length(path)) AS distance
OPTIONAL MATCH (p)-[:WORKS_AT]->(company:Company)
WITH p, distance, collect(company.name) AS workplaces
OPTIONAL MATCH (p)-[:STUDIES_AT]->(university:University)
WITH p, distance, workplaces, collect(university.name) AS placesOfStudy
OPTIONAL MATCH (p)-[:LOCATED_IN]->(city:City)
RETURN 
    p.person_id AS id,
    p.person_last_name,
    distance,
    p.person_birthday,
    p.person_created_at,
    p.person_gender,
    p.person_browser_used,
    p.person_location_ip,
    city.name,
    workplaces,
    placesOfStudy
ORDER BY distance, p.person_last_name, id
LIMIT 20;