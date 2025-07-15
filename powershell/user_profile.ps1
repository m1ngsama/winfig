# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Performance: Import modules in background jobs for faster startup
$null = Start-Job -ScriptBlock {
    Import-Module posh-git -ErrorAction SilentlyContinue
    Import-Module Terminal-Icons -ErrorAction SilentlyContinue
    Import-Module PSFzf -ErrorAction SilentlyContinue
}

# Initialize oh-my-posh immediately (essential for prompt)
$omp_config = Join-Path $PSScriptRoot ".\m1ng.omp.json"
oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression

# PSReadLine - Configure immediately for better typing experience
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Lazy load modules on first use
$global:__ModulesLoaded = @{}

function Import-LazyModule {
    param($ModuleName)
    if (-not $global:__ModulesLoaded[$ModuleName]) {
        Import-Module $ModuleName -ErrorAction SilentlyContinue
        $global:__ModulesLoaded[$ModuleName] = $true
    }
}

# Fzf - Lazy load configuration
Register-ArgumentCompleter -Native -CommandName 'fzf' -ScriptBlock {
    Import-LazyModule PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
}

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Users\m1ngsama\scoop\apps\git\2.47.1.2\usr\bin\tig.exe'
Set-Alias less 'C:\Users\m1ngsama\scoop\apps\git\2.47.1.2\usr\bin\less.exe'

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Enhanced directory navigation
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }

# Quick access to common directories
function docs { Set-Location ~\Documents }
function dl { Set-Location ~\Downloads }
function dt { Set-Location ~\Desktop }
function proj { Set-Location ~\Projects }

# Enhanced ls with colors and formatting
function la { Get-ChildItem -Force @args }
function lh { Get-ChildItem -Force -Hidden @args }

# Git shortcuts
function gs { git status }
function ga { git add @args }
function gc { git commit -m @args }
function gp { git push }
function gpl { git pull }
function gd { git diff @args }
function gco { git checkout @args }
function gb { git branch @args }
function glog { git log --oneline --graph --all --decorate }

# System utilities
function reload { & $PROFILE }
function touch($file) { New-Item -ItemType File -Name $file -Force }
function mkcd($dir) { New-Item -ItemType Directory -Path $dir -Force; Set-Location $dir }

# Network utilities
function Get-PublicIP { (Invoke-WebRequest -Uri "https://api.ipify.org").Content }
function Test-Port($hostname, $port) {
    Test-NetConnection -ComputerName $hostname -Port $port
}

# Development utilities
function dev {
    param([string]$project)
    if ($project) {
        Set-Location ~\Projects\$project
    } else {
        Set-Location ~\Projects
    }
}

function Open-VSCode { code . }
Set-Alias c Open-VSCode

# System information
function sysinfo {
    Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture, CsProcessors
}

