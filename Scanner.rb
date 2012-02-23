require File.join(File.dirname(__FILE__), 'Character')

# A Scanner object reads through the sourceText and returns one character at a time.
class Scanner
  def initialize(sourceTextArg)
    self.sourceText   = sourceTextArg
    self.lastIndex    = len(sourceText) - 1
    self.sourceIndex  = -1
    self.lineIndex    =  0
    self.colIndex     = -1
  end

  # Return the next character in sourceText.
  def get()
    
    self.sourceIndex += 1    # Increment the index in sourceText

    # Maintain the line count
    if self.sourceIndex > 0
      if self.sourceText[self.sourceIndex - 1] == "\n"
        self.lineIndex +=1
        self.colIndex  = -1
      end
    end

    self.colIndex += 1

    if self.sourceIndex > self.lastIndex
      # We've read past the end of sourceText. Return the ENDMARK character.
      char = Character(ENDMARK, self.lineIndex, self.colIndex, self.sourceIndex, self.sourceText)
    else
      c    = self.sourceText[self.sourceIndex]
      char = Character(c, self.lineIndex, self.colIndex, self.sourceIndex, self.sourceText)
    end

    return char
  end
end