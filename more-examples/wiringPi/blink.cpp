#include <wiringPi.h>

const int led_pin = 24;

int main() {
    wiringPiSetupGpio();
    pinMode(led_pin, OUTPUT);
    while (1) {
        digitalWrite(led_pin, HIGH);
        delay(500);
        digitalWrite(led_pin, LOW);
        delay(500);
    }
}