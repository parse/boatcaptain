class AST
  attr_accessor :level, :to_s, :children

  def initialize(token=nil)
    @token = token
    @level = 0
    @children = []  # A list of my children
  end
    
  def add(token)
    # Make a node out of a token and add it to self.children
    addNode( AST.new(token) )
  end
        
  def addNode(node)
    # Add a node to self.children
    node.level = @level + 1
    @children << node 
  end

  def to_s()
    s = "    " * @level
        
    if @token == nil
      s += "ROOT\n"
    else
      s +=  @token.cargo + "\n"
    end
            
    for child in @children
      s += child.to_s
    end
    
    return s
  end
end