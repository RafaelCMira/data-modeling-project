LOAD CSV WITH HEADERS FROM 'file:///C:/temp/continent.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:Continent {
	continent_id: toInteger(row.continent_id),
	name: row.name
});


LOAD CSV WITH HEADERS FROM 'file:///C:/temp/country.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:Country {
	country_id: toInteger(row.country_id),
	name: row.name
});


LOAD CSV WITH HEADERS FROM 'file:///C:/temp/city.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:City {
	city_id: toInteger(row.city_id),
	name: row.name
});


LOAD CSV WITH HEADERS FROM 'file:///C:/temp/country.csv' AS row FIELDTERMINATOR '|'
MATCH (country:Country {country_id: toInteger(row.country_id)})
MATCH (continent:Continent {continent_id: toInteger(row.continent_id)})
CREATE (country)-[:COUNTRY_OF]->(continent);


LOAD CSV WITH HEADERS FROM 'file:///C:/temp/city.csv' AS row FIELDTERMINATOR '|'
MATCH (city:City {city_id: toInteger(row.city_id)})
MATCH (country:Country {country_id: toInteger(row.country_id)})
CREATE (city)-[:CITY_OF]->(country);





LOAD CSV WITH HEADERS FROM 'file:///C:/temp/university.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:University {
	university_id: toInteger(row.university_id),
	name: row.name
});

LOAD CSV WITH HEADERS FROM 'file:///C:/temp/university.csv' AS row FIELDTERMINATOR '|'
MATCH (university:University {university_id: toInteger(row.university_id)})
MATCH (city:City {city_id: toInteger(row.city_id)})
CREATE (university)-[:LOCATED_IN]->(city);



LOAD CSV WITH HEADERS FROM 'file:///C:/temp/company.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:Company {
	company_id: toInteger(row.company_id),
	name: row.name
});

LOAD CSV WITH HEADERS FROM 'file:///C:/temp/company.csv' AS row FIELDTERMINATOR '|'
MATCH (company:Company {company_id: toInteger(row.company_id)})
MATCH (country:Country {country_id: toInteger(row.country_id)})
CREATE (company)-[:LOCATED_IN]->(country);





LOAD CSV WITH HEADERS FROM 'file:///C:/temp/tag.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:Tag {
	tag_id: toInteger(row.tag_id),
	name: row.name
});


LOAD CSV WITH HEADERS FROM 'file:///C:/temp/tag_class.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:TagClass {
	tag_class_id: toInteger(row.tag_class_id),
	name: row.name
});

LOAD CSV WITH HEADERS FROM 'file:///C:/temp/tag.csv' AS row FIELDTERMINATOR '|'
MATCH (tag:Tag {tag_id: toInteger(row.tag_id)})
MATCH (tag_class:TagClass {tag_class_id: toInteger(row.tag_class_id)})
CREATE (tag)-[:TAG_TYPE]->(tag_class);

LOAD CSV WITH HEADERS FROM 'file:///C:/temp/tag_class.csv' AS row FIELDTERMINATOR '|'
MATCH (tag_class_1:TagClass {tag_class_id: toInteger(row.tag_class_id)})
MATCH (tag_class_2:TagClass {tag_class_id: toInteger(row.subclass_of)})
CREATE (tag_class_1)-[:SUBCLASS_OF]->(tag_class_2);


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/person.csv" AS row FIELDTERMINATOR "|"
RETURN row',
'CREATE (p:Person {
    person_id: toInteger(row.person_id),
    person_first_name: row.first_name,
    person_last_name: row.last_name,
    person_gender: row.gender,
    person_birthday: date(row.birthday),
    person_browser_used: row.browser_used,
    person_location_ip: row.location_ip,
    person_created_at: datetime(row.created_at)
})',
{batchSize: 50000, parallel: true}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/person.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
MATCH (city:City {city_id: toInteger(row.city_id)})
CREATE (person)-[:LOCATED_IN]->(city);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/studies.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
MATCH (university:University {university_id: toInteger(row.university_id)})
CREATE (person)-[:STUDIES_AT {class_year: toInteger(row.class_year)}]->(university);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/works.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
MATCH (company:Company {company_id: toInteger(row.company_id)})
CREATE (person)-[:WORKS_AT {work_from: toInteger(row.work_from)}]->(company);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/knows.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (p1:Person {person_id: toInteger(row.person_id1)})
 MATCH (p2:Person {person_id: toInteger(row.person_id2)})
 CREATE (p1)-[:KNOWS {created_at: datetime(row.created_at)}]->(p2)',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/forum.csv" AS row FIELDTERMINATOR "|" RETURN row',
