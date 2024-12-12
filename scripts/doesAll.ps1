param (
    [string]$user,
    [string]$pgPassword,
    [string]$dataset,
    [string]$neo4jDB = "neo4j"
)

if(-not $user) {
    Write-Error "Please provide the windows user as an argument. -user <user>"
    exit 1
}

if (-not $pgPassword) {
    Write-Error "Please provide the PostgreSQL password as an argument. -pgPassword <password>"
    exit 1
}

$validDatasetValues = @("0.3", "1", "3")
if (-not $dataset) {
    Write-Error "Please provide the dataset as an argument."
    exit 1
} elseif ($dataset -notin $validDatasetValues) {
    Write-Error "Invalid dataset. Valid values are: 0.3, 1, 3."
    exit 1
}

# if (-not $neo4jDB) {
#     Write-Error "Please provide the Neo4j DB path as an argument. -neo4jDB <db>"
#     exit 1
# }


Write-Output "-------------------------------------------------------------------------------"

Write-Output "User: $user"

Write-Output "Dataset: $dataset"

$datasetFolder = "ldbc_output_composite_merged-default_$dataset"

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
Copy-Item "../systems/postgreSQL/sql/schema.sql" "C:\temp"
Copy-Item "../systems/postgreSQL/sql/bulkInserts.sql" "C:\temp"
Copy-Item "../systems/postgreSQL/sql/constraints.sql" "C:\temp"
Copy-Item "../systems/postgreSQL/sql/createEdges.sql" "C:\temp"


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

$constraintsTime = Measure-Command {
    psql -U postgres -d test -f "C:/temp/createEdges.sql"
}
Write-Output "createEdges.sql completed in $($constraintsTime.TotalSeconds) seconds."

$analyzeTime = Measure-Command {
    psql -U postgres -d test -c "ANALYZE;"
}
Write-Output "ANALYZE completed in $($analyzeTime.TotalSeconds) seconds."

# #region 4. Configure Neo4j
# Copy-Item "../systems/neo4j/load_data.cypher" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\import"

# Copy-Item "../systems/neo4j/utils/apoc5plus-5.20.0.jar" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\plugins"
# Copy-Item "../systems/neo4j/utils/apoc-5.23.0-extended.jar" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\plugins"
# Copy-Item "../systems/neo4j/utils/graph-data-science-2.9.0.jar" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\plugins"

# Copy-Item "../systems/neo4j/utils/apoc.conf" "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\conf"

# $confFile = "C:\Users\$user\.Neo4jDesktop\relate-data\dbmss\$neo4jDB\conf\neo4j.conf"

# # Read the existing configuration file
# $config = Get-Content -Path $confFile

# # Update or add the properties
# $config = $config -replace '#server.memory.heap.initial_size=.*', 'server.memory.heap.initial_size=4g'
# $config = $config -replace '#server.memory.heap.max_size=.*', 'server.memory.heap.max_size=8g'
# $config = $config -replace '#server.memory.pagecache.size=.*', 'server.memory.pagecache.size=3g'
# $config = $config -replace 'dbms.security.auth_enabled=true', 'dbms.security.auth_enabled=false'
# $config = $config -replace 'server.directories.import=import', '#server.directories.import=import'
# $config = $config -replace 'dbms.security.procedures.unrestricted=jwt.security.*', 'dbms.security.procedures.unrestricted=jwt.security.*,apoc.*,gds.*'

# # Write the updated configuration back to the file
# $config | Set-Content -Path $confFile
# #endregion

Write-Output "-------------------------------------------------------------------------------"
