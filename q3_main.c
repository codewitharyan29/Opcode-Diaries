/* ============================================================
 * Q3 : Linear search - C driver
 * Reads 'n' elements and a key, then calls the assembly routine.
 * ============================================================ */
#include <stdio.h>

#define MAX 100                 /* maximum array size */

/* Defined in q3_linear_search.asm
 * Returns the index of key in arr, or -1 if it is not present. */
int linear_search(int *arr, int n, int key);

int main(void)
{
    int arr[MAX];
    int n, i, key, pos;

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

    printf("Enter the element to search: ");
    if (scanf("%d", &key) != 1) {
        printf("Invalid key.\n");
        return 1;
    }

    pos = linear_search(arr, n, key);   /* assembly routine does the search */

    if (pos == -1)
        printf("%d is not present in the array.\n", key);
    else
        printf("%d found at index %d (position %d).\n", key, pos, pos + 1);

    return 0;
}
