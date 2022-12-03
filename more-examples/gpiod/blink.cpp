#include <chrono>
#include <gpiod.hpp>
#include <thread>
using namespace std::chrono_literals;

const int led_pin_number = 24;

int main() {
    gpiod::chip gpio {"pinctrl-bcm2835", gpiod::chip::OPEN_BY_LABEL};
    auto led_pin = gpio.get_line(led_pin_number);
    led_pin.request({"LED", gpiod::line_request::DIRECTION_OUTPUT});

    while (1) {
        led_pin.set_value(1); // LED on
        std::this_thread::sleep_for(500ms);
        led_pin.set_value(0); // LED off
        std::this_thread::sleep_for(500ms);
    }
}