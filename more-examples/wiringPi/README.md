# Wiring Pi

Blinking an LED using `wiringPi`.

## Instructions

- Install wiringPi to the Pi:
  ```sh
  sudo apt install wiringpi
  ```
- Install wiringPi to the schroot on your development machine:
  ```sh
  sudo sbuild-apt schroot-name-arm64 apt-get install libwiringpi-dev
  ```
- Connect an LED (+ series resistor) to [GPIO24](https://projects.raspberrypi.org/en/projects/rpi-gpio-pins).
- Configure this project:
  ```sh
  cmake -S. -Bbuild -DCMAKE_TOOLCHAIN_FILE="../../cmake/aarch64-rpi3-linux-gnu.cmake"
  ```
- Build the example:
  ```sh
  cmake --build build
  ```
- Copy the program to the Pi:
  ```sh
  scp build/blink RPi3:~
  ```
- Connect to the Pi:
  ```sh
  ssh RPi3
  ```
- Run the program:
  ```sh
  ./blink
  ```
