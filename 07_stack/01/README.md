# Stack walkthrough: `01.asm`

[`01.asm`](01.asm) demonstrates basic 64-bit pushes and pops.

## Execution and stack changes

Let `S` be the value of `RSP` when Linux transfers control to `_start`. The program first puts `100` in `RAX` and `200` in `RBX`. These register moves do not use the stack.

1. `push rax` subtracts 8 from `RSP` and stores `100` at `[S - 8]`. `RSP` is now `S - 8`.
2. `push rbx` subtracts another 8 and stores `200` at `[S - 16]`. `RSP` is now `S - 16`; the top of the stack is `200`, with `100` immediately above it in memory.
3. `nop` has no effect on the stack.
4. `pop rcx` reads the top value (`200`) into `RCX`, then adds 8 to `RSP`, bringing it to `S - 8`.
5. `pop rdx` reads `100` into `RDX` and adds another 8 to `RSP`, restoring `RSP` to `S`. This is last-in, first-out order: the second value pushed is the first popped.
6. The final `nop` changes nothing. The program then invokes Linux's 64-bit exit syscall with status `0`; it does not print anything.

## Run and observed result

From the repository root:

```bash
nasm -f elf64 07_stack/01/01.asm -o 07_stack/01/01.o
ld -o 07_stack/01/01.out 07_stack/01/01.o
07_stack/01/01.out
echo $?
```

The program exited with status `0` and no output. At the first `nop`, GDB showed `RSP` 16 bytes below its starting value and the stack top-to-bottom values `200`, `100`. After both pops, `RSP` was back at its starting value, with `RCX = 200` and `RDX = 100`.
