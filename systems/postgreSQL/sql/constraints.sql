-- Primary keys
-- region ENTITIES
ALTER TABLE CONTINENT
ADD CONSTRAINT CONTINENT_PK PRIMARY KEY (CONTINENT_ID);

ALTER TABLE COUNTRY
ADD CONSTRAINT COUNTRY_PK PRIMARY KEY (COUNTRY_ID);

ALTER TABLE CITY
ADD CONSTRAINT CITY_PK PRIMARY KEY (CITY_ID);

ALTER TABLE UNIVERSITY
ADD CONSTRAINT UNIVERSITY_PK PRIMARY KEY (UNIVERSITY_ID);

ALTER TABLE COMPANY
ADD CONSTRAINT COMPANY_PK PRIMARY KEY (COMPANY_ID);

ALTER TABLE PERSON
ADD CONSTRAINT PERSON_PK PRIMARY KEY (PERSON_ID);

ALTER TABLE TAG
ADD CONSTRAINT TAG_PK PRIMARY KEY (TAG_ID);

ALTER TABLE TAG_CLASS
ADD CONSTRAINT TAG_CLASS_PK PRIMARY KEY (TAG_CLASS_ID);

ALTER TABLE MESSAGE
ADD CONSTRAINT MESSAGE_PK PRIMARY KEY (MESSAGE_ID);

ALTER TABLE POST
ADD CONSTRAINT POST_PK PRIMARY KEY (MESSAGE_ID);

ALTER TABLE COMMENT
ADD CONSTRAINT COMMENT_PK PRIMARY KEY (MESSAGE_ID);

ALTER TABLE FORUM
ADD CONSTRAINT FORUM_PK PRIMARY KEY (FORUM_ID);

-- endregion
-- region RELATIONS
ALTER TABLE KNOWS
ADD CONSTRAINT KNOWS_PK PRIMARY KEY (PERSON_ID1, PERSON_ID2);

ALTER TABLE STUDIES
ADD CONSTRAINT STUDIES_PK PRIMARY KEY (PERSON_ID, UNIVERSITY_ID);

ALTER TABLE WORKS
ADD CONSTRAINT WORKS_PK PRIMARY KEY (PERSON_ID, COMPANY_ID);

ALTER TABLE LIKES
ADD CONSTRAINT LIKES_PK PRIMARY KEY (PERSON_ID, MESSAGE_ID);

ALTER TABLE MESSAGE_TAGS
ADD CONSTRAINT MESSAGE_TAGS_PK PRIMARY KEY (MESSAGE_ID, TAG_ID);

ALTER TABLE FORUM_TAGS
ADD CONSTRAINT FORUM_TAGS_PK PRIMARY KEY (FORUM_ID, TAG_ID);

ALTER TABLE FORUM_MEMBERS
ADD CONSTRAINT FORUM_MEMBERS_PK PRIMARY KEY (FORUM_ID, PERSON_ID);

ALTER TABLE HAS_INTEREST
ADD CONSTRAINT HAS_INTEREST_PK PRIMARY KEY (PERSON_ID, TAG_ID);

-- endregion
-- Foreign keys
-- region ENTITIES
ALTER TABLE COUNTRY
ADD CONSTRAINT COUNTRY_CONTINENT_FK FOREIGN KEY (CONTINENT_ID) REFERENCES CONTINENT (CONTINENT_ID) NOT VALID;

ALTER TABLE COUNTRY VALIDATE CONSTRAINT COUNTRY_CONTINENT_FK;

ALTER TABLE CITY
ADD CONSTRAINT CITY_COUNTRY_FK FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRY (COUNTRY_ID) NOT VALID;

ALTER TABLE CITY VALIDATE CONSTRAINT CITY_COUNTRY_FK;

ALTER TABLE UNIVERSITY
ADD CONSTRAINT UNIVERSITY_CITY_FK FOREIGN KEY (CITY_ID) REFERENCES CITY (CITY_ID) NOT VALID;

ALTER TABLE UNIVERSITY VALIDATE CONSTRAINT UNIVERSITY_CITY_FK;

