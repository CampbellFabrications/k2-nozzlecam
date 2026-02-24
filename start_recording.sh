#!/bin/sh
set -e

PIDFILE=/tmp/ustreamer_rec.pid
OUTDIR=/mnt/exUDISK
STREAM_URL=http://localhost:8001/stream

# Already recording? Exit cleanly.
if [ -f "$PIDFILE" ]; then
  exit 0
fi


# Use argument 1 as print name (fallback if empty)
PRINT_NAME="$1"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ -n "$PRINT_NAME" ]; then
  # sanitize: keep letters, numbers, dash, underscore
  SAFE_NAME=$(echo "$PRINT_NAME" | tr -cd '[:alnum:]_-')
  FILENAME="$OUTDIR/${SAFE_NAME}_${TIMESTAMP}.mjpeg"
else
  FILENAME="$OUTDIR/print_${TIMESTAMP}.mjpeg"
fi

# Ensure USB is writable
mkdir -p "$OUTDIR"
touch "$OUTDIR/.write_test" || exit 1
rm -f "$OUTDIR/.write_test"


# Start recording
curl -s "$STREAM_URL" --output "$FILENAME" &
echo $! > "$PIDFILE"

exit 0
