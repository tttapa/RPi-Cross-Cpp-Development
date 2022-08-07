# gpiod

Blinking an LED using `libgpiod`.

## Instructions

- Install `gpiod` on the Pi:
  ```sh
  sudo apt install gpiod
  ```
- Install `libgpiod-dev` on your development machine (change the name of the schroot accordingly):
  ```sh
  sudo sbuild-apt schroot-name-arm64 apt-get install libgpiod-dev
  ```
- On the Pi, run `gpiodetect` to list all GPIO devices, use the correct device label (e.g. `pinctrl-bcm2835`) in `blink.cpp`.
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