# LuaFuck

[![GitHub release](https://img.shields.io/github/release/Guard13007/LuaFuck.svg?maxAge=2592000)](https://github.com/Guard13007/LuaFuck/releases/latest)
[![GitHub downloads](https://img.shields.io/github/downloads/Guard13007/LuaFuck/latest/total.svg?maxAge=2592000)](https://github.com/Guard13007/LuaFuck/releases/latest)
[![GitHub issues](https://img.shields.io/github/issues-raw/Guard13007/LuaFuck.svg?maxAge=2592000)](https://github.com/Guard13007/LuaFuck/issues)
[![GitHub license](https://img.shields.io/github/license/Guard13007/LuaFuck.svg?maxAge=2592000)](https://github.com/Guard13007/LuaFuck/blob/master/LICENSE)

Translation program to run Brainfuck code in Lua.

Supports several command-line options and extensions, listed below.

- Tested on Arch. (Has a test bash script so you can test stuff yourself.)
- Cell size is 8 bits, memory length is unrestricted (except by the limits of Lua).
  (This includes going left into negative indexes of memory.)
- EOF is 10, Enter is 10.

## NAME
luafuck.lua - Compiles Brainfuck code into Lua code.

## SYNOPSIS
lua luafuck.lua [IN_FILE] [OPTIONS]

(Note: OPTIONS must be specified individually. `-vds` won't work for example.)

## OPTIONS
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
  a list of extensions to enable<br>
  (note: only the `--extensions=` form works right now!)
- `-h, --help`<br>
  show this help

## EXTENSIONS

- debug
  - Adds `#` and `!` instructions.<br>
    `#` prints out the first 10 memory cells, and 9 memory cells surrounding
      the currently selected memory cell.<br>
    `!` makes the rest of the file get placed into the input buffer. (Instead
      of reading from keyboard.)
