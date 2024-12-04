## 0. Prerequisites

-   Install Postgres server version 17, pgAdmin, and psql
-   Add postgres bin directory to the Windows system path:
    -   Edit the system environment variables -> Environment Variables -> System variables -> Path -> Edit -> New

```
C:\Program Files\PostgreSQL\17\bin
```

# How to load SQL data

## 1. Create a new database in Postgres

-   Open powershell terminal
-   Run the following commands to create a new database

```bash
$env:PGPASSWORD="your_password"
psql -U postgres -c "CREATE DATABASE test;"
```

## 2. Configure Postgres server

-   Go to the Postgres installation folder

```
C:\Program Files\PostgreSQL\17\data
```

-   Open the postgresql.conf file
-   Change the following properties:

    ### 1. Memory Settings

    This will only be important to create the indexes and foreign keys after the data is loaded

    ```properties
    shared_buffers = 1GB # Increases memory for caching data
    work_mem = 2047MB # Note: with 2GB fails so use MB, Increases memory for sorting operations
    maintenance_work_mem = 2GB # Increases memory for index creation and maintenance tasks
    ```

    ### 2. Checkpoint Settings

    ```properties
    max_wal_size = 4GB # Increases the WAL threshold to avoid frequent checkpoints
    checkpoint_timeout = 10min # Increases the checkpoint interval to reduce disk I/O
    ```

    ## 3. WAL (Write-Ahead Logging)

    ```properties
    max_wal_senders = 0 # Disables WAL replication to speed up data loading
    wal_level = minimal # Reduces the amount of WAL generated during data loading
    synchronous_commit = off # Disables fsync to speed up data loading
    full_page_writes = off # Disables full-page writes to speed up data loading
    wal_buffers = 128MB # Increases the WAL buffer size to speed up data loading
    ```

-   Save the file
-   Restart the Postgres server (Task Manager -> Services -> postgres-x64-17 -> Restart)
