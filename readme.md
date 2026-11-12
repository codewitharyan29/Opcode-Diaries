# Opcode Diaries



x86 and x86-64 assembly programs (NASM) called from C.

Microprocessor Theory & Applications (AIC3092), Assignment II.



**Aryan Verma** | Enrollment No.: GQ0251 | Faculty No.: 24AIBEA124



## Programs



| # | Program | Architecture | Files |

|---|---------|--------------|-------|

| 1 | Fibonacci series | x86 (32-bit) | `q1_fibonacci.asm`, `q1_main.c` |

| 2 | Bubble sort | x86-64 | `q2_bubble_sort.asm`, `q2_main.c` |

| 3 | Linear search | x86-64 | `q3_linear_search.asm`, `q3_main.c` |

| 4 | Menu-driven string operations | x86 (32-bit) | `q4_string_menu.asm`, `q4_main.c` |



In each program, the C file handles input and calls the assembly function.



## Video explanations



- Q1, Fibonacci series: https://youtu.be/jfxi3YD_bzo

- Q2, Bubble sort: https://youtu.be/XySeptePpHI

- Q3, Linear search: https://youtu.be/25kTen5jomo

- Q4, Menu-driven string operations: https://youtu.be/H2RKkF0LtF4



## Requirements



Linux or WSL (Ubuntu) with NASM and GCC:



```bash

sudo apt install nasm gcc gcc-multilib

```



## Build and run



Q1 (32-bit):



```bash

nasm -f elf32 q1_fibonacci.asm -o q1.o

gcc -m32 -no-pie q1_main.c q1.o -o q1

./q1

```



Q2 (64-bit):



```bash

nasm -f elf64 q2_bubble_sort.asm -o q2.o

gcc -no-pie q2_main.c q2.o -o q2

./q2

```



Q3 (64-bit):



```bash

nasm -f elf64 q3_linear_search.asm -o q3.o

gcc -no-pie q3_main.c q3.o -o q3

./q3

```



Q4 (32-bit):



```bash

nasm -f elf32 q4_string_menu.asm -o q4.o

gcc -m32 -no-pie q4_main.c q4.o -o q4

./q4

```



## Calling conventions used



- **32-bit (Q1, Q4):** cdecl, arguments are passed on the stack and read from `[ebp + 8]`.

- **64-bit (Q2, Q3):** System V AMD64, arguments are passed in registers `rdi`, `esi`, `edx`.
