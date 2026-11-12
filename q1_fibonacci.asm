; ============================================================
; Q1 : Print 'n' terms of the Fibonacci series   (x86, 32-bit)
; Assembler : NASM        Calling convention : cdecl
; Called from C as :  void print_fib(int n);
; ============================================================

global  print_fib               ; make the label visible to the C linker
extern  printf                  ; we use C's printf to print each term

section .data
    fmt     db  "%u ", 0        ; format string: unsigned number + space
    newline db  10, 0           ; "\n"

section .text

print_fib:
    ; ---------- function prologue ----------
    push    ebp                 ; save caller's base pointer
    mov     ebp, esp            ; ebp now points to our stack frame
    push    ebx                 ; ebx, esi, edi are callee-saved in cdecl,
    push    esi                 ; so we must save them before using them
    push    edi
    sub     esp, 12             ; space for printf arguments
                                ; (also keeps the stack 16-byte aligned)

    ; ---------- initialise ----------
    mov     ebx, [ebp + 8]      ; ebx = n   (first argument sits at ebp+8)
    xor     esi, esi            ; esi = a = 0   (current term)
    mov     edi, 1              ; edi = b = 1   (next term)

.loop:
    cmp     ebx, 0              ; any terms left to print?
    jle     .done               ; if counter <= 0, stop

    ; ---------- printf("%u ", a) ----------
    mov     dword [esp], fmt    ; 1st argument : address of format string
    mov     [esp + 4], esi      ; 2nd argument : current term
    call    printf              ; (printf may change eax, ecx, edx only)

    ; ---------- compute the next term ----------
    mov     eax, esi            ; eax = a
    add     eax, edi            ; eax = a + b
    mov     esi, edi            ; a = b
    mov     edi, eax            ; b = a + b

    dec     ebx                 ; one term printed, decrease the counter
    jmp     .loop               ; repeat

.done:
    ; ---------- printf("\n") ----------
    mov     dword [esp], newline
    call    printf

    ; ---------- function epilogue ----------
    add     esp, 12             ; remove the argument space
    pop     edi                 ; restore saved registers (reverse order)
    pop     esi
    pop     ebx
    pop     ebp
    ret                         ; return to C

section .note.GNU-stack noalloc noexec nowrite progbits   ; non-executable stack
