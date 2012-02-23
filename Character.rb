ENDMARK = "\0"  # aka "lowvalues"

class Character
  def initialize(c, lineIndex, colIndex, sourceIndex, sourceText)
    self.cargo          = c
    self.sourceIndex    = sourceIndex
    self.lineIndex      = lineIndex
    self.colIndex       = colIndex
    self.sourceText     = sourceText
  end 

  # Return a displayable string representation of the Character object
  def to_s()
    if self.cargo == " "
      self.cargo = "   space"
    elsif self.cargo == "\n"   
      self.cargo = "   newline"
    elsif self.cargo == "\t"    
      self.cargo = "   tab"
    elsif self.cargo == ENDMARK 
      self.cargo = "   eof"
    end 

    return (
      str(lineIndex).rjust(6)
      + str(colIndex).rjust(4)
      + "  "
      + self.cargo
     )
  end 
end