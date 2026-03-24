#include <Arduino.h>

#define LED1 2
#define LED2 4

// Task 1
void Task1(void *pvParameters) {
  while (1) {
    digitalWrite(LED1, HIGH);
    vTaskDelay(1000 / portTICK_PERIOD_MS);
    digitalWrite(LED1, LOW);
    vTaskDelay(1000 / portTICK_PERIOD_MS);
  }
}

// Task 2
void Task2(void *pvParameters) {
  while (1) {
    digitalWrite(LED2, HIGH);
    vTaskDelay(500 / portTICK_PERIOD_MS);
    digitalWrite(LED2, LOW);
    vTaskDelay(500 / portTICK_PERIOD_MS);
  }
}

void setup() {
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);

  // Create tasks
  xTaskCreate(
    Task1,        // Function
    "Task1",      // Name
    1000,         // Stack size
    NULL,         
    1,            // Priority
    NULL
  );

  xTaskCreate(
    Task2,
    "Task2",
    1000,
    NULL,
    1,
    NULL
  );
}

void loop() {
  // Empty because RTOS handles tasks
}