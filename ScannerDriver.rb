require File.join(File.dirname(__FILE__), 'Scanner')

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

# Create a scanner (an instance of the Scanner class)
scanner = Scanner.new( get_file_as_string('nxx1.txt') )

#------------------------------------------------------------------
# Call the scanner's get() method repeatedly
# to get the characters in the sourceText.
# Stop when we reach the ENDMARK.
#------------------------------------------------------------------
character = scanner.get()       # getfirst Character object from the scanner

while true
  puts character

  if character.cargo == character.ENDMARK
    break
  end 
  character = scanner.get()   # getnext
end