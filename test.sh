#!/bin/bash

# Let's test the basics...
echo "Beginning tests! :o"
echo "Let's see what version we're using (-v):"
lua ./luafuck.lua -v
echo "And again (to make sure --version works):"
lua ./luafuck.lua --version
echo "And here's the help (-h):"
lua ./luafuck.lua -h
echo "And here's that again (--help):"
lua .luafuck.lua --help

# Of course, we must start with a Hello World!
echo "Now for a hello world:"
lua ./luafuck.lua ./testing/helloworld.bf
lua ./testing/helloworld.lua
echo "And again, because this version is apparently good for testing compatibility of Brainfuck interpreters:"
lua ./luafuck.lua ./testing/complexhello.bf
lua ./testing/complexhello.lua

echo "Now for a cat (hit enter to without input to quit it):"
lua ./luafuck.lua ./testing/EOF/cat0.bf -o ./testing/cat.lua
lua ./testing/cat.lua
echo "And another version (again, hit enter to exit):"
lua ./luafuck.lua ./testing/EOF/cat0or.bf --out=./testing/cat2.lua
lua ./testing/cat2.lua

echo "This next one adds a couple of numbers, but we're using the debug (-d) flag to make a bunch of debug info print out as well:"
lua ./luafuck.lua ./testing/addnext.bf -d
lua ./testing/addnext.lua
