# HyprVoid Developer Guide

**Version**: 1.1  
**Last Updated**: 2025-11-08  

This guide explains how to work on HyprVoid as a developer or contributor. It covers code standards, menu system patterns, icon usage, testing procedures, and contribution workflows.

---

## ⚠️ CRITICAL: READ THIS FIRST

**PATH Issues in Menu-Invoked Scripts**

Scripts called from menus (SUPER+ALT+SPACE, etc.) do NOT have `~/.local/bin` in their PATH.

**The Problem**: A script works perfectly from terminal but fails when run from the menu.

**The Solution**: Always use absolute paths for custom scripts:

```bash
# ❌ WRONG - relies on PATH
if command -v my-script >/dev/null 2>&1; then
  my-script args
fi

# ✅ CORRECT - uses absolute path
if [[ -x "$HOME/.local/bin/my-script" ]]; then
  "$HOME/.local/bin/my-script" args
fi
```

**For complete details**: Read [PATH-ISSUE-CRITICAL.md](PATH-ISSUE-CRITICAL.md)

This issue caused Obsidian themes to fail from menus while working from terminal. It cost hours of debugging. Don't repeat this mistake.

---

## Table of Contents
1. [Getting Started](#getting-started)
2. [Code Standards](#code-standards)
3. [Menu System Development](#menu-system-development)
4. [Icon System](#icon-system)
5. [Testing Procedures](#testing-procedures)
6. [Git Workflow](#git-workflow)
7. [Common Tasks](#common-tasks)
8. [Troubleshooting Development Issues](#troubleshooting-development-issues)

---

## Getting Started

### Prerequisites
- Void Linux system
- Git installed
- Basic bash scripting knowledge
- Hyprland running
- Text editor (nano, vim, VSCode, etc.)

### Development Setup
```bash
# Clone the repo
git clone https://github.com/stolenducks/hyprvoid.git
cd hyprvoid

# Read the documentation first!
cat docs/SYSTEM-REFERENCE.md    # System architecture
cat docs/menu-system.md          # Menu system details
cat docs/DEVELOPER-GUIDE.md      # This file

# Make changes in the repo
# Test locally before committing
```

### Key Files to Know
- `bin/hyprvoid-menu` - Main menu system (400 lines)
- `bin/hyprvoid-lib` - Shared utilities
- `config/bindings.conf` - All keybindings
- `config/wofi-style-dark.css` - Menu styling

---

## Code Standards

### Bash Script Standards

**File Headers:**
```bash
#!/usr/bin/env bash
# HyprVoid [Script Name] - [Brief description]

set -Eeuo pipefail  # Strict error handling
```

**Sourcing hyprvoid-lib:**
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/hyprvoid-lib"
```

**Function Naming:**
- Use `snake_case`
- Prefix menu functions with `show_`: `show_system_menu()`
- Use descriptive names: `toggle_nightlight()` not `tn()`

**Variable Naming:**
- Use lowercase with underscores
- Use `local` for function variables
- Use descriptive names: `user_choice` not `c`

**Error Handling:**
```bash
# Check if command exists
if ! command -v wofi >/dev/null 2>&1; then
    notify "Error" "Wofi not found"
    return 1
fi

# Check if file exists
if [[ ! -f "$config_file" ]]; then
    log "ERROR: Config file not found: $config_file"
    return 1
fi
```

**Logging:**
```bash
# Use log() from hyprvoid-lib
log "INFO: Starting theme switch"
log "ERROR: Failed to reload config"
```

---

## Menu System Development

### Understanding the Menu Structure

All menus follow this pattern in `bin/hyprvoid-menu`:

```bash
show_[menu_name]_menu() {
  # 1. Optional: Prevent multiple instances (toggle behavior)
  if pgrep -f "dmenu.*Menu Prompt" >/dev/null 2>&1; then
    pkill -f "dmenu.*Menu Prompt"
    exit 0
  fi
  
  # 2. Define options with icons
  local options="󰀻  Option One
  Option Two
  Option Three"
  
  # 3. Show menu and capture choice
  local choice
  choice=$(echo "$options" | dmenu "Menu Prompt")
  
  # 4. Handle selection
  case "$choice" in
    *Option\ One*)
      # Action here
      ;;
    *Option\ Two*)
      # Action here
      ;;
  esac
}
```

### How to Find and Edit a Menu

**Step 1: Identify the menu you want to edit**
- SUPER+ALT+SPACE → Main menu
- SUPER+ESCAPE → System menu
- From main menu → Learn, Trigger, Style, Setup, etc.

**Step 2: Find the function in code**
```bash
# Open hyprvoid-menu
nano bin/hyprvoid-menu

# Search for the menu function
# Main menu: show_main_menu()
# System menu: show_system_menu()
# Style menu: show_style_menu()
# etc.
```

**Step 3: Understand the function structure**
- Line 1-7: Toggle prevention (if present)
- Line 8-12: Options with icons
- Line 13-16: dmenu() call
- Line 17+: case statement handling selections

### Example: How System Menu Was Fixed

**Problem Identified:**
1. Missing Lock icon
2. Lock didn't log out
3. No toggle behavior (couldn't close with SUPER+ESC)
4. Commands didn't work

**Solution Steps:**

**1. Located the function:**
```bash
# Found at line 343 in bin/hyprvoid-menu
# ========== SYSTEM MENU ==========
show_system_menu() {
```

**2. Added toggle prevention (copied from main menu):**
```bash
# Prevent multiple instances
if pgrep -f "dmenu.*System" >/dev/null 2>&1; then
  pkill -f "dmenu.*System"
  exit 0
fi
```

**3. Fixed icons (found working icon 󰍃):**
```bash
local options="󰍃  Lock
󰤄  Suspend
󰜉  Restart
󰐥  Shutdown"
```

**4. Fixed Lock action to exit Hyprland:**
```bash
*Lock*)
  if confirm "Exit Hyprland?"; then
    hyprctl dispatch exit
  fi
  ;;
```

**5. Ensured other options have confirmation and proper commands:**
```bash
*Suspend*)
  if confirm "Suspend system?"; then
    systemctl suspend
  fi
  ;;
```

### Adding a New Menu

**Example: Adding a "Network" menu**

**1. Add to main menu options:**
```bash
show_main_menu() {
  local options="󰀻  Apps
󰧑  Learn
󰖟  Network      # NEW
󱓞  Trigger
...
```

**2. Add case handler:**
```bash
case "$choice" in
  *Apps*)     show_apps_menu ;;
  *Learn*)    show_learn_menu ;;
  *Network*)  show_network_menu ;;  # NEW
  ...
esac
```

**3. Create the function:**
```bash
# ========== NETWORK MENU ==========
show_network_menu() {
  # Prevent multiple instances
  if pgrep -f "dmenu.*Network" >/dev/null 2>&1; then
    pkill -f "dmenu.*Network"
    exit 0
  fi
  
  local options="󰖩  WiFi Settings
󰂯  Bluetooth
󰩟  VPN"
  
  local choice
  choice=$(echo "$options" | dmenu "Network")
  
  case "$choice" in
    *WiFi*)
      run_in_terminal "nmtui"
      ;;
    *Bluetooth*)
      if command -v blueman-manager >/dev/null 2>&1; then
        blueman-manager &
      else
        run_in_terminal "bluetoothctl"
      fi
      ;;
    *VPN*)
      notify "VPN" "VPN configuration coming soon"
      ;;
  esac
}
```

**4. Add to main() entry point:**
```bash
main() {
  local menu="${1:-main}"
  
  case "$menu" in
    apps)     show_apps_menu ;;
    learn)    show_learn_menu ;;
    network)  show_network_menu ;;  # NEW
    ...
  esac
}
```

### Menu Pattern Reference

**Simple Action Menu:**
```bash
show_simple_menu() {
  local options="  Option 1
  Option 2"
  
  local choice
  choice=$(echo "$options" | dmenu "Prompt")
  
  case "$choice" in
    *Option\ 1*) command_here ;;
    *Option\ 2*) another_command ;;
  esac
}
```

**Submenu Pattern:**
```bash
show_parent_menu() {
  local options="  Submenu 1
  Submenu 2"
  
  local choice
  choice=$(echo "$options" | dmenu "Parent")
  
  case "$choice" in
    *Submenu\ 1*) show_submenu1 ;;
    *Submenu\ 2*) show_submenu2 ;;
  esac
}
```

**Confirmation Pattern:**
```bash
show_dangerous_menu() {
  local options="  Safe Action
  Dangerous Action"
  
  local choice
  choice=$(echo "$options" | dmenu "Warning")
  
  case "$choice" in
    *Dangerous*)
      if confirm "Are you sure?"; then
        dangerous_command
      fi
      ;;
  esac
}
```

---

## Icon System

### How Icons Work

Icons are **Nerd Font** glyphs embedded directly in the text strings.

**Icon Format:**
```bash
local options="󰀻  Apps"
#              ^^^^ This is a single Unicode character (Nerd Font icon)
```

### Finding Icons

**Method 1: Look at existing menus**
```bash
# See what icons are already working
grep "local options" bin/hyprvoid-menu
```

**Method 2: Nerd Font Cheat Sheet**
- Visit: https://www.nerdfonts.com/cheat-sheet
- Search for icon (e.g., "lock", "wifi")
- Copy the glyph
- Paste into your code

**Method 3: Test in terminal**
```bash
# See if icon renders
echo "󰍃  Lock"
echo "󰖟  Network"
```

### Common Icon Categories

**System:**
- `󰐥` Shutdown
- `󰜉` Restart
- `󰤄` Suspend
- `󰍃` Lock/Logout
- `󰐫` Power

**Network:**
- `󰖩` WiFi
- `󰖪` WiFi Off
- `󰂯` Bluetooth
- `󰩟` VPN

**Media:**
- `  Screenshot
- `  Camera
- `  Color Picker
- `  Record

**System Tools:**
- `󰌠` Terminal
- `  File Manager
- `󰣇` Package
- `  Settings

**UI Elements:**
- `󰀻` Apps/Grid
- `󰍜` Bar/Menu
- `  Clipboard
- `  Share

### Icon Best Practices

1. **Always test icons in terminal first**
   ```bash
   echo "󰍃  Test Icon" | wofi --dmenu
   ```

2. **Use consistent icons across similar functions**
   - WiFi menu → Use 󰖩 everywhere
   - Don't mix different WiFi icons

3. **Keep spacing consistent**
   ```bash
   # Good - two spaces after icon
   "󰍃  Lock"
   
   # Bad - inconsistent spacing
   "󰍃Lock"
   "󰍃   Lock"
   ```

4. **Test with your font**
   - HyprVoid uses "Noto Sans" + "Font Awesome 6 Free"
   - Some icons may not render with all fonts

5. **Fallback for missing icons**
   ```bash
   # If icon doesn't render, use emoji or text
   "🔒  Lock"  # Emoji fallback
   " Lock"   # Text only fallback
   ```

---

## Testing Procedures

### Before Committing ANY Changes

**1. Test the specific menu you changed:**
```bash
# Press the keybinding
SUPER+ESCAPE  # If you changed system menu

