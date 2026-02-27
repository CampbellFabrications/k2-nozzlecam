#!/bin/sh

DEVICE=""

while [ $# -gt 0 ]; do
    case "$1" in
        --device=*)
            DEVICE="${1#*=}"
            ;;
    esac
    shift
done

[ -z "$DEVICE" ] && exit 1

exec v4l2-ctl --device="$DEVICE" --list-ctrls