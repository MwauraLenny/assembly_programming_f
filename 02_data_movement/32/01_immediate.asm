; nasm -f elf32 -g -F dwarf 01_immediate.asm -o 01_immediate.o && ld -m elf_i386 01_immediate.o -o 01_immediate && ./01_immediate
; nasm -f elf32 01_immediate.asm    --- assemble file
; ld -m elf_i386 01_immediate.o     --- link
; ./a.out                           ---run

section .data
num1 dq 42
msg db "GDB memory demo", 0

section .text
global _start

_start:

    mov eax, 10
    mov ebx, 20

    add eax, 5

    mov eax, 1
    int 0x80