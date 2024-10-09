# How to load data into Neo4j

## 1. Configure the Neo4j Desktop
- Open the Neo4j Desktop
- Create a new database
- Click on the three dots
- Click on settings
- Set the following settings: (Increase the heap size if you have a lot of data tio avoid out of memory errors)
  - ```properties
    server.memory.heap.initial_size=4g
    server.memory.heap.max_size=4g
    ```

## 2. Find the folder to the database
- Open the Neo4j Desktop
- Hover over the database you want to load data into
- Click on the three dots
- Click on "Open Folder" -> Import (Will open the folder where you can store the data)
  - `C:\Users\Rafael\.Neo4jDesktop\relate-data\dbmss\dbms-b52b7ca0-0d4f-4dbb-afa9-b9235e466017\import`


## 3. Install the APOC plugin
- Open the Neo4j Desktop
- Click in the database name -> This will open a side bar on the right
- Plugins -> APOC -> Install


## 4. Install the APOC extended plugin
- Download the APOC extended JAR from https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases
- Place the JAR in the plugins folder of the database 
  - `C:\Users\Rafael\.Neo4jDesktop\relate-data\dbmss\dbms-b52b7ca0-0d4f-4dbb-afa9-b9235e466017\plugins`
-  Create a file named `apoc.conf` in the conf folder `C:\Users\Rafael\.Neo4jDesktop\relate-data\dbmss\dbms-b52b7ca0-0d4f-4dbb-afa9-b9235e466017\conf`
- Paste this property in the `apoc.conf` file
  - ```properties
      apoc.import.file.enabled=true
      ```
  
## 5. Load the data
- Copy cypher files to the import folder
- Copy all the .csv files to the import folder
- Open the Neo4j Desktop
- Open neo4j browser
  - Run:
    - ```cypher
          // Pk constraints
          CREATE CONSTRAINT country_id_unique IF NOT EXISTS
          FOR (c:Country)
          REQUIRE c.country_id IS UNIQUE;
  
          CREATE CONSTRAINT district_unique IF NOT EXISTS
          FOR (d:District)
          REQUIRE (d.district_name, d.country_id) IS UNIQUE;
  
          CREATE CONSTRAINT city_unique IF NOT EXISTS
          FOR (c:City)
          REQUIRE (c.city_name, c.district_name, c.country_id) IS UNIQUE;
  
          CREATE CONSTRAINT person_id_unique IF NOT EXISTS
          FOR (p:Person)
          REQUIRE p.person_id IS UNIQUE;
      
          CREATE CONSTRAINT post_id_unique IF NOT EXISTS
          FOR (po:Post)
          REQUIRE po.post_id IS UNIQUE;
      
          CREATE CONSTRAINT comment_id_unique IF NOT EXISTS
          FOR (co:Comment)
          REQUIRE co.comment_id IS UNIQUE;
      
          CREATE CONSTRAINT tag_id_unique IF NOT EXISTS
          FOR (t:Tag)
          REQUIRE t.tag_id IS UNIQUE;
        ```

    - ```cypher
      // Load data
      CALL apoc.cypher.runFile("file:///load_data.cypher")
      ```
