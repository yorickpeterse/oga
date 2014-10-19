##
# AST parser for CSS expressions.
#
class Oga::CSS::Parser

token T_IDENT T_PIPE T_LBRACK T_RBRACK T_COLON T_SPACE T_LPAREN T_RPAREN T_MINUS
token T_EQ T_SPACE_IN T_STARTS_WITH T_ENDS_WITH T_IN T_HYPHEN_IN
token T_CHILD T_FOLLOWING T_FOLLOWING_DIRECT
token T_NTH T_INT T_STRING T_ODD T_EVEN T_DOT T_HASH

options no_result_var

prechigh
  left T_COLON T_HASH T_DOT
  left T_CHILD T_FOLLOWING T_FOLLOWING_DIRECT
  left T_DOT T_HASH
preclow

rule
  css
    : expression { val[0] }
    | /* none */ { nil }
    ;

  expression
    : steps { s(:path, *val[0]) }
    | step
    ;

  steps
    : step T_SPACE step  { [val[0], val[2]] }
    | step T_SPACE steps { [val[0], *val[2]] }
    ;

  step
    : step_test { s(:axis, 'descendant-or-self', val[0]) }
    ;

  step_test
    : element_test    { val[0] }
    | step_predicates { s(:test, nil, '*', val[0]) }
    ;

  step_predicates
    : step_predicate
    | step_predicates step_predicate { s(:and, val[0], val[1]) }
    ;

  step_predicate
    : class
    | id
    #| axis
    #| pseudo_class
    ;

  element_test
    # foo
    : node_name { s(:test, *val[0]) }

    # foo[bar]
    | node_name predicate { s(:test, *val[0], val[1]) }

    # foo:root
    | node_name step_predicates { s(:test, *val[0], val[1]) }

    # foo[bar]:root
    | node_name predicate step_predicates
      {
        s(:test, *val[0], s(:and, val[1], val[2]))
      }
    ;

  attribute_test
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

  predicate
    : T_LBRACK predicate_members T_RBRACK { val[1] }
    ;

  predicate_members
    : attribute_test
    #| operator
    ;

  class
    : T_DOT T_IDENT
      {
        s(
          :eq,
          s(:axis, 'attribute', s(:test, nil, 'class')),
          s(:string, val[1])
        )
      }
    ;

  id
    : T_HASH T_IDENT
      {
        s(
          :eq,
          s(:axis, 'attribute', s(:test, nil, 'id')),
          s(:string, val[1])
        )
      }
    ;

  # operator
  #   : op_members T_EQ          op_members { s(:eq, val[0], val[2]) }
  #   | op_members T_SPACE_IN    op_members { s(:space_in, val[0], val[2]) }
  #   | op_members T_STARTS_WITH op_members { s(:starts_with, val[0], val[2]) }
  #   | op_members T_ENDS_WITH   op_members { s(:ends_with, val[0], val[2]) }
  #   | op_members T_IN          op_members { s(:in, val[0], val[2]) }
  #   | op_members T_HYPHEN_IN   op_members { s(:hyphen_in, val[0],val[2]) }
  #   ;
  #
  # op_members
  #   : node_test
  #   | string
  #   ;
  #
  # axis
  #   # x > y
  #   : step_member T_CHILD step_member { s(:child, val[0], val[2]) }
  #
  #   # x + y
  #   | step_member T_FOLLOWING step_member { s(:following, val[0], val[2]) }
  #
  #   # x ~ y
  #   | step_member T_FOLLOWING_DIRECT step_member
  #     {
  #       s(:following_direct, val[0], val[2])
  #     }
  #   ;
  #
  # pseudo_class
  #   # :root
  #   : pseudo_name { s(:pseudo, nil, val[0]) }
  #
  #   # x:root
  #   | step_member pseudo_name { s(:pseudo, val[0], val[1]) }
  #
  #   # :nth-child(2)
  #   | pseudo_name pseudo_args { s(:pseudo, nil, val[0], val[1]) }
  #
  #   # x:nth-child(2)
  #   | step_member pseudo_name pseudo_args { s(:pseudo, val[0], val[1], val[2]) }
  #   ;
  #
  # pseudo_name
  #   : T_COLON T_IDENT { val[1] }
  #   ;
  #
  # pseudo_args
  #   : T_LPAREN pseudo_arg T_RPAREN { val[1] }
  #   ;
  #
  # pseudo_arg
  #   : integer
  #   | odd
  #   | even
  #   | nth
  #   | node_test
  #   ;
  #
  # odd
  #   : T_ODD { s(:odd) }
  #   ;
  #
  # even
  #   : T_EVEN { s(:even) }
  #   ;
  #
  # nth
  #   : T_NTH                 { s(:nth) }
  #   | T_MINUS T_NTH         { s(:nth) }
  #   | integer T_NTH         { s(:nth, val[0]) }
  #   | integer T_NTH integer { s(:nth, val[0], val[2]) }
  #   ;
  #
  # string
  #   : T_STRING { s(:string, val[0]) }
  #   ;
  #
  # integer
  #  : T_INT { s(:int, val[0].to_i) }
  #  ;
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
