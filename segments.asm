section .data
    message db "Hello, World!", 0xA    ; Stored in the .data segment (initialized data)
    message_len equ $ - message        ; Calculate message length

    data_msg db "This is .data segment", 0xA
    data_msg_len equ $ - data_msg

section .bss
    temp resb 1  ; Reserve 1 byte (uninitialized) in the .bss segment

section .text
    global _start

_start:
    ; Print message from the .data segment
    mov eax, 4       ; sys_write system call
    mov ebx, 1       ; File descriptor 1 (stdout)
    mov ecx, message ; Pointer to the message (stored in .data)
    mov edx, message_len
    int 0x80         ; Invoke system call

    ; Print another message showing the .data segment
    mov eax, 4
    mov ebx, 1
    mov ecx, data_msg
    mov edx, data_msg_len
    int 0x80

    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80

