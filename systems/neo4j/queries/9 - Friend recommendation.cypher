WITH 1 AS monthParam, 4398046513970 AS personIdParam
MATCH (p:Person {person_id: personIdParam})-[:KNOWS*2..2]->(foaf:Person)
WHERE
    (foaf.person_birthday.month = monthParam AND foaf.person_birthday.day >= 21) OR
    (foaf.person_birthday.month = (monthParam % 12) + 1 AND foaf.person_birthday.day < 22)
    AND NOT (p)-[:KNOWS]-(foaf)

// Collect the start person's tags of interest
WITH p, foaf
MATCH (p)-[:HAS_INTEREST]->(tags:Tag)

// Calculate Common Posts
WITH p, foaf, COLLECT(DISTINCT tags) AS personTags
OPTIONAL MATCH (foaf)<-[:POSTED_BY]-(commonPost:Post)<-[:TAG_OF]-(commonTag:Tag)
WHERE commonTag IN personTags

// Calculate Uncommon Posts
WITH p, foaf, COUNT(DISTINCT commonPost) AS common, personTags
OPTIONAL MATCH (uncommonPost:Post)-[:POSTED_BY]->(foaf)
WHERE NOT EXISTS {
    MATCH (uncommonPost)<-[:TAG_OF]-(uncommonTag:Tag)
    WHERE uncommonTag IN personTags
}

WITH p, foaf, common, (common - COUNT(DISTINCT  uncommonPost)) AS commonInterestScore
MATCH (foaf)-[:LOCATED_IN]->(city:City)
RETURN
    foaf.person_id AS foafId,
    foaf.person_first_name AS foafFirstName,
    foaf.person_last_name AS foafLastName,
    commonInterestScore,
    foaf.person_gender AS foafGender,
    city.name AS cityName
ORDER BY commonInterestScore DESC, foafId ASC,
LIMIT 10;

