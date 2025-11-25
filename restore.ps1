# Winfig Restore Script
# Restores configurations from backup

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupPath,
    [switch]$RestoreScoopPackages,
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

function Restore-ConfigFile {
    param($source, $destination, $description)

    if (Test-Path $source) {
        try {
            # Backup existing file if it exists and not in Force mode
            if ((Test-Path $destination) -and -not $Force) {
                $backup = "$destination.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                Copy-Item $destination $backup
                Write-ColorOutput "  [WARN] Backed up existing: $backup" "Yellow"
            }

            $destDir = Split-Path $destination -Parent
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }

            Copy-Item -Path $source -Destination $destination -Force
            Write-ColorOutput "  [OK] Restored: $description" "Green"
            return $true
        } catch {
            Write-ColorOutput "  [FAIL] Failed: $description - $($_.Exception.Message)" "Red"
            return $false
        }
    } else {
        Write-ColorOutput "  [WARN] Not found in backup: $description" "Yellow"
        return $false
    }
}

Write-Section "Winfig Restore"
Write-ColorOutput "Restoring configurations from backup"
Write-ColorOutput ""

# Check if backup path exists
if (-not (Test-Path $BackupPath)) {
    Write-ColorOutput "Error: Backup path not found: $BackupPath" "Red"
    exit 1
}

# If backup is compressed, extract it first
if ($BackupPath -match '\.zip$') {
    Write-ColorOutput "Extracting compressed backup..." "Cyan"
    $extractPath = Join-Path $env:TEMP "winfig-restore-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Expand-Archive -Path $BackupPath -DestinationPath $extractPath -Force
    $BackupPath = Get-ChildItem $extractPath -Directory | Select-Object -First 1 -ExpandProperty FullName
}

# Load backup metadata
$backupInfoPath = Join-Path $BackupPath "backup-info.json"
if (Test-Path $backupInfoPath) {
    $backupInfo = Get-Content $backupInfoPath | ConvertFrom-Json
    Write-ColorOutput "Backup from: $($backupInfo.timestamp)" "Cyan"
    Write-ColorOutput "Original host: $($backupInfo.hostname)" "Cyan"
    Write-ColorOutput ""
} else {
    Write-ColorOutput "Warning: No backup metadata found" "Yellow"
    Write-ColorOutput ""
}

# Restore PowerShell profile
Write-Section "PowerShell Configuration"
$profileDir = Split-Path $PROFILE -Parent
$psBackupDir = Join-Path $BackupPath "powershell"

Restore-ConfigFile (Join-Path $psBackupDir "user_profile.ps1") $PROFILE "PowerShell profile"
Restore-ConfigFile (Join-Path $psBackupDir "m1ng.omp.json") (Join-Path $profileDir "m1ng.omp.json") "Oh-My-Posh theme"

# Restore Git configuration
Write-Section "Git Configuration"
$homeDir = $env:USERPROFILE
$gitBackupDir = Join-Path $BackupPath "git"

Restore-ConfigFile (Join-Path $gitBackupDir ".gitconfig") (Join-Path $homeDir ".gitconfig") "Git config"
Restore-ConfigFile (Join-Path $gitBackupDir ".gitignore_global") (Join-Path $homeDir ".gitignore_global") "Global gitignore"

# Restore Windows Terminal settings
Write-Section "Windows Terminal Configuration"
$terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$terminalBackupDir = Join-Path $BackupPath "windows-terminal"

Restore-ConfigFile (Join-Path $terminalBackupDir "settings.json") $terminalSettingsPath "Windows Terminal settings"

# Restore Scoop packages
if ($RestoreScoopPackages) {
    Write-Section "Scoop Packages"

    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-ColorOutput "  [FAIL] Scoop is not installed" "Red"
        Write-ColorOutput "  Install Scoop first: https://scoop.sh" "Yellow"
    } else {
        $scoopBackupPath = Join-Path $BackupPath "scoop\packages.json"

        if (Test-Path $scoopBackupPath) {
            $scoopBackup = Get-Content $scoopBackupPath | ConvertFrom-Json

            # Add buckets
            Write-ColorOutput "  Adding buckets..." "Cyan"
            foreach ($bucket in $scoopBackup.buckets) {
                scoop bucket add $bucket 2>&1 | Out-Null
            }

            # Install packages
            Write-ColorOutput "  Installing packages..." "Cyan"
            $installed = 0
            $failed = 0

            foreach ($package in $scoopBackup.packages) {
                Write-ColorOutput "    Installing: $package" "White"
                scoop install $package 2>&1 | Out-Null

                if ($LASTEXITCODE -eq 0) {
                    $installed++
                } else {
                    $failed++
                }
            }

            Write-ColorOutput "  [OK] Installed: $installed packages" "Green"
            if ($failed -gt 0) {
                Write-ColorOutput "  [FAIL] Failed: $failed packages" "Red"
            }
        } else {
            Write-ColorOutput "  [WARN] No Scoop package list found in backup" "Yellow"
        }
    }
}

# Restore VSCode settings
Write-Section "VSCode Configuration"
$vscodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
$vscodeKeybindingsPath = "$env:APPDATA\Code\User\keybindings.json"
$vscodeBackupDir = Join-Path $BackupPath "vscode"

Restore-ConfigFile (Join-Path $vscodeBackupDir "settings.json") $vscodeSettingsPath "VSCode settings"
Restore-ConfigFile (Join-Path $vscodeBackupDir "keybindings.json") $vscodeKeybindingsPath "VSCode keybindings"

# Summary
Write-Section "Restore Complete"
Write-ColorOutput ""
Write-ColorOutput "Configurations have been restored from backup" "Green"
Write-ColorOutput ""
Write-ColorOutput "Next steps:" "Cyan"
Write-ColorOutput "  1. Restart PowerShell" "White"
Write-ColorOutput "  2. Restart Windows Terminal" "White"
Write-ColorOutput "  3. Verify configurations are working correctly" "White"
Write-ColorOutput ""

if (-not $RestoreScoopPackages) {
    Write-ColorOutput "Scoop packages were not restored" "Yellow"
    Write-ColorOutput "Use -RestoreScoopPackages to install them" "Yellow"
    Write-ColorOutput ""
}
