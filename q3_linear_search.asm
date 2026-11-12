; ============================================================
; Q3 : Linear search on an array of 'n' integers   (x86-64)
; Assembler : NASM        Calling convention : System V AMD64 (Linux)
; Called from C as :  int linear_search(int *arr, int n, int key);
;       rdi = address of the array
;       esi = number of elements (n)
;       edx = key (value to search for)
; Returns in eax : index of the first match, or -1 if not found.
; ============================================================

global  linear_search           ; make the label visible to the C linker

section .text

linear_search:
    xor     ecx, ecx            ; ecx = i = 0  (current index)

.loop:
    cmp     ecx, esi            ; i < n ?
    jge     .not_found          ; reached the end without a match

    cmp     [rdi + rcx*4], edx  ; arr[i] == key ?  (each int is 4 bytes)
    je      .found              ; yes -> stop searching

    inc     ecx                 ; i++
    jmp     .loop               ; check the next element

.found:
    mov     eax, ecx            ; return value = index of the match
    ret

.not_found:
    mov     eax, -1             ; return value = -1 (key is not in the array)
    ret

section .note.GNU-stack noalloc noexec nowrite progbits   ; non-executable stack
