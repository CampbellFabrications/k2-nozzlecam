#!/bin/sh

PIDFILE=/tmp/ustreamer_rec.pid

if [ -f "$PIDFILE" ]; then
  kill "$(cat "$PIDFILE")" 2>/dev/null || true
  rm -f "$PIDFILE"
fi

exit 0
