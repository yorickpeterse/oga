module Oga
  module XPath
    ##
    # The Evaluator class is used to evaluate an XPath expression in the
    # context of a given document.
    #
    class Evaluator
      ##
      # @param [Oga::XML::Document|Oga::XML::Node] document
      #
      def initialize(document)
        @document = document
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
            # TODO: pass the current node for functions such as position().
            retval      = process(predicate, nodes)

            # Non empty node set? Keep the current node
            if retval.is_a?(XML::NodeSet) and !retval.empty?
              new_nodes << current

            # In case of a number we'll use it as the index.
            elsif retval.is_a?(Numeric) && retval.to_i == xpath_index
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
        name, args = *ast_node

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
    end # Evaluator
  end # XPath
end # Oga
