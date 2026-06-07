#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/hypr/input-device-mapping.conf"
[ -f "$CONFIG" ] || exit 0

MONITORS_JSON="$(hyprctl -j monitors)"

declare -A SEEN

lua_escape() {
    # minimalne escapowanie dla Lua stringów w bashu
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

apply_lua_device() {
    local device="$1"
    local enabled="$2"
    local output="$3"

    device_esc="$(lua_escape "$device")"

    if [[ "$enabled" == "false" ]]; then
        hyprctl eval "
hl.device({
    name = \"$device_esc\",
    enabled = false,
})
" >/dev/null 2>&1 || true
        return
    fi

    output_esc="$(lua_escape "$output")"

    hyprctl eval "
hl.device({
    name = \"$device_esc\",
    enabled = true,
    output = \"$output_esc\",
})
" >/dev/null 2>&1 || true
}

while IFS="|" read -r DEVICE DESCRIPTION; do
    DEVICE="${DEVICE//[$'\t\r\n ']}"
    DESCRIPTION="${DESCRIPTION//[$'\t\r\n ']}"

    [[ -z "$DEVICE" || -z "$DESCRIPTION" ]] && continue

    key="${DEVICE}|${DESCRIPTION}"
    [[ -n "${SEEN[$key]:-}" ]] && continue
    SEEN["$key"]=1

    # =========================
    # OFF
    # =========================
    if [[ "$DESCRIPTION" == "Off" ]]; then
        apply_lua_device "$DEVICE" "false" ""
        continue
    fi

    # =========================
    # MATCH MONITOR
    # =========================
    OUTPUT="$(echo "$MONITORS_JSON" | jq -r \
        ".[] | select(
            (.description | gsub(\"[[:space:]]\"; \"\") | ascii_downcase)
            ==
            (\"$DESCRIPTION\" | gsub(\"[[:space:]]\"; \"\") | ascii_downcase)
        ) | .name" | head -n1)"

    if [[ -z "$OUTPUT" ]]; then
        echo "WARN: no monitor match for:"
        echo "      $DESCRIPTION"
        echo "available:"
        echo "$MONITORS_JSON" | jq -r '.[].description'
        continue
    fi

    # =========================
    # APPLY
    # =========================
    apply_lua_device "$DEVICE" "true" "$OUTPUT"

done < "$CONFIG"
