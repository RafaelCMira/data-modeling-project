# 1. Configuration

## 0. Prerequisites

-   Install Postgres server version 17, pgAdmin, and psql
-   Add postgres bin directory to the Windows system path:
    -   Edit the system environment variables -> Environment Variables -> System variables -> Path -> Edit -> New

```
C:\Program Files\PostgreSQL\17\bin
```

## 1. Install GNU Parallel

-   Open bash terminal
-   Run the following command to install GNU Parallel

```bash
sudo apt-get update
```

```bash
sudo apt-get install parallel
```

## 2. Install postgres client in WSL

```bash
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
```

```bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```

```bash
sudo apt-get update
```

```bash
sudo apt-get install postgresql-client-17
```

## 3. Change server configuration to allow remote connections

-   Go to the Postgres installation folder

```
C:\Program Files\PostgreSQL\17\data
```

-   Open the postgresql.conf file
-   Change this property if it's not like this (by default is but check)

```properties
listen_addresses = '*' # Allows connections from any IP address
```

-   Open the pg_hba.conf file
-   Add the following lines to the end of the file:

```properties
host    all             all             172.0.0.0/8             scram-sha-256
host    all             all             192.0.0.0/8             scram-sha-256
```

## 4. Configure windows firewall to allow connections

-   Go to this link: https://stackoverflow.com/questions/56824788/how-to-connect-to-windows-postgres-database-from-wsl
-   Do exactly what the first answer says
-   (just need to do the 1 - 12 steps, the rest is explained in the next section)

## 5. Configure WSL to connect to the Postgres server

-   Open a bash terminal
-   Run

```bash
vim ~/.bashrc
```

-   Press **i** to be able to write
-   Go to the end of the file and add the following lines: (copy and right-click to paste in the terminal)

```bash
# Add DNS entry for Windows host
if ! $(cat /etc/hosts | grep -q 'winhost'); then
  echo 'Adding DNS entry for Windows host in /etc/hosts'
  echo '\n# Windows host - added via ~/.bashrc' | sudo tee -a /etc/hosts
  echo -e "$(grep nameserver /etc/resolv.conf | awk '{print $2, "   winhost"}')" | sudo tee -a /etc/hosts
fi
```

-   Press **ESC** and type **:wq** to save and exit the file
-   Run the following command to apply the changes

```bash
source ~/.bashrc
```

-   Verify the changes by running the following command

```bash
psql -h winhost -p 5432 -U postgres (if it asks for a password it works)
```

# How to load SQL data

## 0. Create a new database in Postgres

-   Open powershell terminal
-   Run the following commands to create a new database

```bash
$env:PGPASSWORD="your_password"
psql -U postgres -c "CREATE DATABASE test;"
```

## 1. Configure Postgres server

-   Go to the Postgres installation folder

```
C:\Program Files\PostgreSQL\17\data
```

-   Open the postgresql.conf file
-   Change the following properties:

    ### 1. Memory Settings

    This will only be important to create the indexes and foreign keys after the data is loaded

    ```properties
    maintenance_work_mem = 1GB # Increases memory for index creation and maintenance tasks
    ```

    ### 2. Checkpoint Settings

    ```properties
    max_wal_size = 2GB # Increases the WAL threshold to avoid frequent checkpoints
    checkpoint_timeout = 10min # Increases the checkpoint interval to reduce disk I/O
    ```

-   Save the file
-   Restart the Postgres server (Task Manager -> Services -> postgres-x64-17 -> Restart)

## 2. Generate the dataset

-   Run the datagen.ps1 script to run the LDBC SNB datagen docker image
-   Run the python script to clean the csv files and place them in the temp folder

## 3. Create schema

-   Run the schema.sql script to create the tables

```bash
$env:PGPASSWORD="your_password"
psql -U postgres -d test -f "C:/temp/schema.sql"
```

## 4. Load SQL data in parallel

-   Options for loading the data:
    -   **Option 1:** Use the COPY command in pgAdmin (works)
        -   Place the csv files in the 'C:\temp' directory
        -   Run the command in the query tool
            ```sql
            COPY continent FROM 'C:/temp/continent.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);
            ```
    -   **Option 2:** Do the same but using the psql in powershell (works)
        -   Place the csv files in the 'C:\temp' directory
        -   Connect to the database
            ```bash
            $env:PGPASSWORD="your_password"
            psql -U postgres -d test
            ```
        -   Run the command in the query tool
            ```sql
            COPY continent FROM 'C:/temp/continent.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);
            ```
    -   **Option 3:** Do the same but in wsL (works)
        -   Place the csv files in the 'C:\temp' directory
        -   Connect to the database
            ```bash
            PGPASSWORD=your_password psql -h winhost -p 5432 -U postgres -d test
            ```
        -   Run the command in the query tool
            ```sql
            COPY continent FROM 'C:/temp/continent.csv' WITH (FORMAT csv, DELIMITER '|', NULL '', HEADER);
            ```

## 5. Create constraints and indexes

-   Run the constraints.sql script to create the constraints and indexes

```bash
$env:PGPASSWORD="your_password"
psql -U postgres -d test -f "C:/temp/constraints.sql"
```

## 6. ANALYZE the tables to update the statistics

-   Run the following command to update the statistics for the tables:

```sql
ANALYZE;
```

## 7. Reset the Postgres configuration to the default settings.

-   Open the postgresql.conf file
-   Change the following properties: **TODO:** check the default values and update this section

    ### 1. Memory and Disk Settings

    ```properties
    maintenance_work_mem = 64MB # Default value
    ```

    ### 2. Checkpoint Settings

    ```properties
    max_wal_size = 1GB # Default value
    checkpoint_timeout = 5min # Default value
    ```
