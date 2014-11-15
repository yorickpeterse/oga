##
# AST parser for CSS expressions.
#
class Oga::CSS::Parser

token T_IDENT T_PIPE T_LBRACK T_RBRACK T_COLON T_SPACE T_LPAREN T_RPAREN T_MINUS
token T_EQ T_SPACE_IN T_STARTS_WITH T_ENDS_WITH T_IN T_HYPHEN_IN
token T_GREATER T_TILDE T_PLUS
token T_NTH T_INT T_STRING T_ODD T_EVEN T_DOT T_HASH

options no_result_var

prechigh
  left T_COLON T_HASH T_DOT
  left T_GREATER T_TILDE T_PLUS
preclow

rule
  css
    : selectors  { val[0] }
    | /* none */ { nil }
    ;

  selectors
    : selector
      {
        # a single "+ y" selector
        if val[0].is_a?(Array)
          return s(:path, *val[0])
        else
          return val[0]
        end
      }
    | selectors_ { s(:path, *val[0].flatten) }
    ;

  selectors_
    : selectors_ T_SPACE selector { val[0] << val[2] }
    | selector T_SPACE selector   { [val[0], val[2]] }
    ;

  selector
    # .foo, :bar, etc
    : predicates
      {
        s(:predicate, s(:axis, 'descendant', on_test(nil, '*')), val[0])
      }

    # foo
    | descendant_or_self

    # foo.bar
    | descendant_or_self predicates { s(:predicate, val[0], val[1]) }

    # > foo
    | axis

    # > foo.bar
    | axis predicates { s(:predicate, val[0], val[1]) }
    ;

  descendant_or_self
    : node_test { s(:axis, 'descendant', val[0]) }
    ;

  axis
    # > foo
    : T_GREATER axis_selector
      {
        s(:axis, 'child', val[1])
      }

    # ~ foo
    | T_TILDE axis_selector
      {
        s(:axis, 'following-sibling', val[1])
      }

    # + foo
    | T_PLUS axis_selector
      {
        [
          s(
            :predicate,
            s(:axis, 'following-sibling', on_test(nil, '*')),
            s(:int, 1)
          ),
          s(:axis, 'self', val[1])
        ]
      }
    ;

  axis_selector
    | node_test
    | axis
    ;

  node_test
    # foo
    : node_name { on_test(*val[0]) }
    ;

  node_name
    # foo
    : T_IDENT { [nil, val[0]] }

    # ns|foo
    | T_IDENT T_PIPE T_IDENT { [val[0], val[2]] }
    ;

  predicates
    : predicates predicate { s(:and, val[0], val[1]) }
    | predicate
    ;

  predicate
    : class
    | id
    | pseudo_class
    | attribute_predicate
    ;

  attribute_predicate
    : T_LBRACK attribute_predicate_members T_RBRACK { val[1] }
    ;

  attribute_predicate_members
    : attribute
    | operator
    ;

  attribute
    : node_name { s(:axis, 'attribute', on_test(*val[0])) }
    ;

  # The AST of these operators is mostly based on what
  # `Nokogiri::CSS.xpath_for('...')` returns.
  operator
    # a="b"
    : attribute T_EQ string
      {
        s(:eq, val[0], val[2])
      }

    # a~="b"
    | attribute T_SPACE_IN string
      {
        s(
          :call,
          'contains',
          s(:call, 'concat', s(:string, ' '), val[0], s(:string, ' ')),
          s(:call, 'concat', s(:string, ' '), val[2], s(:string, ' '))
        )
      }

    # a^="b"
    | attribute T_STARTS_WITH string
      {
        s(:call, 'starts-with', val[0], val[2])
      }

    # a$="b"
    | attribute T_ENDS_WITH string
      {
        s(
          :eq,
          s(
            :call,
            'substring',
            val[0],
            s(
              :add,
              s(
                :sub,
                s(:call, 'string-length', val[0]),
                s(:call, 'string-length', val[2])
              ),
              s(:int, 1)
            ),
            s(:call, 'string-length', val[2])
          ),
          val[2]
        )
      }

    # a*="b"
    | attribute T_IN string
      {
        s(:call, 'contains', val[0], val[2])
      }

    # a|="b"
    | attribute T_HYPHEN_IN string
      {
        s(
          :or,
          s(:eq, val[0], val[2]),
          s(
            :call,
            'starts-with',
            val[0],
            s(:call, 'concat', val[2], s(:string, '-'))
          )
        )
      }
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
    : pseudo_name { on_pseudo_class(val[0]) }

    # :nth-child(2)
    | pseudo_name pseudo_args { on_pseudo_class(val[0], val[1]) }
    ;

  pseudo_name
    : T_COLON T_IDENT { val[1] }
    ;

  pseudo_args
    : T_LPAREN pseudo_arg T_RPAREN { val[1] }
    ;

  pseudo_arg
    : integer
    | odd
    | even
    | nth
    | selector
    ;

  string
    : T_STRING { s(:string, val[0]) }
    ;

  integer
    : T_INT { s(:int, val[0].to_i) }
    ;

  # These AST nodes are _not_ the final AST nodes. Instead they are used by
  # on_pseudo_class_nth_child() to determine what the final AST should be.

  nth
    # n
    : T_NTH { s(:nth, s(:int, 1)) }

    # n+2
    | T_NTH integer { s(:nth, s(:int, 1), val[1]) }

    # -n
    | T_MINUS T_NTH { s(:nth, s(:int, 1)) }

    # -n+2, -n-2
    | T_MINUS T_NTH integer { s(:nth, s(:int, -1), val[2]) }

    # 2n
    | integer T_NTH { s(:nth, val[0]) }

    # 2n+1, 2n-1
    | integer T_NTH integer
      {
        a = val[0]
        b = val[2]

        # 2n-1 gets turned into 2n+1
        if b.children[0] < 0
          b = s(:int, a.children[0] - (b.children[0] % a.children[0]))
        end

        s(:nth, a, b)
      }
    ;

  odd
    : T_ODD { s(:nth, s(:int, 2), s(:int, 1)) }
    ;

  even
    : T_EVEN { s(:nth, s(:int, 2)) }
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
  # Resets the internal state of the parser.
  #
  def reset
    @current_element = nil
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
  # Returns the node test for the current element.
  #
  # @return [AST::Node]
  #
  def current_element
    return @current_element ||= s(:test, nil, '*')
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
    reset

    ast = yyparse(self, :yield_next_token)

    return ast
  end

  ##
  # Generates the AST for a node test.
  #
  # @param [String] namespace
  # @param [String] name
  # @return [AST::Node]
  #
  def on_test(namespace, name)
    @current_element = s(:test, namespace, name)

    return @current_element
  end

  ##
  # @param [String] name
  # @param [AST::Node] arg
  # @return [AST::Node]
  #
  def on_pseudo_class(name, arg = nil)
    handler = "on_pseudo_class_#{name.gsub('-', '_')}"

    return arg ? send(handler, arg) : send(handler)
  end

  ##
  # Generates the AST for the `root` pseudo class.
  #
  # @return [AST::Node]
  #
  def on_pseudo_class_root
    return s(:call, 'not', s(:axis, 'parent', s(:test, nil, '*')))
  end

  ##
  # Generates the AST for the `nth-child` pseudo class.
  #
  # @param [AST::Node] arg
  # @return [AST::Node]
  #
  def on_pseudo_class_nth_child(arg)
    return generate_nth_child('preceding-sibling', arg)
  end

  ##
  # Generates the AST for the `nth-last-child` pseudo class.
  #
  # @param [AST::Node] arg
  # @return [AST::Node]
  #
  def on_pseudo_class_nth_last_child(arg)
    return generate_nth_child('following-sibling', arg)
  end

  ##
  # @param [String] count_axis
  # @param [AST::Node] arg
  # @return [AST::Node]
  #
  def generate_nth_child(count_axis, arg)
    count_call = s(:call, 'count', s(:axis, count_axis, s(:test, nil, '*')))

   # literal 2, 4, etc
    if int_node?(arg)
      node = s(:eq, count_call, s(:int, arg.children[0] - 1))
    else
      step, offset = *arg
      before_count = s(:add, count_call, s(:int, 1))
      compare      = step_comparison(step)

      # 2n+2, 2n-4, etc
      if offset
        mod_val = step_modulo_value(step)
        node    = s(
          :and,
          s(compare, before_count, offset),
          s(:eq, s(:mod, s(:sub, before_count, offset), mod_val), s(:int, 0))
        )

      # 2n, n, -2n
      else
        node = s(:eq, s(:mod, before_count, step), s(:int, 0))
      end
    end

    return node
  end

  ##
  # Generates the AST for the `nth-of-type` pseudo class.
  #
  # @param [AST::Node] arg
  # @return [AST::Node]
  #
  def on_pseudo_class_nth_of_type(arg)
    position_node = s(:call, 'position')

    return generate_nth_of_type(arg, position_node)
  end

  ##
  # Generates the AST for the `nth-last-of-type` pseudo class.
  #
  # @param [AST::Node] arg
  # @return [AST::Node]
  #
  def on_pseudo_class_nth_last_of_type(arg)
    position_node = s(
      :add,
      s(:sub, s(:call, 'last'), s(:call, 'position')),
      s(:int, 1)
    )

    return generate_nth_of_type(arg, position_node)
  end

  ##
  # @param [AST::Node] arg
  # @param [AST::Node] position_node
  # @return [AST::Node]
  #
  def generate_nth_of_type(arg, position_node)
    # literal 2, 4, etc
    if int_node?(arg)
      node = s(:eq, position_node, arg)
    else
      step, offset = *arg
      compare      = step_comparison(step)

      # 2n+2, 2n-4, etc
      if offset
        mod_val = step_modulo_value(step)
        node    = s(
          :and,
          s(compare, position_node, offset),
          s(:eq, s(:mod, s(:sub, position_node, offset), mod_val), s(:int, 0))
        )

      # 2n, n, -2n
      else
        node = s(:eq, s(:mod, position_node, step), s(:int, 0))
      end
    end

    return node
  end

  ##
  # Generates the AST for the `:first-child` selector.
  #
  # @return [AST::Node]
  #
  def on_pseudo_class_first_child
    return s(
      :eq,
      s(:call, 'count', s(:axis, 'preceding-sibling', s(:test, nil, '*'))),
      s(:int, 0)
    )
  end

  ##
  # Generates the AST for the `:last-child` selector.
  #
  # @return [AST::Node]
  #
  def on_pseudo_class_last_child
    return s(
      :eq,
      s(:call, 'count', s(:axis, 'following-sibling', s(:test, nil, '*'))),
      s(:int, 0)
    )
  end

  ##
  # Generates the AST for the `:first-of-type` selector.
  #
  # @return [AST::Node]
  #
  def on_pseudo_class_first_of_type
    return s(
      :eq,
      s(:call, 'count', s(:axis, 'preceding-sibling', current_element)),
      s(:int, 0)
    )
  end

  ##
  # Generates the AST for the `:last-of-type` selector.
  #
  # @return [AST::Node]
  #
  def on_pseudo_class_last_of_type
    return s(
      :eq,
      s(:call, 'count', s(:axis, 'following-sibling', current_element)),
      s(:int, 0)
    )
  end

  ##
  # Generates the AST for the `:only-child` selector.
  #
  # @return [AST::Node]
  #
  def on_pseudo_class_only_child
    return s(:and, on_pseudo_class_first_child, on_pseudo_class_last_child)
  end

  ##
  # Generates the AST for the `:only-of-type` selector.
  #
  # @return [AST::Node]
  #
  def on_pseudo_class_only_of_type
    return s(:and, on_pseudo_class_first_of_type, on_pseudo_class_last_of_type)
  end

  ##
  # Generates the AST for the `:empty` selector.
  #
  # @return [AST::Node]
  #
  def on_pseudo_class_empty
    return s(:call, 'not', s(:axis, 'child', s(:type_test, 'node')))
  end

  private

  ##
  # @param [AST::Node] node
  # @return [TrueClass|FalseClass]
  #
  def int_node?(node)
    return node.type == :int
  end

  ##
  # @param [AST::Node] node
  # @return [TrueClass|FalseClass]
  #
  def non_positive_number?(node)
    return node.children[0] <= 0
  end

  ##
  # @param [AST::Node] node
  # @return [Symbol]
  #
  def step_comparison(node)
    return node.children[0] >= 0 ? :gte : :lte
  end

  ##
  # @param [AST::Node] step
  # @return [AST::Node]
  #
  def step_modulo_value(step)
    # -2n
    if step and non_positive_number?(step)
      mod_val = s(:int, -step.children[0])

    # 2n
    elsif step
      mod_val = step

    else
      mod_val = s(:int, 1)
    end

    return mod_val
  end

# vim: set ft=racc:
