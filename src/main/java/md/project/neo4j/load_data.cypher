// Perguntar se é necessário criar constraints para non-null fields

// Pk constraints
CREATE CONSTRAINT country_id_unique IF NOT EXISTS
FOR (c:Country)
REQUIRE c.country_id IS UNIQUE;

CREATE CONSTRAINT district_unique IF NOT EXISTS
FOR (d:District)
REQUIRE (d.district_name, d.country_id) IS UNIQUE;

CREATE CONSTRAINT city_unique IF NOT EXISTS
FOR (c:City)
REQUIRE (c.city_name, c.district_name, c.country_id) IS UNIQUE;

CREATE CONSTRAINT person_id_unique IF NOT EXISTS
FOR (p:Person)
REQUIRE p.person_id IS UNIQUE;

CREATE CONSTRAINT post_id_unique IF NOT EXISTS
FOR (po:Post)
REQUIRE po.post_id IS UNIQUE;

CREATE CONSTRAINT comment_id_unique IF NOT EXISTS
FOR (co:Comment)
REQUIRE co.comment_id IS UNIQUE;

CREATE CONSTRAINT tag_id_unique IF NOT EXISTS
FOR (t:Tag)
REQUIRE t.tag_id IS UNIQUE;

LOAD CSV WITH HEADERS FROM 'file:///countries.csv' AS row FIELDTERMINATOR '$'
WITH row
	CREATE (c:Country {
	country_id: toInteger(row.country_id),
	country_name: row.country_name
});

LOAD CSV WITH HEADERS FROM 'file:///districts.csv' AS row FIELDTERMINATOR '$'
WITH row
MERGE (d:District {
	district_name: row.district_name,
	country_id: toInteger(row.country_id)
});

LOAD CSV WITH HEADERS FROM 'file:///cities.csv' AS row FIELDTERMINATOR '$'
WITH row
MERGE (c:City {
	city_name: row.city_name,
	district_name: row.district_name,
	country_id: toInteger(row.country_id)
});

LOAD CSV WITH HEADERS FROM 'file:///person.csv' AS row FIELDTERMINATOR '$'
WITH row, apoc.date.parse(row.created_at, 'ms', 'yyyy-MM-dd HH:mm:ss.SSS') AS parsedDate
MERGE (p:Person {
	person_id: toInteger(row.person_id),
	person_username: row.username,
	person_first_name: row.first_name,
	person_last_name: row.last_name,
	person_email: row.email,
	person_password: row.password,
	person_birth_date: row.birthdate,
	person_created_at: datetime({epochMillis: parsedDate})
});

LOAD CSV WITH HEADERS FROM 'file:///post.csv' AS row FIELDTERMINATOR '$'
WITH row, apoc.date.parse(row.created_at, 'ms', 'yyyy-MM-dd HH:mm:ss.SSS') AS parsedDate
	CREATE (p:Post {
	post_id: toInteger(row.post_id),
	post_content: row.content,
	post_created_at: datetime({epochMillis: parsedDate})
});

LOAD CSV WITH HEADERS FROM 'file:///comment.csv' AS row FIELDTERMINATOR '$'
WITH row, apoc.date.parse(row.created_at, 'ms', 'yyyy-MM-dd HH:mm:ss.SSS') AS parsedDate
	CREATE (c:Comment {
	comment_id: toInteger(row.comment_id),
	comment_msg: row.msg,
	comnment_created_at: datetime({epochMillis: parsedDate})
});

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

LOAD CSV WITH HEADERS FROM 'file:///districts.csv' AS row FIELDTERMINATOR '$'
MATCH (d:District {district_name: row.district_name, country_id: toInteger(row.country_id)})
MATCH (c:Country {country_id: toInteger(row.country_id)})
CREATE (d)-[:DISTRICT_OF]->(c);

LOAD CSV WITH HEADERS FROM 'file:///person.csv' AS row FIELDTERMINATOR '$'
MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (c:City {city_name: row.city_name, district_name: row.district_name, country_id: toInteger(row.country_id)})
CREATE (p)-[:LIVES_IN]->(c);

LOAD CSV WITH HEADERS FROM 'file:///person.csv' AS row FIELDTERMINATOR '$'
MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (c:Country {country_id: toInteger(row.country_id)})
CREATE (p)-[:BORN_IN]->(c);

LOAD CSV WITH HEADERS FROM 'file:///follow.csv' AS row FIELDTERMINATOR '$'
WITH row, apoc.date.parse(row.created_at, 'ms', 'yyyy-MM-dd HH:mm:ss.SSS') AS parsedDate
MATCH (p1:Person {person_id: toInteger(row.follower_id)})
MATCH (p2:Person {person_id: toInteger(row.person_id)})
CREATE (p1)-[:FOLLOWS {created_at: datetime({epochMillis: parsedDate})}]->(p2);

LOAD CSV WITH HEADERS FROM 'file:///post.csv' AS row FIELDTERMINATOR '$'
MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (po:Post {post_id: toInteger(row.post_id)})
CREATE (p)-[:POSTED]->(po);

LOAD CSV WITH HEADERS FROM 'file:///post_like.csv' AS row FIELDTERMINATOR '$'
WITH row, apoc.date.parse(row.created_at, 'ms', 'yyyy-MM-dd HH:mm:ss.SSS') AS parsedDate
MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (po:Post {post_id: toInteger(row.post_id)})
CREATE (po)-[:LIKED_BY {created_at: datetime({epochMillis: parsedDate})}]->(p);

LOAD CSV WITH HEADERS FROM 'file:///comment.csv' AS row FIELDTERMINATOR '$'
MATCH (po:Post {post_id: toInteger(row.post_id)})
MATCH (co:Comment {comment_id: toInteger(row.comment_id)})
CREATE (co)-[:COMMENTED_ON]->(po);

LOAD CSV WITH HEADERS FROM 'file:///comment.csv' AS row FIELDTERMINATOR '$'
MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (co:Comment {comment_id: toInteger(row.comment_id)})
CREATE (co)-[:COMMENTED_BY]->(p);

LOAD CSV WITH HEADERS FROM 'file:///comment_like.csv' AS row FIELDTERMINATOR '$'
WITH row, apoc.date.parse(row.created_at, 'ms', 'yyyy-MM-dd HH:mm:ss.SSS') AS parsedDate
MATCH (p:Person {person_id: toInteger(row.person_id)})
MATCH (co:Comment {comment_id: toInteger(row.comment_id)})
CREATE (co)-[:LIKED_BY {created_at: datetime({epochMillis: parsedDate})}]->(p);

LOAD CSV WITH HEADERS FROM 'file:///comment_parent.csv' AS row FIELDTERMINATOR '$'
MATCH (co1:Comment {comment_id: toInteger(row.comment_id)})
MATCH (co2:Comment {comment_id: toInteger(row.parent_id)})
CREATE (co2)-[:PARENT_OF]->(co1);

LOAD CSV WITH HEADERS FROM 'file:///post_tag.csv' AS row FIELDTERMINATOR '$'
MATCH (po:Post {post_id: toInteger(row.post_id)})
MATCH (t:Tag {tag_id: toInteger(row.tag_id)})
CREATE (po)-[:HAS_TAG]->(t);
