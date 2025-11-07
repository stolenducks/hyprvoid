# HyprVoid System Reference

**Version**: 1.0  
**Last Updated**: 2025-11-07  
**Status**: Production-Ready

This document provides a complete technical reference for the HyprVoid system. Read this first when working on the project.

---

## Table of Contents
1. [Tech Stack](#tech-stack)
2. [Architecture Overview](#architecture-overview)
3. [File Structure](#file-structure)
4. [Active Components](#active-components)
5. [Configuration Files](#configuration-files)
6. [Menu System Deep Dive](#menu-system-deep-dive)
7. [Theme System](#theme-system)
8. [Walker vs Wofi Resolution](#walker-vs-wofi-resolution)
9. [Installation Flow](#installation-flow)
10. [Runtime Paths](#runtime-paths)

---

## Tech Stack

### Core Window Manager
- **Hyprland** 0.49.0+ - Wayland compositor
- **Wayland** - Display protocol

### Menu/Launcher System  
- **Wofi** - PRIMARY launcher (styled with custom theme)
- **Walker** - OPTIONAL (installed but not used by default)
- Choice: Wofi for consistency and visual control

### UI Components
- **Waybar** - Top status bar
- **Mako** - Notification daemon
- **hyprpaper** - Wallpaper manager
- **Alacritty** - Terminal emulator

### Audio Stack
- **PipeWire** - Audio server
- **WirePlumber** - Session manager
- **wpctl** - Control utility

### Utilities
- **grim** - Screenshot tool
- **slurp** - Region selector
- **hyprpicker** - Color picker
- **wl-copy** - Clipboard utility

### Package Management
- **xbps** - Void Linux package manager

---

## Architecture Overview

```
User Input (Keyboard)
       ↓
Hyprland (bindings.conf)
       ↓
hyprvoid-* scripts ← hyprvoid-lib (shared utilities)
       ↓
Wofi (styled menus) / System Commands
```

### Design Principles
1. **Wofi-First**: All menus use wofi for visual consistency
2. **Sharp Aesthetic**: No rounded corners, clean blue borders
3. **Centralized**: hyprvoid-lib provides shared functionality
4. **Scriptable**: Bash scripts for all custom functionality

---

## File Structure

### Repository Layout
```
hyprvoid/
├── bin/                          # Executable scripts (14 files)
│   ├── hyprvoid-menu             # ⭐ Main hierarchical menu
│   ├── hyprvoid-menu-keybindings # Keybinding display
│   ├── hyprvoid-lib              # ⭐ Shared utility library
│   ├── hyprvoid-screenrecord     # Screen recording
│   ├── hyprvoid-theme-bg-next    # Background switcher
│   ├── hyprvoid-theme-set        # Dark/light theme toggle
│   ├── hyprvoid-toggle-*         # System toggles (4 files)
│   ├── hyprvoid-backup           # Config backup utility
│   ├── hyprvoid-restore          # Config restore utility
│   └── hyprvoid-symlink-configs  # Symlink manager
│
├── config/                       # Configuration templates
│   ├── autostart.conf            # Programs to start with Hyprland
│   ├── bindings.conf             # ⭐ Keybindings (synced from ~/.config)
│   ├── hyprland.conf             # Main Hyprland config
│   ├── looknfeel-dark.conf       # Dark theme settings
│   ├── looknfeel-light.conf      # Light theme settings
│   ├── looknfeel.conf            # Current theme symlink target
│   ├── windowrules.conf          # Window behavior rules
│   ├── wofi-style-dark.css       # ⭐ Wofi dark theme template
│   ├── wofi-style-light.css      # Wofi light theme template
│   ├── wofi/                     # Active wofi config (repo copy)
│   │   ├── config                # Wofi behavior settings
│   │   └── style.css             # Active theme CSS
│   └── walker/                   # ⚠️ UNUSED - kept for reference
│       ├── config.toml
│       └── themes/
│
├── docs/                         # Documentation
│   ├── SYSTEM-REFERENCE.md       # ⭐ This file
│   ├── menu-system.md            # Menu architecture guide
│   ├── keybindings.md            # Complete keybinding reference
│   ├── project-structure.md      # Project overview
│   └── bin-audit.md              # Script usage audit
│
├── install.sh                    # ⭐ Main installer
├── test.sh                       # System diagnostics
└── fix.sh                        # Hyprland fixes
```

---

## Active Components

### Critical Scripts (Must Keep)
These are actively called by keybindings or other scripts:

1. **hyprvoid-menu** - Main menu system
   - Called by: SUPER+ALT+SPACE (bindings.conf:11)
   - Provides: Apps, Learn, Trigger, Style, Setup, Install, Remove, Update, About, System menus

2. **hyprvoid-menu-keybindings** - Keybinding reference
   - Called by: SUPER+K (bindings.conf:13)
   - Displays: Formatted keybinding list

3. **hyprvoid-lib** - Shared utilities
   - Called by: All hyprvoid-* scripts
   - Provides: dmenu(), notify(), logging, theme detection

4. **hyprvoid-theme-set** - Theme switcher
   - Called by: hyprvoid-menu Style → Theme
   - Switches between dark/light themes

5. **hyprvoid-theme-bg-next** - Background cycler
   - Called by: SUPER+CTRL+SPACE (bindings.conf:27)
   - Cycles through wallpapers

6. **hyprvoid-toggle-waybar** - Bar toggle
   - Called by: SUPER+SHIFT+SPACE (bindings.conf:26)
   - Shows/hides top bar

7. **hyprvoid-toggle-gaps** - Gaps toggle
   - Called by: SUPER+SHIFT+BACKSPACE (bindings.conf:30)
   - Toggles workspace gaps

8. **hyprvoid-toggle-idle** - Idle toggle
   - Called by: SUPER+CTRL+I (bindings.conf:40)
   - Toggles screen lock/idle

9. **hyprvoid-toggle-nightlight** - Nightlight toggle
   - Called by: SUPER+CTRL+N (bindings.conf:41)
   - Toggles blue light filter

10. **hyprvoid-screenrecord** - Screen recorder
    - Called by: CTRL+PRINT (bindings.conf:48)
    - Records screen with wf-recorder

### Utility Scripts (Optional)
Not actively called but may be useful:

- **hyprvoid-backup** - Manual backup tool
- **hyprvoid-restore** - Manual restore tool
- **hyprvoid-symlink-configs** - Config symlink manager

---

## Configuration Files

### Hyprland Core Config

#### hyprland.conf
**Location**: `config/hyprland.conf` → `~/.config/hypr/hyprland.conf`  
**Purpose**: Main Hyprland configuration  
**Status**: ACTIVE

Key sections:
- Monitor configuration
- Source directives (autostart, bindings, looknfeel, windowrules)
- Input device settings
- General appearance settings
- Decoration (blur, shadows)
- Animation definitions
- Layout settings

#### bindings.conf
**Location**: `config/bindings.conf` → `~/.config/hypr/bindings.conf`  
**Purpose**: ALL keybindings  
**Status**: ACTIVE (synced from working ~/.config)

Important bindings:
- `SUPER+SPACE` → Wofi app launcher (direct call)
- `SUPER+ALT+SPACE` → hyprvoid-menu
- `SUPER+ESCAPE` → System menu
- `SUPER+K` → Keybindings display

#### autostart.conf
**Location**: `config/autostart.conf` → `~/.config/hypr/autostart.conf`  
**Purpose**: Programs to start with Hyprland  
**Status**: ACTIVE

Typically includes:
- Waybar
- Mako
- hyprpaper
- PipeWire/WirePlumber
- polkit agent

#### windowrules.conf
**Location**: `config/windowrules.conf` → `~/.config/hypr/windowrules.conf`  
**Purpose**: Window-specific behavior rules  
**Status**: ACTIVE

Examples:
- Float certain windows
- Set opacity
- Workspace assignments
- Size constraints

### Theme Configuration

#### looknfeel-dark.conf
**Location**: `config/looknfeel-dark.conf`  
**Purpose**: Dark theme colors and settings  
**Status**: ACTIVE (sourced when dark theme selected)

Contains:
- Color definitions
- Border colors (#89b4fa - blue)
- Background colors
- Active/inactive window colors

#### looknfeel-light.conf
**Location**: `config/looknfeel-light.conf`  
**Purpose**: Light theme colors and settings  
**Status**: ACTIVE (sourced when light theme selected)

#### looknfeel.conf
**Location**: `config/looknfeel.conf` → `~/.config/hypr/looknfeel.conf`  
**Purpose**: Symlink to active theme  
**Status**: ACTIVE (points to dark or light)

This is a simple source directive:
```bash
source = ~/.config/hypr/looknfeel-dark.conf
# OR
source = ~/.config/hypr/looknfeel-light.conf
```

### Wofi Configuration

#### wofi-style-dark.css
**Location**: `config/wofi-style-dark.css`  
**Purpose**: Dark theme template for wofi  
**Status**: ACTIVE TEMPLATE

Copied to `~/.config/wofi/style.css` during install.

Key styling:
```css
window {
  border: 2px solid #89b4fa;  /* Sharp blue border */
  background-color: rgba(30, 30, 46, 0.95);
  border-radius: 0;  /* No rounded corners */
}
```

#### wofi-style-light.css
**Location**: `config/wofi-style-light.css`  
**Purpose**: Light theme template for wofi  
**Status**: ACTIVE TEMPLATE

#### config/wofi/config
**Location**: `config/wofi/config`  
**Purpose**: Wofi behavior settings  
**Status**: ACTIVE TEMPLATE

Settings:
```
width=600
height=400
location=center  # Center the menu!
show=dmenu
allow_images=true
image_size=24
```

#### config/wofi/style.css
**Location**: `config/wofi/style.css`  
**Purpose**: Repo copy of active wofi theme  
**Status**: REFERENCE (actual file is in ~/.config/wofi/)

This is a copy for reference. The actual active file is:
`~/.config/wofi/style.css`

### Walker Configuration (UNUSED)

#### config/walker/config.toml
**Location**: `config/walker/config.toml`  
**Purpose**: Walker configuration  
**Status**: ⚠️ UNUSED (kept for reference)

Walker is installed but NOT used in the current system. All menu functionality uses wofi.

#### config/walker/themes/*
**Location**: `config/walker/themes/`  
**Purpose**: Walker theme files  
**Status**: ⚠️ UNUSED

Multiple theme files exist:
- catppuccin-mocha.css/.toml
- default.css/.toml
- dmenu.css/.toml

These are NOT being used.

---

## Menu System Deep Dive

### Primary Launcher: Wofi

**How it's called**:
```bash
# SUPER+SPACE (bindings.conf:9)
wofi --show drun \
  --conf "${HOME}/.config/wofi/config" \
  --style "${HOME}/.config/wofi/style.css"
```

**What it does**:
- Shows desktop applications
- Uses custom styled theme
- Centered on screen
- Sharp blue borders
- Semi-transparent background

### HyprVoid Menu: hyprvoid-menu

**How it's called**:
```bash
# SUPER+ALT+SPACE (bindings.conf:11)
~/.local/bin/hyprvoid-menu
```

**Menu hierarchy**:
```
HyprVoid Menu
├── Apps → wofi --show drun (styled)
├── Learn
│   ├── Keybindings
│   ├── Hyprland Wiki
│   ├── Void Linux Docs
│   └── Bash Cheatsheet
├── Trigger
│   ├── Capture (screenshots, color picker, recording)
│   ├── Share (clipboard tools)
│   └── Toggle (idle, nightlight, bar)
├── Style
│   ├── Theme (dark/light/toggle)
│   ├── Background (cycle wallpapers)
│   └── Font (info)
├── Setup
│   ├── Audio (pavucontrol)
│   ├── WiFi (nmtui)
│   ├── Bluetooth
│   ├── Power Profile
│   ├── Monitors
│   └── Config Files
├── Install (xbps package install)
├── Remove (xbps package remove)
├── Update (system updates)
├── About (HyprVoid info)
└── System (lock, logout, reboot, shutdown)
```

### The dmenu() Function

Located in `hyprvoid-lib`, this wraps wofi:

```bash
dmenu() {
  local prompt="${1:-Select}"
  wofi --dmenu --prompt "$prompt" \
    --conf "${HOME}/.config/wofi/config" \
    --style "${HOME}/.config/wofi/style.css"
}
```

All menu selections in hyprvoid-menu use this function.

---

## Theme System

### How Themes Work

1. **Two theme files**: `looknfeel-dark.conf` and `looknfeel-light.conf`
2. **Current theme**: `looknfeel.conf` sources one of them
3. **Switching**: `hyprvoid-theme-set` rewrites `looknfeel.conf`
4. **Reload**: `hyprctl reload` applies changes

### Theme Components

**Hyprland colors** (looknfeel-*.conf):
- Window borders
- Background
- Active/inactive colors

**Wofi styling** (wofi-style-*.css):
- Menu borders
- Background transparency
- Text colors
- Selection highlight

### Current Theme: HyprVoid Default

- **Sharp blue borders**: `#89b4fa` (2px solid)
- **No rounded corners**: `border-radius: 0`
- **Semi-transparent backgrounds**: `rgba(30, 30, 46, 0.95)`
- **Centered menus**: `location=center`
- **Clean, modern aesthetic**

---

## Walker vs Wofi Resolution

### The History

**Initial Setup**:
- Walker was intended as primary launcher
- `hyprvoid-launch-walker` script with wofi fallback
- SUPER+SPACE → hyprvoid-launch-walker → walker

**The Problem**:
- Walker had different styling (catppuccin)
- Inconsistent with hyprvoid-menu appearance
- User wanted unified styled menus

**The Solution**:
- Switched SUPER+SPACE to call wofi directly
- Applied custom HyprVoid theme to wofi
- Removed hyprvoid-launch-walker
- All menus now use styled wofi

### Current State

**Walker Status**:
- ✅ Still installed on system (`/usr/bin/walker`)
- ⚠️ Config exists but unused (`config/walker/`)
- ❌ NOT called by any keybinding
- ℹ️ Available via `walker -m symbols` (SUPER+CTRL+E) for emojis

**Wofi Status**:
- ✅ PRIMARY launcher
- ✅ Used by SUPER+SPACE
- ✅ Used by hyprvoid-menu (via dmenu())
- ✅ Custom styled theme applied
- ✅ Consistent across all menus

### Decision: Why Wofi?

1. **Visual Control**: CSS styling is easier to customize
2. **Consistency**: Same look across all menus
3. **Simplicity**: Direct calls, no wrapper scripts
4. **Performance**: Lightweight, fast startup
5. **Proven**: Working beautifully in production

---

## Installation Flow

### What install.sh Does

1. **Installs packages** via xbps
2. **Copies config files** from repo to `~/.config/`
3. **Copies bin scripts** to `~/.local/bin/`
4. **Sets up themes**:
   - Copies wofi-style-dark.css to ~/.config/wofi/style.css
   - Sets default theme (dark)
5. **Enables services**:
   - PipeWire
   - WirePlumber
6. **Creates directories**:
   - ~/Pictures/screenshots
   - ~/.cache/hyprvoid/logs

### Runtime Installation

```
Repository: /home/stolenducks/hyprvoid/
              ↓ install.sh
User Config: ~/.config/hypr/
                ├── hyprland.conf
                ├── bindings.conf
                ├── autostart.conf
                ├── looknfeel.conf
                ├── looknfeel-dark.conf
                ├── looknfeel-light.conf
                └── windowrules.conf

            ~/.config/wofi/
                ├── config
                └── style.css

            ~/.local/bin/
                └── hyprvoid-* scripts
```

---

## Runtime Paths

### Configuration Locations

**Active configs** (what Hyprland reads):
- `~/.config/hypr/` - All Hyprland configs
- `~/.config/wofi/` - Wofi styling
- `~/.local/bin/` - Executable scripts

**Templates** (in repository):
- `config/` - Config templates
- `bin/` - Script sources

### Log Files
- `~/.cache/hyprvoid/logs/` - Script logs
- `~/.cache/hyprvoid/hyprvoid.log` - General log

### Data Directories
- `~/Pictures/screenshots/` - Screenshot storage
- `~/Pictures/wallpapers/` - Wallpaper storage (optional)

---

## Quick Start Guide

### For New Users

1. Clone repo: `git clone https://github.com/stolenducks/hyprvoid.git`
2. Run installer: `cd hyprvoid && ./install.sh`
3. Log out and select "Hyprland" session
4. Test keybindings:
   - `SUPER+SPACE` - App launcher
   - `SUPER+ALT+SPACE` - Main menu
   - `SUPER+K` - Keybindings reference

### For Developers

1. Read this document first
2. Check `docs/menu-system.md` for menu architecture
3. Check `docs/keybindings.md` for all bindings
4. Scripts are in `bin/`, configs in `config/`
5. Make changes, test thoroughly
6. Update documentation if you change behavior

### For Troubleshooting

1. Check logs: `~/.cache/hyprvoid/logs/`
2. Test configs: `hyprctl reload`
3. Verify paths: configs in `~/.config/`, scripts in `~/.local/bin/`
4. Test menu: `~/.local/bin/hyprvoid-menu`
5. Test wofi: `wofi --show drun`

---

## Summary: What's Actually Being Used

### ACTIVE ✅
- Wofi (all menus)
- Hyprland configs (all .conf files in ~/.config/hypr/)
- wofi-style-dark.css (template for ~/.config/wofi/style.css)
- All hyprvoid-* scripts except backup/restore/symlink
- Keybindings in bindings.conf

### UNUSED ⚠️
- Walker (installed but not called)
- config/walker/* (reference only)
- hyprvoid-backup (utility)
- hyprvoid-restore (utility)
- hyprvoid-symlink-configs (utility)

### TEMPLATES 📄
- config/*.conf (copied to ~/.config/hypr/)
- config/wofi-style-*.css (copied to ~/.config/wofi/)

---

## Version History

- **1.0** (2025-11-07) - Initial complete system reference
  - Walker removed as primary launcher
  - Wofi established as primary with custom theme
  - All documentation updated
  - System confirmed working beautifully

---

*This document is the single source of truth for the HyprVoid system. Keep it updated when making changes.*
