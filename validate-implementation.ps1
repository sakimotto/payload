# ZerviOS Project Validation and Completion Script
# This script validates the implementation and creates any missing files/directories

$projectRoot = "C:\Users\Archie\Desktop\Projects\ZerviOS"
Write-Host "ZerviOS Project Validation and Completion" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Check and create core directory structure
function EnsureDirectoryExists {
    param (
        [string]$path
    )
    
    if (-not (Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
        Write-Host "Created directory: $path" -ForegroundColor Yellow
        return $true
    }
    return $false
}

# Define all required directories based on our documentation
$directories = @(
    "src/payload/collections",
    "src/payload/globals",
    "src/payload/hooks",
    "src/payload/utilities",
    "src/payload/blocks",
    "src/payload/fields",
    "src/payload/admin",
    "src/payload/seed",
    "src/frontend/components/common",
    "src/frontend/components/layout",
    "src/frontend/pages/api",
    "src/frontend/public",
    "src/frontend/styles",
    "src/frontend/lib",
    "src/frontend/types",
    "infra/docker/mongodb",
    "infra/docker/nginx/conf.d",
    "infra/docker/redis",
    "docs/architecture",
    "docs/setup",
    "docs/compliance",
    "scripts/deployment",
    "scripts/backup",
    "scripts/test"
)

Write-Host "`nStep 1: Validating and creating directory structure..." -ForegroundColor Green
$directoriesCreated = 0
foreach ($dir in $directories) {
    $fullPath = Join-Path -Path $projectRoot -ChildPath $dir
    if (EnsureDirectoryExists $fullPath) {
        $directoriesCreated++
    }
}
Write-Host "Created $directoriesCreated new directories" -ForegroundColor Yellow

# Ensure all our required files exist
Write-Host "`nStep 2: Validating required files..." -ForegroundColor Green

# Define required files and their source/destination paths
$requiredFiles = @(
    @{
        Path = "docker-compose.yml"
        Message = "Main Docker Compose configuration"
    },
    @{
        Path = "docker-compose.prod.yml"
        Message = "Production Docker Compose overrides"
    },
    @{
        Path = ".env.example"
        Source = "env.example"
        Message = "Environment variables template"
    },
    @{
        Path = "src/payload/Dockerfile"
        Message = "Payload CMS Dockerfile"
    },
    @{
        Path = "src/payload/payload.config.ts"
        Message = "Payload CMS configuration"
    },
    @{
        Path = "src/payload/package.json"
        Message = "Payload CMS dependencies"
    },
    @{
        Path = "src/payload/tsconfig.json"
        Message = "Payload CMS TypeScript configuration"
    },
    @{
        Path = "src/payload/collections/Users.ts"
        Message = "Users collection schema"
    },
    @{
        Path = "src/payload/collections/Media.ts"
        Message = "Media collection schema"
    },
    @{
        Path = "src/payload/globals/Settings.ts"
        Message = "Global settings schema"
    },
    @{
        Path = "src/payload/seed/index.ts"
        Message = "Seed data script"
    },
    @{
        Path = "src/frontend/Dockerfile"
        Message = "Frontend Dockerfile"
    },
    @{
        Path = "src/frontend/package.json"
        Message = "Frontend dependencies"
    },
    @{
        Path = "src/frontend/tsconfig.json"
        Message = "Frontend TypeScript configuration"
    },
    @{
        Path = "src/frontend/next.config.js"
        Message = "Next.js configuration"
    },
    @{
        Path = "src/frontend/pages/_app.tsx"
        Message = "Next.js app wrapper"
    },
    @{
        Path = "src/frontend/pages/index.tsx"
        Message = "Next.js homepage"
    },
    @{
        Path = "src/frontend/styles/globals.css"
        Message = "Global CSS styles"
    },
    @{
        Path = "infra/docker/mongodb/init-mongo.js"
        Message = "MongoDB initialization script"
    },
    @{
        Path = "verify.sh"
        Message = "Verification script"
    },
    @{
        Path = "README.md"
        Message = "Project documentation"
    }
)

$missingFiles = @()
foreach ($file in $requiredFiles) {
    $fullPath = Join-Path -Path $projectRoot -ChildPath $file.Path
    
    if (-not (Test-Path $fullPath)) {
        if ($file.ContainsKey('Source')) {
            $sourcePath = Join-Path -Path $projectRoot -ChildPath $file.Source
            if (Test-Path $sourcePath) {
                Copy-Item -Path $sourcePath -Destination $fullPath -Force
                Write-Host "Copied $($file.Source) to $($file.Path)" -ForegroundColor Yellow
            } else {
                $missingFiles += @{ Path = $file.Path; Message = $file.Message }
            }
        } else {
            $missingFiles += @{ Path = $file.Path; Message = $file.Message }
        }
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "`n$($missingFiles.Count) required files are missing:" -ForegroundColor Red
    foreach ($file in $missingFiles) {
        Write-Host "  - $($file.Path) ($($file.Message))" -ForegroundColor Red
    }
} else {
    Write-Host "All required files are present!" -ForegroundColor Green
}

# Copy documentation
Write-Host "`nStep 3: Copying architectural documentation..." -ForegroundColor Green
$docsDir = "$projectRoot\docs\architecture"
EnsureDirectoryExists $docsDir

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

$copiedDocs = 0
foreach ($doc in $documents) {
    $sourcePath = "C:\Users\Archie\Desktop\$doc"
    $destPath = "$docsDir\$doc"
    
    if (Test-Path $sourcePath) {
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "Copied: $doc" -ForegroundColor Green
        $copiedDocs++
    } else {
        Write-Host "Warning: Could not find $doc" -ForegroundColor Yellow
    }
}
Write-Host "Copied $copiedDocs documentation files to $docsDir" -ForegroundColor Yellow

Write-Host "`nValidation and completion process finished!" -ForegroundColor Green
Write-Host "To initialize the project, run: .\initialize-project.ps1" -ForegroundColor Cyan