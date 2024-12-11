param (
    [string]$user,
    [string]$dataset,
    [string]$neo4jDb
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

if(-not $neo4jDb) {
    Write-Error "Please provide the neo4j database as an argument."
    exit 1
}


$userWindows = $user
if($user -eq "Rafael") {
    $user = "rafael"
} else {
    $user = "jose"
}

$OutputDir = "../../csv_results/$user/neo4j/dataset $dataset" 

# -------------------- Neo4j Default configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "default.csv"

$confFile= "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\conf\neo4j.conf"

$config = Get-Content -Path $confFile

$config = $config -replace 'server.memory.heap.initial_size=.*', 'server.memory.heap.initial_size=512m'
$config = $config -replace 'server.memory.heap.max_size=.*', 'server.memory.heap.max_size=512m'
$config = $config -replace 'server.memory.pagecache.size=.*', '#server.memory.pagecache.size='

$config | Set-Content -Path $confFile

# Start the Neo4j application and capture the pid
$neo4jBin = "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\bin"

# Start the Neo4j console in a new terminal and capture the process
$neo4jProcess = Start-Process -FilePath "cmd.exe" `
                             -ArgumentList "/c cd /d `"$neo4jBin`" && .\neo4j console" `
                             -NoNewWindow:$false `
                             -PassThru

if ($neo4jProcess -ne $null) {
    Write-Output "Neo4j process started with PID: $($neo4jProcess.Id)"
} else {
    Write-Error "Failed to start the Neo4j console."
    exit 1
}

$neo4jPid = $neo4jProcess.Id

Start-Sleep -Seconds 40

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_neo4j_$dataset.jmx" -l $FullOutputDir  `
    -Jcsv1="../../inputs/dataset $dataset/1.csv" `
    -Jcsv2="../../inputs/dataset $dataset/2.csv" `
    -Jcsv3="../../inputs/dataset $dataset/3.csv" `
    -Jcsv4="../../inputs/dataset $dataset/4 neo4j.csv" `
    -Jcsv5="../../inputs/dataset $dataset/5.csv" `
    -Jcsv6="../../inputs/dataset $dataset/6.csv" `
    -Jcsv7="../../inputs/dataset $dataset/7.csv" `
    -Jcsv8="../../inputs/dataset $dataset/8.csv" `
    -Jcsv9="../../inputs/dataset $dataset/9.csv" `
    -Jcsv10="../../inputs/dataset $dataset/10.csv"

# Find and terminate all child processes of the Neo4j cmd process
$childProcesses = Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $neo4jPid }
foreach ($child in $childProcesses) {
    Stop-Process -Id $child.ProcessId -Force
}

Stop-Process -Id $neo4jPid -Force

Get-Process -Name java -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.Id -Force }


Start-Sleep -Seconds 40



# -------------------- Neo4j 1GB configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "1GB.csv"

$confFile= "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\conf\neo4j.conf"

$config = Get-Content -Path $confFile

$config = $config -replace 'server.memory.heap.initial_size=.*', 'server.memory.heap.initial_size=512m'
$config = $config -replace 'server.memory.heap.max_size=.*', 'server.memory.heap.max_size=1024m'
$config = $config -replace '#server.memory.pagecache.size=.*', 'server.memory.pagecache.size=1024m'

$config | Set-Content -Path $confFile

# Start the Neo4j application and capture the pid
$neo4jBin = "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\bin"

# Start the Neo4j console in a new terminal and capture the process
$neo4jProcess = Start-Process -FilePath "cmd.exe" `
                             -ArgumentList "/c cd /d `"$neo4jBin`" && .\neo4j console" `
                             -NoNewWindow:$false `
                             -PassThru

if ($neo4jProcess -ne $null) {
    Write-Output "Neo4j process started with PID: $($neo4jProcess.Id)"
} else {
    Write-Error "Failed to start the Neo4j console."
    exit 1
}

$neo4jPid = $neo4jProcess.Id

Start-Sleep -Seconds 40

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_neo4j_$dataset.jmx" -l $FullOutputDir  `
    -Jcsv1="../../inputs/dataset $dataset/1.csv" `
    -Jcsv2="../../inputs/dataset $dataset/2.csv" `
    -Jcsv3="../../inputs/dataset $dataset/3.csv" `
    -Jcsv4="../../inputs/dataset $dataset/4 neo4j.csv" `
    -Jcsv5="../../inputs/dataset $dataset/5.csv" `
    -Jcsv6="../../inputs/dataset $dataset/6.csv" `
    -Jcsv7="../../inputs/dataset $dataset/7.csv" `
    -Jcsv8="../../inputs/dataset $dataset/8.csv" `
    -Jcsv9="../../inputs/dataset $dataset/9.csv" `
    -Jcsv10="../../inputs/dataset $dataset/10.csv"

# Find and terminate all child processes of the Neo4j cmd process
$childProcesses = Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $neo4jPid }
foreach ($child in $childProcesses) {
    Stop-Process -Id $child.ProcessId -Force
}

Stop-Process -Id $neo4jPid -Force

Get-Process -Name java -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.Id -Force }

Start-Sleep -Seconds 40



# -------------------- Neo4j 2GB configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "2GB.csv"

$confFile= "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\conf\neo4j.conf"

$config = Get-Content -Path $confFile

$config = $config -replace 'server.memory.heap.initial_size=.*', 'server.memory.heap.initial_size=1024m'
$config = $config -replace 'server.memory.heap.max_size=.*', 'server.memory.heap.max_size=2048m'
$config = $config -replace 'server.memory.pagecache.size=.*', 'server.memory.pagecache.size=2048m'

$config | Set-Content -Path $confFile

# Start the Neo4j application and capture the pid
$neo4jBin = "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\bin"

# Start the Neo4j console in a new terminal and capture the process
$neo4jProcess = Start-Process -FilePath "cmd.exe" `
                             -ArgumentList "/c cd /d `"$neo4jBin`" && .\neo4j console" `
                             -NoNewWindow:$false `
                             -PassThru

if ($neo4jProcess -ne $null) {
    Write-Output "Neo4j process started with PID: $($neo4jProcess.Id)"
} else {
    Write-Error "Failed to start the Neo4j console."
    exit 1
}

$neo4jPid = $neo4jProcess.Id

Start-Sleep -Seconds 40

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_neo4j_$dataset.jmx" -l $FullOutputDir  `
    -Jcsv1="../../inputs/dataset $dataset/1.csv" `
    -Jcsv2="../../inputs/dataset $dataset/2.csv" `
    -Jcsv3="../../inputs/dataset $dataset/3.csv" `
    -Jcsv4="../../inputs/dataset $dataset/4 neo4j.csv" `
    -Jcsv5="../../inputs/dataset $dataset/5.csv" `
    -Jcsv6="../../inputs/dataset $dataset/6.csv" `
    -Jcsv7="../../inputs/dataset $dataset/7.csv" `
    -Jcsv8="../../inputs/dataset $dataset/8.csv" `
    -Jcsv9="../../inputs/dataset $dataset/9.csv" `
    -Jcsv10="../../inputs/dataset $dataset/10.csv"

# Find and terminate all child processes of the Neo4j cmd process
$childProcesses = Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $neo4jPid }
foreach ($child in $childProcesses) {
    Stop-Process -Id $child.ProcessId -Force
}

Stop-Process -Id $neo4jPid -Force

Get-Process -Name java -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.Id -Force }

Start-Sleep -Seconds 40



# -------------------- Neo4j 4GB configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "4GB.csv"

$confFile= "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\conf\neo4j.conf"

$config = Get-Content -Path $confFile

$config = $config -replace 'server.memory.heap.initial_size=.*', 'server.memory.heap.initial_size=2048m'
$config = $config -replace 'server.memory.heap.max_size=.*', 'server.memory.heap.max_size=4096m'
$config = $config -replace 'server.memory.pagecache.size=.*', 'server.memory.pagecache.size=4096m'

$config | Set-Content -Path $confFile

# Start the Neo4j application and capture the pid
$neo4jBin = "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\bin"

# Start the Neo4j console in a new terminal and capture the process
$neo4jProcess = Start-Process -FilePath "cmd.exe" `
                             -ArgumentList "/c cd /d `"$neo4jBin`" && .\neo4j console" `
                             -NoNewWindow:$false `
                             -PassThru

if ($neo4jProcess -ne $null) {
    Write-Output "Neo4j process started with PID: $($neo4jProcess.Id)"
} else {
    Write-Error "Failed to start the Neo4j console."
    exit 1
}

$neo4jPid = $neo4jProcess.Id

Start-Sleep -Seconds 40

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_neo4j_$dataset.jmx" -l $FullOutputDir  `
    -Jcsv1="../../inputs/dataset $dataset/1.csv" `
    -Jcsv2="../../inputs/dataset $dataset/2.csv" `
    -Jcsv3="../../inputs/dataset $dataset/3.csv" `
    -Jcsv4="../../inputs/dataset $dataset/4 neo4j.csv" `
    -Jcsv5="../../inputs/dataset $dataset/5.csv" `
    -Jcsv6="../../inputs/dataset $dataset/6.csv" `
    -Jcsv7="../../inputs/dataset $dataset/7.csv" `
    -Jcsv8="../../inputs/dataset $dataset/8.csv" `
    -Jcsv9="../../inputs/dataset $dataset/9.csv" `
    -Jcsv10="../../inputs/dataset $dataset/10.csv"

# Find and terminate all child processes of the Neo4j cmd process
$childProcesses = Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $neo4jPid }
foreach ($child in $childProcesses) {
    Stop-Process -Id $child.ProcessId -Force
}

Stop-Process -Id $neo4jPid -Force

Get-Process -Name java -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.Id -Force }

Start-Sleep -Seconds 40



# -------------------- Neo4j 8GB configuration Benchmark --------------------
$FullOutputDir = Resolve-Path -Path $OutputDir
$FullOutputDir = Join-Path -Path $FullOutputDir.Path -ChildPath "8GB.csv"

$confFile= "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\conf\neo4j.conf"

$config = Get-Content -Path $confFile

$config = $config -replace 'server.memory.heap.initial_size=.*', 'server.memory.heap.initial_size=4096m'
$config = $config -replace 'server.memory.heap.max_size=.*', 'server.memory.heap.max_size=8192m'
$config = $config -replace 'server.memory.pagecache.size=.*', 'server.memory.pagecache.size=4096m'

$config | Set-Content -Path $confFile

# Start the Neo4j application and capture the pid
$neo4jBin = "C:\Users\$userWindows\.Neo4jDesktop\relate-data\dbmss\$neo4jDb\bin"

# Start the Neo4j console in a new terminal and capture the process
$neo4jProcess = Start-Process -FilePath "cmd.exe" `
                             -ArgumentList "/c cd /d `"$neo4jBin`" && .\neo4j console" `
                             -NoNewWindow:$false `
                             -PassThru

if ($neo4jProcess -ne $null) {
    Write-Output "Neo4j process started with PID: $($neo4jProcess.Id)"
} else {
    Write-Error "Failed to start the Neo4j console."
    exit 1
}

$neo4jPid = $neo4jProcess.Id

Start-Sleep -Seconds 40

# Run Jmeter
jmeter -n -t "../../inputs/dataset $dataset/jmetter_neo4j_$dataset.jmx" -l $FullOutputDir  `
    -Jcsv1="../../inputs/dataset $dataset/1.csv" `
    -Jcsv2="../../inputs/dataset $dataset/2.csv" `
    -Jcsv3="../../inputs/dataset $dataset/3.csv" `
    -Jcsv4="../../inputs/dataset $dataset/4 neo4j.csv" `
    -Jcsv5="../../inputs/dataset $dataset/5.csv" `
    -Jcsv6="../../inputs/dataset $dataset/6.csv" `
    -Jcsv7="../../inputs/dataset $dataset/7.csv" `
    -Jcsv8="../../inputs/dataset $dataset/8.csv" `
    -Jcsv9="../../inputs/dataset $dataset/9.csv" `
    -Jcsv10="../../inputs/dataset $dataset/10.csv"
    
# Find and terminate all child processes of the Neo4j cmd process
$childProcesses = Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $neo4jPid }
foreach ($child in $childProcesses) {
    Stop-Process -Id $child.ProcessId -Force
}

Stop-Process -Id $neo4jPid -Force

Get-Process -Name java -ErrorAction SilentlyContinue | ForEach-Object { Stop-Process -Id $_.Id -Force }

Start-Sleep -Seconds 40