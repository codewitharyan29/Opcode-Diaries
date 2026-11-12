/* ============================================================
 * Q4 : Menu-driven string operations - C driver
 * Handles all input from the user and passes the string to the
 * assembly routine, which runs the menu and does the operations.
 * ============================================================ */
#include <stdio.h>
#include <string.h>

#define MAX 100                 /* size of the string buffer */

/* Defined in q4_string_menu.asm */
void string_menu(char *str);

/* Throw away the rest of the current input line (including '\n') */
static void clear_line(void)
{
    int c;
    while ((c = getchar()) != '\n' && c != EOF)
        ;
}

/* Called from assembly (option 1) and from main:
 * reads one line of text into buf and removes the trailing newline. */
void input_string(char *buf)
{
    printf("Enter a string: ");
    if (fgets(buf, MAX, stdin) == NULL)
        buf[0] = '\0';                  /* no input -> empty string */
    buf[strcspn(buf, "\n")] = '\0';     /* strip the newline, if any */
}

/* Called from assembly: reads the menu choice and returns it. */
int input_choice(void)
{
    int choice;
    int result = scanf("%d", &choice);

    if (result == EOF)
        return 7;                       /* input closed -> behave like Exit */

    clear_line();                       /* remove leftover characters */

    if (result != 1)
        return 0;                       /* not a number -> invalid choice */
    return choice;
}

/* Called from assembly (option 6): reads one character and returns it. */
int input_char(void)
{
    char ch = '\0';

    printf("Enter the character to search: ");
    if (scanf(" %c", &ch) == 1)         /* leading space skips whitespace */
        clear_line();
    return (unsigned char)ch;
}

int main(void)
{
    char str[MAX];

    input_string(str);          /* take the string from the user */
    string_menu(str);           /* pass it to the assembly program */

    return 0;
}
