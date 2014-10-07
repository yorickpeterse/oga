##
# AST parser for CSS expressions.
#
class Oga::CSS::Parser

token T_IDENT T_PIPE T_LBRACK T_RBRACK T_COLON T_SPACE T_LPAREN T_RPAREN T_MINUS
token T_EQ T_SPACE_IN T_STARTS_WITH T_ENDS_WITH T_IN T_HYPHEN_IN
token T_CHILD T_FOLLOWING T_FOLLOWING_DIRECT
token T_NTH T_INT T_STRING T_ODD T_EVEN

options no_result_var

prechigh
  left T_COLON
  left T_CHILD T_FOLLOWING T_FOLLOWING_DIRECT
preclow

rule
  css
    : expression { val[0] }
    | /* none */ { nil }
    ;

  expression
    : path
    | path_member
    ;

  path
    : path_members { s(:path, *val[0]) }
    ;

  path_members
    : path_member T_SPACE path_member  { [val[0], val[2]] }
    | path_member T_SPACE path_members { [val[0], *val[2]] }
    ;

  path_member
    : node_test
    | axis
    | pseudo_class
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

  op_members
    : node_test
    | string
    ;

  axis
    # x > y
    : path_member T_CHILD path_member
      {
        s(:axis, 'child', val[0], val[2])
      }

    # x + y
    | path_member T_FOLLOWING path_member
      {
        s(:axis, 'following', val[0], val[2])
      }

    # x ~ y
    | path_member T_FOLLOWING_DIRECT path_member
      {
        s(:axis, 'following-direct', val[0], val[2])
      }
    ;

  pseudo_class
    # x:root
    : path_member T_COLON T_IDENT { s(:pseudo, val[2], val[0]) }

    # x:nth-child(2)
    | path_member T_COLON T_IDENT T_LPAREN pseudo_arg T_RPAREN
      {
        s(:pseudo, val[2], val[0], val[4])
      }
    ;

  pseudo_arg
    : integer
    | odd
    | even
    | nth
    ;

  odd
    : T_ODD { s(:odd) }
    ;

  even
    : T_EVEN { s(:even) }
    ;

  nth
    : T_NTH                 { s(:nth) }
    | T_MINUS T_NTH         { s(:nth) }
    | integer T_NTH         { s(:nth, val[0]) }
    | integer T_NTH integer { s(:nth, val[0], val[2]) }
    ;

  string
    : T_STRING { s(:string, val[0]) }
    ;

  integer
   : T_INT { s(:int, val[0].to_i) }
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
