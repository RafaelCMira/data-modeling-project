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


-- Primary Key Constraints
ALTER TABLE country
    ADD PRIMARY KEY (country_id);

ALTER TABLE district
    ADD PRIMARY KEY (district_name, country_id);

ALTER TABLE city
    ADD PRIMARY KEY (city_name, district_name, country_id);

ALTER TABLE person
    ADD PRIMARY KEY (person_id);

ALTER TABLE post
    ADD PRIMARY KEY (post_id);

ALTER TABLE comment
    ADD PRIMARY KEY (comment_id);

ALTER TABLE tag
    ADD PRIMARY KEY (tag_id);

ALTER TABLE follow
    ADD PRIMARY KEY (person_id, follower_id);

ALTER TABLE post_like
    ADD PRIMARY KEY (post_id, person_id);

ALTER TABLE comment_like
    ADD PRIMARY KEY (comment_id, person_id);

ALTER TABLE comment_parent
    ADD PRIMARY KEY (comment_id);

ALTER TABLE post_tag
    ADD PRIMARY KEY (post_id, tag_id);


-- Foreign Key Constraints
ALTER TABLE city
    ADD CONSTRAINT fk_city_district FOREIGN KEY (district_name, country_id) REFERENCES district (district_name, country_id) ON DELETE CASCADE;

ALTER TABLE district
    ADD CONSTRAINT fk_district_country FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE CASCADE;

ALTER TABLE person
    ADD CONSTRAINT fk_person_born_country FOREIGN KEY (born_country_id) REFERENCES country (country_id),
    ADD CONSTRAINT fk_person_city FOREIGN KEY (city_name, district_name, country_id) REFERENCES city (city_name, district_name, country_id)
;

ALTER TABLE post
    ADD CONSTRAINT fk_post_person FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE;

ALTER TABLE comment
    ADD CONSTRAINT fk_comment_person FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_comment_post FOREIGN KEY (post_id) REFERENCES post (post_id) ON DELETE CASCADE
;

ALTER TABLE follow
    ADD CONSTRAINT fk_follow_person FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_follow_follower FOREIGN KEY (follower_id) REFERENCES person (person_id) ON DELETE CASCADE
;

ALTER TABLE post_like
    ADD CONSTRAINT fk_post_like_person FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_post_like_post FOREIGN KEY (post_id) REFERENCES post (post_id) ON DELETE CASCADE
;

ALTER TABLE comment_like
    ADD CONSTRAINT fk_comment_like_comment FOREIGN KEY (comment_id) REFERENCES comment (comment_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_comment_like_person FOREIGN KEY (person_id) REFERENCES person (person_id) ON DELETE CASCADE
;

ALTER TABLE comment_parent
    ADD CONSTRAINT fk_comment_parent_comment FOREIGN KEY (comment_id) REFERENCES comment (comment_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_comment_parent_parent FOREIGN KEY (parent_id) REFERENCES comment (comment_id) ON DELETE CASCADE
;

ALTER TABLE post_tag
    ADD CONSTRAINT fk_post_tag_post FOREIGN KEY (post_id) REFERENCES post (post_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_post_tag_tag FOREIGN KEY (tag_id) REFERENCES tag (tag_id) ON DELETE CASCADE
;


