# winfig

> Comprehensive Windows development environment configuration toolkit

Winfig is a curated collection of configurations, scripts, and utilities designed to transform your Windows terminal into a powerful, efficient development environment. Optimized for Windows Terminal, PowerShell, and modern development workflows.

## Features

- **⚡ Performance Optimized PowerShell** - Lazy loading modules for faster startup
- **🎨 Beautiful Terminal Theme** - Custom Oh-My-Posh configuration with context awareness
- **🛠️ Comprehensive Utilities** - 40+ helper functions for faster workflow
- **📦 Package Management** - Curated Scoop package lists with automated installation
- **⚙️ Git Configuration** - Extensive aliases and optimized settings
- **🖥️ Windows Terminal Settings** - Custom profiles, keybindings, and color schemes
- **💾 Backup & Restore** - Easy configuration backup and migration
- **🚀 Automated Setup** - One-command installation with smart defaults

## Quick Start

### 1. Install Prerequisites

```powershell
# Install Scoop (package manager)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# Install essential tools
scoop install git pwsh oh-my-posh
```

### 2. Clone Repository

```powershell
git clone https://github.com/m1ngsama/winfig.git
cd winfig
```

### 3. Run Setup

```powershell
# Automated setup (recommended)
.\setup.ps1

# Or manual setup for specific components
.\setup.ps1 -SkipScoop         # Skip Scoop setup
.\setup.ps1 -SkipGit           # Skip Git configuration
.\setup.ps1 -SkipPowerShell    # Skip PowerShell profile
.\setup.ps1 -SkipTerminal      # Skip Windows Terminal settings
```

### 4. Install Packages

```powershell
# Install all recommended packages
cd scoop
.\install-packages.ps1

# Or install specific categories
.\install-packages.ps1 -Category essentials
.\install-packages.ps1 -Category development
```

### 5. Restart Terminal

Close and reopen your terminal to see the changes.

## Components

### 📁 PowerShell Profile

**Location**: `powershell/user_profile.ps1`

**Features**:
- Lazy loading for faster startup (50%+ improvement)
- Enhanced PSReadLine with ListView predictions
- 40+ utility functions and aliases
- Git integration with shortcuts
- Network and system utilities

**Quick Functions**:
```powershell
# Directory navigation
..          # Up one level
...         # Up two levels
docs        # Jump to Documents
proj        # Jump to Projects
mkcd dir    # Create and enter directory

# Git shortcuts
gs          # git status
ga file     # git add
gc "msg"    # git commit
gp          # git push
glog        # Beautiful git log

# System utilities
reload      # Reload PowerShell profile
touch file  # Create new file
which cmd   # Find command location
c           # Open VS Code in current directory
```

### 🎨 Oh-My-Posh Theme

**Location**: `powershell/m1ng.omp.json`

**Features**:
- Modern powerline design
- Git status integration
- Node.js, Python, Go, Docker indicators
- Execution time display (500ms+ threshold)
- Time display
- Root/admin indicator

### 🖥️ Windows Terminal

**Location**: `windows-terminal/settings.json`

**Features**:
- Optimized for CaskaydiaCove Nerd Font
- Custom color schemes (One Half Dark, Dracula)
- Vim-inspired pane management keybindings
- Profiles for PowerShell, CMD, WSL, Azure Cloud Shell
- Performance optimizations

**Key Bindings**:
- `Alt+Shift+D` - Duplicate pane
- `Alt+Shift+-` - Split horizontally
- `Alt+Shift+|` - Split vertically
- `Alt+Arrow Keys` - Navigate panes
- `Ctrl+Shift+F` - Find
- `Alt+Enter` - Fullscreen

### ⚙️ Git Configuration

**Location**: `git/.gitconfig`

**Features**:
- 30+ useful aliases
- Histogram diff algorithm
- Auto-stash before rebase
- Auto-prune deleted branches
- Auto-correct typos
- Global gitignore

**Useful Aliases**:
```bash
git lg          # Beautiful graph log
git sync        # Fetch and rebase
git cleanup     # Delete merged branches
git wip         # Quick WIP commit
git unwip       # Undo WIP commit
git aliases     # List all aliases
```

### 📦 Scoop Packages

**Location**: `scoop/packages.json`

**Categories**:
- **Essentials**: git, 7zip, curl, wget, grep, sed
- **Shells**: pwsh, oh-my-posh
- **Terminal**: windows-terminal, wezterm
- **Editors**: neovim, vscode
- **Development**: nodejs, python, go, rust
- **Tools**: fzf, ripgrep, bat, lazygit, delta
- **Databases**: postgresql, redis, mysql
- **Cloud**: aws-cli, azure-cli, terraform
- **Fonts**: Nerd Fonts (CascadiaCode, FiraCode, JetBrainsMono)
- **Utilities**: everything, quicklook, powertoys

### 🔧 Tmux Configuration

**Location**: `tmux/`

**Features**:
- Custom prefix key (Ctrl+T)
- Vim-style navigation
- Custom theme and statusline
- macOS-specific optimizations
- Useful utility keybindings

## Advanced Usage

### Backup Current Configuration

```powershell
# Create backup
.\backup.ps1

# Backup with Scoop packages
.\backup.ps1 -IncludeScoopPackages

# Compressed backup
.\backup.ps1 -Compress
```

