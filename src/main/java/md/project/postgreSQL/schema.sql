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
    continent_id BIGINT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE country (
    country_id BIGINT,
    name VARCHAR(50) NOT NULL,
    continent_id BIGINT
);

CREATE TABLE city (
    city_id BIGINT
    name VARCHAR(50) NOT NULL,
    country_id BIGINT
);

CREATE TABLE university (
    university_id BIGINT,
    name VARCHAR(50) NOT NULL,
    city_id INTEGER
);

CREATE TABLE company (
    company_id BIGINT,
    name VARCHAR(50) NOT NULL,
    country_id BIGINT
);

CREATE TABLE person (
    person_id BIGINT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender  VARCHAR(6) NOT NULL,
    birthday DATE,
    browser_used VARCHAR(20) NOT NULL,
    location_ip VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    city_id BIGINT,
);

CREATE TABLE tag (
    tag_id BIGINT,
    name VARCHAR(50) NOT NULL,
    tag_class_id BIGINT
);

CREATE TABLE tag_class (
    tag_class_id BIGINT,
    name VARCHAR(50) NOT NULL,
    subclass_of BIGINT
);

CREATE TABLE message (
    message_id BIGINT,
    browser_used VARCHAR(20) NOT NULL,
    location_ip VARCHAR(20) NOT NULL,
    content VARCHAR(1000),
    `length` INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL,
    country_id BIGINT,
    person_id BIGINT
);

CREATE TABLE post (
    language VARCHAR(5),
    message_id BIGINT,
    forum_id BIGINT
);

CREATE TABLE comment (
    message_id BIGINT,
    parent_id BIGINT,
);

CREATE TABLE forum (
    forum_id BIGINT,
    title VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    person_id BIGINT
)
-- endregion

-- region RELATIONS
CREATE TABLE knows (
    person_id1 BIGINT,
    person_id2 BIGINT,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE studies (
    person_id BIGINT,
    university_id BIGINT,
    class_year SMALLINT NOT NULL
);

CREATE TABLE works (
    person_id BIGINT,
    company_id BIGINT,
    work_from SMALLINT NOT NULL
);

CREATE TABLE likes (
    person_id BIGINT,
    message_id BIGINT,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE message_tags (
    message_id BIGINT,
    tag_id BIGINT
);

CREATE TABLE forum_tags (
    forum_id BIGINT,
    tag_id BIGINT
);

CREATE TABLE forum_members (
    forum_id BIGINT,
    person_id BIGINT,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE has_interest (
    person_id BIGINT,
    tag_id BIGINT
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

ALTER TABLE tag_class
    ADD CONSTRAINT tag_class_subclass_of_fk FOREIGN KEY (subclass_of) REFERENCES tag_class(tag_class_id);

ALTER TABLE message
    ADD CONSTRAINT message_country_fk FOREIGN KEY (country_id) REFERENCES country(country_id),
    ADD CONSTRAINT message_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id);

ALTER TABLE post
    ADD CONSTRAINT post_message_fk FOREIGN KEY (message_id) REFERENCES message(message_id),
    ADD CONSTRAINT post_forum_fk FOREIGN KEY (forum_id) REFERENCES forum(forum_id);

ALTER TABLE comment
    ADD CONSTRAINT comment_message_fk FOREIGN KEY (message_id) REFERENCES message(message_id),
    ADD CONSTRAINT comment_message_parent_fk FOREIGN KEY (parent_id) REFERENCES message(message_id);

ALTER TABLE forum
    ADD CONSTRAINT forum_moderator_fk FOREIGN KEY (person_id) REFERENCES person(person_id);
-- endregion

-- region RELATIONS
ALTER TABLE knows
    ADD CONSTRAINT knows_person1_fk FOREIGN KEY (person_id1) REFERENCES person(person_id),
    ADD CONSTRAINT knows_person2_fk FOREIGN KEY (person_id2) REFERENCES person(person_id);

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

ALTER TABLE has_interest
    ADD CONSTRAINT has_interest_person_fk FOREIGN KEY (person_id) REFERENCES person(person_id),
    ADD CONSTRAINT has_interest_tag_fk FOREIGN KEY (tag_id) REFERENCES tag(tag_id);
-- endregion