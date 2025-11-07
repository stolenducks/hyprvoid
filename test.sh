#!/usr/bin/env bash
# Quick Hyprland troubleshooting script
# Run this from a terminal INSIDE Hyprland

echo "=== Hyprland Environment Check ==="
echo ""

echo "1. Checking if Walker exists:"
which walker && echo "✓ Walker found" || echo "✗ Walker not found"
echo ""

echo "2. Checking if wofi exists:"
which wofi && echo "✓ wofi found" || echo "✗ wofi not found"
echo ""

echo "3. Testing Walker launch:"
timeout 2 walker --version 2>&1 && echo "✓ Walker works" || echo "✗ Walker failed"
echo ""

echo "4. Checking environment variables:"
echo "XDG_CURRENT_DESKTOP: $XDG_CURRENT_DESKTOP"
echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
echo "XDG_SESSION_TYPE: $XDG_SESSION_TYPE"
echo ""

echo "5. Testing menu scripts:"
echo "App menu script: ~/.local/bin/voidance-menu-apps"
ls -la ~/.local/bin/voidance-menu-apps
echo ""

echo "=== Try these commands manually ==="
echo ""
echo "Test Walker directly:"
echo "  walker"
echo ""
echo "Test wofi directly:"
echo "  wofi --show drun"
echo ""
echo "Test terminal:"
echo "  alacritty"
echo ""