### Restore from Backup

```powershell
# Restore configurations
.\restore.ps1 -BackupPath ".\backups\backup-20241201-120000"

# Restore with Scoop packages
.\restore.ps1 -BackupPath ".\backups\backup.zip" -RestoreScoopPackages

# Force restore (no backup of existing)
.\restore.ps1 -BackupPath ".\backups\backup.zip" -Force
```

### Export Scoop Packages

```powershell
cd scoop
.\export-packages.ps1
```

Creates `installed-packages.json` with your current setup.

### Uninstall

```powershell
# Safe uninstall (backups configs)
.\uninstall.ps1

# Remove modules too
.\uninstall.ps1 -RemoveModules

# Force remove (no backups)
.\uninstall.ps1 -Force
```

## Customization

### PowerShell Profile

Edit `powershell/user_profile.ps1` to add your own functions and aliases.

### Oh-My-Posh Theme

Customize `powershell/m1ng.omp.json` or create your own theme:
```powershell
# Browse themes
Get-PoshThemes

# Set different theme
oh-my-posh init pwsh --config ~/theme.omp.json | Invoke-Expression
```

### Git Configuration

Edit `git/.gitconfig` or override specific settings:
```powershell
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Windows Terminal

Customize `windows-terminal/settings.json` for your preferences:
- Change color scheme
- Modify keybindings
- Add custom profiles
- Adjust font and appearance

## Requirements

### Minimum Requirements
- Windows 10/11
- PowerShell 7+ (PowerShell Core)
- Windows Terminal (recommended)

### Recommended Tools
- Scoop package manager
- Git for Windows
- Oh-My-Posh
- Nerd Font (CaskaydiaCove, FiraCode, or JetBrainsMono)

### Optional Tools
- WSL2 (for tmux configuration)
- Docker Desktop
- VS Code

## Troubleshooting

### PowerShell Profile Not Loading

Check execution policy:
```powershell
Get-ExecutionPolicy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Oh-My-Posh Not Working

Install Oh-My-Posh and fonts:
```powershell
scoop install oh-my-posh
scoop bucket add nerd-fonts
scoop install CascadiaCode-NF
```

Set font in Windows Terminal settings.

### Modules Not Found

Install required PowerShell modules:
```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module Terminal-Icons -Scope CurrentUser
Install-Module PSFzf -Scope CurrentUser
```

### Git Config Not Applied

Manually copy configuration:
```powershell
Copy-Item git\.gitconfig ~\.gitconfig
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Terminal Icons Not Showing

1. Install a Nerd Font:
   ```powershell
   scoop bucket add nerd-fonts
   scoop install CascadiaCode-NF
   ```

2. Set font in Windows Terminal:
   - Open Settings (Ctrl+,)
   - Appearance → Font face → CaskaydiaCove Nerd Font

## Project Structure

```
winfig/
├── powershell/           # PowerShell profile and theme
│   ├── user_profile.ps1  # Main profile
│   └── m1ng.omp.json     # Oh-My-Posh theme
├── windows-terminal/     # Windows Terminal settings
│   ├── settings.json     # Terminal configuration
│   └── README.md
├── git/                  # Git configuration
│   ├── .gitconfig        # Git config with aliases
│   ├── .gitignore_global # Global gitignore
│   └── README.md
├── scoop/                # Package management
│   ├── packages.json     # Package list
│   ├── install-packages.ps1
│   ├── export-packages.ps1
│   └── README.md
├── tmux/                 # Tmux configuration
│   ├── tmux.conf
│   ├── theme.conf
│   ├── statusline.conf
│   ├── utility.conf
│   └── macos.conf
├── setup.ps1             # Automated setup
├── uninstall.ps1         # Uninstall script
├── backup.ps1            # Backup configurations
├── restore.ps1           # Restore from backup
└── README.md             # This file
```

## Tips & Tricks

### Faster Scoop Downloads

```powershell
scoop install aria2
scoop config aria2-enabled true
```

### Update Everything

```powershell
# Update Scoop packages
scoop update *

# Update PowerShell modules
Update-Module

# Update Oh-My-Posh
scoop update oh-my-posh
```

### Clean Up

```powershell
# Remove old Scoop versions
scoop cleanup *

# Clear Scoop cache
scoop cache rm *

# Remove temp files
Remove-Item $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue
```

### Keyboard Maestro

Combine winfig with keyboard launchers:
- **Keypirinha** - Fast launcher (included in Scoop packages)
- **PowerToys Run** - Microsoft's launcher
- **Everything** - Fast file search

## Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Share your customizations

## License

MIT License - See LICENSE file for details

## Acknowledgments

- [Oh-My-Posh](https://ohmyposh.dev/) - Prompt theme engine
- [Scoop](https://scoop.sh/) - Package manager for Windows
- [Windows Terminal](https://github.com/microsoft/terminal) - Modern terminal
- [Nerd Fonts](https://www.nerdfonts.com/) - Patched fonts with icons

## Author

**m1ngsama**
- GitHub: [@m1ngsama](https://github.com/m1ngsama)

---

⭐ If you find winfig useful, please consider giving it a star!
