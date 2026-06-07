#!/usr/bin/env bash

# default sink
wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-

# jeśli istnieje loopback głośników, ścisz też jego głośność
if [ -f /tmp/wfrecorder.loopback_speakers ]; then
    LOOP=$(cat /tmp/wfrecorder.loopback_speakers)
    wpctl set-volume combined.monitor 5%-
fi
