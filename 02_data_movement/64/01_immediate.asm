; nasm -f elf64 -g -F dwarf 01_immediate.asm -o 01_immediate.o && ld 01_immediate.o -o 01_immediate && ./01_immediate

section .data
num1 dq 42
msg db "GDB memory demo", 0

section .text
global _start

_start:

    mov rax, 10
    mov rbx, 20

    add rax, 5

    mov rax, 60
    xor rdi, rdi
    syscall