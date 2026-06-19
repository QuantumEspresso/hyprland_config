
local on_start = hl.on

on_start("hyprland.start", function()

    hl.exec_cmd("syncthing")
    hl.exec_cmd("syncthing-tray")

    hl.exec_cmd("udiskie")
    hl.exec_cmd("lxqt-policykit-agent")

    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("xembedsniproxy")

    hl.exec_cmd("wayscriber --daemon")

    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("quickshell")

    hl.exec_cmd("bash ~/.config/quickshell/scripts/light-dark.sh wallpaper")
    hl.exec_cmd("bash ~/.config/hypr/scripts/apply-input-mapping.sh")
    hl.exec_cmd("systemctl --user restart pipewire pipewire-pulse wireplumber")

end)
