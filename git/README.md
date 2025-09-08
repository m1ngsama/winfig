# Git Configuration

Optimized Git configuration with useful aliases and settings for enhanced workflow.

## Features

- **Comprehensive Aliases**: Shortcuts for common Git operations
- **Better Diff Algorithm**: Histogram algorithm for cleaner diffs
- **Auto-correction**: Automatically fixes typos in Git commands
- **Smart Defaults**: Optimized settings for better performance on Windows
- **Global Gitignore**: Ignore common system and IDE files across all repositories

## Installation

### Configure Git

```powershell
# Copy the config to your home directory
Copy-Item git\.gitconfig ~\.gitconfig

# Configure global gitignore
git config --global core.excludesfile ~/.gitignore_global
Copy-Item git\.gitignore_global ~\.gitignore_global

# Set your user information
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Useful Aliases

### Basic Operations
- `git st` - Status
- `git co` - Checkout
- `git br` - Branch
- `git cm "message"` - Commit with message
- `git ca` - Amend last commit
- `git can` - Amend last commit without editing message

### Logs
- `git lg` - Beautiful graph log
- `git lga` - Beautiful graph log (all branches)
- `git last` - Show last commit with stats

### Branch Management
- `git brd <branch>` - Delete branch (safe)
- `git brD <branch>` - Force delete branch
- `git bra` - List all branches (including remote)

### Stash Operations
- `git sl` - Stash list
- `git sa` - Stash apply
- `git ss "message"` - Stash save with message
- `git sp` - Stash pop
- `git sd` - Stash drop

### Advanced Workflows
- `git sync` - Fetch and rebase current branch
- `git cleanup` - Delete all merged branches (except main/master/develop)
- `git wip` - Quick work-in-progress commit
- `git unwip` - Undo the last WIP commit
- `git unstage <file>` - Unstage file
- `git undo` - Undo last commit (keep changes)

### Information
- `git aliases` - List all configured aliases
- `git contributors` - List contributors with commit counts
- `git ignored` - List ignored files
- `git untracked` - List untracked files

## Configuration Highlights

### Performance
- `core.fscache = true` - Cache file system operations
- `core.preloadindex = true` - Parallel index preload

### Auto-stash
- Automatically stash changes before rebase

### Better Diffs
- Histogram algorithm for cleaner diffs
- Detect renames and copies
- Show conflict markers in diff3 style

### Smart Defaults
- Auto-prune deleted remote branches
- Rebase instead of merge on pull
- Push current branch by default
- Auto-correct typos in commands

## Windows-Specific Settings

- `core.autocrlf = true` - Handle line endings automatically
- `credential.helper = wincred` - Use Windows Credential Manager
- `core.editor = nvim` - Use Neovim as default editor

## Global Gitignore

The `.gitignore_global` file ignores common files across all your repositories:
- System files (Windows, macOS, Linux)
- IDE and editor files (.vscode, .idea, etc.)
- Language-specific files (node_modules, __pycache__, etc.)
- Temporary and backup files

## Customization

Edit `~\.gitconfig` to customize settings to your preferences. Remember to update your user information:

```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```
