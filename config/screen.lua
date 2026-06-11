-- =========================
-- MONITORS
-- =========================

local profiles = require("config.monitor_profiles")

-- =========================
-- LOGGING
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

-- =========================
-- NORMALIZE
-- =========================

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
        local key = normalize(m.description)
        if key ~= "" then
            connected[key] = true
        end
    end

    return connected
end

local function countSet(set)
    local n = 0
    for _ in pairs(set) do
        n = n + 1
    end
    return n
end

-- =========================
-- PROFILE MATCHER (FIXED LOGIC)
-- =========================

local function profileMatches(profile, connected)
    local profileSet = {}

    for _, m in ipairs(profile.monitors) do
        if not m.disabled then
            profileSet[normalize(m.desc)] = true
        end
    end

    -- MUST match same number of active monitors
    if countSet(profileSet) ~= countSet(connected) then
        return false
    end

    -- must include all connected monitors
    for desc in pairs(connected) do
        if not profileSet[desc] then
            return false
        end
    end

    -- must include all profile monitors
    for desc in pairs(profileSet) do
        if not connected[desc] then
            return false
        end
    end

    return true
end

local function findProfile()
    local connected = getConnectedMonitors()

    log("Connected monitors: " .. tostring(countSet(connected)))

    for desc in pairs(connected) do
        log("-> " .. desc)
    end

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
-- APPLY HELPERS
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
-- VALIDATION (UNCHANGED LOGIC)
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

    local f = io.open(LOG_PATH, "a")
    if f then
        f:write(table.concat(lines, "\n") .. "\n")
        f:close()
    end
end

-- =========================
-- APPLY ENGINE (IMPORTANT FIX)
-- =========================

local applying = false

local function tryApply(reason)
    if applying then
        return
    end

    applying = true

    logHeader()
    log("EVENT/TRIGGER: " .. (reason or "manual"))

    local monitors = hl.get_monitors()

    if #monitors == 0 then
        log("MONITORS NOT READY")
        applying = false
        return
    end

    local profile = findProfile()

    if profile then
        log("PROFILE FOUND -> APPLYING")
        validateProfile(profile)
        applyProfile(profile)
        log("PROFILE APPLIED SUCCESSFULLY")
    else
        log("NO PROFILE MATCH -> FALLBACK")
        applyFallback()
        log("FALLBACK APPLIED")
    end

    applying = false
end

-- =========================
-- EVENTS (HYPRLAND 0.55)
-- =========================

hl.on("hyprland.start", function()
    tryApply("hyprland.start")
end)

hl.on("monitor.added", function(m)
    log("monitor.added: " .. (m.description or "unknown"))
    tryApply("monitor.added")
end)

hl.on("monitor.removed", function(m)
    log("monitor.removed: " .. (m.description or "unknown"))
    tryApply("monitor.removed")
end)

hl.on("monitor.layout_changed", function()
    tryApply("monitor.layout_changed")
end)