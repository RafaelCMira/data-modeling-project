# How to load data into Neo4j

## 1. Configure the Neo4j Desktop

-   Open the Neo4j Desktop
-   Create a new database

-   Find the database id, this will be needed to run the `doesAll.ps1` script

    -   Hover over the database you just created
    -   Click on the three dots
    -   Open settings
        -   Ctrl + F: `dbms.windows_service_name`
        -   Copy what's after `neo4j-relate-`
        -   e.g. `dbms-407a92d1-d49c-4ce8-8e19-dc6974adc4d5`

## 2. Load the data

-   Open the Neo4j Desktop
-   Open neo4j browser

    1. Create the constraints

        - Run (ctrl + a, ctrl + enter) the following cypher query

        - ```cypher
              // Pk constraints
              CREATE CONSTRAINT continent_id_unique IF NOT EXISTS
              FOR (c:Continent)
              REQUIRE c.continent_id IS UNIQUE;

              CREATE CONSTRAINT country_id_unique IF NOT EXISTS
              FOR (c:Country)
              REQUIRE c.country_id IS UNIQUE;

              CREATE CONSTRAINT city_id_unique IF NOT EXISTS
              FOR (c:City)
              REQUIRE c.city_id IS UNIQUE;



              CREATE CONSTRAINT university_id_unique IF NOT EXISTS
              FOR (u:University)
              REQUIRE u.university_id IS UNIQUE;

              CREATE CONSTRAINT company_id_unique IF NOT EXISTS
              FOR (c:Company)
              REQUIRE c.company_id IS UNIQUE;



              CREATE CONSTRAINT tag_id_unique IF NOT EXISTS
              FOR (t:Tag)
              REQUIRE t.tag_id IS UNIQUE;

              CREATE CONSTRAINT tag_class_id_unique IF NOT EXISTS
              FOR (tc:TagClass)
              REQUIRE tc.tag_class_id IS UNIQUE;



              CREATE CONSTRAINT person_id_unique IF NOT EXISTS
              FOR (p:Person)
              REQUIRE p.person_id IS UNIQUE;



              CREATE CONSTRAINT forum_id_unique IF NOT EXISTS
              FOR (f:Forum)
              REQUIRE f.forum_id IS UNIQUE;



              CREATE CONSTRAINT message_id_unique IF NOT EXISTS
              FOR (m:Message)
              REQUIRE m.message_id IS UNIQUE;

              CREATE CONSTRAINT comment_id_unique IF NOT EXISTS
              FOR (c:Comment)
              REQUIRE c.comment_id IS UNIQUE;

              CREATE CONSTRAINT post_id_unique IF NOT EXISTS
              FOR (p:Post)
              REQUIRE p.post_id IS UNIQUE;
          ```

    1. Load the csv files

    -   ```cypher
          // Load data
          CALL apoc.cypher.runFile("file:///import/load_data.cypher")
        ```
