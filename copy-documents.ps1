# ZerviOS Document Copy Script
# This script copies the architectural documents to the project's docs directory

$projectRoot = "C:\Users\Archie\Desktop\Projects\ZerviOS"
$docsDir = "$projectRoot\docs\architecture"
$desktopDir = "C:\Users\Archie\Desktop"

Write-Host "Copying ZerviOS Project Documents" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Create docs directory if it doesn't exist
if (-not (Test-Path $docsDir)) {
    New-Item -Path $docsDir -ItemType Directory -Force | Out-Null
    Write-Host "Created docs directory: $docsDir" -ForegroundColor Yellow
}

# List of documents to copy
$documents = @(
    "ZerviOS-Project-Plan.md",
    "ZerviOS-Docker-Architecture.md",
    "ZerviOS-Environment-Variables.md",
    "ZerviOS-Docker-Compose.md",
    "ZerviOS-Payload-CMS-Configuration.md",
    "ZerviOS-Verification-Tests.md",
    "ZerviOS-Directory-Structure.md",
    "ZerviOS-Implementation-Plan.md"
)

# Copy each document
foreach ($doc in $documents) {
    $sourcePath = "$desktopDir\$doc"
    $destPath = "$docsDir\$doc"
    
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "Copied: $doc" -ForegroundColor Green
    } else {
        Write-Host "Warning: Could not find $doc" -ForegroundColor Yellow
    }
}

Write-Host "`nDocument copy complete!" -ForegroundColor Green
Write-Host "All architecture documents have been copied to: $docsDir" -ForegroundColor Cyan