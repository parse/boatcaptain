# A recursive descent parser for nxx1, 
# as defined in nxx1ebnf.txt

require File.join(File.dirname(__FILE__), 'Lexer')
require File.join(File.dirname(__FILE__), 'nxxSymbols')
require File.join(File.dirname(__FILE__), 'Node')

class Parser
  attr_accessor :ast

  def initialize(sourceText, verbose = false)
    @sourceText     = sourceText
    @token          = nil
    @ast            = nil
    @verbose        = verbose
    @indent         = 0
    @numberOperator = ["+","-","/","*"]
    @lexer          = Lexer.new(sourceText)
    
    parse()
  end

  def getAST()
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

    #return @ast
  end

  def getToken()
    if @verbose
      if @token
        # print the current token, before we get the next one
        # print (" "*40 ) + token.show() 
        puts(("  "*@indent) + "   (" + @token.show(false) + ")")
      end
    end

    @token  = @lexer.get()
  end

  # Push and pop
  def push(s)
    @indent += 1

    if @verbose
      print(("  "*@indent) + " " + s)
    end
  end

  def pop(s)
    if @verbose
      print(("  "*@indent) + " " + s + ".end")
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
    #puts @token.type + " == " + argTokenType
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

  # Program
  def program()
    push("program")
    # program = statement {statement} EOF.
    node = Node.new()

    statement(node)
    while not found(EOF)
      statement(node)
    end

    consume(EOF)

    @ast = node
    pop("program")
  end

  # Statement
  def statement(node)
    push("statement")

    # statement = printStatement | assignmentStatement .
    # assignmentStatement = variable "=" expression ";".
    # printStatement      = "print" expression ";".

    if found("print")
      printStatement(node)
    else
      assignmentStatement(node)
    end

    pop("statement")
  end

  # Expression
  def expression(node)
    push("expression")

    # expression = stringExpression | numberExpression.
    # "||" is the concatenation operator, as in PL/I 
    # stringExpression =  (stringLiteral | variable) {"||"            stringExpression}.
    # numberExpression =  (numberLiteral | variable) { numberOperator numberExpression}.
    # numberOperator = "+" | "-" | "/" | "*" .

    if found(WHITESPACE) or found(COMMENT)
      getToken()

    elsif found(STRING)
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
    pop("expression")
  end

  # AssignmentStatement
  def assignmentStatement(node)
    push("assignmentStatement")
    #assignmentStatement = variable "=" expression ";".
    identifierNode = Node.new(@token)
    consume(IDENTIFIER)

    operatorNode = Node.new(@token)
    consume("=")
    node.addNode(operatorNode)

    operatorNode.addNode(identifierNode)

    expression(operatorNode)
    consume(";")
    pop("assignmentStatement")
  end

  # printStatement
  def printStatement(node)
    push("printStatement")
    # printStatement      = "print" expression ";".
    statementNode = Node.new(@token)
    consume("print")

    node.addNode(statementNode)

    expression(statementNode)

    consume(";")
    pop("printStatement")
  end

  # stringExpression
  def stringExpression(node)
    push("stringExpression")
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
    pop("stringExpression")
  end

  # numberExpression
  def numberExpression(node)
    push("numberExpression")
    # numberExpression =  (numberLiteral | variable) { numberOperator numberExpression}.
    # numberOperator = "+" | "-" | "/" | "*" .
    if found(NUMBER)
      numberLiteral(node)
    else
      node.add(@token)
      consume(IDENTIFIER)
    end

    while foundOneOf(@numberOperator)
      node.add(@token)
      getToken()
      numberExpression(node)
    end
    pop("numberExpression")
  end

  # commentLiteral
  def commentLiteral(node)
    node.add(@token)
    getToken()
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