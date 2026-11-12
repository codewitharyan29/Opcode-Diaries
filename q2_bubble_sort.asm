; ============================================================
; Q2 : Bubble sort on an array of 'n' integers   (x86-64)
; Assembler : NASM        Calling convention : System V AMD64 (Linux)
; Called from C as :  void bubble_sort(int *arr, int n);
;       rdi = address of the array
;       esi = number of elements (n)
; Sorts the array in ascending order, in place.
; ============================================================

global  bubble_sort             ; make the label visible to the C linker

section .text

bubble_sort:
    cmp     esi, 1              ; 0 or 1 element?
    jle     .done               ; then the array is already sorted

    mov     ecx, esi
    dec     ecx                 ; ecx = n - 1 = comparisons in the first pass

.outer:                         ; ---- one full pass over the array ----
    xor     edx, edx            ; edx = j = 0  (inner loop index)
    xor     r8d, r8d            ; r8d = swapped flag = 0

.inner:
    cmp     edx, ecx            ; j < number of comparisons for this pass?
    jge     .inner_done         ; no -> this pass is finished

    mov     eax, [rdi + rdx*4]      ; eax = arr[j]     (each int is 4 bytes)
    mov     r9d, [rdi + rdx*4 + 4]  ; r9d = arr[j+1]
    cmp     eax, r9d            ; compare the neighbours (signed)
    jle     .no_swap            ; arr[j] <= arr[j+1] -> correct order

    mov     [rdi + rdx*4], r9d      ; swap: arr[j]   = old arr[j+1]
    mov     [rdi + rdx*4 + 4], eax  ;       arr[j+1] = old arr[j]
    mov     r8d, 1              ; remember that a swap happened

.no_swap:
    inc     edx                 ; j++
    jmp     .inner

.inner_done:
    test    r8d, r8d            ; did this pass swap anything?
    jz      .done               ; no swaps -> already sorted, stop early

    dec     ecx                 ; largest element is now at the end,
                                ; so the next pass needs one less comparison
    jnz     .outer              ; repeat while comparisons remain

.done:
    ret                         ; return to C

section .note.GNU-stack noalloc noexec nowrite progbits   ; non-executable stack
