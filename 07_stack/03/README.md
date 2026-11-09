# Stack walkthrough: `03.asm`

[`03.asm`](03.asm) demonstrates that `call` and `ret` use the stack even when a function has no explicit `push` or `pop`.

## Execution and stack changes

Let `S` be `RSP` immediately before the `call calculate`.

1. `_start` sets `RAX` to `10`. This register move does not touch the stack.
2. `call calculate` subtracts 8 from `RSP` and pushes the address of `after_call` there. Inside `calculate`, `RSP = S - 8`.
3. `add rax, 5` changes `RAX` to `15`; it does not alter `RSP`.
4. `ret` takes the saved return address from the top of the stack, transfers execution to `after_call`, and adds 8 to `RSP`. Thus `RSP` is back to `S` when the caller resumes.
5. The `nop` at `after_call` leaves the state unchanged. `_start` then exits with status `0`; nothing is printed.

The return address is the only stack value this program explicitly causes to be placed on the stack. `ret` consumes it, so no manual cleanup is needed.

## Run and observed result

From the repository root:

```bash
nasm -f elf64 07_stack/03/03.asm -o 07_stack/03/03.o
ld -o 07_stack/03/03.out 07_stack/03/03.o
07_stack/03/03.out
echo $?
```

The program exited with status `0` and no output. At `after_call`, GDB showed `RAX = 15` and `RSP` restored to its pre-call value, confirming that the `call`-pushed return address was consumed by `ret`.
