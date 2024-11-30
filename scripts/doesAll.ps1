param (
    [string]$pgPassword,
    [string]$datasetFolder,
    [string]$outputFile = "output.txt"  # Optional parameter for the output file
)

if (-not $pgPassword) {
    Write-Error "Please provide the PostgreSQL password as an argument."
    exit 1
}

if (-not $datasetFolder) {
    Write-Error "Please provide the dataset folder as an argument."
    exit 1
}

Write-Output "-------------------------------------------------------------------------------"

 # 1. Runs the py scripts
$entitiesTime = Measure-Command {
    python "../python/parseEntities.py" --dataset_folder $datasetFolder
}
Write-Output "Entities scripts completed in $($entitiesTime.TotalSeconds) seconds."

$relationsTime = Measure-Command {
    python "../python/parseRelations.py" --dataset_folder $datasetFolder
}
Write-Output "Relations scripts completed in $($relationsTime.TotalSeconds) seconds."


# # 2. Copies the sql files to "C:\temp" directory
Copy-Item "../systems/postgreSQL/schema.sql" "C:\temp"
Copy-Item "../systems/postgreSQL/bulkInserts.sql" "C:\temp"
Copy-Item "../systems/postgreSQL/constraints.sql" "C:\temp"

# 3. Runs this commands:
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

Write-Output "-------------------------------------------------------------------------------"
