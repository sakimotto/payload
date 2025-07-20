# ZerviOS Project Structure Creation Script
# This script creates the directory structure and placeholder files for the ZerviOS project

# Root directory
$root = "C:\Users\Archie\Desktop\Projects\ZerviOS"

# Create directories
$dirs = @(
    "src\payload\collections",
    "src\payload\globals",
    "src\payload\hooks",
    "src\payload\utilities",
    "src\payload\blocks",
    "src\payload\fields",
    "src\payload\admin",
    "src\payload\seed",
    "src\frontend\components\common",
    "src\frontend\components\layout",
    "src\frontend\pages\api",
    "src\frontend\public",
    "src\frontend\styles",
    "src\frontend\lib",
    "src\frontend\types",
    "infra\docker\mongodb",
    "infra\docker\nginx\conf.d",
    "infra\docker\redis",
    "docs\architecture",
    "docs\setup",
    "docs\compliance",
    "scripts\deployment",
    "scripts\backup",
    "scripts\test"
)

Write-Host "Creating directory structure..."
foreach ($dir in $dirs) {
    $path = Join-Path -Path $root -ChildPath $dir
    if (-not (Test-Path -Path $path)) {
        New-Item -Path $path -ItemType Directory -Force
        Write-Host "Created: $path"
    } else {
        Write-Host "Already exists: $path"
    }
}

Write-Host "Directory structure created successfully!"