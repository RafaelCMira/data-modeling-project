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

$OutputDir = "../postgreSQL/results/$user/dataset $dataset/default.csv"


$FullOutputDir = Resolve-Path -Path $OutputDir

# Default PostgreSQL configuration Benchmark
$originalFilePath = "C:\Program Files\PostgreSQL\17\data\postgresql.conf"
$replacementFilePath = "./configs/postgresql_default_config.conf"

Copy-Item -Path $replacementFilePath -Destination $originalFilePath -Force

# Restart the PostgreSQL service
Restart-Service -Name "postgresql-x64-17"

# Run Jmeter
jmeter -n -t "../../inputs/dataset 0.3/jmetter_postgres_0.3GB.jmx" -l "report.csv"
