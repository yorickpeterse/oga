##
# AST parser for CSS expressions.
#
class Oga::CSS::Parser

options no_result_var

rule
  css
    : expression { val[0] }
    | /* none */ { nil }
    ;

  expression
    : path
    | node_test
    ;

  path_member
    : node_test
    ;

  path_members
    : path_member path_member  { [val[0], val[1]] }
    | path_member path_members { [val[0], *val[1]] }
    ;

  path
    : path_members { s(:path, *val[0]) }
    ;

  node_test
    : node_name { s(:test, *val[0]) }
    ;

  node_name
    # foo
    : T_IDENT { [nil, val[0]] }

    # ns|foo
    | T_IDENT T_PIPE T_IDENT { [val[0], val[2]] }

    # |foo
    | T_PIPE T_IDENT { [nil, val[1]] }
    ;
end

---- inner
  ##
  # @param [String] data The input to parse.
  #
  def initialize(data)
    @lexer = Lexer.new(data)
  end

  ##
  # @param [Symbol] type
  # @param [Array] children
  # @return [AST::Node]
  #
  def s(type, *children)
    return AST::Node.new(type, children)
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
  #  parser = Oga::CSS::Parser.new('foo.bar')
  #  ast    = parser.parse
  #
  # @return [AST::Node]
  #
  def parse
    ast = yyparse(self, :yield_next_token)

    return ast
  end

# vim: set ft=racc:
