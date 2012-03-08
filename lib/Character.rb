# A Character object holds
#        - one character (self.cargo)
#        - the index of the character's position in the sourceText.
#        - the index of the line where the character was found in the sourceText.
#        - the index of the column in the line where the character was found in the sourceText.
#        - (a reference to) the entire sourceText (self.sourceText)

#   This information will be available to a token that uses this character.
#    If an error occurs, the token can use this information to report the
#    line/column number where the error occurred, and to show an image of the
#    line in sourceText where the error occurred.  

class Character
  attr_accessor :cargo, :sourceText, :lineIndex, :colIndex, :ENDMARK

  def initialize(c, lineIndex, colIndex, sourceIndex, sourceText)
    @cargo          = c
    @sourceIndex    = sourceIndex
    @lineIndex      = lineIndex
    @colIndex       = colIndex
    @sourceText     = sourceText
    @ENDMARK        = "\0"        # aka "lowvalues"
  end 

  # Return a displayable string representation of the Character object
  def to_s
    cargo = @cargo

    if cargo == " "
      cargo = "   space"
    elsif cargo == "\n"   
      cargo = "   newline"
    elsif cargo == "\t"    
      cargo = "   tab"
    elsif cargo == @ENDMARK 
      cargo = "   eof"
    end 

    @lineIndex.to_s.rjust(6) + @colIndex.to_s.rjust(4) + "  " + cargo
  end 
end