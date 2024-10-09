# How to load SQL data

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

## 3. Connect to mysql shell

- Open the terminal
- Write: mysqlsh
- Write: \c root@localhost:3306 (\connect ```<user>@<host>:<port> ```)
- Put the password if asked (and configure to not ask again) [Y]
- Select the schema

    ``` shell
    \use data_modeling
    ```

## 4. Create the schema (Or Reset the schema)

After connecting to the MySQL shell, run the following commands:

``` shell
\sql
```

Note: Use absolute paths to avoid errors. 

The path to the schema.sql varies depending on your computer. Change the path accordingly.

``` shell
\source "C:\Users\Rafael\Documents\Universidade\2024_2025\1º 
Semestre\MD\trabalho\repo\data-modelling\src\main\java\com\example\data_modelling\rdbms\schema.sql"
```

## 5. Load the data into the schema

Run the following commands:

``` shell
\js
```

Note: Use absolute paths to avoid errors. 

The path to the bulkInsert.js varies depending on your computer. Change the path accordingly.

``` shell
\source "C:\Users\Rafael\Documents\Universidade\2024_2025\1º Semestre\MD\trabalho\repo\data-modelling\src\main\java\com\example\data_modelling\rdbms\bulkInsert.js"
```

