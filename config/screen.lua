-- =========================
-- MONITORS
-- =========================

local profiles = require("config.monitor_profiles")

hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@60.01000",
    position = "2200x1350",
    scale = 1.2
})

hl.monitor({
    output = "desc:Lenovo Group Limited P40w-20 V909507G",
    mode = "5120x2160@75",
    position = "0x0",
    scale = 1.6
})

hl.monitor({
    output = "desc:ASUSTek COMPUTER INC ASUS MB14AHD S6LMTF011157",
    mode = "1920x1080@60.01000",
    position = "5200x400",
    scale = 1.2
})

-- =========================
-- WORKSPACE RULES
-- =========================

hl.workspace_rule({
    workspace = "1",
    monitor = "eDP-1",
    default = true
})

for i = 2, 5 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "eDP-1"
    })
end
for i = 6, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "DP-1"
    })
end
for i = 11, 15 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor = "HDMI-A-1"
    })
end
