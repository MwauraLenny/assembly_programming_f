# Subtraction

These are the arithmetic flags immediately after the indicated instruction, before the exit code runs. `1` means set and `0` means clear. CF reports an unsigned borrow, OF a signed overflow, SF the high bit of the result, ZF a zero result, PF even parity in the low byte, and AF a borrow from bit 4 into bit 3.

| Program | Operation and result | CF | OF | SF | ZF | PF | AF |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `sub1.asm` | 8-bit 50 - 80 = -30 (`0xe2`, unsigned 226) | 1 | 0 | 1 | 0 | 1 | 0 |
| `sub2.asm` | 16-bit 1000 - 2000 = -1000 (`0xfc18`, unsigned 64536) | 1 | 0 | 1 | 0 | 1 | 0 |
| `sub3.asm` after `sub` | 16-bit `0 - 1` wraps to `0xffff` | 1 | 0 | 1 | 0 | 1 | 1 |
| `sub3.asm` after `sbb` | `0xffff - 0 - CF(1) = 0xfffe` | 0 | 0 | 1 | 0 | 0 | 0 |

For `sub1`, unsigned 50 is smaller than 80, so subtraction requires a borrow (CF=1) and wraps modulo 256 to `0xe2`. As signed 8-bit numbers, 50 - 80 = -30 still lies within -128 to 127 (OF=0); bit 7 of `0xe2` is 1 (SF=1). `0xe2` is not zero (ZF=0), and its low byte has four set bits (PF=1). The low nibble subtraction `0x2 - 0x0` needs no borrow across bit 4 (AF=0).

For `sub2`, unsigned 1000 is smaller than 2000, so subtraction borrows (CF=1) and wraps modulo 65536 to `0xfc18`. Signed -1000 is within -32768 to 32767 (OF=0); bit 15 of `0xfc18` is 1 (SF=1). The result is not zero (ZF=0), its low byte `0x18` has two set bits (PF=1), and `0x8 - 0x0` needs no borrow across bit 4 (AF=0).

For `sub3`, `0 - 1` needs an unsigned borrow (CF=1) and wraps to `0xffff`. Signed -1 is representable (OF=0); bit 15 is 1 (SF=1), the result is nonzero (ZF=0), and the low byte `0xff` has eight set bits (PF=1). The low nibble `0 - 1` needs a borrow across bit 4 (AF=1). The following `sbb` consumes CF=1 and subtracts one more: `0xffff - 1 = 0xfffe`. This needs no new unsigned borrow (CF=0), and signed -1 - 1 = -2 is in range (OF=0). Bit 15 stays 1 (SF=1), and the result is not zero (ZF=0). Its low byte `0xfe` has seven set bits (PF=0); `0xf - 0 - 1` needs no nibble borrow (AF=0). The stored result is `0xfffe`, not `0xffff`.