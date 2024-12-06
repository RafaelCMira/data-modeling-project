// Pk constraints
CREATE CONSTRAINT continent_id_unique IF NOT EXISTS
FOR (c:Continent)
REQUIRE c.continent_id IS UNIQUE;

CREATE CONSTRAINT country_id_unique IF NOT EXISTS
FOR (c:Country)
REQUIRE c.country_id IS UNIQUE;

CREATE CONSTRAINT city_id_unique IF NOT EXISTS
FOR (c:City)
REQUIRE c.city_id IS UNIQUE;



CREATE CONSTRAINT university_id_unique IF NOT EXISTS
FOR (u:University)
REQUIRE u.university_id IS UNIQUE;

CREATE CONSTRAINT company_id_unique IF NOT EXISTS
FOR (c:Company)
REQUIRE c.company_id IS UNIQUE;



CREATE CONSTRAINT tag_id_unique IF NOT EXISTS
FOR (t:Tag)
REQUIRE t.tag_id IS UNIQUE;

CREATE CONSTRAINT tag_class_id_unique IF NOT EXISTS
FOR (tc:TagClass)
REQUIRE tc.tag_class_id IS UNIQUE;



CREATE CONSTRAINT person_id_unique IF NOT EXISTS
FOR (p:Person)
REQUIRE p.person_id IS UNIQUE;



CREATE CONSTRAINT forum_id_unique IF NOT EXISTS
FOR (f:Forum)
REQUIRE f.forum_id IS UNIQUE;



CREATE CONSTRAINT message_id_unique IF NOT EXISTS
FOR (m:Message)
REQUIRE m.message_id IS UNIQUE;

CREATE CONSTRAINT comment_id_unique IF NOT EXISTS
FOR (c:Comment)
REQUIRE c.message_id IS UNIQUE;

CREATE CONSTRAINT post_id_unique IF NOT EXISTS
FOR (p:Post)
REQUIRE p.message_id IS UNIQUE;

