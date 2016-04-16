local class = require "lib.middleclass"
local Character = require "Character"
local ENDMARK = require("values").ENDMARK

local Scanner = class("Scanner")

function Scanner:initialize(source)
    self.source = source
    self.last = #source - 1 -- last index in source code
    self.index = -1         -- current index
    self.line = 0           -- current line
    self.column = -1        -- current column
end

function Scanner:get()
    -- go to next index
    self.index = self.index + 1

    -- check if we are on a newline and handle it
    if self.index > 0 then
        if self.source:sub(self.index - 1, self.index - 1) == "\n" then
            -- on a new line
            self.line = self.line + 1
            self.column = -1
        end
    end

    self.column = self.column + 1

    -- return an ENDMARK or the current character
    if self.index > self.last then
        return Character(ENDMARK, self.line, self.column)
    else
        return Character(self.source:sub(self.index, self.index), self.line, self.column)
    end
end

return Scanner
