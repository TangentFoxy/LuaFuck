#!/bin/bash

# Of course, we must start with a Hello World!
lua ./luafuck.lua ./testing/helloworld.bf
echo "The following line should be \"Hello World!\":"
lua ./testing/helloworld.lua

# This version of Hello World is intended to expose BF interpreter errors.
lua ./luafuck.lua ./testing/complexhello.bf
echo "The following line should (again) be \"Hello World!\":"
lua ./testing/complexhello.lua

# Now we shall test the four versions of cat:
# (Four versions because BF interpreters don't have a proper EOF handling standard.)
lua ./luafuck.lua ./testing/EOF/cat0.bf
#echo "This is the EOF-0 version of cat, please type some text and then hit enter (Ctrl+C should get you out):"
#lua ./testing/EOF/cat0.lua

lua ./luafuck.lua ./testing/EOF/cat0or.bf
#echo "This is the EOF-0 (or unchanged(?)) version of cat, please type some text and then hit enter (Ctrl+C should get you out):"
#lua ./testing/EOF/cat0or.lua

#TODO put other cat tests
