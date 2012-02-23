require File.join(File.dirname(__FILE__), 'Lexer')
require File.join(File.dirname(__FILE__), 'Token')

def get_file_as_string(filename)
  data = ''
  f = File.open(filename, "r") 
  f.each_line do |line|
    data += line
  end
  return data
end

puts "Here are the characters returned by the scanner:"
puts "  line col  character"

lexer = Lexer.new( get_file_as_string('nxx1.txt') )

while true
    token = lexer.get()

    puts token.show(true)

    if token.type == EOF
        break
    end
end
