-- Postgres database schema for the project

--region DROP SCHEMA
DROP TABLE IF EXISTS knows;
DROP TABLE IF EXISTS studies;
DROP TABLE IF EXISTS works;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS message_tags;
DROP TABLE IF EXISTS forum_tags;
DROP TABLE IF EXISTS forum_members;
DROP TABLE IF EXISTS has_interest;

DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS forum;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS tag_class;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS university;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS country;
DROP TABLE IF EXISTS continent;

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
    city_id BIGINT,
    name VARCHAR(100) NOT NULL,
    country_id BIGINT
);

CREATE TABLE university (
    university_id BIGINT,
    name VARCHAR(250) NOT NULL,
    city_id INTEGER
);

CREATE TABLE company (
    company_id BIGINT,
    name VARCHAR(100) NOT NULL,
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
    city_id BIGINT
);

CREATE TABLE tag (
    tag_id BIGINT,
    name VARCHAR(150) NOT NULL,
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
    content TEXT,
    length INTEGER NOT NULL DEFAULT 0,
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
    parent_id BIGINT
);

CREATE TABLE forum (
    forum_id BIGINT,
    title VARCHAR(150) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    person_id BIGINT
);
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
