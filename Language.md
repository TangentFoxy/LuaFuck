# Brainfuck

Brainfuck is an esoteric programming language created in 1993 by Urban Müller.
It is extremely minimalistic, and not very practical. That said, it does make
for a challenge.

Brainfuck consists of 8 instructions. Any other character is ignored and can be
used for comments. (Note that LuaFuck supports certain extensions to these 8
commands that allow extra functionality. These are detailed in the extensions
directory.)

| Instruction | Meaning |
|-------------|---------|
| **&gt;** | Move data pointer right. |
| **&lt;** | Move data pointer left. |
| **+** | Incrememt memory at pointer. |
| **-** | Decrement memory at pointer. |
| **.** | Output character in memory at pointer. |
| **,** | Input character to memory at pointer. |
| **[** | Jump to matching ] if memory at pointer is zero. |
| **]** | Jump to matching [ if memory at pointer in nonzero. |

Typically, memory locations are 1 byte, and the memory is expected to span
infinitely to the right from the 0th (starting) location. (The original
implementation had memory limited to 30k bytes.) (Note: LuaFuck uses "infinite"
memory in both directions. For compatibility with other compilers, you probably
shouldn't go left into negative indexes.)

### The Newline / EOF Problem

There is some inconsistency in Brainfuck interpreters/compilers. Some expect EOF
to be a -1 (255), some expect it to be a NULL (0). This compiler, due to how Lua
handles input by default, uses NULL.

A related issue is newlines. Some systems historically used 13. Most use 10. A
few use both (a 13 followed by a 10). It is recommended you should use 10. This
compiler uses 10, most interpreters/compilers expect 10.

## Resources

- [Wikipedia article](https://en.wikipedia.org/wiki/Brainfuck)
- [Esolang wiki article](https://esolangs.org/wiki/Brainfuck)
  - [Brainfuck algorithms](https://esolangs.org/wiki/Brainfuck_algorithms)
    (methods to execute certain basic calculations)
  - [Brainfuck constants](https://esolangs.org/wiki/Brainfuck_constants)
    (ways of getting particular values into a memory cell)
- [ASCII Reference](http://www.asciitable.com/)
  (note: not all of these will display properly)
