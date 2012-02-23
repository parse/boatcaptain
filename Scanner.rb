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
end