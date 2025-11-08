# HyprVoid Keybindings Reference

Complete keyboard shortcut reference for HyprVoid.

## Quick Reference Card

### Essential Shortcuts

| Keybinding | Action |
|------------|--------|
| `SUPER + SPACE` | Launch applications |
| `SUPER + ALT + SPACE` | HyprVoid menu |
| `SUPER + RETURN` | Open terminal |
| `SUPER + W` | Close window |
| `SUPER + ESCAPE` | System menu |

## Complete Keybinding List

### Clipboard (Omarchy-style)

Universal copy/paste keybindings that work across all applications. The commands send standardized X11 signals (`CTRL+Insert`, `SHIFT+Insert`) which are recognized by most Linux apps.

|| Keybinding | Action | Description |
||------------|--------|-------------|
|| `SUPER + C` | Copy | Copies selection (sends CTRL+Insert) |
|| `SUPER + V` | Paste | Pastes from clipboard (sends SHIFT+Insert) |
|| `SUPER + X` | Cut | Cuts selection (sends CTRL+X) |

**Terminal (Ghostty)**: You can also use `CTRL+Insert`, `SHIFT+Insert`, `CTRL+SHIFT+C`, and `CTRL+SHIFT+V` directly in the terminal.

### Menus & Launchers

|| Keybinding | Action | Description |
||------------|--------|-------------|
|| `SUPER + SPACE` | Launch Apps | Opens wofi application launcher |
| `SUPER + ALT + SPACE` | HyprVoid Menu | Opens main hierarchical menu |
| `SUPER + ESCAPE` | System Menu | Power options (lock, logout, reboot, shutdown) |
| `SUPER + K` | Keybindings | Shows this keybinding reference |
| `SUPER + CTRL + E` | Emoji Picker | Opens emoji/symbol picker (walker) |
| `XF86Calculator` | Calculator | Opens calculator app |

### Applications

| Keybinding | Action | Description |
|------------|--------|-------------|
| `SUPER + RETURN` | Terminal | Opens Alacritty terminal |
| `SUPER + SHIFT + B` | Browser | Opens Firefox |
| `SUPER + SHIFT + F` | File Manager | Opens Thunar |
| `SUPER + SHIFT + N` | Editor | Opens text editor |
| `SUPER + SHIFT + T` | System Monitor | Opens btop in terminal |

### Window Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `SUPER + W` | Close Window | Kills active window |
| `SUPER + F` | Fullscreen | Toggle fullscreen mode |
| `SUPER + T` | Toggle Floating | Float/tile current window |
| `SUPER + J` | Toggle Split | Change split direction |
| `SUPER + P` | Pseudo Tile | Pseudo-tiling mode |
| `SHIFT + F11` | Force Fullscreen | Force fullscreen (no gaps) |
| `ALT + F11` | Maximize | Maximize window |

### Window Focus (Arrow Keys)

| Keybinding | Action |
|------------|--------|
| `SUPER + LEFT` | Focus left |
| `SUPER + RIGHT` | Focus right |
| `SUPER + UP` | Focus up |
| `SUPER + DOWN` | Focus down |

### Window Focus (Vim Style)

| Keybinding | Action |
|------------|--------|
| `SUPER + H` | Focus left |
| `SUPER + L` | Focus right |
| `SUPER + K` | Focus up |

### Window Movement (Arrow Keys)

| Keybinding | Action |
|------------|--------|
| `SUPER + SHIFT + LEFT` | Swap left |
| `SUPER + SHIFT + RIGHT` | Swap right |
| `SUPER + SHIFT + UP` | Swap up |
| `SUPER + SHIFT + DOWN` | Swap down |

### Window Movement (Vim Style)

| Keybinding | Action |
|------------|--------|
| `SUPER + SHIFT + H` | Swap left |
| `SUPER + SHIFT + L` | Swap right |

### Window Resizing

| Keybinding | Action |
|------------|--------|
| `SUPER + -` | Shrink width |
| `SUPER + =` | Expand width |
| `SUPER + SHIFT + -` | Shrink height |
| `SUPER + SHIFT + =` | Expand height |

