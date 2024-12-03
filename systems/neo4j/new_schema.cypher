LOAD CSV WITH HEADERS FROM 'file:///continent.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:Continent {
	continent_id: toInteger(row.continent_id),
	name: row.name
});


LOAD CSV WITH HEADERS FROM 'file:///country.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:Country {
	country_id: toInteger(row.country_id),
	name: row.name
});


LOAD CSV WITH HEADERS FROM 'file:///city.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:City {
	city_id: toInteger(row.city_id),
	name: row.name
});


LOAD CSV WITH HEADERS FROM 'file:///country.csv' AS row FIELDTERMINATOR '|'
MATCH (country:Country {country_id: toInteger(row.country_id)})
MATCH (continent:Continent {continent_id: toInteger(row.continent_id)})
CREATE (country)-[:COUNTRY_OF]->(continent);


LOAD CSV WITH HEADERS FROM 'file:///city.csv' AS row FIELDTERMINATOR '|'
MATCH (city:City {city_id: toInteger(row.city_id)})
MATCH (country:Country {country_id: toInteger(row.country_id)})
CREATE (city)-[:CITY_OF]->(country);





LOAD CSV WITH HEADERS FROM 'file:///university.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:University {
	university_id: toInteger(row.university_id),
	name: row.name
});

LOAD CSV WITH HEADERS FROM 'file:///university.csv' AS row FIELDTERMINATOR '|'
MATCH (university:University {university_id: toInteger(row.university_id)})
MATCH (city:City {city_id: toInteger(row.city_id)})
CREATE (university)-[:LOCATED_IN]->(city);



LOAD CSV WITH HEADERS FROM 'file:///company.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:Company {
	company_id: toInteger(row.company_id),
	name: row.name
});

LOAD CSV WITH HEADERS FROM 'file:///company.csv' AS row FIELDTERMINATOR '|'
MATCH (company:Company {company_id: toInteger(row.company_id)})
MATCH (country:Country {country_id: toInteger(row.country_id)})
CREATE (company)-[:LOCATED_IN]->(country);





LOAD CSV WITH HEADERS FROM 'file:///tag.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:Tag {
	tag_id: toInteger(row.tag_id),
	name: row.name
});


LOAD CSV WITH HEADERS FROM 'file:///tag_class.csv' AS row FIELDTERMINATOR '|'
WITH row
	CREATE (c:TagClass {
	tag_class_id: toInteger(row.tag_class_id),
	name: row.name
});

LOAD CSV WITH HEADERS FROM 'file:///tag.csv' AS row FIELDTERMINATOR '|'
MATCH (tag:Tag {tag_id: toInteger(row.tag_id)})
MATCH (tag_class:TagClass {tag_class_id: toInteger(row.tag_class_id)})
CREATE (tag)-[:TAG_TYPE]->(tag_class);

LOAD CSV WITH HEADERS FROM 'file:///tag_class.csv' AS row FIELDTERMINATOR '|'
MATCH (tag_class_1:TagClass {tag_class_id: toInteger(row.tag_class_id)})
MATCH (tag_class_2:TagClass {tag_class_id: toInteger(row.subclass_of)})
CREATE (tag_class_1)-[:SUBCLASS_OF]->(tag_class_2);



// TODO -> Check id this date parsing is correct
CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///person.csv" AS row FIELDTERMINATOR "$"
WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
RETURN row, parsedDate',
'CREATE (p:Person {
    person_id: toInteger(row.person_id),
    person_first_name: row.first_name,
    person_last_name: row.last_name,
    person_gender: row.gender,
    person_birthday: date(row.birthday),
    person_browser_used: row.browser_used,
    person_location_ip: row.location_ip,
    person_created_at: datetime({epochMillis: parsedDate})
})',
{batchSize: 40000, parallel: true}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///person.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
MATCH (city:City {city_id: toInteger(row.city_id)})
CREATE (person)-[:LOCATED_IN]->(city);',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///studies.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
MATCH (university:University {university_id: toInteger(row.university_id)})
CREATE (person)-[:STUDIES_AT {class_year: toInteger(row.class_year)}]->(university);',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///works.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
MATCH (company:Company {company_id: toInteger(row.company_id)})
CREATE (person)-[:WORKS_AT {work_from: toInteger(row.work_from)}]->(company);',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


