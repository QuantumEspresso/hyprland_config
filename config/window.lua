-- xwaylandvideobridge fix
-- hl.window_rule({
--     match = { class = "xwaylandvideobridge" },
--     opacity = "0.0 override"
-- })
local state_file =
    os.getenv("XDG_RUNTIME_DIR") ..
    "/hypr-opaque-toggle"

local opaque = false

do
    local f = io.open(state_file, "r")
    if f then
        opaque = true
        f:close()
    end
end

-- global opacity
hl.window_rule({
    match = { class = ".*" },
    opacity = opaque and "1.0 override" or "0.9 0.8"
})

-- video / media exceptions
local video_titles = {
    "YouTube",
    "Netflix",
    "Prime Video",
    "HBO",
    "Disney",
    "Pokéflix",
    "hub",
    "Xournal",
    "Miro",
    "VLC",
    "mpv"
}

for _, t in ipairs(video_titles) do
    hl.window_rule({
        match = { title = ".*" .. t .. ".*" },
        opacity = "1.0 override"
    })
end


-- dropdown terminals

local dropdowns = {
    term = {
        key = "ALT + T",
        cmd = "alacritty --class dropdown-term",
    },

    music = {
        key = "ALT + M",
        cmd = "alacritty --class dropdown-music -e cmus",
    },

    lynx = {
        key = "ALT + B",
        cmd = "alacritty --class dropdown-lynx -e lynx",
    },

    calendar = {
        key = "ALT + C",
        cmd = "alacritty --class dropdown-calendar -e khal interactive",
    },

    signal = {
        key = "ALT + S",
        cmd = "signal-desktop",
    },
    discord = {
        key = "ALT + D",
        cmd = "discord --class dropdown-discord",
    },
    btop = {
        key = "ALT + Y",
        cmd = "alacritty --class dropdown-btop -e btop",
    },
    nvtop = {
        key = "ALT + N",
        cmd = "alacritty --class dropdown-btop -e nvtop",
    },
}

for name, cfg in pairs(dropdowns) do
    hl.window_rule({
        match = { class = "dropdown-" .. name },
        workspace = "special:" .. name,
        float = true,
        move = "0 40",
        size = {
            "monitor_w * 1",
            "monitor_h * 0.5"
        }
    })

    hl.workspace_rule({
        workspace = "special:" .. name,
        on_created_empty = cfg.cmd
    })

    hl.bind(
        cfg.key,
        hl.dsp.workspace.toggle_special(name)
    )
end
