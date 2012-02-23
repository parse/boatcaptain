# List of keywords
KeyWords = ["if", "then", "else", "elif", "endif", "while", "loop", "endloop", "print", "return", "exit"]

# A list of symbols that are one character long
OneCharacterSymbols = ["=", "(", ")", "<", ">", "/", "*", "+", "-", "!", "&", ".", ";"]

# A list of symbols that are two characters long
TwoCharacterSymbols = ["==", "<=", ">=", "<>", "!=", "++", "**", "--", "+=", "-=", "||"]

IDENTIFIER_STARTCHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
IDENTIFIER_CHARS      = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"

NUMBER_STARTCHARS     = "0123456789"
NUMBER_CHARS          = "0123456789."

STRING_STARTCHARS = "'" + '"'
WHITESPACE_CHARS  = " \t\n"

# TokenTypes for things other than symbols and keywords
STRING             = "String"
IDENTIFIER         = "Identifier"
NUMBER             = "Number"
WHITESPACE         = "Whitespace"
COMMENT            = "Comment"
EOF                = "Eof"