##
# Parser for XPath expressions.
#
class Oga::XPath::Parser

token T_AXIS T_COLON T_COMMA T_FLOAT T_INT T_IDENT T_OP T_STAR
token T_LBRACK T_RBRACK T_LPAREN T_RPAREN T_SLASH T_STRING

options no_result_var

rule
  expressions
    : expressions_ { s(:xpath, *val[0]) }
    | /* none */   { s(:xpath) }
    ;

  expressions_
    : expressions_ expression { val[0] << val[1] }
    | expression              { val }
    ;

  expression
    : node_test
    ;

  node_test
    : T_IDENT                  { s(:node, nil, val[0]) }
    | T_IDENT T_COLON T_IDENT  { s(:node, val[0], val[2]) }
    ;
end

---- inner
  ##
  # @param [String] data The input to parse.
  #
  # @param [Hash] options
  #
  def initialize(data)
    @data  = data
    @lexer = Lexer.new(data)
  end

  ##
  # Creates a new XPath node.
  #
  # @param [Symbol] type
  # @param [Array] children
  # @return [Oga::XPath::Node]
  #
  def s(type, *children)
    return Node.new(type, children)
  end

  ##
  # Yields the next token from the lexer.
  #
  # @yieldparam [Array]
  #
  def yield_next_token
    @lexer.advance do |*args|
      yield args
    end

    yield [false, false]
  end

  ##
  # Parses the input and returns the corresponding AST.
  #
  # @example
  #  parser = Oga::XPath::Parser.new('//foo')
  #  ast    = parser.parse
  #
  # @return [Oga::AST::Node]
  #
  def parse
    ast = yyparse(self, :yield_next_token)

    return ast
  end
# vim: set ft=racc:
