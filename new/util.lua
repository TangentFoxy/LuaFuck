local ENDMARK = require("values").ENDMARK

local function printable(char)
    local result = tostring(char)

    if char == " " then
        result = "(space)"
    elseif char == "\n" then
        result = "(newline)"
    elseif char == "\t" then
        result = "(tab)"
    elseif char == ENDMARK then
        result = "(eof)"
    end

    return result
end

local function not_in()
    --idfk
end

return {
    printable = printable,
}
