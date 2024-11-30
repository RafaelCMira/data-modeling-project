# 1. Runs th py scripts

cd "../python"

python "parseEntities.py"
python "parseRelations.py"

# 2. Copies the sql files to "C:\temp" directory

cd "../systems/postgreSQL"

Copy-Item "schema.sql" "C:\temp"
Copy-Item "bulkInserts.sql" "C:\temp"
Copy-Item "constraints.sql" "C:\temp"

# # 3. Runs this commands:

# $env:PGPASSWORD="your_password"

# $schemaTime = Measure-Command {
#     psql -U postgres -d test -f "C:/temp/schema.sql"
# }
# Write-Output "schema.sql completed in $($schemaTime.TotalSeconds) seconds."

# $bulkInsertsTime = Measure-Command {
#     psql -U postgres -d test -f "C:/temp/bulkInserts.sql"
# }
# Write-Output "bulkInserts.sql completed in $($bulkInsertsTime.TotalSeconds) seconds."

# $constraintsTime = Measure-Command {
#     psql -U postgres -d test -f "C:/temp/constraints.sql"
# }
# Write-Output "constraints.sql completed in $($constraintsTime.TotalSeconds) seconds."

# $analyzeTime = Measure-Command {
#     psql -U postgres -d test -c "ANALYZE;"
# }
# Write-Output "ANALYZE completed in $($analyzeTime.TotalSeconds) seconds."
