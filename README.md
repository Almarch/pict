# pict

The Plant insect Interactions Camera Trap (PICT), is a DIY, low-cost, weather-resistant camera designed to be autonomous, energy efficient and modular. Its architecture is based on a Raspberry Pi single board computer.

This git repository aims at providing the resources to build a PICT from a Raspberry Pi Zero and the appropriate peripherals including a camera.

## Resources

The method is described in a paper in Method in Ecology and Evolution :
https://doi.org/10.1111/2041-210X.13618

A user manual is periodically updated and can be downloaded from:
https://doi.org/10.5281/zenodo.4139838

It is also provided in the [doc](doc/) folder.

## Build a prototype

### Hardware

- Raspberry Pi Zero board

- Micro SD card and adapter to your desktop computer (either micro SD-to-SD, either micro SD-to-USB)

- Raspberry Pi Camera "NoIR" with 1 IR LED.

- Camera flat cable. This should have a small side for the Raspberry Pi board and a larger side for the camera.

- Mini HDMI-to-HDMI adapter

- Micro USB-to-USB adapter

Note that mini HDMI-to-HDMI and micro USB-to-USB are commonly sold together as a Raspberry Pi Zero adapter kit.

- Micro-USB charger

- Multi-USB dispatcher, to which are connected a USB mouse and a USB keyboard

- Computer screen with a HDMI cable

### Flash the OS

From a desktop computer, install [Raspberry Pi Imager](https://raspberrypi.com/software). Connect the micro SD to the desktop computer using the relevant adapter. Using Raspberry Pi Imager, flash the OS to the SD card with the following parameters:

- Device = Raspberry Pi Zero

- OS = Raspberry Pi OS Legacy 32-bits. This is the default, recommanded one and the version name is Bullseye.

### Set up the Raspberry board

Once the SD card has been written, insert it within the Raspberry Pi Zero board. Connect to the board your screen (using the micro HDMI-to-HDMI adapter), your mouse and keyboard (using the micro USB-to-USB adapter, beware to use the "USB" port and not the "PWR" one), the camera (using the flat cable). Beware the camera flat cable is in the right sense, the IR LED should glow when it is properly plugged.

Finally, power the board with from the "PWR" micro USB port. You will have to parameterize the OS installation, which is straightforward. I suggest using the English language as all documentation and help will be found using English keywords and error messages. Provide the wifi ID and password at the installation step so that the software will be updated right ahead.

Once the OS is installed, the board launches as a regular desktop computer. If you use a non-qwerty keyboard, set it up as a first step. Go to the raspberry logo / Preferences / Keyboard and mouse / Keyboard / Layout and select the appropriate layout.

The next important step is to enable the camera. Open the terminal, and access the Configuration pane:

```{bash}
sudo raspi-config
```

Select: 3. Interface options / I1. Legacy camera / yes.

Then Finish / yes to the reboot proposition.

Once the board is rebooted, open the terminal and prepare pict:

```{bash}
cd ~/
mkdir record
git clone https://github.com/almarch/pict.git 
```

/// energy saving: bluetooth,...

/// connection to smartphone

## Scale up

Now that we have a working prototype, the next step will be to clone it to as many PICT as needed.

The hardware of each PICT has to be build as described in the doc file.

The software can be cloned from one SD card to the user using (...).

## Smartphone connectivity


## Post-hoc analysis

Post-hoc analysis can be achieved using the matlab script provided in the [src](src/) folder. 
