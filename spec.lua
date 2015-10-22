--[[ Brainfuck spec:
    > move pointer right
    < move pointer left
    + increment memory at pointer
    - decrement memory at pointer
    . output character of memory at pointer
    , input character to memory at pointer
    [ jump to matching ] if memory at pointer == 0
    ] jump to matching [ if memory at pointer ~= 0
--]]

-- Bootstrap code to make translating to Lua easy:
local cell = 0
local memory = {}
local toCharacter = string.char -- converts ## to char
local writeOut = io.write       -- to default out
local toInteger = string.byte   -- converts char to ##
-- readIn is implemented with a buffer
--  because using io.read() directly doesn't work
local readBuffer = ""
local function readIn()
    if readBuffer:len() == 0 then readBuffer = io.read() end
    local out = readBuffer:sub(1,1)
    readBuffer = readBuffer:sub(2)
    return out
end

-- Make sure cells are "initially" zero:
setmetatable(memory, {__index = function(Table, key)
    return 0
end})

-- Brainfuck to Lua translations:

--Instruction ">"
    cell = cell + 1
--Instruction "<"
    cell = cell - 1
--Instruction "+"
    memory[cell] = memory[cell] + 1
    if memory[cell] > 255 then
        memory[cell] = 0
    end
--Instruction "-"
    memory[cell] = memory[cell] - 1
    if memory[cell] < 0 then
        memory[cell] = 255
    end
--Instruction "."
    writeOut(toCharacter(memory[cell]))
--Instruction ","
    memory[cell] = toInteger(readIn())
--Instruction "["
    while memory[cell] ~= 0 do
--Instruction "]"
    end
