# HyprVoid

> Hyprland-optimized desktop setup for Void Linux

**HyprVoid** is a streamlined Hyprland configuration designed specifically for Void Linux with:
- 🚀 **Wofi** as primary menu system with custom theme
- 🎨 **HyprVoid Default** theming (sharp blue borders, dark aesthetic)
- ⌨️ **Omarchy-inspired keybindings**
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

### Menu System
- **Wofi-based** hierarchical menu system
- Sharp blue borders with dark, semi-transparent background
- Centered menus with icon support
- Quick access to apps, system controls, and settings
- Launch apps with `Super + Space`
- Full menu with `Super + Alt + Space`

### HyprVoid Default Theme
- Clean, sharp aesthetic with no rounded corners
- Blue accent colors (#89b4fa)
- Semi-transparent backgrounds
- Consistent styling across all menus

### Omarchy-Inspired Keybindings

| Key | Action |
|-----|--------|
| `Super + Space` | Launch applications (wofi) |
| `Super + Alt + Space` | HyprVoid menu (Apps, Learn, Trigger, Style, Setup, etc.) |
| `Super + Escape` | System menu (Lock, Logout, Reboot, Shutdown) |
| `Super + K` | Show keybindings reference |
| `Super + Return` | Terminal (Alacritty) |
| `Super + W` | Close window |
| `Super + F` | Fullscreen |
| `Super + T` | Toggle floating |
| `Super + 1-9` | Switch workspace |
| `Super + Tab` | Next workspace |
| `Alt + Tab` | Cycle windows |
| `Print` | Screenshot |

See [docs/keybindings.md](docs/keybindings.md) for complete keybinding reference.

### Audio Setup
- PipeWire + WirePlumber configured automatically
- Volume controls via media keys
- PulseAudio compatibility layer included

## Testing

After installation, verify everything works:

```bash
# Test menu system
~/.local/bin/hyprvoid-menu

# Test app launcher
wofi --show drun

# Test audio
wpctl status
pactl info

# Test terminal
alacritty
```

## Troubleshooting

### Menu doesn't appear styled
Reload Hyprland configuration:
```bash
hyprctl reload
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
- **Launcher**: Wofi (with custom HyprVoid theme)
- **Terminal**: Alacritty
- **Notifications**: Mako
- **Wallpaper**: hyprpaper
- **Audio**: PipeWire + WirePlumber
- **Theme**: HyprVoid Default (sharp blue borders, dark aesthetic)

## Project Structure

```
hyprvoid/
├── install.sh              # Main installer
├── bin/
│   ├── hyprvoid-menu       # Main hierarchical menu
│   ├── hyprvoid-lib        # Shared utilities
│   └── hyprvoid-*          # Various system scripts
├── config/
│   ├── bindings.conf       # Hyprland keybindings
│   ├── wofi-style-*.css    # Wofi theme templates
│   └── *.conf              # Hyprland configs
└── docs/
    ├── menu-system.md      # Menu system documentation
    ├── keybindings.md      # Keybinding reference
    └── project-structure.md # Project overview
```

See [docs/menu-system.md](docs/menu-system.md) for detailed menu documentation.

## License

MIT

## Credits

- Inspired by [Voidance](https://github.com/stolenducks/voidance)
- [Hyprland](https://hyprland.org/)
- [Wofi](https://hg.sr.ht/~scoopta/wofi)
- [Void Linux](https://voidlinux.org/)
