# Scoop Package Management

Curated list of essential development tools and utilities for Windows, managed via [Scoop](https://scoop.sh).

## Prerequisites

Install Scoop if you haven't already:

```powershell
# Run in PowerShell (not PowerShell ISE)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

## Quick Start

### Install All Packages

```powershell
cd scoop
.\install-packages.ps1
```

### Install Specific Category

```powershell
# Available categories: essentials, shells, terminal, editors, development, tools, databases, cloud, fonts, utilities
.\install-packages.ps1 -Category essentials
```

### Dry Run (Preview)

```powershell
.\install-packages.ps1 -DryRun
```

## Package Categories

### Essentials
Core utilities for Windows command line:
- **git** - Version control
- **7zip** - Archive manager
- **aria2** - Download manager (speeds up Scoop)
- **dark** - Terminal theme switcher
- **sudo** - Run commands as admin
- **grep, sed, less** - Unix-like text tools
- **curl, wget** - Download utilities

### Shells
- **pwsh** - PowerShell Core
- **oh-my-posh** - Prompt theme engine

### Terminal
- **windows-terminal** - Modern terminal emulator
- **wezterm** - GPU-accelerated terminal

### Editors
- **neovim** - Modern Vim-based editor
- **vscode** - Visual Studio Code

### Development
Programming languages and build tools:
- **nodejs-lts** - Node.js LTS
- **python** - Python
- **go** - Go programming language
- **rust** - Rust programming language
- **gcc, make, cmake** - C/C++ toolchain

### Tools
Modern CLI replacements and utilities:
- **fzf** - Fuzzy finder
- **ripgrep** - Fast grep alternative
- **fd** - Fast find alternative
- **bat** - Cat with syntax highlighting
- **eza** - Modern ls replacement
- **zoxide** - Smart cd command
- **delta** - Better git diff
- **lazygit** - Git TUI
- **gh** - GitHub CLI

### Databases
- **postgresql** - PostgreSQL database
- **redis** - Redis cache
- **mysql** - MySQL database

### Cloud
- **aws** - AWS CLI
- **azure-cli** - Azure CLI
- **terraform** - Infrastructure as code

### Fonts
Nerd Fonts with icon support:
- **CascadiaCode-NF** - Microsoft's Cascadia Code
- **FiraCode-NF** - Fira Code with ligatures
- **JetBrainsMono-NF** - JetBrains Mono

### Utilities
Windows productivity tools:
- **everything** - Fast file search
- **quicklook** - File preview (like macOS)
- **powertoys** - Microsoft PowerToys
- **ditto** - Clipboard manager
- **keypirinha** - Launcher (like Alfred)

## Export Current Setup

Save your currently installed packages:

```powershell
.\export-packages.ps1
```

This creates `installed-packages.json` with all your packages.

## Maintenance

### Update All Packages

```powershell
scoop update *
```

### Check Status

```powershell
scoop status
```

### Cleanup Old Versions

```powershell
scoop cleanup *
```

### Clear Cache

```powershell
scoop cache rm *
```

## Customization

Edit `packages.json` to customize the package list for your needs. Structure:

```json
{
  "description": "...",
  "buckets": ["list", "of", "buckets"],
  "packages": {
    "category": ["package1", "package2"]
  }
}
```

## Useful Scoop Commands

```powershell
# Search for packages
scoop search <name>

# Show package info
scoop info <package>

# List installed packages
scoop list

# Uninstall package
scoop uninstall <package>

# Hold package version
scoop hold <package>

# Unhold package
scoop unhold <package>
```

## Buckets

Buckets are package repositories. Default buckets included:
- **extras** - Additional apps not in main bucket
- **nerd-fonts** - Patched fonts with icons
- **versions** - Multiple versions of packages

Add more buckets:
```powershell
scoop bucket add java
scoop bucket add games
```

## Tips

1. **Enable aria2** for faster downloads:
   ```powershell
   scoop install aria2
   scoop config aria2-enabled true
   ```

2. **Use sudo** for apps requiring admin:
   ```powershell
   sudo scoop install <package>
   ```

3. **Check for updates regularly**:
   ```powershell
   scoop status
   scoop update *
   ```

4. **Keep things clean**:
   ```powershell
   scoop cleanup *
   scoop cache rm *
   ```
