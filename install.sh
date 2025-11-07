#!/usr/bin/env bash
# HyprVoid Setup Script - Hyprland for Void Linux
# Walker launcher • Catppuccin Mocha • Omarchy-style keybindings

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; exit 1; }

cat << 'EOF'
  _   _                __     __    _     _ 
 | | | |_   _ _ __  _ _\ \   / /__ (_) __| |
 | |_| | | | | '_ \| '__\ \ / / _ \| |/ _` |
 |  _  | |_| | |_) | |   \ V / (_) | | (_| |
 |_| |_|\__, | .__/|_|    \_/ \___/|_|\__,_|
        |___/|_|                             

  Hyprland for Void Linux
  Walker • Catppuccin • Omarchy keybindings
EOF

echo ""
info "This script will:"
echo "  • Install Hyprland + Wayland stack (~20 packages)"
echo "  • Install Walker (Omarchy's launcher)"
echo "  • Configure Omarchy-style keybindings"
echo "  • Apply Catppuccin Mocha theme"
echo "  • Fix audio (PipeWire + WirePlumber)"
echo "  • Keep XFCE as default (Hyprland optional at login)"
echo ""
warn "Estimated time: 10-15 minutes"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 0

info "Step 1/6: Adding Hyprland repository..."
if [ ! -f /etc/xbps.d/hyprland-void.conf ]; then
  echo "repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc" | sudo tee /etc/xbps.d/hyprland-void.conf > /dev/null
  success "Hyprland repository added"
else
  success "Hyprland repository already configured"
fi

info "Step 2/6: Installing packages..."
sudo xbps-install -Syu \
  hyprland \
  Waybar \
  wofi \
  walker \
  mako \
  hyprpaper \
  hypridle \
  hyprlock \
  alacritty \
  pipewire \
  wireplumber \
  pavucontrol \
  alsa-utils \
  papirus-icon-theme \
  noto-fonts-ttf \
  noto-fonts-emoji \
  font-awesome6 \
  grim \
  slurp \
  wl-clipboard \
  xdg-desktop-portal-hyprland \
  polkit-gnome

success "Packages installed"

info "Step 3/6: Fixing audio configuration..."
sudo usermod -aG audio $USER
success "Added $USER to audio group (requires re-login to take effect)"

info "Step 4/6: Creating directories..."
mkdir -p ~/.local/bin
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/mako
mkdir -p ~/.config/wofi
mkdir -p ~/.config/hyprpaper
mkdir -p ~/Pictures/wallpapers
success "Directories created"

info "Step 5/6: Creating launcher scripts..."

# App menu script
cat > ~/.local/bin/hyprvoid-menu-apps << 'EOFSCRIPT'
#!/usr/bin/env bash
set -euo pipefail

# HyprVoid app launcher with Walker-first fallback
wofi_conf="${HOME}/.config/wofi/config"
wofi_style="${HOME}/.config/wofi/style.css"

if command -v walker >/dev/null 2>&1; then
  exec walker "$@"
elif command -v wofi >/dev/null 2>&1; then
  exec wofi --show drun --allow-images --insensitive --conf "${wofi_conf}" --style "${wofi_style}"
elif command -v fuzzel >/dev/null 2>&1; then
  exec fuzzel
else
  notify-send "No launcher found" "Install walker, wofi, or fuzzel"
fi
EOFSCRIPT

chmod +x ~/.local/bin/hyprvoid-menu-apps

# Actions menu script
cat > ~/.local/bin/hyprvoid-menu-actions << 'EOFSCRIPT'
#!/usr/bin/env bash
set -euo pipefail

# Omarchy-style actions menu for xbps package management

dmenu() {
  local prompt="${1:-Select}"
  if command -v wofi >/dev/null 2>&1; then
    wofi --dmenu --prompt "${prompt}" \
      --conf "${HOME}/.config/wofi/config" \
      --style "${HOME}/.config/wofi/style.css"
  elif command -v fuzzel >/dev/null 2>&1; then
    fuzzel --dmenu --prompt "${prompt}: "
  elif command -v tofi >/dev/null 2>&1; then
    tofi --prompt-text "${prompt}: "
  else
    return 1
  fi
}

confirm() {
  printf "No\nYes\n" | dmenu "Confirm" | grep -qi "^Yes$"
}

run_term() {
  local cmd="$*"
  if command -v alacritty >/dev/null 2>&1; then
    alacritty -e bash -lc "${cmd}; echo; read -n 1 -s -r -p 'Press any key to close...'"
  else
    xdg-terminal-exec bash -lc "${cmd}"
  fi
}

pick_action() {
  printf "  Update System\n  Install Package\n  Remove Package\n  Search Packages\n"
}

main() {
  action="$(pick_action | dmenu 'Actions…' || true)"
  case "${action}" in
    *Update*)
      if confirm; then
        run_term "sudo xbps-install -Syu"
        notify-send "System Update" "Completed"
      fi
      ;;
    *Install*)
      pkg="$(printf '' | dmenu 'Package to install' || true)"
      [ -n "${pkg:-}" ] || exit 0
      if confirm; then
        run_term "sudo xbps-install -S ${pkg}"
        notify-send "Install" "Installed ${pkg}"
      fi
      ;;
    *Remove*)
      pkg="$(printf '' | dmenu 'Package to remove' || true)"
      [ -n "${pkg:-}" ] || exit 0
      if confirm; then
        run_term "sudo xbps-remove -R ${pkg}"
        notify-send "Remove" "Removed ${pkg}"
      fi
      ;;
    *Search*)
      query="$(printf '' | dmenu 'Search query' || true)"
      [ -n "${query:-}" ] || exit 0
      results="$(xbps-query -Rs "${query}" 2>/dev/null || true)"
      if [ -z "${results}" ]; then
        notify-send "Search" "No results for ${query}"
        exit 0
      fi
      sel="$(printf "%s\n" "${results}" | dmenu 'Results' || true)"
      [ -n "${sel:-}" ] && notify-send "Package" "${sel}"
      ;;
    *)
      ;;
  esac
}

main "$@"
EOFSCRIPT

chmod +x ~/.local/bin/hyprvoid-menu-actions

success "Launcher scripts created"

info "Step 6/6: Creating configuration files..."

# Wofi config
cat > ~/.config/wofi/config << 'EOF'
location=center
width=820
height=420
lines=12
allow-markup=true
allow-images=true
no-actions=false
prompt=>
insensitive=true
EOF

# Wofi style (Catppuccin Mocha)
cat > ~/.config/wofi/style.css << 'EOF'
/* Catppuccin Mocha - Omarchy aesthetic */
* {
  font-family: "Noto Sans", "Font Awesome 6 Free";
  font-size: 13px;
}

window {
  margin: 0px;
  border: 2px solid #89b4fa;  /* Catppuccin blue */
  background-color: #1e1e2e;  /* Catppuccin base */
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
}

#input {
  margin: 12px;
  padding: 8px 12px;
  border: none;
  color: #cdd6f4;             /* Catppuccin text */
  background-color: #181825;  /* Catppuccin mantle */
  border-radius: 8px;
}

#inner-box {
  margin: 12px;
  border: none;
  background-color: transparent;
}

#outer-box {
  margin: 0px;
  border: none;
  background-color: transparent;
}

#scroll {
  margin: 0px;
  border: none;
}

#text {
  margin: 6px;
  padding: 4px;
  color: #cdd6f4;
}

#entry:selected {
  background-color: #313244;  /* Catppuccin surface0 */
  border-radius: 8px;
}

#entry:selected #text {
  color: #89b4fa;            /* Blue highlight */
}

#img {
  margin-right: 8px;
}
EOF

# Hyprland config (Omarchy keybindings)
cat > ~/.config/hypr/hyprland.conf << 'EOF'
# Voidance Hyprland Configuration
# Omarchy-style keybindings and aesthetic

monitor=,preferred,auto,1

env = XCURSOR_SIZE,24
env = GTK_THEME,Adwaita-dark

# Autostart
exec-once = hyprpaper
exec-once = mako
exec-once = waybar
exec-once = /usr/libexec/polkit-gnome-authentication-agent-1

input {
  kb_layout = us
  follow_mouse = 1
  
  touchpad {
    natural_scroll = true
    disable_while_typing = true
    tap-to-click = true
  }
}

general {
  gaps_in = 5
  gaps_out = 10
  border_size = 2
  
  col.active_border = rgba(89b4faff)      # Catppuccin blue
  col.inactive_border = rgba(313244ff)    # Catppuccin surface0
  
  layout = dwindle
  allow_tearing = false
}

decoration {
  rounding = 10
  
  blur {
    enabled = true
    size = 6
    passes = 2
  }
  
  drop_shadow = true
  shadow_range = 20
  shadow_render_power = 3
  col.shadow = rgba(00000066)
}

animations {
  enabled = true
  
  bezier = easeOutQuint, 0.23, 1, 0.32, 1
  bezier = quick, 0.15, 0, 0.1, 1
  
  animation = windows, 1, 4.79, easeOutQuint
  animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
  animation = windowsOut, 1, 1.49, quick, popin 87%
  animation = border, 1, 5, easeOutQuint
  animation = fade, 1, 3, quick
  animation = workspaces, 1, 6, easeOutQuint
}

dwindle {
  pseudotile = true
  preserve_split = true
  force_split = 2
}

windowrulev2 = suppressevent maximize, class:.*

layerrule = blur, waybar
layerrule = blur, wofi

# ===== KEYBINDINGS (Omarchy-exact) =====

$mod = SUPER
$term = alacritty
$appmenu = ~/.local/bin/hyprvoid-menu-apps
$actions = ~/.local/bin/hyprvoid-menu-actions

# Core Omarchy bindings
bind = $mod, SPACE, exec, $appmenu
bind = $mod ALT, SPACE, exec, $actions
bind = $mod, RETURN, exec, $term
bind = $mod, W, killactive,
bind = $mod, F, fullscreen, 0
bind = $mod, T, togglefloating,
bind = $mod, J, togglesplit,
bind = $mod, P, pseudo,

# Window focus
bind = $mod, LEFT, movefocus, l
bind = $mod, RIGHT, movefocus, r
bind = $mod, UP, movefocus, u
bind = $mod, DOWN, movefocus, d

# Workspaces
bind = $mod, 1, workspace, 1
bind = $mod, 2, workspace, 2
bind = $mod, 3, workspace, 3
bind = $mod, 4, workspace, 4
bind = $mod, 5, workspace, 5
bind = $mod, 6, workspace, 6
bind = $mod, 7, workspace, 7
bind = $mod, 8, workspace, 8
bind = $mod, 9, workspace, 9

# Move window to workspace
bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, 3, movetoworkspace, 3
bind = $mod SHIFT, 4, movetoworkspace, 4
bind = $mod SHIFT, 5, movetoworkspace, 5
bind = $mod SHIFT, 6, movetoworkspace, 6
bind = $mod SHIFT, 7, movetoworkspace, 7
bind = $mod SHIFT, 8, movetoworkspace, 8
bind = $mod SHIFT, 9, movetoworkspace, 9

# Workspace navigation
bind = $mod, TAB, workspace, e+1
bind = $mod SHIFT, TAB, workspace, e-1
bind = $mod CTRL, TAB, workspace, previous

# Swap windows
bind = $mod SHIFT, LEFT, swapwindow, l
bind = $mod SHIFT, RIGHT, swapwindow, r
bind = $mod SHIFT, UP, swapwindow, u
bind = $mod SHIFT, DOWN, swapwindow, d

# Cycle windows
bind = ALT, TAB, cyclenext
bind = ALT, TAB, bringactivetotop
bind = ALT SHIFT, TAB, cyclenext, prev
bind = ALT SHIFT, TAB, bringactivetotop

# Screenshots
bind = , PRINT, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Saved to Pictures"
bind = SHIFT, PRINT, exec, grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Area saved"

# System
bind = $mod, ESCAPE, exec, hyprctl dispatch exit

# Audio
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# Brightness
bind = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

# Mouse
bindm = $mod, mouse:272, movewindow
bindm = $mod, mouse:273, resizewindow
bind = $mod, mouse_down, workspace, e+1
bind = $mod, mouse_up, workspace, e-1
EOF

# Waybar config
cat > ~/.config/waybar/config.jsonc << 'EOF'
{
  "layer": "top",
  "position": "top",
  "height": 30,
  "spacing": 4,
  
  "modules-left": [],
  "modules-center": ["clock"],
  "modules-right": [],
  
  "clock": {
    "format": " {:%H:%M  —  %a %b %d}",
    "tooltip": false
  }
}
EOF

# Waybar style
cat > ~/.config/waybar/style.css << 'EOF'
/* Catppuccin Mocha - Omarchy aesthetic */
* {
  font-family: "Noto Sans", "Font Awesome 6 Free";
  font-size: 12pt;
  font-weight: 500;
}

window#waybar {
  background: rgba(30, 30, 46, 0.9);
  color: #cdd6f4;
}

#clock {
  background: transparent;
  color: #cdd6f4;
  padding: 0 16px;
  border-radius: 8px;
}
EOF

# Mako config
cat > ~/.config/mako/config << 'EOF'
font=Noto Sans 11
background-color=#1e1e2e
text-color=#cdd6f4
border-color=#89b4fa
border-size=2
border-radius=10
padding=12
margin=10
default-timeout=5000
anchor=top-right
max-visible=5
icons=1
EOF

# Hyprpaper config
cat > ~/.config/hypr/hyprpaper.conf << 'EOF'
preload = ~/Pictures/wallpapers/catppuccin-mocha.png
wallpaper = ,~/Pictures/wallpapers/catppuccin-mocha.png
EOF

success "Configuration files created"

info "Downloading Catppuccin wallpaper..."
if command -v curl >/dev/null 2>&1; then
  curl -sL -o ~/Pictures/wallpapers/catppuccin-mocha.png \
    https://raw.githubusercontent.com/catppuccin/wallpapers/main/minimalistic/catppuccin_mocha.png
  success "Wallpaper downloaded"
elif command -v wget >/dev/null 2>&1; then
  wget -q -O ~/Pictures/wallpapers/catppuccin-mocha.png \
    https://raw.githubusercontent.com/catppuccin/wallpapers/main/minimalistic/catppuccin_mocha.png
  success "Wallpaper downloaded"
else
  warn "curl/wget not found - download wallpaper manually to ~/Pictures/wallpapers/"
fi

# Ensure PATH includes ~/.local/bin
if ! grep -q '$HOME/.local/bin' ~/.bashrc 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
  success "Added ~/.local/bin to PATH in ~/.bashrc"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ HyprVoid installation complete!${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
info "What to do next:"
echo ""
echo "  1. Log out of XFCE"
echo "  2. At LightDM, click the session icon (top-right)"
echo "  3. Select 'Hyprland'"
echo "  4. Log in with your password"
echo ""
info "Omarchy-style keybindings:"
echo ""
echo "  Super + Space          → App launcher (Walker)"
echo "  Super + Alt + Space    → Actions menu (xbps)"
echo "  Super + Return         → Terminal"
echo "  Super + W              → Close window"
echo "  Super + F              → Fullscreen"
echo "  Super + T              → Toggle floating"
echo "  Super + 1-9            → Switch workspace"
echo "  Super + Tab            → Next workspace"
echo "  Alt + Tab              → Cycle windows"
echo "  Print                  → Screenshot"
echo "  Super + Escape         → Exit Hyprland"
echo ""
warn "Audio fix requires re-login to take effect"
echo ""
info "To return to XFCE: Log out and select XFCE at LightDM"
echo ""
info "GitHub: https://github.com/stolenducks/hyprvoid"
echo ""