ALTER TABLE COMPANY
ADD CONSTRAINT COMPANY_COUNTRY_FK FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRY (COUNTRY_ID) NOT VALID;

ALTER TABLE COMPANY VALIDATE CONSTRAINT COMPANY_COUNTRY_FK;

ALTER TABLE PERSON
ADD CONSTRAINT PERSON_CITY_FK FOREIGN KEY (CITY_ID) REFERENCES CITY (CITY_ID) NOT VALID;

ALTER TABLE PERSON VALIDATE CONSTRAINT PERSON_CITY_FK;

ALTER TABLE TAG
ADD CONSTRAINT TAG_TAG_CLASS_FK FOREIGN KEY (TAG_CLASS_ID) REFERENCES TAG_CLASS (TAG_CLASS_ID) NOT VALID;

ALTER TABLE TAG VALIDATE CONSTRAINT TAG_TAG_CLASS_FK;

ALTER TABLE TAG_CLASS
ADD CONSTRAINT TAG_CLASS_SUBCLASS_OF_FK FOREIGN KEY (SUBCLASS_OF) REFERENCES TAG_CLASS (TAG_CLASS_ID) NOT VALID;

ALTER TABLE TAG_CLASS VALIDATE CONSTRAINT TAG_CLASS_SUBCLASS_OF_FK;

ALTER TABLE MESSAGE
ADD CONSTRAINT MESSAGE_COUNTRY_FK FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRY (COUNTRY_ID) NOT VALID,
ADD CONSTRAINT MESSAGE_PERSON_FK FOREIGN KEY (PERSON_ID) REFERENCES PERSON (PERSON_ID) NOT VALID;

ALTER TABLE MESSAGE 
VALIDATE CONSTRAINT MESSAGE_COUNTRY_FK,
VALIDATE CONSTRAINT MESSAGE_PERSON_FK;

ALTER TABLE POST
ADD CONSTRAINT POST_MESSAGE_FK FOREIGN KEY (MESSAGE_ID) REFERENCES MESSAGE (MESSAGE_ID) NOT VALID,
ADD CONSTRAINT POST_FORUM_FK FOREIGN KEY (FORUM_ID) REFERENCES FORUM (FORUM_ID) NOT VALID;

ALTER TABLE POST
VALIDATE CONSTRAINT POST_MESSAGE_FK,
VALIDATE CONSTRAINT POST_FORUM_FK;

ALTER TABLE COMMENT
ADD CONSTRAINT COMMENT_MESSAGE_FK FOREIGN KEY (MESSAGE_ID) REFERENCES MESSAGE (MESSAGE_ID) NOT VALID,
ADD CONSTRAINT COMMENT_MESSAGE_PARENT_FK FOREIGN KEY (PARENT_ID) REFERENCES MESSAGE (MESSAGE_ID) NOT VALID;

ALTER TABLE COMMENT
VALIDATE CONSTRAINT COMMENT_MESSAGE_FK,
VALIDATE CONSTRAINT COMMENT_MESSAGE_PARENT_FK;

ALTER TABLE FORUM
ADD CONSTRAINT FORUM_MODERATOR_FK FOREIGN KEY (PERSON_ID) REFERENCES PERSON (PERSON_ID) NOT VALID;

ALTER TABLE FORUM
VALIDATE CONSTRAINT FORUM_MODERATOR_FK;

-- endregion
-- region RELATIONS
ALTER TABLE KNOWS
ADD CONSTRAINT KNOWS_PERSON1_FK FOREIGN KEY (PERSON_ID1) REFERENCES PERSON (PERSON_ID) NOT VALID,
ADD CONSTRAINT KNOWS_PERSON2_FK FOREIGN KEY (PERSON_ID2) REFERENCES PERSON (PERSON_ID) NOT VALID;

ALTER TABLE KNOWS
VALIDATE CONSTRAINT KNOWS_PERSON1_FK,
VALIDATE CONSTRAINT KNOWS_PERSON2_FK;

