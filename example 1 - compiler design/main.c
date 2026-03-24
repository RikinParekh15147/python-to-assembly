#include <stdio.h>

int main() {
    // The following preprocessor conditionals check which OS is being compiled on

    #ifdef WIN32
        // This macro is defined when compiling on Windows
        printf("Hello from Windows\n");

    #elif defined(__linux__)
        // This macro is defined when compiling on Linux
        printf("Hello from Linux\n");

    #elif defined(__APPLE__)
        // This macro is defined when compiling on macOS
        printf("Hello from macOS\n");

    #else
        // Fallback if the OS is not recognized
        printf("Hello from an unknown OS\n");
    #endif

    return 0;
}