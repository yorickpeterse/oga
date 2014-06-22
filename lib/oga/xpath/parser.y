##
# Parser for XPath expressions.
#
class Oga::XPath::Parser

token T_AXIS T_COLON T_COMMA T_FLOAT T_INT T_IDENT
token T_LBRACK T_RBRACK T_LPAREN T_RPAREN T_SLASH T_STRING
token T_PIPE T_AND T_OR T_ADD T_DIV T_MOD T_EQ T_NEQ T_LT T_GT T_LTE T_GTE
token T_SUB T_MUL

options no_result_var

prechigh
  left T_PIPE T_MOD T_DIV T_MUL T_SUB T_ADD
  left T_GT T_GTE T_LT T_LTE T_NEQ T_EQ T_AND T_OR
preclow

rule
  xpath
    : paths      { val[0] }
    | /* none */ { nil }
    ;

  paths
    : T_SLASH path { s(:absolute, val[1]) }
    | path         { val[0] }
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
    : T_LBRACK paths T_RBRACK { val[1] }
    ;

  operator
    : expression T_PIPE expression { s(:pipe, val[0], val[2]) }
    | expression T_AND  expression { s(:and, val[0], val[2]) }
    | expression T_OR   expression { s(:or, val[0], val[2]) }
    | expression T_ADD  expression { s(:add, val[0], val[2]) }
    | expression T_DIV  expression { s(:div, val[0], val[2]) }
    | expression T_MOD  expression { s(:mod, val[0], val[2]) }
    | expression T_EQ   expression { s(:eq, val[0], val[2]) }
    | expression T_NEQ  expression { s(:neq, val[0], val[2]) }
    | expression T_LT   expression { s(:lt, val[0], val[2]) }
    | expression T_GT   expression { s(:gt, val[0], val[2]) }
    | expression T_LTE  expression { s(:lte, val[0], val[2]) }
    | expression T_GTE  expression { s(:gte, val[0], val[2]) }
    | expression T_MUL  expression { s(:mul, val[0], val[2]) }
    | expression T_SUB  expression { s(:sub, val[0], val[2]) }
    ;

  axis
    : T_AXIS axis_value { s(:axis, val[0], val[1]) }
    | T_AXIS            { s(:axis, val[0]) }
    ;

  axis_value
    : node_test
    | call
    ;

  call
    : T_IDENT T_LPAREN T_RPAREN           { s(:call, val[0]) }
    | T_IDENT T_LPAREN call_args T_RPAREN { s(:call, val[0], *val[2]) }
    ;

  call_args
    : paths                   { val }
    | paths T_COMMA call_args { val[2].unshift(val[0]) }
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
