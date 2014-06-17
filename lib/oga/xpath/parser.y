##
# Parser for XPath expressions.
#
class Oga::XPath::Parser

token T_AXIS T_COLON T_COMMA T_FLOAT T_INT T_IDENT T_STAR
token T_LBRACK T_RBRACK T_LPAREN T_RPAREN T_SLASH T_STRING
token T_PIPE T_AND T_OR T_ADD T_DIV T_MOD T_EQ T_NEQ T_LT T_GT T_LTE T_GTE

options no_result_var

prechigh
  left  T_EQ T_AXIS
  right T_OR
preclow

rule
  xpath
    : T_SLASH path { s(:absolute, val[1]) }
    | path         { val[0] }
    | /* none */   { nil }
    ;

  path
    : expression              { s(:path, val[0]) }
    | expression T_SLASH path { s(:path, val[0], val[2]) }
    ;

  expression
    : node_test
    | operator
    | axis
    | string
    | number
    | call
    ;

  node_test
    : node_name           { s(:test, *val[0]) }
    | node_name predicate { s(:test, *val[0], val[1]) }
    ;

  node_name
    # foo
    : T_IDENT { [nil, val[0]] }

    # foo:bar
    | T_IDENT T_COLON T_IDENT { [val[0], val[2]] }
    ;

  predicate
    : T_LBRACK xpath T_RBRACK { val[1] }
    ;

  operator
    : expression T_EQ expression { s(:eq, val[0], val[2]) }
    | expression T_OR expression { s(:or, val[0], val[2]) }
    ;

  axis
    : T_AXIS expression { s(:axis, val[0], val[1]) }
    | T_AXIS            { s(:axis, val[0]) }
    ;

  call
    : T_IDENT T_LPAREN T_RPAREN           { s(:call, val[0]) }
    | T_IDENT T_LPAREN call_args T_RPAREN { s(:call, val[0], *val[2]) }
    ;

  call_args
    : xpath                   { val }
    | xpath T_COMMA call_args { [val[0], *val[2]] }
    ;

  string
    : T_STRING { s(:string, val[0]) }
    ;

  number
    : T_INT   { s(:int, val[0]) }
    | T_FLOAT { s(:float, val[0]) }
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
