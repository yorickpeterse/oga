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

            # Node sets, strings, etc
            elsif retval and !retval.empty?
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
          if node.is_a?(XML::Element) or node.is_a?(XML::Text)
            nodes << node
          end
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
        if expression
          node = process(expression, context)

          if node.is_a?(XML::NodeSet)
            node = node.first
          else
            raise TypeError, 'local-name() only takes node sets as arguments'
          end
        else
          node = current_node
        end

        return node.is_a?(XML::Element) ? node.name : ''
      end

      ##
      # Processes an `(int)` node. This method simply returns the value as a
      # Float.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Float]
      #
      def on_int(ast_node, context)
        return ast_node.children[0].to_f
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
