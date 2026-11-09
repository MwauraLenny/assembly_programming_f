# Stack walkthrough: `05.asm`

[`05.asm`](05.asm) demonstrates LIFO register save-and-restore in 64-bit mode, using a full-width value and a smaller one.

## Execution and stack changes

Let `S` be the initial `RSP` at `_start`. The program loads `0x1122334455667788` into `RAX` and `0x1234` into `RBX`; neither move changes the stack.

1. `push rax` subtracts 8 from `RSP` and stores the 64-bit `RAX` value at `[S - 8]`.
2. `push rbx` subtracts another 8 and stores `0x1234` at `[S - 16]`. At the following `nop`, `RSP = S - 16`, the top value is `0x1234`, and the next value is `0x1122334455667788`.
3. `pop rbx` restores `0x1234` to `RBX` and advances `RSP` to `S - 8`.
4. `pop rax` restores `0x1122334455667788` to `RAX` and advances `RSP` to `S`. The original register values have been recovered in reverse push order.
5. The exit setup then replaces `RAX` with syscall number `60` and sets `RDI` to `0`. The program exits successfully without printing anything.

## Run and observed result

From the repository root:

```bash
nasm -f elf64 07_stack/05/05.asm -o 07_stack/05/05.o
ld -o 07_stack/05/05.out 07_stack/05/05.o
07_stack/05/05.out
echo $?
```

The program exited with status `0` and no output. GDB showed the two values in LIFO order at the first `nop`. After the two pops, `RSP` was restored and `RBX = 0x1234`, `RAX = 0x1122334455667788` immediately before the exit setup overwrote `RAX`.
