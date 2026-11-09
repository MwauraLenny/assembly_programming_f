# Stack walkthrough: `06.asm`

[`06.asm`](06.asm) is the 32-bit version of the register save-and-restore example in `05.asm`.

## Execution and stack changes

Let `S` be the initial `ESP` at `_start`. In this 32-bit program, each push or pop moves `ESP` by 4 bytes. The initial moves set `EAX = 0x11223344` and `EBX = 0x1234`.

1. `push eax` subtracts 4 from `ESP` and stores `0x11223344` at `[S - 4]`.
2. `push ebx` subtracts another 4 and stores `0x1234` at `[S - 8]`. At the following `nop`, `ESP = S - 8`, with `0x1234` on top and `0x11223344` below it.
3. `pop ebx` reads the top value (`0x1234`) into `EBX` and advances `ESP` to `S - 4`.
4. `pop eax` reads `0x11223344` into `EAX` and advances `ESP` to `S`. This restores both original values in last-in, first-out order.
5. The exit setup sets `EAX = 1` (the i386 exit syscall number), then clears `EBX` to select exit status `0`. The `int 0x80` syscall ends the program; it produces no output.

## Run and observed result

From the repository root:

```bash
nasm -f elf32 07_stack/06/06.asm -o 07_stack/06/06.o
ld -m elf_i386 -o 07_stack/06/06.out 07_stack/06/06.o
07_stack/06/06.out
echo $?
```

The program exited with status `0` and no output. GDB showed `0x1234` above `0x11223344` at the first `nop`; after both pops, `ESP` was back at its starting value and the original values had been restored before the exit setup replaced `EAX` and `EBX`.
