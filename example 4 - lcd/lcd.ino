// to run a 16x2 LCD with AVR microcontroller atmega328p using C language

#define F_CPU 8000000UL
#include <avr/io.h>
#include <util/delay.h>

// Control Pins
#define RS PD0
#define RW PD1
#define E  PD2

// Function to send command
void lcd_command(unsigned char cmd) {
    PORTB = cmd;                  // Send command to data port
    PORTD &= ~(1 << RS);          // RS = 0 (Command)
    PORTD &= ~(1 << RW);          // RW = 0 (Write)
    
    PORTD |= (1 << E);            // Enable pulse
    _delay_ms(2);
    PORTD &= ~(1 << E);
}

// Function to send data
void lcd_data(unsigned char data) {
    PORTB = data;                 // Send data to LCD
    PORTD |= (1 << RS);           // RS = 1 (Data)
    PORTD &= ~(1 << RW);          // RW = 0 (Write)
    
    PORTD |= (1 << E);            // Enable pulse
    _delay_ms(2);
    PORTD &= ~(1 << E);
}

// LCD initialization
void lcd_init() {
    DDRB = 0xFF;                  // PORTB as output (Data)
    DDRD |= (1 << RS) | (1 << RW) | (1 << E);  // Control pins output

    _delay_ms(20);                // LCD power ON delay

    lcd_command(0x38);            // 8-bit mode, 2 lines, 5x7 font
    lcd_command(0x0C);            // Display ON, Cursor OFF
    lcd_command(0x06);            // Entry mode
    lcd_command(0x01);            // Clear display
    _delay_ms(2);
}

// Function to print string
void lcd_string(const char *str) {
    while (*str) {
        lcd_data(*str++);
    }
}

int main(void) {
    lcd_init();                   // Initialize LCD

    lcd_string("Hello Rikin");    // Print message

    while (1) {
        // Loop forever
    }
}