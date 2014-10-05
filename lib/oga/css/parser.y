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
    | axis
    ;

  path_member
    : node_test
    | axis
    ;

  path_members
    : path_member path_member  { [val[0], val[1]] }
    | path_member path_members { [val[0], *val[1]] }
    ;

  path
    : path_members { s(:path, *val[0]) }
    ;

  node_test
    : node_name           { s(:test, *val[0]) }
    | node_name predicate { s(:test, *val[0], val[1]) }
    ;

  node_name
    # foo
    : T_IDENT { [nil, val[0]] }

    # ns|foo
    | T_IDENT T_PIPE T_IDENT { [val[0], val[2]] }

    # |foo
    | T_PIPE T_IDENT { [nil, val[1]] }
    ;

  predicate
    : T_LBRACK predicate_members T_RBRACK { val[1] }
    ;

  predicate_members
    : node_test
    | operator
    ;

  operator
    : op_members T_EQ          op_members { s(:eq, val[0], val[2]) }
    | op_members T_SPACE_IN    op_members { s(:space_in, val[0], val[2]) }
    | op_members T_STARTS_WITH op_members { s(:starts_with, val[0], val[2]) }
    | op_members T_ENDS_WITH   op_members { s(:ends_with, val[0], val[2]) }
    | op_members T_IN          op_members { s(:in, val[0], val[2]) }
    | op_members T_HYPHEN_IN   op_members { s(:hyphen_in, val[0],val[2]) }
    ;

  axis
    # x > y
    : node_test T_CHILD node_test
      {
        s(:axis, 'child', val[0], val[2])
      }

    # x + y
    | node_test T_FOLLOWING node_test
      {
        s(:axis, 'following', val[0], val[2])
      }

    # x ~ y
    | node_test T_FOLLOWING_DIRECT node_test
      {
        s(:axis, 'following-direct', val[0], val[2])
      }
    ;

  op_members
    : node_test
    | string
    ;

  string
    : T_STRING { s(:string, val[0]) }
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
