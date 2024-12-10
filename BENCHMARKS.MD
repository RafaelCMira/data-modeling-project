# Benchmarks configuration

We will run 7 benchmarks for each system AND each dataset. The benchmarks are:

-   **Default**: The system will run with default settings.
-   **1GB**: The system will run with 1GB of memory.
-   **2GB**: The system will run with 2GB of memory.
-   **4GB**: The system will run with 4GB of memory.
-   **8GB**: The system will run with 8GB of memory.
-   **xGB + Indexed**: The system will run with indexes other than the primary and foreign keys. (memory to be determined but probably 2GB or 4GB)
-   **xGB + Concurrent**: The system will run with concurrent connections doing diverse operations. (memory to be determined but probably 4GB or 8GB)

## 1. PostgreSQL

The parameters we will change are:

-   `shared_buffers`
-   `work_mem`

### Default configuration

```properties
shared_buffers = 128MB
work_mem = 4MB
```

### 1GB configuration (x8)

```properties
shared_buffers = 1024MB
work_mem = 32MB
```

### 2GB configuration (x16)

```properties
shared_buffers = 2048MB
work_mem = 64MB
```

### 4GB configuration (x32)

```properties
shared_buffers = 4096MB
work_mem = 128MB
```

### 8GB configuration (x64)

```properties
shared_buffers = 8192MB
work_mem = 128MB
```

### xGB + Indexed configuration

```properties
shared_buffers = 4096MB
work_mem = 128MB
```

### xGB + Concurrent configuration

```properties
shared_buffers = 8192MB
work_mem = 128MB
```

## 2. Neo4j

The parameters we will change are:

-   `dbms.memory.heap.initial_size`
-   `dbms.memory.heap.max_size`
-   `dbms.memory.pagecache.size`

### Default configuration

```properties
dbms.memory.heap.initial_size = 512m
dbms.memory.heap.max_size = 512m
dbms.memory.pagecache.size = 7680m # 50% of RAM minus the Java heap size.
```

### 1GB configuration (x8)

```properties
dbms.memory.heap.initial_size = 512m
dbms.memory.heap.max_size = 1024m
dbms.memory.pagecache.size = 1024m
```

### 2GB configuration (x16)

```properties
dbms.memory.heap.initial_size = 1024m
dbms.memory.heap.max_size = 2048m
dbms.memory.pagecache.size = 2048m
```

### 4GB configuration (x32)

```properties
dbms.memory.heap.initial_size = 2048m
dbms.memory.heap.max_size = 4096m
dbms.memory.pagecache.size = 4096m
```

### 8GB configuration (x64)

```properties
dbms.memory.heap.initial_size = 4096m
dbms.memory.heap.max_size = 8192m
dbms.memory.pagecache.size = 4096m
```

### xGB + Indexed configuration

```properties
dbms.memory.heap.initial_size = 2048m
dbms.memory.heap.max_size = 4096m
dbms.memory.pagecache.size = 4096m
```

### xGB + Concurrent configuration

```properties
dbms.memory.heap.initial_size = 4096m
dbms.memory.heap.max_size = 8192m
dbms.memory.pagecache.size = 4096m
```

# How to run the benchmarks

-   Go to `https://jdbc.postgresql.org/download/`
-   Download the version under Java 8 (version 42.7.4)
-   Place the JAR file in the `lib` folder of installation `apache-jmeter-5.6.3/lib`

-   Add Jmetter bin to the PATH environment variable

## For each dataset:

1. Open a powershell as administrator
2. `cd folder\where\the\script is`
3. Run
    ```powershell
    .\benchmark_postgres.ps1 -user "Rafael" -dataset "0.3"
    ```
