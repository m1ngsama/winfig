# Windows Terminal Configuration

Optimized Windows Terminal settings for enhanced development experience.

## Features

- **Custom Color Schemes**: One Half Dark (default) and Dracula
- **Optimized Font**: CaskaydiaCove Nerd Font for better icon support
- **Enhanced Keybindings**: Vim-inspired pane management
- **Performance Optimized**: ClearType antialiasing, disabled acrylic for better performance
- **Multi-Profile Support**: PowerShell, CMD, WSL, Azure Cloud Shell

## Installation

1. Open Windows Terminal
2. Press `Ctrl+,` to open settings
3. Click "Open JSON file" button in bottom-left
4. Replace contents with `settings.json` from this directory
5. Save and restart Windows Terminal

## Keybindings

### Panes
- `Alt+Shift+D` - Duplicate pane
- `Alt+Shift+-` - Split horizontally
- `Alt+Shift+|` - Split vertically
- `Ctrl+Shift+W` - Close pane

### Navigation
- `Alt+Arrow Keys` - Move focus between panes
- `Alt+Shift+Arrow Keys` - Resize panes

### Tabs
- `Ctrl+Shift+T` - New tab
- `Ctrl+Shift+D` - Duplicate tab

### View
- `Ctrl+Shift+F11` - Toggle focus mode
- `Alt+Enter` - Toggle fullscreen
- `Ctrl+Shift+F` - Find

## Required Fonts

Install [CaskaydiaCove Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases) for best experience:

```powershell
scoop bucket add nerd-fonts
scoop install CascadiaCode-NF
```

## Color Schemes

### One Half Dark (Default)
Modern, easy-on-the-eyes color scheme based on Atom's One Dark.

### Dracula
Popular dark theme with vibrant colors.

## Customization

To change the default color scheme, edit the `colorScheme` property in the PowerShell profile:

```json
"colorScheme": "Dracula"
```
