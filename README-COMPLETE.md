# HyprVoid

> **Hyprland for Void Linux** – Complete Omarchy-style setup with full keybindings, theme switching, and comprehensive menu system

## Features

- ✅ **Complete Omarchy Keybindings** – All 100+ keybindings adapted for Void Linux
- ✅ **Full Menu System** – 10 top-level menus (Apps, Learn, Trigger, Style, Setup, Install, Remove, Update, About, System)
- ✅ **Theme Switching** – Catppuccin Mocha (dark) and Latte (light) with one-key toggle
- ✅ **Dynamic Keybindings Viewer** – Press `SUPER+K` to see all bindings
- ✅ **Wallpaper Management** – Theme-specific wallpaper cycling
- ✅ **xbps Integration** – Native Void package management in menus
- ✅ **Minimal & Clean** – No bloat, graceful fallbacks for optional tools

## Quick Start

### Installation

```bash
git clone https://github.com/stolenducks/hyprvoid.git
cd hyprvoid
./install.sh
```

Log out, select **Hyprland** at your login manager, and log back in.

## Essential Keybindings

### Core Access
- `SUPER + SPACE` – Launch apps (Walker)
- `SUPER + ALT + SPACE` – HyprVoid menu (all features)
- `SUPER + K` – Show all keybindings
- `SUPER + ESC` – System menu (lock/suspend/shutdown)

### Applications
- `SUPER + RETURN` – Terminal (alacritty)
- `SUPER + SHIFT + B` – Browser (Firefox)
- `SUPER + SHIFT + F` – File manager (Thunar)
- `SUPER + SHIFT + N` – Editor ($EDITOR)

### Theme & Aesthetics
- `SUPER + SHIFT + CTRL + SPACE` – Theme menu (dark/light toggle)
- `SUPER + CTRL + SPACE` – Next wallpaper
- `SUPER + SHIFT + SPACE` – Toggle Waybar
- `SUPER + SHIFT + BACKSPACE` – Toggle workspace gaps

### Screenshots & Recording
- `PRINT` – Screenshot full screen
- `SHIFT + PRINT` – Screenshot area (with slurp)
- `SUPER + PRINT` – Color picker
- `CTRL + PRINT` – Screen recording toggle

### Notifications (Mako)
- `SUPER + COMMA` – Dismiss last notification
- `SUPER + SHIFT + COMMA` – Dismiss all notifications
- `SUPER + CTRL + COMMA` – Toggle Do Not Disturb

### Toggles
- `SUPER + CTRL + I` – Toggle idle/auto-lock
- `SUPER + CTRL + N` – Toggle nightlight (warm colors)

### Window Management
- `SUPER + W` – Close window
- `SUPER + F` – Fullscreen
- `SUPER + T` – Toggle floating
- `SUPER + J` – Toggle split direction
- `SUPER + Arrow Keys` – Move focus
- `SUPER + SHIFT + Arrow Keys` – Swap windows
- `ALT + TAB` – Cycle windows

### Workspaces
- `SUPER + 1-9` – Switch to workspace 1-9
- `SUPER + SHIFT + 1-9` – Move window to workspace 1-9
- `SUPER + TAB` – Next workspace
- `SUPER + SHIFT + TAB` – Previous workspace
- `SUPER + S` – Toggle scratchpad

### Media Keys
- `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` – Volume
- `XF86AudioMute` – Mute toggle
- `XF86AudioPlay/Pause/Next/Prev` – Media controls (playerctl)
- `XF86MonBrightnessUp/Down` – Screen brightness

### Mouse
- `SUPER + Left Click` – Move window
- `SUPER + Right Click` – Resize window
- `SUPER + Scroll` – Switch workspace

## Menu System

Press `SUPER + ALT + SPACE` to open the main menu:

### 󰀻 Apps
Launch applications using Walker or Wofi

### 󰧑 Learn
- Keybindings viewer
- Hyprland wiki
- Void Linux docs
- Bash cheatsheet

### 󱓞 Trigger
**Capture:**
- Screenshot (full/area)
- Color picker
- Screen recording

**Share:**
- Clipboard text
- File/folder paths

**Toggle:**
- Idle lock
- Nightlight
- Waybar

### Style
- Theme switcher (Dark/Light/Toggle)
- Background cycler
- Font info

### Setup
- Audio (pavucontrol)
- WiFi (nmtui)
- Bluetooth (blueman/bluetoothctl)
- Power profiles
- Monitors (wdisplays)
- Config file editor

### 󰉉 Install
- Package installer (xbps)
- Web apps
- Dev environments (Node, Python, Rust, Go)

### 󰭌 Remove
- Package removal (xbps)
- Orphan cleanup

### Update
- System update (xbps-install -Syu)
- Config reload
- Restart services (Waybar, Mako, Hyprpaper)

### About
System information display

### System
- Lock
- Suspend
- Restart
- Shutdown

## Theme Switching

HyprVoid includes two Catppuccin themes:

- **Dark** – Catppuccin Mocha (default)
- **Light** – Catppuccin Latte

