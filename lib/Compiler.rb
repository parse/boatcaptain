class Compiler
  def initialize(ast)
    @ast = ast
  end 

  def generateOutput()
    s = ""
    
    for child in @ast.children
      puts child + " hej "
      #s += child.to_s
    end
    #@ast.inspect

    #s
  end
end