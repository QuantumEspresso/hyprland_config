-- ~/.config/hypr/config/theme.lua

---------------------------------------------------------------------------------------------------
-- GTK4 theme (libadwaita)
---------------------------------------------------------------------------------------------------

hl.exec(
    'gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"'
)

---------------------------------------------------------------------------------------------------
-- GTK3 theme
---------------------------------------------------------------------------------------------------

-- Requires:
--   adw-gtk-theme
--
-- Arch Linux:
--   sudo pacman -S adw-gtk-theme

hl.exec(
    'gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3"'
)

---------------------------------------------------------------------------------------------------
-- Qt theme
---------------------------------------------------------------------------------------------------

-- Requires:
--   qt5ct
--   qt6ct
--   kvantum
--   breeze-icons
--
-- Arch Linux:
--   sudo pacman -S qt5ct qt6ct kvantum breeze-icons

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
