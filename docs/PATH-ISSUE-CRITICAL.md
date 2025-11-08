# CRITICAL: PATH Issue in Menu-Invoked Scripts

**Date**: 2025-11-08  
**Severity**: CRITICAL  
**Affected**: All scripts called from `hyprvoid-menu` that invoke other scripts in `~/.local/bin`

## The Problem

When scripts are invoked from the Hyprland menu system (wofi/dmenu), they **DO NOT** have the same PATH environment as your terminal shell.

### What Happened

**Symptom**: Running `hyprvoid-theme-set osaka-jade` from terminal worked perfectly (waybar, obsidian, etc. all changed themes). Running it from the menu (SUPER+ALT+SPACE → Style → Themes) only changed waybar, not obsidian.

**Root Cause**: 
- `hyprvoid-theme-set-obsidian` calls `obsidian-theme switch <theme-name>`
- `obsidian-theme` is located at `~/.local/bin/obsidian-theme`
- When running from terminal: `~/.local/bin` is in PATH ✅
- When running from menu: `~/.local/bin` is NOT in PATH ❌
- The script used `command -v obsidian-theme` which failed silently
- Obsidian CSS files were never copied

**Evidence from log** (`~/.cache/hyprvoid/log`):
```
[2025-11-08 00:01:34] Calling obsidian-theme switch osaka-jade
[2025-11-08 00:01:34] obsidian-theme command not found  ← Menu invocation
[2025-11-08 00:02:58] obsidian-theme switch completed    ← Terminal invocation
```

## The Fix

Changed from relying on PATH:
```bash
if command -v obsidian-theme >/dev/null 2>&1; then
  obsidian-theme switch "$HYPRVOID_THEME"  # ❌ Fails in menu context
fi
```

To using absolute paths:
```bash
if [[ -x "$HOME/.local/bin/obsidian-theme" ]]; then
  "$HOME/.local/bin/obsidian-theme" switch "$HYPRVOID_THEME"  # ✅ Always works
fi
```

**File**: `/home/stolenducks/hyprvoid/bin/hyprvoid-theme-set-obsidian`  
**Lines**: 23-28

## Critical Rules for All Menu-Invoked Scripts

### Rule 1: NEVER rely on PATH for custom scripts
❌ **WRONG**:
```bash
my-custom-script args
command -v my-custom-script
which my-custom-script
```

✅ **CORRECT**:
```bash
"$HOME/.local/bin/my-custom-script" args
[[ -x "$HOME/.local/bin/my-custom-script" ]]
```

### Rule 2: System binaries are OK
These are safe because they're in system PATH that menus inherit:
```bash
# These work fine in menus:
notify-send "Title" "Message"
hyprctl reload
pkill waybar
sed -i 's/foo/bar/' file.txt
```

### Rule 3: Scripts calling other scripts
When one HyprVoid script needs to call another:

❌ **WRONG**:
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
some-other-hyprvoid-script  # Relies on PATH
```

✅ **CORRECT**:
```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
"$SCRIPT_DIR/some-other-hyprvoid-script"  # Uses SCRIPT_DIR
# OR
"$HOME/.local/bin/some-other-hyprvoid-script"  # Absolute path
```

### Rule 4: Testing requirements
When adding new theme scripts that call other commands:

1. **Test from terminal**: `hyprvoid-theme-set <theme>`
2. **Test from menu**: SUPER+ALT+SPACE → Style → Themes → select theme
3. **Check logs**: `tail -f ~/.cache/hyprvoid/log`
4. **Verify**: All target applications changed (waybar, obsidian, vscode, etc.)

If it works from terminal but not from menu → PATH issue.

## How to Debug PATH Issues

Add debug logging to any script called from menus:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

# Add this at the top
LOG_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/hyprvoid/log"
mkdir -p "$(dirname "$LOG_FILE")"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] SCRIPT_NAME STARTED" >> "$LOG_FILE"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] PATH=$PATH" >> "$LOG_FILE"

# Before calling external commands
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Calling some-command with args" >> "$LOG_FILE"
if command -v some-command >/dev/null 2>&1; then
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] some-command found" >> "$LOG_FILE"
else
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] some-command NOT FOUND" >> "$LOG_FILE"
fi
```

Then:
1. Run from menu
2. Check: `tail -20 ~/.cache/hyprvoid/log`
3. Look for "NOT FOUND" messages
4. Replace with absolute paths

## Why This Happens

**Terminal context**:
- Inherits shell environment from `.bashrc`, `.bash_profile`, etc.
- PATH typically includes: `/home/user/.local/bin:/usr/local/bin:/usr/bin:/bin`
- Custom scripts in `~/.local/bin` are found

**Menu context** (wofi launched via keybinding):
- Inherits environment from Hyprland compositor
- PATH is minimal: `/usr/local/bin:/usr/bin:/bin` (system paths only)
- Custom scripts in `~/.local/bin` are NOT found

## Affected Scripts Checklist

Current HyprVoid scripts that call other scripts:

- [x] `hyprvoid-theme-set` → calls `hyprvoid-theme-set-*` (uses `$SCRIPT_DIR` ✅)
- [x] `hyprvoid-theme-set-obsidian` → calls `obsidian-theme` (FIXED: now uses absolute path ✅)
- [ ] `hyprvoid-theme-set-vscode` → check if it calls any custom scripts
- [ ] `hyprvoid-theme-set-terminal` → check if it calls any custom scripts
- [ ] `hyprvoid-theme-set-gtk` → check if it calls any custom scripts

When adding new theme setters for other apps, follow the patterns above.

## Prevention for Future Scripts

**Template for new theme setter scripts**:

```bash
#!/usr/bin/env bash
# HyprVoid Theme Setter for <APP-NAME>
set -Eeuo pipefail

# Get current hyprvoid theme
CURRENT_THEME_LINK="$HOME/.config/hyprvoid/current/theme"
if [[ -L "$CURRENT_THEME_LINK" ]]; then
  HYPRVOID_THEME=$(basename "$(readlink "$CURRENT_THEME_LINK")")
else
  exit 0
fi

# If calling another custom script, use absolute path:
if [[ -x "$HOME/.local/bin/app-theme-switcher" ]]; then
  "$HOME/.local/bin/app-theme-switcher" switch "$HYPRVOID_THEME"
fi

# System commands work fine:
notify-send "Theme Applied" "Switched to $HYPRVOID_THEME"
```

## Summary

**The Golden Rule**: In scripts called from menus, ALWAYS use absolute paths for custom scripts in `~/.local/bin`.

This issue cost significant debugging time. Do not repeat this mistake.
