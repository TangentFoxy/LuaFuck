local class = require "lib.middleclass"
local printable = require("util").printable
local VALUE = require "values"

local Token = class("Token")

function Token:initialize(character)
    self.text = character:getChar()
    self.line = character:getLine()
    self.column = character:getColumn()

    self.type = VALUE.TOKEN.UNKNOWN
end

function Token:add(character)
    self.text = self.text + character:getChar()
end

function Token:__tostring()
    local text = printable(self.text)

    return tostring(self.line) .. "\t" .. tostring(self.column) .. "\t" .. text .. "\t(" .. self.type .. ")"
end

return Token
