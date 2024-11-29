$OutputDir = "C:\ldbc_output_composite_merged-default_10"
$SparkConfDir = "C:\spark_conf"
# Define the scale factor for the dataset size (0.003 is a very small dataset)
$ScaleFactor = 10
$Parallelism = 1

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Director
}

# Create the Spark configuration directory if it doesn't exist
if (!(Test-Path -Path $SparkConfDir)) {
    New-Item -Path $SparkConfDir -ItemType Directory
}

# Create the spark-defaults.conf file with increased memory settings
$sparkDefaultsConf = @"
spark.driver.memory 12g
spark.executor.memory 12g
spark.executor.extraJavaOptions -XX:+UseG1GC
spark.driver.extraJavaOptions -XX:+UseG1GC
spark.sql.files.maxPartitionBytes 32m
spark.local.dir=/tmp/spark-temp
"@
$sparkDefaultsConf | Out-File -FilePath "$SparkConfDir\spark-defaults.conf" -Encoding utf8

$executionTime = Measure-Command {
    docker run `
    --rm `
    --memory="14g" `
    --cpus="8" `
    -v "${OutputDir}:/out" `
    -v "${SparkConfDir}:/conf" `
    -e "SPARK_CONF_DIR=/conf" `
    ldbc/datagen-standalone:latest `
    "--parallelism=$Parallelism" `
    -- `
    "--format=csv" `
    "--scale-factor=$ScaleFactor" `
    "--mode=bi" `
    "--output-dir=/out"
}

Write-Output "Data generation completed in $($executionTime.TotalSeconds) seconds."

# 1 ScaleFactor = 1, parallelism = 1, docker memory = 10G, cpus = 8, spark.driver.memory 5g, spark.executor.memory 5g, .wslconfig = 6gb and 4 processors -> 

# 3 ScaleFactor = 3, parallelism = 1, docker memory = 11G, cpus = 8, spark.driver.memory 10g, spark.executor.memory 10g -> 438 seconds

# 1 ScaleFactor = 1, parallelism = 1, docker memory = 11G, cpus = 8, spark.driver.memory 10g, spark.executor.memory 10g -> 278.2516788 seconds.


# 10 ScaleFactor = 10, parallelism = 1, docker memory = 13G, cpus = 10, spark.driver.memory 12g, spark.executor.memory 12g -> CRASH


# 3.4 ScaleFactor = 3, parallelism = 4, docker memory = 11G, cpus = 8, spark.driver.memory 10g, spark.executor.memory 10g -> CRASH

# ScaleFactor = 3, parallelism = 1, docker memory = 11G, cpus = 8, spark.driver.memory 10g, spark.executor.memory 10g -> 404.0006386 seconds.

# ScaleFactor = 3, parallelism = 1, docker memory = 10G, cpus = 8, spark.driver.memory 5g, spark.executor.memory 5g -> 417.330887 seconds.

# ScaleFactor = 1, parallelism = 1, docker memory = 10G, cpus = 6, spark.driver.memory 5g, spark.executor.memory 5g -> 238.2457566 seconds.

# ScaleFactor = 3, parallelism = 1, docker memory = 8G, cpus = 6 -> 429.6153154 seconds.

# ScaleFactor = 1, parallelism = 1, docker memory = 8G, cpus = 6 -> 262.7498756 seconds.

# ScaleFactor = 3, parallelism = 1, docker memory = 4G -> 270.9071299 seconds.

# ScaleFactor = 1, parallelism = 1, docker memory = 4G -> 270.9071299 seconds.

# ScaleFactor = 0.003, parallelism = 1 -> 86.8392037 seconds. (gera um composite-merge-fk)

# ScaleFactor = 0.003, parallelism = 1, explode-edges -> 142.8895393 seconds. (gera um composite-projected-fk)

# ScaleFactor = 0.003, parallelism = 1, explode-attrs -> 90.0769607 seconds. (gera um singular-merged-fk)

# ScaleFactor = 0.003, parallelism = 1, explode-attrs, explode-edges -> 144.4296018 seconds.  (gera um singular-projected-fk)