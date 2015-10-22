local version = {
    major = 0,
    minor = 1,
    patch = 0,
    expletive = "Dagobah",
    toString = nil
}
function version.toString()
    return "LuaFuck version "..version.major.."."..version.minor.."."..version.patch.." "..version.expletive
end

-- set up the environment before translations with this
-- cell, memory, output (translation), write (to STDOUT), input (translation), buffer (of input), input (from STDIN, processed), then we set a metatable to make cells initialize to zero
bootstrap = "c,m,o,w,i,b,r=0,{},string.char,io.write,string.byte,\"\",function() if b:len()==0 then b=io.read() end local O=b:sub(1,1) b=b:sub(2) return O end setmetatable(m,{__index=function() return 0 end}) "

-- "sets" are what we call the tables of translations of
--  Brainfuck instructions to be converted to Lua
local sets = require "conversions"

local Help = [[
NAME
    luafuck.lua - Compiles Brainfuck code into Lua code.
SYNOPSIS
    lua luafuck.lua INPUT [OPTIONS] [filename]

    (Note: OPTIONS must be specified individually.
     `-vds` won't work for example.)
DESCRIPTION
    Compiles Brainfuck into Lua code.
OPTIONS
    -v, --version
        output version
    -V, --verbose
        verbose output
    -d, --debug
        debug statements will be placed in the output code printing changes to
        the state of the program while it runs
    -o filename, --out=filename
        output filename to use (will append .lua to it if you don't)
    -e extension1 extension2, --extensions=extension1,extension2
        a list of extensions to enable
    -h, --help
        show this help
    (Note: Passing -- won't stop further optionss from going through.
     Deal with it (possibly by submitting a patch for it).)
EXTENSIONS
    No extensions are supported at this time. They will be in future versions.
FILES
    luafuck.lua
    conversions.lua
]]

-- get our arguments
local arguments = {...}

-- default options
local OUT_FILE = arguments[1]:sub(1, -4) --.. ".lua"
local CONVERSION_SET = "conversions"
local VERBOSE = false
local DEBUG = false
local EXTENSIONS = {}

-- checks which options are selected
local function selected(option)
    for k,v in pairs(arguments) do
        if v == option then
            return true, k
        end
        --print(k,v) --TEMP
    end
    return false
end

-- shitty checks partial options existing
local function selectedPartial(option)
    for k,v in pairs(arguments) do
        if v:find(option) then
            return true, k
        end
    end
    return false
end

-- easy options
if selected("-v") or selected("--version") then
    print(version.toString())
    return 0
end
if selected("-V") or selected("--verbose") then
    VERBOSE = true
end
if selected("-d") or selected("--debug") then
    --DEBUG = true
    CONVERSION_SET = CONVERSION_SET .. "_debug"
end
if selected("-h") or selected("--help") then
    print(Help)
    return 0
end

-- more complicated (and shittily coded!) options
local fileSpecified, argPlace = selected("-o")
if not fileSpecified then
    fileSpecified, argPlace = selectedPartial("--out=")
    if fileSpecified then
        OUT_FILE = arguments[argPlace-1]:sub(7)
    end
else
    OUT_FILE = arguments[argPlace-1]
end
-- now make sure it has a proper extension!
if not OUT_FILE:find(".lua") then
    OUT_FILE = OUT_FILE .. ".lua"
end

-- yay verbosity!
if VERBOSE then
    print(version.toString() .. " has started!")
    print("ARGUMENTS:")
    for k,v in pairs(arguments) do
        print(k, v)
    end
    print("Options:")
    print("OUT_FILE", OUT_FILE)
    print("VERBOSE", VERBOSE)
    print("DEBUG", DEBUG)
    print("CONVERSION_SET", CONVERSION_SET, "(should say _debug at end if DEBUG == true)")
    print("EXTENSIONS:")
    for k,v in pairs(EXTENSIONS) do
        print(k, v)
    end
    if #EXTENSIONS < 1 then
        print(0, "none")
    end
end

print("Beginning compilation of " .. OUT_FILE)
--TODO fix the fact that OUT_FILE is ...the input o.o

-- open output file
local outFileHandle = io.open(OUT_FILE, "w")
if VERBOSE then print("Opened "..OUT_FILE.." for output.") end

-- write bootstrap
if VERBOSE then print("Writing bootstrap code...") end
outFileHandle:write(bootstrap)
if VERBOSE then print("Done.") end

-- loop through input file and process it
if VERBOSE then print("Opening input...") end
for line in io.lines(OUT_FILE) do
    if VERBOSE then print("Read line:", line) end
    for i=1,line:len() do
        local character = line:sub(i,i)
        if sets[CONVERSION_SET][character] then outFileHandle:write(sets[CONVERSION_SET][character]) end
        if VERBOSE then print("Wrote to output:", sets[CONVERSION_SET][character]) end
    end
end

if VERBOSE then print("Done. Closing files.") end
outFileHandle:close()

print("Compilation complete.")
