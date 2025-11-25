# Scoop Package Installation Script
# Installs essential development tools and utilities

param(
    [string]$Category = "all",
    [switch]$DryRun
)

$packagesFile = Join-Path $PSScriptRoot "packages.json"
$packages = Get-Content $packagesFile | ConvertFrom-Json

function Write-ColorOutput {
    param($message, $color = "White")
    Write-Host $message -ForegroundColor $color
}

function Install-Package {
    param($packageName)

    if ($DryRun) {
        Write-ColorOutput "  [DRY RUN] Would install: $packageName" "Yellow"
        return
    }

    Write-ColorOutput "  Installing: $packageName" "Cyan"
    scoop install $packageName

    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "  [OK] Installed: $packageName" "Green"
    } else {
        Write-ColorOutput "  [FAIL] Failed: $packageName" "Red"
    }
}

function Add-Bucket {
    param($bucketName)

    if ($DryRun) {
        Write-ColorOutput "[DRY RUN] Would add bucket: $bucketName" "Yellow"
        return
    }

    Write-ColorOutput "Adding bucket: $bucketName" "Cyan"
    scoop bucket add $bucketName
}

# Check if scoop is installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-ColorOutput "Error: Scoop is not installed!" "Red"
    Write-ColorOutput "Install Scoop first: https://scoop.sh" "Yellow"
    exit 1
}

Write-ColorOutput "=== Scoop Package Installation ===" "Magenta"
Write-ColorOutput ""

# Add buckets
Write-ColorOutput "Adding buckets..." "Green"
foreach ($bucket in $packages.buckets) {
    Add-Bucket $bucket
}
Write-ColorOutput ""

# Install packages based on category
if ($Category -eq "all") {
    foreach ($cat in $packages.packages.PSObject.Properties) {
        Write-ColorOutput "Installing $($cat.Name) packages..." "Green"
        foreach ($package in $cat.Value) {
            Install-Package $package
        }
        Write-ColorOutput ""
    }
} else {
    if ($packages.packages.PSObject.Properties.Name -contains $Category) {
        Write-ColorOutput "Installing $Category packages..." "Green"
        foreach ($package in $packages.packages.$Category) {
            Install-Package $package
        }
    } else {
        Write-ColorOutput "Error: Category '$Category' not found!" "Red"
        Write-ColorOutput "Available categories: $($packages.packages.PSObject.Properties.Name -join ', ')" "Yellow"
        exit 1
    }
}

Write-ColorOutput ""
Write-ColorOutput "=== Installation Complete ===" "Magenta"
Write-ColorOutput ""
Write-ColorOutput "Run 'scoop status' to check for updates." "Cyan"
