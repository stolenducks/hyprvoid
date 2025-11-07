# HyprVoid Troubleshooting & Customization Guide

## Table of Contents
1. [Cursor Theme Issues](#cursor-theme-issues)
2. [Wallpaper Issues](#wallpaper-issues)
3. [Power Management Issues](#power-management-issues)
4. [Menu System Issues](#menu-system-issues)
5. [Common Customizations](#common-customizations)

---

## Cursor Theme Issues

### Symptom: Cursor reverts to default after restart

**Root Cause**: Environment variables not set or cursor not applied at startup.

**Solution**: Verify these three configuration points:

1. **Hyprland environment variable** (`~/.config/hypr/hyprland.conf`):
   ```conf
   env = XCURSOR_THEME,Bibata-Modern-Classic
   env = XCURSOR_SIZE,24
   ```

2. **Autostart command** (`~/.config/hypr/autostart.conf`):
   ```conf
   exec-once = hyprctl setcursor Bibata-Modern-Classic 24
   ```

3. **GTK configuration** (`~/.config/gtk-3.0/settings.ini`):
   ```ini
   [Settings]
   gtk-cursor-theme-name=Bibata-Modern-Classic
   gtk-cursor-theme-size=24
   ```

**Verify cursor is installed**:
```bash
ls ~/.local/share/icons/Bibata-Modern-Classic/
```

**Apply immediately without restart**:
```bash
hyprctl setcursor Bibata-Modern-Classic 24
```

### Installing a different cursor theme

1. Download cursor theme to `~/.local/share/icons/`
2. Update all three configuration files above with new cursor name
3. Reload: `hyprctl reload`
4. Apply: `hyprctl setcursor YourCursorName 24`

---

## Wallpaper Issues

### Symptom: Wallpaper disappears or reverts after restart

**Root Cause**: Theme script overriding custom wallpaper or hyprpaper not starting.

**Solution**: 

1. **Verify hyprpaper config** (`~/.config/hypr/hyprpaper.conf`):
   ```conf
   preload = ~/Pictures/wallpapers/your-wallpaper.jpg
   wallpaper = ,~/Pictures/wallpapers/your-wallpaper.jpg
   ```
   Note: The comma (`,`) before path means "all monitors"

2. **Verify hyprpaper is enabled** (`~/.config/hypr/autostart.conf`):
   ```conf
   exec-once = hyprpaper
   ```
   Should NOT be commented out with `#`

3. **Verify theme script is disabled** (`~/.config/hypr/autostart.conf`):
   ```conf
   # exec-once = ~/.local/bin/hyprvoid-theme-bg-next
   ```
   Should BE commented out if using custom wallpaper

**Apply wallpaper immediately**:
```bash
pkill hyprpaper
hyprpaper &
```

**Check if hyprpaper is running**:
```bash
pgrep hyprpaper
hyprctl hyprpaper listactive
```

### Symptom: Black screen after setting wallpaper

**Root Cause**: Running `hyprpaper` in foreground blocks terminal.

**Solution**: Always run hyprpaper in background:
```bash
hyprpaper &
```

Or just restart Hyprland: `SUPER+SHIFT+R` or log out/in.

### Changing wallpaper

1. Copy image to `~/Pictures/wallpapers/`
2. Edit `~/.config/hypr/hyprpaper.conf`
3. Restart hyprpaper: `pkill hyprpaper && hyprpaper &`

---

## Power Management Issues

### Symptom: Restart/Shutdown don't work from system menu

**Root Cause**: CRITICAL - Void Linux does NOT use systemd!

**Background**:
- Void Linux uses **runit** as init system
- Session management uses **elogind**, not systemd-logind
- Commands like `systemctl` DO NOT EXIST on Void
- Using `sudo reboot` fails because it prompts for password (breaks menu)

**Solution**: Use `loginctl` commands (no sudo required!)

**Correct commands** in `~/hyprvoid/bin/hyprvoid-menu`:
```bash
# System menu function (lines 365-379)
case "$choice" in
  *Lock*)
    if confirm "Exit Hyprland?"; then
      hyprctl dispatch exit
    fi
    ;;
  *Suspend*)
    if confirm "Suspend system?"; then
      loginctl suspend
    fi
    ;;
  *Restart*)
    if confirm "Restart system?"; then
      loginctl reboot
    fi
    ;;
  *Shutdown*)
    if confirm "Shutdown system?"; then
      loginctl poweroff
    fi
    ;;
esac
```

**WRONG commands** (do not use):
- ❌ `systemctl suspend` - systemctl doesn't exist on Void
- ❌ `systemctl reboot` - systemctl doesn't exist on Void
- ❌ `sudo reboot` - requires password prompt (breaks menu)
- ❌ `sudo poweroff` - requires password prompt (breaks menu)

**Verify loginctl works**:
```bash
which loginctl
loginctl --help | grep -E "suspend|reboot|poweroff"
```

**Test system menu**:
```bash
hyprvoid-menu system
```

### Why loginctl works without sudo

The `loginctl` command uses elogind's session management, which allows unprivileged users to perform power operations on their own session. This is the standard way on Void Linux.

---

## Menu System Issues

### Symptom: Waybar power icon doesn't open menu

**Root Cause**: Waybar not restarted after config change.

**Solution**:
```bash
pkill waybar && waybar &
```

**Verify waybar config** (`~/.config/waybar/config.jsonc` line 70-74):
```json
"custom/power": {
  "format": "󰐥",
  "on-click": "hyprvoid-menu system",
  "tooltip": false
}
```

### Symptom: Menu opens but items don't work

**Root Cause**: Script errors or missing dependencies.

**Debug steps**:

1. **Test menu directly**:
   ```bash
   ~/.local/bin/hyprvoid-menu system
   ```

2. **Check for errors**:
   ```bash
   ~/.local/bin/hyprvoid-menu system 2>&1 | grep -i error
   ```

3. **Verify wofi is working**:
   ```bash
   echo -e "Test 1\nTest 2" | wofi --dmenu
   ```

4. **Check script is executable**:
   ```bash
   ls -la ~/.local/bin/hyprvoid-menu
   ```

5. **Verify symlink is correct**:
   ```bash
   ls -la ~/.local/bin/hyprvoid-menu
   # Should point to: /home/stolenducks/hyprvoid/bin/hyprvoid-menu
   ```

---

## Common Customizations

### Changing Cursor Theme

**Popular cursor themes for Void Linux**:
- Bibata Modern Classic (current)
- Adwaita (default)
- Breeze
- Capitaine Cursors

**Installation**:
```bash
# Manual installation from GitHub
cd ~/.local/share/icons
curl -LO https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Classic.tar.xz
tar -xf Bibata-Modern-Classic.tar.xz
rm Bibata-Modern-Classic.tar.xz
```

Then update configs as shown in [Cursor Theme Issues](#cursor-theme-issues).

### Changing Wallpaper

**Quick change**:
```bash
cp /path/to/your/image.jpg ~/Pictures/wallpapers/
nano ~/.config/hypr/hyprpaper.conf
# Update paths in file
pkill hyprpaper && hyprpaper &
```

**For multiple monitors**:
```conf
preload = ~/Pictures/wallpapers/monitor1.jpg
preload = ~/Pictures/wallpapers/monitor2.jpg
wallpaper = HDMI-A-1,~/Pictures/wallpapers/monitor1.jpg
wallpaper = eDP-1,~/Pictures/wallpapers/monitor2.jpg
```

Get monitor names:
```bash
hyprctl monitors
```

### Changing Theme Colors

**Theme files**:
- Dark: `~/.config/hypr/looknfeel-dark.conf`
- Light: `~/.config/hypr/looknfeel-light.conf`

**Example color change** (line 11 in looknfeel-dark.conf):
```conf
# Change from blue to red
col.active_border = rgba(f38ba8ff)  # Catppuccin red
# Original blue:
col.active_border = rgba(89b4faff)  # Catppuccin blue
```

Apply: `hyprctl reload`

---

## Quick Reference Commands

### Reload Configurations
```bash
# Reload Hyprland config
hyprctl reload

# Restart Waybar
pkill waybar && waybar &

# Restart hyprpaper
pkill hyprpaper && hyprpaper &

# Apply cursor immediately
hyprctl setcursor Bibata-Modern-Classic 24
```

### Check Status
```bash
# Check what's running
pgrep -a hyprpaper
pgrep -a waybar
pgrep -a wofi

# Check wallpaper
hyprctl hyprpaper listactive

# Check monitors
hyprctl monitors
```

### Test Components
```bash
# Test menu system
hyprvoid-menu system

# Test wofi
wofi --show drun

# Test loginctl
loginctl --help
```

---

## File Reference

### Critical Configuration Files

**Cursor**:
- `~/.config/hypr/hyprland.conf` (env variables)
- `~/.config/hypr/autostart.conf` (startup command)
- `~/.config/gtk-3.0/settings.ini` (GTK apps)

**Wallpaper**:
- `~/.config/hypr/hyprpaper.conf` (wallpaper config)
- `~/.config/hypr/autostart.conf` (enable/disable hyprpaper)

**Power Management**:
- `~/hyprvoid/bin/hyprvoid-menu` (system menu function)
- `~/.local/bin/hyprvoid-menu` (symlink to above)

**Waybar**:
- `~/.config/waybar/config.jsonc` (bar configuration)
- `~/.config/waybar/style.css` (bar styling)

---

## When Things Break

### Full System Reset

If everything is broken and you want to start fresh:

```bash
# Backup first!
cp -r ~/.config/hypr ~/.config/hypr.backup
cp -r ~/.config/waybar ~/.config/waybar.backup

# Reset to defaults
cd ~/hyprvoid
cp -r config/* ~/.config/hypr/
cp -r bin/* ~/.local/bin/
chmod +x ~/.local/bin/hyprvoid-*

# Reload
hyprctl reload
pkill waybar && waybar &
```

### Logs and Debugging

**Hyprland log**:
```bash
cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -1)/hyprland.log | tail -50
```

**Waybar log**:
```bash
pkill waybar
waybar > /tmp/waybar.log 2>&1 &
cat /tmp/waybar.log
```

**Test script with verbose output**:
```bash
bash -x ~/.local/bin/hyprvoid-menu system
```

---

## Getting Help

1. Check this troubleshooting guide first
2. Check `docs/SYSTEM-REFERENCE.md` for architecture
3. Check `docs/DEVELOPER-GUIDE.md` for development patterns
4. Search Hyprland wiki: https://wiki.hyprland.org/
5. Search Void Linux docs: https://docs.voidlinux.org/

---

*Last updated: 2025-11-07*
