module Oga
  module XPath
    ##
    # The Evaluator class evaluates XPath expressions, either as a String or an
    # AST of {Oga::XPath::Node} instances.
    #
    # ## Thread Safety
    #
    # This class is not thread-safe, you can not share the same instance between
    # multiple threads. This is due to the use of an internal stack (see below
    # for more information). It is however perfectly fine to use multiple
    # separated instances as this class does not use a thread global state.
    #
    # ## Node Stack
    #
    # This class uses an internal stack of XML nodes. This stack is used for
    # certain XPath functions that require access to the current node being
    # processed in a predicate. An example of such a function is `position()`.
    #
    # An alternative to a stack would be to pass the current node as arguments
    # to the various `on_*` methods. The problematic part of this approach is
    # that it requires every method to take and pass along the argument. It's
    # far too easy to make mistakes in such a setup and as such I've chosen to
    # use an internal stack instead.
    #
    # See {#with_node} and {#current_node} for more information.
    #
    # ## Set Indices
    #
    # XPath node sets start at index 1 instead of index 0. In other words, if
    # you want to access the first node in a set you have to use index 1, not 0.
    # Certain methods such as {#on_call_last} and {#on_call_position} take care
    # of converting indices from Ruby to XPath.
    #
    # ## Number Types
    #
    # The XPath specification states that all numbers produced by an expression
    # should be returned as double-precision 64bit IEEE 754 floating point
    # numbers. For example, the return value of `position()` should be a float
    # (e.g. "1.0", not "1").
    #
    # Oga takes care internally of converting numbers to integers and/or floats
    # where needed. The output types however will always be floats.
    #
    # For more information on the specification, see
    # <http://www.w3.org/TR/xpath/#numbers>.
    #
    class Evaluator
      ##
      # @param [Oga::XML::Document|Oga::XML::Node] document
      #
      def initialize(document)
        @document = document
        @nodes    = []
      end

      ##
      # Evaluates an XPath expression as a String.
      #
      # @example
      #  evaluator = Oga::XPath::Evaluator.new(document)
      #
      #  evaluator.evaluate('//a')
      #
      # @param [String] string An XPath expression as a String.
      # @return [Oga::XML::Node]
      #
      def evaluate(string)
        ast     = Parser.new(string).parse
        context = XML::NodeSet.new([@document])

        return process(ast, context)
      end

      ##
      # Processes an XPath node by dispatching it and the given context to a
      # dedicated handler method. Handler methods are called "on_X" where "X" is
      # the node type.
      #
      # @param [Oga::XPath::Node] ast_node The XPath AST node to process.
      # @param [Oga::XML::NodeSet] context The context (a set of nodes) to
      #  evaluate an expression in.
      #
      # @return [Oga::XML::NodeSet]
      #
      def process(ast_node, context)
        handler = "on_#{ast_node.type}"

        return send(handler, ast_node, context)
      end

      ##
      # Processes an absolute XPath expression such as `/foo`.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_absolute_path(ast_node, context)
        if @document.respond_to?(:root_node)
          context = XML::NodeSet.new([@document.root_node])
        else
          context = XML::NodeSet.new([@document])
        end

        return on_path(ast_node, context)
      end

      ##
      # Processes a relative XPath expression such as `foo`.
      #
      # Paths are evaluated using a "short-circuit" mechanism similar to Ruby's
      # `&&` / `and` operator. Whenever a path results in an empty node set the
      # evaluation is aborted immediately.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_path(ast_node, context)
        nodes = XML::NodeSet.new

        ast_node.children.each do |test|
          nodes = process(test, context)

          if nodes.empty?
            break
          else
            context = nodes
          end
        end

        return nodes
      end

      ##
      # Processes a node test. Nodes are compared using {#node_matches?} so see
      # that method for more information on that matching logic.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_test(ast_node, context)
        nodes     = XML::NodeSet.new
        predicate = ast_node.children[2]

        context.each do |xml_node|
          nodes << xml_node if node_matches?(xml_node, ast_node)
        end

        # Filter the nodes based on the predicate.
        if predicate
          new_nodes = XML::NodeSet.new

          nodes.each_with_index do |current, index|
            xpath_index = index + 1
            retval      = with_node(current) { process(predicate, nodes) }

            # Numeric values are used as node set indexes.
            if retval.is_a?(Numeric)
              new_nodes << current if retval.to_i == xpath_index

            # Node sets, strings, booleans, etc
            elsif retval
              # Empty strings and node sets evaluate to false.
              if retval.respond_to?(:empty?) and retval.empty?
                next
              end

              new_nodes << current
            end
          end

          nodes = new_nodes
        end

        return nodes
      end

      ##
      # Dispatches the processing of axes to dedicated methods. This works
      # similar to {#process} except the handler names are "on_axis_X" with "X"
      # being the axis name.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis(ast_node, context)
        name, test = *ast_node

        handler = name.gsub('-', '_')

        return send("on_axis_#{handler}", test, context)
      end

      ##
      # Processes the `ancestor` axis. This axis walks through the entire
      # ancestor chain until a matching node is found.
      #
      # Evaluation happens using a "short-circuit" mechanism. The moment a
      # matching node is found it is returned immediately.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_ancestor(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |xml_node|
          while has_parent?(xml_node)
            xml_node = xml_node.parent

            if node_matches?(xml_node, ast_node)
              nodes << xml_node
              break
            end
          end
        end

        return nodes
      end

      ##
      # Processes the `ancestor-or-self` axis.
      #
      # @see [#on_axis_ancestor]
      #
      def on_axis_ancestor_or_self(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |xml_node|
          while has_parent?(xml_node)
            if node_matches?(xml_node, ast_node)
              nodes << xml_node
              break
            end

            xml_node = xml_node.parent
          end
        end

        return nodes
      end

      ##
      # Processes the `attribute` axis. The node test is performed against all
      # the attributes of the nodes in the current context.
      #
      # Evaluation of the nodes continues until the node set has been exhausted
      # (unlike some other methods which return the moment they find a matching
      # node).
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_attribute(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |xml_node|
          next unless xml_node.is_a?(XML::Element)

          nodes += on_test(ast_node, xml_node.attributes)
        end

        return nodes
      end

      ##
      # Evaluates the `child` axis. This simply delegates work to {#on_test}
      # or {#on_node_type}.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_child(ast_node, context)
        return process(ast_node, child_nodes(context))
      end

      ##
      # Evaluates the `descendant` axis. This method processes child nodes until
      # the very end of the tree, no "short-circuiting" mechanism is used.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_descendant(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |context_node|
          nodes += on_test(ast_node, context_node.children)
          nodes += on_axis_descendant(ast_node, context_node.children)
        end

        return nodes
      end

      ##
      # Evaluates the `descendant-or-self` axis.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_descendant_or_self(ast_node, context)
        return on_test(ast_node, context) +
          on_axis_descendant(ast_node, context)
      end

      ##
      # Evaluates the `following` axis.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_following(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |context_node|
          check = false

          @document.each_node do |doc_node|
            # Skip child nodes of the current context node, compare all
            # following nodes.
            if doc_node == context_node
              check = true
              throw :skip_children
            end

            next unless check

            nodes << doc_node if node_matches?(doc_node, ast_node)
          end
        end

        return nodes
      end

      ##
      # Evaluates the `following-sibling` axis.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_following_sibling(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |context_node|
          check  = false
          parent = has_parent?(context_node) ? context_node.parent : nil

          @document.each_node do |doc_node|
            # Skip child nodes of the current context node, compare all
            # following nodes.
            if doc_node == context_node
              check = true
              throw :skip_children
            end

            if !check or parent != doc_node.parent
              next
            end

            if node_matches?(doc_node, ast_node)
              nodes << doc_node

              throw :skip_children
            end
          end
        end

        return nodes
      end

      ##
      # Evaluates the `parent` axis.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_parent(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |context_node|
          next unless has_parent?(context_node)

          parent = context_node.parent

          nodes << parent if node_matches?(parent, ast_node)
        end

        return nodes
      end

      ##
      # Evaluates the `preceding` axis.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_preceding(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |context_node|
          check = true

          @document.each_node do |doc_node|
            # Test everything *until* we hit the current context node.
            if doc_node == context_node
              break
            elsif node_matches?(doc_node, ast_node)
              nodes << doc_node
            end
          end
        end

        return nodes
      end

      ##
      # Evaluates the `preceding-sibling` axis.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_preceding_sibling(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |context_node|
          check  = true
          parent = has_parent?(context_node) ? context_node.parent : nil

          @document.each_node do |doc_node|
            # Test everything *until* we hit the current context node.
            if doc_node == context_node
              break
            elsif doc_node.parent == parent and node_matches?(doc_node, ast_node)
              nodes << doc_node
            end
          end
        end

        return nodes
      end

      ##
      # Evaluates the `self` axis.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_self(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |context_node|
          nodes << context_node if node_matches?(context_node, ast_node)
        end

        return nodes
      end

      ##
      # Evaluates the `namespace` axis.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_namespace(ast_node, context)
        nodes = XML::NodeSet.new
        name  = ast_node.children[1]

        context.each do |context_node|
          next unless context_node.respond_to?(:available_namespaces)

          context_node.available_namespaces.each do |_, namespace|
            if namespace.name == name or name == '*'
              nodes << namespace
            end
          end
        end

        return nodes
      end

      ##
      # Dispatches node type matching to dedicated handlers.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_type_test(ast_node, context)
        name, test = *ast_node

        handler = name.gsub('-', '_')

        return send("on_type_test_#{handler}", test, context)
      end

      ##
      # Processes the `node` type matcher. This matcher matches all node types.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_type_test_node(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |node|
          nodes << node if node.is_a?(XML::Node)
        end

        return nodes
      end

      ##
      # Processes the `text()` type test. This matches only text nodes.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_type_test_text(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |node|
          nodes << node if node.is_a?(XML::Text)
        end

        return nodes
      end

      ##
      # Processes the `comment()` type test. This matches only comment nodes.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_type_test_comment(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |node|
          nodes << node if node.is_a?(XML::Comment)
        end

        return nodes
      end

      ##
      # Processes the `processing-instruction()` type test. This matches only
      # processing-instruction nodes.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_type_test_processing_instruction(ast_node, context)
        nodes = XML::NodeSet.new

        context.each do |node|
          nodes << node if node.is_a?(XML::ProcessingInstruction)
        end

        return nodes
      end

      ##
      # Processes the pipe (`|`) operator. This operator creates a union of two
      # sets.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_pipe(ast_node, context)
        left, right = *ast_node

        return process(left, context) + process(right, context)
      end

      ##
      # Processes the `and` operator.
      #
      # This operator returns true if both the left and right expression
      # evaluate to `true`. If the first expression evaluates to `false` the
      # right expression is ignored.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [TrueClass|FalseClass]
      #
      def on_and(ast_node, context)
        left, right = *ast_node

        return on_call_boolean(context, left) && on_call_boolean(context, right)
      end

      ##
      # Processes the `or` operator.
      #
      # This operator returns `true` if one of the expressions evaluates to
      # true, otherwise false is returned. If the first expression evaluates to
      # `true` the second expression is ignored.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [TrueClass|FalseClass]
      #
      def on_or(ast_node, context)
        left, right = *ast_node

        return on_call_boolean(context, left) || on_call_boolean(context, right)
      end

      ##
      # Processes the `+` operator.
      #
      # This operator converts the left and right expressions to numbers and
      # adds them together.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_add(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) + on_call_number(context, right)
      end

      ##
      # Processes the `div` operator.
      #
      # This operator converts the left and right expressions to numbers and
      # divides the left number with the right number.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_div(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) / on_call_number(context, right)
      end

      ##
      # Processes the `mod` operator.
      #
      # This operator converts the left and right expressions to numbers and
      # returns the modulo of the two numbers.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_mod(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) % on_call_number(context, right)
      end

      ##
      # Processes the `*` operator.
      #
      # This operator converts the left and right expressions to numbers and
      # multiplies the left number with the right number.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_mul(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) * on_call_number(context, right)
      end

      ##
      # Processes the `-` operator.
      #
      # This operator converts the left and right expressions to numbers and
      # subtracts the right number of the left number.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_sub(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) - on_call_number(context, right)
      end

      ##
      # Processes the `=` operator.
      #
      # This operator evaluates the expression on the left and right and returns
      # `true` if they are equal. This operator can be used to compare strings,
      # numbers and node sets. When using node sets the text of the set is
      # compared instead of the nodes themselves. That is, nodes with different
      # names but the same text are considered to be equal.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [TrueClass|FalseClass]
      #
      def on_eq(ast_node, context)
        left  = process(ast_node.children[0], context)
        right = process(ast_node.children[1], context)

        if left.is_a?(XML::NodeSet)
          left = first_node_text(left)
        end

        if right.is_a?(XML::NodeSet)
          right = first_node_text(right)
        end

        if left.is_a?(Numeric) and !right.is_a?(Numeric)
          right = to_float(right)
        end

        if left.is_a?(String) and !right.is_a?(String)
          right = to_string(right)
        end

        return left == right
      end

      ##
      # Processes the `!=` operator.
      #
      # This operator does the exact opposite of the `=` operator. See {#on_eq}
      # for more information.
      #
      # @see [#on_eq]
      #
      def on_neq(ast_node, context)
        return !on_eq(ast_node, context)
      end

      ##
      # Processes the `<` operator.
      #
      # This operator converts the left and right expression to a number and
      # returns `true` if the first number is lower than the second number.
      #
      # @param [Oga::XML::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [TrueClass|FalseClass]
      #
      def on_lt(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) < on_call_number(context, right)
      end

      ##
      # Processes the `>` operator.
      #
      # This operator converts the left and right expression to a number and
      # returns `true` if the first number is greater than the second number.
      #
      # @param [Oga::XML::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [TrueClass|FalseClass]
      #
      def on_gt(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) > on_call_number(context, right)
      end

      ##
      # Processes the `<=` operator.
      #
      # This operator converts the left and right expression to a number and
      # returns `true` if the first number is lower-than or equal to the second
      # number.
      #
      # @param [Oga::XML::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [TrueClass|FalseClass]
      #
      def on_lte(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) <= on_call_number(context, right)
      end

      ##
      # Processes the `>=` operator.
      #
      # This operator converts the left and right expression to a number and
      # returns `true` if the first number is greater-than or equal to the
      # second number.
      #
      # @param [Oga::XML::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [TrueClass|FalseClass]
      #
      def on_gte(ast_node, context)
        left, right = *ast_node

        return on_call_number(context, left) >= on_call_number(context, right)
      end

      ##
      # Delegates function calls to specific handlers.
      #
      # Handler functions take two arguments:
      #
      # 1. The context node set
      # 2. A variable list of XPath function arguments, passed as individual
      #    Ruby method arguments.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_call(ast_node, context)
        name, *args = *ast_node

        handler = name.gsub('-', '_')

        return send("on_call_#{handler}", context, *args)
      end

      ##
      # Processes the `last()` function call. This function call returns the
      # index of the last node in the current set.
      #
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_call_last(context)
        # XPath uses indexes 1 to N instead of 0 to N.
        return context.length.to_f
      end

      ##
      # Processes the `position()` function call. This function returns the
      # position of the current node in the current node set.
      #
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_call_position(context)
        index = context.index(current_node) + 1

        return index.to_f
      end

      ##
      # Processes the `count()` function call. This function counts the amount
      # of nodes in `expression` and returns the result as a float.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Float]
      #
      def on_call_count(context, expression)
        retval = process(expression, context)

        unless retval.is_a?(XML::NodeSet)
          raise TypeError, 'count() can only operate on NodeSet instances'
        end

        return retval.length.to_f
      end

      ##
      # Processes the `id()` function call.
      #
      # The XPath specification states that this function's behaviour should be
      # controlled by a DTD. If a DTD were to specify that the ID attribute for
      # a certain element would be "foo" then this function should use said
      # attribute.
      #
      # Oga does not support DTD parsing/evaluation and as such always uses the
      # "id" attribute.
      #
      # This function searches the entire document for a matching node,
      # regardless of the current position.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Oga::XML::NodeSet]
      #
      def on_call_id(context, expression)
        id    = process(expression, context)
        nodes = XML::NodeSet.new

        # Based on Nokogiri's/libxml behaviour it appears that when using a node
        # set the text of the set is used as the ID.
        id  = id.is_a?(XML::NodeSet) ? id.text : id.to_s
        ids = id.split(' ')

        @document.each_node do |node|
          next unless node.is_a?(XML::Element)

          attr = node.attribute('id')

          if attr and ids.include?(attr.value)
            nodes << node
          end
        end

        return nodes
      end

      ##
      # Processes the `local-name()` function call.
      #
      # This function call returns the name of one of the following:
      #
      # * The current context node (if any)
      # * The first node in the supplied node set
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Oga::XML::NodeSet]
      #
      def on_call_local_name(context, expression = nil)
        node = function_node(context, expression)

        return node.respond_to?(:name) ? node.name : ''
      end

      ##
      # Processes the `name()` function call.
      #
      # This function call is similar to `local-name()` (see
      # {#on_call_local_name}) except that it includes the namespace name if
      # present.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Oga::XML::NodeSet]
      #
      def on_call_name(context, expression = nil)
        node = function_node(context, expression)

        if node.respond_to?(:name) and node.respond_to?(:namespace)
          if node.namespace
            return "#{node.namespace.name}:#{node.name}"
          else
            return node.name
          end
        else
          return ''
        end
      end

      ##
      # Processes the `namespace-uri()` function call.
      #
      # This function call returns the namespace URI of one of the following:
      #
      # * The current context node (if any)
      # * The first node in the supplied node set
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Oga::XML::NodeSet]
      #
      def on_call_namespace_uri(context, expression = nil)
        node = function_node(context, expression)

        if node.respond_to?(:namespace) and node.namespace
          return node.namespace.uri
        else
          return ''
        end
      end

      ##
      # Evaluates the `string()` function call.
      #
      # This function call converts the given argument *or* the current context
      # node to a string. If a node set is given then only the first node is
      # converted to a string.
      #
      # @example
      #  string(10) # => "10"
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [String]
      #
      def on_call_string(context, expression = nil)
        if expression
          convert = process(expression, context)

          if convert.is_a?(XML::NodeSet)
            convert = convert[0]
          end
        else
          convert = current_node
        end

        if convert.respond_to?(:text)
          return convert.text
        else
          return to_string(convert)
        end
      end

      ##
      # Evaluates the `number()` function call.
      #
      # This function call converts its first argument *or* the current context
      # node to a number, similar to the `string()` function.
      #
      # @example
      #  number("10") # => 10.0
      #
      # @see [#on_call_string]
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Float]
      #
      def on_call_number(context, expression = nil)
        convert = nil

        if expression
          exp_retval = process(expression, context)

          if exp_retval.is_a?(XML::NodeSet)
            convert = first_node_text(exp_retval)

          elsif exp_retval == true
            convert = 1.0

          elsif exp_retval == false
            convert = 0.0

          elsif exp_retval
            convert = exp_retval
          end
        else
          convert = current_node.text
        end

        return to_float(convert)
      end

      ##
      # Processes the `concat()` function call.
      #
      # This function call converts its arguments to strings and concatenates
      # them. In case of node sets the text of the set is used.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] first
      # @param [Oga::XPath::Node] second
      # @param [Array<Oga::XPath::Node>] rest
      #
      def on_call_concat(context, first, second, *rest)
        args   = [first, second] + rest
        retval = ''

        args.each do |arg|
          retval << on_call_string(context, arg)
        end

        return retval
      end

      ##
      # Processes the `starts-with()` function call.
      #
      # This function call returns `true` if the string in the 1st argument
      # starts with the string in the 2nd argument. Node sets can also be used.
      #
      # @example
      #  starts-with("hello world", "hello") # => true
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] haystack The string to search.
      # @param [Oga::XPath::Node] needle The string to search for.
      # @return [TrueClass|FalseClass]
      #
      def on_call_starts_with(context, haystack, needle)
        haystack_str = on_call_string(context, haystack)
        needle_str   = on_call_string(context, needle)

        # https://github.com/jruby/jruby/issues/1923
        return needle_str.empty? || haystack_str.start_with?(needle_str)
      end

      ##
      # Processes the `contains()` function call.
      #
      # This function call returns `true` if the string in the 1st argument
      # contains the string in the 2nd argument. Node sets can also be used.
      #
      # @example
      #  contains("hello world", "o w") # => true
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] haystack The string to search.
      # @param [Oga::XPath::Node] needle The string to search for.
      # @return [String]
      #
      def on_call_contains(context, haystack, needle)
        haystack_str = on_call_string(context, haystack)
        needle_str   = on_call_string(context, needle)

        return haystack_str.include?(needle_str)
      end

      ##
      # Processes the `substring-before()` function call.
      #
      # This function call returns the substring of the 1st argument that occurs
      # before the string given in the 2nd argument. For example:
      #
      #     substring-before("2014-08-25", "-")
      #
      # This would return "2014" as it occurs before the first "-".
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] haystack The string to search.
      # @param [Oga::XPath::Node] needle The string to search for.
      # @return [String]
      #
      def on_call_substring_before(context, haystack, needle)
        haystack_str = on_call_string(context, haystack)
        needle_str   = on_call_string(context, needle)

        before, sep, after = haystack_str.partition(needle_str)

        return sep.empty? ? sep : before
      end

      ##
      # Processes the `substring-after()` function call.
      #
      # This function call returns the substring of the 1st argument that occurs
      # after the string given in the 2nd argument. For example:
      #
      #     substring-before("2014-08-25", "-")
      #
      # This would return "08-25" as it occurs after the first "-".
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] haystack The string to search.
      # @param [Oga::XPath::Node] needle The string to search for.
      # @return [String]
      #
      def on_call_substring_after(context, haystack, needle)
        haystack_str = on_call_string(context, haystack)
        needle_str   = on_call_string(context, needle)

        before, sep, after = haystack_str.partition(needle_str)

        return sep.empty? ? sep : after
      end

      ##
      # Processes the `substring()` function call.
      #
      # This function call returns the substring of the 1st argument, starting
      # at the position given in the 2nd argument. If the third argument is
      # given it is used as the length for the substring, otherwise the string
      # is consumed until the end.
      #
      # XPath string indexes start from position 1, not position 0.
      #
      # @example Using a literal string
      #  substring("foo", 2) # => "oo"
      #
      # @exxample Using a literal string with a custom length
      #  substring("foo", 1, 2) # => "fo"
      #
      # @example Using a node set
      #  substring(users/user/username, 5)
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] haystack
      # @param [Oga::XPath::Node] start
      # @param [Oga::XPath::Node] length
      # @return [String]
      #
      def on_call_substring(context, haystack, start, length = nil)
        haystack_str = on_call_string(context, haystack)
        start_index  = on_call_number(context, start).to_i - 1

        if length
          length_int = on_call_number(context, length).to_i - 1
          stop_index = start_index + length_int
        else
          stop_index = -1
        end

        return haystack_str[start_index..stop_index]
      end

      ##
      # Processes the `string-length()` function.
      #
      # This function returns the length of the string given in the 1st argument
      # *or* the current context node. If the expression is not a string it's
      # converted to a string using the `string()` function.
      #
      # @see [#on_call_string]
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Float]
      #
      def on_call_string_length(context, expression = nil)
        return on_call_string(context, expression).length.to_f
      end

      ##
      # Processes the `normalize-space()` function call.
      #
      # This function strips the 1st argument string *or* the current context
      # node of leading/trailing whitespace as well as replacing multiple
      # whitespace sequences with single spaces.
      #
      # @example
      #  normalize-space(" fo  o    ") # => "fo o"
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [String]
      #
      def on_call_normalize_space(context, expression = nil)
        str = on_call_string(context, expression)

        return str.strip.gsub(/\s+/, ' ')
      end

      ##
      # Processes the `translate()` function call.
      #
      # This function takes the string of the 1st argument and replaces all
      # characters of the 2nd argument with those specified in the 3rd argument.
      #
      # @example
      #  translate("bar", "abc", "ABC") # => "BAr"
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] input
      # @param [Oga::XPath::Node] find
      # @param [Oga::XPath::Node] replace
      # @return [String]
      #
      def on_call_translate(context, input, find, replace)
        input_str     = on_call_string(context, input)
        find_chars    = on_call_string(context, find).chars.to_a
        replace_chars = on_call_string(context, replace).chars.to_a
        replaced      = input_str

        find_chars.each_with_index do |char, index|
          replace_with = replace_chars[index] ? replace_chars[index] : ''
          replaced     = replaced.gsub(char, replace_with)
        end

        return replaced
      end

      ##
      # Processes the `boolean()` function call.
      #
      # This function converts the 1st argument to a boolean.
      #
      # The boolean `true` is returned for the following:
      #
      # * A non empty string
      # * A non empty node set
      # * A non zero number, either positive or negative
      #
      # The boolean `false` is returned for all other cases.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [TrueClass|FalseClass]
      #
      def on_call_boolean(context, expression)
        retval = process(expression, context)
        bool   = false

        if retval.is_a?(Numeric)
          bool = !retval.nan? && !retval.zero?
        elsif retval
          bool = !retval.respond_to?(:empty?) || !retval.empty?
        end

        return bool
      end

      ##
      # Processes the `not()` function call.
      #
      # This function converts the 1st argument to a boolean and returns the
      # opposite boolean value. For example, if the first argument results in
      # `true` then this function returns `false` instead.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [TrueClass|FalseClass]
      #
      def on_call_not(context, expression)
        return !on_call_boolean(context, expression)
      end

      ##
      # Processes the `true()` function call.
      #
      # This function simply returns the boolean `true`.
      #
      # @param [Oga::XPath::NodeSet] context
      # @return [TrueClass]
      #
      def on_call_true(context)
        return true
      end

      ##
      # Processes the `false()` function call.
      #
      # This function simply returns the boolean `false`.
      #
      # @param [Oga::XPath::NodeSet] context
      # @return [FalseClass]
      #
      def on_call_false(context)
        return false
      end

      ##
      # Processes the `lang()` function call.
      #
      # This function returns `true` if the current context node is in the given
      # language, `false` otherwise.
      #
      # The language is based on the value of the "xml:lang" attribute of either
      # the context node or an ancestor node (in case the context node has no
      # such attribute).
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] language
      # @return [TrueClass|FalseClass]
      #
      def on_call_lang(context, language)
        lang_str = on_call_string(context, language)
        node     = current_node

        while node.respond_to?(:attribute)
          found = node.attribute('xml:lang')

          return found.value == lang_str if found

          node = node.parent
        end

        return false
      end

      ##
      # Processes the `sum()` function call.
      #
      # This function call takes a node set, converts each node to a number and
      # then sums the values.
      #
      # As an example, take the following XML:
      #
      #     <root>
      #       <a>1</a>
      #       <b>2</b>
      #     </root>
      #
      # Using the expression `sum(root/*)` the return value would be `3.0`.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Float]
      #
      def on_call_sum(context, expression)
        nodes = process(expression, context)
        sum   = 0.0

        unless nodes.is_a?(XML::NodeSet)
          raise TypeError, 'sum() can only operate on NodeSet instances'
        end

        nodes.each do |node|
          sum += node.text.to_f
        end

        return sum
      end

      ##
      # Processes the `floor()` function call.
      #
      # This function call rounds the 1st argument down to the closest integer,
      # and then returns that number as a float.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Float]
      #
      def on_call_floor(context, expression)
        number = on_call_number(context, expression)

        return number.nan? ? number : number.floor.to_f
      end

      ##
      # Processes the `ceiling()` function call.
      #
      # This function call rounds the 1st argument up to the closest integer,
      # and then returns that number as a float.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Float]
      #
      def on_call_ceiling(context, expression)
        number = on_call_number(context, expression)

        return number.nan? ? number : number.ceil.to_f
      end

      ##
      # Processes the `round()` function call.
      #
      # This function call rounds the 1st argument to the closest integer, and
      # then returns that number as a float.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Float]
      #
      def on_call_round(context, expression)
        number = on_call_number(context, expression)

        return number.nan? ? number : number.round.to_f
      end

      ##
      # Processes an `(int)` node.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_int(ast_node, context)
        return ast_node.children[0].to_f
      end

      ##
      # Processes an `(float)` node.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_float(ast_node, context)
        return ast_node.children[0]
      end

      ##
      # Processes a `(string)` node.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [String]
      #
      def on_string(ast_node, context)
        return ast_node.children[0]
      end

      ##
      # Returns the node for a function call. This node is either the first node
      # in the supplied node set, or the first node in the current context.
      #
      # @param [Oga::XML::NodeSet] context
      # @param [Oga::XPath::Node] expression
      # @return [Oga::XML::Node]
      #
      def function_node(context, expression = nil)
        if expression
          node = process(expression, context)

          if node.is_a?(XML::NodeSet)
            node = node.first
          else
            raise TypeError, 'only node sets can be used as arguments'
          end
        else
          node = current_node
        end

        return node
      end

      ##
      # Returns the text of the first node in the node set, or an empty string
      # if the node set is empty.
      #
      # @param [Oga::XML::NodeSet] set
      # @return [String]
      #
      def first_node_text(set)
        return set[0].respond_to?(:text) ? set[0].text : ''
      end

      ##
      # Returns a node set containing all the child nodes of the given set of
      # nodes.
      #
      # @param [Oga::XML::NodeSet] nodes
      # @return [Oga::XML::NodeSet]
      #
      def child_nodes(nodes)
        children = XML::NodeSet.new

        nodes.each do |xml_node|
          children += xml_node.children
        end

        return children
      end

      ##
      # Checks if a given {Oga::XML::Node} instance matches a {Oga::XPath::Node}
      # instance.
      #
      # This method can use both "test" and "type-test" nodes. In case of
      # "type-test" nodes the procedure is as following:
      #
      # 1. Evaluate the expression
      # 2. If the return value is non empty return `true`, otherwise return
      #    `false`
      #
      # For "test" nodes the procedure is as following instead:
      #
      # 1. Match the name
      # 2. Match the namespace
      #
      # For both the name and namespace a wildcard (`*`) can be used.
      #
      # @param [Oga::XML::Node] xml_node
      # @param [Oga::XPath::Node] ast_node
      # @return [Oga::XML::NodeSet]
      #
      def node_matches?(xml_node, ast_node)
        ns, name = *ast_node

        if ast_node.type == :type_test
          return type_matches?(xml_node, ast_node)
        end

        # If only the name is given and is a wildcard then we'll also want to
        # match the namespace as a wildcard.
        if !ns and name == '*'
          ns = '*'
        end

        name_matches = name_matches?(xml_node, name)
        ns_matches   = false

        if ns
          ns_matches = namespace_matches?(xml_node, ns)

        elsif name_matches and !xml_node.namespace
          ns_matches = true
        end

        return name_matches && ns_matches
      end

      ##
      # @param [Oga::XML::Node] xml_node
      # @param [Oga::XPath::Node] ast_node
      # @return [TrueClass|FalseClass]
      #
      def type_matches?(xml_node, ast_node)
        context = XML::NodeSet.new([xml_node])

        return process(ast_node, context).length > 0
      end

      ##
      # Returns `true` if the name of the XML node matches the given name *or*
      # matches a wildcard.
      #
      # @param [Oga::XML::Node] xml_node
      # @param [String] name
      #
      def name_matches?(xml_node, name)
        return false unless xml_node.respond_to?(:name)

        return xml_node.name == name || name == '*'
      end

      ##
      # Returns `true` if the namespace of the XML node matches the given
      # namespace *or* matches a wildcard.
      #
      # @param [Oga::XML::Node] xml_node
      # @param [String] ns
      #
      def namespace_matches?(xml_node, ns)
        return false unless xml_node.respond_to?(:namespace)

        return xml_node.namespace.to_s == ns || ns == '*'
      end

      ##
      # @param [Oga::XML::Node] ast_node
      # @return [TrueClass|FalseClass]
      #
      def has_parent?(ast_node)
        return ast_node.respond_to?(:parent) && !!ast_node.parent
      end

      ##
      # Converts the given value to a float. If the value can't be converted to
      # a float NaN is returned instead.
      #
      # @param [Mixed] value
      # @return [Float]
      #
      def to_float(value)
        return Float(value) rescue Float::NAN
      end

      ##
      # Converts the given value to a string according to the XPath string
      # conversion rules.
      #
      # @param [Mixed] value
      # @return [String]
      #
      def to_string(value)
        # If we have a number that has a zero decimal (e.g. 10.0) we want to
        # get rid of that decimal. For this we'll first convert the number to
        # an integer.
        if value.is_a?(Float) and value.modulo(1).zero?
          value = value.to_i
        end

        return value.to_s
      end

      ##
      # Stores the node in the node stack, yields the block and removes the node
      # from the stack.
      #
      # This method is mainly intended to be used when processing predicates.
      # Expressions inside a predicate might need access to the node on which
      # the predicate is performed.
      #
      # This method's return value is the same as whatever the block returned.
      #
      # @example
      #  some_node_set.each do |node|
      #    result = with_node(node) { process(...) }
      #  end
      #
      # @param [Oga::XML::Node] node
      # @return [Mixed]
      #
      def with_node(node)
        @nodes << node

        retval = yield

        @nodes.pop

        return retval
      end

      ##
      # Returns the current node that's being processed.
      #
      # @return [Oga::XML::Node]
      #
      def current_node
        return @nodes.last
      end
    end # Evaluator
  end # XPath
end # Oga