ALTER TABLE STUDIES
ADD CONSTRAINT STUDIES_PERSON_FK FOREIGN KEY (PERSON_ID) REFERENCES PERSON (PERSON_ID) NOT VALID,
ADD CONSTRAINT STUDIES_UNIVERSITY_FK FOREIGN KEY (UNIVERSITY_ID) REFERENCES UNIVERSITY (UNIVERSITY_ID) NOT VALID;

ALTER TABLE STUDIES
VALIDATE CONSTRAINT STUDIES_PERSON_FK,
VALIDATE CONSTRAINT STUDIES_UNIVERSITY_FK;

ALTER TABLE WORKS
ADD CONSTRAINT WORKS_PERSON_FK FOREIGN KEY (PERSON_ID) REFERENCES PERSON (PERSON_ID) NOT VALID,
ADD CONSTRAINT WORKS_COMPANY_FK FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY (COMPANY_ID) NOT VALID;

ALTER TABLE WORKS
VALIDATE CONSTRAINT WORKS_PERSON_FK,
VALIDATE CONSTRAINT WORKS_COMPANY_FK;

ALTER TABLE LIKES
ADD CONSTRAINT LIKES_PERSON_FK FOREIGN KEY (PERSON_ID) REFERENCES PERSON (PERSON_ID) NOT VALID,
ADD CONSTRAINT LIKES_MESSAGE_FK FOREIGN KEY (MESSAGE_ID) REFERENCES MESSAGE (MESSAGE_ID) NOT VALID;

ALTER TABLE LIKES
VALIDATE CONSTRAINT LIKES_PERSON_FK,
VALIDATE CONSTRAINT LIKES_MESSAGE_FK;

ALTER TABLE MESSAGE_TAGS
ADD CONSTRAINT MESSAGE_TAGS_MESSAGE_FK FOREIGN KEY (MESSAGE_ID) REFERENCES MESSAGE (MESSAGE_ID) NOT VALID,
ADD CONSTRAINT MESSAGE_TAGS_TAG_FK FOREIGN KEY (TAG_ID) REFERENCES TAG (TAG_ID) NOT VALID;

ALTER TABLE MESSAGE_TAGS
VALIDATE CONSTRAINT MESSAGE_TAGS_MESSAGE_FK,
VALIDATE CONSTRAINT MESSAGE_TAGS_TAG_FK;

ALTER TABLE FORUM_TAGS
ADD CONSTRAINT FORUM_TAGS_FORUM_FK FOREIGN KEY (FORUM_ID) REFERENCES FORUM (FORUM_ID) NOT VALID,
ADD CONSTRAINT FORUM_TAGS_TAG_FK FOREIGN KEY (TAG_ID) REFERENCES TAG (TAG_ID) NOT VALID;

ALTER TABLE FORUM_TAGS
VALIDATE CONSTRAINT FORUM_TAGS_FORUM_FK,
VALIDATE CONSTRAINT FORUM_TAGS_TAG_FK;

ALTER TABLE FORUM_MEMBERS
ADD CONSTRAINT FORUM_MEMBERS_FORUM_FK FOREIGN KEY (FORUM_ID) REFERENCES FORUM (FORUM_ID) NOT VALID,
ADD CONSTRAINT FORUM_MEMBERS_PERSON_FK FOREIGN KEY (PERSON_ID) REFERENCES PERSON (PERSON_ID) NOT VALID;

ALTER TABLE FORUM_MEMBERS
VALIDATE CONSTRAINT FORUM_MEMBERS_FORUM_FK,
VALIDATE CONSTRAINT FORUM_MEMBERS_PERSON_FK;

ALTER TABLE HAS_INTEREST
ADD CONSTRAINT HAS_INTEREST_PERSON_FK FOREIGN KEY (PERSON_ID) REFERENCES PERSON (PERSON_ID) NOT VALID,
ADD CONSTRAINT HAS_INTEREST_TAG_FK FOREIGN KEY (TAG_ID) REFERENCES TAG (TAG_ID) NOT VALID;

ALTER TABLE HAS_INTEREST
VALIDATE CONSTRAINT HAS_INTEREST_PERSON_FK,
VALIDATE CONSTRAINT HAS_INTEREST_TAG_FK;

-- endregion