# Verify:
# - Menu appears with icons
# - All options are visible
# - Selection works
# - Action executes correctly
```

**2. Test toggle behavior:**
```bash
# Press keybinding twice
SUPER+ESCAPE
SUPER+ESCAPE  # Should close the menu

# Verify menu doesn't stack multiple instances
```

**3. Test related menus:**
```bash
# If you changed system menu, also test:
SUPER+ALT+SPACE  # Main menu
# Navigate to System option
# Verify it works
```

**4. Test styling:**
```bash
# Verify menus still have:
# - Blue borders (2px solid #89b4fa)
# - Centered positioning
# - Semi-transparent background
# - Sharp corners (no rounding)
```

**5. Check for errors:**
```bash
# Watch for notifications about missing commands
# Check logs
tail -f ~/.cache/hyprvoid/logs/*.log
```

### Testing Checklist

Before pushing to Git:

- [ ] Changed menu opens correctly
- [ ] All icons display properly
- [ ] Toggle behavior works (close on second press)
- [ ] All options execute correct commands
- [ ] Confirmation dialogs work (for dangerous actions)
- [ ] No error notifications appear
- [ ] Styling matches other menus (blue borders, centered)
- [ ] Related menus still work
- [ ] No duplicate menu instances can open
- [ ] Changes documented in commit message

### Testing Commands Directly

**Test wofi directly:**
```bash
echo -e "Option 1\nOption 2\nOption 3" | wofi --dmenu --prompt "Test"
```

**Test with styling:**
```bash
echo -e "󰍃  Lock\n󰤄  Suspend" | wofi --dmenu \
  --conf "${HOME}/.config/wofi/config" \
  --style "${HOME}/.config/wofi/style.css" \
  --prompt "Test"
```

**Test specific menu function:**
```bash
# Add this temporarily to your script
show_system_menu

# Run it
./bin/hyprvoid-menu
```

---

## Git Workflow

### Standard Development Flow

**1. Make changes in local repo:**
```bash
cd ~/hyprvoid
nano bin/hyprvoid-menu  # Edit files
```

**2. Test changes thoroughly** (see Testing Procedures)

**3. Check what changed:**
```bash
git status
git diff bin/hyprvoid-menu
```

**4. Stage changes:**
```bash
git add -A  # Stage all changes
# OR
git add bin/hyprvoid-menu  # Stage specific file
```

**5. Commit with descriptive message:**
```bash
git commit -m "Fix system menu icons and logout behavior

- Add toggle prevention to system menu
- Fix Lock option to exit Hyprland with confirmation  
- Use proper icon (󰍃) that renders correctly
- Test confirmed all options work"
```

**6. Push to GitHub:**
```bash
git push
```

### Commit Message Standards

**Format:**
```
Short summary (50 chars or less)

Detailed explanation of changes:
- Bullet point 1
- Bullet point 2
- Testing notes

Related issue: #123 (if applicable)
```

**Good commit messages:**
```
✅ "Fix system menu icons and logout behavior"
✅ "Add network configuration menu"
✅ "Update wofi theme - increase border width"
```

**Bad commit messages:**
```
❌ "Fixed stuff"
❌ "Update"
❌ "Changes"
```

### Reverting Changes

**If something breaks:**
```bash
# See recent commits
git log --oneline -5

# Revert last commit
git reset --hard HEAD~1

# Reload Hyprland to apply old config
hyprctl reload

# Force push to update remote
git push --force
```

**Emergency revert:**
```bash
# If you pushed broken changes
git log  # Find last good commit hash
git reset --hard <commit-hash>
git push --force

# ALWAYS test after reverting!
```

---

## Common Tasks

### Task: Change a Menu Icon

**1. Find the menu function:**
```bash
grep -n "show_system_menu" bin/hyprvoid-menu
```

**2. Locate the options string:**
```bash
local options="󰍃  Lock
󰤄  Suspend"
```

**3. Find new icon:**
- Visit: https://www.nerdfonts.com/cheat-sheet
- Search for desired icon
- Copy glyph

**4. Replace icon:**
```bash
local options="󰌾  Lock    # NEW ICON
󰤄  Suspend"
```

**5. Test, commit, push**

### Task: Add Menu Toggle Behavior

**Add this at the start of the menu function:**
```bash
show_your_menu() {
  # Prevent multiple instances
  if pgrep -f "dmenu.*Your Menu Prompt" >/dev/null 2>&1; then
    pkill -f "dmenu.*Your Menu Prompt"
    exit 0
  fi
  
  # Rest of menu code...
}
```

**Pattern explanation:**
- `pgrep -f "dmenu.*Your Menu Prompt"` - Check if menu is open
- Matches the prompt text used in dmenu() call
- If found, kill it and exit
- Pressing keybinding again closes menu

### Task: Add Confirmation to Action

**Wrap dangerous actions:**
```bash
case "$choice" in
  *Dangerous*)
    if confirm "Are you sure?"; then  # Uses confirm() from hyprvoid-lib
      dangerous_command
    fi
    ;;
esac
```

**The confirm() function:**
- Shows "Yes/No" dialog
- Returns 0 if Yes selected
- Returns 1 if No selected

### Task: Add New Script

**1. Create script:**
```bash
nano bin/hyprvoid-new-feature
```

**2. Use template:**
```bash
#!/usr/bin/env bash
# HyprVoid New Feature - Brief description

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/hyprvoid-lib"

main() {
  # Your code here
  log "INFO: New feature executed"
}

main "$@"
```

**3. Make executable:**
```bash
chmod +x bin/hyprvoid-new-feature
```

**4. Copy to ~/.local/bin:**
```bash
cp bin/hyprvoid-new-feature ~/.local/bin/
```

**5. Add keybinding (if needed):**
```bash
# Edit config/bindings.conf
bind = $mod, X, exec, ~/.local/bin/hyprvoid-new-feature  #desc: New feature
```

**6. Reload Hyprland:**
```bash
hyprctl reload
```

### Task: Update Documentation

**When you make changes, update:**

1. **SYSTEM-REFERENCE.md** - If you add/remove components
2. **DEVELOPER-GUIDE.md** - If you add new patterns or procedures
3. **menu-system.md** - If you change menu hierarchy
4. **keybindings.md** - If you add/change keybindings

**Documentation checklist:**
- [ ] Code change committed
- [ ] Relevant docs updated
- [ ] Examples added (if new feature)
- [ ] Testing procedures documented
- [ ] Docs committed separately or with code

---

## Troubleshooting Development Issues

### Menu doesn't appear

**Check:**
```bash
# Is wofi installed?
which wofi

# Can you run wofi manually?
echo "Test" | wofi --dmenu

# Check config files exist
ls -la ~/.config/wofi/

# Check logs
tail ~/.cache/hyprvoid/logs/*.log
```

### Icons don't display

**Check:**
```bash
# Test icon in terminal
echo "󰍃  Lock"

# Check if Nerd Fonts are installed
fc-list | grep -i nerd

# Install if missing
sudo xbps-install -S nerd-fonts-*
```

### Menu styling looks wrong

**Check:**
```bash
# Verify style.css exists and is correct
cat ~/.config/wofi/style.css | grep border

# Should see:
# border: 2px solid #89b4fa;

# Reload Hyprland
hyprctl reload
```

### Changes don't take effect

**Check:**
```bash
# Did you copy to ~/.local/bin?
cp bin/hyprvoid-menu ~/.local/bin/

# Is Hyprland using old config?
hyprctl reload

# Check which file Hyprland is using
ls -la ~/.config/hypr/bindings.conf
```

### Multiple menu instances open

**Add toggle prevention:**
```bash
if pgrep -f "dmenu.*Menu Name" >/dev/null 2>&1; then
  pkill -f "dmenu.*Menu Name"
  exit 0
fi
```

---

## Style Guide Summary

### Menu Functions
- Name: `show_[name]_menu()`
- Add toggle prevention
- Use icons with 2 spaces after
- Use `dmenu()` from hyprvoid-lib
- Handle selections with case statement
- Add confirmation for dangerous actions

### Code Style
- Use bash strict mode: `set -Eeuo pipefail`
- Source hyprvoid-lib for utilities
- Use `local` for function variables
- Log important actions
- Check command existence before using

### Testing
- Test every change before committing
- Verify toggle behavior
- Check styling matches other menus
- Test on actual system, not just mentally

### Git
- Descriptive commit messages
- Test before pushing
- Document changes
- Update relevant docs

---

## Quick Reference

### Essential Commands
```bash
# Edit menu
nano bin/hyprvoid-menu

# Copy to active location
cp bin/hyprvoid-menu ~/.local/bin/

# Reload Hyprland
hyprctl reload

# Test menu manually
~/.local/bin/hyprvoid-menu

# Check logs
tail -f ~/.cache/hyprvoid/logs/*.log
```

### Key Files
- `bin/hyprvoid-menu` - All menus
- `bin/hyprvoid-lib` - Shared utilities
- `config/bindings.conf` - Keybindings
- `~/.config/wofi/style.css` - Menu styling

### Important Patterns
- Toggle: Check pgrep, kill if found
- Icons: Use Nerd Fonts, 2 spaces after
- Confirm: Wrap dangerous actions
- Log: Use log() from hyprvoid-lib

---

*This guide should be updated whenever new patterns or procedures are established. Keep it current!*
