require File.join(File.dirname(__FILE__), 'lib/Parser')

def get_file_as_string(filename)
  data = ''
  f = File.open(filename, "r") 
  f.each_line do |line|
    data += line
  end
  return data
end

sourceText = get_file_as_string('nxx1.txt')
parser = Parser.new(sourceText, false)

puts "~"*40
puts "Here is the abstract syntax tree:"
puts "~"*40

ast = parser.getAST()
puts ast.to_s