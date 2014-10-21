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
preclow

rule
  css
    : selectors  { val[0] }
    | /* none */ { nil }
    ;

  selectors
    : selector
    | selectors_ { s(:path, *val[0]) }
    ;

  selectors_
    : selectors_ T_SPACE selector { val[0] << val[2] }
    | selector T_SPACE selector   { [val[0], val[2]] }
    ;

  selector
    : descendant_or_self
    | axis
    ;

  descendant_or_self
    : node_test { s(:axis, 'descendant-or-self', val[0]) }
    ;

  axis
    : T_CHILD axis_selector             { s(:axis, 'child', val[1]) }
    | T_FOLLOWING axis_selector         { s(:axis, 'following', val[1]) }
    | T_FOLLOWING_DIRECT axis_selector  { s(:axis, 'following-direct', val[1]) }
    ;

  axis_selector
    | node_test
    | axis
    ;

  node_test
    # foo
    : node_name
      {
        s(:test, *val[0])
      }

    # .foo, :root, etc
    | predicates
      {
        s(:test, nil, '*', val[0])
      }

    # foo.bar
    | node_name predicates
      {
        s(:test, *val[0], val[1])
      }

    # foo[bar]
    | node_name attribute_predicate
      {
        s(:test, *val[0], val[1])
      }

    # foo[bar].baz
    | node_name attribute_predicate predicates
      {
        s(:test, *val[0], s(:and, val[1], val[2]))
      }
    ;

  node_name
    # foo
    : T_IDENT { [nil, val[0]] }

    # ns|foo
    | T_IDENT T_PIPE T_IDENT { [val[0], val[2]] }

    # |foo
    | T_PIPE T_IDENT { [nil, val[1]] }
    ;

  predicates
    : predicates predicate { s(:and, val[0], val[1]) }
    | predicate
    ;

  predicate
    : class
    | id
    | pseudo_class
    ;

  attribute_predicate
    : T_LBRACK attribute_predicate_members T_RBRACK { val[1] }
    ;

  attribute_predicate_members
    : attribute
    | operator
    ;

  attribute
    : node_name { s(:axis, 'attribute', s(:test, *val[0])) }
    ;

  operator
    : attribute T_EQ string { s(:eq, val[0], val[2]) }
    ;

  class
    : T_DOT T_IDENT
      {
        axis = s(:axis, 'attribute', s(:test, nil, 'class'))

        s(
          :call,
          'contains',
          s(:call, 'concat', s(:string, ' '), axis, s(:string, ' ')),
          s(:string, " #{val[1]} ")
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

  pseudo_class
    # :root
    : pseudo_name { s(:pseudo, nil, val[0]) }

    # :nth-child(2)
    | pseudo_name pseudo_args { s(:pseudo, nil, val[0], val[1]) }
    ;

  pseudo_name
    : T_COLON T_IDENT { val[1] }
    ;

  pseudo_args
    : T_LPAREN pseudo_arg T_RPAREN { val[1] }
    ;

  pseudo_arg
    : integer
    #| odd
    #| even
    #| nth
    | selector
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
