DROP TABLE IF EXISTS post_tag;
DROP TABLE IF EXISTS comment_parent;
DROP TABLE IF EXISTS comment_like;
DROP TABLE IF EXISTS post_like;
DROP TABLE IF EXISTS follow;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS district;
DROP TABLE IF EXISTS country;

CREATE TABLE country
(
    country_id   TINYINT UNSIGNED,
    country_name VARCHAR(70) NOT NULL UNIQUE
);

CREATE TABLE district
(
    district_name VARCHAR(70) NOT NULL,
    country_id    TINYINT UNSIGNED
);

CREATE TABLE city
(
    city_name     VARCHAR(70) NOT NULL,
    district_name VARCHAR(70) NOT NULL,
    country_id    TINYINT UNSIGNED
);


CREATE TABLE person
(
    person_id       MEDIUMINT UNSIGNED,
    username        VARCHAR(70)  NOT NULL UNIQUE,
    first_name      VARCHAR(70)  NOT NULL,
    last_name       VARCHAR(70)  NOT NULL,
    email           VARCHAR(70)  NOT NULL UNIQUE,
    password        VARCHAR(255) NOT NULL,
    birthdate       DATE         NOT NULL,
    created_at      TIMESTAMP    NOT NULL DEFAULT current_timestamp,
    born_country_id TINYINT UNSIGNED,
    city_name       VARCHAR(70)  NOT NULL,
    district_name   VARCHAR(70) NOT NULL,
    country_id      TINYINT UNSIGNED
);


CREATE TABLE post
(
    post_id    MEDIUMINT UNSIGNED,
    content    TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
    person_id  MEDIUMINT UNSIGNED
);


CREATE TABLE comment
(
    comment_id MEDIUMINT UNSIGNED,
    msg        TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
    person_id  MEDIUMINT UNSIGNED,
    post_id    MEDIUMINT UNSIGNED
);

CREATE TABLE tag
(
    tag_id TINYINT UNSIGNED,
    name   VARCHAR(70) NOT NULL
);

CREATE TABLE follow
(
    person_id   MEDIUMINT UNSIGNED,
    follower_id MEDIUMINT UNSIGNED,
    created_at  TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE post_like
(
    post_id    MEDIUMINT UNSIGNED,
    person_id  MEDIUMINT UNSIGNED,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE comment_like
(
    comment_id MEDIUMINT UNSIGNED,
    person_id  MEDIUMINT UNSIGNED,
    created_at TIMESTAMP NOT NULL DEFAULT current_timestamp
);

CREATE TABLE comment_parent
(
    comment_id MEDIUMINT UNSIGNED,
    parent_id  MEDIUMINT UNSIGNED
);

CREATE TABLE post_tag
(
    post_id MEDIUMINT UNSIGNED,
    tag_id  TINYINT UNSIGNED
);

