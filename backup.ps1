# Winfig Backup Script
# Creates a backup of current configurations

param(
    [string]$BackupPath = (Join-Path $PSScriptRoot "backups\backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"),
    [switch]$IncludeScoopPackages,
    [switch]$Compress
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

function Backup-ConfigFile {
    param($source, $destination, $description)

    if (Test-Path $source) {
        try {
            $destDir = Split-Path $destination -Parent
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }

            Copy-Item -Path $source -Destination $destination -Force
            Write-ColorOutput "  ✓ Backed up: $description" "Green"
            return $true
        } catch {
            Write-ColorOutput "  ✗ Failed: $description - $($_.Exception.Message)" "Red"
            return $false
        }
    } else {
        Write-ColorOutput "  ⚠ Not found: $description" "Yellow"
        return $false
    }
}

Write-Section "Winfig Backup"
Write-ColorOutput "Creating backup of your configurations"
Write-ColorOutput "Backup location: $BackupPath"
Write-ColorOutput ""

# Create backup directory
if (-not (Test-Path $BackupPath)) {
    New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
}

$backupInfo = @{
    timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    hostname = $env:COMPUTERNAME
    username = $env:USERNAME
    files = @{}
}

# Backup PowerShell profile
Write-Section "PowerShell Configuration"
$profileDir = Split-Path $PROFILE -Parent
$psBackupDir = Join-Path $BackupPath "powershell"

if (Backup-ConfigFile $PROFILE (Join-Path $psBackupDir "user_profile.ps1") "PowerShell profile") {
    $backupInfo.files["powershell_profile"] = $PROFILE
}

$ompConfig = Join-Path $profileDir "m1ng.omp.json"
if (Backup-ConfigFile $ompConfig (Join-Path $psBackupDir "m1ng.omp.json") "Oh-My-Posh theme") {
    $backupInfo.files["omp_theme"] = $ompConfig
}

# Backup Git configuration
Write-Section "Git Configuration"
$homeDir = $env:USERPROFILE
$gitBackupDir = Join-Path $BackupPath "git"

if (Backup-ConfigFile (Join-Path $homeDir ".gitconfig") (Join-Path $gitBackupDir ".gitconfig") "Git config") {
    $backupInfo.files["git_config"] = Join-Path $homeDir ".gitconfig"
}

if (Backup-ConfigFile (Join-Path $homeDir ".gitignore_global") (Join-Path $gitBackupDir ".gitignore_global") "Global gitignore") {
    $backupInfo.files["git_ignore_global"] = Join-Path $homeDir ".gitignore_global"
}

# Backup Windows Terminal settings
Write-Section "Windows Terminal Configuration"
$terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$terminalBackupDir = Join-Path $BackupPath "windows-terminal"

if (Backup-ConfigFile $terminalSettingsPath (Join-Path $terminalBackupDir "settings.json") "Windows Terminal settings") {
    $backupInfo.files["terminal_settings"] = $terminalSettingsPath
}

# Backup environment variables
Write-Section "Environment Variables"
$envBackupPath = Join-Path $BackupPath "environment.json"
$envVars = @{
    user = [System.Environment]::GetEnvironmentVariables("User")
    path = $env:PATH -split ";"
}
$envVars | ConvertTo-Json -Depth 10 | Set-Content $envBackupPath
Write-ColorOutput "  ✓ Backed up: Environment variables" "Green"

# Backup Scoop packages
if ($IncludeScoopPackages -and (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Section "Scoop Packages"

    $scoopBackupDir = Join-Path $BackupPath "scoop"
    New-Item -ItemType Directory -Path $scoopBackupDir -Force | Out-Null

    # Export installed packages
    $installed = scoop list | Select-Object -Skip 1 | ForEach-Object {
        $line = $_.Trim()
        if ($line -and $line -notmatch "^-+$") {
            ($line -split '\s+')[0]
        }
    }

    $buckets = scoop bucket list | Select-Object -Skip 1 | ForEach-Object {
        ($_.Trim() -split '\s+')[0]
    }

    $scoopExport = @{
        timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        buckets = $buckets
        packages = $installed
    }

    $scoopExport | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $scoopBackupDir "packages.json")
    Write-ColorOutput "  ✓ Backed up: $($installed.Count) Scoop packages" "Green"
    $backupInfo.scoop_packages = $installed.Count
}

# Backup VSCode settings
Write-Section "VSCode Configuration"
$vscodeSettingsPath = "$env:APPDATA\Code\User\settings.json"
$vscodeKeybindingsPath = "$env:APPDATA\Code\User\keybindings.json"
$vscodeBackupDir = Join-Path $BackupPath "vscode"

if (Backup-ConfigFile $vscodeSettingsPath (Join-Path $vscodeBackupDir "settings.json") "VSCode settings") {
    $backupInfo.files["vscode_settings"] = $vscodeSettingsPath
}

if (Backup-ConfigFile $vscodeKeybindingsPath (Join-Path $vscodeBackupDir "keybindings.json") "VSCode keybindings") {
    $backupInfo.files["vscode_keybindings"] = $vscodeKeybindingsPath
}

# Save backup metadata
$backupInfo | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $BackupPath "backup-info.json")

# Compress backup if requested
if ($Compress) {
    Write-Section "Compressing Backup"
    $archivePath = "$BackupPath.zip"
    Compress-Archive -Path $BackupPath -DestinationPath $archivePath -Force
    Remove-Item $BackupPath -Recurse -Force
    Write-ColorOutput "  ✓ Compressed to: $archivePath" "Green"
    $finalPath = $archivePath
} else {
    $finalPath = $BackupPath
}

# Summary
Write-Section "Backup Complete"
Write-ColorOutput ""
Write-ColorOutput "Backup saved to: $finalPath" "Green"
Write-ColorOutput "Files backed up: $($backupInfo.files.Count)" "Cyan"

if ($backupInfo.scoop_packages) {
    Write-ColorOutput "Scoop packages: $($backupInfo.scoop_packages)" "Cyan"
}

Write-ColorOutput ""
Write-ColorOutput "To restore this backup, run: .\restore.ps1 -BackupPath `"$finalPath`"" "Yellow"
