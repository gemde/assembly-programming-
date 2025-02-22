section .bss
    num1 resb 8   ; Space for first number input
    num2 resb 8   ; Space for second number input
    result resb 12 ; Buffer to store result as a string
    choice resb 2  ; Space to store operation choice

section .data
    prompt_choice db "Choose operation:\n1. Add\n2. Subtract\n3. Multiply\n4. Divide\nEnter choice: ", 0
    prompt_choice_len equ $ - prompt_choice

    prompt1 db "Enter first number: ", 0
    prompt1_len equ $ - prompt1

    prompt2 db "Enter second number: ", 0
    prompt2_len equ $ - prompt2

    result_msg db "Result: ", 0
    result_msg_len equ $ - result_msg

section .text
    global _start

_start:
    ; Prompt for operation choice
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_choice
    mov edx, prompt_choice_len
    int 0x80

    ; Read choice
    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 2
    int 0x80

    ; Prompt for first number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, prompt1_len
    int 0x80

    ; Read first number
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 8
    int 0x80

    ; Prompt for second number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 0x80

    ; Read second number
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 8
    int 0x80

    ; Convert ASCII input to integers
    mov eax, 0
    mov esi, num1
    call string_to_int
    mov ebx, eax

    mov eax, 0
    mov esi, num2
    call string_to_int
    mov ecx, eax

    ; Perform the selected operation
    mov al, byte [choice]
    cmp al, '1'
    je do_addition
    cmp al, '2'
    je do_subtraction
    cmp al, '3'
    je do_multiplication
    cmp al, '4'
    je do_division
    jmp exit_program

; Addition
 do_addition:
    add ebx, ecx
    jmp print_result

; Subtraction
 do_subtraction:
    sub ebx, ecx
    jmp print_result

; Multiplication
 do_multiplication:
    imul ebx, ecx
    jmp print_result

; Division
 do_division:
    cmp ecx, 0
    je exit_program  ; Prevent division by zero
    xor edx, edx
    div ecx
    jmp print_result

; Print the result
print_result:
    mov eax, ebx
    call int_to_string

    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, result_msg_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 12
    int 0x80

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Convert String to Integer
string_to_int:
    xor eax, eax
.loop:
    movzx edx, byte [esi]
    test dl, dl
    je .done
    cmp dl, 10
    je .done
    cmp dl, '0'
    jl .done
    cmp dl, '9'
    jg .done
    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    inc esi
    jmp .loop
.done:
    ret

; Convert Integer to String
int_to_string:
    mov edi, result
    add edi, 10
    mov byte [edi], 10  ; newline
    dec edi

    mov ecx, 10
.loop:
    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .loop
    inc edi

    mov ecx, edi
    ret
