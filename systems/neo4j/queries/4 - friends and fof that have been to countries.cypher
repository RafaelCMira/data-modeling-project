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
WITH 4398046513221 AS personIdParam, "India" AS countryXNameParam, "China" AS countryYNameParam, datetime("2012-11-01") AS startDateParam, duration({days: 15}) AS durationParam
MATCH (start:Person {person_id: personIdParam})-[:KNOWS*1..2]->(otherPerson:Person)
WHERE otherPerson.person_id <> personIdParam
  AND NOT (otherPerson)-[:LOCATED_IN]->(:City)-[:CITY_OF]->(:Country {name: countryXNameParam})
  AND NOT (otherPerson)-[:LOCATED_IN]->(:City)-[:CITY_OF]->(:Country {name: countryYNameParam})

WITH DISTINCT otherPerson, countryXNameParam, countryYNameParam, startDateParam, durationParam
MATCH (otherPerson)<-[:POSTED_BY]-(message:Message)-[:LOCATED_IN]->(country:Country)
WHERE country.name = countryYNameParam
    AND message.message_created_at >= startDateParam
    AND message.message_created_at < startDateParam + durationParam
WITH 
    otherPerson, 
    COUNT(message) AS xCount,
    countryXNameParam,
    countryYNameParam,
    startDateParam,
    durationParam
MATCH (otherPerson)<-[:POSTED_BY]-(message:Message)-[:LOCATED_IN]->(country:Country)
WHERE country.name = countryXNameParam
    AND message.message_created_at >= startDateParam
    AND message.message_created_at < startDateParam + durationParam
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
