# Addition

These are the arithmetic flags immediately after the indicated instruction, before the exit code runs. `1` means set and `0` means clear. For addition, CF reports an unsigned carry, OF a signed overflow, SF the high bit of the result, ZF a zero result, PF even parity in the low byte, and AF a carry from bit 3 to bit 4.

| Program | Operation and result | CF | OF | SF | ZF | PF | AF |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `add1.asm` | 8-bit 120 + 10 = 130 (`0x82`, signed -126) | 0 | 1 | 1 | 0 | 1 | 1 |
| `add2.asm` | 16-bit 32000 + 500 = 32500 (`0x7ef4`) | 0 | 0 | 0 | 0 | 0 | 0 |
| `add3.asm` after `add` | 16-bit `0xffff + 1` wraps to `0x0000` | 1 | 0 | 0 | 1 | 1 | 1 |
| `add3.asm` after `adc` | `0x0000 + 0 + CF(1) = 0x0001` | 0 | 0 | 0 | 0 | 0 | 0 |

For `add1`, 120 + 10 = 130 fits in 8 unsigned bits (CF=0), but exceeds the signed 8-bit maximum of 127: two positive operands yield the negative bit pattern `0x82` (OF=1). Bit 7 of `0x82` is 1 (SF=1), and the result is not zero (ZF=0). The low byte `0x82` has two set bits (PF=1); its low nibbles add as `0x8 + 0xa = 0x12`, carrying from bit 3 to bit 4 (AF=1).

For `add2`, 32000 + 500 = 32500 fits in both 16-bit unsigned (0 to 65535) and signed (-32768 to 32767) ranges (CF=0, OF=0). Bit 15 of `0x7ef4` is 0 (SF=0), and the result is not zero (ZF=0). Only the low byte counts for parity: `0xf4` has five set bits (PF=0). The operand low nibbles `0x0 + 0x4` do not carry across bit 4 (AF=0).

For `add3`, the first `add` exceeds the unsigned 16-bit maximum, so it wraps to zero with a carry (CF=1, ZF=1). Interpreted as signed, -1 + 1 = 0 is in range (OF=0); zero has no sign bit (SF=0), and its low byte has zero set bits, an even count (PF=1). The low nibbles `0xf + 1` carry into bit 4 (AF=1). The following `adc` consumes the incoming CF=1, yielding 1; **its flags replace the `add` flags**. One fits the unsigned and signed 16-bit ranges (CF=0, OF=0), has no sign bit (SF=0), and is not zero (ZF=0). Its low byte has one set bit (PF=0), and `0 + 0 + 1` creates no nibble carry (AF=0). The stored result is 1, not 0.

`adc4.asm` is empty, so it has no operation or flags to report.