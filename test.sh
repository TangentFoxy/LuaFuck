#!/bin/bash

# Let's test the basics...
echo "Beginning tests! :o"
echo "Let's see what it says if we don't tell it to do anything:"
lua ./luafuck.lua
echo "Let's see what version we're using (-v):"
lua ./luafuck.lua -v
echo "And again (to make sure --version works):"
lua ./luafuck.lua --version
echo "And here's the help (-h) (look familiar?):"
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

echo "Since we were cat'ing so much, let's tac:"
lua ./luafuck.lua ./testing/tac.bf
lua ./testing/tac.lua

echo "Let's test the debug extension! This program is moving a value from cell 0 to cell 2, and the debug print command is used to show the state before and after execution:"
lua ./luafuck.lua ./testing/moveval.bf -e debug
