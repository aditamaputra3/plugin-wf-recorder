#!/bin/env bash
WF_RECORDER_PATH="/usr/bin/wf-recorder"
SLURP_PATH="/usr/bin/slurp"
NOTIFY_SEND_PATH="/usr/bin/notify-send"
MKDIR_PATH="/usr/bin/mkdir"

OUTPUT_DIR="$HOME/Videos/Screencasts"
FILENAME="recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"
"$MKDIR_PATH" -p "$OUTPUT_DIR"

exec "$WF_RECORDER_PATH" -c libx264 --audio=alsa_output.pci-0000_00_09.2.analog-stereo.monitor -f "$OUTPUT_DIR/$FILENAME" -g "$($SLURP_PATH -f %w,%x,%y,%h -p)" &
"$NOTIFY_SEND_PATH" "Screen Recording" "Window started. Saved to Videos/Screencasts"
