--[[
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
    c = 0
    m = {}
    o = string.char --converts ## to char
    w = io.write    --to default out
    i = string.byte --converts char to ##
    r = io.read     --from default in

    Brainfuck to Lua translations:
    > c = c + 1
    < c = c - 1
    + m[c] = m[c] + 1 if m[c] > 255 then m[c] = 0 end
    - m[c] = m[c] - 1 if m[c] < 0 then m[c] = 255 end
    . w(o(m[c]))
    , m[c] = i(r())
    [ while m[c] ~= 0 do
    ] end
]]

bootstrap = "c,m,o,w,i,r=0,{},string.char,io.write,string.byte,io.read "

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
