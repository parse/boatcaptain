# A recursive descent parser for nxx1, 
# as defined in nxx1ebnf.txt

require File.join(File.dirname(__FILE__), 'Lexer')
require File.join(File.dirname(__FILE__), 'nxxSymbols')
require File.join(File.dirname(__FILE__), 'Node')

class Parser

  def initialize(sourceText, verbose = false)
    @sourceText     = sourceText
    @token          = nil
    @ast            = nil
    @verbose        = verbose
    @indent         = 0
    @numberOperator = ["+","-","/","*"]
    @lexer          = Lexer.new(sourceText)

    parse()

    return @ast
  end

  # Parse
  def parse()
    getToken()
    program()

    if @verbose
      puts "~"*40
      puts "Successful parse!"
      puts "~"*40
    end

    return @ast
  end

  def getToken()
    if @verbose
      if @token
        # print the current token, before we get the next one
        # print (" "*40 ) + token.show() 
        puts(("  "*@indent) + "   (" + @token.show(align=False) + ")")
      end
    end

    @token  = @lexer.get()
  end


  # Push and pop
  def push(s)
    @indent += 1

    if @verbose
      print(("  "*indent) + " " + s)
    end
  end

  def pop(s)
    if @verbose
      #print(("  "*indent) + " " + s + ".end")
      pass
    end

    @indent -= 1
  end

  # Error passing
  def error(msg)
    @token.abort(msg)
  end

  # foundOneOf
  def foundOneOf(argTokenTypes)
    # argTokenTypes should be a list of argTokenType

    for argTokenType in argTokenTypes
      #print "foundOneOf", argTokenType, token.type
      if @token.type == argTokenType
        return true
      end
    end

    return false
  end

  # Found
  def found(argTokenType)
    if @token.type == argTokenType
      return true
    end

    return false
  end

  # Consume
  def consume(argTokenType)
    # Consume a token of a given type and get the next token.
    # If the current token is NOT of the expected type, then
    # raise an error.

    if @token.type == argTokenType
      getToken()
    else
      error("I was expecting to find " + argTokenType.to_s + " but I found " + @token.show(align = false) )
    end
  end

  # Decorator track0
  def track0(func)
    def newfunc()
      push(func.__name__) 
      func()
      pop(func.__name__)
    end

    return newfunc
  end
      
  # Decorator track
  def track(func)
    def newfunc(node)
      push(func.__name__)
      func(node)
      pop(func.__name__)
    end

    return newfunc
  end

  # Program
  @track0
  def program()
    # program = statement {statement} EOF.
    node = Node.new()

    statement(node)

    while not found(EOF)
      statement(node)
    end
    consume(EOF)
    @ast = node
  end

  # Statement
  @track
  def statement(node)
    # statement = printStatement | assignmentStatement .
    # assignmentStatement = variable "=" expression ";".
    # printStatement      = "print" expression ";".

    if found("print")
      printStatement(node)
    else
      assignmentStatement(node)
    end
  end

  # Expression
  @track
  def expression(node)
    # expression = stringExpression | numberExpression.
    # "||" is the concatenation operator, as in PL/I 
    # stringExpression =  (stringLiteral | variable) {"||"            stringExpression}.
    # numberExpression =  (numberLiteral | variable) { numberOperator numberExpression}.
    # numberOperator = "+" | "-" | "/" | "*" .

    if found(STRING)
      stringLiteral(node)

      while found("||")
          getToken()
          stringExpression(node)
      end

    elsif found(NUMBER)
      numberLiteral(node)

      while foundOneOf(@numberOperator)
        node.add(@token)
        getToken()
        numberExpression(node)
      end
    else
      node.add(@token)
      consume(IDENTIFIER)

      if found("||")
        while found("||")
          getToken()
          stringExpression(node)
        end
      elsif foundOneOf(@numberOperator)
        while foundOneOf(@numberOperator)
          node.add(@token)
          getToken()
          numberExpression(node)
        end
      end
    end
  end

  # AssignmentStatement
  @track
  def assignmentStatement(node)
    #assignmentStatement = variable "=" expression ";".
    identifierNode = Node.new(@token)
    consume(IDENTIFIER)

    operatorNode = Node.new(@token)
    consume("=")
    node.addNode(operatorNode)

    operatorNode.addNode(identifierNode)

    expression(operatorNode)
    consume(";")
  end

  # printStatement
  @track
  def printStatement(node)
    # printStatement      = "print" expression ";".
    statementNode = Node.new(@token)
    consume("print")

    node.addNode(statementNode)

    expression(statementNode)

    consume(";")
  end

  # stringExpression
  @track
  def stringExpression(node)
    # /* "||" is the concatenation operator, as in PL/I */
    #stringExpression =  (stringLiteral | variable) {"||" stringExpression}.

    if found(STRING)
      node.add(@token)
      getToken()

      while found("||")
        getToken()
        stringExpression(node)
      end
    else
      node.add(@token)
      consume(IDENTIFIER)
    end

    while found("||")
      getToken() 
      stringExpression(node)
    end
  end

  # numberExpression
  @track
  def numberExpression(node)
    # numberExpression =  (numberLiteral | variable) { numberOperator numberExpression}.
    # numberOperator = "+" | "-" | "/" | "*" .
    if found(NUMBER)
      numberLiteral(node)
    else
      node.add(@token)
      consume(IDENTIFIER)
    end

    while foundOneOf(numberOperator)
      node.add(@token)
      getToken()
      numberExpression(node)
    end
  end

  # stringLiteral
  def stringLiteral(node)
    node.add(@token)
    getToken()
  end

  # numberLiteral
  def numberLiteral(node)
    node.add(@token)
    getToken()
  end
end