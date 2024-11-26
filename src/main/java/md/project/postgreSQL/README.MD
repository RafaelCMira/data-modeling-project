# Install guide

## 0. Prerequisites
- Install Postgres server version 17, pgAdmin, and psql
- Add postgres bin directory to the Windows system path: 
  - Edit the system environment variables -> Environment Variables -> System variables -> Path -> Edit -> New
```
C:\Program Files\PostgreSQL\17\bin
```

## 1. Install GNU Parallel

- Open bash terminal
- Run the following command to install GNU Parallel
``` bash
sudo apt-get update
```

``` bash
sudo apt-get install parallel
```

## 2. Install postgres client in WSL

``` bash
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
```

``` bash
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
```

``` bash
sudo apt-get update
```

``` bash
sudo apt-get install postgresql-client-17
```

## 3. Change server configuration to allow remote connections

- Go to the Postgres installation folder
```
C:\Program Files\PostgreSQL\17\data
```
- Open the postgresql.conf file
- Change the following properties:
```properties
listen_addresses = '*' # Allows connections from any IP address
```

- Open the pg_hba.conf file
- Add the following lines to the end of the file:
```properties
host    all             all             172.0.0.0/8             scram-sha-256
host    all             all             192.0.0.0/8             scram-sha-256
```

## 4. Configure windows firewall to allow connections

- Go to this link: https://stackoverflow.com/questions/56824788/how-to-connect-to-windows-postgres-database-from-wsl
- Do exactly what the first answer says
- (just need to do the 1 - 12 steps, the rest is explained in the next section)

## 5. Configure WSL to connect to the Postgres server

- Open a bash terminal
- Run
``` bash
vim ~/.bashrc
```
- Press **i** to be able to write
- Go to the end of the file and add the following lines: (copy and right-click to paste in the terminal)
``` bash
# Add DNS entry for Windows host
if ! $(cat /etc/hosts | grep -q 'winhost'); then
  echo 'Adding DNS entry for Windows host in /etc/hosts'
  echo '\n# Windows host - added via ~/.bashrc' | sudo tee -a /etc/hosts
  echo -e "$(grep nameserver /etc/resolv.conf | awk '{print $2, "   winhost"}')" | sudo tee -a /etc/hosts
fi
```
- Press **ESC** and type **:wq** to save and exit the file
- Run the following command to apply the changes
``` bash
source ~/.bashrc
```
- Verify the changes by running the following command
``` bash
psql -h winhost -p 5432 -U postgres (if it asks for a password it works)
```



# How to load SQL data

## 1. Configure Postgres server

- Go to the Postgres installation folder
```
C:\Program Files\PostgreSQL\17\data
```
- Open the postgresql.conf file
- Change the following properties:

  ### 1. Disable Write-Ahead Logging (WAL) overhead 
    ```properties
    fsync = off
    synchronous_commit = off # Disables waiting for disk writes, improving write performance
     ```
  ### 2.  Memory and Disk Settings
    ```properties
    maintenance_work_mem = 1GB # Increases memory for index creation and maintenance tasks
    work_mem = 512MB # Memory used for sorting and hash tables
    shared_buffers = 256MB
    autovacuum = off # Prevents autovacuum processes from slowing down inserts
    ```

  ### 3. Checkpoint Settings
    ```properties
    max_wal_size = 2GB # Increases the WAL threshold to avoid frequent checkpoints
    checkpoint_timeout = 10min # Increases the checkpoint interval to reduce disk I/O
    checkpoint_completion_target = 0.9 # Spreads checkpoint writes over a longer period to avoid I/O spikes
    ```
- Save the file
- Restart the MySQL server




## 2. Load SQL data in parallel



## 3. Create constraints and indexes

- For indexes, use the following command:
``` sql
CREATE INDEX CONCURRENTLY <idx_name> ON <table_name> <(column_name)>;
```

- For constraints, use the following command:
``` sql
ALTER TABLE <table_name> ADD CONSTRAINT <pk_name> PRIMARY KEY <(column_name)> DEFERRABLE INITIALLY DEFERRED;
  
ALTER TABLE <table_name> ADD CONSTRAINT <fk_name> FOREIGN KEY <(column_name)> REFERENCES <table_name> <(column_name)> DEFERRABLE INITIALLY DEFERRED;
```

## 4. ANALYZE the tables to update the statistics

- Run the following command to update the statistics for the tables:
``` sql
ANALYZE <table_name>;
```

## 5. Reset the Postgres configuration to the default settings.

- Open the postgresql.conf file
- Change the following properties: **TODO:** check the default values and update this section

  ### 1. Enable Write-Ahead Logging (WAL) overhead 
    ```properties
    fsync = on
    synchronous_commit = on # Enables waiting for disk writes, improving data durability
     ```
  ### 2.  Memory and Disk Settings
    ```properties
    maintenance_work_mem = 64MB # Default value
    work_mem = 4MB # Default value
    shared_buffers = 128MB # Default value
    autovacuum = on # Enables autovacuum processes
    ```

  ### 3. Checkpoint Settings
    ```properties
    max_wal_size = 1GB # Default value
    checkpoint_timeout = 5min # Default value
    checkpoint_completion_target = 0.5 # Default value
    ```