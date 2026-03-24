#include <stdio.h>
#include "mylib.h"

void printNumber(int number) {
    printf("%d\n", number);
}

int factorial(int n) {
    if (n <= 1) {   
        return 1;
    }
    return n * factorial(n - 1); 
}