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
bootstrap = "c,m,o,w,i,r=0,{},string.char,io.write,string.byte,io.read setmetatable(m,{__index=function() return 0 end}) "

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

-- these are meant to be used with smarter code to optimize
-- groups of cell selections and/or increments/decrements
partials = {
    [">"] = "c=c+",
    ["<"] = "c=c-",
    ["+"] = "m[c]=m[c]+",
    ["-"] = "m[c]=m[c]-",
    -- over and underflow checks need to be re-written for abitrary lengths of +++/---!
    --plusCheck = "if m[c]>255 then m[c]=0 end ",
    --minusCheck = "if m[c]<0 then m[c]=255 end "
    plusCheck = "while m[c]>255 do m[c]=m[c]-256 end ",
    minusCheck = "while m[c]<0 do m[c]=m[c]+256 end "
}

-- get our arguments
local arguments = {...}

--TODO check args here, (TEMP => assume 1 arg, filename, out to filename.lua)
fileName = arguments[1]

-- open files
--inFile = io.open(fileName)
outFile = io.open(fileName:sub(1, -4) .. ".lua", "w") --TODO verify correctness

-- write bootstrap
outFile:write(bootstrap)

for line in io.lines(fileName) do
    --loop through each byte of line, if key matches, output something, else, continue
    for i=1,line:len() do
        --print(line:sub(i,i))
        local character = line:sub(i,i)
        if conversions[character] then outFile:write(conversions[character]) end
    end
end

--local line --current line from input
--while (line = inFile:read("*line")) do
--    --process
--end

outFile:close()

--TODO print success / error / etc
print("success?")
