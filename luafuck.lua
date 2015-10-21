local version = {
    major = 0,
    minor = 1,
    patch = 0,
    expletive = "Dagobah",
    toString = function()
        return "LuaFuck version "..version.major.."."..version.minor.."."..version.patch.." "..version.expletive
    end
}

--[[ Brainfuck Notes

    Brainfuck spec:
    > move pointer right
    < move pointer left
    + increment memory at pointer
    - decrement memory at pointer
    . output character of memory at pointer
    , input character to memory at pointer
    [ jump to matching ] if memory at pointer == 0
    ] jump to matching [ if memory at pointer ~= 0

    Bootstrap code to make translating to Lua easy:
    cell = 0
    memory = {}
    toCharacter = string.char --converts ## to char
    writeOut = io.write    --to default out
    toInteger = string.byte --converts char to ##
    readIn = io.read     --from default in

    That bit I forgot about any given m[c] being nil initially:
    setmetatable(memory, {__index = function(Table, key)
        return 0
    end})

    Now some extra shit because it turns out I need an input buffer:
    -- as you probably have guessed, this replaces the previous attempt at readIn
    local readBuffer = ""
    local function readIn()
        if readBuffer:len() == 0 then readBuffer = io.read() end
        local out = readBuffer:sub(1,1)
        readBuffer = readBuffer:sub(2)
        return out
    end

    Brainfuck to Lua translations:
    > cell = cell + 1
    < cell = cell - 1
    + memory[cell] = memory[cell] + 1 if memory[cell] > 255 then memory[cell] = 0 end
    - memory[cell] = memory[cell] - 1 if memory[cell] < 0 then memory[cell] = 255 end
    . writeOut(toCharacter(memory[cell]))
    , memory[cell] = toInteger(readIn())
    [ while memory[cell] ~= 0 do
    ] end

]]

-- set up the environment before translations with this
-- cell, memory, output (translation), write (to STDOUT), input (translation), buffer (of input), input (from STDIN, processed), then we set a metatable to make cells initialize to zero
bootstrap = "c,m,o,w,i,b,r=0,{},string.char,io.write,string.byte,\"\",function() if b:len()==0 then b=io.read() end local O=b:sub(1,1) b=b:sub(2) return O end setmetatable(m,{__index=function() return 0 end}) "

-- standard code conversions, each instruction is translated directly
conversions = {
  [">"] = "c=c+1 ",
  ["<"] = "c=c-1 ",
  ["+"] = "m[c]=m[c]+1 if m[c]>255 then m[c]=0 end ",
  ["-"] = "m[c]=m[c]-1 if m[c]<0 then m[c]=255 end ",
  ["."] = "w(o(m[c])) ",
  [","] = "m[c]=i(r()) ",
  ["["] = "while m[c]~=0 do ",
  ["]"] = "end "
}

-- conversions expanding to include (too many) debugging statements
conversions_debug = {
  [">"] = [[
    local previous = c
    c=c+1
    print("MOVED FROM CELL "..previous.." TO "..c)
  ]],
  ["<"] = [[
    local previous = c
    c=c-1
    print("MOVED FROM CELL "..previous.." TO "..c)
  ]],
  ["+"] = [[
    local previous = m[c]
    m[c]=m[c]+1 if m[c]>255 then m[c]=0 end
    print("MEMORY @ "..c.." INCREMENTED FROM "..previous.." TO "..m[c])
  ]],
  ["-"] = [[
    local previous = m[c]
    m[c]=m[c]-1 if m[c]<0 then m[c]=255 end
    print("MEMORY @ "..c.." DECREMENTED FROM "..previous.." TO "..m[c])
  ]],
  ["."] = [[
    print("WRITING FROM RAW: \""..m[c].."\"")
    local TRANSLATED = o(m[c])
    if TRANSLATED ~= nil then
        print("TRANSLATES TO: \""..TRANSLATED.."\"")
    else
        print("TRANSLATES TO: \"nil\"")
    end
    print("OUTPUTTING!")
    w(TRANSLATED)
  ]],
  [","] = [[
    local READ = r()
    print("READ RAW: \""..READ.."\"")
    local TRANSLATED = i(READ)
    if TRANSLATED ~= nil then
        print("TRANSLATED RAW: \""..TRANSLATED.."\"")
    else
        print("TRANSLATED RAW: \"nil\"")
    end
    m[c] = TRANSLATED
    print("TRANSLATED WAS STORED IN M["..c.."]")
  ]],
  ["["] = [[
    print("-- BEGIN WHILE NOT 0 --")
    print("CURRENT MEMORY: "..m[c])
    while m[c] ~= 0 do
    print("LOOPING WHILE NOT 0")
    print("CURRENT MEMORY: "..m[c])
  ]],
  ["]"] = [[
    end
    print("-- END OF WHILE NOT 0 --")
  ]]
}

-- these are meant to be used with smarter code to optimize
-- groups of cell selections and/or increments/decrements
partials = {
    [">"] = "c=c+",
    ["<"] = "c=c-",
    ["+"] = "m[c]=m[c]+",
    ["-"] = "m[c]=m[c]-",
    -- overflow and underflow checks needed to be re-written
    --  for abitrary lengths of +++/---!
    plusCheck = "while m[c]>255 do m[c]=m[c]-256 end ",
    minusCheck = "while m[c]<0 do m[c]=m[c]+256 end "
}

--TODO make partials_debug

local Help = [[
NAME
    luafuck.lua - Compiles Brainfuck code into Lua code.
SYNOPSIS
    lua luafuck.lua INPUT [OPTIONS] [filename]
DESCRIPTION
    Compiles Brainfuck into Lua code.
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
]]

-- default options
local OUT_FILE = arguments[1]:sub(1, -4) --.. ".lua"
local CONVERSION_SET = conversions
local VERBOSE = false
local DEBUG = false
local EXTENSIONS = {}

-- get our arguments
local arguments = {...}

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
        if CONVERSION_SET[character] then outFileHandle:write(CONVERSION_SET[character]) end
        if VERBOSE then print("Wrote to output:", CONVERSION_SET[character])
    end
end

if VERBOSE then print("Done. Closing files.") end
outFileHandle:close()

print("Assuming this didn't break somewhere, everything seems done! :D")
