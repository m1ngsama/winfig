# Winfig Setup Script
# Automated setup for Windows development environment

param(
    [switch]$SkipScoop,
    [switch]$SkipGit,
    [switch]$SkipPowerShell,
    [switch]$SkipTerminal,
    [switch]$DryRun
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

function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Copy-ConfigFile {
    param($source, $destination, $description)

    if ($DryRun) {
        Write-ColorOutput "  [DRY RUN] Would copy: $description" "Yellow"
        return
    }

    try {
        $destDir = Split-Path $destination -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }

        Copy-Item -Path $source -Destination $destination -Force
        Write-ColorOutput "  ✓ Copied: $description" "Green"
    } catch {
        Write-ColorOutput "  ✗ Failed: $description - $($_.Exception.Message)" "Red"
    }
}

Write-Section "Winfig Setup"
Write-ColorOutput "Automated Windows development environment configuration"
Write-ColorOutput ""

if ($DryRun) {
    Write-ColorOutput "Running in DRY RUN mode - no changes will be made" "Yellow"
    Write-ColorOutput ""
}

# Check for admin rights for certain operations
if (-not (Test-Admin)) {
    Write-ColorOutput "Note: Some operations may require administrator privileges" "Yellow"
    Write-ColorOutput ""
}

# PowerShell Configuration
if (-not $SkipPowerShell) {
    Write-Section "PowerShell Configuration"

    $profileDir = Split-Path $PROFILE -Parent
    $sourceProfile = Join-Path $PSScriptRoot "powershell\user_profile.ps1"
    $sourceOmp = Join-Path $PSScriptRoot "powershell\m1ng.omp.json"

    Copy-ConfigFile $sourceProfile $PROFILE "PowerShell profile"
    Copy-ConfigFile $sourceOmp (Join-Path $profileDir "m1ng.omp.json") "Oh-My-Posh theme"

    Write-ColorOutput ""
    Write-ColorOutput "  Required PowerShell modules:" "Cyan"
    Write-ColorOutput "    - posh-git" "White"
    Write-ColorOutput "    - Terminal-Icons" "White"
    Write-ColorOutput "    - PSFzf" "White"
    Write-ColorOutput ""
    Write-ColorOutput "  Install with: Install-Module <module-name> -Scope CurrentUser" "Yellow"
}

# Git Configuration
if (-not $SkipGit) {
    Write-Section "Git Configuration"

    $homeDir = $env:USERPROFILE
    $sourceGitConfig = Join-Path $PSScriptRoot "git\.gitconfig"
    $sourceGitIgnore = Join-Path $PSScriptRoot "git\.gitignore_global"

    Copy-ConfigFile $sourceGitConfig (Join-Path $homeDir ".gitconfig") "Git config"
    Copy-ConfigFile $sourceGitIgnore (Join-Path $homeDir ".gitignore_global") "Global gitignore"

    Write-ColorOutput ""
    Write-ColorOutput "  Don't forget to set your Git identity:" "Yellow"
    Write-ColorOutput "    git config --global user.name `"Your Name`"" "White"
    Write-ColorOutput "    git config --global user.email `"your.email@example.com`"" "White"
}

# Windows Terminal Configuration
if (-not $SkipTerminal) {
    Write-Section "Windows Terminal Configuration"

    $terminalSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    $sourceTerminalSettings = Join-Path $PSScriptRoot "windows-terminal\settings.json"

    if (Test-Path (Split-Path $terminalSettingsPath -Parent)) {
        # Backup existing settings
        if (Test-Path $terminalSettingsPath) {
            $backupPath = "$terminalSettingsPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            if (-not $DryRun) {
                Copy-Item $terminalSettingsPath $backupPath
                Write-ColorOutput "  ✓ Backed up existing settings to: $backupPath" "Green"
            } else {
                Write-ColorOutput "  [DRY RUN] Would backup to: $backupPath" "Yellow"
            }
        }

        Copy-ConfigFile $sourceTerminalSettings $terminalSettingsPath "Windows Terminal settings"
    } else {
        Write-ColorOutput "  ⚠ Windows Terminal not found or not installed" "Yellow"
    }
}

# Scoop Setup
if (-not $SkipScoop) {
    Write-Section "Scoop Package Manager"

    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-ColorOutput "  ✓ Scoop is already installed" "Green"
        Write-ColorOutput ""
        Write-ColorOutput "  Install packages with:" "Cyan"
        Write-ColorOutput "    cd scoop" "White"
        Write-ColorOutput "    .\install-packages.ps1" "White"
    } else {
        Write-ColorOutput "  ✗ Scoop is not installed" "Red"
        Write-ColorOutput ""
        Write-ColorOutput "  Install Scoop with:" "Yellow"
        Write-ColorOutput "    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" "White"
        Write-ColorOutput "    irm get.scoop.sh | iex" "White"
    }
}

# Tmux Configuration (if using WSL)
Write-Section "Tmux Configuration (WSL)"
Write-ColorOutput "  Tmux configuration is available in tmux/ directory" "Cyan"
Write-ColorOutput "  Copy to WSL: cp -r tmux ~/.config/tmux" "White"

# Summary
Write-Section "Setup Complete"
Write-ColorOutput ""
Write-ColorOutput "Next steps:" "Green"
Write-ColorOutput "  1. Restart PowerShell to apply changes" "White"
Write-ColorOutput "  2. Install required PowerShell modules" "White"
Write-ColorOutput "  3. Set your Git identity" "White"
Write-ColorOutput "  4. Install Scoop packages (cd scoop && .\install-packages.ps1)" "White"
Write-ColorOutput "  5. Restart Windows Terminal to see new settings" "White"
Write-ColorOutput ""
Write-ColorOutput "For more information, see README.md" "Cyan"
