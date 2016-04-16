local class = require "lib.middleclass"
local printable = require("util").printable
local ENDMARK = require("values").ENDMARK

local Character = class("Character")

function Character:initialize(char, line, column)
    self.char = char
    self.line = line
    self.column = column
end

function Character:getChar()
    return self.char
end

function Character:getLine()
    return self.line
end

function Character:getColumn()
    return self.column
end

function Character:__tostring()
    local char = printable(self.char)

    return tostring(self.line) .. "\t" .. tostring(self.column) .. "\t" .. char
end

return Character
