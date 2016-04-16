local Scanner = require "scanner"
local ENDMARK = require("values").ENDMARK

local scanner = Scanner("This is a test.\nIncludes new lines,\tand tabs!")

local out
repeat
    out = scanner:get()
    print(out)
until out:getChar() == ENDMARK
