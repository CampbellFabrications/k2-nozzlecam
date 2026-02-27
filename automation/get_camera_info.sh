#!/bin/sh

# Output JSON object of discovered cameras
# Keys are semantic roles (chamber, nozzle)

printf '{\n'
first=1

for dev in /dev/video*; do
    INFO="$(udevadm info -a -n "$dev")"

    # --- get V4L2 index (primary stream only) ---
    INDEX="$(printf '%s\n' "$INFO" | awk '
        /looking at device/ {found=1; next}
        found && /looking at parent device/ {exit}
        found && /ATTR\{index\}/ {
            split($0, a, "\"")
            print a[2]
            exit
        }
    ')"

    [ "$INDEX" != "0" ] && continue

    # --- get interface name ---
    NAME="$(printf '%s\n' "$INFO" | awk '
        /looking at parent device/ {found=1; next}
        found && /looking at/ {exit}
        found && /ATTRS\{interface\}/ {
            split($0, a, "\"")
            print a[2]
            exit
        }
    ')"

    # --- get USB interface path ---
    IFACE="$(printf '%s\n' "$INFO" | awk '
        /looking at parent device/ {found=1; next}
        found && /looking at/ {exit}
        found && /KERNELS=="/ {
            split($0, a, "\"")
            print a[2]
            exit
        }
    ')"

    [ -z "$NAME" ] && continue

    ROLE=""
    case "$NAME" in
        *"CREALITY CAM"*)
            ROLE="chamber"
            ;;
        *"3DO USB CAMERA V2"*)
            ROLE="nozzle"
            ;;
        *)
            continue
            ;;
    esac

    [ $first -eq 0 ] && printf ',\n'
    first=0

    printf '  "%s": {\n' "$ROLE"
    printf '    "device": "%s",\n' "$(basename "$dev")"
    printf '    "interface": "%s",\n' "$NAME"
    printf '    "usb_path": "%s"\n' "$IFACE"
    printf '  }'
done

printf '\n}\n'