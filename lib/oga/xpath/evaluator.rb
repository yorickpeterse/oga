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
        nodes = XML::NodeSet.new

        context.each do |xml_node|
          nodes << xml_node if node_matches?(xml_node, ast_node)
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
      # Evaluates the `child` axis. This simply delegates work to {#on_test}.
      #
      # @param [Oga::XPath::Node] ast_node
      # @param [Oga::XML::NodeSet] context
      # @return [Oga::XML::NodeSet]
      #
      def on_axis_child(ast_node, context)
        return on_test(ast_node, child_nodes(context))
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
      # Checking if a node matches happens in two steps:
      #
      # 1. Match the name
      # 2. Match the namespace
      #
      # In both cases a star (`*`) can be used as a wildcard.
      #
      # @param [Oga::XML::Node] xml_node
      # @param [Oga::XPath::Node] ast_node
      # @return [Oga::XML::NodeSet]
      #
      def node_matches?(xml_node, ast_node)
        return false unless can_match_node?(xml_node)

        ns, name = *ast_node

        name_matches = xml_node.name == name || name == '*'
        ns_matches   = false

        if ns
          ns_matches = xml_node.namespace == ns || ns == '*'

        # If there's no namespace given but the name matches we'll also mark
        # the namespace as matching.
        #
        # THINK: stop automatically matching namespaces if left out?
        #
        elsif name_matches
          ns_matches = true
        end

        return name_matches && ns_matches
      end

      ##
      # Returns `true` if the given XML node can be compared using
      # {#node_matches?}.
      #
      # @param [Oga::XML::Node] ast_node
      #
      def can_match_node?(ast_node)
        return ast_node.respond_to?(:name) && ast_node.respond_to?(:namespace)
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
