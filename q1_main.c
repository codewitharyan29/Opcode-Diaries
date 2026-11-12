/* ============================================================
 * Q1 : Fibonacci series - C driver
 * Takes 'n' from the user and calls the assembly routine.
 * ============================================================ */
#include <stdio.h>

/* Defined in q1_fibonacci.asm */
void print_fib(int n);

int main(void)
{
    int n;

    printf("Enter the number of terms (1 to 48): ");

    /* Validate: must be a number, and the 49th term overflows 32 bits */
    if (scanf("%d", &n) != 1 || n < 1 || n > 48) {
        printf("Invalid input. n must be between 1 and 48.\n");
        return 1;
    }

    printf("Fibonacci series: ");
    print_fib(n);               /* assembly routine prints the n terms */

    return 0;
}
