#!/bin/ash

set -e

SCRIPT_DIR="$(readlink -f $(dirname $0))"

# backup original auto_uvc if present
if [ -e /usr/bin/auto_uvc.sh ] || [ -L /usr/bin/auto_uvc.sh ]; then
    cp -p /usr/bin/auto_uvc.sh /usr/bin/auto_uvc.sh.bak
fi

# symlink the new script into place
ln -sf "${SCRIPT_DIR}/auto_uvc.sh" /usr/bin/auto_uvc.sh
# make the new script executable
chmod 755 /usr/bin/auto_uvc.sh

# backup original 60-v4l if present
if [ -e /etc/hotplug.d/usb/60-v4l ] || [ -L /etc/hotplug.d/usb/60-v4l ]; then
    cp -p /etc/hotplug.d/usb/60-v4l /etc/hotplug.d/usb/60-v4l.bak
fi

# symlink the udev rule into place
ln -sf "${SCRIPT_DIR}/60-v4l" /etc/hotplug.d/usb/60-v4l

# symlink the ustreamer binary into /usr/bin
ln -sf "${SCRIPT_DIR}/ustreamer_static_arm32" /usr/bin/ustreamer_static_arm32
chmod 755 /usr/bin/ustreamer_static_arm32

ln -sf "${SCRIPT_DIR}/start_recording.sh" /usr/bin/start_recording.sh
chmod 755 /usr/bin/start_recording.sh

ln -sf "${SCRIPT_DIR}/stop_recording.sh" /usr/bin/stop_recording.sh
chmod 755 /usr/bin/stop_recording.sh

# adds gcode_shell_command to klipper
ln -sf "${SCRIPT_DIR}/gcode_shell_command.py" /usr/share/klipper/klippy/extras/gcode_shell_command.py

# copy the camera_macro.cfg to /home/pi/klipper_config/camera_macro.cfg
cp -f "${SCRIPT_DIR}/camera_macro.cfg" /mnt/UDISK/printer_data/config/camera_macro.cfg

echo "Installation complete. reboot the system to apply changes."