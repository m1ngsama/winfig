# Winfig Uninstall Script
# Removes winfig configurations and restores backups

param(
    [switch]$RemoveModules,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-ColorOutput {
    param($message, $color = "White")
    Write-Host $message -ForegroundColor $color
}

function Write-Section {
    param($title)
    Write-ColorOutput "`n=== $title ===" "Magenta"
}

function Remove-ConfigFile {
    param($path, $description)

    if (Test-Path $path) {
        if ($Force) {
            Remove-Item $path -Force
            Write-ColorOutput "  ✓ Removed: $description" "Green"
        } else {
            $backup = "$path.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Move-Item $path $backup
            Write-ColorOutput "  ✓ Backed up to: $backup" "Green"
        }
    } else {
        Write-ColorOutput "  ⚠ Not found: $description" "Yellow"
    }
}

Write-Section "Winfig Uninstall"
Write-ColorOutput "Removing winfig configurations"
Write-ColorOutput ""

if (-not $Force) {
    Write-ColorOutput "Running in safe mode - configurations will be backed up" "Yellow"
    Write-ColorOutput "Use -Force to remove without backup" "Yellow"
    Write-ColorOutput ""
}

# Remove PowerShell configuration
Write-Section "PowerShell Configuration"
$profileDir = Split-Path $PROFILE -Parent
Remove-ConfigFile $PROFILE "PowerShell profile"
Remove-ConfigFile (Join-Path $profileDir "m1ng.omp.json") "Oh-My-Posh theme"

# Remove Git configuration
Write-Section "Git Configuration"
$homeDir = $env:USERPROFILE
Remove-ConfigFile (Join-Path $homeDir ".gitconfig") "Git config"
Remove-ConfigFile (Join-Path $homeDir ".gitignore_global") "Global gitignore"

# Remove Windows Terminal configuration
Write-Section "Windows Terminal Configuration"
$terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Remove-ConfigFile $terminalSettingsPath "Windows Terminal settings"

# Remove PowerShell modules
if ($RemoveModules) {
    Write-Section "PowerShell Modules"
    Write-ColorOutput "  Uninstalling modules..." "Cyan"

    $modules = @('posh-git', 'Terminal-Icons', 'PSFzf')
    foreach ($module in $modules) {
        if (Get-Module -ListAvailable -Name $module) {
            Uninstall-Module $module -Force -ErrorAction SilentlyContinue
            Write-ColorOutput "  ✓ Removed: $module" "Green"
        }
    }
}

Write-Section "Uninstall Complete"
Write-ColorOutput ""
Write-ColorOutput "Configurations have been removed or backed up" "Green"
Write-ColorOutput "Restart PowerShell and Windows Terminal to apply changes" "Cyan"
Write-ColorOutput ""

if (-not $RemoveModules) {
    Write-ColorOutput "PowerShell modules were not removed" "Yellow"
    Write-ColorOutput "Use -RemoveModules to uninstall them" "Yellow"
    Write-ColorOutput ""
}
