local class = require "lib.middleclass"
local Scanner = require "scanner"
local Token = require "token"
local VALUE = require "values"

local Lexer = class("Lexer")

function Lexer:initialize(source)
    self.scanner = Scanner(source)
    --self.token = Token(self.scanner:get())
end

function Lexer:get()
    --idfk
    --local character = self.scanner:get()
    --while character:getChar() not in VALUE.KEYWORD do --NOTE PESUDO-CODE!
    --    -- keep putting it in, type is comment
    --end
end

return Lexer
