#!/bin/env bash
# Menghentikan wf-recorder dengan aman dan memberi notifikasi.

# Menggunakan Full Path untuk keandalan maksimal
PKILL_PATH="/usr/bin/pkill"
NOTIFY_SEND_PATH="/usr/bin/notify-send"

# Kirim sinyal INT ke wf-recorder (Sinyal aman agar file tersimpan dengan benar)
"$PKILL_PATH" -INT -x wf-recorder

# Beri notifikasi berdasarkan hasil
if [ $? -eq 0 ]; then
    "$NOTIFY_SEND_PATH" "Screen Recording" "Recording stopped successfully." -t 2000
else
    # Jika tidak ada proses berjalan (mungkin sudah mati duluan)
    "$NOTIFY_SEND_PATH" "Screen Recording" "No recording found to stop." -t 2000
fi