### Workspaces

| Keybinding | Action |
|------------|--------|
| `SUPER + 1-9` | Switch to workspace 1-9 |
| `SUPER + 0` | Switch to workspace 10 |
| `SUPER + TAB` | Next workspace |
| `SUPER + SHIFT + TAB` | Previous workspace |
| `SUPER + CTRL + TAB` | Last workspace |

### Move Window to Workspace

| Keybinding | Action |
|------------|--------|
| `SUPER + SHIFT + 1-9` | Move to workspace 1-9 |
| `SUPER + SHIFT + 0` | Move to workspace 10 |

### Scratchpad (Special Workspace)

| Keybinding | Action |
|------------|--------|
| `SUPER + S` | Toggle scratchpad |
| `SUPER + SHIFT + S` | Move window to scratchpad |

### Window Cycling

| Keybinding | Action |
|------------|--------|
| `ALT + TAB` | Cycle next window |
| `ALT + SHIFT + TAB` | Cycle previous window |

### Aesthetics & Theme

| Keybinding | Action | Description |
|------------|--------|-------------|
| `SUPER + SHIFT + SPACE` | Toggle Waybar | Show/hide top bar |
| `SUPER + CTRL + SPACE` | Next Background | Cycle wallpapers |
| `SUPER + SHIFT + CTRL + SPACE` | Theme Menu | Open style/theme menu |
| `SUPER + BACKSPACE` | Toggle Transparency | Toggle window opacity |
| `SUPER + SHIFT + BACKSPACE` | Toggle Gaps | Toggle workspace gaps |

### Notifications (Mako)

| Keybinding | Action |
|------------|--------|
| `SUPER + ,` | Dismiss last notification |
| `SUPER + SHIFT + ,` | Dismiss all notifications |
| `SUPER + CTRL + ,` | Toggle Do Not Disturb |

### System Toggles

| Keybinding | Action |
|------------|--------|
| `SUPER + CTRL + I` | Toggle idle/screen lock |
| `SUPER + CTRL + N` | Toggle nightlight |

### Screenshots & Recording

| Keybinding | Action |
|------------|--------|
| `PRINT` | Screenshot (fullscreen) |
| `SHIFT + PRINT` | Screenshot (area select) |
| `SUPER + PRINT` | Color picker |
| `CTRL + PRINT` | Screen record toggle |

### Media Keys

| Keybinding | Action |
|------------|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute toggle |
| `XF86AudioMicMute` | Mic mute |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioPause` | Play/pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |

### Brightness Keys

| Keybinding | Action |
|------------|--------|
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |

### Mouse Bindings

| Keybinding | Action |
|------------|--------|
| `SUPER + Left Click (hold)` | Move window |
| `SUPER + Right Click (hold)` | Resize window |
| `SUPER + Scroll Up` | Next workspace |
| `SUPER + Scroll Down` | Previous workspace |

### System Info

| Keybinding | Action |
|------------|--------|
| `SUPER + CTRL + T` | Show time/date |
| `SUPER + CTRL + B` | Show battery level |

## Customization

All keybindings are defined in `~/.config/hypr/keybindings.conf`. To customize:

1. Edit the file: `nano ~/.config/hypr/keybindings.conf`
2. Modify or add bindings following the format:
   ```
   bind = MODS, KEY, dispatcher, params
   ```
3. Reload Hyprland: `hyprctl reload`

### Example Custom Binding

```bash
# Add a custom keybinding to launch a specific app
bind = $mod, B, exec, firefox
```

## Tips

- **$mod** is defined as `SUPER` (Windows key)
- Most window operations use `SUPER + [key]`
- Moving/swapping windows adds `SHIFT`
- System actions typically use `SUPER + CTRL`
- You can chain multiple modifiers: `SUPER + SHIFT + CTRL + [key]`

## See Also

- [Menu System Documentation](menu-system.md)
- [Project Structure](project-structure.md)
- [Hyprland Keybinding Docs](https://wiki.hyprland.org/Configuring/Binds/)
