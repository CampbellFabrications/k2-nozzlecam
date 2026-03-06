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
  # Ignore sanitisation for now
  # SAFE_NAME=$(echo "$PRINT_NAME" | tr -cd '[:alnum:]_-')
  FILENAME="$OUTDIR/${PRINT_NAME}_${TIMESTAMP}"
else
  FILENAME="$OUTDIR/print_${TIMESTAMP}"
fi

# Ensure USB is writable
mkdir -p "$OUTDIR"
touch "$OUTDIR/.write_test" || exit 1
rm -f "$OUTDIR/.write_test"


# Start recording
#ffmpeg -i "$STREAM_URL" -c copy "$FILENAME" > /tmp/ffmpeg.log 2>&1 &
#ffmpeg -r 25 -fflags +genpts -i "$STREAM_URL" -c copy "$FILENAME" > /tmp/ffmpeg.log 2>&1 &
ffmpeg -fflags +genpts -use_wallclock_as_timestamps 1 -i "$STREAM_URL" -c copy "$FILENAME.avi" > /tmp/ffmpeg.log 2>&1 &
#ffmpeg -r 25 -fflags +genpts -f v4l2 -input_format mjpeg -video_size 1920x1080 -i /dev/video0 \
#  -map 0:v -c copy /mnt/exUDISK/print_$(date +%Y%m%d_%H%M%S).avi \
#  -map 0:v -vf scale=1280:720 -r 25 -f mjpeg http://localhost:8001/stream

echo $! > "$PIDFILE"

exit 0
