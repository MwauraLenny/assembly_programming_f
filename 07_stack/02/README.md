# Stack walkthrough: `02.asm`

[`02.asm`](02.asm) uses a 64-bit stack frame to save a register, reserve local storage, and return from a function.

## Execution and stack changes

Let `S` be `RSP` just before `_start` calls `work`. The initial `mov` instructions set up the exit syscall only after the function returns.

1. `call work` subtracts 8 from `RSP` and stores the address of the instruction after the call there. At function entry, `RSP = S - 8`.
2. `push rbp` saves the caller's `RBP` in another 8-byte stack slot, making `RSP = S - 16`. `mov rbp, rsp` establishes this address as the frame base.
3. `sub rsp, 16` reserves 16 bytes for two local values without pushing either value. Now `RSP = S - 32`, or `RBP - 16`.
4. The stores place `100` at `[RBP - 8]` and `200` at `[RBP - 16]`. Since the stack grows toward lower addresses, the `200` local is at the current stack top, followed by `100`. The saved `RBP` is at `[RBP]`, and the call's return address is at `[RBP + 8]`.
5. The loads copy the locals into `RAX` (`100`) and `RBX` (`200`). They do not change `RSP`; `nop` does not either.
6. `mov rsp, rbp` resets `RSP` to `S - 16`, discarding the reserved local area. `pop rbp` restores the saved caller value and advances `RSP` to `S - 8`.
7. `ret` pops the return address into the instruction pointer and advances `RSP` to `S`, returning to `_start`.
8. `_start` exits with status `0`. There is no output.

## Run and observed result

From the repository root:

```bash
nasm -f elf64 07_stack/02/02.asm -o 07_stack/02/02.o
ld -o 07_stack/02/02.out 07_stack/02/02.o
07_stack/02/02.out
echo $?
```

The program exited with status `0` and no output. At `work`'s `nop`, GDB showed `RSP = RBP - 16`, with `200` and `100` at the two local slots and `RAX = 100`, `RBX = 200`. The saved frame pointer and return address were above those locals. The restore sequence and `ret` return the stack pointer to its pre-call value.
