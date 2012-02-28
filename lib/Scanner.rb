require File.join(File.dirname(__FILE__), 'Character')

# A Scanner object reads through the sourceText and returns one character at a time.
class Scanner
  attr_accessor :ENDMARK
  
  def initialize (sourceTextArg)
    @sourceText   = sourceTextArg
    @lastIndex    = @sourceText.length - 1
    @sourceIndex  = -1
    @lineIndex    =  0
    @colIndex     = -1
    @ENDMARK      = "\0"  # aka "lowvalues"
  end

  # Return the next character in sourceText.
  def get()
    
    @sourceIndex += 1    # Increment the index in sourceText

    # Maintain the line count
    if @sourceIndex > 0
      if @sourceText[@sourceIndex - 1] == "\n"
        @lineIndex +=1
        @colIndex  = -1
      end
    end

    @colIndex += 1

    if @sourceIndex > @lastIndex
      # We've read past the end of sourceText. Return the ENDMARK character.
      char = Character.new(@ENDMARK, @lineIndex, @colIndex, @sourceIndex, @sourceText)
    else
      c    = @sourceText[@sourceIndex]
      char = Character.new(c, @lineIndex, @colIndex, @sourceIndex, @sourceText)
    end

    return char
  end

  def lookahead(offset=1)
    # Return a string (not a Character object) containing the character
    # at position:
    #    sourceIndex + offset
    # Note that we do NOT move our current position in the sourceText.
    # That is,  we do NOT change the value of sourceIndex.
  
    index = @sourceIndex + offset

    if index > @lastIndex
      # We've read past the end of sourceText.
      # Return the ENDMARK character.
      return @ENDMARK
    else
      return @sourceText[index]
    end
  end
end