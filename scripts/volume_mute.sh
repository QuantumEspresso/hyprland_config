#!/usr/bin/env bash

# default sink
wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# jeśli istnieje loopback głośników, toggle mute również
LOOP_FILE="/tmp/wfrecorder.loopback_speakers"
if [ -f "$LOOP_FILE" ]; then
    LOOP=$(cat "$LOOP_FILE")
    pactl set-sink-input-mute "$LOOP" toggle
fi
