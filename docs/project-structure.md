# HyprVoid Project Structure

## Overview

HyprVoid is an Omarchy-inspired Hyprland configuration for Void Linux. It follows Omarchy's naming conventions and architectural patterns where applicable, adapted for Void's package management (xbps).

## Naming Convention

Following Omarchy's pattern:
- **omarchy-*** → **hyprvoid-***
- **omarchy-launch-walker** → **hyprvoid-launch-walker**
- **omarchy-cmd-*** → **hyprvoid-cmd-*** (future)
- **omarchy-menu** doesn't exist in Omarchy; we use **hyprvoid-menu** for Void-specific dmenu system

## Directory Structure

```
hyprvoid/
├── bin/                      # Executable scripts
│   ├── hyprvoid-backup       # Backup configuration ✓
│   ├── hyprvoid-restore      # Restore from backup ✓
│   ├── hyprvoid-launch-walker # Walker launcher (to be created)
│   ├── hyprvoid-restart-walker # Restart walker service (to be created)
│   ├── hyprvoid-refresh-walker # Refresh walker config (to be created)
│   ├── hyprvoid-menu         # Main dmenu system (existing)
│   ├── hyprvoid-menu-apps    # DEPRECATED - will become hyprvoid-launch-walker
│   ├── hyprvoid-menu-actions # DEPRECATED - integrated into hyprvoid-menu
│   ├── hyprvoid-lib          # Shared library functions
│   └── hyprvoid-*            # Other utility scripts
│
├── config/                   # Configuration templates
│   ├── hypr/                 # Hyprland configuration
│   │   ├── hyprland.conf     # Main Hyprland config
│   │   ├── bindings.conf     # Keybindings
│   │   ├── autostart.conf    # Autostart programs
│   │   ├── looknfeel*.conf   # Theme configurations
│   │   └── windowrules.conf  # Window rules
│   │
│   ├── walker/               # Walker configuration (optional)
│   │   ├── config.toml       # Main walker config
│   │   └── themes/           # Walker themes
│   │
│   ├── wofi-style-dark.css   # Wofi dark theme template
│   ├── wofi-style-light.css  # Wofi light theme template
│   └── wofi-config           # Wofi config template (to be created)
│
├── docs/                     # Documentation
│   ├── project-structure.md  # This file
│   ├── walker.md             # Walker usage and config (to be created)
│   └── release-notes.md      # Change log (to be created)
│
├── install.sh                # Main installer
├── test.sh                   # Diagnostic tool
└── fix.sh                    # Hyprland fixes

## Configuration Management

### Local Paths (Runtime)
- `~/.config/hypr/` - Hyprland configuration
  - `hyprland.conf` - Main config
  - `bindings.conf` - Keybindings
  - `looknfeel.conf` - Current theme (symlink)
- `~/.config/wofi/` - Wofi configuration
  - `config` - Wofi settings (size, position, etc.)
  - `style.css` - Active theme CSS
- `~/.config/walker/` - Walker configuration (optional)
- `~/.local/bin/` - User binaries
  - `hyprvoid-*` scripts installed here
- `~/.local/share/applications/` - Desktop entries (overrides)

### Backup Paths
- `~/.hyprvoid/backups/` - Configuration snapshots
- `~/.cache/hyprvoid/logs/` - Runtime logs

## Theme System

### Wofi Configuration

**Active Configuration** (runtime):
- Location: `~/.config/wofi/`
- Files:
  - `config` - Menu behavior and positioning
  - `style.css` - Visual theme (colors, borders, spacing)

**Templates** (repository):
- `config/wofi-style-dark.css` - HyprVoid Default dark theme
- `config/wofi-style-light.css` - HyprVoid Default light theme

**Theme Characteristics**:
- Sharp blue borders (`#89b4fa`, 2px solid)
- No rounded corners (sharp aesthetic)
- Semi-transparent dark backgrounds
- Centered positioning
- Icon support (24px)

### Theme Switching

The installer copies the appropriate wofi theme based on your selection:
1. Dark theme → `wofi-style-dark.css` copied to `~/.config/wofi/style.css`
2. Light theme → `wofi-style-light.css` copied to `~/.config/wofi/style.css`

### Customizing Themes

To modify the menu appearance:
1. Edit `~/.config/wofi/style.css`
2. Changes take effect on next menu launch
3. No reload required

To make changes permanent in the repo:
1. Edit `config/wofi-style-dark.css` or `config/wofi-style-light.css`
2. Reinstall or manually copy to `~/.config/wofi/style.css`

## Audit Results

### References Found:
- **omarchy**: 1 occurrence (README credits only)
- **elephant**: 0 occurrences (✓ none found)
- **walker**: Multiple occurrences (all intentional)
- **wofi**: Multiple occurrences (fallback support)

### Files Using Walker:
- `bin/hyprvoid-menu-apps` - Will be renamed to hyprvoid-launch-walker
- `bin/hyprvoid-menu` - Uses walker in Apps menu
- `config/bindings.conf` - Keybindings for walker
- `install.sh` - Walker installation logic

### No Path Conflicts:
✓ No hardcoded omarchy paths
✓ No elephant dependencies
✓ All paths use hyprvoid or generic ~/.config patterns

## Menu System Architecture

### Primary Menu System: Wofi

HyprVoid uses **wofi** as the primary menu system with a custom theme:

**Main Components**:
1. **hyprvoid-menu** - Hierarchical menu script
   - Main menu (Apps, Learn, Trigger, Style, Setup, etc.)
   - Submenus for system management
   - Sources utilities from hyprvoid-lib

2. **hyprvoid-lib** - Shared library
   - `dmenu()` function wraps wofi
   - Launcher detection (wofi → fuzzel → bemenu)
   - Common utilities (logging, notifications, theme detection)

3. **Wofi Configuration**
   - Config file defines behavior (centering, size)
   - CSS file defines appearance (colors, borders, fonts)

**Keybinding Integration**:
- `SUPER + SPACE` → Direct app launcher (`wofi --show drun`)
- `SUPER + ALT + SPACE` → Full HyprVoid menu
- `SUPER + ESCAPE` → System menu (power options)

### Secondary Launcher: Walker (Optional)

Walker is available but not primary:
- Advanced features (AI, bookmarks, clipboard)
- Alternative launcher option
- No longer bound to primary keybinding

## Acceptance Criteria

✓ No hardcoded omarchy paths
✓ No elephant dependencies
✓ Consistent hyprvoid-* naming
✓ Clear separation: repo files vs. runtime ~/.config
✓ Documented audit trail
