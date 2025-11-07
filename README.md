# HyprVoid

> Hyprland-optimized desktop setup for Void Linux

**HyprVoid** is a streamlined Hyprland configuration designed specifically for Void Linux with:
- 🚀 **Walker** as primary app launcher (with Wofi fallback)
- 🎨 **Catppuccin Mocha** theming
- ⌨️ **Omarchy-style keybindings**
- 🔊 **PipeWire + WirePlumber** audio
- ⚡ **Fast and minimal** setup

## Requirements

- Void Linux (glibc)
- Wayland-capable GPU
- Internet connection for package installation

## Installation

```bash
git clone https://github.com/stolenducks/hyprvoid.git
cd hyprvoid
./install.sh
```

After installation:
1. Log out
2. At login manager, select **Hyprland** session
3. Log in

## Features

### Walker App Launcher
- Primary launcher with clean, fast UI
- Automatic fallback to Wofi if Walker unavailable
- Launch with `Super + Space`

### Catppuccin Mocha Theme
- Consistent dark theme across all components
- Blue accent colors (#89b4fa)
- Blurred backgrounds and smooth animations

### Omarchy Keybindings

| Key | Action |
|-----|--------|
| `Super + Space` | App launcher (Walker) |
| `Super + Alt + Space` | Actions menu (xbps package management) |
| `Super + Return` | Terminal (Alacritty) |
| `Super + W` | Close window |
| `Super + F` | Fullscreen |
| `Super + T` | Toggle floating |
| `Super + 1-9` | Switch workspace |
| `Super + Tab` | Next workspace |
| `Alt + Tab` | Cycle windows |
| `Print` | Screenshot |
| `Super + Escape` | Exit Hyprland |

### Audio Setup
- PipeWire + WirePlumber configured automatically
- Volume controls via media keys
- PulseAudio compatibility layer included

## Testing

After installation, verify everything works:

```bash
# Test launcher
~/.local/bin/hyprvoid-menu-apps

# Test Walker directly
walker

# Test Wofi fallback
wofi --show drun

# Test audio
wpctl status
pactl info

# Test terminal
alacritty
```

## Troubleshooting

### Walker shows "--maxheight" error
This has been fixed in the latest version. Update your scripts:
```bash
cd hyprvoid && git pull && ./install.sh
```

### Audio not working
Start audio services manually (temporary fix):
```bash
pipewire &
wireplumber &
```

Then log out and back in for permanent fix.

### Launcher doesn't open
Check if scripts are executable and in PATH:
```bash
ls -la ~/.local/bin/hyprvoid-*
echo $PATH | grep ".local/bin"
```

## Components

- **WM**: Hyprland 0.49.0+
- **Bar**: Waybar
- **Launcher**: Walker (primary), Wofi (fallback)
- **Terminal**: Alacritty
- **Notifications**: Mako
- **Wallpaper**: hyprpaper
- **Audio**: PipeWire + WirePlumber
- **Theme**: Catppuccin Mocha

## Project Structure

```
hyprvoid/
├── install.sh              # Main installer
├── test.sh                 # Diagnostic tool
├── fix.sh                  # Hyprland fixes
└── bin/
    ├── hyprvoid-menu-apps      # App launcher script
    └── hyprvoid-menu-actions   # xbps package manager menu
```

## License

MIT

## Credits

- Inspired by [Voidance](https://github.com/stolenducks/voidance)
- [Hyprland](https://hyprland.org/)
- [Walker](https://github.com/abenz1267/walker)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
- [Void Linux](https://voidlinux.org/)
