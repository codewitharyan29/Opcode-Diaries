/* ============================================================
 * Q2 : Bubble sort - C driver
 * Reads 'n' elements into an array and calls the assembly routine.
 * ============================================================ */
#include <stdio.h>

#define MAX 100                 /* maximum array size */

/* Defined in q2_bubble_sort.asm */
void bubble_sort(int *arr, int n);

int main(void)
{
    int arr[MAX];
    int n, i;

    printf("Enter the number of elements (1 to %d): ", MAX);
    if (scanf("%d", &n) != 1 || n < 1 || n > MAX) {
        printf("Invalid size.\n");
        return 1;
    }

    /* Read the n elements */
    printf("Enter %d integers:\n", n);
    for (i = 0; i < n; i++) {
        if (scanf("%d", &arr[i]) != 1) {
            printf("Invalid element.\n");
            return 1;
        }
    }

    bubble_sort(arr, n);        /* assembly routine sorts the array in place */

    /* Print the sorted array */
    printf("Sorted array: ");
    for (i = 0; i < n; i++)
        printf("%d ", arr[i]);
    printf("\n");

    return 0;
}
