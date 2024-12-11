param (
    [float]$sf
)

# Validate the sf
$validScaleFactors = @(0.3, 1, 3)
if (-not $sf) {
    Write-Error "Please provide the sf as an argument."
    exit 1
} elseif ($sf -notin $validScaleFactors) {
    Write-Error "Invalid sf. Valid values are: 0.3, 1, 3."
    exit 1
}

# Determine the output directory based on the ScaleFactor
switch ($sf) {
    0.3 { $OutputDir = "C:\ldbc_output_composite_merged-default_0_3" }
    1 { $OutputDir = "C:\ldbc_output_composite_merged-default_1" }
    3 { $OutputDir = "C:\ldbc_output_composite_merged-default_3" }
    default {
        Write-Error "Invalid sf. Valid values are: 0.3, 1, 3."
        exit 1
    }
}

$Parallelism = 1

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Directory
}

$executionTime = Measure-Command {
    docker run `
    --rm `
    -v "${OutputDir}:/out" `
    -e "SPARK_CONF_DIR=/conf" `
    ldbc/datagen-standalone:latest `
    "--parallelism=$Parallelism" `
    -- `
    "--format=csv" `
    "--scale-factor=$sf" `
    "--mode=bi" `
    "--output-dir=/out"
}

Write-Output "Data generation completed in $($executionTime.TotalSeconds) seconds."