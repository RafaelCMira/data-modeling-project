--region Entities
COPY continent FROM 'C:/temp/continent.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY country FROM 'C:/temp/country.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY city FROM 'C:/temp/city.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY university FROM 'C:/temp/university.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY company FROM 'C:/temp/company.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY person FROM 'C:/temp/person.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY tag FROM 'C:/temp/tag.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY tag_class FROM 'C:/temp/tag_class.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY message FROM 'C:/temp/message.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY post FROM 'C:/temp/post.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY comment FROM 'C:/temp/comment.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY forum FROM 'C:/temp/forum.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);
--endregion

--region Relations
COPY knows FROM 'C:/temp/knows.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY studies FROM 'C:/temp/studies.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY works FROM 'C:/temp/works.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY likes FROM 'C:/temp/likes.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY message_tags FROM 'C:/temp/message_tags.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY forum_tags FROM 'C:/temp/forum_tags.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY forum_members FROM 'C:/temp/forum_members.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);

COPY has_interest FROM 'C:/temp/has_interest.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);