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

# add start_recording.sh script to usr/bin
ln -sf "${SCRIPT_DIR}/start_recording.sh" /usr/bin/start_recording.sh
chmod 755 /usr/bin/start_recording.sh

# add stop_recording.sh script to usr/bin
ln -sf "${SCRIPT_DIR}/stop_recording.sh" /usr/bin/stop_recording.sh
chmod 755 /usr/bin/stop_recording.sh

# adds gcode_shell_command to klipper
ln -sf "${SCRIPT_DIR}/gcode_shell_command.py" /usr/share/klipper/klippy/extras/gcode_shell_command.py

# copy the camera_macro.cfg to /mnt/UDISK/printer_data/config/camera_macro.cfg
cp -f "${SCRIPT_DIR}/camera_macro.cfg" /mnt/UDISK/printer_data/config/camera_macro.cfg
# add the macro into the printer.cfg file
python ${SCRIPT_DIR}/ensure_included.py \
    ~/printer_data/config/printer.cfg camera_macro.cfg


# cp fluidd assets into /usr/share/fluidd

# fluidd config files get added to /mnt/UDISK/printer_data/config/fluidd/

# direct tmp files get put into /tmp

# add camera detection script
#chmod +x "${SCRIPT_DIR}/get_camera_info.sh"
#ln -sf "${SCRIPT_DIR}/get_camera_info.sh" /mnt/UDISK/printer_data/scripts/get_camera_info.sh

echo "Installation complete. reboot the system to apply changes."