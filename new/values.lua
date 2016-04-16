return {
    -- special
    ENDMARK   = "\0",
    KEYWORD = {
        R_ARROW   = ">",
        L_ARROW   = "<",
        PLUS      = "+",
        MINUS     = "-",
        OUTPUT    = ".",
        INPUT     = ",",
        L_BRACKET = "[",
        R_BRACKET = "]",
    },
    TOKEN = {
        KEYWORD   = "Instruction",
        COMMENT   = "Comment",
        EOF       = "Eof",
        UNKNOWN   = "Unknown",
    },
}
