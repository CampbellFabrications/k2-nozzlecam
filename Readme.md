# K2 Extruder Nozzle-Cam Project

more documentation will be added soon.

This project lets you install the 3DO Nozzle Camera V2 into the K2 Plus (and potentially the K2 & K2 Pro) Series Extruder.
there are printable .STEP files to _replace_ the stock AI Camera, and files to keep the stock AI Camera.
I recommend printing those parts in ASA or any CF composite of ASA.

There is currently no place to mount the 3DO Camera board if you choose to keep the Stock AI Camera, however i've had success storing it next to the extruder toolboard, in the rear of the extruder carriage, provided your clips are intact.

Personally, I recommend removing the Stock AI Camera, there's not much benefit from having it, despite a few calibrations that use it.

## Installation

Run `./install.sh` to drag all the required files over, and include a handy recording macro into your printer.cfg
Simple as that.

Below you will find a modified readme of the 3DO Nozzle Camera provided by 3DO's github.
Feel free to refer to the User Controls section for command functionality.
Results may vary depending on hardware installation, you will likely end up experimenting with different `set-ctrls` parameters set to your liking.
I'll be providing my commands used here for reference until such time as a front-end UI can me made to control the camera without touching the commandline.


## FPC Cable Options
- 5cm - Needs LED's
- 10cm - Needs LED's
- 25cm - Needs LED's
- 5cm with LEDs - Recommended (but not tested) for K2 Plus
- 10cm with LEDs - Tested for K2 Plus
- 25cm with LEDs - Too Long for K2 Plus

## Camera Options
- **Nozzle Camera (Glued)**: Not Recommended.
- **Nozzle Camera (Adjustable)**: Lens focus can be adjusted by rotating the lens.
- **Enclosure Camera (Adjustable)**: Lens focus can be adjusted by rotating the lens, FoV 120°.

## Specifications
|                         | 4K (Sony IMX258)     	|
|-------------------------|-------------------------|
| Sensor Size             | 1/3.06               	|
| Mega-Pixel              | 13MP                 	|
| Frame Rate*             | 30FPS@4K 60FPS@1080P*	|
| Operating temperature** | -20°C TO 65°C (85°C**)	|

_*Frame rates are achievable when connected directly. Performance may vary with different streaming setups._
_**Tested for 48hrs without issue, use with caution._
### User Controls

| Control                     | Details                                                                 |
|-----------------------------|-------------------------------------------------------------------------|
| **brightness**              | min=0, max=64, step=1, default=15                                       |
| **contrast**                | min=0, max=95, step=1, default=4                                        |
| **saturation**              | min=0, max=100, step=1, default=70                                      |
| **hue**                     | min=-2000, max=2000, step=1, default=0                                  |
| **white_balance_automatic** | default=1                                                               |
| **gamma**                   | min=1, max=300, step=1, default=115                                     |
| **gain**                    | (ISO control) min=0, max=480, step=1, default=0                         |
| **power_line_frequency**    | min=0, max=2, default=1                                                 |
|                             | 0: Disabled                                                             |
|                             | 1: 50 Hz                                                                |
|                             | 2: 60 Hz                                                                |
| **white_balance_temperature** | min=2800, max=6500, step=1, default=4600, flags=inactive              |
| **sharpness**               | min=1, max=7, step=1, default=1                                         |
| **backlight_compensation**  | min=0, max=2, step=1, default=1                                         |
|                             | 0: LED off                                                              |
|                             | 1: LED on when stream is open                                           |
|                             | 2: LED always on                                                        |

### Camera Controls

| Control                    | Details                                                                  |
|----------------------------|--------------------------------------------------------------------------|
| **auto_exposure**          | min=0, max=3, default=3                                                  |
|                            | 1: Manual Mode                                                           |
|                            | 3: Aperture Priority Mode                                                |
| **exposure_time_absolute** | min=3, max=2047, step=1, default=166, flags=inactive                     |
| **pan_absolute**           | min=-648000, max=648000, step=3600, default=0                            |
| **tilt_absolute**          | min=-648000, max=648000, step=3600, default=0                            |
| **focus_absolute**         | min=0, max=1023, step=1, default=0, flags=inactive                       |
| **focus_automatic_continuous** | default=0                                                           |
| **zoom_absolute**          | min=0, max=60, step=1, default=0                                         |

**Notes:**

- `exposure_time_absolute` controls the shutter speed and can only be set when `auto_exposure` is in manual mode.

- PTZ controls (`pan_absolute`, `tilt_absolute`, `zoom_absolute`) are used to crop the image. All 30fps streams are downscaled to 4K, and all 60fps streams are downscaled to 1080p. To use the crop feature, you need to select a downscaled stream.

