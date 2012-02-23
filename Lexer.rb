require File.join(File.dirname(__FILE__), 'Scanner')
require File.join(File.dirname(__FILE__), 'nxxSymbols')

class Lexer

  def initialize(sourceText)

    # Initialize the scanner with the sourceText
    @scanner = Scanner.new(sourceText)
    @c1 = nil
    @c2 = nil
    @character = nil
    @ENDMARK = "\0"        # aka "lowvalues"

    # Use the scanner to read the first character from the sourceText
    getChar()
  end

  def getChar()  
    # Get the next character
    @character = @scanner.get()
    @c1 = @character.cargo

    #---------------------------------------------------------------
    # Every time we get a character from the scanner, we also  
    # lookahead to the next character and save the results in c2.
    # This makes it easy to lookahead 2 characters.
    #---------------------------------------------------------------
    @c2 = @c1 + @scanner.lookahead(1)
  end

  def get()
    # Construct and return the next token in the sourceText.

    # Read past and ignore any whitespace characters or any comments -- START
    while WHITESPACE_CHARS.include? @c1 or @c2 == "/*" 

      # Process whitespace
      while WHITESPACE_CHARS.include? @c1

        token = Token.new(@character)
        token.type = WHITESPACE
        getChar() 

        while WHITESPACE_CHARS.include? @c1
          token.cargo += @c1
          getChar() 
                          
          return token  # only if we want the lexer to return whitespace
        end
      end
      
      # Process comments
      while @c2 == "/*"

        # We found comment start
        token = Token.new(@character)
        token.type = COMMENT
        token.cargo = @c2

        getChar() # read past the first  character of a 2-character token
        getChar() # read past the second character of a 2-character token

        while not @c2 == "*/"
          if @c1 == @ENDMARK
            token.abort("Found end of file before end of comment")
          end

          token.cargo += @c1
          getChar() 
        end

        token.cargo += @c2  # append the */ to the token cargo

        getChar() # read past the first  character of a 2-character token
        getChar() # read past the second character of a 2-character token
      
        return token
      end
    end

    # Create a new token.  The token will pick up its line and column information from the character.
    token = Token.new(@character)

    if @c1 == @ENDMARK
      token.type = EOF

      return token
    end

    if IDENTIFIER_STARTCHARS.include? @c1
      token.type = IDENTIFIER
      getChar() 

      while IDENTIFIER_CHARS.include? @c1
        token.cargo += @c1
        getChar() 
      end
      
      if KeeyWords.include? token.cargo
        token.type = token.cargo
      end
        
      return token
    end

    if NUMBER_STARTCHARS.include? @c1
      token.type = NUMBER
      getChar() 
          
      while NUMBER_CHARS.include? @c1 
        token.cargo += @c1
        getChar() 
      end
        
      return token
    end

    if STRING_STARTCHARS.include? @c1

      # Remember the quoteChar (single or double quote)
      # So we can look for the same character to terminate the quote.
      quoteChar = @c1

      getChar() 

      while @c1 != quoteChar
        if @c1 == @ENDMARK
          token.abort("Found end of file before end of string literal")
        end

        token.cargo += @c1    # Append quoted character to text
        getChar()    
      end  

      token.cargo += @c1      # Append close quote to text
      getChar()          
      token.type = STRING

      return token
    end

    if TwoCharacterSymbols.include? @c2
      token.cargo = @c2
      token.type  = token.cargo   # For symbols, the token type is same as the cargo
      getChar()                   # Read past the first  character of a 2-character token
      getChar()                   # Read past the second character of a 2-character token

      return token
    end

    if OneCharacterSymbols.include? @c1
      token.type = token.cargo  # For symbols, the token type is same as the cargo
      getChar()                 # Read past the symbol

      return token
    end

    # We have encountered something that we don't recognize.
    token.abort("I found a character or symbol that I do not recognize: " + dq(c1))
  end
end