// todo -> check if this date parsing is correct
CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///knows.csv" AS row FIELDTERMINATOR "$"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'MATCH (p1:Person {person_id: toInteger(row.person_id1)})
 MATCH (p2:Person {person_id: toInteger(row.person_id2)})
 CREATE (p1)-[:KNOWS {created_at: datetime({epochMillis: parsedDate})}]->(p2)',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///works.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
MATCH (company:Company {company_id: toInteger(row.company_id)})
CREATE (person)-[:WORKS_AT {work_from: toInteger(row.work_from)}]->(company);',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


// todo -> check if this date parsing is correct
CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///forum.csv" AS row FIELDTERMINATOR "$"
WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
RETURN row, parsedDate',
'CREATE (f:Forum {
    forum_id: toInteger(row.forum_id),
    forum_title: row.title,
    forum_created_at: datetime({epochMillis: parsedDate})
})',
{batchSize: 40000, parallel: true}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///forum.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
 MATCH (forum:Forum {forum_id: toInteger(row.forum_id)})
 CREATE (person)-[:MODERATOR_OF]->(forum);',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


// todo -> check if this date parsing is correct
CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///forum_members.csv" AS row FIELDTERMINATOR "$"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
 MATCH (forum:Forum {forum_id: toInteger(row.forum_id)})
 CREATE (person)-[:MEMBER_OF {created_at: datetime({epochMillis: parsedDate})}]->(forum)',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///forum_tags.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (forum:Forum {forum_id: toInteger(row.forum_id)})
MATCH (tag:Tag {tag_id: toInteger(row.tag_id)})
CREATE (tag)-[:TAG_OF]->(forum);',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///has_interest.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (person:Person {person_id: toInteger(row.person_id)})
 MATCH (tag:Tag {tag_id: toInteger(row.tag_id)})
 CREATE (person)-[:HAS_INTEREST]->(tag);',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;



// todo -> check if this date parsing is correct
CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///message.csv" AS row FIELDTERMINATOR "$"
WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
RETURN row, parsedDate',
'CREATE (m:Message {
    message_id: toInteger(row.message_id),
    message_browser_used: row.browser_used,
    message_location_ip: row.location_ip,
    message_content: row.content,
    message_length: toInteger(row.length),
    message_created_at: datetime({epochMillis: parsedDate})
})',
{batchSize: 30000, parallel: true}
)
YIELD batches, total
RETURN batches, total;



CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///message.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (message:Message {message_id: toInteger(row.message_id)})
 MATCH (country:Country {country_id: toInteger(row.country_id)})
 CREATE (message)-[:LOCATED_IN]->(country);',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///message.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (message:Message {message_id: toInteger(row.message_id)})
 MATCH (person:Person {person_id: toInteger(row.person_id)})
 CREATE (message)-[:POSTED_BY]->(person);',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///message.csv" AS row FIELDTERMINATOR "|" RETURN row',
'MATCH (message:Message {message_id: toInteger(row.message_id)})
 MATCH (tag:Tag {tag_id: toInteger(row.tag_id)})
 CREATE (tag)-[:TAG_OF]->(message);',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


// todo -> check if this date parsing is correct
CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///message.csv" AS row FIELDTERMINATOR "|"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'MATCH (message:Message {message_id: toInteger(row.message_id)})
 MATCH (person:Person {person_id: toInteger(row.person_id)})
 CREATE (message)-[:LIKED_BY {created_at: datetime({epochMillis: parsedDate})}]->(person)',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;