$OutputDir = "C:\ldbc_output_composite_merged-default_1"
# Define the scale factor for the dataset size (0.003 is a very small dataset)
$ScaleFactor = 1
$Parallelism = 1

# Create the output directory if it doesn't exist
if (!(Test-Path -Path $OutputDir)) {
    New-Item -Path $OutputDir -ItemType Director
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
    "--scale-factor=$ScaleFactor" `
    "--mode=bi" `
    "--output-dir=/out"
}

Write-Output "Data generation completed in $($executionTime.TotalSeconds) seconds."
