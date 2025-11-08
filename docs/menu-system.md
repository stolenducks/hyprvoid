# HyprVoid Menu System Documentation

## Overview

HyprVoid uses a custom menu system built around **wofi** (a Wayland-native application launcher) with a clean, consistent theme. The menu system provides quick access to applications, system controls, and HyprVoid-specific features.

## Architecture

### Core Components

1. **hyprvoid-menu** (`bin/hyprvoid-menu`)
   - Main menu script providing hierarchical navigation
   - Sources shared utilities from `hyprvoid-lib`
   - Presents categorized options (Apps, Learn, Trigger, Style, Setup, etc.)

2. **hyprvoid-lib** (`bin/hyprvoid-lib`)
   - Shared library for all HyprVoid scripts
   - Provides `dmenu()` function that wraps wofi
   - Handles launcher detection and common utilities

3. **Wofi Configuration**
   - Config: `~/.config/wofi/config`
   - Style: `~/.config/wofi/style.css`
   - Theme templates: `config/wofi-style-dark.css`, `config/wofi-style-light.css`

### Menu Hierarchy

```
HyprVoid Menu (SUPER+ALT+SPACE)
├── Apps              → Application launcher (wofi --show drun)
├── Learn             → Documentation & resources
│   ├── Keybindings
│   ├── Hyprland Wiki
│   ├── Void Linux Docs
│   └── Bash Cheatsheet
├── Trigger           → Quick actions
│   ├── Capture       → Screenshots, color picker, recording
│   ├── Share         → Clipboard tools
│   └── Toggle        → System toggles (idle, nightlight, bar)
├── Style             → Theme management
│   ├── Theme         → Dark/Light/Toggle
│   ├── Background    → Cycle wallpapers
│   └── Font          → Font info
├── Setup             → System configuration
│   ├── Audio
│   ├── WiFi
│   ├── Bluetooth
│   ├── Power Profile
│   ├── Monitors
│   └── Config Files
├── Install           → Package installation
├── Remove            → Package removal
├── Update            → System updates
│   ├── System Update → Update all packages (xbps-install -Syu)
│   ├── Warp Terminal → Update Warp Terminal to latest version
│   ├── Config Refresh → Reload Hyprland configuration
│   └── Restart Services → Restart Waybar, Mako, or Hyprpaper
├── About             → HyprVoid information
└── System            → Power options (lock, logout, reboot, shutdown)
```

## Keybindings

| Keybinding | Action | Description |
|------------|--------|-------------|
| `SUPER + SPACE` | Launch Apps | Opens wofi application launcher directly |
| `SUPER + ALT + SPACE` | HyprVoid Menu | Opens the main hierarchical menu |
| `SUPER + ESCAPE` | System Menu | Opens power/system menu directly |
| `SUPER + K` | Keybindings | Shows keybinding reference |

## Theme System

### Current Theme: HyprVoid Default

The menu uses a custom theme with:
- **Sharp blue borders** (`#89b4fa` - 2px solid)
- **Semi-transparent dark background** (`rgba(30, 30, 46, 0.95)`)
- **No rounded corners** (Sharp, clean aesthetic)
- **Centered positioning**
- **Icon support** with 24px size

### Theme Files

- **Active config**: `~/.config/wofi/style.css` (installed to user home)
- **Dark template**: `config/wofi-style-dark.css` (in repo)
- **Light template**: `config/wofi-style-light.css` (in repo)

The installer copies the appropriate theme to `~/.config/wofi/` based on your theme selection.

### Customizing the Theme

To modify the menu appearance, edit `~/.config/wofi/style.css`:

```css
window {
  border: 2px solid #89b4fa;  /* Border color and width */
  background-color: rgba(30, 30, 46, 0.95);  /* Background */
  border-radius: 0;  /* 0 = sharp corners, 8 = rounded */
}
```

After editing, the changes take effect immediately on the next menu launch.

## How It Works

### The dmenu() Function

The `dmenu()` function in `hyprvoid-lib` provides a unified interface:

```bash
dmenu "Prompt Text"
```

This function:
1. Detects available launchers (wofi, fuzzel, bemenu)
2. Passes the prompt to the launcher
3. Returns the selected option

For wofi, it calls:
```bash
wofi --dmenu --prompt "$prompt" \
  --conf "${HOME}/.config/wofi/config" \
  --style "${HOME}/.config/wofi/style.css"
```

### Menu Flow Example

When you press `SUPER+ALT+SPACE`:

1. `hyprvoid-menu` is executed
2. `show_main_menu()` displays options via `dmenu()`
3. User selects "Apps"
4. `show_apps_menu()` is called
5. Wofi launches with `--show drun` to display applications
6. Selected app is launched

## Integration with Other Launchers

While HyprVoid defaults to wofi, it supports:
- **wofi** (primary, styled)
- **fuzzel** (fallback)
- **bemenu** (fallback)
- **walker** (available via `SUPER+SHIFT+ALT+SPACE` for advanced features)

The `dmenu()` function automatically detects and uses the best available launcher.

## Troubleshooting

### Menu appears unstyled
- Verify `~/.config/wofi/style.css` exists
- Check file permissions: `chmod 644 ~/.config/wofi/style.css`
- Reload Hyprland: `hyprctl reload`

### Menu not appearing
- Check if wofi is installed: `which wofi`
- Install if missing: `sudo xbps-install -S wofi`
- Check keybindings: `hyprctl binds | grep SPACE`

### Wrong menu opening
- Verify keybindings in `~/.config/hypr/bindings.conf`
- Reload config: `hyprctl reload`

## Development

### Adding a New Menu Item

1. Edit `bin/hyprvoid-menu`
2. Add option to the appropriate `show_*_menu()` function
3. Create handler function if needed
4. Update this documentation

Example:
```bash
show_main_menu() {
  local options="  Apps
  Learn
  New Item"  # Add your item
  
  local choice
  choice=$(echo "$options" | dmenu "HyprVoid Menu")
  
  case "$choice" in
    *Apps*)      show_apps_menu ;;
    *Learn*)     show_learn_menu ;;
    *New*)       show_new_menu ;;  # Add handler
  esac
}

show_new_menu() {
  notify "New Menu" "This is a new menu item"
}
```

### Creating a Submenu

Follow the pattern of existing submenus like `show_trigger_menu()`:

```bash
show_new_menu() {
  local options="  Option 1
  Option 2"
  
  local choice
  choice=$(echo "$options" | dmenu "New Menu")
  
  case "$choice" in
    *Option\ 1*) command1 ;;
    *Option\ 2*) command2 ;;
  esac
}
```

## Related Files

- `bin/hyprvoid-menu` - Main menu script
- `bin/hyprvoid-lib` - Shared utilities
- `bin/hyprvoid-menu-keybindings` - Keybinding display
- `config/bindings.conf` - Hyprland keybindings
- `config/wofi-style-dark.css` - Dark theme template
- `config/wofi-style-light.css` - Light theme template
- `docs/keybindings.md` - Keybinding reference

## See Also

- [Project Structure](project-structure.md)
- [Keybindings](keybindings.md)
- [Wofi Documentation](https://hg.sr.ht/~scoopta/wofi)
