// 1 - Find the person_id
// Persons with most friends
MATCH (person:Person)-[:KNOWS*1..2]-(otherPerson:Person)
WITH person, COUNT(DISTINCT otherPerson) AS friendCount
WHERE friendCount > 0
RETURN person.person_id AS personId, friendCount
ORDER BY friendCount DESC
LIMIT 10;

// 2 - Find the countries (probably just use China and India)
// Countries with most messages
MATCH (message:Message)-[:LOCATED_IN]->(country:Country)
WITH country.name AS countryName, COUNT(message) AS messageCount
WHERE messageCount > 0
RETURN countryName, messageCount
ORDER BY messageCount DESC
LIMIT 10;

// 3 - See the results and use the month with most activity
// Find high activity dates
MATCH (message:Message)
RETURN date(message.message_created_at) AS activityDate, COUNT(*) AS messageCount
ORDER BY messageCount DESC
LIMIT 100;


// personId = 4398046513221
// $countryXName = "India"
// $countryYName = "China"
// startDate = "2012-09-01"
MATCH (start:Person {person_id: 4398046513221})-[:KNOWS*1..2]->(otherPerson:Person)
WHERE otherPerson.person_id <> 4398046513221
  AND NOT (otherPerson)-[:LOCATED_IN]->(:City)-[:CITY_OF]->(:Country {name: "China"})
  AND NOT (otherPerson)-[:LOCATED_IN]->(:City)-[:CITY_OF]->(:Country {name: "India"})

WITH DISTINCT otherPerson
MATCH (otherPerson)<-[:POSTED_BY]-(message:Message)-[:LOCATED_IN]->(country:Country)
WHERE country.name = "India"
    AND message.message_created_at >= datetime("2012-11-01")
    AND message.message_created_at < datetime("2012-11-01") + duration({days: 15})
WITH 
    otherPerson, 
    COUNT(message) AS xCount
MATCH (otherPerson)<-[:POSTED_BY]-(message:Message)-[:LOCATED_IN]->(country:Country)
WHERE country.name = "China"
    AND message.message_created_at >= datetime("2012-11-01")
    AND message.message_created_at < datetime("2012-11-01") + duration({days: 15})
WITH 
    otherPerson, 
    xCount, 
    COUNT(message) AS yCount
WHERE xCount > 0 AND yCount > 0
RETURN 
    otherPerson.person_id AS id,
    otherPerson.person_first_name AS firstName,
    otherPerson.person_last_name AS lastName,
    xCount,
    yCount,
    (xCount + yCount) AS count
ORDER BY count DESC, id ASC;
