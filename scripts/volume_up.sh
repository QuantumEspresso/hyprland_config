#!/usr/bin/env bash

# default sink
wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+

# jeśli istnieje loopback głośników, podbij też jego głośność
if [ -f /tmp/wfrecorder.loopback_speakers ]; then
    LOOP=$(cat /tmp/wfrecorder.loopback_speakers)
    wpctl set-volume -l 1.5 combined.monitor 5%+
fi
