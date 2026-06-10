-- =========================
-- MONITORS
-- =========================

local profiles = require("config.monitor_profiles")

-- =========================
-- HELPERS
-- =========================

local LOG_PATH = "/tmp/hypr-monitor-debug.log"

local function log(msg)
    local f = io.open(LOG_PATH, "a")
    if f then
        f:write(msg .. "\n")
        f:close()
    end
end

local function logHeader()
    local f = io.open(LOG_PATH, "w")
    if f then
        f:write("=== HYPR MONITOR DEBUG START ===\n")
        f:close()
    end
end

-- 🔥 FIX: normalize strings (KLUCZOWE)
local function normalize(str)
    return (str or "")
        :gsub("%s+", " ")
        :gsub("^%s+", "")
        :gsub("%s+$", "")
end

-- =========================
-- MONITOR STATE
-- =========================

local function getConnectedMonitors()
    local connected = {}

    for _, m in ipairs(hl.get_monitors()) do
        connected[normalize(m.description)] = m
    end

    return connected
end

local function profileMatches(profile, connected)
    for _, m in ipairs(profile.monitors) do
        if not m.disabled then
            local key = normalize(m.desc)

            if not connected[key] then
                return false
            end
        end
    end

    return true
end

local function findProfile()
    local connected = getConnectedMonitors()

    for name, profile in pairs(profiles) do
        local ok = profileMatches(profile, connected)

        log("PROFILE CHECK: " .. name .. " -> " .. tostring(ok))

        if ok then
            log("SELECTED PROFILE: " .. name)
            return profile
        end
    end

    return nil
end

-- =========================
-- GEOMETRY + VALIDATION
-- =========================

local function parsePos(pos)
    local x, y = pos:match("^(%-?%d+)x(%-?%d+)$")
    return tonumber(x) or 0, tonumber(y) or 0
end

local function getMonitorSizeByDesc(desc)
    for _, m in ipairs(hl.get_monitors()) do
        if normalize(m.description) == normalize(desc) then
            return m.width or 1920, m.height or 1080
        end
    end
    return 1920, 1080
end

local function rect(m)
    local x, y = parsePos(m.position or "0x0")

    local w, h = getMonitorSizeByDesc(m.desc)
    local scale = m.scale or 1.0

    return {
        x = x,
        y = y,
        w = w * scale,
        h = h * scale,
        name = m.desc
    }
end

local function overlaps(a, b)
    return not (
        a.x + a.w <= b.x or
        b.x + b.w <= a.x or
        a.y + a.h <= b.y or
        b.y + b.h <= a.y
    )
end

local function validateProfile(profile)
    local rects = {}
    local lines = {}

    table.insert(lines, "=== HYPR MONITOR VALIDATION ===")

    for _, m in ipairs(profile.monitors) do
        if not m.disabled then
            table.insert(rects, rect(m))
        end
    end

    for i = 1, #rects do
        for j = i + 1, #rects do
            if overlaps(rects[i], rects[j]) then
                table.insert(lines,
                    "OVERLAP: " .. rects[i].name ..
                    " <-> " .. rects[j].name
                )
            end
        end
    end

    if #lines == 1 then
        table.insert(lines, "OK: no overlaps detected")
    end

    local f = io.open(LOG_PATH, "w")
    if f then
        f:write(table.concat(lines, "\n"))
        f:close()
    end
end

-- =========================
-- APPLY
-- =========================

local function applyProfile(profile)
    for _, m in ipairs(profile.monitors) do
        if m.disabled then
            hl.monitor({
                output = "desc:" .. m.desc,
                disabled = true
            })
        else
            hl.monitor({
                output = "desc:" .. m.desc,
                mode = m.mode,
                position = m.position,
                scale = m.scale
            })
        end
    end
end

local function applyFallback()
    local x = 0

    for _, m in ipairs(hl.get_monitors()) do
        hl.monitor({
            output = "desc:" .. m.description,
            mode = "preferred",
            position = string.format("%dx0", x),
            scale = 1.0
        })

        x = x + (m.width or 1920)
    end
end

-- =========================
-- MAIN
-- =========================

logHeader()

local profile = findProfile()

if profile then
    log("PROFILE FOUND: APPLYING")
    log("Profile monitors: " .. tostring(#profile.monitors))

    for _, m in ipairs(profile.monitors) do
        log("-> " .. m.desc .. " @ " .. (m.position or "nil"))
    end

    validateProfile(profile)
    applyProfile(profile)

    log("PROFILE APPLIED SUCCESSFULLY")
else
    log("NO PROFILE MATCH -> FALLBACK")

    local connected = hl.get_monitors()
    log("Connected monitors: " .. tostring(#connected))

    for _, m in ipairs(connected) do
        log("-> " .. normalize(m.description))
    end

    applyFallback()

    log("FALLBACK APPLIED")
end

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
