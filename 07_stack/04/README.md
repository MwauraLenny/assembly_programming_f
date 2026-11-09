# Stack walkthrough: `04.asm`

[`04.asm`](04.asm) is the 32-bit counterpart to the stack-frame example in `02.asm`.

## Execution and stack changes

Let `S` be `ESP` just before `_start` calls `work`. In 32-bit mode, each pushed address or register value occupies 4 bytes.

1. `call work` subtracts 4 from `ESP` and stores the address after the call. At function entry, `ESP = S - 4`.
2. `push ebp` saves the caller's frame pointer in another 4-byte slot, making `ESP = S - 8`. `mov ebp, esp` makes this the frame base.
3. `sub esp, 8` reserves 8 bytes for two 4-byte locals, so `ESP = S - 16`, or `EBP - 8`.
4. The stores put `100` at `[EBP - 4]` and `200` at `[EBP - 8]`. The `200` local is at the stack top, followed by `100`. The saved `EBP` is at `[EBP]`, and the return address is at `[EBP + 4]`.
5. The loads put the locals in `EAX` (`100`) and `EBX` (`200`); neither they nor `nop` change `ESP`.
6. `mov esp, ebp` discards the local area by restoring `ESP` to `S - 8`. `pop ebp` restores the caller's frame pointer and advances `ESP` to `S - 4`.
7. `ret` pops the saved return address and advances `ESP` to `S`, returning to `_start`.
8. `_start` exits through the Linux i386 syscall (`EAX = 1`, `EBX = 0`). It prints nothing.

## Run and observed result

From the repository root:

```bash
nasm -f elf32 07_stack/04/04.asm -o 07_stack/04/04.o
ld -m elf_i386 -o 07_stack/04/04.out 07_stack/04/04.o
07_stack/04/04.out
echo $?
```

The program exited with status `0` and no output. At `work`'s `nop`, GDB showed `ESP = EBP - 8`, with `200` then `100` in the local slots and `EAX = 100`, `EBX = 200`. The epilogue restores the saved frame pointer and `ret` consumes the return address, bringing `ESP` back to its pre-call value.