### Switch themes:
```bash
hyprvoid-theme-set dark    # Switch to dark
hyprvoid-theme-set light   # Switch to light
hyprvoid-theme-set toggle  # Toggle between themes
```

Or use: `SUPER + SHIFT + CTRL + SPACE` → Theme menu

Theme switching updates:
- Hyprland colors and borders
- Wofi menu style
- Waybar style
- Wallpapers (from theme-specific directories)

## Wallpapers

Wallpapers are organized by theme:
- `~/Pictures/Wallpapers/dark/` – Dark theme wallpapers
- `~/Pictures/Wallpapers/light/` – Light theme wallpapers

### Cycle wallpapers:
- Press `SUPER + CTRL + SPACE`
- Or use menu: HyprVoid Menu → Style → Background

Supported formats: PNG, JPG, JPEG

## Configuration Files

HyprVoid uses a modular configuration structure:

```
~/.config/hypr/
├── hyprland.conf          # Main config (sources others)
├── keybindings.conf          # All keybindings
├── looknfeel.conf         # Theme pointer
├── looknfeel-dark.conf    # Catppuccin Mocha
├── looknfeel-light.conf   # Catppuccin Latte
└── autostart.conf         # Startup programs
```

### Edit configs:
- `SUPER + ALT + SPACE` → Setup → Config Files
- Or manually: `$EDITOR ~/.config/hypr/keybindings.conf`

## Dependencies

### Required (auto-installed):
- hyprland, walker, waybar, wofi, mako
- alacritty (terminal)
- firefox (browser)
- thunar (file manager)
- pipewire, wireplumber (audio)
- grim, slurp (screenshots)
- jq (JSON parsing)
- playerctl (media controls)
- brightnessctl (brightness)

### Optional (install as needed):
- `hypridle`, `hyprlock` – Idle management and lock screen
- `hyprpaper` – Wallpaper daemon
- `hyprpicker` – Color picker
- `wf-recorder` – Screen recording
- `gammastep` or `hyprsunset` – Nightlight
- `pavucontrol` – Audio GUI
- `blueman` – Bluetooth GUI
- `wdisplays` – Monitor configuration GUI
- `nm-applet` – NetworkManager applet

## Customization

### Add custom keybindings:
Edit `~/.config/hypr/keybindings.conf` and add:
```
bind = $mod SHIFT, X, exec, my-command  #desc: My custom command
```

The `#desc:` tag makes it appear in the keybindings viewer (`SUPER+K`).

### Add custom autostart programs:
Edit `~/.config/hypr/autostart.conf` or create:
```bash
~/.config/hypr/autostart-user.sh
```

### Override settings:
Create `~/.config/hypr/custom.conf` with your overrides. This file is sourced last.

## Troubleshooting

### Keybinding not working?
1. Check: `hyprctl binds` to see loaded bindings
2. Reload config: `hyprctl reload`
3. View bindings: `SUPER+K`

### Theme not switching?
Ensure files exist:
```bash
ls ~/.config/hypr/looknfeel-*.conf
ls ~/.config/wofi/style-*.css
```

### Wallpaper not changing?
1. Add wallpapers to `~/Pictures/Wallpapers/dark/` or `/light/`
2. Supported: PNG, JPG, JPEG
3. Test: `hyprvoid-theme-bg-next`

### Menu not opening?
Check launcher: `which walker wofi`
Install: `sudo xbps-install -S walker wofi`

## Scripts Reference

All scripts are in `/home/stolenducks/hyprvoid/bin/` and `~/.local/bin/`:

- `hyprvoid-menu` – Main menu system
- `hyprvoid-menu-keybindings` – Keybindings viewer
- `hyprvoid-theme-set` – Theme switcher
- `hyprvoid-theme-bg-next` – Wallpaper cycler
- `hyprvoid-toggle-waybar` – Toggle status bar
- `hyprvoid-toggle-idle` – Toggle idle management
- `hyprvoid-toggle-nightlight` – Toggle nightlight
- `hyprvoid-toggle-gaps` – Toggle workspace gaps
- `hyprvoid-screenrecord` – Screen recording toggle

## Project Structure

```
hyprvoid/
├── bin/                    # All scripts
│   ├── hyprvoid-lib        # Shared library
│   ├── hyprvoid-menu*      # Menu scripts
│   └── hyprvoid-*          # Helper scripts
├── config/                 # Configuration templates
│   ├── hyprland.conf
│   ├── keybindings.conf
│   ├── looknfeel-*.conf
│   ├── autostart.conf
│   └── wofi-style-*.css
├── install.sh              # Installer
└── README-COMPLETE.md      # This file
```

## License

MIT

## Credits

- Inspired by [Omarchy](https://omarchy.org) by DHH
- [Hyprland](https://hyprland.org/)
- [Walker](https://github.com/abenz1267/walker)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
- [Void Linux](https://voidlinux.org/)

## Contributing

Issues and PRs welcome at [github.com/stolenducks/hyprvoid](https://github.com/stolenducks/hyprvoid)

---

**HyprVoid** – Minimal, elegant, powerful. Hyprland the Omarchy way, on Void Linux.
