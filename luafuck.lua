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

-- get our arguments
local arguments = {...}

-- util to check which options are selected
local function selected(option)
    for _,v in pairs(arguments) do
        if v == option then
            return true
        end
        print(_,v)
    end
    return false
end

selected()

--[[ Options
    -v output version, do nothing else
    -V verbose output (NOT IMPLEMENTED)
]]



--TODO check args here,
-- (TEMP => assume 1 arg, filename, out to filename.lua)
-- TEMP assume want debug conversions
local fileName = arguments[1]
local CONVERT = conversions_debug
--local CONVERT = conversions

-- open output file
local outFile = io.open(fileName:sub(1, -4) .. ".lua", "w") --TODO verify correctness

-- write bootstrap
outFile:write(bootstrap)

-- loop through input file and process it
for line in io.lines(fileName) do
    for i=1,line:len() do
        local character = line:sub(i,i)
        if CONVERT[character] then outFile:write(CONVERT[character]) end
    end
end

outFile:close()

-- TODO print success / error / etc
print("success?")
