#!/bin/env bash
WF_RECORDER_PATH="/usr/bin/wf-recorder"
NOTIFY_SEND_PATH="/usr/bin/notify-send"
MKDIR_PATH="/usr/bin/mkdir"

OUTPUT_DIR="$HOME/Videos/Screencasts"
FILENAME="recording_$(date +'%Y-%m-%d_%H-%M-%S').mp4"
"$MKDIR_PATH" -p "$OUTPUT_DIR"

exec "$WF_RECORDER_PATH" -c libx264 --audio=alsa_output.pci-0000_00_09.2.analog-stereo.monitor -f "$OUTPUT_DIR/$FILENAME" &
"$NOTIFY_SEND_PATH" "Screen Recording" "Full screen started. Saved to Videos/Screencasts"
