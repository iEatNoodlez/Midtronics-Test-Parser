# PowerShell script to split Midtronics CSV files by battery strings and save in a dated subfolder

# Prompt user to drag and drop the CSV file into the console window
$csvFile = Read-Host "Please drag and drop the CSV file here"

# Remove potential quotes around the file path
$csvFile = $csvFile -replace '"', ''

# Check if file exists
if (-not (Test-Path -Path $csvFile)) {
    Write-Host "File not found. Please ensure the path is correct."
    exit
}

# Get the current date and time in the format yyyy-MM-dd_HH-mm-ss
$currentDateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Create a subfolder in the script directory with the current date and time
$outputFolder = Join-Path -Path $PSScriptRoot -ChildPath $currentDateTime
New-Item -Path $outputFolder -ItemType Directory -Force

# Function to write CSV file for each unique string
function Write-StringCsv {
    param (
        [string]$site,
        [string]$plant,
        [string]$string,
        [array]$data,
        [string]$header
    )

    $fileName = "$site - $plant - $string.csv"
    $outputFilePath = Join-Path -Path $outputFolder -ChildPath $fileName
    
    # Write schema header first
    Out-File -FilePath $outputFilePath -InputObject $header -Encoding UTF8 -Force
    
    # Append the data for the specific string
    foreach ($line in $data) {
        Add-Content -Path $outputFilePath -Value $line
    }
}

# Read the entire CSV file
$csvContent = Get-Content -Path $csvFile

# Extract the schema (first line)
$schema = $csvContent[0]

# Initialize a hashtable to store battery data by strings
$stringsData = @{}

# Loop through the CSV data starting from the second line
for ($i = 1; $i -lt $csvContent.Length; $i++) {
    $line = $csvContent[$i]
    $fields = $line -split ','

    # Check if fields are available and assign 'UNKNOWN' if missing
    $site = if ($fields[0]) { $fields[0].Trim() } else { 'UNKNOWN' }
    $plant = if ($fields[1]) { $fields[1].Trim() } else { 'UNKNOWN' }
    $string = if ($fields[2]) { $fields[2].Trim() } else { 'UNKNOWN' }

    # Use a unique key combining Site, Plant, and String
    $key = "$site|$plant|$string"

    # Store each row under the corresponding string
    if (-not $stringsData.ContainsKey($key)) {
        $stringsData[$key] = @()
    }
    
    $stringsData[$key] += $line
}

# Write each string data to separate CSV files in the output folder
foreach ($key in $stringsData.Keys) {
    $parts = $key -split '\|'
    $site = $parts[0]
    $plant = $parts[1]
    $string = $parts[2]
    
    Write-StringCsv -site $site -plant $plant -string $string -data $stringsData[$key] -header $schema
}

Write-Host "Files have been created successfully in the folder: $outputFolder"
