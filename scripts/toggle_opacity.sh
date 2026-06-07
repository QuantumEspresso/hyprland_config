#!/usr/bin/env bash

set -euo pipefail

STATE="$XDG_RUNTIME_DIR/hypr-opaque-toggle"

if [[ -f "$STATE" ]]; then
    rm -f "$STATE"
else
    touch "$STATE"
fi

hyprctl reload
