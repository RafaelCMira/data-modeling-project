param (
    [string]$user,
    [string]$pgPassword,
    [string]$datasetFolder,
    [string]$neo4jDB,
    [string]$outputFile = "output.txt"  # Optional parameter for the output file
)

if(-not $user) {
    Write-Error "Please provide the windows user as an argument. -user <user>"
    exit 1
}

if (-not $pgPassword) {
    Write-Error "Please provide the PostgreSQL password as an argument. -pgPassword <password>"
    exit 1
}

if (-not $datasetFolder) {
    Write-Error "Please provide the dataset folder as an argument.  -datasetFolder <folder>"
    exit 1
}

if (-not $neo4jDB) {
    Write-Error "Please provide the Neo4j DB path as an argument. -neo4jDB <db>"
    exit 1
}


Write-Output "-------------------------------------------------------------------------------"

Write-Output "$datasetFolder"

 # 1. Runs the py scripts
$entitiesTime = Measure-Command {
    python "../python/parseEntities.py" --dataset_folder $datasetFolder 
}
Write-Output "Entities scripts completed in $($entitiesTime.TotalSeconds) seconds."

$relationsTime = Measure-Command {
    python "../python/parseRelations.py" --dataset_folder $datasetFolder 
}
Write-Output "Relations scripts completed in $($relationsTime.TotalSeconds) seconds."


# 2. Copies the sql files to "C:\temp" directory
Copy-Item "../systems/postgreSQL/schema.sql" "C:\temp"
Copy-Item "../systems/postgreSQL/bulkInserts.sql" "C:\temp"
Copy-Item "../systems/postgreSQL/constraints.sql" "C:\temp"

# 3. Inserts the data into PostgreSQL:
$env:PGPASSWORD=$pgPassword

$schemaTime = Measure-Command {
    psql -U postgres -d test -f "C:/temp/schema.sql"
}
Write-Output "schema.sql completed in $($schemaTime.TotalSeconds) seconds."

$bulkInsertsTime = Measure-Command {
    psql -U postgres -d test -f "C:/temp/bulkInserts.sql"
}
Write-Output "bulkInserts.sql completed in $($bulkInsertsTime.TotalSeconds) seconds."

$constraintsTime = Measure-Command {
    psql -U postgres -d test -f "C:/temp/constraints.sql"
}
Write-Output "constraints.sql completed in $($constraintsTime.TotalSeconds) seconds."

$analyzeTime = Measure-Command {
    psql -U postgres -d test -c "ANALYZE;"
}
Write-Output "ANALYZE completed in $($analyzeTime.TotalSeconds) seconds."

# 4. Configure Neo4j
Copy-Item "../systems/neo4j/load_data.cypher" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\import"

Copy-Item "../systems/neo4j/utils/apoc5plus-5.20.0.jar" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\plugins"
Copy-Item "../systems/neo4j/utils/apoc-5.23.0-extended.jar" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\plugins"

Copy-Item "../systems/neo4j/utils/apoc.conf" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\conf"

$confFile = "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\conf\neo4j.conf"

# Read the existing configuration file
$config = Get-Content -Path $confFile

# Update or add the properties
$config = $config -replace '#server.memory.heap.initial_size=.*', 'server.memory.heap.initial_size=6g'
$config = $config -replace '#server.memory.heap.max_size=.*', 'server.memory.heap.max_size=6g'
$config = $config -replace '#server.memory.pagecache.size=.*', 'server.memory.pagecache.size=4g'
$config = $config -replace 'dbms.security.auth_enabled=true', 'dbms.security.auth_enabled=false'
$config = $config -replace 'server.directories.import=import', '#server.directories.import=import'
$config = $config -replace 'dbms.security.procedures.unrestricted=jwt.security.*', 'dbms.security.procedures.unrestricted=jwt.security.*,apoc.*'

# Write the updated configuration back to the file
$config | Set-Content -Path $confFile


Write-Output "-------------------------------------------------------------------------------"
