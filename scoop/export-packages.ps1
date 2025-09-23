# Export Scoop Installed Packages
# Creates a backup of currently installed packages

$outputFile = Join-Path $PSScriptRoot "installed-packages.json"

function Write-ColorOutput {
    param($message, $color = "White")
    Write-Host $message -ForegroundColor $color
}

# Check if scoop is installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-ColorOutput "Error: Scoop is not installed!" "Red"
    exit 1
}

Write-ColorOutput "=== Exporting Scoop Packages ===" "Magenta"
Write-ColorOutput ""

# Get installed packages
$installed = scoop list | Select-Object -Skip 1 | ForEach-Object {
    $line = $_.Trim()
    if ($line -and $line -notmatch "^-+$") {
        ($line -split '\s+')[0]
    }
}

# Get buckets
$buckets = scoop bucket list | Select-Object -Skip 1 | ForEach-Object {
    ($_.Trim() -split '\s+')[0]
}

# Create export object
$export = @{
    timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    buckets = $buckets
    packages = $installed
}

# Save to JSON
$export | ConvertTo-Json -Depth 10 | Set-Content $outputFile

Write-ColorOutput "✓ Exported $($installed.Count) packages to: $outputFile" "Green"
Write-ColorOutput ""
Write-ColorOutput "Buckets: $($buckets.Count)" "Cyan"
Write-ColorOutput "Packages: $($installed.Count)" "Cyan"
