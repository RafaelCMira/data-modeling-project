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