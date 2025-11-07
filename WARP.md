# HyprVoid Project Rules for Warp AI

## Documentation-First Approach

**CRITICAL: Always consult documentation before making changes**

When working on HyprVoid, you MUST reference these documents in this order:

1. **docs/SYSTEM-REFERENCE.md** (610 lines)
   - Read this FIRST to understand what components are active/unused
   - Contains full tech stack, architecture, and file structure
   - Explains Walker vs Wofi resolution (Wofi is primary, Walker is unused)
   - Shows which files are templates vs active configs

2. **docs/DEVELOPER-GUIDE.md** (902 lines)
   - Read this SECOND for HOW to make changes
   - Contains exact patterns for editing menus
   - Real example: System menu fix walkthrough
   - Icon system, testing procedures, git workflow

3. **docs/menu-system.md**
   - Menu architecture details
   - Menu hierarchy reference

4. **docs/keybindings.md**
   - Complete keybinding reference
   - Check before adding new keybindings

## Critical System Knowledge

### Menu System
- **Primary launcher**: Wofi (styled with custom theme)
- **Walker**: Installed but NOT used (kept for reference only)
- **Menu location**: `bin/hyprvoid-menu` (single 400-line file)
- **Styling**: Blue borders (#89b4fa), no rounded corners, centered
- **Toggle behavior**: All menus support pressing keybinding again to close

### Active vs Unused Components

**ACTIVE** ✅:
- All files in `bin/` (11 scripts)
- All files in `config/*.conf`
- `config/wofi-style-dark.css` and `config/wofi-style-light.css`
- Keybindings in `config/bindings.conf`

**UNUSED** ⚠️:
- `config/walker/*` - Reference only, NOT active
- Walker is not called by any keybinding

### Key Paths
- **Repository**: `/home/stolenducks/hyprvoid/`
- **Active config**: `~/.config/hypr/` (copied from repo)
- **Active wofi**: `~/.config/wofi/` (copied from repo)
- **Scripts**: `~/.local/bin/` (copied from repo)

## Code Standards

### Menu Development Pattern
```bash
show_[name]_menu() {
  # 1. Prevent multiple instances (toggle behavior)
  if pgrep -f "dmenu.*Menu Prompt" >/dev/null 2>&1; then
    pkill -f "dmenu.*Menu Prompt"
    exit 0
  fi
  
  # 2. Define options with icons (2 spaces after icon)
  local options="󰀻  Option One
  Option Two"
  
  # 3. Show menu and capture choice
  local choice
  choice=$(echo "$options" | dmenu "Menu Prompt")
  
  # 4. Handle selection with case statement
  case "$choice" in
    *Option\ One*) action_here ;;
  esac
}
```

### Icon Standards
- Use Nerd Font glyphs
- Always 2 spaces after icon: `"󰍃  Lock"`
- Test icon in terminal first: `echo "󰍃  Test"`
- Reference: https://www.nerdfonts.com/cheat-sheet
- Look at existing menus for working icons

### Testing Requirements

**Before ANY commit**:
1. Test the changed menu with actual keybinding
2. Test toggle behavior (press keybinding twice)
3. Verify icons display correctly
4. Verify blue borders and centered positioning
5. Test related menus still work
6. No error notifications

### File Editing Rules

**When editing menus**:
1. Find function in `bin/hyprvoid-menu`
2. Menu functions: `show_[name]_menu()`
3. Main menu: line 16, System menu: line 344
4. Follow existing pattern exactly
5. Add toggle prevention if missing

**When editing configs**:
1. Edit in repo: `config/`
2. Copy to active: `~/.config/hypr/`
3. Reload: `hyprctl reload`
4. Test immediately

**When editing scripts**:
1. Edit in repo: `bin/`
2. Copy to active: `~/.local/bin/`
3. Make executable: `chmod +x`
4. Test immediately

## Git Workflow Requirements

### Commit Messages
Format:
```
Short summary (50 chars max)

Detailed explanation:
- Bullet points
- Testing notes
```

Good examples:
- "Fix system menu icons and logout behavior"
- "Add network configuration menu"

Bad examples:
- "Fixed stuff"
- "Update"

### Before Pushing
- [ ] All tests passed
- [ ] Documentation updated (if needed)
- [ ] Commit message is descriptive
- [ ] Changes match established patterns

## Common Mistakes to Avoid

### DO NOT:
1. ❌ Remove `config/wofi/` - It contains critical style templates
2. ❌ Assume Walker is being used - It's not (Wofi is primary)
3. ❌ Edit files without testing immediately
4. ❌ Commit without descriptive message
5. ❌ Change styling without verifying blue borders remain
6. ❌ Add menu without toggle prevention
7. ❌ Use inconsistent icon spacing

### DO:
1. ✅ Read SYSTEM-REFERENCE.md before any work
2. ✅ Follow DEVELOPER-GUIDE.md patterns exactly
3. ✅ Test with actual keybindings, not just mentally
4. ✅ Check existing menus for working patterns
5. ✅ Verify styling after every change
6. ✅ Update documentation if you add features
7. ✅ Use 2 spaces after icons consistently

## System Customization History & Critical Notes

### Cursor Theme Setup (2025-11-07)
**CRITICAL: Bibata-Modern-Classic cursor is installed and configured**

**Location**: `~/.local/share/icons/Bibata-Modern-Classic/`

**Configuration files**:
1. `~/.config/hypr/hyprland.conf` - Line 8: `env = XCURSOR_THEME,Bibata-Modern-Classic`
2. `~/.config/hypr/autostart.conf` - Line 33: `exec-once = hyprctl setcursor Bibata-Modern-Classic 24`
3. `~/.config/gtk-3.0/settings.ini` - `gtk-cursor-theme-name=Bibata-Modern-Classic`

**To apply cursor immediately**: `hyprctl setcursor Bibata-Modern-Classic 24`

### Wallpaper Setup (2025-11-07)
**CRITICAL: Custom wallpaper configured with hyprpaper**

**Active wallpaper**: `~/Pictures/wallpapers/fabrizio-conti-z2BCD8Bgd9M-unsplash.jpg`

**Configuration**:
- `~/.config/hypr/hyprpaper.conf` - Contains preload and wallpaper directives
- `~/.config/hypr/autostart.conf` - Line 14: `exec-once = hyprpaper` (ENABLED)
- `~/.config/hypr/autostart.conf` - Line 30: Theme wallpaper script DISABLED (was overriding custom wallpaper)

**IMPORTANT**: The `hyprvoid-theme-bg-next` script is disabled to prevent it from overriding custom wallpapers.

### Power Management Fix (2025-11-07)
**CRITICAL: Void Linux uses elogind/loginctl, NOT systemd**

**Problem**: System menu Suspend/Restart/Shutdown were failing because script used `systemctl` commands

**Solution**: Updated `~/hyprvoid/bin/hyprvoid-menu` (lines 365-379) to use:
- **Suspend**: `loginctl suspend` (no sudo required)
- **Restart**: `loginctl reboot` (no sudo required)
- **Shutdown**: `loginctl poweroff` (no sudo required)

**Why this matters**:
- Void Linux does NOT have `systemd` or `systemctl`
- Void uses **runit** as init system and **elogind** for session management
- `loginctl` is part of elogind and works without sudo permissions
- Commands like `sudo reboot` require password prompt which breaks menu system

**File location**: `/home/stolenducks/hyprvoid/bin/hyprvoid-menu`
**Symlink**: `~/.local/bin/hyprvoid-menu` → `/home/stolenducks/hyprvoid/bin/hyprvoid-menu`

**Testing power management**:
```bash
# Verify loginctl is available
which loginctl
loginctl --help | grep -E "suspend|reboot|poweroff"

# Test system menu
hyprvoid-menu system
```

### Waybar Power Icon (2025-11-07)
**Configuration**: `~/.config/waybar/config.jsonc` line 72: `"on-click": "hyprvoid-menu system"`

**To restart waybar**: `pkill waybar && waybar &`

## Current System State

- **System**: Working beautifully ✅
- **Menus**: Styled wofi with blue borders
- **Keybindings**: SUPER+SPACE (apps), SUPER+ALT+SPACE (main menu), SUPER+ESC (system menu)
- **Theme**: HyprVoid Default (sharp blue borders, no rounding)
- **Cursor**: Bibata-Modern-Classic (installed and configured)
- **Wallpaper**: Custom image via hyprpaper
- **Power Management**: loginctl-based (Void Linux compatible)
- **Scripts**: 11 active in `bin/`
- **Last verified**: 2025-11-07

## Quick Reference

### Essential Files
- `bin/hyprvoid-menu` - All menu functions
- `bin/hyprvoid-lib` - Shared utilities (dmenu(), notify(), etc.)
- `config/bindings.conf` - All keybindings
- `config/wofi-style-dark.css` - Menu styling template
- `~/.config/wofi/style.css` - Active menu styling

### Key Commands
```bash
# Edit menu
nano bin/hyprvoid-menu

# Copy to active
cp bin/hyprvoid-menu ~/.local/bin/

# Reload config
hyprctl reload

# Test menu
~/.local/bin/hyprvoid-menu
```

## Documentation Update Policy

**When you make changes, update relevant docs:**
- Added/removed components → SYSTEM-REFERENCE.md
- New patterns/procedures → DEVELOPER-GUIDE.md
- Changed menu hierarchy → menu-system.md
- New keybindings → keybindings.md

**Commit documentation separately or with code changes.**

---

*These rules ensure consistency and prevent breaking the working system. Always reference documentation before making changes.*
