# HyprVoid Bin Directory Audit

This document explains what each script in `bin/` does and whether it's needed.

## ✅ ACTIVE SCRIPTS (Currently Used)

### Core Menu System
- **hyprvoid-menu** - Main hierarchical menu (SUPER+ALT+SPACE)
  - Used by: keybindings.conf line 11
  - Status: **KEEP** - Core functionality

- **hyprvoid-menu-keybindings** - Displays keybinding reference (SUPER+K)
  - Used by: keybindings.conf line 13
  - Status: **KEEP** - Core functionality

- **hyprvoid-launch-walker** - App launcher with wofi fallback (SUPER+SPACE)
  - Used by: keybindings.conf line 9
  - Status: **KEEP** - Actually used and has proper fallback

- **hyprvoid-lib** - Shared utilities for all scripts
  - Used by: All hyprvoid-* scripts
  - Status: **KEEP** - Critical dependency

### Theme & Appearance
- **hyprvoid-theme-set** - Switch between dark/light themes
  - Used by: hyprvoid-menu Style menu
  - Status: **KEEP** - Active feature

- **hyprvoid-theme-bg-next** - Cycle backgrounds (SUPER+CTRL+SPACE)
  - Used by: keybindings.conf line 27
  - Status: **KEEP** - Active feature

- **hyprvoid-toggle-waybar** - Toggle top bar (SUPER+SHIFT+SPACE)
  - Used by: keybindings.conf line 26
  - Status: **KEEP** - Active feature

- **hyprvoid-toggle-gaps** - Toggle workspace gaps (SUPER+SHIFT+BACKSPACE)
  - Used by: keybindings.conf line 30
  - Status: **KEEP** - Active feature

### System Toggles
- **hyprvoid-toggle-idle** - Toggle screen lock (SUPER+CTRL+I)
  - Used by: keybindings.conf line 40
  - Status: **KEEP** - Active feature

- **hyprvoid-toggle-nightlight** - Toggle nightlight (SUPER+CTRL+N)
  - Used by: keybindings.conf line 41
  - Status: **KEEP** - Active feature

### Media
- **hyprvoid-screenrecord** - Screen recording toggle (CTRL+PRINT)
  - Used by: keybindings.conf line 48
  - Status: **KEEP** - Active feature

## ❓ QUESTIONABLE SCRIPTS (Not directly used)

- **hyprvoid-backup** - Backup configuration
  - Used by: Nothing currently
  - Status: **MAYBE REMOVE** - Utility script, not core functionality

- **hyprvoid-restore** - Restore from backup
  - Used by: Nothing currently
  - Status: **MAYBE REMOVE** - Utility script, not core functionality

- **hyprvoid-symlink-configs** - Symlink management
  - Used by: Possibly install.sh
  - Status: **MAYBE REMOVE** - Installer utility

- **hyprvoid-test-walker** - Walker testing
  - Used by: Nothing (development only)
  - Status: **CAN REMOVE** - Development/testing only

- **hyprvoid-menu-actions** - Old menu system
  - Used by: Nothing (deprecated)
  - Status: **CAN REMOVE** - Superseded by hyprvoid-menu

- **hyprvoid-menu-apps** - Old app launcher
  - Used by: Nothing (deprecated)
  - Status: **CAN REMOVE** - Superseded by hyprvoid-launch-walker

## Recommendations

### Safe to Remove (3 files)
These are definitively unused:
1. `hyprvoid-test-walker` - Testing only
2. `hyprvoid-menu-actions` - Deprecated
3. `hyprvoid-menu-apps` - Deprecated

### Consider Removing (3 files)
These might be useful but aren't actively called:
1. `hyprvoid-backup` - Manual backup utility
2. `hyprvoid-restore` - Manual restore utility  
3. `hyprvoid-symlink-configs` - Installer helper

### Must Keep (11 files)
Core functionality that's actively used:
1. hyprvoid-menu
2. hyprvoid-menu-keybindings
3. hyprvoid-launch-walker
4. hyprvoid-lib
5. hyprvoid-theme-set
6. hyprvoid-theme-bg-next
7. hyprvoid-toggle-waybar
8. hyprvoid-toggle-gaps
9. hyprvoid-toggle-idle
10. hyprvoid-toggle-nightlight
11. hyprvoid-screenrecord

## Next Steps

Before removing anything:
1. Test that SUPER+SPACE still works (uses hyprvoid-launch-walker)
2. Test that all menu options work
3. Verify no other scripts call the ones we want to remove
4. Remove in a separate commit so we can easily revert if needed
