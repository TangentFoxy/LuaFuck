-- standard code conversions, each instruction is translated directly
local conversions = {
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
local conversions_debug = {
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
local partials = {
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

return {
    conversions = conversions,
    conversions_debug = conversions_debug,
    partials = partials
}
