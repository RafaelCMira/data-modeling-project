LOAD CSV WITH HEADERS FROM 'file:///countries.csv' AS row FIELDTERMINATOR '$'
WITH row
	CREATE (c:Country {
	country_id: toInteger(row.country_id),
	country_name: row.country_name
});

LOAD CSV WITH HEADERS FROM 'file:///districts.csv' AS row FIELDTERMINATOR '$'
WITH row
CREATE (d:District {
	district_name: row.district_name,
	country_id: toInteger(row.country_id)
});

LOAD CSV WITH HEADERS FROM 'file:///cities.csv' AS row FIELDTERMINATOR '$'
WITH row
CREATE (c:City {
	city_name: row.city_name,
	district_name: row.district_name,
	country_id: toInteger(row.country_id)
});

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///person.csv" AS row FIELDTERMINATOR "$"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'CREATE (p:Person {
    person_id: toInteger(row.person_id),
    person_username: row.username,
    person_first_name: row.first_name,
    person_last_name: row.last_name,
    person_email: row.email,
    person_password: row.password,
    person_birth_date: date(row.birthdate),
    person_created_at: datetime({epochMillis: parsedDate})
})',
{batchSize: 50000, parallel: true}
)
YIELD batches, total
RETURN batches, total;

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///post.csv" AS row FIELDTERMINATOR "$"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'CREATE (p:Post {
	post_id: toInteger(row.post_id),
	post_content: row.content,
	post_created_at: datetime({epochMillis: parsedDate})
})',
{batchSize: 50000, parallel: true}
)
YIELD batches, total
RETURN batches, total;

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///comment.csv" AS row FIELDTERMINATOR "$"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'	CREATE (c:Comment {
	comment_id: toInteger(row.comment_id),
	comment_msg: row.msg,
	comment_created_at: datetime({epochMillis: parsedDate})
})',
{batchSize: 50000, parallel: true}
)
YIELD batches, total
RETURN batches, total;


LOAD CSV WITH HEADERS FROM 'file:///tag.csv' AS row FIELDTERMINATOR '$'
WITH row
	CREATE (t:Tag {
	tag_id: toInteger(row.tag_id),
	tag_name: row.tag_name
});


LOAD CSV WITH HEADERS FROM 'file:///cities.csv' AS row FIELDTERMINATOR '$'
MATCH (c:City {city_name: row.city_name, district_name: row.district_name, country_id: toInteger(row.country_id)})
MATCH (d:District {district_name: row.district_name, country_id: toInteger(row.country_id)})
CREATE (c)-[:CITY_OF]->(d);

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///districts.csv" AS row FIELDTERMINATOR "$" RETURN row',
'MATCH (d:District {district_name: row.district_name, country_id: toInteger(row.country_id)})
MATCH (c:Country {country_id: toInteger(row.country_id)})
CREATE (d)-[:DISTRICT_OF]->(c)',
{batchSize: 5000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


LOAD CSV WITH HEADERS FROM 'file:///person.csv' AS row FIELDTERMINATOR '$'
MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (c:City {city_name: row.city_name, district_name: row.district_name, country_id: toInteger(row.country_id)})
CREATE (p)-[:LIVES_IN]->(c);


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///person.csv" AS row FIELDTERMINATOR "$" RETURN row',
'MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (c:Country {country_id: toInteger(row.country_id)})
CREATE (p)-[:BORN_IN]->(c)',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///follow.csv" AS row FIELDTERMINATOR "$"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'MATCH (p1:Person {person_id: toInteger(row.follower_id)})
 MATCH (p2:Person {person_id: toInteger(row.person_id)})
 CREATE (p1)-[:FOLLOWS {created_at: datetime({epochMillis: parsedDate})}]->(p2)',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///post.csv" AS row FIELDTERMINATOR "$" RETURN row',
'MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (po:Post {post_id: toInteger(row.post_id)})
CREATE (p)-[:POSTED]->(po)',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///post_like.csv" AS row FIELDTERMINATOR "$"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'MATCH (p:Person {person_id: toInteger(row.person_id)})
 MATCH (po:Post {post_id: toInteger(row.post_id)})
 CREATE (po)-[:LIKED_BY {created_at: datetime({epochMillis: parsedDate})}]->(p)',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///comment.csv" AS row FIELDTERMINATOR "$" RETURN row',
'MATCH (po:Post {post_id: toInteger(row.post_id)})
MATCH (co:Comment {comment_id: toInteger(row.comment_id)})
CREATE (co)-[:COMMENTED_ON]->(po)',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///comment.csv" AS row FIELDTERMINATOR "$" RETURN row',
'MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (co:Comment {comment_id: toInteger(row.comment_id)})
CREATE (co)-[:COMMENTED_BY]->(p)',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;


CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///comment_like.csv" AS row FIELDTERMINATOR "$"
 WITH row, apoc.date.parse(row.created_at, "ms", "yyyy-MM-dd HH:mm:ss.SSS") AS parsedDate
 RETURN row, parsedDate',
'MATCH (p:Person {person_id: toInteger(row.person_id)})
 MATCH (co:Comment {comment_id: toInteger(row.comment_id)})
 CREATE (co)-[:LIKED_BY {created_at: datetime({epochMillis: parsedDate})}]->(p)',
{batchSize: 100000, parallel: false}
)
YIELD batches, total
RETURN batches, total;

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///comment_parent.csv" AS row FIELDTERMINATOR "$" RETURN row',
'MATCH (co1:Comment {comment_id: toInteger(row.comment_id)})
MATCH (co2:Comment {comment_id: toInteger(row.parent_id)})
CREATE (co2)-[:PARENT_OF]->(co1)',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;

CALL apoc.periodic.iterate(
'LOAD CSV WITH HEADERS FROM "file:///post_tag.csv" AS row FIELDTERMINATOR "$" RETURN row',
'MATCH (po:Post {post_id: toInteger(row.post_id)})
MATCH (t:Tag {tag_id: toInteger(row.tag_id)})
CREATE (po)-[:HAS_TAG]->(t)',
{batchSize: 50000, parallel: false}
)
YIELD batches, total
RETURN batches, total;
