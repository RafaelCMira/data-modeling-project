## How to load the data

-   ### 1. Do the postgreSQL `SIMPLE_README.MD`

-   ### 2. Configure the Neo4j database

    -   Open the Neo4j Desktop
    -   Create a new database
    -   Find the database id, this will be needed to run the `doesAll.ps1` script
        -   Hover over the database you just created
        -   Click on the three dots
        -   Open settings
            -   Ctrl + F: `dbms.windows_service_name`
            -   Copy what's after this `neo4j-relate-`
            -   e.g. `dbms-407a92d1-d49c-4ce8-8e19-dc6974adc4d5`

-   ### 3. Generate the dataset (Optional if you already have the dataset)

    -   Run the datagen.ps1 script to run the LDBC SNB datagen docker image.
    -   sf is the scale factor. Possible values: 0.3, 1, 3, 10

        ```bash
        .\datagen.ps1 -sf 0.3
        ```

-   ### 4. Run the doesAll.ps1 script

    This script will:

    -   Clean the csv files

    -   `PostgreSQL`:

        -   Create the schema
        -   Load the data
        -   Create the constraints and indexes
        -   Update the statistics.

    -   `Neo4j`: configure the database.

    ```bash
    .\doesAll.ps1 -user "Rafael" -pgPassword "password" -datasetFolder "ldbc_output_composite_merged-default_0_3" -neo4jDB "dbms-23424-1234123-234234-sada2dasd3qqf" >> "output_machine2.txt"
    ```

-   ### 5. Load data into Neo4j

    -   Open the Neo4j Desktop
    -   Open neo4j browser

    -   Create the constraints

        -   Copy constraints.cypher content to the neo4j browser

    -   Load the csv files
        ```cypher
        // Load data
        CALL apoc.cypher.runFile("file:///import/load_data.cypher")
        ```

-   ### 6. Reset the Postgres configuration to the default settings.

    -   Open the postgresql.conf file
    -   Restore the default values for the properties changed in step 1
    -   Check the postgresql_defaults.conf file in the repo for the default values

-   ### 7. Reset the Neo4j configuration to the default settings.

    -   Open the Neo4j Desktop
    -   Go to the settings
    -   TODO: define the values based on the dataset size