'CREATE (f:Forum {
    forum_id: toInteger(row.forum_id),
    forum_title: row.title,
    forum_created_at: datetime(row.created_at)
})',
{batchSize: 50000, parallel: true}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/forum.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
 MATCH (forum:Forum {forum_id: toInteger(row.forum_id)})
 CREATE (person)-[:MODERATOR_OF]->(forum);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total; 


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/forum_members.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
 MATCH (forum:Forum {forum_id: toInteger(row.forum_id)})
 CREATE (person)-[:MEMBER_OF {created_at: datetime(row.created_at)}]->(forum)',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/forum_tags.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (forum:Forum {forum_id: toInteger(row.forum_id)})
MATCH (tag:Tag {tag_id: toInteger(row.tag_id)})
CREATE (tag)-[:TAG_OF]->(forum);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/has_interest.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
 MATCH (tag:Tag {tag_id: toInteger(row.tag_id)})
 CREATE (person)-[:HAS_INTEREST]->(tag);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/neo4j_comment.csv" AS row FIELDTERMINATOR "|" RETURN row',
'CREATE (m:Message:Comment {
    message_id: toInteger(row.message_id),
    message_browser_used: row.browser_used,
    message_location_ip: row.location_ip,
    message_content: row.content,
    message_length: toInteger(row.length),
    message_created_at: datetime(row.created_at)
})',
{batchSize: 30000, parallel: true}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/neo4j_post.csv" AS row FIELDTERMINATOR "|" RETURN row',
'CREATE (m:Message:Post {
    message_id: toInteger(row.message_id),
    message_browser_used: row.browser_used,
    message_location_ip: row.location_ip,
    message_content: row.content,
    message_length: toInteger(row.length),
    message_language: row.language,
    message_created_at: datetime(row.created_at)
})',
{batchSize: 30000, parallel: true}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/neo4j_comment.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (comment:Comment {message_id: toInteger(row.message_id)})
 MATCH (message:Message {message_id: toInteger(row.parent_id)})
 CREATE (comment)-[:REPLY_OF]->(message);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/neo4j_post.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (post:Post {message_id: toInteger(row.message_id)})
 MATCH (forum:Forum {forum_id: toInteger(row.forum_id)})
 CREATE (post)-[:POSTED_IN]->(forum);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/message.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (message:Message {message_id: toInteger(row.message_id)})
 MATCH (country:Country {country_id: toInteger(row.country_id)})
 CREATE (message)-[:LOCATED_IN]->(country);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/message_tags.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (message:Message {message_id: toInteger(row.message_id)})
 MATCH (tag:Tag {tag_id: toInteger(row.tag_id)})
 CREATE (tag)-[:TAG_OF]->(message);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/likes.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (message:Message {message_id: toInteger(row.message_id)})
MATCH (person:Person {person_id: toInteger(row.person_id)})
CREATE (message)-[:LIKED_BY {created_at: datetime(row.created_at)}]->(person)',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///C:/temp/message.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (message:Message {message_id: toInteger(row.message_id)})
 MATCH (person:Person {person_id: toInteger(row.person_id)})
 CREATE (message)-[:POSTED_BY]->(person);',
{batchSize: 5000, parallel: false, retries: 3}
)
YIELD batches, total
RETURN batches, total;