#!/bin/env bash
SCRIPT_TO_RUN="$1"
HYPRCTL_PATH="/usr/bin/hyprctl"
BASH_PATH="/bin/bash"
NOTIFY_SEND_PATH="/usr/bin/notify-send"

if [ -x "$HYPRCTL_PATH" ]; then
    "$HYPRCTL_PATH" dispatch exec "$BASH_PATH" "$SCRIPT_TO_RUN"
else
    # Fallback aman menggunakan $HOME jika perlu referensi path user
    "$NOTIFY_SEND_PATH" "WF Recorder" "Hyprctl not found"
    exit 1
fi
