#include <Arduino.h>

#define LED1 2
#define LED2 4

unsigned long prevTime1 = 0;
unsigned long prevTime2 = 0;

bool led1State = LOW;
bool led2State = LOW;

void setup() {
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
}

void loop() {
  unsigned long currentMillis = millis();

  // Task 1 (1 sec interval)
  if (currentMillis - prevTime1 >= 1000) {
    prevTime1 = currentMillis;
    led1State = !led1State;
    digitalWrite(LED1, led1State);
  }

  // Task 2 (0.5 sec interval)
  if (currentMillis - prevTime2 >= 500) {
    prevTime2 = currentMillis;
    led2State = !led2State;
    digitalWrite(LED2, led2State);
  }
}