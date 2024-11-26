-- Postgres database schema for the project

--region DROP SCHEMA
DROP TABLE IF EXISTS knows;
DROP TABLE IF EXISTS subclass_of;
DROP TABLE IF EXISTS studies;
DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS message_tags;
DROP TABLE IF EXISTS forum_tags;
DROP TABLE IF EXISTS forum_members;
DROP TABLE IF EXISTS moderates;
DROP TABLE IF EXISTS has_interest;

DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS tag_class;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS university;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS continent;
DROP TABLE IF EXISTS forum;
--endregion

-- Create schema

-- region ENTITIES
CREATE TABLE continent (
    continent_id INTEGER,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE country (
    country_id INTEGER,
    name VARCHAR(50) NOT NULL,
    continent_id
);

CREATE TABLE city (
    city_id INTEGER
    name VARCHAR(50) NOT NULL,
    country_id INTEGER
);

CREATE TABLE university (
    university_id INTEGER,
    name VARCHAR(50) NOT NULL,
    city_id INTEGER
);

CREATE TABLE company (
    company_id INTEGER,
    name VARCHAR(50) NOT NULL,
    country_id INTEGER
);

CREATE TABLE person (
    person_id INTEGER,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender  VARCHAR(6) NOT NULL,
    birthday DATE,
    browser_used VARCHAR(20) NOT NULL,
    location_ip VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    city_id INTEGER,
);

CREATE TABLE tag (
    tag_id INTEGER,
    name VARCHAR(50) NOT NULL,
    tag_class_id INTEGER
);

CREATE TABLE tag_class (
    tag_class_id INTEGER,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE message (
    message_id INTEGER,
    browser_used VARCHAR(20) NOT NULL,
    location_ip VARCHAR(20) NOT NULL,
    content VARCHAR(1000) NOT NULL,
    `length` INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL,
    country_id INTEGER,
    person_id INTEGER
);

CREATE TABLE post (
    language VARCHAR(5) NOT NULL,
    image_file VARCHAR(50) NOT NULL,
    message_id INTEGER,
    forum_id INTEGER
);

CREATE TABLE comment (
    message_id INTEGER
    reply_to_message_id INTEGER
);

CREATE TABLE forum (
    forum_id INTEGER,
    title VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL
)
-- endregion

-- region RELATIONS
CREATE TABLE knows (
    person_id1 INTEGER,
    person_id2 INTEGER,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE subclass_of (
    tag_class_id1 INTEGER,
    tag_class_id2 INTEGER
);

CREATE TABLE studies (
    person_id INTEGER,
    university_id INTEGER,
    class_year SMALLINT NOT NULL
);

CREATE TABLE works (
    person_id INTEGER,
    company_id INTEGER,
    work_from SMALLINT NOT NULL
);

CREATE TABLE likes (
    person_id INTEGER,
    message_id INTEGER,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE message_tags (
    message_id INTEGER,
    tag_id INTEGER
);

CREATE TABLE forum_tags (
    forum_id INTEGER,
    tag_id INTEGER
);

CREATE TABLE forum_members (
    forum_id INTEGER,
    person_id INTEGER,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE moderates (
    forum_id INTEGER,
    person_id INTEGER
);

CREATE TABLE has_interest (
    person_id INTEGER,
    tag_id INTEGER
);

-- endregion

-- Primary keys

-- region ENTITIES
ALTER TABLE continent
    ADD CONSTRAINT continent_pk PRIMARY KEY (continent_id);

ALTER TABLE country
    ADD CONSTRAINT country_pk PRIMARY KEY (country_id);

ALTER TABLE city
    ADD CONSTRAINT city_pk PRIMARY KEY (city_id);

ALTER TABLE university
    ADD CONSTRAINT university_pk PRIMARY KEY (university_id);

ALTER TABLE company
    ADD CONSTRAINT company_pk PRIMARY KEY (company_id);

ALTER TABLE person
    ADD CONSTRAINT person_pk PRIMARY KEY (person_id);

ALTER TABLE tag
    ADD CONSTRAINT tag_pk PRIMARY KEY (tag_id);

ALTER TABLE tag_class
    ADD CONSTRAINT tag_class_pk PRIMARY KEY (tag_class_id);

ALTER TABLE message
    ADD CONSTRAINT message_pk PRIMARY KEY (message_id);

ALTER TABLE post
    ADD CONSTRAINT post_pk PRIMARY KEY (message_id);

ALTER TABLE comment
    ADD CONSTRAINT comment_pk PRIMARY KEY (message_id);

ALTER TABLE forum
    ADD CONSTRAINT forum_pk PRIMARY KEY (forum_id);

-- endregion

-- region RELATIONS
ALTER TABLE knows
    ADD CONSTRAINT knows_pk PRIMARY KEY (person_id1, person_id2);

ALTER TABLE subclass_of
    ADD CONSTRAINT subclass_of_pk PRIMARY KEY (tag_class_id1);

ALTER TABLE studies
    ADD CONSTRAINT studies_pk PRIMARY KEY (person_id, university_id);

ALTER TABLE works
    ADD CONSTRAINT works_pk PRIMARY KEY (person_id, company_id);

ALTER TABLE likes
    ADD CONSTRAINT likes_pk PRIMARY KEY (person_id, message_id);

ALTER TABLE message_tags
    ADD CONSTRAINT message_tags_pk PRIMARY KEY (message_id, tag_id);

ALTER TABLE forum_tags
    ADD CONSTRAINT forum_tags_pk PRIMARY KEY (forum_id, tag_id);

ALTER TABLE forum_members
    ADD CONSTRAINT forum_members_pk PRIMARY KEY (forum_id, person_id);

ALTER TABLE moderates
    ADD CONSTRAINT moderates_pk PRIMARY KEY (forum_id);

ALTER TABLE has_interest
    ADD CONSTRAINT has_interest_pk PRIMARY KEY (person_id, tag_id);
-- endregion

-- Foreign keys

-- region ENTITIES
ALTER TABLE country
    ADD CONSTRAINT country_continent_fk FOREIGN KEY (continent_id) REFERENCES continent(continent_id);

ALTER TABLE city
    ADD CONSTRAINT city_country_fk FOREIGN KEY (country_id) REFERENCES country(country_id);

ALTER TABLE university
    ADD CONSTRAINT university_city_fk FOREIGN KEY (city_id) REFERENCES city(city_id);

ALTER TABLE company
    ADD CONSTRAINT company_country_fk FOREIGN KEY (country_id) REFERENCES country(country_id);

ALTER TABLE person
    ADD CONSTRAINT person_city_fk FOREIGN KEY (city_id) REFERENCES city(city_id);

ALTER TABLE tag
    ADD CONSTRAINT tag_tag_class_fk FOREIGN KEY (tag_class_id) REFERENCES tag_class(tag_class_id);

ALTER TABLE message
    ADD CONSTRAINT message_country_fk FOREIGN KEY (country_id) REFERENCES country(country_id),
    ADD CONSTRAINT message_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id);

ALTER TABLE post
    ADD CONSTRAINT post_message_fk FOREIGN KEY (message_id) REFERENCES message(message_id),
    ADD CONSTRAINT post_forum_fk FOREIGN KEY (forum_id) REFERENCES forum(forum_id);

ALTER TABLE comment
    ADD CONSTRAINT comment_message_fk FOREIGN KEY (message_id) REFERENCES message(message_id),
    ADD CONSTRAINT comment_reply_to_message_fk FOREIGN KEY (reply_to_message_id) REFERENCES message(message_id);
-- endregion

-- region RELATIONS
ALTER TABLE knows
    ADD CONSTRAINT knows_person1_fk FOREIGN KEY (person_id1) REFERENCES person(person_id),
    ADD CONSTRAINT knows_person2_fk FOREIGN KEY (person_id2) REFERENCES person(person_id);

ALTER TABLE subclass_of
    ADD CONSTRAINT subclass_of_tag_class1_fk FOREIGN KEY (tag_class_id1) REFERENCES tag_class(tag_class_id),
    ADD CONSTRAINT subclass_of_tag_class2_fk FOREIGN KEY (tag_class_id2) REFERENCES tag_class(tag_class_id);

ALTER TABLE studies
    ADD CONSTRAINT studies_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id),
    ADD CONSTRAINT studies_university_fk FOREIGN KEY (university_id) REFERENCES university(university_id);

ALTER TABLE works
    ADD CONSTRAINT works_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id),
    ADD CONSTRAINT works_company_fk FOREIGN KEY (company_id) REFERENCES company(company_id);

ALTER TABLE likes
    ADD CONSTRAINT likes_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id),
    ADD CONSTRAINT likes_message_fk FOREIGN KEY (message_id) REFERENCES message(message_id);

ALTER TABLE message_tags
    ADD CONSTRAINT message_tags_message_fk FOREIGN KEY (message_id) REFERENCES message(message_id),
    ADD CONSTRAINT message_tags_tag_fk FOREIGN KEY (tag_id) REFERENCES tag(tag_id);

ALTER TABLE forum_tags
    ADD CONSTRAINT forum_tags_forum_fk FOREIGN KEY (forum_id) REFERENCES forum(forum_id),
    ADD CONSTRAINT forum_tags_tag_fk FOREIGN KEY (tag_id) REFERENCES tag(tag_id);

ALTER TABLE forum_members
    ADD CONSTRAINT forum_members_forum_fk FOREIGN KEY (forum_id) REFERENCES forum(forum_id),
    ADD CONSTRAINT forum_members_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id);

ALTER TABLE moderates
    ADD CONSTRAINT moderates_forum_fk FOREIGN KEY (forum_id) REFERENCES forum(forum_id),
    ADD CONSTRAINT moderates_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id);

ALTER TABLE has_interest
    ADD CONSTRAINT has_interest_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id),
    ADD CONSTRAINT has_interest_tag_fk FOREIGN KEY (tag_id) REFERENCES tag(tag_id);
-- endregion