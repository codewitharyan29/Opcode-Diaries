; ============================================================
; Q4 : Menu-driven string operations   (x86, 32-bit)
; Assembler : NASM        Calling convention : cdecl
; Called from C as :  void string_menu(char *str);
;
; The C file handles all keyboard input (string, menu choice,
; character). This file runs the menu loop and performs every
; string operation itself.
; ============================================================

global  string_menu             ; make the label visible to the C linker

extern  printf                  ; C library : formatted output
extern  input_string            ; C file : void input_string(char *buf)
extern  input_choice            ; C file : int  input_choice(void)
extern  input_char              ; C file : int  input_char(void)

section .data
    menu_txt    db  10
                db  "========== STRING MENU ==========", 10
                db  "1. Accept a string", 10
                db  "2. Display the string", 10
                db  "3. Find the length of the string", 10
                db  "4. Reverse the string", 10
                db  "5. Check for palindrome", 10
                db  "6. Search for a character", 10
                db  "7. Exit", 10
                db  "Enter your choice: ", 0

    msg_show    db  "String: %s", 10, 0
    msg_len     db  "Length = %d", 10, 0
    msg_rev     db  "Reversed string: %s", 10, 0
    msg_pal     db  "The string is a palindrome.", 10, 0
    msg_notpal  db  "The string is NOT a palindrome.", 10, 0
    msg_found   db  "Character '%c' found at position %d.", 10, 0
    msg_nfound  db  "Character '%c' is not present in the string.", 10, 0
    msg_invalid db  "Invalid choice. Try again.", 10, 0
    msg_bye     db  "Exiting.", 10, 0

section .text

; ------------------------------------------------------------
; my_strlen : helper routine (used only inside this file)
;   in  : ebx = address of a null-terminated string
;   out : eax = length (number of characters before the 0 byte)
; ------------------------------------------------------------
my_strlen:
    xor     eax, eax                ; eax = length counter = 0
.count:
    cmp     byte [ebx + eax], 0     ; reached the terminating 0 ?
    je      .end                    ; yes -> eax holds the length
    inc     eax                     ; no  -> count this character
    jmp     .count
.end:
    ret

; ------------------------------------------------------------
; string_menu(char *str) : the menu loop
; ------------------------------------------------------------
string_menu:
    ; ---------- function prologue ----------
    push    ebp                     ; save caller's base pointer
    mov     ebp, esp                ; set up our stack frame
    push    ebx                     ; ebx, esi, edi are callee-saved,
    push    esi                     ; so save them before using them
    push    edi
    sub     esp, 12                 ; space for up to 3 function arguments
                                    ; (also keeps the stack 16-byte aligned)

    mov     ebx, [ebp + 8]          ; ebx = address of the string (kept
                                    ; in ebx for the whole function)

.menu:
    ; ---------- show the menu and read the choice ----------
    mov     dword [esp], menu_txt   ; argument : menu text
    call    printf
    call    input_choice            ; C function, choice returned in eax

    ; ---------- jump to the selected option ----------
    cmp     eax, 1
    je      .accept
    cmp     eax, 2
    je      .display
    cmp     eax, 3
    je      .length
    cmp     eax, 4
    je      .reverse
    cmp     eax, 5
    je      .palindrome
    cmp     eax, 6
    je      .search
    cmp     eax, 7
    je      .exit

    mov     dword [esp], msg_invalid ; anything else is an invalid choice
    call    printf
    jmp     .menu

; ---------- 1. Accept a string ----------
.accept:
    mov     [esp], ebx              ; argument : buffer address
    call    input_string            ; C function reads a new string into it
    jmp     .menu

; ---------- 2. Display the string ----------
.display:
    mov     dword [esp], msg_show   ; argument 1 : format string
    mov     [esp + 4], ebx          ; argument 2 : the string
    call    printf
    jmp     .menu

; ---------- 3. Find the length ----------
.length:
    call    my_strlen               ; eax = length of the string
    mov     dword [esp], msg_len    ; argument 1 : format string
    mov     [esp + 4], eax          ; argument 2 : the length
    call    printf
    jmp     .menu

; ---------- 4. Reverse the string (in place) ----------
.reverse:
    call    my_strlen               ; eax = length
    mov     esi, ebx                ; esi -> first character
    lea     edi, [ebx + eax - 1]    ; edi -> last character
.rev_loop:
    cmp     esi, edi                ; have the two pointers met or crossed?
    jae     .rev_done               ; yes -> the whole string is reversed
    mov     al, [esi]               ; al = character from the front
    mov     dl, [edi]               ; dl = character from the back
    mov     [esi], dl               ; swap the two characters
    mov     [edi], al
    inc     esi                     ; front pointer moves forward
    dec     edi                     ; back pointer moves backward
    jmp     .rev_loop
.rev_done:
    mov     dword [esp], msg_rev    ; print the reversed string
    mov     [esp + 4], ebx
    call    printf
    jmp     .menu

; ---------- 5. Palindrome check ----------
.palindrome:
    call    my_strlen               ; eax = length
    mov     esi, ebx                ; esi -> first character
    lea     edi, [ebx + eax - 1]    ; edi -> last character
.pal_loop:
    cmp     esi, edi                ; pointers met or crossed?
    jae     .is_pal                 ; every pair matched -> palindrome
    mov     al, [esi]               ; character from the front
    cmp     al, [edi]               ; same as the character from the back?
    jne     .not_pal                ; one mismatch -> not a palindrome
    inc     esi                     ; move both pointers towards the middle
    dec     edi
    jmp     .pal_loop
.is_pal:
    mov     dword [esp], msg_pal
    call    printf
    jmp     .menu
.not_pal:
    mov     dword [esp], msg_notpal
    call    printf
    jmp     .menu

; ---------- 6. Search for a character ----------
.search:
    call    input_char              ; C function, character returned in eax (al)
    mov     esi, ebx                ; esi -> first character of the string
.srch_loop:
    mov     dl, [esi]               ; dl = current character
    test    dl, dl                  ; end of string (0 byte)?
    jz      .srch_nf                ; yes -> character is not present
    cmp     dl, al                  ; is it the character we want?
    je      .srch_found
    inc     esi                     ; move to the next character
    jmp     .srch_loop
.srch_found:
    sub     esi, ebx                ; esi = index of the match (0-based)
    inc     esi                     ; convert to a 1-based position
    movzx   eax, al                 ; widen the character to 32 bits for %c
    mov     dword [esp], msg_found  ; argument 1 : format string
    mov     [esp + 4], eax          ; argument 2 : the character
    mov     [esp + 8], esi          ; argument 3 : its position
    call    printf
    jmp     .menu
.srch_nf:
    movzx   eax, al                 ; widen the character to 32 bits for %c
    mov     dword [esp], msg_nfound
    mov     [esp + 4], eax
    call    printf
    jmp     .menu

; ---------- 7. Exit ----------
.exit:
    mov     dword [esp], msg_bye
    call    printf

    ; ---------- function epilogue ----------
    add     esp, 12                 ; remove the argument space
    pop     edi                     ; restore saved registers (reverse order)
    pop     esi
    pop     ebx
    pop     ebp
    ret                             ; return to C

section .note.GNU-stack noalloc noexec nowrite progbits   ; non-executable stack
