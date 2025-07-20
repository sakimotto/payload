# ZerviOS Project Initialization Script
# This script sets up the complete ZerviOS project structure and prepares it for Docker deployment

$projectRoot = "C:\Users\Archie\Desktop\Projects\ZerviOS"
Write-Host "ZerviOS Project Initialization" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# Step 1: Execute the directory structure creation script
Write-Host "`nStep 1: Creating directory structure..." -ForegroundColor Green
& "$projectRoot\create-structure.ps1"

# Step 2: Copy architectural documents to the project
Write-Host "`nStep 2: Copying architectural documents..." -ForegroundColor Green
& "$projectRoot\copy-documents.ps1"

# Step 3: Rename env.example to .env.example and create .env
Write-Host "`nStep 3: Setting up environment files..." -ForegroundColor Green
if (Test-Path "$projectRoot\env.example") {
    Move-Item -Path "$projectRoot\env.example" -Destination "$projectRoot\.env.example" -Force
    Write-Host "  - Renamed env.example to .env.example" -ForegroundColor Yellow
    
    # Create .env from .env.example
    Copy-Item -Path "$projectRoot\.env.example" -Destination "$projectRoot\.env" -Force
    Write-Host "  - Created .env from .env.example" -ForegroundColor Yellow
} else {
    Write-Host "  - env.example not found, skipping" -ForegroundColor Red
}

# Step 4: Give execute permission to verify.sh on Unix-like systems (if using WSL or similar)
Write-Host "`nStep 4: Setting permissions for verification script..." -ForegroundColor Green
if (Get-Command "chmod" -ErrorAction SilentlyContinue) {
    chmod +x "$projectRoot\verify.sh"
    Write-Host "  - Set execute permissions on verify.sh" -ForegroundColor Yellow
} else {
    Write-Host "  - chmod command not available, skipping permissions setting" -ForegroundColor Yellow
    Write-Host "  - If using bash/WSL later, run: chmod +x verify.sh" -ForegroundColor Yellow
}

# Step 5: Set up Git repository (optional)
Write-Host "`nStep 5: Initializing Git repository..." -ForegroundColor Green
if (Get-Command "git" -ErrorAction SilentlyContinue) {
    Set-Location $projectRoot
    git init
    Write-Host "  - Git repository initialized" -ForegroundColor Yellow
} else {
    Write-Host "  - Git command not available, skipping repository initialization" -ForegroundColor Yellow
}

# Step 6: Provide instructions for starting Docker containers
Write-Host "`nSetup Complete!" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host "`nTo start the ZerviOS containers, run:" -ForegroundColor Cyan
Write-Host "  cd $projectRoot" -ForegroundColor White
Write-Host "  docker-compose up -d" -ForegroundColor White

Write-Host "`nTo verify the setup, run:" -ForegroundColor Cyan
Write-Host "  .\verify.sh  # Using bash/WSL" -ForegroundColor White
Write-Host "  or check these URLs in your browser:" -ForegroundColor White
Write-Host "  - Payload CMS Admin: http://localhost:3000/admin" -ForegroundColor White
Write-Host "  - Frontend: http://localhost:3001" -ForegroundColor White

Write-Host "`nDefault admin credentials:" -ForegroundColor Cyan
Write-Host "  Email: admin@zervios.com" -ForegroundColor White
Write-Host "  Password: password123 (change this in production!)" -ForegroundColor White

Write-Host "`nArchitectural documentation can be found in:" -ForegroundColor Cyan
Write-Host "  $projectRoot\docs\architecture\" -ForegroundColor White

Write-Host "`nFor more information, see README.md" -ForegroundColor Cyan