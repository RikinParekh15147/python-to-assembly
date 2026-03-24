#include <stdio.h>
#include "mylib.h"

int main() {
    printf("Program started\n");

    int num = 10;
    int result = factorial(num);

    printf("Factorial calculated\n");

    printNumber(result);

    printf("Program ended\n");

    return 0;
}