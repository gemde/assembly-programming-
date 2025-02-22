section .data
    msg db "Hello, World!", 0xA  ; Message to print (newline at the end)
    len equ $ - msg               ; Calculate message length

section .text
    global _start

_start:
    mov eax, 4      ; sys_write system call number
    mov ebx, 1      ; File descriptor (stdout)
    mov ecx, msg    ; Pointer to message
    mov edx, len    ; Message length
    int 0x80        ; Call kernel

    mov eax, 1      ; sys_exit system call number
    xor ebx, ebx    ; Return 0
    int 0x80        ; Call kernel
