# Python to Assembly - Lecture Examples

This repository contains a set of lecture examples that move from basic compiler concepts to embedded and RTOS programming.

The folders are intentionally independent. Each example demonstrates a specific concept and can be run on its own.

## Repository Overview

1. `example 1 - compiler design`
2. `example 2 - library`
3. `example 3 - compiler+interpreter`
4. `example 4 - lcd`
5. `example 5 - rtos`

## Prerequisites

Depending on which example you want to run, you may need:

- GCC toolchain for C examples (`gcc`)
- Rust toolchain for the interpreter/window example (`rustup`, `cargo`)
- AVR toolchain for ATmega328P (`avr-gcc`, `avr-libc`, uploader)
- Arduino IDE / PlatformIO for `.ino` sketches
- ESP32 board support package for FreeRTOS example on ESP

## Example 1 - Compiler Design (`example 1 - compiler design`)

### What it demonstrates

- Preprocessor conditionals for platform detection (`WIN32`, `__linux__`, `__APPLE__`)
- The transformation pipeline from C source to preprocessed output and assembly

### Files

- `main.c`: source code with OS-dependent `printf` branches
- `main.i`: preprocessed C output (expanded includes/macros)
- `main.s`: generated assembly output

### Run / Reproduce

```bash
# Compile and run
gcc "example 1 - compiler design/main.c" -o ex1
./ex1

# Save generated intermediary file
gcc "example 1 - compiler design/main.c" -o "example 1 - compiler design/main.c" --save-temps
```

## Example 2 - Library (`example 2 - library`)

### What it demonstrates

- Splitting code into a reusable C library (`.h` + `.c`)
- Recursive function implementation (`factorial`)
- Linking multiple translation units

### Files

- `main.c`: app entry point, calls library functions
- `mylib.h`: declarations
- `mylib.c`: implementations (`printNumber`, `factorial`)

### Run

```bash
gcc "example 2 - library/main.c" "example 2 - library/mylib.c" -o ex2
./ex2
```

Expected behavior:

- Prints program start/end logs
- Computes `factorial(10)` and prints the result

## Example 3 - Compiler + Interpreter (`example 3 - compiler+interpreter`)

### What it demonstrates

- A custom mini-language interpreter in Rust
- Lexing, parsing (Pratt parser), expression evaluation, labels/jumps
- Shared interpreter state with thread-safe synchronization (`RwLock`)
- Real-time visualization in a desktop window using `winit` + `pixels`

### Files

- `src/lib_interpreter.rs`: language runtime
	- value model (`Int`, `Bool`)
	- statement types (`Assign`, `Jump`, `IfJump`, `Print`, `Sleep`)
	- lexer + parser
	- interpreter execution loop and threaded runner
- `src/window.rs`: window/event loop wrapper and frame drawing context
- `src/main.rs`: wires interpreter thread to render callbacks
- `script.txt`: demo script controlling square movement and RGB background
- `Cargo.toml`: Rust dependencies and package metadata

### Run

```bash
cd "example 3 - compiler+interpreter"
cargo run --release
```

How the demo works:

- Script updates `x`, `y`, `dx`, `dy` continuously
- Collision checks invert direction at boundaries
- Script computes color channels (`r`, `g`, `b`) from distance metrics
- Window callback reads those variables every frame and renders a moving white square

## Example 4 - LCD (`example 4 - lcd`)

### What it demonstrates

- Driving a 16x2 character LCD with an ATmega328P
- Two approaches to the same hardware task:
	- Low-level AVR assembly
	- C/Arduino-style code

### Files

- `lcd.asm`: AVR assembly implementation
	- LCD init sequence
	- command/data writes
	- busy-flag polling
	- cursor movement/backspace/line control
- `lcd.ino`: C++ Arduino sketch using direct AVR register access

### Typical workflow

- Assemble/flash `lcd.asm` using AVR tools for bare-metal workflow
- Or upload `lcd.ino` via Arduino IDE for a higher-level workflow
- Use an ISP programmer for flashing the AVR target when working at register/assembly level
- Use Atmel Studio to compile and simulate the AVR code
- Or use Proteus to simulate both the assembly and Arduino/C variants

Note:

- Pin mapping and LCD wiring must match the definitions in code (`PORTB` data lines and `PORTD` control lines).

## Example 5 - RTOS (`example 5 - rtos`)

### What it demonstrates

- Cooperative, non-blocking multitask behavior without RTOS (`esp.ino`)
- Native FreeRTOS task scheduling (`esp-rtos.ino`)

### Files

- `esp.ino`:
	- Uses `millis()` to schedule two independent LED blink intervals
	- Single-loop architecture (manual time slicing)
- `esp-rtos.ino`:
	- Creates two FreeRTOS tasks via `xTaskCreate`
	- Uses `vTaskDelay` for periodic task timing
	- Leaves `loop()` empty because scheduler owns execution

### Run

- Select your ESP board in Arduino IDE / PlatformIO.
- Upload either sketch depending on the lecture mode (without RTOS vs with RTOS).

## Suggested Learning Path

1. Start with Example 1 to understand source-to-assembly flow.
2. Continue to Example 2 for modular C project structure.
3. Move to Example 3 for language implementation concepts.
4. Explore Example 4 for low-level peripheral control.
5. Finish with Example 5 to compare scheduler styles on embedded systems.

## Notes

- `target/` inside Example 3 contains Rust build artifacts and can be large.
- Examples are lecture-oriented and may prioritize clarity over production hardening.
