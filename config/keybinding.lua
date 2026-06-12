
local bind = hl.bind
local binde = hl.bind
local bindm = hl.bind

-- =========================
-- MODIFIERS
-- =========================

local SUPER = "SUPER"
local ALT = "ALT"
local SHIFT = "SHIFT"

-- =========================
-- APPS
-- =========================

bind("SUPER + Return", hl.dsp.exec_cmd("alacritty"))
bind("SUPER + T", hl.dsp.exec_cmd("kitty"))

bind("SUPER + ALT + B", hl.dsp.exec_cmd("brave"))
bind("SUPER + ALT + D", hl.dsp.exec_cmd("discord"))
bind("SUPER + ALT + S", hl.dsp.exec_cmd("signal-desktop"))
bind("SUPER + ALT + F", hl.dsp.exec_cmd("thunar"))

bind("SUPER + ALT + Delete", hl.dsp.exec_cmd("hyprlock"))
bind("SUPER + ALT + R", hl.dsp.exec_cmd("wayscriber --active"))

bind("SUPER + Q", hl.dsp.window.close())
bind("SUPER + SHIFT + Q", hl.dsp.exit())

bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
bind("SUPER + F", hl.dsp.window.fullscreen())

-- =========================
-- FOCUS
-- =========================

bind("SUPER + left",  hl.dsp.focus({ direction = "l" }))
bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
bind("SUPER + up",    hl.dsp.focus({ direction = "u" }))
bind("SUPER + down",  hl.dsp.focus({ direction = "d" }))

bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
bind("SUPER + J", hl.dsp.focus({ direction = "d" }))

-- =========================
-- MOVE WINDOWS
-- =========================

bind("SUPER + SHIFT + left",  hl.dsp.window.swap({ direction = "l" }))
bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "r" }))
bind("SUPER + SHIFT + up",    hl.dsp.window.swap({ direction = "u" }))
bind("SUPER + SHIFT + down",  hl.dsp.window.swap({ direction = "d" }))

bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "l" }))
bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "r" }))
bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "u" }))
bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "d" }))

-- =========================
-- RESIZE
-- =========================

bind("SUPER + ALT + right", hl.dsp.window.resize({ x = 20, y = 0 }))
bind("SUPER + ALT + left",  hl.dsp.window.resize({ x = -20, y = 0 }))
bind("SUPER + ALT + up",    hl.dsp.window.resize({ x = 0, y = 20 }))
bind("SUPER + ALT + down",  hl.dsp.window.resize({ x = 0, y = -20 }))

bind("SUPER + ALT + L", hl.dsp.window.resize({ x = 20, y = 0 }))
bind("SUPER + ALT + H", hl.dsp.window.resize({ x = -20, y = 0 }))
bind("SUPER + ALT + K", hl.dsp.window.resize({ x = 0, y = 20 }))
bind("SUPER + ALT + J", hl.dsp.window.resize({ x = 0, y = -20 }))

-- =========================
-- WORKSPACES
-- =========================

for i = 1, 9 do
    bind("SUPER + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
    bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end

bind("SUPER + Z", hl.dsp.focus({ workspace = "r-1" }))
bind("SUPER + X", hl.dsp.focus({ workspace = "r+1" }))

bind("SUPER + SHIFT + Z", hl.dsp.window.move({ workspace = "r-1" }))
bind("SUPER + SHIFT + X", hl.dsp.window.move({ workspace = "r+1" }))

bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- =========================
-- MOUSE
-- =========================

bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- =========================
-- SCREENSHOT
-- =========================

bind("Print", hl.dsp.exec_cmd("~/.config/quickshell/scripts/screenshot.sh select"))
bind("SUPER + Print", hl.dsp.exec_cmd("~/.config/quickshell/scripts/screenshot.sh screen"))
bind("SUPER + ALT + Print", hl.dsp.exec_cmd("~/.config/quickshell/scripts/screenshot.sh window"))

-- =========================
-- MEDIA
-- =========================

bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_up.sh"), { repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_down.sh"), { repeating = true })
bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_mute.sh"), { locked = true })

bind("XF86AudioPlay", hl.dsp.exec_cmd("quickshell:mediaPlayPause"), { locked = true })
bind("XF86AudioNext", hl.dsp.exec_cmd("quickshell:mediaNext"), { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("quickshell:mediaPrev"), { locked = true })

-- =========================
-- DROPDOWNS
-- =========================

-- bind("ALT + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/dropdown-term.sh term"))
bind("ALT + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/dropdown-term.sh music"))
bind("ALT + B", hl.dsp.exec_cmd("~/.config/hypr/scripts/dropdown-term.sh lynx"))
bind("ALT + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/dropdown-term.sh calendar"))
bind("ALT + S", hl.dsp.exec_cmd("~/.config/hypr/scripts/dropdown-term.sh signal"))
bind("ALT + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/dropdown-term.sh discord"))

-- quickshell
bind("ALT + Q", hl.dsp.exec_cmd("quickshell"))

-- opacity
bind("ALT + O", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_opacity.sh"))
