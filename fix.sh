#!/usr/bin/env bash
# Hyprland Diagnostic and Fix Script

set -e

echo "=== Hyprland Diagnostic & Fix ==="
echo ""

# 1. Check what's working
echo "1. Environment Check:"
echo "   XDG_CURRENT_DESKTOP: $XDG_CURRENT_DESKTOP"
echo "   WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
echo "   XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
echo ""

# 2. Test Walker
echo "2. Testing Walker (app launcher):"
if timeout 1 walker --version &>/dev/null; then
    echo "   ✓ Walker works"
else
    echo "   ✗ Walker has issues"
fi
echo ""

# 3. Test wofi
echo "3. Testing wofi (menu backend):"
if timeout 1 wofi --version &>/dev/null; then
    echo "   ✓ wofi works"
else
    echo "   ✗ wofi has issues"
fi
echo ""

# 4. Check keybinding scripts
echo "4. Checking menu scripts:"
if [ -x ~/.local/bin/voidance-menu-apps ]; then
    echo "   ✓ App menu script is executable"
else
    echo "   ✗ App menu script missing or not executable"
fi

if [ -x ~/.local/bin/voidance-menu-actions ]; then
    echo "   ✓ Actions menu script is executable"
else
    echo "   ✗ Actions menu script missing or not executable"
fi
echo ""

# 5. Check Waybar
echo "5. Checking Waybar (status bar):"
if pgrep -x waybar >/dev/null; then
    echo "   ✓ Waybar is running"
else
    echo "   ✗ Waybar is NOT running"
    echo "   → Starting Waybar..."
    waybar &
fi
echo ""

# 6. Check Mako
echo "6. Checking Mako (notifications):"
if pgrep -x mako >/dev/null; then
    echo "   ✓ Mako is running"
else
    echo "   ✗ Mako is NOT running"
    echo "   → Starting Mako..."
    mako &
fi
echo ""

# 7. Test keybindings
echo "7. Testing if keybindings are registered:"
hyprctl binds | grep -q "voidance-menu-apps" && echo "   ✓ App menu keybinding registered" || echo "   ✗ App menu keybinding NOT registered"
hyprctl binds | grep -q "voidance-menu-actions" && echo "   ✓ Actions menu keybinding registered" || echo "   ✗ Actions menu keybinding NOT registered"
echo ""

# 8. Check for errors in Hyprland log
echo "8. Recent Hyprland errors (if any):"
HYPR_LOG=$(ls -t /tmp/hypr/*/hyprland.log 2>/dev/null | head -1)
if [ -f "$HYPR_LOG" ]; then
    echo "   Log file: $HYPR_LOG"
    echo "   Last 5 errors/warnings:"
    grep -i "error\|warn" "$HYPR_LOG" | tail -5 || echo "   (no recent errors)"
else
    echo "   ✗ No log file found"
fi
echo ""

echo "=== Manual Tests ==="
echo ""
echo "Try these commands manually to test each component:"
echo ""
echo "1. Test Walker directly:"
echo "   walker"
echo ""
echo "2. Test wofi directly:"
echo "   wofi --show drun"
echo ""
echo "3. Test app menu script:"
echo "   ~/.local/bin/voidance-menu-apps"
echo ""
echo "4. Test actions menu script:"
echo "   ~/.local/bin/voidance-menu-actions"
echo ""
echo "5. Test keybindings:"
echo "   Windows + Space          → App launcher"
echo "   Windows + Alt + Space    → Actions menu"
echo "   Windows + Return         → Terminal"
echo ""
echo "=== Config Files ==="
echo "Main config: ~/.config/hypr/hyprland.conf"
echo "Waybar config: ~/.config/waybar/config.jsonc"
echo "Wofi config: ~/.config/wofi/config"
echo ""
