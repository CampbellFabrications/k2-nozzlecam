import subprocess
import re
import json
from moonraker import MoonrakerRequestHandler, printer

class V4LControlsExtension:
    def __init__(self, app):
        self.app = app
        self.register_routes()

    def register_routes(self):
        # GET camera info
        @self.app.route("/server/v4l/cameras")
        async def cameras(request):
            cams = self.discover_cameras()
            return self.app.json_response(cams)

        # GET controls for a given role
        @self.app.route("/server/v4l/controls")
        async def controls(request):
            role = request.query.get("role", "nozzle")
            cams = self.discover_cameras()
            if role not in cams:
                return self.app.json_response({"error": "Unknown camera role"}, status=404)

            device = f"/dev/{cams[role]['device']}"
            ctrls = self.get_v4l_controls(device)
            return self.app.json_response({"device": device, "controls": ctrls})

        # POST to set a control
        @self.app.route("/server/v4l/set", methods=["POST"])
        async def set_control(request):
            body = await request.json()
            device = body.get("device")
            name = body.get("name")
            value = body.get("value")
            if not all([device, name, value is not None]):
                return self.app.json_response({"error": "Missing fields"}, status=400)

            try:
                subprocess.run(["v4l2-ctl", "--device", device, f"--set-ctrl={name}={value}"], check=True)
                return self.app.json_response({"status": "ok"})
            except subprocess.CalledProcessError as e:
                return self.app.json_response({"error": str(e)}, status=500)

    def discover_cameras(self):
        cams = {}
        # iterate over /dev/video*
        for dev in subprocess.getoutput("ls /dev/video*").splitlines():
            info = subprocess.getoutput(f"udevadm info -a -n {dev}")

            # get index
            m = re.search(r'ATTR\{index\}=="(\d+)"', info)
            if not m or m.group(1) != "0":
                continue

            # interface name
            m_name = re.search(r'ATTRS\{interface\}=="([^"]+)"', info)
            if not m_name:
                continue
            name = m_name.group(1)

            # USB path
            m_path = re.search(r'KERNELS=="([^"]+)"', info)
            iface = m_path.group(1) if m_path else ""

            # role assignment
            role = None
            if "CREALITY CAM" in name:
                role = "chamber"
            elif "3DO USB CAMERA V2" in name:
                role = "nozzle"
            if not role:
                continue

            cams[role] = {
                "device": dev.replace("/dev/", ""),
                "interface": name,
                "usb_path": iface
            }

        return cams

    def get_v4l_controls(self, device):
        """Parses v4l2-ctl --list-ctrls output into structured dicts"""
        output = subprocess.getoutput(["v4l2-ctl", "--device", device, "--list-ctrls"])
        controls = []

        pattern = re.compile(
            r"(?P<name>\S+)\s+0x[0-9a-fA-F]+ \((?P<type>\w+)\)\s*: "
            r"(?:min=(?P<min>-?\d+)\s+max=(?P<max>-?\d+)\s+step=(?P<step>\d+)\s+default=(?P<default>-?\d+)\s+)?value=(?P<value>-?\d+|0|1)"
        )

        for line in output.splitlines():
            m = pattern.match(line.strip())
            if not m:
                continue
            gd = m.groupdict()
            ctrl = {
                "name": gd["name"],
                "type": gd["type"],
                "value": int(gd["value"]) if gd["type"] != "bool" else bool(int(gd["value"]))
            }
            if gd["type"] == "int":
                ctrl.update({
                    "min": int(gd["min"]),
                    "max": int(gd["max"]),
                    "step": int(gd["step"]),
                    "default": int(gd["default"])
                })
            controls.append(ctrl)
        return controls