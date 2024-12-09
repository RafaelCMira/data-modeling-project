-- Create a table with the edges of person connections
DROP TABLE IF EXISTS edges;

CREATE TABLE edges AS
SELECT 
    row_number() OVER () AS id,
    person_id1 AS source, 
    person_id2 AS target, 
    1 AS cost
FROM knows
UNION ALL
SELECT 
    row_number() OVER () + (SELECT count(*) FROM knows) AS id, 
    person_id2 AS source, 
    person_id1 AS target, 
    1 AS cost
FROM knows;