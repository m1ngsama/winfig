# Troubleshooting Guide

This guide covers common issues and their solutions when using winfig.

## Table of Contents

- [PowerShell Issues](#powershell-issues)
- [Oh-My-Posh Issues](#oh-my-posh-issues)
- [Windows Terminal Issues](#windows-terminal-issues)
- [Git Issues](#git-issues)
- [Scoop Issues](#scoop-issues)
- [Font and Display Issues](#font-and-display-issues)
- [Performance Issues](#performance-issues)
- [General Issues](#general-issues)

## PowerShell Issues

### Profile Not Loading

**Symptom**: PowerShell starts but custom functions and theme are not available.

**Solutions**:

1. Check if profile exists:
   ```powershell
   Test-Path $PROFILE
   ```

2. Check execution policy:
   ```powershell
   Get-ExecutionPolicy
   # Should be RemoteSigned or Unrestricted
   ```

3. Set execution policy if needed:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. Check for errors in profile:
   ```powershell
   & $PROFILE
   # Look for error messages
   ```

### Module Import Errors

**Symptom**: Errors about missing modules (posh-git, Terminal-Icons, PSFzf).

**Solution**:

Install missing modules:
```powershell
Install-Module posh-git -Scope CurrentUser -Force
Install-Module Terminal-Icons -Scope CurrentUser -Force
Install-Module PSFzf -Scope CurrentUser -Force
```

### Slow Startup

**Symptom**: PowerShell takes a long time to start.

**Solutions**:

1. Check which modules are slow to load:
   ```powershell
   Measure-Command { & $PROFILE }
   ```

2. Disable unused modules in `user_profile.ps1`

3. Ensure lazy loading is working:
   ```powershell
   # Check if background job completed
   Get-Job
   ```

### Functions Not Working

**Symptom**: Custom functions like `gs`, `gp`, `..` don't work.

**Solutions**:

1. Reload profile:
   ```powershell
   . $PROFILE
   ```

2. Check if function exists:
   ```powershell
   Get-Command gs
   ```

3. Check for conflicts:
   ```powershell
   Get-Alias gs -ErrorAction SilentlyContinue
   ```

## Oh-My-Posh Issues

### Theme Not Displaying

**Symptom**: Prompt is plain text, no colors or icons.

**Solutions**:

1. Check if Oh-My-Posh is installed:
   ```powershell
   Get-Command oh-my-posh
   ```

2. Install Oh-My-Posh:
   ```powershell
   scoop install oh-my-posh
   ```

3. Verify theme file exists:
   ```powershell
   Test-Path (Join-Path (Split-Path $PROFILE) "m1ng.omp.json")
   ```

### Icons Not Showing (Boxes/Question Marks)

**Symptom**: Squares, boxes, or question marks instead of icons.

**Solutions**:

1. Install a Nerd Font:
   ```powershell
   scoop bucket add nerd-fonts
   scoop install CascadiaCode-NF
   ```

2. Set font in Windows Terminal:
   - Open Settings (`Ctrl+,`)
   - Go to Appearance
   - Set Font face to "CaskaydiaCove Nerd Font" or another Nerd Font

3. Restart Windows Terminal

### Theme Performance Issues

**Symptom**: Prompt is slow, especially in Git repositories.

**Solutions**:

1. Disable Git status fetching in theme:
   - Edit `m1ng.omp.json`
   - Set `fetch_status: false` in git segment

2. Use simpler theme:
   ```powershell
   oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\minimal.omp.json" | Invoke-Expression
   ```

## Windows Terminal Issues

### Settings Not Applied

**Symptom**: Windows Terminal doesn't show custom settings.

**Solutions**:

1. Verify settings location:
   ```powershell
   $settingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
   Test-Path $settingsPath
   ```

2. Open settings in editor:
   - Press `Ctrl+Shift+,` (opens JSON file)
   - Verify settings are correct

3. Check for JSON errors:
   - Look for syntax errors in settings.json
   - Use a JSON validator

4. Reset to defaults:
   - Rename settings.json
   - Restart Windows Terminal (creates new defaults)
   - Re-apply winfig settings

### Keybindings Not Working

**Symptom**: Custom keybindings don't work.

**Solutions**:

1. Check for conflicts:
   - Open Settings → Actions
   - Look for duplicate keybindings

2. Verify in settings.json:
   - Check `actions` array
   - Ensure no syntax errors

3. Try different key combination

### Font Not Changing

**Symptom**: Terminal doesn't use Nerd Font.

**Solutions**:

1. Install font system-wide:
   ```powershell
   # Download and install font file
   # Or use Scoop
   scoop install CascadiaCode-NF
   ```

2. Set in PowerShell profile settings:
   - Settings → Profiles → PowerShell → Appearance
   - Set Font face manually

3. Restart Windows Terminal

## Git Issues

### Config Not Applied

**Symptom**: Git aliases don't work.

**Solutions**:

1. Verify config location:
   ```powershell
   git config --list --show-origin
   ```

2. Manually copy config:
   ```powershell
   Copy-Item git\.gitconfig ~\.gitconfig -Force
   ```

3. Set user info:
   ```powershell
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```

### Aliases Not Working

**Symptom**: Git aliases like `git lg`, `git sync` don't work.

**Solutions**:

1. Check if alias exists:
   ```bash
   git config --get-regexp alias
   ```

2. Test alias:
   ```bash
   git config alias.lg
   ```

3. Manually add alias:
   ```bash
   git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
   ```

### Line Ending Issues

**Symptom**: Git shows all files as modified (^M characters).

**Solutions**:

1. Configure line endings:
   ```bash
   git config --global core.autocrlf true
   ```

2. Refresh repository:
   ```bash
   git rm --cached -r .
   git reset --hard
   ```

## Scoop Issues

### Scoop Not Found

**Symptom**: `scoop` command not recognized.

**Solutions**:

1. Install Scoop:
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   irm get.scoop.sh | iex
   ```

2. Add to PATH:
   ```powershell
   $env:PATH += ";$env:USERPROFILE\scoop\shims"
   ```

3. Restart PowerShell

### Package Installation Fails

**Symptom**: `scoop install <package>` fails.

**Solutions**:

1. Update Scoop:
   ```powershell
   scoop update
   ```

2. Check for conflicts:
   ```powershell
   scoop list
   ```

3. Clear cache:
   ```powershell
   scoop cache rm *
   ```

4. Try different bucket:
   ```powershell
   scoop bucket add extras
   scoop search <package>
   ```

### Slow Downloads

**Symptom**: Package downloads are slow.

**Solutions**:

1. Enable aria2:
   ```powershell
   scoop install aria2
   scoop config aria2-enabled true
   ```

2. Increase connections:
   ```powershell
   scoop config aria2-max-connection-per-server 16
   scoop config aria2-split 16
   ```

## Font and Display Issues

### Icons Show as Boxes

**Symptom**: Icons appear as boxes or question marks.

**Solutions**:

1. Install Nerd Font:
   ```powershell
   scoop bucket add nerd-fonts
   scoop install CascadiaCode-NF
   ```

2. Set font in all profiles:
   - Windows Terminal: Settings → Profiles → Defaults → Appearance
   - Set Font face to Nerd Font

3. Verify font is installed:
   - Windows Settings → Fonts
   - Search for "Cascadia" or your chosen font

### Colors Look Wrong

**Symptom**: Colors are incorrect or washed out.

**Solutions**:

1. Enable TrueColor:
   - Windows Terminal Settings → Rendering
   - Disable "Use legacy console"

2. Check color scheme:
   - Settings → Profiles → Color scheme
   - Try different scheme (One Half Dark, Dracula)

3. Update terminal:
   ```powershell
   scoop update windows-terminal
   ```

### Blurry or Pixelated

**Symptom**: Text appears blurry or pixelated.

**Solutions**:

1. Adjust antialiasing:
   - Settings → Rendering
   - Try different antialiasing modes (ClearType, Grayscale)

2. Check DPI scaling:
   - Windows Settings → Display
   - Ensure DPI scaling is appropriate

3. Disable Acrylic:
   - Settings → Appearance
   - Turn off "Acrylic material"

## Performance Issues

### Slow Terminal Startup

**Symptom**: Terminal takes long to open.

**Solutions**:

1. Disable unnecessary startup tasks:
   - Edit `user_profile.ps1`
   - Comment out unused module imports

2. Use lazy loading:
   - Already implemented in winfig profile

3. Clear temp files:
   ```powershell
   Remove-Item $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue
   ```

### Sluggish Git Operations

**Symptom**: Git commands are slow.

**Solutions**:

1. Disable Oh-My-Posh git status:
   - Edit `m1ng.omp.json`
   - Set `fetch_status: false`

2. Configure Git to use FSCache:
   ```bash
   git config --global core.fscache true
   git config --global core.preloadindex true
   ```

3. Exclude antivirus scanning:
   - Add Git installation directory to antivirus exclusions

### High Memory Usage

**Symptom**: PowerShell uses excessive memory.

**Solutions**:

1. Check for module leaks:
   ```powershell
   Get-Process pwsh | Select-Object -Property *
   ```

2. Restart PowerShell regularly

3. Limit history size:
   ```powershell
   Set-PSReadLineOption -MaximumHistoryCount 1000
   ```

## General Issues

### Permission Errors

**Symptom**: "Access denied" or permission errors.

**Solutions**:

1. Run as Administrator:
   - Right-click Windows Terminal
   - Select "Run as administrator"

2. Use `sudo`:
   ```powershell
   scoop install sudo
   sudo <command>
   ```

3. Check file permissions:
   ```powershell
   Get-Acl $PROFILE
   ```

### Profile Conflicts

**Symptom**: Multiple profiles causing conflicts.

**Solutions**:

1. Check profile locations:
   ```powershell
   $PROFILE | Format-List * -Force
   ```

2. Use correct profile:
   - CurrentUserCurrentHost (recommended)
   - Edit only this profile

3. Remove conflicting profiles:
   ```powershell
   Remove-Item $PROFILE.CurrentUserAllHosts -ErrorAction SilentlyContinue
   ```

### Setup Script Fails

**Symptom**: `setup.ps1` fails with errors.

**Solutions**:

1. Run with execution policy:
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process
   .\setup.ps1
   ```

2. Check error message and fix specific issue

3. Use selective setup:
   ```powershell
   .\setup.ps1 -SkipScoop  # Skip problematic component
   ```

4. Manual setup:
   - Copy files manually from each directory
   - Follow README in each subdirectory

### Backup/Restore Issues

**Symptom**: Backup or restore fails.

**Solutions**:

1. Check disk space:
   ```powershell
   Get-PSDrive C
   ```

2. Run with administrator privileges

3. Check paths:
   ```powershell
   Test-Path .\backups
   ```

4. Use full paths:
   ```powershell
   .\backup.ps1
   # Instead of relative paths
   ```

## Getting More Help

If you continue to experience issues:

1. **Check Documentation**:
   - Read component-specific READMEs
   - Review configuration comments

2. **Enable Verbose Output**:
   ```powershell
   $VerbosePreference = "Continue"
   .\setup.ps1 -Verbose
   ```

3. **Check Logs**:
   - PowerShell: `$error[0] | Format-List * -Force`
   - Scoop: `scoop cache show`

4. **Create an Issue**:
   - GitHub: [winfig issues](https://github.com/m1ngsama/winfig/issues)
   - Include error messages and system info

5. **Community Support**:
   - Windows Terminal discussions
   - Oh-My-Posh GitHub
   - Scoop community

## System Information

To gather system information for troubleshooting:

```powershell
# PowerShell version
$PSVersionTable

# Windows version
Get-ComputerInfo | Select-Object WindowsVersion, OsArchitecture

# Installed modules
Get-Module -ListAvailable | Where-Object Name -in 'posh-git','Terminal-Icons','PSFzf'

# Scoop status
scoop status

# Git version
git --version

# Oh-My-Posh version
oh-my-posh version
```

Include this information when reporting issues.
