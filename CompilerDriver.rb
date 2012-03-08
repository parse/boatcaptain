require File.join(File.dirname(__FILE__), 'lib/Parser')
require File.join(File.dirname(__FILE__), 'lib/Compiler')

def get_file_as_string(filename)
  data = ''
  f = File.open(filename, "r") 
  f.each_line do |line|
    data += line
  end
  return data
end

sourceText 	= get_file_as_string('nxx1.txt')
parser 		= Parser.new(sourceText, true)

puts "~"*40
puts "Here is the generated output:"
puts "~"*40

ast 		= parser.getAST()
puts ast.children.inspect
#compiler 	= Compiler.new(ast)
#puts compiler.generateOutput()