# LuaFuck
Translation program to run Brainfuck code in Lua.

Will support popular extensions and options (oh, and some basic optimizations!),
 but for now is fairly simple.

NOTE: Expects EOF to be 0, uses LF for enter (or at least it does in testing
    on Linux (specifically Antergos)).

Oh yeah! It even comes with a (WIP) test script! :D

## NAME
luafuck.lua - Compiles Brainfuck code into Lua code.

## SYNOPSIS
lua luafuck.lua INPUT [OPTIONS] [filename]

## DESCRIPTION
Compiles Brainfuck into Lua code.

- `-v, --version`<br>
  output version
- `-V, --verbose`<br>
  verbose output
- `-d, --debug`<br>
  debug statements will be placed in the output code printing changes to
  the state of the program while it runs
- `-o filename, --out=filename`<br>
  output filename to use (will append .lua to it if you don't)
- `-e extension1 extension2, --extensions=extension1,extension2`<br>
  a list of extensions to enable
- `-h, --help`<br>
  show this help

(Note: Passing `--` won't stop further optionss from going through.
 Deal with it (possibly by submitting a patch for it).)

## EXTENSIONS
No extensions are supported at this time. They will be in future versions.

For an idea of what an extension might be, check the [Wikipedia page](https://en.wikipedia.org/wiki/Brainfuck)
on Brainfuck, or the [Esolang Wiki page](https://esolangs.org/wiki/Brainfuck) on it.
