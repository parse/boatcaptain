class Compiler
  def initialize(ast)
    @ast = ast
  end

  def generateOutput()
    @ast.inspect
  end
end