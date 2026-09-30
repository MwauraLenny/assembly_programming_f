# Unsigned Multiplication

These are the flags immediately after `mul`, before the exit code runs. `1` means set and `0` means clear. For `mul`, **only CF and OF are defined**: both are set if the upper half of the double-width product is nonzero, and cleared otherwise. SF, ZF, PF, and AF are **undefined**, even if a debugger displays values for them; those values cannot reliably be inferred from the product.

| Program | Product | Upper half | CF | OF | SF / ZF / PF / AF |
| --- | --- | --- | --- | --- | --- |
| `mul1.asm` | 8-bit 25 * 10 = 250 (`AX=0x00fa`) | `AH=0x00` | 0 | 0 | Undefined |
| `mul2.asm` | 16-bit 3000 * 200 = 600000 (`DX:AX=0x0009:0x27c0`) | `DX=0x0009` | 1 | 1 | Undefined |
| `mul3.asm` | 32-bit 100000 * 300000 = 30000000000 (`EDX:EAX=0x00000006:0xfc23ac00`) | `EDX=0x00000006` | 1 | 1 | Undefined |

For `mul1`, 25 * 10 = 250 (`0xfa`) is at most 255, so `AH=0` and the product fits in `AL` (CF=0, OF=0). For `mul2`, 3000 * 200 = 600000 = `0x000927c0`, which exceeds 65535: `DX=0x0009` is nonzero (CF=1, OF=1). These flags describe whether the upper half is needed for the unsigned product, not whether the low half looks signed or zero. `MUL` does not define SF, ZF, PF, or AF, so even a product of zero would not justify claiming ZF=1.

For `mul3`, 30000000000 is larger than the 32-bit unsigned maximum of 4294967295. The product therefore needs the high 32 bits (`EDX=6`), so CF and OF are both set. SF, ZF, PF, and AF remain undefined even though the low 32 bits (`EAX=0xfc23ac00`) have a high bit and are nonzero.