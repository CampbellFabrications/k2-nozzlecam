#!/bin/sh

set -e

# return original auto_uvc if backup exists
if [ -e /usr/bin/auto_uvc.sh.bak ] && [ -e /usr/bin/auto_uvc.sh ]; then
    rm -rf /usr/bin/auto_uvc.sh
	cp -p /usr/bin/auto_uvc.sh.bak /usr/bin/auto_uvc.sh
	rm -rf /usr/bin/auto_uvc.sh.bak
fi


# return original 60-v4l if backup exists
if [ -e /etc/hotplug.d/usb/60-v4l.bak ] && [ -e /etc/hotplug.d/usb/60-v4l ]; then
    rm -rf /etc/hotplug.d/usb/60-v4l
	cp -p /etc/hotplug.d/usb/60-v4l.bak /etc/hotplug.d/usb/60-v4l
	rm -rf /etc/hotplug.d/usb/60-v4l.bak
fi

# remove the old symlinks
rm -rf /usr/bin/ustreamer_static_arm32
rm -rf /usr/bin/start_recording.sh
rm -rf /usr/bin/stop_recording.sh
rm -rf /mnt/UDISK/printer_data/config/camera_macro.cfg
rm -rf /usr/share/klipper/klippy/extras/gcode_shell_command.py

echo "Installation complete. reboot the system to apply changes."