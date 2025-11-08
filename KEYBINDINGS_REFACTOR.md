# HyprVoid Keybindings Refactor - Complete

## What Changed

### Before
- Single large `config/bindings.conf` file with 160+ lines of keybindings
- All keybindings mixed together without clear organization
- Hard to find specific categories
- Copying keybindings changes to active config meant tracking updates

### After ✅
- **Single organized file** with all keybindings in one place
- **Clear sections** organized by category
- **One place to edit** at `~/.config/hypr/keybindings.conf`
- **Easy to maintain** - no need to jump between multiple files

## Final Structure

```
~/.config/hypr/
├── keybindings.conf          ← All keybindings in one organized file
└── hyprland.conf             ← Sources keybindings.conf
```

### Sections in keybindings.conf:
- Clipboard (SUPER+C/V/X, SUPER+CTRL+V for history)
- Applications (Terminal, Browser, Editor)
- Menus & Launchers (Wofi, HyprVoid menu)
- Window Management (Focus, floating, fullscreen)
- Window Focus & Movement (Arrow keys + Vim style)
- Window Resize
- Workspaces (1-10, navigation)
- Window Cycling (ALT+TAB)
- Media Keys (Volume, brightness, playback)
- Mouse Bindings
- Screenshots & Recording
- Notifications (Mako)
- System Toggles
- Aesthetics & Theme

## How to Use

### Change a Keybinding
1. Edit `~/.config/hypr/keybindings.conf`
2. Find the section you want to modify
3. Save
4. Run: `hyprctl reload`
5. Done! Changes are instant and system-wide

### Example: Change Terminal from SUPER+RETURN to SUPER+T
```bash
# Edit ~/.config/hypr/keybindings.conf
# Find the APPLICATIONS section and change:
bind = $mod, RETURN, exec, ghostty  #desc: Terminal (SUPER+RETURN)
# To:
bind = $mod, T, exec, ghostty  #desc: Terminal (SUPER+T)
```

### View All Keybindings
Press **SUPER+K** to see all keybindings with descriptions

### Add New Keybinding
1. Open `~/.config/hypr/keybindings.conf`
2. Find the appropriate section (e.g., SCREENSHOTS & RECORDING for screenshot variants)
3. Add: `bind = $mod SHIFT, Z, exec, command  #desc: Description (SUPER+SHIFT+Z)`
4. Save and `hyprctl reload`

## Clipboard Configuration

**Universal Wayland Clipboard System:**
- `SUPER+C` → Copy selection to clipboard (via hv-clip)
- `SUPER+V` → Paste universally using wtype (works everywhere!)
- `SUPER+X` → Cut selection (copy + delete)
- `SUPER+CTRL+V` → Open clipboard history menu (Wofi-styled)
- File: `~/.config/hypr/keybindings.conf` (CLIPBOARD section)

**How It Works:**
- **hv-clip**: Universal clipboard handler script
  - Copies PRIMARY selection → CLIPBOARD
  - Pastes via wtype (types content universally)
  - Location: `~/.local/bin/hv-clip`

- **hv-clip-watcher**: Smart clipboard history manager
  - Debounced to prevent keystroke pollution
  - Stores clipboard entries after 1-second stability
  - Persistent history via cliphist database
  - Auto-starts from `~/.config/hypr/autostart.conf`
  - Location: `~/.local/bin/hv-clip-watcher`

- **Clipboard History Menu**: 
  - Press SUPER+CTRL+V to see styled Wofi menu
  - Select any item to paste immediately
  - Press SUPER+CTRL+V again to close (toggle)
  - Clear history option available

**Terminal Integration:**
- Works in Ghostty, Warp, and all terminals
- No terminal-specific configuration needed
- Universal paste works in Firefox, browsers, editors, everywhere!

## Files Modified

### Repository (`/home/stolenducks/hyprvoid/`)
- ✅ Created `config/keybindings.conf` (single organized file)
- ✅ Updated `config/hyprland.conf` (sources keybindings.conf)
- ✅ Simplified `config/ghostty/config`
- ✅ Removed legacy `config/bindings.conf` (2025-11-08)
- ✅ Removed legacy `config/bindings/` directory (2025-11-08)
- ✅ Added clipboard system: `bin/hv-clip` and `bin/hv-clip-watcher`
- ✅ Updated `bin/hyprvoid-menu` with clipboard history menu

### Active Config (`~/.config/`)
- ✅ Deployed `keybindings.conf`
- ✅ Updated `hypr/hyprland.conf`
- ✅ Updated `ghostty/config`
- ✅ Added `autostart.conf` with clipboard watcher
- ✅ Removed legacy `bindings/` directory (2025-11-08)

## Benefits

✅ **Easy to customize** - Edit one well-organized file
✅ **Organized** - Clear sections, easy to navigate
✅ **Universal clipboard** - Works everywhere (Firefox, terminals, editors)
✅ **Clipboard history** - SUPER+CTRL+V for styled history menu
✅ **Instant updates** - `hyprctl reload` makes changes live
✅ **Maintainable** - Single source of truth
✅ **Documented** - Inline comments with descriptions

## Troubleshooting

**Keybindings not updating after `hyprctl reload`?**
- Check syntax in the file: `bind = $mod, KEY, exec, command #desc: Description`
- Ensure `#desc:` comment is present for SUPER+K menu
- Verify file is saved

**Keybindings showing in SUPER+K but not working?**
- Check Hyprland logs with `hyprctl`
- Verify command exists: `which command-name`
- Check if script is executable: `ls -l ~/.local/bin/script-name`

**Clipboard history showing keystroke pollution?**
- Verify `hv-clip-watcher` is running: `ps aux | grep hv-clip-watcher`
- Check it's debouncing correctly (1-second delay)
- Clear history: `cliphist wipe`
- Restart watcher: `pkill hv-clip-watcher && ~/.local/bin/hv-clip-watcher &`
