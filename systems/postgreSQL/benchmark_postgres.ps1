param (
    [string]$user,
    [string]$dataset
)

$validUserValues = @("Rafael", "josec")
if(-not $user) {
    Write-Error "Please provide the windows user as an argument. -user <user>"
    exit 1
} elseif ($user -notin $validUserValues) {
    Write-Error "Invalid user. Valid values are: Rafael, josec."
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

if($user -eq "Rafael") {
    $user = "rafael"
} else {
    $user = "jose"
}

$OutputDir = "../../csv_results/$user/postgres/dataset $dataset" 

# -------------------- Default PostgreSQL configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "default.csv"

$originalFilePath = "C:\Program Files\PostgreSQL\17\data\postgresql.conf"
$replacementFilePath = "./configs/postgresql_default_config.conf"

Copy-Item -Path $replacementFilePath -Destination $originalFilePath -Force

# Restart the PostgreSQL service
Restart-Service -Name "postgresql-x64-17"

Start-Sleep -Seconds 3

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_postgres_$dataset.jmx" -l $FullOutputDir


# -------------------- 1GB PostgreSQL configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "1GB.csv"

$replacementFilePath = "./configs/postgresql_1GB_config.conf"

Copy-Item -Path $replacementFilePath -Destination $originalFilePath -Force

# Restart the PostgreSQL service
Restart-Service -Name "postgresql-x64-17"

Start-Sleep -Seconds 3

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_postgres_$dataset.jmx" -l $FullOutputDir


# -------------------- 2GB PostgreSQL configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "2GB.csv"

$replacementFilePath = "./configs/postgresql_2GB_config.conf"

Copy-Item -Path $replacementFilePath -Destination $originalFilePath -Force

# Restart the PostgreSQL service
Restart-Service -Name "postgresql-x64-17"

Start-Sleep -Seconds 3

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_postgres_$dataset.jmx" -l $FullOutputDir


# -------------------- 4GB PostgreSQL configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "4GB.csv"

$replacementFilePath = "./configs/postgresql_4GB_config.conf"

Copy-Item -Path $replacementFilePath -Destination $originalFilePath -Force

# Restart the PostgreSQL service
Restart-Service -Name "postgresql-x64-17"

Start-Sleep -Seconds 3

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_postgres_$dataset.jmx" -l $FullOutputDir



# -------------------- 8GB PostgreSQL configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "8GB.csv"

$replacementFilePath = "./configs/postgresql_8GB_config.conf"

Copy-Item -Path $replacementFilePath -Destination $originalFilePath -Force

# Restart the PostgreSQL service
Restart-Service -Name "postgresql-x64-17"

Start-Sleep -Seconds 3

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_postgres_$dataset.jmx" -l $FullOutputDir