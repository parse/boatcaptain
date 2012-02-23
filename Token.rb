# A Token object is the kind of thing that the Lexer returns.
# It holds:
# - the text of the token (self.cargo)
# - the type of token that it is
# - the line number and column index where the token starts

class Token
  attr_accessor :cargo, :type

  def initialize (startChar)

    # The constructor of the Token class
    @cargo = startChar.cargo

    # The token picks up information, about its location in the sourceText
    @sourceText = startChar.sourceText
    @lineIndex  = startChar.lineIndex
    @colIndex   = startChar.colIndex

    # We won't know what kind of token we have until we have
    # finished processing all of the characters in the token.
    # So when we start, the token.type is None (aka null).
    @type = nil
  end
  
  #  Return a displayable string representation of the token
  def show (showLineNumbers = false, *args)
    # align=True shows token type left justified with dot leaders.
    # Specify align=False to turn this feature OFF.        
    align = false #args.get("align", true)
# TODO: FIX
    if align
      tokenTypeLen = 12
      space = " "
    else
      tokenTypeLen = 0
      space = ""
    end      
      
    if showLineNumbers
      s = @lineIndex.to_s.rjust(6) + @colIndex.to_s.rjust(4) + "  "
    else
      s = ""
    end
            
    if @type == @cargo
      s = s + "Symbol".ljust(tokenTypeLen, ".") + ":" + space + @type
    elsif @type == "Whitespace"
      s = s + "Whitespace".ljust(tokenTypeLen, ".") + ":" + space + repr(@cargo)
    else
      s = s + @type.ljust(tokenTypeLen, ".") + ":" + space + @cargo
    end

    return s
  end
  
  def abort (msg)
    lines = @sourceText.split("\n")
    sourceLine = lines[@lineIndex]

    # @TODO: FIX!
    #raise LexerError("\nIn line "      + str(self.lineIndex + 1)
    #     + " near column " + str(self.colIndex + 1) + ":\n\n"
    #     + sourceLine.replace("\t"," ") + "\n"
    #     + " "* self.colIndex
    #     + "^\n\n"
    #     + msg)
  end
end        
    
#guts = property(show)