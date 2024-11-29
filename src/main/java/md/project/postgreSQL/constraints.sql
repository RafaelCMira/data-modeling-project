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