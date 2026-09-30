# Unsigned Division

These are results immediately after `div`, before the exit code runs. **DIV leaves all arithmetic flags (CF, OF, SF, ZF, PF, and AF) undefined** for all three examples: none is guaranteed to be set or clear based on the quotient or remainder. A debugger may display their incidental values, but they must not be interpreted as results of division.

| Program | Division | Quotient | Remainder | CF / OF / SF / ZF / PF / AF |
| --- | --- | --- | --- | --- |
| `div1.asm` | 16-bit `AX=100` / 8-bit `BL=7` | `AL=14` | `AH=2` | Undefined |
| `div2.asm` | 32-bit `DX:AX=50000` / 16-bit `BX=300` | `AX=166` | `DX=200` | Undefined |
| `div3.asm` | 64-bit `EDX:EAX=300000000` / 32-bit `EBX=1000` | `EAX=300000` | `EDX=0` | Undefined |

In `div1`, `100 = 7 * 14 + 2`, so `AL` receives 14 and `AH` receives 2; `0 <= 2 < 7`. In `div2`, `50000 = 300 * 166 + 200`, so `AX` receives 166 and `DX` receives 200; `0 <= 200 < 300`. In `div3`, `300000000 = 1000 * 300000 + 0`, so `EAX` receives 300000 and `EDX` receives 0; `0 <= 0 < 1000`. All three quotients fit their destinations, so none of these divisions traps. Unlike `SUB` or `ADD`, `DIV` specifies no relationship between its quotient/remainder and CF, OF, SF, ZF, PF, or AF. Therefore no "why set" or "why clear" conclusion is valid for any of those flags, even when the remainder is zero, regardless of the bits GDB shows. The later `xor ebx, ebx` in the exit code does change flags, so inspect them at `div`, not at program exit.