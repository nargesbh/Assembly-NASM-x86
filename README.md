# Assembly64 Assembler and Disassembler

This project implements an assembler and disassembler for Assembly64, supporting 8, 16, 32, and 64-bit commands with various addressing modes for 64-bit architecture. The implementation is provided in both Assembly and Python languages.

## Features

- **Dual Implementation:** Both assembler and disassembler are provided in both Python and Assembly languages for versatility and ease of use.
- **Highly Rated:** The project received a high score in its class and successfully passed all test cases.

## Prerequisites

- **Operating System:** Ubuntu
- **Processor:** Intel chip
- **IDE:** VSCode (recommended for ease of use)

## Supported Arguments

The assembler and disassembler support various operand combinations:

1. First Operand: Register (8/16/32/64 bits)
2. Second Operand: Register (8/16/32/64 bits)
3. First Operand: Register (8/16/32/64 bits), Second Operand: Memory (32/64 bits - direct/indirect)
4. First Operand: Memory (32/64 bits - direct/indirect), Second Operand: Register (8/16/32/64 bits)
5. First Operand: Register (8/16/32/64 bits), Second Operand: Immediate Data
6. First Operand: Memory (32/64 bits - direct/indirect), Second Operand: Immediate Data

## Input Rules

- A space must separate the instruction and the first operand (if present).
- If there are two operands, they are separated by a comma without spaces (e.g., `mov rax, rbx`).
- When an operand is memory, its size must be specified, and it should be preceded by `PTR` within square brackets (e.g., `or WORD PTR [edx*8], ax`).
- No spaces should exist between elements within memory operands (e.g., `mov edx, DWORD ptr [ebx+ecx*1+0x32345467]`).
- If displacement exists in memory operands, it must be in hexadecimal format starting with `0x`.
- All characters should be in lowercase English, except for `BYTE`, `WORD`, `DWORD`, `QWORD`.
- When a memory operand includes a register index, the scale value must be displayed, even if it's 1.
- The order for base, index, scale, and displacement in memory operands is `[base+index*scale+disp]`.
- Handle cases where `ebp` or `rbp` is chosen as the base register, and refer to the Defuse website for different scenarios.
- The only exception to hex input is for `imul`, and you only need to code for single-operand `idiv`. No need to handle cases where shift counts are held in `cl`.

## Output Rules

- The output must be in hexadecimal.
- There should be no `0x` prefix in the output.

## Supported Commands

- `mov`, `add`, `adc`, `sub`, `sbb`, `and`, `or`, `xor`, `dec`, `inc`, `cmp`, `test`
- `xchg`, `xadd`, `imul`, `idiv`, `bsf`, `bsr`
- `stc`, `clc`, `std`, `cld`
- `jmp`, `jcc`
- `shr`, `shl`, `neg`, `not`
- `call`, `ret`
- `syscall`, `push`, `pop`

For detailed test cases and examples, please refer to the [Defuse x86 Assembler](https://defuse.ca/online-x86-assembler.htm) website.
