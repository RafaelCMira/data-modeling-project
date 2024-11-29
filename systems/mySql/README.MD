# How to load SQL data


## 0. Configure MySQL server

- Go to the MySQL installation folder
- Open the my.ini file
- Change the following properties:
    ```properties
  innodb_log_buffer_size=256M
  innodb_buffer_pool_size=4G
    ```
- Save the file
- Restart the MySQL server

## 1. Create the Database in MySQL

- Open MySQL Workbench
- Create a new connection
  - Hostname: localhost
  - Port: 3306
  - Username: root (or any other user you have configured)
  - Password: (choose a password)
- SQL script to create the schema (Or just use MySQL Workbench GUI and create the schema)
    ```mysql
    CREATE SCHEMA `data_modeling` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
    ```

## 2. Run the java application to generate the data

- Open the project in IntelliJ IDEA
- Run.

## 3. Clean the .csv files (remove duplicates)

- Install wsl (Windows Subsystem for Linux) if you don't have it installed
- Go to the folder where the .csv files are located
- Open a wsl (bash) terminal
- Check if dos2unix is installed
    ``` shell
    dos2unix --version
    ```
  - If not installed, install it
      ``` shell
      sudo apt update
      ```
      ``` shell
      sudo apt install dos2unix
      ```

- Copy the clean.sh file to the folder where the .csv files are located
- Convert the clean.sh file to unix format
    ``` shell
    dos2unix clean.sh
    ```
- Run the clean.sh file
    ``` shell
    bash clean.sh
    ```
  - If can't run the file, give it permission
    ``` shell
    chmod +x clean.sh
    ```
    ``` shell
    bash clean.sh
    ```
  

## 3. Connect to mysql shell

- Open the terminal
- Write: mysqlsh
- Write: \c root@localhost:3306 (\connect ```<user>@<host>:<port> ```)
- Put the password if asked (and configure to not ask again) [Y]
- Select the schema

    ``` shell
    \use data_modeling
    ```

## 4. Create the schema (Or Reset the schema) (schema.sql)

After connecting to the MySQL shell, run the following commands:

``` shell
\sql
```

Enable local infile

``` shell
SET GLOBAL local_infile = 1;
```

The path to the schema.sql varies depending on your computer. Change the path accordingly.

Note: Use absolute paths to avoid errors.

``` shell
\source "<path_to_schema.sql>"
```

## 5. Load the data into the schema (bulkInsert.js)

Run the following commands:

``` shell
\js
```

Note: Use absolute paths to avoid errors. 

The path to the bulkInsert.js varies depending on your computer. Change the path accordingly.

``` shell
\source "<path_to_bulkInsert.js>"
```

## 6. Create the constraints (constraints.sql)

Run the following commands:

``` shell
\source "<path_to_constraints.sql>"
```